# frozen_string_literal: true

require 'csv'
require 'json'

source_path, output_path = ARGV
abort 'usage: ruby normalize.rb SOURCE.json OUTPUT.tsv' unless source_path && output_path

document = JSON.parse(File.read(source_path, encoding: 'UTF-8'))
page = document.dig('query', 'pages').is_a?(Hash) ? document.dig('query', 'pages').values.first : document.dig('query', 'pages', 0)
revision = page.dig('revisions', 0)
wikitext = revision.dig('slots', 'main', '*') || revision.dig('slots', 'main', 'content')

def link_text(value)
  text = value.strip
  return '' if text.empty?

  if (match = text.match(/\A\{\{l\|ja\|([^}|]+).*\}\}\z/))
    match[1]
  elsif (match = text.match(/\A\[\[(?:[^\]|]+\|)?([^\]]+)\]\]\z/))
    match[1]
  else
    text
  end
end

rows = wikitext.lines.filter_map.with_index(1) do |line, source_line|
  next unless line.start_with?('|') && line.include?('||')

  written, reading, meaning, frequency = line.delete_prefix('|').split(/\s*\|\|\s*/, 4)
  [source_line, link_text(written.to_s), link_text(reading.to_s), (meaning || '').strip, (frequency || '').strip]
end

abort "Expected 1635 rows, got #{rows.length}" unless rows.length == 1635

CSV.open(output_path, 'w', col_sep: "\t", quote_char: '"', force_quotes: true) do |csv|
  csv << %w[source_order written reading meaning_en frequency_rank source_revision]
  rows.each_with_index do |(_source_line, written, reading, meaning, frequency), index|
    csv << [index + 1, written, reading, meaning, frequency, revision.fetch('revid')]
  end
end

puts "Normalized #{rows.length} rows to #{output_path}"
