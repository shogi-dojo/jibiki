# frozen_string_literal: true

# Kana normalisation used by the validator, the doctor and the Houhou matcher.
#
# The algorithm is the yanagi gem's Yanagi::Normalize, restated here with no
# gem dependency so that this file can be compiled by Spinel together with the
# rest of the `jb` CLI (test/kana_test.rb holds it to Yanagi's output).
module Kana
  module_function

  # Katakana ァ (U+30A1) .. ヶ (U+30F6); shifting by -0x60 gives the hiragana.
  KATA_START = 0x30A1
  KATA_END = 0x30F6
  KATA_SHIFT = 0x60

  # NFKC-normalises a string. Input may arrive tagged ASCII-8BIT (ARGV, a
  # binread), which unicode_normalize rejects, so it is coerced to UTF-8 first.
  def nfkc(str)
    s = str.to_s
    s = s.dup.force_encoding(Encoding::UTF_8) unless s.encoding == Encoding::UTF_8
    s.unicode_normalize(:nfkc)
  end

  # Converts katakana to hiragana and passes everything else through.
  def to_hiragana(str)
    str.to_s.chars.map do |ch|
      cp = ch.ord
      cp >= KATA_START && cp <= KATA_END ? (cp - KATA_SHIFT).chr(Encoding::UTF_8) : ch
    end.join
  end
end
