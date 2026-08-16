#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'fileutils'
require 'optparse'
require_relative '../lib/org_entry'

REPO_ROOT = File.expand_path('..', __dir__)
NOTES_DIR = File.join(REPO_ROOT, 'notes')
LOG_PATH = File.join(NOTES_DIR, 'stripped-foreign-senses.json')

options = {
  dry_run: false,
  log_path: LOG_PATH
}

parser = OptionParser.new do |opts|
  opts.banner = 'Usage: scripts/strip_foreign_senses.rb [options] [path ...]'

  opts.on('-d', '--dry-run', 'Perform dry-run without modifying files') do
    options[:dry_run] = true
  end

  opts.on('-l', '--log PATH', 'Path to output JSON audit log') do |p|
    options[:log_path] = p
  end

  opts.on('-h', '--help', 'Show this help message') do
    puts opts
    exit 0
  end
end

parser.parse!(ARGV)

paths = ARGV.empty? ? Dir[File.join(REPO_ROOT, 'entries', '*', '*.org')].sort : ARGV.map { |p| File.expand_path(p) }
paths = paths.select { |p| File.exist?(p) }

def parse_sections(content)
  lines = content.split("\n", -1)
  sections = []
  current_header = nil
  current_lines = []

  lines.each do |line|
    if line =~ /^\*\s+(.*)$/
      sections << { title: current_header, lines: current_lines } if current_header || !current_lines.empty?
      current_header = $1
      current_lines = [line]
    else
      current_lines << line
    end
  end
  sections << { title: current_header, lines: current_lines } if current_header || !current_lines.empty?
  sections
end

stripped_log = []
total_dropped_senses = 0
modified_files_count = 0

paths.each do |path|
  entry = OrgEntry.load(path)
  dropped_senses = []

  entry.senses.each do |sense|
    has_eng = sense.english_glosses.any? { |eg| eg.lang == 'eng' }
    has_uk = sense.ukrainian_glosses.any? { |ug| ug.text && !ug.text.strip.empty? }

    if !has_eng && !has_uk
      dropped_senses << sense
    end
  end

  next if dropped_senses.empty?

  rel_path = path.sub("#{REPO_ROOT}/", '')
  dropped_ids = dropped_senses.map(&:id)

  stripped_log << {
    ent_seq: entry.jmdict_id,
    romaji: entry.romaji,
    path: rel_path,
    dropped_count: dropped_senses.length,
    surviving_count: entry.senses.length - dropped_senses.length,
    dropped_senses: dropped_senses.map do |s|
      {
        sense_id: s.id,
        source_sense_index: s.source_sense_index,
        source_fingerprint: s.source_fingerprint,
        languages: s.english_glosses.map(&:lang).uniq,
        glosses: s.english_glosses.map { |g| { lang: g.lang, text: g.text } }
      }
    end
  }

  total_dropped_senses += dropped_senses.length
  modified_files_count += 1

  unless options[:dry_run]
    content = File.read(path, encoding: Encoding::UTF_8)
    sections = parse_sections(content)

    new_sections = sections.reject do |sec|
      sec[:title] =~ /^Sense\s+(s-\d+-\d+)/ && dropped_ids.include?($1)
    end

    new_content = new_sections.map { |s| s[:lines].join("\n") }.join("\n")
    new_content = "#{new_content.strip}\n"

    File.write(path, new_content, encoding: Encoding::UTF_8)
  end
end

FileUtils.mkdir_p(File.dirname(options[:log_path]))
File.write(options[:log_path], JSON.pretty_generate(stripped_log), encoding: Encoding::UTF_8)

mode_str = options[:dry_run] ? '[DRY RUN] ' : ''
puts "#{mode_str}Stripped #{total_dropped_senses} foreign-only senses across #{modified_files_count} files."
puts "Saved recovery log to #{options[:log_path]}"
