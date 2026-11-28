# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/authoring/reading'

class AuthoringReadingTest < Minitest::Test
  # Stands in for MeCab: a fixed token list per input line.
  class FakeAnalyzer
    attr_reader :calls

    def initialize(table)
      @table = table
      @calls = []
    end

    def tokenize(lines)
      @calls << lines
      lines.map { |line| @table.fetch(line) }
    end
  end

  def test_kana_kept_kanji_read_and_one_analyzer_call
    analyzer = FakeAnalyzer.new(
      '野球チームで' => [%w[野球 ヤキュウ], ['チーム', ''], %w[で デ]],
      'を始める。' => [%w[を ヲ], %w[始める ハジメル], ['。', '']],
      '今日は晴れ。' => [%w[今日 キョウ], %w[は ハ], %w[晴れ ハレ], ['。', '']]
    )
    got = Authoring::Reading.readings([
                                        { ja: '野球チームで春季を始める。', focus: '春季', focus_reading: 'しゅんき' },
                                        { ja: '今日は晴れ。' }
                                      ], analyzer:)

    assert_equal ['やきゅうちーむでしゅんきをはじめる。', 'きょうははれ。'], got
    assert_equal 1, analyzer.calls.size
  end

  def test_focus_at_edges_and_repeated
    analyzer = FakeAnalyzer.new('と' => [%w[と ト]])
    got = Authoring::Reading.readings([{ ja: '青と青', focus: '青', focus_reading: 'あお' }], analyzer:)

    assert_equal ['あおとあお'], got
  end

  def test_unreadable_token_yields_nil
    analyzer = FakeAnalyzer.new('3時に行く。' => [['3', ''], %w[時 ジ], %w[に ニ], %w[行く イク], ['。', '']])

    assert_equal [nil], Authoring::Reading.readings([{ ja: '3時に行く。' }], analyzer:)
  end

  def test_inflected_focus_is_analyzed_with_the_sentence
    analyzer = FakeAnalyzer.new('食べた。' => [%w[食べ タベ], %w[た タ], ['。', '']])
    got = Authoring::Reading.readings([{ ja: '食べた。', focus: '食べた', focus_reading: nil }], analyzer:)

    assert_equal ['たべた。'], got
  end
end
