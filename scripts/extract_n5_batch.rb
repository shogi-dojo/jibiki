#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

require_relative '../lib/dictionary_sources/jmdict'
require_relative '../lib/dictionary_sources/n5_queue'
require_relative '../lib/dictionary_sources/warodai'
require_relative 'source_cli'

options = {}
parser = OptionParser.new do |cli|
  cli.banner = 'Usage: extract_n5_batch.rb --from N --to M'
  cli.on('--from NUMBER', Integer, 'First N5 source_order (inclusive)') { |value| options[:from] = value }
  cli.on('--to NUMBER', Integer, 'Last N5 source_order (inclusive)') { |value| options[:to] = value }
end
parser.parse!

unless options[:from] && options[:to] && options[:from] <= options[:to]
  warn parser
  abort 'Provide --from and --to with from <= to.'
end

SourceCLI.ensure_exists!(SourceCLI::JMDICT_PATH, SourceCLI::WARODAI_PATH, SourceCLI::N5_PATH)

queue = DictionarySources::N5Queue.new(SourceCLI::N5_PATH)
orders = (options[:from]..options[:to]).to_a
queue_records = orders.map { |order| queue.fetch(order) }
queries = queue_records.map { |record| { written: record.fetch(:written), reading: record.fetch(:reading) } }

jmdict = DictionarySources::Jmdict.new(SourceCLI::JMDICT_PATH)
jmdict_sha256 = jmdict.archive_sha256
jmdict_results = jmdict.lookup_many(queries)

warodai = DictionarySources::Warodai.new(SourceCLI::WARODAI_PATH)
warodai_results = warodai.lookup_many(queries)

unresolved = []
orders.each_with_index do |order, i|
  record = queue_records[i]
  jmdict_matches = jmdict_results[i]
  warodai_matches = warodai_results[i]

  result = {
    query: { source_order: order, written: record.fetch(:written), reading: record.fetch(:reading) },
    n5_candidate: record,
    jmdict: {
      source_path: SourceCLI.relative_path(jmdict.path),
      source_sha256: jmdict_sha256,
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

  SourceCLI.write_json(result, format('tmp/source-extracts/n5-%06d.json', order))
  unresolved << [order, jmdict_matches.length] unless jmdict_matches.length == 1
end

unresolved.each do |order, count|
  warn "N5 source_order #{order} resolved to #{count} JMdict entries; inspect the dossier and reconcile explicitly."
end
