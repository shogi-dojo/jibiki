#!/usr/bin/env ruby
# frozen_string_literal: true

# Measures how often analyzer readings (Authoring::Reading) agree with the
# READING already written in corpus examples. Analyzer readings replace
# model-written ones only while this agreement stays at or above --min.
#
#   ruby scripts/reading_agreement.rb --sample 5000 --diffs 40

require 'optparse'
require_relative '../lib/kana'
require_relative '../lib/org_entry'
require_relative '../lib/authoring/reading'

options = { entries: 'entries', sample: 5000, seed: 1, diffs: 30, min: 98.0 }
OptionParser.new do |cli|
  cli.banner = 'Usage: reading_agreement.rb [options]'
  cli.on('--entries DIR', "Entries directory (default: #{options[:entries]})") { |v| options[:entries] = v }
  cli.on('--sample N', Integer, "Entries to sample (default: #{options[:sample]})") { |v| options[:sample] = v }
  cli.on('--seed N', Integer, 'Sampling seed (default: 1)') { |v| options[:seed] = v }
  cli.on('--diffs N', Integer, "Disagreements to print (default: #{options[:diffs]})") { |v| options[:diffs] = v }
  cli.on('--min PERCENT', Float, "Agreement needed to pass (default: #{options[:min]})") { |v| options[:min] = v }
end.parse!

paths = Dir.glob(File.join(options[:entries], '*', '*.org')).sort
paths = paths.sample(options[:sample], random: Random.new(options[:seed])) if options[:sample] < paths.size

sentences = []
paths.each do |path|
  entry = OrgEntry.load(path)
  entry.senses.each do |sense|
    sense.examples.each do |ex|
      next if ex.ja.to_s.empty? || ex.reading.to_s.empty?

      focus_reading = ex.focus == entry.title ? entry.primary_reading : nil
      sentences << { ja: ex.ja, focus: ex.focus, focus_reading:, expected: ex.reading, path: }
    end
  end
end

normalize = ->(s) { Kana.to_hiragana(Kana.nfkc(s)).gsub(/\s/, '') }
generated = Authoring::Reading.readings(sentences)
read = 0
agree = 0
diffs = []
sentences.zip(generated).each do |s, got|
  next if got.nil?

  read += 1
  if normalize.(got) == normalize.(s[:expected])
    agree += 1
  else
    diffs << [s, got]
  end
end

coverage = sentences.empty? ? 0 : 100.0 * read / sentences.size
rate = read.zero? ? 0 : 100.0 * agree / read
puts format('%d entries, %d examples; analyzer read %d (%.1f%%), agreed on %d (%.2f%%)',
            paths.size, sentences.size, read, coverage, agree, rate)
diffs.first(options[:diffs]).each do |s, got|
  puts "\n#{s[:path]}\n  JA:       #{s[:ja]}\n  corpus:   #{s[:expected]}\n  analyzer: #{got}"
end
exit(rate >= options[:min] ? 0 : 1)
