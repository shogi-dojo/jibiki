#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'
require 'json'
require 'optparse'
require_relative '../lib/bccwj_batch'
require_relative 'source_cli'

options = {
  batch_size: 10,
  jmdict: BccwjBatch::DEFAULT_JMDICT_PATH,
  date: Date.today.iso8601
}

parser = OptionParser.new do |cli|
  cli.banner = 'Usage: render_batch.rb --sources FILE --batch N --payload FILE [options]'
  cli.on('--sources FILE', 'Candidate queue JSON array produced by select_bccwj.rb') { |v| options[:sources] = v }
  cli.on('--batch N', String, '1-based batch number to render') { |v| options[:batch] = Integer(v, 10) }
  cli.on('--batch-size N', String, 'Entries per batch (default: 10)') { |v| options[:batch_size] = Integer(v, 10) }
  cli.on('--payload FILE', 'Authored batch payload JSON mapping "1".."N" to glosses/examples') { |v| options[:payload] = v }
  cli.on('--sha256 HASH', 'JMdict archive SHA-256 hex digest') { |v| options[:sha256] = v }
  cli.on('--sha256-file FILE', 'File containing JMdict archive SHA-256 hex digest') { |v| options[:sha256_file] = v }
  cli.on('--jmdict PATH', "JMdict archive for SHA-256 fallback (default: #{options[:jmdict]})") { |v| options[:jmdict] = v }
  cli.on('--date YYYY-MM-DD', "CREATED_AT header value (default: #{options[:date]})") { |v| options[:date] = v }
end
parser.parse!

unless options[:sources] && options[:batch] && options[:payload]
  warn parser
  abort 'Provide --sources, --batch, and --payload.'
end

SourceCLI.ensure_exists!(options[:sources], options[:payload])
sha256 = options[:sha256]
if sha256.nil? && options[:sha256_file]
  SourceCLI.ensure_exists!(options[:sha256_file])
  sha256 = File.read(options[:sha256_file], encoding: 'UTF-8').strip
end
SourceCLI.ensure_exists!(options[:jmdict]) if sha256.nil?

sources = JSON.parse(File.read(options[:sources], encoding: 'UTF-8'))
payload = JSON.parse(File.read(options[:payload], encoding: 'UTF-8'))

renderer = BccwjBatch::Renderer.new(
  sources:,
  sha256:,
  jmdict_path: options[:jmdict],
  created_at: options[:date],
  batch_size: options[:batch_size]
)

rendered = renderer.render_batch(batch_num: options[:batch], payload:)
rendered.each { |path| puts "Rendered #{path}" }
