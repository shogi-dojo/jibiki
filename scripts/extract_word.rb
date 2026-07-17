#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/dictionary_sources/jmdict'
require_relative '../lib/dictionary_sources/n5_queue'
require_relative '../lib/dictionary_sources/warodai'
require_relative 'source_cli'

options = {}
parser = SourceCLI.common_parser(options, banner: 'Usage: extract_word.rb [options]') do |cli|
  cli.on('--source-order NUMBER', Integer, 'Load written form and reading from the N5 queue') do |value|
    options[:source_order] = value
  end
  cli.on('--jmdict-id ENT_SEQ', 'Restrict JMdict to one ent_seq') { |value| options[:ent_seq] = value }
  cli.on('--warodai-id CARD_ID', 'Restrict Warodai to one card ID') { |value| options[:card_id] = value }
end
parser.parse!

SourceCLI.ensure_exists!(SourceCLI::JMDICT_PATH, SourceCLI::WARODAI_PATH)

queue_record = nil
if options[:source_order]
  SourceCLI.ensure_exists!(SourceCLI::N5_PATH)
  queue_record = DictionarySources::N5Queue.new(SourceCLI::N5_PATH).fetch(options[:source_order])
  options[:written] ||= queue_record.fetch(:written)
  options[:reading] ||= queue_record.fetch(:reading)
end

if [options[:written], options[:reading], options[:ent_seq], options[:card_id]].all?(&:nil?)
  warn parser
  abort 'Provide --source-order, --written, --reading, --jmdict-id, or --warodai-id.'
end

jmdict = DictionarySources::Jmdict.new(SourceCLI::JMDICT_PATH)
jmdict_matches = jmdict.lookup(
  written: options[:written],
  reading: options[:reading],
  ent_seq: options[:ent_seq]
)

if options[:written].nil? && options[:reading].nil? && jmdict_matches.length == 1
  options[:written] = jmdict_matches.first[:written_forms].first&.fetch(:text, nil)
  options[:reading] = jmdict_matches.first[:readings].first&.fetch(:text, nil)
end

warodai = DictionarySources::Warodai.new(SourceCLI::WARODAI_PATH)
warodai_matches = warodai.lookup(
  written: options[:written],
  reading: options[:reading],
  card_id: options[:card_id]
)

if options[:output].nil? && options[:source_order]
  options[:output] = format('tmp/source-extracts/n5-%06d.json', options[:source_order])
end

result = {
  query: options.slice(:source_order, :written, :reading, :ent_seq, :card_id),
  n5_candidate: queue_record,
  jmdict: {
    source_path: SourceCLI.relative_path(jmdict.path),
    source_sha256: jmdict.archive_sha256,
    match_count: jmdict_matches.length,
    matches: jmdict_matches
  },
  warodai: {
    source_path: SourceCLI.relative_path(warodai.root),
    usage: 'Private read-only comparison; do not copy, translate, or publish Warodai text.',
    match_count: warodai_matches.length,
    matches: warodai_matches
  }
}

SourceCLI.write_json(result, options[:output])

if options[:source_order] && jmdict_matches.length != 1
  abort "N5 source_order #{options[:source_order]} resolved to #{jmdict_matches.length} JMdict entries; inspect the dossier and reconcile explicitly."
end
