# frozen_string_literal: true

require 'json'
require 'minitest/autorun'
require 'rbconfig'
require_relative '../lib/acp_client'

class AcpClientTest < Minitest::Test
  FAKE = [RbConfig.ruby, File.expand_path('fixtures/fake_acp_agent.rb', __dir__)].freeze

  def client(provider: 'codex', mode: 'none', **opts)
    env = { 'FAKE_PROMPT_MODE' => mode }.merge(opts.delete(:env) || {})
    AcpClient.new(provider:, command: FAKE, env:, timeout: 20, **opts)
  end

  def report(result) = JSON.parse(result.text)

  def test_override_mode_sends_rules_as_system_prompt
    result = client(provider: 'claude', mode: 'override', model: 'big').prompt(system: 'RULES', user: 'WORDS')
    seen = report(result)

    assert_equal({ 'mode' => 'override', 'content' => [{ 'type' => 'text', 'text' => 'RULES' }] }, seen['system_prompt'])
    assert_equal 'WORDS', seen['prompt']
    assert_equal({ 'claudeCode' => { 'options' => { 'tools' => [], 'settingSources' => [] } } }, seen['meta'])
    assert_equal 'big (option)', seen['model']
    assert_equal 'big', result.model
  end

  def test_reply_usage_and_refused_permission
    result = client.prompt(system: nil, user: 'hi')

    assert_equal 'end_turn', result.stop_reason
    assert_equal({ 'inputTokens' => 100, 'outputTokens' => 20 }, result.usage)
    assert_equal({ 'used' => 120, 'size' => 1000 }, result.usage_update)
    assert_equal 1, result.tool_calls
    assert_equal({ 'outcome' => { 'outcome' => 'selected', 'optionId' => 'no' } }, report(result)['permission'])
  end

  def test_append_only_adapter_and_effort_suffixed_model
    seen = report(client(mode: 'append', model: 'big[high]', effort: 'low').prompt(system: 'RULES', user: 'WORDS'))

    assert_equal 'append', seen.dig('system_prompt', 'mode')
    assert_equal 'big[high] (set_model)', seen['model']
    assert_equal 'low (option)', seen['effort']
  end

  def test_rules_are_prepended_without_system_prompt_support
    seen = report(client.prompt(system: 'RULES', user: 'WORDS'))

    assert_nil seen['system_prompt']
    assert_equal "RULES\n\nWORDS", seen['prompt']
  end

  def test_host_session_env_is_scrubbed_and_home_is_set
    ENV['CLAUDE_TEST_LEAK'] = '1'
    seen = report(client(home: '/tmp/codex-acct').prompt(system: nil, user: 'x'))

    assert_empty seen['host_env']
    assert_equal '/tmp/codex-acct', seen['account']
  ensure
    ENV.delete('CLAUDE_TEST_LEAK')
  end

  def test_agent_exit_raises
    err = assert_raises(AcpClient::Error) do
      client(env: { 'FAKE_EXIT_ON_PROMPT' => '1' }).prompt(system: nil, user: 'x')
    end
    assert_match(/agent exited/, err.message)
  end

  def test_describe_returns_session_info
    info = client.describe

    assert_equal 'base', info.dig('models', 'currentModelId')
  end
end
