# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/pitch_accent'

class PitchAccentTest < Minitest::Test
  def test_small_kana_join_the_preceding_mora
    assert_equal %w[きょ う], PitchAccent.morae('きょう')
    assert_equal %w[ふぁ い る], PitchAccent.morae('ふぁいる')
    assert_equal %w[くゎ し], PitchAccent.morae('くゎし')
  end

  def test_sokuon_moraic_n_and_long_vowel_mark_are_morae
    assert_equal %w[が っ こ う], PitchAccent.morae('がっこう')
    assert_equal %w[に ほ ん ご], PitchAccent.morae('にほんご')
    assert_equal %w[こ ー ひ ー], PitchAccent.morae('コーヒー')
  end

  def test_katakana_and_hiragana_count_the_same
    assert_equal PitchAccent.mora_count('しゃしん'), PitchAccent.mora_count('シャシン')
    assert_equal 5, PitchAccent.mora_count('ジャズバンド')
    assert_equal %w[ゔぁ い お り ん], PitchAccent.morae('ヴァイオリン')
  end

  def test_pattern_names
    assert_equal 'heiban', PitchAccent.pattern(0, 4)
    assert_equal 'atamadaka', PitchAccent.pattern(1, 3)
    assert_equal 'nakadaka', PitchAccent.pattern(2, 4)
    assert_equal 'odaka', PitchAccent.pattern(3, 3)
    assert_equal 'atamadaka', PitchAccent.pattern(1, 1)
    assert_equal 'heiban', PitchAccent.pattern(0, 1)
  end

  def test_mora_patterns
    assert_equal 'LHHH', PitchAccent.mora_pattern(0, 4)
    assert_equal 'HLL', PitchAccent.mora_pattern(1, 3)
    assert_equal 'LHLL', PitchAccent.mora_pattern(2, 4)
    assert_equal 'LHH', PitchAccent.mora_pattern(3, 3)
    assert_equal 'H', PitchAccent.mora_pattern(1, 1)
    assert_equal 'L', PitchAccent.mora_pattern(0, 1)
  end

  def test_drop_beyond_the_word_is_rejected
    refute PitchAccent.valid_drop?(5, 4)
    refute PitchAccent.valid_drop?(0, 0)
    assert_raises(ArgumentError) { PitchAccent.pattern(5, 4) }
    assert_raises(ArgumentError) { PitchAccent.mora_pattern(-1, 4) }
  end
end
