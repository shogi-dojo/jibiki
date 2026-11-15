#!/usr/bin/env ruby
# frozen_string_literal: true

require 'digest'
require 'json'
require 'optparse'
require 'sqlite3'
require_relative '../lib/bccwj_batch'
require_relative 'source_cli'

options = {
  bccwj: BccwjBatch::DEFAULT_BCCWJ_PATH,
  zip_entry: BccwjBatch::DEFAULT_BCCWJ_ENTRY,
  jmdict_cache: BccwjBatch::DEFAULT_JMDICT_CACHE,
  warodai_cache: BccwjBatch::DEFAULT_WARODAI_CACHE,
  entries_dir: 'entries',
  min_rank: 1,
  limit: 500,
  batch_size: 10,
  exclude: []
}

parser = OptionParser.new do |cli|
  cli.banner = 'Usage: select_bccwj.rb --output PATH [options]'
  cli.on('--bccwj PATH', "BCCWJ frequency TSV or zip (default: #{options[:bccwj]})") { |v| options[:bccwj] = v }
  cli.on('--zip-entry NAME', "TSV entry inside zip (default: #{options[:zip_entry]})") { |v| options[:zip_entry] = v }
  cli.on('--source-url URL', 'Override source_url recorded in candidate rows') { |v| options[:source_url] = v }
  cli.on('--jmdict-cache PATH', "JMdict SQLite cache (default: #{options[:jmdict_cache]})") { |v| options[:jmdict_cache] = v }
  cli.on('--warodai-cache PATH', "Warodai SQLite cache (default: #{options[:warodai_cache]})") { |v| options[:warodai_cache] = v }
  cli.on('--entries-dir DIR', "Entries root to skip existing IDs (default: #{options[:entries_dir]})") { |v| options[:entries_dir] = v }
  cli.on('--min-rank N', Integer, 'Minimum BCCWJ rank (inclusive, default: 1)') { |v| options[:min_rank] = v }
  cli.on('--limit N', Integer, 'Maximum candidates to select (default: 500)') { |v| options[:limit] = v }
  cli.on('--batch-size N', Integer, 'Entries per dossier batch (default: 10)') { |v| options[:batch_size] = v }
  cli.on('--exclude WORDS', 'Comma-separated lemmas to skip') { |v| options[:exclude].concat(v.split(',')) }
  cli.on('--exclude-file PATH', 'File of lemmas to skip (one per line)') do |v|
    SourceCLI.ensure_exists!(v)
    options[:exclude].concat(File.readlines(v, encoding: 'UTF-8').map(&:strip).reject { |l| l.empty? || l.start_with?('#') })
  end
  cli.on('--output PATH', 'Write selected candidate JSON array to PATH') { |v| options[:output] = v }
  cli.on('--dossier-dir DIR', 'Optional directory to write batch dossier-NN.txt files') { |v| options[:dossier_dir] = v }
end
parser.parse!

unless options[:output]
  warn parser
  abort 'Provide --output PATH.'
end

SourceCLI.ensure_exists!(options[:bccwj], options[:jmdict_cache], options[:warodai_cache])

source_url = options[:source_url] ||
             if File.extname(options[:bccwj]) == '.zip'
               File.join(File.dirname(options[:bccwj]), options[:zip_entry])
             else
               options[:bccwj]
             end
source_sha256 = Digest::SHA256.file(options[:bccwj]).hexdigest

jmdict_db = SQLite3::Database.new(options[:jmdict_cache], readonly: true)
warodai_db = SQLite3::Database.new(options[:warodai_cache], readonly: true)

begin
  selector = BccwjBatch::Selector.new(
    jmdict_db:,
    warodai_db:,
    entries_dir: options[:entries_dir],
    min_rank: options[:min_rank],
    limit: options[:limit],
    excluded_words: options[:exclude]
  )

  candidates = BccwjBatch.open_bccwj_io(options[:bccwj], zip_entry: options[:zip_entry]) do |io|
    selector.select(io:, source_url:, source_sha256:)
  end
ensure
  jmdict_db.close
  warodai_db.close
end

SourceCLI.write_json(candidates, options[:output])

if options[:dossier_dir]
  BccwjBatch::DossierFormatter.write_batches(candidates, dir: options[:dossier_dir], batch_size: options[:batch_size])
end

if candidates.empty?
  warn 'Selected 0 candidates.'
else
  puts "Selected #{candidates.size} candidates (ranks #{candidates.first['source_order']}..#{candidates.last['source_order']})"
end
