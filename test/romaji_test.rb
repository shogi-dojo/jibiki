# frozen_string_literal: true

require 'minitest/autorun'
require 'yanagi'
require_relative '../lib/romaji'
require_relative '../scripts/gen_yanagi_tables'

# Romaji restates Yanagi.romaji over a generated table; it must agree with the
# gem on every reading the corpus uses and on the edge cases below.
class RomajiTest < Minitest::Test
  ROOT = File.expand_path('..', __dir__)

  EDGE_CASES = [
    '', 'とうきょう', 'がっこう', 'きっちり', 'まっちゃ', 'ラーメン', 'ー', 'っ', 'ん', 'しんぶん',
    'コーヒー', 'ヴァイオリン', 'ｶﾀｶﾅ', 'ちぇっく', 'じぇ', 'てぃ', 'でぃ', 'いぇ', 'っん', 'あっ',
    'ふぁいる', '漢字かな', 'abc', 'きゃきゅきょ', 'っー'
  ].freeze

  def test_matches_yanagi_on_edge_cases
    EDGE_CASES.each do |reading|
      assert_equal Yanagi.romaji(reading), Romaji.call(reading), reading
    end
  end

  def test_matches_yanagi_on_every_corpus_reading
    readings = Dir[File.join(ROOT, 'entries', '*', '*.org')].filter_map do |path|
      File.read(path, 512, encoding: 'UTF-8')[/^#\+PRIMARY_READING: (.*)$/, 1]
    end.uniq
    skip 'no corpus entries' if readings.empty?

    mismatches = readings.reject { |reading| Yanagi.romaji(reading) == Romaji.call(reading) }
    assert_empty mismatches.first(10)
  end

  def test_generated_table_matches_the_installed_gem
    current = File.read(YanagiTables::TARGET, encoding: 'UTF-8')

    assert_equal YanagiTables.source, current,
                 'lib/generated/romaji_table.rb is stale: rerun scripts/gen_yanagi_tables.rb'
  end
end
