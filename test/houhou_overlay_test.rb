# frozen_string_literal: true

require "minitest/autorun"
require "tmpdir"
require "sequel"
require_relative "../lib/exporters/houhou_overlay"
require_relative "../lib/exporters/houhou_vocab_matcher"

# ---------------------------------------------------------------------------
# Minimal stub objects that mirror the shape HouhouOverlay expects from entries.
# ---------------------------------------------------------------------------

UkGloss     = Struct.new(:text, :qualifier)
RuReference = Struct.new(:text)

ReadingStub = Struct.new(:text, :no_kanji, :applies_to_written_forms) do
  def initialize(text:, no_kanji: false, applies_to_written_forms: [])
    super(text, no_kanji, applies_to_written_forms)
  end
end

WrittenFormStub = Struct.new(:text)

SenseStub = Struct.new(:ukrainian_glosses, :applies_to_written_forms) do
  def initialize(ukrainian_glosses: [], applies_to_written_forms: [])
    super(ukrainian_glosses, applies_to_written_forms)
  end
end

EntryStub = Struct.new(:jmdict_id, :written_forms, :readings, :senses)

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

class HouhouOverlayTest < Minitest::Test
  BASE_DB_PATH = File.expand_path(
    "../../../../../../projects/other/Houhou-SRS/Kanji.Interface/Data/KanjiDatabase.sqlite",
    __dir__
  )

  # Build a tiny in-memory KanjiDatabase and return its path written to a tempfile.
  def build_base_db(rows)
    path = Tempfile.new(["base_db", ".sqlite"]).path
    db   = Sequel.sqlite(path)
    db.create_table(:VocabSet) do
      Integer :ID,          primary_key: true
      String  :KanjiWriting
      String  :KanaWriting, null: false
      Integer :IsMain,      null: false
    end
    rows.each { |r| db[:VocabSet].insert(r) }
    db.disconnect
    path
  end

  # Run the overlay exporter against the given entries and base db rows.
  # Returns [stats, output_path, db] where db is a connected Sequel::Database.
  def run_export(entries, base_rows, base_overlay_path: nil)
    base_path = build_base_db(base_rows)
    output    = Tempfile.new(["overlay", ".sqlite"]).path
    FileUtils.rm_f(output)  # exporter creates it

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

  # ---------------------------------------------------------------------------
  # Schema tests
  # ---------------------------------------------------------------------------

  def test_required_tables_exist
    entries = []
    _stats, _out, db = run_export(entries, [])
    assert db.table_exists?(:Metadata),               "Metadata table missing"
    assert db.table_exists?(:LocalizedVocabMeaning),  "LocalizedVocabMeaning table missing"
    # FTS tables appear as views in Sequel
    tables_and_views = db.tables + db.views
    assert tables_and_views.map(&:to_s).include?("LocalizedVocabSearchFts"), \
      "LocalizedVocabSearchFts FTS table missing"
    db.disconnect
  end

  def test_schema_version_is_1
    _stats, _out, db = run_export([], [])
    val = db[:Metadata].where(Key: "SchemaVersion").get(:Value)
    assert_equal "1", val
    db.disconnect
  end

  def test_metadata_ukrainian_source_key_present
    _stats, _out, db = run_export([], [])
    val = db[:Metadata].where(Key: "UkrainianSource").get(:Value)
    assert_equal "jibiki", val
    db.disconnect
  end

  # ---------------------------------------------------------------------------
  # Meaning insertion tests
  # ---------------------------------------------------------------------------

  WAKARU_ROWS = [
    { ID: 1001, KanjiWriting: "分かる", KanaWriting: "わかる", IsMain: 1 },
    { ID: 1002, KanjiWriting: "分かる", KanaWriting: "わかる", IsMain: 0 }
  ].freeze

  def wakaru_entry
    EntryStub.new(
      1_606_560,
      [WrittenFormStub.new("分かる")],
      [ReadingStub.new(text: "わかる")],
      [SenseStub.new(ukrainian_glosses: [UkGloss.new("розуміти", nil), UkGloss.new("знати", nil)])]
    )
  end

  def test_meanings_inserted_for_matched_entry
    _stats, _out, db = run_export([wakaru_entry], WAKARU_ROWS)
    meanings = db[:LocalizedVocabMeaning].where(Language: "uk").select_map(:Meaning)
    assert_includes meanings, "розуміти"
    assert_includes meanings, "знати"
    db.disconnect
  end

  def test_meanings_have_correct_language
    _stats, _out, db = run_export([wakaru_entry], WAKARU_ROWS)
    langs = db[:LocalizedVocabMeaning].select_map(:Language).uniq
    assert_equal ["uk"], langs
    db.disconnect
  end

  def test_meanings_associated_with_correct_vocab_ids
    _stats, _out, db = run_export([wakaru_entry], WAKARU_ROWS)
    ids = db[:LocalizedVocabMeaning].where(Language: "uk").select_map(:VocabId).sort
    assert_equal [1001, 1002], ids.uniq.sort
    db.disconnect
  end

  def test_qualifier_appended_to_meaning
    entry = EntryStub.new(
      9_999_999,
      [WrittenFormStub.new("食べる")],
      [ReadingStub.new(text: "たべる")],
      [SenseStub.new(ukrainian_glosses: [UkGloss.new("їсти", "розм.")])]
    )
    base = [{ ID: 5001, KanjiWriting: "食べる", KanaWriting: "たべる", IsMain: 1 }]
    _stats, _out, db = run_export([entry], base)
    meanings = db[:LocalizedVocabMeaning].where(Language: "uk").select_map(:Meaning)
    assert_includes meanings, "їсти (розм.)"
    db.disconnect
  end

  def test_no_qualifier_suffix_when_qualifier_nil
    _stats, _out, db = run_export([wakaru_entry], WAKARU_ROWS)
    meanings = db[:LocalizedVocabMeaning].where(Language: "uk").select_map(:Meaning)
    assert meanings.none? { |m| m.include?("(") }
    db.disconnect
  end

  # ---------------------------------------------------------------------------
  # FTS tests
  # ---------------------------------------------------------------------------

  def test_fts_row_exists_for_uk_vocab
    _stats, _out, db = run_export([wakaru_entry], WAKARU_ROWS)
    rows = db[:LocalizedVocabSearchFts].where(Language: "uk").all
    refute_empty rows
    db.disconnect
  end

  def test_fts_meanings_column_contains_all_meanings_space_joined
    _stats, _out, db = run_export([wakaru_entry], WAKARU_ROWS)
    # At least one FTS row for vocab_id 1001 should contain both meanings
    rows = db["SELECT * FROM LocalizedVocabSearchFts WHERE Language='uk' AND VocabId=1001"].all
    assert_equal 1, rows.size
    fts_meanings = rows.first[:Meanings]
    assert_includes fts_meanings, "розуміти"
    assert_includes fts_meanings, "знати"
    db.disconnect
  end

  # ---------------------------------------------------------------------------
  # Unmatched reporting tests
  # ---------------------------------------------------------------------------

  def test_unmatched_entry_reported_to_io
    entry = EntryStub.new(
      8_888_888,
      [WrittenFormStub.new("存在しない")],
      [ReadingStub.new(text: "そんざいしない")],
      [SenseStub.new(ukrainian_glosses: [UkGloss.new("не існує", nil)])]
    )
    _stats, _out, _db, log = run_export([entry], [])
    assert_includes log, "8888888"
  end

  def test_matched_entry_not_in_unmatched_report
    _stats, _out, _db, log = run_export([wakaru_entry], WAKARU_ROWS)
    refute_includes log, "1606560"
  end

  # ---------------------------------------------------------------------------
  # Stats tests
  # ---------------------------------------------------------------------------

  def test_stats_matched_count
    stats, = run_export([wakaru_entry], WAKARU_ROWS)
    assert_equal 1, stats[:matched]
  end

  def test_stats_unmatched_count_when_miss
    entry = EntryStub.new(7_777_777,
      [WrittenFormStub.new("ない")],
      [ReadingStub.new(text: "ない")],
      [SenseStub.new(ukrainian_glosses: [UkGloss.new("немає", nil)])])
    stats, = run_export([entry], [])
    assert_equal 1, stats[:unmatched]
  end

  # ---------------------------------------------------------------------------
  # Integrity check
  # ---------------------------------------------------------------------------

  def test_integrity_check_passes
    _stats, _output, db = run_export([wakaru_entry], WAKARU_ROWS)
    result = db["PRAGMA integrity_check"].first.values.first
    assert_equal "ok", result
    db.disconnect
  end

  # ---------------------------------------------------------------------------
  # Merge mode tests
  # ---------------------------------------------------------------------------

  # Build a donor overlay SQLite file containing pre-seeded rows.
  def build_donor_overlay(rows)
    path = Tempfile.new(["donor", ".sqlite"]).path
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
    # Donor has 'ru' rows for a VocabId not covered by jibiki.
    donor_rows = [
      { VocabId: 9001, Language: "ru", Meaning: "понимать" }
    ]
    db, = run_merge_export([], [], donor_rows)
    meanings = db[:LocalizedVocabMeaning].where(Language: "ru").select_map(:Meaning)
    assert_includes meanings, "понимать"
    db.disconnect
  end

  def test_merge_preserves_foreign_uk_rows_for_unmatched_vocab_ids
    # Donor has a 'uk' row for a VocabId jibiki does NOT cover.
    donor_rows = [
      { VocabId: 8888, Language: "uk", Meaning: "чужий запис" }
    ]
    db, = run_merge_export([], [], donor_rows)
    meanings = db[:LocalizedVocabMeaning].where(VocabId: 8888, Language: "uk").select_map(:Meaning)
    assert_includes meanings, "чужий запис"
    db.disconnect
  end

  def test_merge_jibiki_wins_conflict_for_covered_vocab_id
    # Donor has a stale 'uk' row for a VocabId that jibiki DOES cover — it should NOT appear.
    donor_rows = [
      { VocabId: 1001, Language: "uk", Meaning: "старий запис" }
    ]
    db, = run_merge_export([wakaru_entry], WAKARU_ROWS, donor_rows)
    meanings = db[:LocalizedVocabMeaning].where(VocabId: 1001, Language: "uk").select_map(:Meaning)
    refute_includes meanings, "старий запис"
    assert_includes meanings, "розуміти"
    db.disconnect
  end

  def test_merge_metadata_contains_merged_from_key
    donor_rows = [{ VocabId: 7001, Language: "ru", Meaning: "тест" }]
    donor_path = build_donor_overlay(donor_rows)
    _stats, _out, db = run_export([], [], base_overlay_path: donor_path)
    val = db[:Metadata].where(Key: "MergedFrom").get(:Value)
    refute_nil val
    db.disconnect
  ensure
    FileUtils.rm_f(donor_path) if donor_path
  end

  def test_no_merged_from_key_without_merge_mode
    _stats, _out, db = run_export([wakaru_entry], WAKARU_ROWS)
    val = db[:Metadata].where(Key: "MergedFrom").get(:Value)
    assert_nil val
    db.disconnect
  end
end
