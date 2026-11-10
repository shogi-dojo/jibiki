#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'json'
require_relative '../lib/entry_doctor/runner'
require_relative '../lib/dictionary_sources/jmdict'

REPO_ROOT = File.expand_path('..', __dir__)
JMDICT_PATH = ENV.fetch(
  'JMDICT_PATH',
  File.join(REPO_ROOT, 'sources', 'jmdict', 'JMdict.xml.gz')
)

options = {
  json: false,
  report: nil,
  with_jmdict: false
}

parser = OptionParser.new do |opts|
  opts.banner = 'Usage: scripts/doctor.rb [options] [path ...]'

  opts.on('-j', '--json', 'Output report in JSON format') do
    options[:json] = true
  end

  opts.on('-r', '--report PATH', 'Generate HTML report to the specified file') do |path|
    options[:report] = path
  end

  opts.on('--with-jmdict', 'Cross-check against JMdict archive for Russian references') do
    options[:with_jmdict] = true
  end

  opts.on('-h', '--help', 'Show this help message') do
    puts opts
    exit 0
  end
end

parser.parse!(ARGV)

paths = ARGV.empty? ? Dir[File.join(REPO_ROOT, 'entries', '*', '*.org')].sort : ARGV.map { |p| File.expand_path(p) }
paths = paths.select { |p| File.exist?(p) }

if paths.empty?
  warn 'No valid entry files found to analyze.'
  exit 1
end

jmdict_entries = {}
if options[:with_jmdict] && File.exist?(JMDICT_PATH)
  ent_seqs = paths.filter_map do |path|
    File.binread(path).force_encoding('UTF-8')[/^#\+JMDICT_ID: (.*)$/, 1]
  end.uniq
  index = DictionarySources::JmdictIndex.open(JMDICT_PATH)
  if index
    ent_seqs.each { |seq| jmdict_entries[seq] = index.entry(seq) }
  else
    jmdict = DictionarySources::Jmdict.new(JMDICT_PATH)
    queries = ent_seqs.map { |seq| { ent_seq: seq } }
    jmdict.lookup_many(queries).each_with_index do |matches, index_in_batch|
      jmdict_entries[ent_seqs[index_in_batch]] = matches.first
    end
  end
end

reports = EntryDoctor::Runner.analyze(paths, jmdict_entries)

if options[:report]
  require_relative 'doctor_report'
  DoctorReport.generate(reports, options[:report])
  puts "Generated HTML doctor report at #{options[:report]}"
end

exit EntryDoctor::Runner.emit(reports, io: $stdout, json: options[:json])
