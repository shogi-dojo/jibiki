#!/usr/bin/env ruby
# frozen_string_literal: true

# Ukrainian drafts for the kanji records, in resumable batches.
#
#   ruby scripts/kanji_drafts.rb dump START COUNT   # the English source lines for a range, in order
#   ruby scripts/kanji_drafts.rb placeholders       # writes drafts/kanji/placeholders.tsv for characters with no English meaning
#   ruby scripts/kanji_drafts.rb apply              # writes every drafts/kanji/*.tsv into its record
#   ruby scripts/kanji_drafts.rb coverage           # how many records have a translation, and of what status
#
# A batch file holds one line per character: "U+XXXX<TAB>Ukrainian text". Applying a batch adds a
# draft block (status draft, no reviewer) to a record that has no Ukrainian translation yet. A record
# with a draft updates that draft; a reviewed translation is never changed. Running apply again is safe.
require 'fileutils'
require_relative '../lib/kanji'

ROOT = File.expand_path('..', __dir__)
RECORDS = File.join(ROOT, 'kanji')
BATCHES = File.join(ROOT, 'drafts', 'kanji')

def records
  Dir[File.join(RECORDS, 'U+*.org')].sort.map { |path| Kanji::Record.load(path) }
end

# Characters with an English meaning in the source are translated by hand, in batches; the rest get
# a placeholder that says the source gives no meaning (see placeholders).
def with_meanings
  records.select { |record| record.source.meanings.any? }
end

def dump(start, count)
  with_meanings[start, count].each_with_index do |record, offset|
    meanings = record.source.meanings.first(4).join('; ')
    readings = (record.source.on_readings + record.source.kun_readings).first(3).join('、')
    puts [start + offset, record.codepoint, record.character, meanings, readings].join("\t")
  end
end

# A draft that states only what the source says: no meaning is invented for these characters.
def placeholders
  FileUtils.mkdir_p(BATCHES)
  lines = records.reject { |record| record.source.meanings.any? }.map do |record|
    readings = (record.source.on_readings + record.source.kun_readings).first(3).join('、')
    text = readings.empty? ? 'у джерелі не вказано значення' : "у джерелі не вказано значення; читання: #{readings}"
    "#{record.codepoint}\t#{text}"
  end
  File.write(File.join(BATCHES, 'placeholders.tsv'), "#{lines.join("\n")}\n", encoding: 'UTF-8')
  puts "placeholders: #{lines.size}"
end

def batch_drafts
  Dir[File.join(BATCHES, '*.tsv')].sort.each_with_object({}) do |path, drafts|
    File.foreach(path, encoding: 'UTF-8') do |line|
      code, text = line.chomp.split("\t", 2)
      next if code.nil? || text.nil? || text.strip.empty?

      drafts[code] = text.strip
    end
  end
end

def apply
  drafts = batch_drafts
  written = 0
  skipped = 0
  drafts.each do |codepoint, text|
    path = File.join(RECORDS, "#{codepoint}.org")
    next skipped += 1 unless File.exist?(path)

    record = Kanji::Record.load(path)
    translations = record.translations.dup
    existing = translations.find { |translation| translation.status == 'draft' && translation.reviewed_by.nil? }
    if existing
      next skipped += 1 if existing.text == text

      translations[translations.index(existing)] = existing.with(text: text)
    elsif translations.none? { |translation| translation.status == 'reviewed' }
      number = translations.map { |t| t.id[/-(\d+)\z/, 1].to_i }.max.to_i + 1
      translations << Kanji::Translation.new(id: format('uk-%s-%03d', codepoint, number), text: text,
                                             status: 'draft', reviewed_by: nil)
    else
      next skipped += 1 # a reviewed translation already stands; the draft is not needed
    end
    File.write(path, Kanji::Writer.render(keywords: record.keywords, source: record.source, translations: translations),
               encoding: 'UTF-8')
    written += 1
  end
  puts "applied #{written}, unchanged or skipped #{skipped}, drafts in batches #{drafts.size}"
end

def coverage
  counts = Hash.new(0)
  records.each do |record|
    statuses = record.translations.map(&:status)
    key = if statuses.include?('reviewed') then 'reviewed'
          elsif statuses.include?('draft') then 'draft'
          else 'missing'
          end
    counts[key] += 1
  end
  puts JSON.pretty_generate(counts.merge('records' => counts.values.sum))
end

case ARGV[0]
when 'dump' then dump(Integer(ARGV[1]), Integer(ARGV[2]))
when 'apply' then apply
when 'placeholders' then placeholders
when 'coverage' then coverage
else abort 'usage: kanji_drafts.rb dump START COUNT | apply | coverage'
end
