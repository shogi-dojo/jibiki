#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/dictionary_sources/jmdict'
require_relative 'source_cli'

options = {}
parser = SourceCLI.common_parser(options, banner: 'Usage: extract_jmdict.rb [options]') do |cli|
  cli.on('--id ENT_SEQ', 'Exact JMdict ent_seq') { |value| options[:ent_seq] = value }
end
parser.parse!

if [options[:written], options[:reading], options[:ent_seq]].all?(&:nil?)
  warn parser
  abort 'Provide --written, --reading, or --id.'
end

SourceCLI.ensure_exists!(SourceCLI::JMDICT_PATH)
source = DictionarySources::Jmdict.new(SourceCLI::JMDICT_PATH)
matches = source.lookup(written: options[:written], reading: options[:reading], ent_seq: options[:ent_seq])

SourceCLI.write_json(
  {
    query: options.slice(:written, :reading, :ent_seq),
    source: {
      path: SourceCLI.relative_path(source.path),
      sha256: source.archive_sha256
    },
    match_count: matches.length,
    matches:
  },
  options[:output]
)
