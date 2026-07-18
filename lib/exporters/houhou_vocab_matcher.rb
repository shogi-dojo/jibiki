# frozen_string_literal: true

require "sequel"

module Exporters
  # Builds a lookup table from the Houhou KanjiDatabase VocabSet table so that
  # jibiki entries (keyed by JMdict ent_seq writing/reading pairs) can be matched
  # to Houhou VocabSet.ID values.
  #
  # Matching mirrors the reference build_localized_dictionary.py logic:
  #   key = [nfkc(COALESCE(NULLIF(KanjiWriting,''), KanaWriting)), hira(KanaWriting)]
  #
  # Usage:
  #   matcher = HouhouVocabMatcher.new("/path/to/KanjiDatabase.sqlite")
  #   matches = matcher.lookup(writing: "分かる", reading: "わかる")
  #   # => [{vocab_id: 12345, is_main: true}, ...]
  #   matcher.close
  class HouhouVocabMatcher
    # Katakana codepoint range: ァ (U+30A1) .. ヶ (U+30F6).
    # Shift by −0x60 converts each to the corresponding hiragana.
    KATA_START = 0x30A1
    KATA_END   = 0x30F6
    KATA_SHIFT = 0x60

    # Convert a katakana string to hiragana (passthrough for everything else).
    def self.to_hiragana(str)
      str.chars.map do |ch|
        cp = ch.ord
        (cp >= KATA_START && cp <= KATA_END) ? (cp - KATA_SHIFT).chr(Encoding::UTF_8) : ch
      end.join
    end

    # NFKC-normalise a string (compatibility decomposition then canonical composition).
    def self.nfkc(str)
      str.unicode_normalize(:nfkc)
    end

    # Compute the lookup key used for matching.
    # writing may be nil/empty; reading must be present.
    def self.key(writing, reading)
      effective_writing = (writing.nil? || writing.empty?) ? reading : writing
      [nfkc(effective_writing), to_hiragana(nfkc(reading))]
    end

    # -------------------------------------------------------------------------
    # Instance

    # @param db_path [String] path to KanjiDatabase.sqlite (read-only)
    def initialize(db_path)
      @db = Sequel.sqlite(db_path, readonly: true)
      initialize_index
    end

    # Return all VocabSet rows that match the given writing/reading pair.
    #
    # @param writing [String, nil] kanji writing (may be nil or empty for kana-only)
    # @param reading [String]      kana reading
    # @return [Array<Hash>] each element has :vocab_id (Integer) and :is_main (Boolean)
    def lookup(writing:, reading:)
      k = self.class.key(writing, reading)
      @index.fetch(k, [])
    end

    # Fallback: match by reading alone, but only when every VocabSet row with
    # this reading belongs to a single GroupId (i.e. one word) — this prevents
    # homophones (橋/箸/端 …) from bleeding into each other.
    #
    # @return [Array<Hash>] like #lookup
    def lookup_by_reading(reading)
      key = self.class.to_hiragana(self.class.nfkc(reading))
      rows = @reading_index.fetch(key, [])
      return [] unless rows.map { |r| r[:group_id] }.uniq.size == 1

      rows.map { |r| { vocab_id: r[:vocab_id], is_main: r[:is_main] } }
    end

    def close
      @db.disconnect
    end

    # Build (or rebuild) the in-memory indexes from VocabSet. Called by initialize;
    # also usable by tests that inject a custom @db before calling this.
    def initialize_index
      @index = Hash.new { |h, k| h[k] = [] }
      @reading_index = Hash.new { |h, k| h[k] = [] }

      @db[:VocabSet].select(:ID, :KanjiWriting, :KanaWriting, :IsMain, :GroupId).each do |row|
        entry = { vocab_id: row[:ID], is_main: row[:IsMain] == 1 || row[:IsMain] == true }
        @index[self.class.key(row[:KanjiWriting], row[:KanaWriting])] << entry
        reading_key = self.class.to_hiragana(self.class.nfkc(row[:KanaWriting]))
        @reading_index[reading_key] << entry.merge(group_id: row[:GroupId])
      end
    end
  end
end
