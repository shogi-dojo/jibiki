#!/usr/bin/env ruby
# frozen_string_literal: true

# Writes Kanjium's Tokyo pitch accents into entry `* Pronunciation` sections
# (docs/org-format.md §11). The matching and rewriting live in
# lib/kanjium_accents.rb; this file only reads and writes.
#
# accents.txt is a local, ignored input pinned to one Kanjium commit and
# checked against its SHA-256. Fetch it with:
#
#   mkdir -p sources/kanjium
#   curl -sSfL -o sources/kanjium/accents.txt <KanjiumAccents::RAW_URL>
#
# Re-running is safe: unchanged blocks are left as they are, stale imported
# blocks are removed, and hand-authored accents are never touched.

require 'date'
require 'digest'
require 'optparse'
require_relative '../lib/kanjium_accents'

ROOT = File.expand_path('..', __dir__)

options = {
  accents: ENV.fetch('KANJIUM_ACCENTS_PATH', File.join(ROOT, 'sources', 'kanjium', 'accents.txt')),
  root: ROOT,
  date: Date.today.iso8601,
  check: false,
  allow_unpinned: false
}
OptionParser.new do |parser|
  parser.banner = 'Usage: import_kanjium_accents.rb [--accents PATH] [--date YYYY-MM-DD] [--check] [--root DIR]'
  parser.on('--accents PATH', 'Kanjium accents.txt (default sources/kanjium/accents.txt)') { |v| options[:accents] = v }
  parser.on('--date DATE', 'VERIFIED_AT for new or changed blocks (default today)') { |v| options[:date] = v }
  parser.on('--check', 'Report what would change without writing; exit 1 if anything would') { options[:check] = true }
  parser.on('--allow-unpinned', 'Accept an accents file whose SHA-256 differs from the pin (test fixtures)') do
    options[:allow_unpinned] = true
  end
  parser.on('--root DIR', 'Repository root holding entries/ (default this repo)') { |v| options[:root] = v }
end.parse!

accents = options[:accents]
unless File.exist?(accents)
  abort "#{accents} not found. Fetch the pinned file:\n  " \
        "mkdir -p #{File.dirname(accents)} && curl -sSfL -o #{accents} #{KanjiumAccents::RAW_URL}"
end
digest = Digest::SHA256.file(accents).hexdigest
if digest != KanjiumAccents::SHA256 && !options[:allow_unpinned]
  abort "#{accents} has SHA-256 #{digest}, expected #{KanjiumAccents::SHA256} (Kanjium #{KanjiumAccents::COMMIT})"
end

paths = Dir[File.join(options[:root], 'entries', '*', '*.org')].sort
texts = paths.to_h { |path| [path, File.read(path, encoding: 'UTF-8')] }
forms = texts.transform_values { |text| KanjiumAccents.read_forms(text) }
index = KanjiumAccents::Index.new
forms.each { |path, entry_forms| index.add(path, entry_forms) }

counts = %i[rows malformed pos_tagged matched unmatched ambiguous multi_entry].to_h { |key| [key, 0] }
# path => { Reading => [drops] }, in accents.txt order.
drops = Hash.new { |hash, path| hash[path] = Hash.new { |inner, reading| inner[reading] = [] } }

File.foreach(accents, encoding: 'UTF-8') do |raw|
  counts[:rows] += 1
  line = KanjiumAccents.parse_line(raw)
  unless line
    counts[:malformed] += 1
    next
  end
  counts[:pos_tagged] += 1 if line.pos_tagged
  match = index.match(line)
  counts[match.status] += 1
  next unless match.status == :matched

  counts[:multi_entry] += 1 if match.targets.map(&:key).uniq.length > 1
  match.targets.each do |target|
    list = drops[target.key][target.reading]
    line.drops.each { |drop| list << drop unless list.include?(drop) }
  end
end

changed = []
totals = %i[blocks kept invalid entries].to_h { |key| [key, 0] }
paths.each do |path|
  text = texts.fetch(path)
  # Keep entry reading order so accent IDs follow rd- order.
  by_reading = forms.fetch(path).readings.to_h { |reading| [reading, drops.dig(path, reading) || []] }
  result = KanjiumAccents.merge(text, by_reading, verified_at: options[:date])
  totals[:blocks] += result.written
  totals[:kept] += result.kept
  totals[:invalid] += result.invalid
  totals[:entries] += 1 if result.written.positive?
  next if result.text == text

  changed << path
  File.write(path, result.text, encoding: 'UTF-8') unless options[:check]
end

puts format(<<~REPORT, **counts.merge(totals), changed: changed.length, entries_total: paths.length)
  Kanjium #{KanjiumAccents::COMMIT[0, 12]}: %<rows>d rows (%<malformed>d malformed, %<pos_tagged>d with part-of-speech prefixes)
    matched    %<matched>d (%<multi_entry>d onto more than one entry)
    unmatched  %<unmatched>d
    ambiguous  %<ambiguous>d kana rows shared by several kanji entries (skipped)
  Accent blocks: %<blocks>d imported across %<entries>d of %<entries_total>d entries; %<kept>d hand-authored kept; %<invalid>d drops past the last mora skipped
  Entries #{options[:check] ? 'that would change' : 'changed'}: %<changed>d
REPORT

exit(options[:check] && !changed.empty? ? 1 : 0)
