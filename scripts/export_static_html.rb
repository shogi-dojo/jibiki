#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative '../lib/dictionary_sources/warodai'
require_relative '../lib/exporters/static_html'
require_relative '../lib/org_entry'

REPO_ROOT = File.expand_path('..', __dir__)

options = {
  output: File.join(REPO_ROOT, 'build', 'dictionary.html'),
  warodai: ENV.fetch('WARODAI_PATH', File.join(REPO_ROOT, 'sources', 'warodai'))
}

OptionParser.new do |parser|
  parser.banner = 'Usage: export_static_html.rb [options]'
  parser.on('-o', '--output PATH', 'Output HTML path') { |value| options[:output] = File.expand_path(value, REPO_ROOT) }
  parser.on('--warodai PATH', 'Warodai source directory') { |value| options[:warodai] = File.expand_path(value, REPO_ROOT) }
  parser.on('-h', '--help', 'Show this help') do
    puts parser
    exit
  end
end.parse!

abort "Missing local Warodai source: #{options[:warodai]}" unless File.directory?(options[:warodai])

paths = Dir[File.join(REPO_ROOT, 'entries', '*', '*.org')].sort
entries = []
errors = []
paths.each do |path|
  entries << OrgEntry.load(path)
rescue StandardError => e
  errors << "#{path.delete_prefix("#{REPO_ROOT}/")}: #{e.message}"
end

unless errors.empty?
  warn "Static HTML export aborted: #{errors.length} entry file(s) could not be loaded:"
  errors.each { |error| warn "- #{error}" }
  exit 1
end

abort 'Static HTML export aborted: no Org entries found.' if entries.empty?

output = File.expand_path(options[:output], REPO_ROOT)
warodai = DictionarySources::Warodai.new(options[:warodai])
Exporters::StaticHtml.export(entries, output, warodai:)
puts "Exported #{entries.length} entries to #{output.delete_prefix("#{REPO_ROOT}/")}"
