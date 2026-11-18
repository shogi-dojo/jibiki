# frozen_string_literal: true

require_relative 'kana'

# Tokyo pitch-accent arithmetic for one kana reading (docs/org-format.md §11).
#
# A drop position counts morae before the fall, as Kanjium and UniDic do:
# 0 is heiban (no lexical fall), 1 atamadaka, the last mora odaka, anything
# in between nakadaka.
module PitchAccent
  module_function

  # Small kana that fuse with the preceding mora (きゃ, ファ, くゎ). っ, ん
  # and ー are morae of their own, and ゕ/ゖ (ヵ/ヶ) are read か/け.
  SMALL = %w[ゃ ゅ ょ ぁ ぃ ぅ ぇ ぉ ゎ].freeze

  # Splits a reading into morae, katakana folded to hiragana first so either
  # script gives the same split.
  def morae(reading)
    Kana.to_hiragana(Kana.nfkc(reading)).chars.each_with_object([]) do |ch, out|
      if SMALL.include?(ch) && !out.empty?
        out[-1] += ch
      else
        out << ch
      end
    end
  end

  def mora_count(reading) = morae(reading).length

  # Whether a drop position fits a word of `count` morae.
  def valid_drop?(drop, count) = count.positive? && drop.between?(0, count)

  def pattern(drop, count)
    raise ArgumentError, "drop #{drop} does not fit #{count} morae" unless valid_drop?(drop, count)

    if drop.zero? then 'heiban'
    elsif drop == 1 then 'atamadaka'
    elsif drop == count then 'odaka'
    else 'nakadaka'
    end
  end

  # The learner-facing H/L summary of the word itself (no following particle,
  # so heiban and odaka look alike here; DROP_AFTER tells them apart).
  def mora_pattern(drop, count)
    raise ArgumentError, "drop #{drop} does not fit #{count} morae" unless valid_drop?(drop, count)

    Array.new(count) do |index|
      position = index + 1
      high = if drop == 1
               position == 1
             else
               position > 1 && (drop.zero? || position <= drop)
             end
      high ? 'H' : 'L'
    end.join
  end
end
