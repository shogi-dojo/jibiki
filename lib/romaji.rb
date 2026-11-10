# frozen_string_literal: true

require_relative 'kana'
require_relative 'generated/romaji_table'

# Kana => Hepburn romaji, as the yanagi gem's Yanagi.romaji renders it.
#
# This restates Yanagi::Tokenizer and Yanagi::Romaji over a table generated
# from yanagi's mora rules (scripts/gen_yanagi_tables.rb), so that it needs no
# gem and no YAML at run time and compiles under Spinel. test/romaji_test.rb
# holds it to Yanagi.romaji over every reading in the corpus.
module Romaji
  # One mora: its kana and what kind of mora it is (:sokuon, :chouonpu,
  # :moraic_n, :syllable or :passthrough).
  Mora = Data.define(:kana, :kind)

  module_function

  def tokenize(input)
    hira = Kana.to_hiragana(Kana.nfkc(input.to_s))
    moras = []
    i = 0
    while i < hira.length
      c1 = hira[i]
      c2 = hira[i, 2]
      if c1 == 'っ'
        moras << Mora.new(kana: c1, kind: :sokuon)
      elsif c1 == 'ー'
        moras << Mora.new(kana: c1, kind: :chouonpu)
      elsif c1 == 'ん'
        moras << Mora.new(kana: c1, kind: :moraic_n)
      elsif c2.length == 2 && TABLE.key?(c2)
        moras << Mora.new(kana: c2, kind: :syllable)
        i += 1
      elsif TABLE.key?(c1)
        moras << Mora.new(kana: c1, kind: :syllable)
      else
        moras << Mora.new(kana: c1, kind: :passthrough)
      end
      i += 1
    end
    moras
  end

  def call(input)
    moras = tokenize(input)
    out = []
    moras.each_with_index do |mora, idx|
      case mora.kind
      when :sokuon
        following = moras[(idx + 1)..].find { |m| %i[syllable moraic_n].include?(m.kind) }
        if following
          next_rom = TABLE.fetch(following.kana, following.kana)
          consonant = next_rom.start_with?('ch') ? 't' : next_rom[0]
          out << consonant if consonant
        end
      when :chouonpu
        prev_char = out.empty? ? nil : out.last[-1]
        out << prev_char if prev_char
      when :moraic_n
        out << 'n'
      when :syllable
        out << TABLE.fetch(mora.kana, mora.kana)
      else
        out << mora.kana
      end
    end
    out.join
  end
end
