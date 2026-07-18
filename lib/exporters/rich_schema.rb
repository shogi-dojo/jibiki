# frozen_string_literal: true

module Exporters
  module RichSchema
    def self.create_tables(db)
      db.create_table?(:metadata) do
        String :key, primary_key: true
        String :value, null: false
      end

      db.create_table?(:entries) do
        Integer :jmdict_id, primary_key: true
        String :title, null: false
        String :primary_reading
        String :romaji
        String :entry_status
        String :quality_profile
        String :created_at
        String :updated_at
      end

      db.create_table?(:written_forms) do
        String :id, primary_key: true
        Integer :jmdict_id, null: false
        Integer :position, null: false
        String :text, null: false
        String :information
        String :priorities
      end

      db.create_table?(:readings) do
        String :id, primary_key: true
        Integer :jmdict_id, null: false
        Integer :position, null: false
        String :text, null: false
        Integer :no_kanji, null: false # SQLite uses INTEGER for booleans
        String :applies_to_written_forms
        String :information
        String :priorities
      end

      db.create_table?(:senses) do
        String :id, primary_key: true
        Integer :jmdict_id, null: false
        Integer :position, null: false
        Integer :source_sense_index, null: false
        String :learner_priority
        String :applies_to_written
        String :applies_to_readings
        String :parts_of_speech
        String :misc
        String :fields
        String :dialects
        String :sense_information
      end

      db.create_table?(:english_glosses) do
        String :sense_id, null: false
        Integer :position, null: false
        String :text, null: false
        String :gloss_type
        String :lang
        String :gender
        primary_key [:sense_id, :position]
      end

      db.create_table?(:ukrainian_glosses) do
        String :id, primary_key: true
        String :sense_id, null: false
        Integer :position, null: false
        String :text, null: false
        String :qualifier
        String :status
        String :translator_id
        String :translated_at
        String :reviewer_id
        String :reviewed_at
        String :source_type
        String :license
      end

      db.create_table?(:russian_references) do
        String :sense_id, null: false
        Integer :position, null: false
        Integer :source_sense_index, null: false
        String :text, null: false
        primary_key [:sense_id, :position]
      end

      db.create_table?(:learner_notes) do
        String :id, primary_key: true
        String :sense_id, null: false
        Integer :position, null: false
        String :uk, null: false
        String :level
        String :register
        String :status
        String :author_id
        String :created_at
        String :license
        String :source_type
      end

      db.create_table?(:examples) do
        String :id, primary_key: true
        String :sense_id, null: false
        Integer :position, null: false
        String :ja, null: false
        String :reading, null: false
        String :romaji
        String :uk, null: false
        String :en
        String :focus
        String :level
        String :register
        String :status
        String :author_id
        String :created_at
        String :license
        String :source_type
        String :source_id
        String :source_url
      end

      db.create_table?(:collocations) do
        String :id, primary_key: true
        String :sense_id, null: false
        Integer :position, null: false
        String :ja, null: false
        String :reading, null: false
        String :uk, null: false
        String :pattern
        String :register
        String :status
        String :author_id
        String :created_at
        String :license
        String :source_type
      end

      db.create_table?(:constructions) do
        String :id, primary_key: true
        String :sense_id, null: false
        Integer :position, null: false
        String :relation, null: false
        String :target, null: false
        String :target_id
        String :status
        String :author_id
        String :created_at
        String :license
        String :source_type
      end

      db.create_table?(:related_words) do
        String :id, primary_key: true
        String :sense_id, null: false
        Integer :position, null: false
        String :relation, null: false
        String :target, null: false
        String :target_id
        String :status
        String :author_id
        String :created_at
        String :license
        String :source_type
      end

      db.create_table?(:idioms) do
        String :id, primary_key: true
        String :sense_id, null: false
        Integer :position, null: false
        String :ja, null: false
        String :reading, null: false
        String :uk, null: false
        String :en
        String :level
        String :register
        String :status
        String :author_id
        String :created_at
        String :license
        String :source_type
      end

      db.create_table?(:pitch_accents) do
        String :id, primary_key: true
        Integer :jmdict_id, null: false
        String :reading_id
        String :system
        Integer :mora_count
        Integer :drop_after
        String :pattern
        String :mora_pattern
        String :context
        String :source_id
        String :source_version
        String :source_url
        String :license
        String :status
        String :verified_at
      end

      db.create_table?(:vocab_mapping) do
        Integer :jmdict_id, null: false
        Integer :vocab_id, null: false
        String :writing
        String :reading
        Integer :is_main # SQLite INTEGER boolean
        primary_key [:jmdict_id, :vocab_id]
      end

      db.run "CREATE VIRTUAL TABLE IF NOT EXISTS entry_search USING fts4(jmdict_id, writings, readings, romaji, uk_glosses, en_glosses, notindexed=jmdict_id, tokenize=unicode61);"

      create_indexes(db)
    end

    # Consumers look rows up by entry or by sense; without these every such
    # query is a table scan.
    def self.create_indexes(db)
      %i[written_forms readings senses pitch_accents].each do |table|
        db.add_index table, :jmdict_id, if_not_exists: true
      end

      %i[ukrainian_glosses learner_notes examples collocations
         constructions related_words idioms].each do |table|
        db.add_index table, :sense_id, if_not_exists: true
      end

      db.add_index :vocab_mapping, :vocab_id, if_not_exists: true
    end
  end
end
