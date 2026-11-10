#!/usr/bin/env ruby
# frozen_string_literal: true

# Rebuilds the kanji source records from the pinned upstream files.
#   ruby scripts/import_kanji.rb
# Existing records keep their Ukrainian translations; only the source sections change.
require 'json'
require_relative '../lib/kanji'

ROOT = File.expand_path('..', __dir__)
SOURCES = File.join(ROOT, 'sources', 'kanji')
report = Kanji::Importer.run(
  kanjidic: File.join(SOURCES, 'kanjidic2.xml.gz'),
  kanjivg: File.join(SOURCES, 'kanjivg-20260714.xml.gz'),
  records_dir: File.join(ROOT, 'kanji')
)
puts JSON.pretty_generate(report.to_h.transform_values { |v| v.is_a?(Array) ? v.size : v })
report.stroke_mismatches.first(20).each { |line| warn "stroke mismatch #{line}" }
