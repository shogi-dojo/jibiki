#!/usr/bin/env ruby
# frozen_string_literal: true

# Export jibiki Ukrainian glosses as a Houhou-SRS DictionaryTranslations overlay.
#
# Usage:
#   bundle exec ruby scripts/export_houhou_overlay.rb \
#     --base /path/to/KanjiDatabase.sqlite \
#     [--base-overlay /path/to/existing/DictionaryTranslations.sqlite] \
#     [--output build/DictionaryTranslations.sqlite] \
#     [--entries entries/]

require "optparse"
require_relative "../lib/org_entry"
require_relative "../lib/exporters/houhou_overlay"

options = {
  output:           "build/DictionaryTranslations.sqlite",
  entries_dir:      File.expand_path("../entries", __dir__),
  base_db:          nil,
  base_overlay:     nil
}

OptionParser.new do |opts|
  opts.banner = "Usage: export_houhou_overlay.rb [options]"

  opts.on("--base PATH", "Path to KanjiDatabase.sqlite (required)") do |v|
    options[:base_db] = v
  end

  opts.on("--base-overlay PATH", "Donor overlay to merge ru rows from") do |v|
    options[:base_overlay] = v
  end

  opts.on("--output PATH", "Output path (default: #{options[:output]})") do |v|
    options[:output] = v
  end

  opts.on("--entries DIR", "Entries directory (default: entries/)") do |v|
    options[:entries_dir] = v
  end

  opts.on("-h", "--help", "Show help") do
    puts opts
    exit
  end
end.parse!

abort "ERROR: --base PATH is required" unless options[:base_db]
abort "ERROR: #{options[:base_db]} not found" unless File.exist?(options[:base_db])
if options[:base_overlay]
  abort "ERROR: #{options[:base_overlay]} not found" unless File.exist?(options[:base_overlay])
end

$stderr.puts "Loading entries from #{options[:entries_dir]}…"
org_files = Dir.glob(File.join(options[:entries_dir], "**", "*.org")).sort
abort "No .org files found under #{options[:entries_dir]}" if org_files.empty?

entries = org_files.map { |f| OrgEntry.load(f) }
$stderr.puts "Loaded #{entries.size} entries."

$stderr.puts "Exporting overlay to #{options[:output]}…"
stats = Exporters::HouhouOverlay.export(
  entries,
  options[:output],
  base_db_path:     options[:base_db],
  base_overlay_path: options[:base_overlay]
)

$stderr.puts <<~DONE
  Done.
    Matched entries : #{stats[:matched]}
    Unmatched       : #{stats[:unmatched]}
    Meanings        : #{stats[:meanings]}
    FTS rows        : #{stats[:fts_rows]}
DONE
