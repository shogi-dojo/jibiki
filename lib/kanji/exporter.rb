# frozen_string_literal: true

require 'sequel'
require_relative 'record'

module Kanji
  # Flat rows for the content database, one array per table, written by write_tables. The
  # shape is fixed here so the importer and the database agree on it.
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

module Kanji
  module Exporter
    module_function

    # Every record in the directory, parsed and sorted by codepoint.
    def load_records(dir)
      Dir[File.join(dir, 'U+*.org')].sort.map { |path| Record.load(path) }
    end

    # Writes the kanji tables into an open Sequel database. Strokes are keyed by codepoint and kept
    # in drawing order; they are read only for the characters a page asks for.
    def write_tables(db, records, strokes)
      tables = rows(records)
      db.create_table(:kanji) do
        String :codepoint, primary_key: true
        String :character, null: false
        Integer :stroke_count
        Integer :grade
        Integer :frequency
        String :fingerprint, null: false
      end
      db.create_table(:kanji_readings) do
        String :codepoint, null: false
        String :kind, null: false
        String :reading, null: false
        Integer :position, null: false
        index :codepoint
        index :reading
      end
      db.create_table(:kanji_meanings) do
        String :codepoint, null: false
        String :text, null: false
        Integer :position, null: false
        index :codepoint
      end
      db.create_table(:kanji_translations) do
        String :id, primary_key: true
        String :codepoint, null: false
        String :text, null: false
        String :status, null: false
        String :reviewed_by
        index :codepoint
      end
      db.create_table(:kanji_strokes) do
        String :codepoint, null: false
        Integer :position, null: false
        String :kind
        String :path, null: false
        primary_key %i[codepoint position]
      end

      db[:kanji].multi_insert(tables[:kanji])
      db[:kanji_readings].multi_insert(tables[:kanji_readings])
      db[:kanji_meanings].multi_insert(tables[:kanji_meanings])
      db[:kanji_translations].multi_insert(tables[:kanji_translations])
      stroke_rows = records.flat_map do |record|
        Array(strokes[record.codepoint]).map do |stroke|
          { codepoint: record.codepoint, position: stroke.position, kind: stroke.kind, path: stroke.path }
        end
      end
      db[:kanji_strokes].multi_insert(stroke_rows)
    end
  end
end
