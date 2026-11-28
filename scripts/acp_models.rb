#!/usr/bin/env ruby
# frozen_string_literal: true

# Lists the models and config options an ACP adapter offers, without sending
# a prompt (no usage is spent):
#
#   ruby scripts/acp_models.rb claude codex gemini
#   ruby scripts/acp_models.rb --home ~/.codex-multi-2 codex

require 'optparse'
require_relative '../lib/acp_client'

options = {}
OptionParser.new do |cli|
  cli.banner = 'Usage: acp_models.rb [--home DIR] [--log] PROVIDER...'
  cli.on('--home DIR', 'Account config dir (CLAUDE_CONFIG_DIR / CODEX_HOME / GEMINI_CLI_HOME)') { |v| options[:home] = v }
  cli.on('--log', 'Print the JSON-RPC traffic to stderr') { options[:log] = $stderr }
end.parse!
providers = ARGV.empty? ? AcpClient::PROFILES.keys : ARGV

providers.each do |provider|
  info = AcpClient.new(provider:, home: options[:home], log: options[:log], timeout: 120).describe
  puts "== #{provider}"
  models = info['models']
  if models
    puts "models (current #{models['currentModelId']}):"
    Array(models['availableModels']).each { |m| puts "  #{m['modelId']}  #{m['name']}" }
  end
  Array(info['configOptions']).each do |opt|
    values = Array(opt['options']).map { |o| o['value'] || o['id'] }
    puts "option #{opt['id']} [#{opt['category']}] = #{opt['currentValue']}  (#{values.join(', ')})"
  end
rescue AcpClient::Error => e
  puts "== #{provider}: #{e.message}"
end
