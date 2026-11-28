# frozen_string_literal: true

# A scripted ACP agent for AcpClient tests. It speaks newline-delimited
# JSON-RPC on stdio and answers a prompt with a JSON report of what it saw
# (system prompt, chosen model, prompt text, permission outcome, env), after
# asking for a permission and announcing a tool call.
#
# FAKE_PROMPT_MODE: override | append | none (sessionCapabilities.systemPrompt)
# FAKE_EXIT_ON_PROMPT: exit without answering session/prompt

require 'json'

$stdout.sync = true
state = { model: 'base', effort: 'medium' }
@pending_permission = nil

def send_message(message) = $stdout.puts(message.to_json)

def update(body) = send_message({ jsonrpc: '2.0', method: 'session/update', params: { sessionId: 's1', update: body } })

def capability
  case ENV.fetch('FAKE_PROMPT_MODE', 'none')
  when 'override' then { mode: { override: {} } }
  when 'append' then {}
  end
end

$stdin.each_line do |line|
  message = JSON.parse(line)
  if message['method'].nil? && message['id'] == 'perm-1'
    state[:permission] = message['result']
    update({ sessionUpdate: 'tool_call', toolCallId: 't1', title: 'ls', status: 'pending' })
    report = state.merge(host_env: ENV.keys.grep(/\ACLAUDE/), account: ENV['CODEX_HOME'])
    text = report.to_json
    update({ sessionUpdate: 'agent_message_chunk', content: { type: 'text', text: text[0, 10] } })
    update({ sessionUpdate: 'agent_message_chunk', content: { type: 'text', text: text[10..] } })
    update({ sessionUpdate: 'usage_update', used: 120, size: 1000 })
    send_message({ jsonrpc: '2.0', id: @pending_prompt,
                   result: { stopReason: 'end_turn', usage: { inputTokens: 100, outputTokens: 20 } } })
    next
  end

  id = message['id']
  params = message['params'] || {}
  result =
    case message['method']
    when 'initialize'
      caps = { sessionCapabilities: capability ? { systemPrompt: capability } : {} }
      { protocolVersion: 1, agentCapabilities: caps, authMethods: [] }
    when 'session/new'
      state[:system_prompt] = params['systemPrompt']
      state[:meta] = params['_meta']
      {
        sessionId: 's1',
        models: { currentModelId: 'base', availableModels: [{ modelId: 'base' }, { modelId: 'big[high]' }] },
        configOptions: [
          { id: 'model', category: 'model', currentValue: 'base', options: [{ value: 'base' }, { value: 'big' }] },
          { id: 'effort', category: 'thought_level', currentValue: 'medium', options: [{ value: 'low' }] }
        ]
      }
    when 'session/set_config_option'
      state[params['configId'] == 'model' ? :model : :effort] = "#{params['value']} (option)"
      {}
    when 'session/set_model'
      state[:model] = "#{params['modelId']} (set_model)"
      {}
    when 'session/prompt'
      exit 3 if ENV['FAKE_EXIT_ON_PROMPT']

      state[:prompt] = params['prompt'].map { |b| b['text'] }.join
      @pending_prompt = id
      send_message({ jsonrpc: '2.0', id: 'perm-1', method: 'session/request_permission',
                     params: { sessionId: 's1', options: [{ optionId: 'ok', kind: 'allow_once' },
                                                          { optionId: 'no', kind: 'reject_once' }] } })
      next
    else
      send_message({ jsonrpc: '2.0', id:, error: { code: -32_601, message: 'unknown' } })
      next
    end
  send_message({ jsonrpc: '2.0', id:, result: })
end
