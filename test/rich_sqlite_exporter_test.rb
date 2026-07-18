# frozen_string_literal: true

require 'minitest/autorun'
require 'tmpdir'
require 'tempfile'
require 'stringio'
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

  # ---------------------------------------------------------------------------
  # vocab_mapping tests
  # ---------------------------------------------------------------------------

  ASOKO_ORG = <<~ORG
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
    ** JMdict metadata
    *** Parts of speech
    - pn
    ** English glosses
    - there
    ** Ukrainian glosses
    *** uk-s-1000320-001-001
    :PROPERTIES:
    :QUALIFIER: neutral
    :STATUS: reviewed
    :AUTHOR_ID: antigravity
    :TRANSLATED_AT: 2026-07-16
    :SOURCE_TYPE: original
    :LICENSE: CC-BY-SA-4.0
    :END:
    - там
  ORG

  def build_base_db_with_rows(rows)
    # Keep a reference so the Tempfile is not finalized (which unlinks the file).
    @base_tempfile = Tempfile.new(["base_db", ".sqlite"])
    path = @base_tempfile.path
    db   = Sequel.sqlite(path)
    db.create_table(:VocabSet) do
      Integer :ID,          primary_key: true
      String  :KanjiWriting
      String  :KanaWriting, null: false
      Integer :IsMain,      null: false
      Integer :GroupId,     null: false
    end
    rows.each { |r| db[:VocabSet].insert({ GroupId: r[:ID] }.merge(r)) }
    db.disconnect
    path
  end

  def test_vocab_mapping_empty_when_no_base_db
    entry_file = Tempfile.new(["entry", ".org"])
    entry_file.write(ASOKO_ORG)
    entry_file.close

    entry = OrgEntry.load(entry_file.path)

    Dir.mktmpdir do |tmpdir|
      output = File.join(tmpdir, "jibiki.sqlite")
      Exporters::RichSqlite.export([entry], output)
      db = Sequel.sqlite(output, readonly: true)
      assert_equal 0, db[:vocab_mapping].count
      db.disconnect
    end
  ensure
    entry_file&.unlink
  end

  def test_vocab_mapping_populated_when_base_db_matches
    entry_file = Tempfile.new(["entry", ".org"])
    entry_file.write(ASOKO_ORG)
    entry_file.close

    entry = OrgEntry.load(entry_file.path)

    base_rows = [
      { ID: 4001, KanjiWriting: "彼処", KanaWriting: "あそこ", IsMain: 1 },
      { ID: 4002, KanjiWriting: "彼処", KanaWriting: "あそこ", IsMain: 0 }
    ]
    base_path = build_base_db_with_rows(base_rows)

    Dir.mktmpdir do |tmpdir|
      output = File.join(tmpdir, "jibiki.sqlite")
      Exporters::RichSqlite.export([entry], output, vocab_mapping_base: base_path)
      db = Sequel.sqlite(output, readonly: true)

      rows = db[:vocab_mapping].where(jmdict_id: 1_000_320).order(:vocab_id).all
      assert_equal 2, rows.size

      assert_equal 4001, rows[0][:vocab_id]
      assert_equal "彼処", rows[0][:writing]
      assert_equal "あそこ", rows[0][:reading]
      assert_equal 1, rows[0][:is_main]

      assert_equal 4002, rows[1][:vocab_id]
      assert_equal 0, rows[1][:is_main]

      # Metadata key present
      assert_equal base_path, db[:metadata].where(key: "VocabMappingBase").get(:value)

      db.disconnect
    end
  ensure
    entry_file&.unlink
    FileUtils.rm_f(base_path) if base_path
  end

  def test_lookup_indexes_exist
    entry_file = Tempfile.new(["entry", ".org"])
    entry_file.write(ASOKO_ORG)
    entry_file.close

    entry = OrgEntry.load(entry_file.path)

    Dir.mktmpdir do |tmpdir|
      output = File.join(tmpdir, "jibiki.sqlite")
      Exporters::RichSqlite.export([entry], output)
      db = Sequel.sqlite(output, readonly: true)
      %i[written_forms senses examples ukrainian_glosses vocab_mapping].each do |table|
        assert db.indexes(table).any?, "expected a lookup index on #{table}"
      end
      db.disconnect
    end
  ensure
    entry_file&.unlink
  end

  def test_vocab_mapping_falls_back_to_kana_only_base_row
    entry_file = Tempfile.new(["entry", ".org"])
    entry_file.write(ASOKO_ORG)
    entry_file.close

    entry = OrgEntry.load(entry_file.path)
    # Base dropped the rare kanji 彼処 and keeps あそこ kana-only.
    base_path = build_base_db_with_rows(
      [{ ID: 4010, KanjiWriting: nil, KanaWriting: "あそこ", IsMain: 1 }]
    )

    Dir.mktmpdir do |tmpdir|
      output = File.join(tmpdir, "jibiki.sqlite")
      Exporters::RichSqlite.export([entry], output, vocab_mapping_base: base_path)
      db = Sequel.sqlite(output, readonly: true)
      assert_equal [4010], db[:vocab_mapping].select_map(:vocab_id)
      db.disconnect
    end
  ensure
    entry_file&.unlink
    FileUtils.rm_f(base_path) if base_path
  end

  def test_duplicate_jmdict_id_is_skipped_with_warning
    entry_file = Tempfile.new(["entry", ".org"])
    entry_file.write(ASOKO_ORG)
    entry_file.close

    entry_a = OrgEntry.load(entry_file.path)
    entry_b = OrgEntry.load(entry_file.path)

    Dir.mktmpdir do |tmpdir|
      output = File.join(tmpdir, "jibiki.sqlite")
      warnings = StringIO.new
      Exporters::RichSqlite.export([entry_a, entry_b], output, warning_io: warnings)
      db = Sequel.sqlite(output, readonly: true)
      assert_equal 1, db[:entries].count
      assert_equal "1", db[:metadata].where(key: "EntryCount").get(:value)
      assert_includes warnings.string, "1000320"
      db.disconnect
    end
  ensure
    entry_file&.unlink
  end

  def test_vocab_mapping_empty_for_unmatched_entry
    entry_file = Tempfile.new(["entry", ".org"])
    entry_file.write(ASOKO_ORG)
    entry_file.close

    entry = OrgEntry.load(entry_file.path)
    base_path = build_base_db_with_rows([])  # empty — no VocabSet rows

    Dir.mktmpdir do |tmpdir|
      output = File.join(tmpdir, "jibiki.sqlite")
      Exporters::RichSqlite.export([entry], output, vocab_mapping_base: base_path)
      db = Sequel.sqlite(output, readonly: true)
      assert_equal 0, db[:vocab_mapping].count
      db.disconnect
    end
  ensure
    entry_file&.unlink
    FileUtils.rm_f(base_path) if base_path
  end
end
