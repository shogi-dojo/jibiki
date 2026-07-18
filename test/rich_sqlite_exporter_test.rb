# frozen_string_literal: true

require 'minitest/autorun'
require 'tmpdir'
require 'sequel'
require_relative '../lib/org_entry'
require_relative '../lib/exporters/rich_sqlite'

class RichSqliteExporterTest < Minitest::Test
  def test_export_builds_valid_database_with_correct_structure
    content = <<~ORG
      #+TITLE: 彼処
      #+JMDICT_ID: 1000320
      #+SCHEMA_VERSION: 2
      #+PRIMARY_READING: あそこ
      #+ROMAJI: asoko
      #+ENTRY_STATUS: reviewed
      #+QUALITY_PROFILE: learner
      #+JMDICT_SOURCE_SHA256: 08cfdf99863a0859570db7f7e0c8ab49dce8dea1fd090c3b99464fc12d20c81e
      #+CREATED_AT: 2026-07-17
      #+DEFAULT_AUTHOR_ID: antigravity
      #+DEFAULT_LICENSE: CC-BY-SA-4.0
      #+DEFAULT_SOURCE_TYPE: original
      #+DEFAULT_STATUS: reviewed

      * Forms
      ** Written form wf-1000320-001
      :PROPERTIES:
      :TEXT: 彼処
      :END:
      *** Information
      - rK
      ** Reading rd-1000320-001
      :PROPERTIES:
      :TEXT: あそこ
      :NO_KANJI: false
      :END:
      *** Applies to written forms
      - *
      *** Priorities
      - ichi1
      * Sense s-1000320-001
      :PROPERTIES:
      :SOURCE_SENSE_INDEX: 1
      :SOURCE_FINGERPRINT: 2329ffc1ac38e601148cd757a2fa0de10b12b37594f0e379b19d9d08868b96e8
      :LEARNER_PRIORITY: primary
      :END:
      ** Applies to forms
      *** Written forms
      - *
      *** Readings
      - あそこ
      ** JMdict metadata
      *** Parts of speech
      - pn
      ** English glosses
      - there
      - over there
      ** Ukrainian glosses
      *** uk-s-1000320-001-001
      :PROPERTIES:
      :END:
      - text :: там
      - qualifier :: neutral
      ** Russian reference
      - 12 :: : {～に} (уст.) там
      ** Learner notes
      *** note-s-1000320-001-001
      :PROPERTIES:
      :END:
      - UK :: Вказівний займенник.
      ** Examples
      *** ex-1000320-001-001
      :PROPERTIES:
      :LEVEL: beginner
      :REGISTER: neutral
      :END:
      - JA :: あそこは病院です。
      - READING :: あそこはびょういんです。
      - UK :: Там знаходиться лікарня.
    ORG

    doc = OrgEntry::Document.parse(content)
    entry = OrgEntry::Entry.new(doc)

    Dir.mktmpdir do |dir|
      db_path = File.join(dir, 'jibiki.sqlite')
      Exporters::RichSqlite.export([entry], db_path)

      assert File.exist?(db_path)

      db = Sequel.sqlite(db_path)
      begin
        # Verify metadata
        assert_equal '1', db[:metadata].filter(key: 'SchemaVersion').first[:value]
        assert_equal '1', db[:metadata].filter(key: 'EntryCount').first[:value]
        assert_equal 'CC-BY-SA-4.0', db[:metadata].filter(key: 'License').first[:value]
        assert_equal entry.created_at, db[:entries].first[:created_at]

        # Verify entry
        assert_equal 1000320, db[:entries].first[:jmdict_id]
        assert_equal '彼処', db[:entries].first[:title]
        assert_equal 'asoko', db[:entries].first[:romaji]

        # Verify written form
        wf = db[:written_forms].first
        assert_equal 'wf-1000320-001', wf[:id]
        assert_equal '彼処', wf[:text]
        assert_equal '["rK"]', wf[:information]

        # Verify reading
        rd = db[:readings].first
        assert_equal 'rd-1000320-001', rd[:id]
        assert_equal 'あそこ', rd[:text]
        assert_equal 0, rd[:no_kanji] # false/boolean represented as 0

        # Verify sense
        sense = db[:senses].first
        assert_equal 's-1000320-001', sense[:id]
        assert_equal 1, sense[:source_sense_index]
        assert_equal 'primary', sense[:learner_priority]

        # Verify English glosses
        eg = db[:english_glosses].all
        assert_equal 2, eg.length
        assert_equal 'there', eg[0][:text]
        assert_equal 'over there', eg[1][:text]

        # Verify Ukrainian glosses
        ug = db[:ukrainian_glosses].first
        assert_equal 'uk-s-1000320-001-001', ug[:id]
        assert_equal 'там', ug[:text]
        assert_equal 'neutral', ug[:qualifier]

        # Verify Russian references
        rr = db[:russian_references].first
        assert_equal 12, rr[:source_sense_index]
        assert_equal ': {～に} (уст.) там', rr[:text]

        # Verify learner notes
        note = db[:learner_notes].first
        assert_equal 'Вказівний займенник.', note[:uk]

        # Verify examples
        ex = db[:examples].first
        assert_equal 'あそこは病院です。', ex[:ja]
        assert_equal 'Там знаходиться лікарня.', ex[:uk]

        # Verify FTS search
        search_results = db[:entry_search].filter(Sequel.lit("entry_search MATCH 'там'")).all
        assert_equal 1, search_results.length
        assert_equal 1000320, search_results.first[:jmdict_id]
      ensure
        db.disconnect
      end
    end
  end
end
