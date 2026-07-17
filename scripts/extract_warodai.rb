#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/dictionary_sources/warodai'
require_relative 'source_cli'

options = {}
parser = SourceCLI.common_parser(options, banner: 'Usage: extract_warodai.rb [options]') do |cli|
  cli.on('--id CARD_ID', 'Exact Warodai card ID') { |value| options[:card_id] = value }
end
parser.parse!

if [options[:written], options[:reading], options[:card_id]].all?(&:nil?)
  warn parser
  abort 'Provide --written, --reading, or --id.'
end

SourceCLI.ensure_exists!(SourceCLI::WARODAI_PATH)
source = DictionarySources::Warodai.new(SourceCLI::WARODAI_PATH)
matches = source.lookup(written: options[:written], reading: options[:reading], card_id: options[:card_id])

SourceCLI.write_json(
  {
    query: options.slice(:written, :reading, :card_id),
    source: {
      path: SourceCLI.relative_path(source.root),
      usage: 'Private read-only comparison; do not copy, translate, or publish Warodai text.'
    },
    match_count: matches.length,
    matches:
  },
  options[:output]
)
