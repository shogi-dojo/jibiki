# frozen_string_literal: true

require 'sequel'
require 'json'
require 'fileutils'
require 'time'
require_relative 'rich_schema'
require_relative 'houhou_vocab_matcher'

module Exporters
  class RichSqlite
    def self.export(entries, output_path, vocab_mapping_base: nil, warning_io: $stderr)
      # entries.jmdict_id is the primary key; the corpus occasionally holds the
      # same JMdict entry under two files (reading aliases). Keep the first,
      # report the rest — merging them is editorial work, not export work.
      seen = {}
      entries = entries.select do |entry|
        if seen.key?(entry.jmdict_id)
          warning_io.puts "DUPLICATE JMDICT_ID #{entry.jmdict_id}: skipping #{entry.romaji} (kept #{seen[entry.jmdict_id]})"
          false
        else
          seen[entry.jmdict_id] = entry.romaji
          true
        end
      end

      building_path = "#{output_path}.building"
      FileUtils.mkdir_p(File.dirname(output_path))
      FileUtils.rm_f(building_path)

      matcher = vocab_mapping_base ? HouhouVocabMatcher.new(vocab_mapping_base) : nil

      db = Sequel.sqlite(building_path)
      begin
        RichSchema.create_tables(db)

        git_commit = get_git_commit
        notice_path = File.expand_path('../../NOTICE', __dir__)
        attribution = File.exist?(notice_path) ? File.read(notice_path, encoding: 'UTF-8') : ''

        db.transaction do
          entries.each do |entry|
            db[:entries].insert(
              jmdict_id: entry.jmdict_id,
              title: entry.title,
              primary_reading: entry.primary_reading,
              romaji: entry.romaji,
              entry_status: entry.entry_status,
              quality_profile: entry.quality_profile,
              created_at: entry.created_at,
              updated_at: entry.updated_at
            )

            entry.written_forms.each_with_index do |wf, idx|
              db[:written_forms].insert(
                id: wf.id,
                jmdict_id: entry.jmdict_id,
                position: idx + 1,
                text: wf.text,
                information: JSON.generate(wf.information),
                priorities: JSON.generate(wf.priorities)
              )
            end

            entry.readings.each_with_index do |rd, idx|
              db[:readings].insert(
                id: rd.id,
                jmdict_id: entry.jmdict_id,
                position: idx + 1,
                text: rd.text,
                no_kanji: rd.no_kanji ? 1 : 0,
                applies_to_written_forms: JSON.generate(rd.applies_to_written_forms),
                information: JSON.generate(rd.information),
                priorities: JSON.generate(rd.priorities)
              )
            end

            entry.senses.each_with_index do |sense, idx|
              db[:senses].insert(
                id: sense.id,
                jmdict_id: entry.jmdict_id,
                position: idx + 1,
                source_sense_index: sense.source_sense_index,
                learner_priority: sense.learner_priority,
                applies_to_written: JSON.generate(sense.applies_to_written),
                applies_to_readings: JSON.generate(sense.applies_to_readings),
                parts_of_speech: JSON.generate(sense.parts_of_speech),
                misc: JSON.generate(sense.miscellaneous),
                fields: JSON.generate(sense.fields),
                dialects: JSON.generate(sense.dialects),
                sense_information: JSON.generate(sense.sense_information)
              )

              sense.english_glosses.each_with_index do |eg, e_idx|
                db[:english_glosses].insert(
                  sense_id: sense.id,
                  position: e_idx + 1,
                  text: eg.text,
                  gloss_type: eg.type,
                  lang: eg.lang,
                  gender: eg.gender
                )
              end

              sense.ukrainian_glosses.each_with_index do |ug, u_idx|
                db[:ukrainian_glosses].insert(
                  id: ug.id,
                  sense_id: sense.id,
                  position: u_idx + 1,
                  text: ug.text,
                  qualifier: ug.qualifier,
                  status: ug.status,
                  translator_id: ug.translator_id,
                  translated_at: ug.translated_at,
                  reviewer_id: ug.reviewer_id,
                  reviewed_at: ug.reviewed_at,
                  source_type: ug.source_type,
                  license: ug.license
                )
              end

              sense.russian_references.each_with_index do |rr, r_idx|
                db[:russian_references].insert(
                  sense_id: sense.id,
                  position: r_idx + 1,
                  source_sense_index: rr.source_sense_index,
                  text: rr.text
                )
              end

              sense.learner_notes.each_with_index do |note, n_idx|
                db[:learner_notes].insert(
                  id: note.id,
                  sense_id: sense.id,
                  position: n_idx + 1,
                  uk: note.uk,
                  level: note.level,
                  register: note.register,
                  status: note.status,
                  author_id: note.author_id,
                  created_at: note.created_at,
                  license: note.license,
                  source_type: note.source_type
                )
              end

              sense.collocations.each_with_index do |col, c_idx|
                db[:collocations].insert(
                  id: col.id,
                  sense_id: sense.id,
                  position: c_idx + 1,
                  ja: col.ja,
                  reading: col.reading,
                  uk: col.uk,
                  pattern: col.pattern,
                  register: col.register,
                  status: col.status,
                  author_id: col.author_id,
                  created_at: col.created_at,
                  license: col.license,
                  source_type: col.source_type
                )
              end

              sense.constructions.each_with_index do |con, c_idx|
                db[:constructions].insert(
                  id: con.id,
                  sense_id: sense.id,
                  position: c_idx + 1,
                  relation: con.relation,
                  target: con.target,
                  target_id: con.target_id,
                  status: con.status,
                  author_id: con.author_id,
                  created_at: con.created_at,
                  license: con.license,
                  source_type: con.source_type
                )
              end

              sense.related_words.each_with_index do |rw, r_idx|
                db[:related_words].insert(
                  id: rw.id,
                  sense_id: sense.id,
                  position: r_idx + 1,
                  relation: rw.relation,
                  target: rw.target,
                  target_id: rw.target_id,
                  status: rw.status,
                  author_id: rw.author_id,
                  created_at: rw.created_at,
                  license: rw.license,
                  source_type: rw.source_type
                )
              end

              sense.idioms.each_with_index do |idm, i_idx|
                db[:idioms].insert(
                  id: idm.id,
                  sense_id: sense.id,
                  position: i_idx + 1,
                  ja: idm.ja,
                  reading: idm.reading,
                  uk: idm.uk,
                  en: idm.en,
                  level: idm.level,
                  register: idm.register,
                  status: idm.status,
                  author_id: idm.author_id,
                  created_at: idm.created_at,
                  license: idm.license,
                  source_type: idm.source_type
                )
              end

              sense.examples.each_with_index do |ex, e_idx|
                db[:examples].insert(
                  id: ex.id,
                  sense_id: sense.id,
                  position: e_idx + 1,
                  ja: ex.ja,
                  reading: ex.reading,
                  romaji: ex.romaji,
                  uk: ex.uk,
                  en: ex.en,
                  focus: ex.focus,
                  level: ex.level,
                  register: ex.register,
                  status: ex.status,
                  author_id: ex.author_id,
                  created_at: ex.created_at,
                  license: ex.license,
                  source_type: ex.source_type,
                  source_id: ex.source_id,
                  source_url: ex.source_url
                )
              end
            end

            entry.pronunciations.each do |pa|
              db[:pitch_accents].insert(
                id: pa.id,
                jmdict_id: entry.jmdict_id,
                reading_id: pa.target_id,
                system: pa.system,
                mora_count: pa.mora_count,
                drop_after: pa.drop_after,
                pattern: pa.pattern,
                mora_pattern: pa.mora_pattern,
                context: pa.context,
                source_id: pa.source_id,
                source_version: pa.source_version,
                source_url: pa.source_url,
                license: pa.license,
                status: pa.status,
                verified_at: pa.verified_at
              )
            end

            writings = entry.written_forms.map(&:text).join(' ')
            readings = entry.readings.map(&:text).join(' ')
            romaji = entry.romaji
            uk_glosses = entry.senses.flat_map { |s| s.ukrainian_glosses.map(&:text) }.join(' ')
            en_glosses = entry.senses.flat_map { |s| s.english_glosses.map(&:text) }.join(' ')

            db[:entry_search].insert(
              jmdict_id: entry.jmdict_id,
              writings: writings,
              readings: readings,
              romaji: romaji,
              uk_glosses: uk_glosses,
              en_glosses: en_glosses
            )

            # Populate vocab_mapping when a base VocabSet DB is provided.
            if matcher
              rows = build_vocab_mapping_rows(entry)
              matched_pairs = rows.flat_map do |writing, reading|
                matcher.lookup(writing: writing, reading: reading).map { |m| [writing, reading, m] }
              end
              # Same fallbacks as the overlay exporter: kana-only base row,
              # then unambiguous reading match.
              if matched_pairs.empty?
                matched_pairs = rows.flat_map do |_writing, reading|
                  matches = matcher.lookup(writing: nil, reading: reading)
                  matches = matcher.lookup_by_reading(reading) if matches.empty?
                  matches.map { |m| [nil, reading, m] }
                end
              end

              matched_pairs.each do |writing, reading, m|
                db[:vocab_mapping].insert(
                  jmdict_id: entry.jmdict_id,
                  vocab_id:  m[:vocab_id],
                  writing:   writing,
                  reading:   reading,
                  is_main:   m[:is_main] ? 1 : 0
                )
              rescue Sequel::UniqueConstraintViolation
                # duplicate (jmdict_id, vocab_id) — skip
              end
            end
          end

          db[:metadata].insert(key: 'SchemaVersion', value: '1')
          db[:metadata].insert(key: 'GeneratorCommit', value: git_commit)
          db[:metadata].insert(key: 'GeneratedAt', value: Time.now.utc.iso8601)
          db[:metadata].insert(key: 'EntryCount', value: entries.count.to_s)
          db[:metadata].insert(key: 'License', value: 'CC-BY-SA-4.0')
          db[:metadata].insert(key: 'Attribution', value: attribution)
          db[:metadata].insert(key: 'VocabMappingBase', value: vocab_mapping_base) if vocab_mapping_base
        end

        check = db['PRAGMA integrity_check'].first.values.first
        unless check == 'ok'
          raise "SQLite integrity check failed: #{check}"
        end

        db.run 'VACUUM;'
        db.disconnect
        db = nil

        FileUtils.mv(building_path, output_path)
      ensure
        db&.disconnect
        matcher&.close
        FileUtils.rm_f(building_path)
      end
    end

    # Return (writing_or_nil, reading) pairs for all reading×written-form combinations
    # of an entry, respecting no_kanji and applies_to restrictions.
    def self.build_vocab_mapping_rows(entry)
      pairs = []
      writings = entry.written_forms.map(&:text)

      if writings.empty?
        # Kana-only: use nil writing + each reading
        entry.readings.each { |rd| pairs << [nil, rd.text] }
      else
        writings.each do |writing|
          applicable = entry.readings.select do |rd|
            next false if rd.no_kanji
            applies = rd.applies_to_written_forms
            applies.empty? || applies.include?('*') || applies.include?(writing)
          end
          applicable.each { |rd| pairs << [writing, rd.text] }
        end
        # Kana-only readings pair without a writing even when the entry has
        # kanji forms (Houhou keys such rows by kana alone).
        entry.readings.select(&:no_kanji).each { |rd| pairs << [nil, rd.text] }
      end

      pairs.uniq
    end

    def self.get_git_commit
      `git rev-parse HEAD`.strip
    rescue
      ''
    end

    private_class_method :build_vocab_mapping_rows, :get_git_commit
  end
end
