# frozen_string_literal: true

require_relative 'record'

module Kanji
  # Flat rows for the content database, one array per table. Commit 5 writes them to SQLite; the
  # shape is fixed here so the importer and the exporter agree on it.
  module Exporter
    module_function

    def rows(records)
      {
        kanji: records.map { |record| kanji_row(record) },
        kanji_readings: records.flat_map { |record| reading_rows(record) },
        kanji_meanings: records.flat_map { |record| meaning_rows(record) },
        kanji_translations: records.flat_map { |record| translation_rows(record) }
      }
    end

    def kanji_row(record)
      source = record.source
      { codepoint: record.codepoint, character: record.character, stroke_count: source.stroke_count,
        grade: source.grade, frequency: source.frequency, fingerprint: record.computed_fingerprint }
    end

    # Positions count within each kind, so the first kun reading is position 0 whatever the on readings.
    def reading_rows(record)
      { 'on' => record.source.on_readings, 'kun' => record.source.kun_readings }.flat_map do |kind, readings|
        readings.each_with_index.map do |reading, position|
          { codepoint: record.codepoint, kind: kind, reading: reading, position: position }
        end
      end
    end

    def meaning_rows(record)
      record.source.meanings.each_with_index.map do |meaning, position|
        { codepoint: record.codepoint, text: meaning, position: position }
      end
    end

    def translation_rows(record)
      record.translations.map do |translation|
        { id: translation.id, codepoint: record.codepoint, text: translation.text,
          status: translation.status, reviewed_by: translation.reviewed_by }
      end
    end
  end
end
