#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative '../lib/org_entry'
require_relative '../lib/exporters/rich_sqlite'

options = {
  output: 'build/jibiki.sqlite',
  base: nil
}

OptionParser.new do |opts|
  opts.banner = 'Usage: export_rich_db.rb [options]'

  opts.on('-o', '--output PATH', 'Path to output SQLite database') do |o|
    options[:output] = o
  end

  opts.on('-b', '--base PATH', 'Path to base Houhou-SRS database for mapping (optional)') do |b|
    options[:base] = b
  end

  opts.on('-h', '--help', 'Prints this help') do
    puts opts
    exit
  end
end.parse!

puts "Loading Org entries..."
paths = Dir[File.expand_path('../entries/*/*.org', __dir__)].sort
entries = paths.map do |path|
  OrgEntry.load(path)
end

puts "Exporting #{entries.length} entries to #{options[:output]}..."
Exporters::RichSqlite.export(entries, options[:output], vocab_mapping_base: options[:base])
puts "Export completed successfully!"
