# frozen_string_literal: true

require 'digest'

module DictionarySources
  class Warodai
    CARD_ID_PATTERN = /〔(?<card_id>\d{3}-\d{2}-\d{2})〕\s*\z/
    TRANSCRIPTION_PATTERN = /\((?<transcription>[^()]*)\)\s*(?<codes>(?:\[[^\]]+\]\s*)*)\z/

    attr_reader :root

    def initialize(root)
      @root = File.expand_path(root)
    end

    def lookup(written: nil, reading: nil, card_id: nil)
      written = normalize_query(written)
      reading = normalize_query(reading)
      card_id = card_id.to_s unless card_id.nil?
      raise ArgumentError, 'provide written, reading, or card_id' if [written, reading, card_id].all?(&:nil?)

      candidate_paths(card_id).filter_map do |path|
        entry = parse_file(path)
        next unless matches?(entry, written:, reading:, card_id:)

        entry
      end
    end

    # Resolves many queries in a single pass over the card files. Takes an
    # array of {written:, reading:, card_id:} hashes and returns an array of
    # match arrays in the same order.
    def lookup_many(queries)
      queries = queries.map do |query|
        {
          written: normalize_query(query[:written]),
          reading: normalize_query(query[:reading]),
          card_id: query[:card_id]&.to_s
        }
      end
      queries.each do |query|
        raise ArgumentError, 'provide written, reading, or card_id' if query.values.all?(&:nil?)
      end

      results = Array.new(queries.length) { [] }
      candidate_paths(nil).each do |path|
        entry = parse_file(path)
        queries.each_with_index do |query, i|
          results[i] << entry if matches?(entry, **query)
        end
      end
      results
    end

    def parse_file(path)
      content = File.binread(path).force_encoding(Encoding::UTF_8)
      raise ArgumentError, "invalid UTF-8 in #{path}" unless content.valid_encoding?

      content = content.unicode_normalize(:nfc)
      lines = content.lines(chomp: true)
      header = parse_header(lines.first.to_s, path)

      header.merge(
        relative_path: path.delete_prefix("#{root}/"),
        body_lines: lines.drop(1),
        source_file_sha256: Digest::SHA256.hexdigest(content)
      )
    end

    def parse_header(line, path = '(header)')
      id_match = line.match(CARD_ID_PATTERN)
      raise ArgumentError, "missing Warodai card ID in #{path}" unless id_match

      before_id = line.sub(CARD_ID_PATTERN, '').rstrip
      transcription_match = before_id.match(TRANSCRIPTION_PATTERN)
      raise ArgumentError, "unrecognized Warodai header in #{path}" unless transcription_match

      headword = before_id.sub(TRANSCRIPTION_PATTERN, '').rstrip
      kana_raw, written_raw = split_headword(headword)

      {
        card_id: id_match[:card_id],
        header: line,
        kana_raw:,
        kana_forms: split_forms(kana_raw),
        written_raw:,
        written_forms: written_raw ? split_forms(written_raw, /[･,]/) : [],
        polivanov: transcription_match[:transcription],
        corpus_codes: transcription_match[:codes].scan(/\[([^\]]+)\]/).flatten
      }
    end

    private

    def normalize_query(value)
      return nil if value.nil? || value.empty?

      value.unicode_normalize(:nfc)
    end

    def candidate_paths(card_id)
      if card_id&.match?(/\A\d{3}-\d{2}-\d{2}\z/)
        group, subgroup, = card_id.split('-')
        [File.join(root, group, subgroup, "#{card_id}.txt")].select { |path| File.file?(path) }
      else
        Dir.glob(File.join(root, '[0-9][0-9][0-9]', '[0-9][0-9]', '*.txt')).sort
      end
    end

    def matches?(entry, written:, reading:, card_id:)
      return false if card_id && entry[:card_id] != card_id
      return false if reading && entry[:kana_forms].none? { |form| searchable_form(form) == reading }
      return false if written && entry[:written_forms].none? { |form| searchable_form(form) == written }

      true
    end

    def split_headword(headword)
      match = headword.match(/\A(?<kana>.*?)【(?<written>.*?)】\z/)
      return [headword, nil] unless match

      [match[:kana], match[:written]]
    end

    def split_forms(value, separator = /,/)
      value.split(separator).map(&:strip).reject(&:empty?)
    end

    def searchable_form(value)
      value.sub(/[IV]+\z/, '')
    end
  end
end
