# frozen_string_literal: true

require 'json'
require 'open3'
require 'timeout'
require 'tmpdir'

# A minimal Agent Client Protocol client: spawns an ACP adapter (Claude,
# Codex, Gemini), opens one session in an empty scratch directory, sends one
# prompt and returns the reply text with whatever usage the adapter reports.
# The agent gets no file system and every permission request is refused, so
# a turn can only answer in text.
class AcpClient
  class Error < StandardError; end

  Result = Struct.new(:text, :stop_reason, :usage, :usage_update, :tool_calls, :seconds, :model,
                      keyword_init: true)

  # command: argv; home_env: the variable that selects an account's config
  # dir; auth: the authenticate methodId sent after initialize, if any.
  # Gemini models are reached through Antigravity's ACP server: gemini-cli's
  # own login no longer serves individual accounts.
  PROFILES = {
    'claude' => { command: %w[claude-agent-acp], home_env: 'CLAUDE_CONFIG_DIR' },
    'codex' => { command: %w[codex-acp], home_env: 'CODEX_HOME' },
    'antigravity' => {
      command: [File.expand_path(ENV.fetch('AGY_ACP_SERVER', '~/.local/share/agy-acp-server/agy_acp_server.par'))],
      home_env: 'GEMINI_CLI_HOME', auth: 'oauth-personal'
    },
    'gemini' => { command: %w[gemini --acp], home_env: 'GEMINI_CLI_HOME', auth: 'oauth-personal' }
  }.freeze

  attr_reader :session_info

  def initialize(provider:, model: nil, effort: nil, home: nil, command: nil, env: {}, timeout: 1200,
                 log: nil)
    profile = PROFILES.fetch(provider) { raise Error, "unknown provider #{provider}" }
    @provider = provider
    @command = command || profile[:command]
    @auth = profile[:auth]
    @env = env.dup
    @env[profile[:home_env]] = File.expand_path(home) if home
    @model = model
    @effort = effort
    @timeout = timeout
    @log = log
    @next_id = 0
  end

  # The session/new answer (models, configOptions) without sending a prompt.
  def describe
    with_session(system: nil) { |_| @session_info }
  end

  def prompt(system:, user:)
    with_session(system:) do |session_id|
      @chunks = +''
      @usage_update = nil
      @tool_calls = 0
      text = system && !@system_applied ? "#{system}\n\n#{user}" : user
      started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      result = request('session/prompt', { sessionId: session_id, prompt: [{ type: 'text', text: }] })
      Result.new(
        text: @chunks, stop_reason: result['stopReason'], usage: result['usage'], usage_update: @usage_update,
        tool_calls: @tool_calls, seconds: (Process.clock_gettime(Process::CLOCK_MONOTONIC) - started).round(1),
        model: @current_model
      )
    end
  end

  private

  def with_session(system:)
    Dir.mktmpdir('acp-author') do |cwd|
      spawn_agent(cwd, system)
      begin
        init = request('initialize', {
                         protocolVersion: 1,
                         clientInfo: { name: 'jibiki-author', version: '1' },
                         clientCapabilities: { fs: { readTextFile: false, writeTextFile: false }, terminal: false }
                       })
        request('authenticate', { methodId: @auth }) if @auth && advertised_auth?(init)
        session_id = open_session(cwd, system, init)
        yield session_id
      ensure
        shutdown
      end
    end
  end

  def spawn_agent(cwd, system)
    env = @env.dup
    if system && @provider == 'gemini'
      # Gemini CLI replaces its whole system prompt with this file.
      path = File.join(cwd, '.system.md')
      File.write(path, system)
      env['GEMINI_SYSTEM_MD'] = path
      @system_applied = true
    end
    @stdin, @stdout, @stderr, @wait = Open3.popen3(clean_env.merge(env), *@command, chdir: cwd)
    @stderr_tail = +''
    @stderr_thread = Thread.new do
      @stderr.each_line { |line| @stderr_tail = (@stderr_tail + line)[-4000..] || (@stderr_tail + line) }
    rescue IOError
      nil
    end
  end

  # A host agent (e.g. Claude Code running this script) exports its own
  # session and auth variables; an adapter that inherits them talks to the
  # host's endpoint instead of the account it should use. Unset them all.
  HOST_ENV = /\A(CLAUDE|ANTHROPIC)/

  def clean_env
    ENV.keys.grep(HOST_ENV).to_h { |key| [key, nil] }
  end

  def open_session(cwd, system, init)
    params = { cwd:, mcpServers: [] }
    supports_prompt = init.dig('agentCapabilities', 'sessionCapabilities', 'systemPrompt')
    if system && supports_prompt && !@system_applied
      # Override drops the harness prompt; adapters that only append keep it.
      mode = supports_prompt.dig('mode', 'override') ? 'override' : 'append'
      params[:systemPrompt] = { mode:, content: [{ type: 'text', text: system }] }
      @system_applied = true
    end
    if @provider == 'claude'
      # No tools, no user/project settings, CLAUDE.md or skills in the context.
      params[:_meta] = { claudeCode: { options: { tools: [], settingSources: [] } } }
    end

    @session_info = request('session/new', params)
    session_id = @session_info.fetch('sessionId')
    @current_model = @session_info.dig('models', 'currentModelId') ||
                     model_option(@session_info)&.fetch('currentValue', nil)
    choose(session_id, 'model', @model) if @model
    choose(session_id, 'thought_level', @effort) if @effort
    session_id
  end

  def advertised_auth?(init)
    Array(init['authMethods']).any? { |m| m['id'] == @auth }
  end

  def model_option(info)
    Array(info['configOptions']).find { |o| o['category'] == 'model' }
  end

  # Sets a config option by category. A model id the option does not list
  # (Codex's effort-suffixed ids such as gpt-6-luna[high]) goes through
  # session/set_model instead.
  def choose(session_id, category, value)
    option = Array(@session_info['configOptions']).find { |o| o['category'] == category }
    values = Array(option&.fetch('options', nil)).map { |o| o['value'] }
    if option && values.include?(value)
      request('session/set_config_option', { sessionId: session_id, configId: option['id'], value: })
    elsif category == 'model'
      request('session/set_model', { sessionId: session_id, modelId: value })
    else
      raise Error, "#{@provider} has no #{category} option"
    end
    @current_model = value if category == 'model'
  end

  def request(method, params)
    id = (@next_id += 1)
    write({ jsonrpc: '2.0', id:, method:, params: })
    Timeout.timeout(@timeout, Error, "#{method} timed out after #{@timeout}s") do
      loop do
        message = read_message
        next handle_incoming(message) if message['method']
        next unless message['id'] == id
        raise Error, "#{method} failed: #{message['error'].to_json}" if message['error']

        return message['result'] || {}
      end
    end
  end

  def handle_incoming(message)
    case message['method']
    when 'session/update' then on_update(message.dig('params', 'update') || {})
    when 'session/request_permission' then refuse_permission(message)
    else
      return unless message.key?('id')

      write({ jsonrpc: '2.0', id: message['id'], error: { code: -32_601, message: 'not supported' } })
    end
  end

  def on_update(update)
    case update['sessionUpdate']
    when 'agent_message_chunk' then @chunks << update.dig('content', 'text').to_s if @chunks
    when 'usage_update' then @usage_update = update.except('sessionUpdate')
    when 'tool_call' then @tool_calls += 1 if @tool_calls
    end
  end

  def refuse_permission(message)
    options = Array(message.dig('params', 'options'))
    reject = options.find { |o| o['kind'].to_s.start_with?('reject') }
    outcome = reject ? { outcome: 'selected', optionId: reject['optionId'] } : { outcome: 'cancelled' }
    write({ jsonrpc: '2.0', id: message['id'], result: { outcome: } })
  end

  def write(message)
    @log&.puts("> #{message.to_json}")
    @stdin.write("#{message.to_json}\n")
    @stdin.flush
  rescue Errno::EPIPE
    raise Error, "agent exited: #{@stderr_tail}"
  end

  def read_message
    loop do
      line = @stdout.gets
      raise Error, "agent exited: #{@stderr_tail.strip}" if line.nil?

      line = line.force_encoding('UTF-8').strip
      next if line.empty?

      @log&.puts("< #{line}")
      begin
        return JSON.parse(line)
      rescue JSON::ParserError
        next
      end
    end
  end

  def shutdown
    @stdin&.close unless @stdin&.closed?
    return unless @wait

    begin
      Timeout.timeout(3) { @wait.value }
    rescue Timeout::Error
      Process.kill('TERM', @wait.pid)
      @wait.value
    end
    @stderr_thread&.join(1)
  rescue Errno::ESRCH
    nil
  ensure
    @system_applied = false
  end
end
