# frozen_string_literal: true

require 'minitest/autorun'
require 'yanagi'
require_relative '../lib/kana'

# Kana restates Yanagi::Normalize without the gem, so it must agree with it.
class KanaTest < Minitest::Test
  SAMPLES = [
    '', 'わかる', 'ワカル', 'ｶﾀｶﾅ', 'ヴァイオリン', 'ヶ月', 'ヵ', 'ー', 'ﾊﾟﾝ', '漢字かなカナ',
    'Ｒｕｂｙ１２３', 'がっこう', 'ヷヸ', "ヶヷ", 'ABC abc'
  ].freeze

  def test_to_hiragana_matches_yanagi
    SAMPLES.each do |sample|
      assert_equal Yanagi::Normalize.to_hiragana(sample), Kana.to_hiragana(sample), sample
    end
  end

  def test_nfkc_matches_yanagi
    SAMPLES.each do |sample|
      assert_equal Yanagi::Normalize.nfkc(sample), Kana.nfkc(sample), sample
    end
  end

  def test_nfkc_accepts_binary_tagged_input
    assert_equal 'カ', Kana.nfkc('ｶ'.b)
  end

  def test_to_hiragana_leaves_non_katakana_alone
    assert_equal 'わかる漢字ー', Kana.to_hiragana('ワカル漢字ー')
  end
end
