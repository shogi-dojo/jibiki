# frozen_string_literal: true

require "sequel"
require "fileutils"
require_relative "houhou_vocab_matcher"

module Exporters
  # Produces a DictionaryTranslations.sqlite overlay compatible with Houhou-SRS.
  #
  # Schema (verbatim from verified Houhou contract — must not drift):
  #
  #   CREATE TABLE Metadata(Key TEXT NOT NULL PRIMARY KEY, Value TEXT NOT NULL);
  #   CREATE TABLE LocalizedVocabMeaning(
  #       VocabId INTEGER NOT NULL, Language TEXT NOT NULL, Meaning TEXT NOT NULL,
  #       PRIMARY KEY(VocabId, Language, Meaning)) WITHOUT ROWID;
  #   CREATE INDEX IX_LocalizedVocabMeaning_Language_VocabId
  #       ON LocalizedVocabMeaning(Language, VocabId);
  #   CREATE VIRTUAL TABLE LocalizedVocabSearchFts USING fts4(
  #       VocabId, Language, Meanings, notindexed=VocabId, tokenize=unicode61);
  #
  # Matching uses HouhouVocabMatcher (NFKC + katakana→hiragana, mirroring the
  # reference build_localized_dictionary.py).
  #
  # In merge mode (base_overlay_path given) the existing overlay's Language='ru'
  # rows and Language='uk' rows for VocabIds jibiki doesn't cover are copied in;
  # jibiki wins any conflicts.
  class HouhouOverlay
    LANGUAGE = "uk"

    # Export a Houhou overlay SQLite file from a collection of OrgEntry objects.
    #
    # @param entries        [Array<OrgEntry>] loaded jibiki entries
    # @param output_path    [String]          destination path (will be built atomically)
    # @param base_db_path   [String]          path to KanjiDatabase.sqlite for VocabId lookup
    # @param base_overlay_path [String, nil]  optional donor overlay for merge mode
    # @param unmatched_io   [IO]              where to report unmatched ent_seqs (default $stdout)
    # @return [Hash] {:matched, :unmatched, :meanings, :fts_rows}
    def self.export(
      entries,
      output_path,
      base_db_path:,
      base_overlay_path: nil,
      unmatched_io: $stdout
    )
      building_path = "#{output_path}.building"
      FileUtils.mkdir_p(File.dirname(output_path))
      FileUtils.rm_f(building_path)

      matcher = HouhouVocabMatcher.new(base_db_path)

      # uk_rows: { vocab_id => [meaning_string, ...] }
      uk_rows = Hash.new { |h, k| h[k] = [] }
      matched_jmdict_ids = []
      unmatched_jmdict_ids = []

      entries.each do |entry|
        entry_matched = false
        pairs = build_candidate_pairs(entry)

        pairs.each do |writing, reading, uk_meanings|
          matcher.lookup(writing: writing, reading: reading).each do |m|
            entry_matched = true
            uk_rows[m[:vocab_id]].concat(uk_meanings)
          end
        end

        # Fallback when every exact (writing, reading) pair missed — typically
        # rare-kanji forms Houhou dropped (its row is kana-only), or kanji Houhou
        # kept that jibiki omits (matched by reading when unambiguous).
        unless entry_matched
          pairs.each do |_writing, reading, uk_meanings|
            matches = matcher.lookup(writing: nil, reading: reading)
            matches = matcher.lookup_by_reading(reading) if matches.empty?
            matches.each do |m|
              entry_matched = true
              uk_rows[m[:vocab_id]].concat(uk_meanings)
            end
          end
        end

        if entry_matched
          matched_jmdict_ids << entry.jmdict_id
        else
          unmatched_jmdict_ids << entry.jmdict_id
        end
      end

      # Deduplicate meanings per vocab_id
      uk_rows.each_value(&:uniq!)

      unmatched_jmdict_ids.each do |id|
        unmatched_io.puts "UNMATCHED ent_seq: #{id}"
      end

      db = Sequel.sqlite(building_path)
      begin
        create_schema(db)

        db.transaction do
          # Merge mode: copy donor rows first (jibiki rows written later will win conflicts)
          if base_overlay_path
            merge_donor(db, base_overlay_path, uk_rows.keys)
          end

          # Insert jibiki uk rows
          uk_rows.each do |vocab_id, meanings|
            meanings.each do |meaning|
              db[:LocalizedVocabMeaning].insert(
                VocabId: vocab_id,
                Language: LANGUAGE,
                Meaning: meaning
              )
            end
          end

          # Build FTS: one row per (VocabId, Language) with space-joined meanings
          # First collect all (vocab_id, language) combinations currently in table
          fts_groups = db[:LocalizedVocabMeaning]
            .select(:VocabId, :Language)
            .group(:VocabId, :Language)
            .all

          fts_groups.each do |row|
            vid  = row[:VocabId]
            lang = row[:Language]
            meanings_text = db[:LocalizedVocabMeaning]
              .where(VocabId: vid, Language: lang)
              .select_map(:Meaning)
              .join(" ")
            db[:LocalizedVocabSearchFts].insert(
              VocabId: vid,
              Language: lang,
              Meanings: meanings_text
            )
          end

          # Metadata
          git_commit = begin
            `git rev-parse --short HEAD 2>/dev/null`.strip
          rescue
            "unknown"
          end
          notice_path = File.expand_path("../../NOTICE", __dir__)
          attribution = File.exist?(notice_path) ? File.read(notice_path, encoding: "UTF-8") : ""

          db[:Metadata].insert(Key: "SchemaVersion",  Value: "1")
          db[:Metadata].insert(Key: "UkrainianSource", Value: "jibiki")
          db[:Metadata].insert(Key: "MatchedEntries",  Value: matched_jmdict_ids.size.to_s)
          db[:Metadata].insert(Key: "UnmatchedEntries", Value: unmatched_jmdict_ids.size.to_s)
          db[:Metadata].insert(Key: "MeaningCount",    Value: uk_rows.values.sum(&:size).to_s)
          db[:Metadata].insert(Key: "GeneratedAt",     Value: Time.now.utc.iso8601)
          db[:Metadata].insert(Key: "GeneratorCommit", Value: git_commit)
          db[:Metadata].insert(Key: "License",         Value: "CC-BY-SA-4.0")
          db[:Metadata].insert(Key: "Attribution",     Value: attribution)
          if base_overlay_path
            db[:Metadata].insert(Key: "MergedFrom", Value: File.basename(base_overlay_path))
          end
        end

        check = db["PRAGMA integrity_check"].first.values.first
        raise "SQLite integrity check failed: #{check}" unless check == "ok"

        db.run "VACUUM;"
      ensure
        db&.disconnect
        matcher.close
      end

      FileUtils.mv(building_path, output_path)

      {
        matched:   matched_jmdict_ids.size,
        unmatched: unmatched_jmdict_ids.size,
        meanings:  uk_rows.values.sum(&:size),
        fts_rows:  uk_rows.size
      }
    ensure
      FileUtils.rm_f(building_path)
    end

    # -----------------------------------------------------------------------
    private

    # Create the required Houhou overlay schema verbatim.
    def self.create_schema(db)
      db.run <<~SQL
        CREATE TABLE Metadata(
          Key   TEXT NOT NULL PRIMARY KEY,
          Value TEXT NOT NULL
        );
      SQL

      db.run <<~SQL
        CREATE TABLE LocalizedVocabMeaning(
          VocabId  INTEGER NOT NULL,
          Language TEXT    NOT NULL,
          Meaning  TEXT    NOT NULL,
          PRIMARY KEY(VocabId, Language, Meaning)
        ) WITHOUT ROWID;
      SQL

      db.run <<~SQL
        CREATE INDEX IX_LocalizedVocabMeaning_Language_VocabId
          ON LocalizedVocabMeaning(Language, VocabId);
      SQL

      db.run <<~SQL
        CREATE VIRTUAL TABLE LocalizedVocabSearchFts USING fts4(
          VocabId, Language, Meanings,
          notindexed=VocabId,
          tokenize=unicode61
        );
      SQL
    end

    # A restriction list of nil/[]/["*"] means "applies to everything".
    def self.unrestricted?(list)
      list.nil? || list.empty? || list.include?('*')
    end

    # Build (writing, reading, [uk_meaning, ...]) triples for all senses of an entry
    # that carry Ukrainian glosses, respecting sense-level applies_to_written /
    # applies_to_readings and reading-level applies_to_written_forms restrictions.
    # Restriction values are literal form/reading texts, with "*" as wildcard.
    #
    # Returns Array<[writing_or_nil, reading, [String]]>.
    def self.build_candidate_pairs(entry)
      all_writings = entry.written_forms.map(&:text)
      pairs = []

      entry.senses.each do |sense|
        uk_meanings = build_uk_meanings(sense)
        next if uk_meanings.empty?

        sense_writings = unrestricted?(sense.applies_to_written) ? all_writings : sense.applies_to_written
        readings = entry.readings.select do |rd|
          unrestricted?(sense.applies_to_readings) || sense.applies_to_readings.include?(rd.text)
        end

        readings.each do |rd|
          if sense_writings.empty? || rd.no_kanji
            # Kana-only entry or kana-only reading: match VocabSet rows keyed by kana.
            pairs << [nil, rd.text, uk_meanings]
          else
            writings = if unrestricted?(rd.applies_to_written_forms)
              sense_writings
            else
              sense_writings & rd.applies_to_written_forms
            end
            writings.each { |w| pairs << [w, rd.text, uk_meanings] }
          end
        end
      end

      pairs
    end

    # Produce meaning strings for a sense's Ukrainian glosses.
    # qualifier is appended as " (qualifier)" if present.
    def self.build_uk_meanings(sense)
      sense.ukrainian_glosses.map do |g|
        q = g.qualifier
        q.nil? || q.empty? ? g.text : "#{g.text} (#{q})"
      end
    end

    # Copy rows from a donor overlay into db, skipping VocabIds that jibiki covers.
    def self.merge_donor(db, donor_path, covered_vocab_ids)
      donor = Sequel.sqlite(donor_path, readonly: true)
      covered_set = Set.new(covered_vocab_ids)

      donor[:LocalizedVocabMeaning].each do |row|
        next if row[:Language] == LANGUAGE && covered_set.include?(row[:VocabId])
        db[:LocalizedVocabMeaning].insert(
          VocabId: row[:VocabId],
          Language: row[:Language],
          Meaning: row[:Meaning]
        )
      end
    ensure
      donor&.disconnect
    end
  end
end
