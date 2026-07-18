# frozen_string_literal: true

require "minitest/autorun"
require "tmpdir"
require "fileutils"
require "stringio"
require "sequel"
require_relative "../lib/org_entry"
require_relative "../lib/exporters/houhou_overlay"
require_relative "../lib/exporters/houhou_vocab_matcher"

class HouhouOverlayTest < Minitest::Test
  def setup
    @tmpdir = Dir.mktmpdir
    @file_seq = 0
  end

  def teardown
    FileUtils.remove_entry(@tmpdir)
  end

  # Unique path inside the per-test tmpdir (Tempfile#path alone is unsafe: the
  # unreferenced Tempfile can be finalized and unlink the file mid-test).
  def tmp_path(basename)
    @file_seq += 1
    File.join(@tmpdir, "#{@file_seq}_#{basename}")
  end

  # -------------------------------------------------------------------------
  # Fixture helpers — build REAL OrgEntry objects from Org source so the
  # exporter is tested against the actual model API, not stand-ins.
  # -------------------------------------------------------------------------

  # readings: [{ text:, no_kanji: false, applies_to: ['*'] }, ...]
  # senses:   [{ uk: [{ text:, qualifier: nil }, ...],
  #              applies_to_written: nil, applies_to_readings: nil }, ...]
  def build_entry(jmdict_id:, title:, writings: [], readings: [], senses: [])
    num = ->(i) { format("%03d", i + 1) }
    org = +""
    org << "#+TITLE: #{title}\n"
    org << "#+JMDICT_ID: #{jmdict_id}\n"
    org << "#+SCHEMA_VERSION: 2\n"
    org << "#+PRIMARY_READING: #{readings.first[:text]}\n"
    org << "#+ROMAJI: test\n"
    org << "#+ENTRY_STATUS: draft\n"
    org << "#+QUALITY_PROFILE: learner\n"
    org << "#+JMDICT_SOURCE_SHA256: #{'0' * 64}\n"
    org << "\n* Forms\n"
    writings.each_with_index do |w, i|
      org << "** Written form wf-#{jmdict_id}-#{num.call(i)}\n"
      org << ":PROPERTIES:\n:TEXT: #{w}\n:END:\n"
    end
    readings.each_with_index do |r, i|
      org << "** Reading rd-#{jmdict_id}-#{num.call(i)}\n"
      org << ":PROPERTIES:\n:TEXT: #{r[:text]}\n:NO_KANJI: #{r[:no_kanji] ? 'true' : 'false'}\n:END:\n"
      org << "*** Applies to written forms\n"
      (r[:applies_to] || ["*"]).each { |a| org << "- #{a}\n" }
    end
    senses.each_with_index do |s, i|
      sid = "s-#{jmdict_id}-#{num.call(i)}"
      org << "* Sense #{sid}\n"
      org << ":PROPERTIES:\n:SOURCE_SENSE_INDEX: #{i + 1}\n:SOURCE_FINGERPRINT: #{'ab' * 8}\n:END:\n"
      if s[:applies_to_written] || s[:applies_to_readings]
        org << "** Applies to forms\n*** Written forms\n"
        (s[:applies_to_written] || ["*"]).each { |a| org << "- #{a}\n" }
        org << "*** Readings\n"
        (s[:applies_to_readings] || ["*"]).each { |a| org << "- #{a}\n" }
      end
      org << "** English glosses\n- placeholder\n"
      org << "** Ukrainian glosses\n"
      (s[:uk] || []).each_with_index do |g, gi|
        org << "*** uk-#{sid}-#{num.call(gi)}\n"
        org << ":PROPERTIES:\n:TRANSLATOR_ID: test\n:TRANSLATED_AT: 2026-01-01\n:END:\n"
        org << "- text :: #{g[:text]}\n"
        org << "- qualifier :: #{g[:qualifier]}\n" if g[:qualifier]
      end
    end
    OrgEntry.parse(org)
  end

  # Build a tiny KanjiDatabase-shaped base DB and return its path.
  def build_base_db(rows)
    path = tmp_path("base_db.sqlite")
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

  # Run the overlay exporter. Returns [stats, output_path, db, unmatched_log].
  def run_export(entries, base_rows, base_overlay_path: nil)
    base_path = build_base_db(base_rows)
    output    = tmp_path("overlay.sqlite")

    unmatched_log = StringIO.new
    stats = Exporters::HouhouOverlay.export(
      entries,
      output,
      base_db_path:      base_path,
      base_overlay_path: base_overlay_path,
      unmatched_io:      unmatched_log
    )
    db = Sequel.sqlite(output, readonly: true)
    [stats, output, db, unmatched_log.string]
  ensure
    FileUtils.rm_f(base_path) if base_path
  end

  WAKARU_ROWS = [
    { ID: 1001, KanjiWriting: "分かる", KanaWriting: "わかる", IsMain: 1 },
    { ID: 1002, KanjiWriting: "分かる", KanaWriting: "わかる", IsMain: 0 }
  ].freeze

  def wakaru_entry
    build_entry(
      jmdict_id: 1_606_560,
      title: "分かる",
      writings: ["分かる"],
      readings: [{ text: "わかる" }],
      senses: [{ uk: [{ text: "розуміти" }, { text: "знати" }] }]
    )
  end

  # -------------------------------------------------------------------------
  # Schema tests
  # -------------------------------------------------------------------------

  def test_required_tables_exist
    _stats, _out, db = run_export([], [])
    assert db.table_exists?(:Metadata),              "Metadata table missing"
    assert db.table_exists?(:LocalizedVocabMeaning), "LocalizedVocabMeaning table missing"
    tables_and_views = db.tables + db.views
    assert tables_and_views.map(&:to_s).include?("LocalizedVocabSearchFts"), \
      "LocalizedVocabSearchFts FTS table missing"
    db.disconnect
  end

  def test_schema_version_is_1
    _stats, _out, db = run_export([], [])
    assert_equal "1", db[:Metadata].where(Key: "SchemaVersion").get(:Value)
    db.disconnect
  end

  def test_metadata_ukrainian_source_key_present
    _stats, _out, db = run_export([], [])
    assert_equal "jibiki", db[:Metadata].where(Key: "UkrainianSource").get(:Value)
    db.disconnect
  end

  # -------------------------------------------------------------------------
  # Meaning insertion tests
  # -------------------------------------------------------------------------

  def test_meanings_inserted_for_matched_entry
    _stats, _out, db = run_export([wakaru_entry], WAKARU_ROWS)
    meanings = db[:LocalizedVocabMeaning].where(Language: "uk").select_map(:Meaning)
    assert_includes meanings, "розуміти"
    assert_includes meanings, "знати"
    db.disconnect
  end

  def test_meanings_have_correct_language
    _stats, _out, db = run_export([wakaru_entry], WAKARU_ROWS)
    assert_equal ["uk"], db[:LocalizedVocabMeaning].select_map(:Language).uniq
    db.disconnect
  end

  def test_meanings_associated_with_correct_vocab_ids
    _stats, _out, db = run_export([wakaru_entry], WAKARU_ROWS)
    ids = db[:LocalizedVocabMeaning].where(Language: "uk").select_map(:VocabId)
    assert_equal [1001, 1002], ids.uniq.sort
    db.disconnect
  end

  def test_glosses_from_all_senses_are_exported
    # Regression: glosses from senses after the first must not be dropped.
    entry = build_entry(
      jmdict_id: 1_606_560,
      title: "分かる",
      writings: ["分かる"],
      readings: [{ text: "わかる" }],
      senses: [
        { uk: [{ text: "розуміти" }] },
        { uk: [{ text: "знати" }] },
        { uk: [{ text: "збагнути" }] }
      ]
    )
    _stats, _out, db = run_export([entry], WAKARU_ROWS)
    meanings = db[:LocalizedVocabMeaning].where(VocabId: 1001, Language: "uk").select_map(:Meaning)
    assert_equal %w[збагнути знати розуміти], meanings.sort
    db.disconnect
  end

  def test_sense_writing_restriction_limits_vocab_ids
    # A sense restricted to one written form must not attach to the other form's VocabId.
    entry = build_entry(
      jmdict_id: 1_600_900,
      title: "話",
      writings: %w[話 話し],
      readings: [{ text: "はなし" }],
      senses: [
        { uk: [{ text: "розмова" }] },
        { uk: [{ text: "оповідання" }], applies_to_written: ["話"] }
      ]
    )
    base = [
      { ID: 2001, KanjiWriting: "話",   KanaWriting: "はなし", IsMain: 1 },
      { ID: 2002, KanjiWriting: "話し", KanaWriting: "はなし", IsMain: 0 }
    ]
    _stats, _out, db = run_export([entry], base)
    restricted = db[:LocalizedVocabMeaning].where(VocabId: 2002, Language: "uk").select_map(:Meaning)
    refute_includes restricted, "оповідання"
    unrestricted = db[:LocalizedVocabMeaning].where(VocabId: 2001, Language: "uk").select_map(:Meaning)
    assert_includes unrestricted, "оповідання"
    assert_includes restricted, "розмова"
    db.disconnect
  end

  def test_reading_restriction_limits_writings
    # A reading restricted to one written form must not pair with the other.
    entry = build_entry(
      jmdict_id: 1_580_320,
      title: "二十",
      writings: %w[二十 廿],
      readings: [{ text: "はたち", applies_to: ["二十"] }],
      senses: [{ uk: [{ text: "двадцять років" }] }]
    )
    base = [
      { ID: 3001, KanjiWriting: "二十", KanaWriting: "はたち", IsMain: 1 },
      { ID: 3002, KanjiWriting: "廿",   KanaWriting: "はたち", IsMain: 0 }
    ]
    _stats, _out, db = run_export([entry], base)
    ids = db[:LocalizedVocabMeaning].where(Language: "uk").select_map(:VocabId).uniq
    assert_equal [3001], ids
    db.disconnect
  end

  def test_kana_only_entry_matches_kana_keyed_row
    entry = build_entry(
      jmdict_id: 1_000_320,
      title: "あそこ",
      writings: [],
      readings: [{ text: "あそこ", no_kanji: true }],
      senses: [{ uk: [{ text: "там" }] }]
    )
    base = [{ ID: 4001, KanjiWriting: nil, KanaWriting: "あそこ", IsMain: 1 }]
    _stats, _out, db = run_export([entry], base)
    meanings = db[:LocalizedVocabMeaning].where(VocabId: 4001, Language: "uk").select_map(:Meaning)
    assert_includes meanings, "там"
    db.disconnect
  end

  def test_fallback_matches_kana_only_base_row_when_kanji_forms_missed
    # jibiki keeps rare-kanji forms (rK) that Houhou's base drops, leaving a
    # kana-only row — the entry must still match by reading.
    entry = build_entry(
      jmdict_id: 1_050_390,
      title: "コップ",
      writings: %w[洋杯 洋盃],
      readings: [{ text: "コップ" }],
      senses: [{ uk: [{ text: "склянка" }] }]
    )
    base = [{ ID: 7161, KanjiWriting: nil, KanaWriting: "コップ", IsMain: 1 }]
    stats, _out, db = run_export([entry], base)
    meanings = db[:LocalizedVocabMeaning].where(VocabId: 7161, Language: "uk").select_map(:Meaning)
    assert_includes meanings, "склянка"
    assert_equal 1, stats[:matched]
    db.disconnect
  end

  def test_fallback_matches_unambiguous_reading_when_base_kept_kanji
    # jibiki treats いいえ as kana-only, but Houhou's base kept the kanji 否 —
    # the reading is unambiguous (single group), so it must still match.
    entry = build_entry(
      jmdict_id: 1_583_250,
      title: "いいえ",
      writings: [],
      readings: [{ text: "いいえ" }],
      senses: [{ uk: [{ text: "ні" }] }]
    )
    base = [{ ID: 74_167, KanjiWriting: "否", KanaWriting: "いいえ", IsMain: 1 }]
    stats, _out, db = run_export([entry], base)
    meanings = db[:LocalizedVocabMeaning].where(VocabId: 74_167, Language: "uk").select_map(:Meaning)
    assert_includes meanings, "ні"
    assert_equal 1, stats[:matched]
    db.disconnect
  end

  def test_fallback_refuses_ambiguous_homophones
    # A kana-only entry whose reading maps to multiple base groups must stay
    # unmatched rather than attach glosses to the wrong homophone.
    entry = build_entry(
      jmdict_id: 6_666_666,
      title: "はし",
      writings: [],
      readings: [{ text: "はし", no_kanji: true }],
      senses: [{ uk: [{ text: "щось" }] }]
    )
    base = [
      { ID: 5001, KanjiWriting: "橋", KanaWriting: "はし", IsMain: 1, GroupId: 50 },
      { ID: 5002, KanjiWriting: "箸", KanaWriting: "はし", IsMain: 1, GroupId: 51 }
    ]
    stats, _out, db = run_export([entry], base)
    assert_equal 1, stats[:unmatched]
    assert_equal 0, db[:LocalizedVocabMeaning].count
    db.disconnect
  end

  def test_qualifier_appended_to_meaning
    entry = build_entry(
      jmdict_id: 9_999_999,
      title: "食べる",
      writings: ["食べる"],
      readings: [{ text: "たべる" }],
      senses: [{ uk: [{ text: "їсти", qualifier: "розм." }] }]
    )
    base = [{ ID: 5001, KanjiWriting: "食べる", KanaWriting: "たべる", IsMain: 1 }]
    _stats, _out, db = run_export([entry], base)
    meanings = db[:LocalizedVocabMeaning].where(Language: "uk").select_map(:Meaning)
    assert_includes meanings, "їсти (розм.)"
    db.disconnect
  end

  def test_no_qualifier_suffix_when_qualifier_absent
    _stats, _out, db = run_export([wakaru_entry], WAKARU_ROWS)
    meanings = db[:LocalizedVocabMeaning].where(Language: "uk").select_map(:Meaning)
    assert meanings.none? { |m| m.include?("(") }
    db.disconnect
  end

  # -------------------------------------------------------------------------
  # FTS tests
  # -------------------------------------------------------------------------

  def test_fts_row_exists_for_uk_vocab
    _stats, _out, db = run_export([wakaru_entry], WAKARU_ROWS)
    refute_empty db[:LocalizedVocabSearchFts].where(Language: "uk").all
    db.disconnect
  end

  def test_fts_meanings_column_contains_all_meanings_space_joined
    _stats, _out, db = run_export([wakaru_entry], WAKARU_ROWS)
    rows = db["SELECT * FROM LocalizedVocabSearchFts WHERE Language='uk' AND VocabId=1001"].all
    assert_equal 1, rows.size
    fts_meanings = rows.first[:Meanings]
    assert_includes fts_meanings, "розуміти"
    assert_includes fts_meanings, "знати"
    db.disconnect
  end

  # -------------------------------------------------------------------------
  # Unmatched reporting tests
  # -------------------------------------------------------------------------

  def test_unmatched_entry_reported_to_io
    entry = build_entry(
      jmdict_id: 8_888_888,
      title: "存在しない",
      writings: ["存在しない"],
      readings: [{ text: "そんざいしない" }],
      senses: [{ uk: [{ text: "не існує" }] }]
    )
    _stats, _out, _db, log = run_export([entry], [])
    assert_includes log, "8888888"
  end

  def test_matched_entry_not_in_unmatched_report
    _stats, _out, _db, log = run_export([wakaru_entry], WAKARU_ROWS)
    refute_includes log, "1606560"
  end

  # -------------------------------------------------------------------------
  # Stats tests
  # -------------------------------------------------------------------------

  def test_stats_matched_count
    stats, = run_export([wakaru_entry], WAKARU_ROWS)
    assert_equal 1, stats[:matched]
  end

  def test_stats_unmatched_count_when_miss
    entry = build_entry(
      jmdict_id: 7_777_777,
      title: "ない",
      writings: [],
      readings: [{ text: "ない", no_kanji: true }],
      senses: [{ uk: [{ text: "немає" }] }]
    )
    stats, = run_export([entry], [])
    assert_equal 1, stats[:unmatched]
  end

  # -------------------------------------------------------------------------
  # Integrity check
  # -------------------------------------------------------------------------

  def test_integrity_check_passes
    _stats, _output, db = run_export([wakaru_entry], WAKARU_ROWS)
    assert_equal "ok", db["PRAGMA integrity_check"].first.values.first
    db.disconnect
  end

  # -------------------------------------------------------------------------
  # Merge mode tests
  # -------------------------------------------------------------------------

  def build_donor_overlay(rows)
    path = tmp_path("donor.sqlite")
    db   = Sequel.sqlite(path)
    db.run <<~SQL
      CREATE TABLE Metadata(Key TEXT NOT NULL PRIMARY KEY, Value TEXT NOT NULL);
    SQL
    db.run <<~SQL
      CREATE TABLE LocalizedVocabMeaning(
        VocabId INTEGER NOT NULL, Language TEXT NOT NULL, Meaning TEXT NOT NULL,
        PRIMARY KEY(VocabId, Language, Meaning)) WITHOUT ROWID;
    SQL
    db.run <<~SQL
      CREATE VIRTUAL TABLE LocalizedVocabSearchFts USING fts4(
        VocabId, Language, Meanings, notindexed=VocabId, tokenize=unicode61);
    SQL
    db[:Metadata].insert(Key: "SchemaVersion", Value: "1")
    rows.each { |r| db[:LocalizedVocabMeaning].insert(r) }
    db.disconnect
    path
  end

  def run_merge_export(entries, base_rows, donor_rows)
    donor_path = build_donor_overlay(donor_rows)
    _stats, _out, db, log = run_export(entries, base_rows, base_overlay_path: donor_path)
    [db, log]
  ensure
    FileUtils.rm_f(donor_path) if donor_path
  end

  def test_merge_copies_russian_rows_from_donor
    donor_rows = [{ VocabId: 9001, Language: "ru", Meaning: "понимать" }]
    db, = run_merge_export([], [], donor_rows)
    meanings = db[:LocalizedVocabMeaning].where(Language: "ru").select_map(:Meaning)
    assert_includes meanings, "понимать"
    db.disconnect
  end

  def test_merge_preserves_foreign_uk_rows_for_unmatched_vocab_ids
    donor_rows = [{ VocabId: 8888, Language: "uk", Meaning: "чужий запис" }]
    db, = run_merge_export([], [], donor_rows)
    meanings = db[:LocalizedVocabMeaning].where(VocabId: 8888, Language: "uk").select_map(:Meaning)
    assert_includes meanings, "чужий запис"
    db.disconnect
  end

  def test_merge_jibiki_wins_conflict_for_covered_vocab_id
    donor_rows = [{ VocabId: 1001, Language: "uk", Meaning: "старий запис" }]
    db, = run_merge_export([wakaru_entry], WAKARU_ROWS, donor_rows)
    meanings = db[:LocalizedVocabMeaning].where(VocabId: 1001, Language: "uk").select_map(:Meaning)
    refute_includes meanings, "старий запис"
    assert_includes meanings, "розуміти"
    db.disconnect
  end

  def test_merge_metadata_contains_merged_from_key
    donor_path = build_donor_overlay([{ VocabId: 7001, Language: "ru", Meaning: "тест" }])
    _stats, _out, db = run_export([], [], base_overlay_path: donor_path)
    refute_nil db[:Metadata].where(Key: "MergedFrom").get(:Value)
    db.disconnect
  ensure
    FileUtils.rm_f(donor_path) if donor_path
  end

  def test_no_merged_from_key_without_merge_mode
    _stats, _out, db = run_export([wakaru_entry], WAKARU_ROWS)
    assert_nil db[:Metadata].where(Key: "MergedFrom").get(:Value)
    db.disconnect
  end
end
