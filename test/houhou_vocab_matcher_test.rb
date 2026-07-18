# frozen_string_literal: true

require "minitest/autorun"
require "sequel"
require_relative "../lib/exporters/houhou_vocab_matcher"

# Build an in-memory KanjiDatabase stand-in and exercise the matcher against it.
class HouhouVocabMatcherTest < Minitest::Test
  # ---------- helpers -------------------------------------------------------

  # Create an in-memory Sequel DB that looks like Houhou's VocabSet table.
  def build_test_db(rows)
    db = Sequel.sqlite
    db.create_table(:VocabSet) do
      Integer :ID, primary_key: true
      String  :KanjiWriting
      String  :KanaWriting, null: false
      Integer :IsMain, null: false  # stored as 0/1 in SQLite
      Integer :GroupId, null: false
    end
    rows.each { |r| db[:VocabSet].insert({ GroupId: r[:ID] }.merge(r)) }
    db
  end

  # Build a matcher backed by an in-memory DB (bypassing file I/O).
  def matcher_from_rows(rows)
    db = build_test_db(rows)
    m = Exporters::HouhouVocabMatcher.allocate
    m.instance_variable_set(:@db, db)
    m.send(:initialize_index)
    m
  end

  # ---------- class-method unit tests ---------------------------------------

  def test_to_hiragana_converts_katakana
    assert_equal "わかる", Exporters::HouhouVocabMatcher.to_hiragana("ワカル")
  end

  def test_to_hiragana_leaves_hiragana_unchanged
    assert_equal "わかる", Exporters::HouhouVocabMatcher.to_hiragana("わかる")
  end

  def test_to_hiragana_mixed
    assert_equal "わかる", Exporters::HouhouVocabMatcher.to_hiragana("ワかる")
  end

  def test_to_hiragana_boundary_kata_start
    # ァ (U+30A1) → ぁ (U+3041)
    assert_equal "\u3041", Exporters::HouhouVocabMatcher.to_hiragana("\u30A1")
  end

  def test_to_hiragana_boundary_kata_end
    # ヶ (U+30F6) → ヶ has no hiragana equivalent but is in range; result = U+3096
    assert_equal "\u3096", Exporters::HouhouVocabMatcher.to_hiragana("\u30F6")
  end

  def test_nfkc_decomposes_fullwidth
    # Fullwidth ASCII 'Ａ' (U+FF21) → 'A'
    assert_equal "A", Exporters::HouhouVocabMatcher.nfkc("\uFF21")
  end

  def test_key_uses_writing_when_present
    k = Exporters::HouhouVocabMatcher.key("分かる", "わかる")
    assert_equal ["分かる", "わかる"], k
  end

  def test_key_uses_reading_as_writing_when_writing_nil
    k = Exporters::HouhouVocabMatcher.key(nil, "わかる")
    assert_equal ["わかる", "わかる"], k
  end

  def test_key_uses_reading_as_writing_when_writing_empty
    k = Exporters::HouhouVocabMatcher.key("", "わかる")
    assert_equal ["わかる", "わかる"], k
  end

  def test_key_converts_katakana_in_reading
    k = Exporters::HouhouVocabMatcher.key(nil, "ワカル")
    assert_equal ["ワカル", "わかる"], k
  end

  # ---------- matcher lookup tests ------------------------------------------

  ROWS = [
    # kanji+kana rows sharing one group
    { ID: 1001, KanjiWriting: "分かる", KanaWriting: "わかる", IsMain: 1, GroupId: 10 },
    { ID: 1002, KanjiWriting: "分かる", KanaWriting: "わかる", IsMain: 0, GroupId: 10 },
    # kana-only row
    { ID: 2001, KanjiWriting: nil,    KanaWriting: "ほん",   IsMain: 1, GroupId: 20 },
    # katakana reading stored in DB (maps to same key after conversion)
    { ID: 3001, KanjiWriting: nil,    KanaWriting: "テスト", IsMain: 1, GroupId: 30 },
    # fullwidth kanji writing (NFKC should normalise)
    { ID: 4001, KanjiWriting: "日本語", KanaWriting: "にほんご", IsMain: 1, GroupId: 40 },
    # homophones in different groups (橋 vs 箸)
    { ID: 5001, KanjiWriting: "橋", KanaWriting: "はし", IsMain: 1, GroupId: 50 },
    { ID: 5002, KanjiWriting: "箸", KanaWriting: "はし", IsMain: 1, GroupId: 51 },
  ].freeze

  def setup
    @matcher = matcher_from_rows(ROWS)
  end

  def test_lookup_kanji_kana_pair_returns_both_rows
    results = @matcher.lookup(writing: "分かる", reading: "わかる")
    assert_equal 2, results.size
    ids = results.map { |r| r[:vocab_id] }.sort
    assert_equal [1001, 1002], ids
  end

  def test_lookup_is_main_flag_true_for_main_row
    results = @matcher.lookup(writing: "分かる", reading: "わかる")
    main = results.find { |r| r[:vocab_id] == 1001 }
    assert_equal true, main[:is_main]
  end

  def test_lookup_is_main_flag_false_for_non_main_row
    results = @matcher.lookup(writing: "分かる", reading: "わかる")
    non_main = results.find { |r| r[:vocab_id] == 1002 }
    assert_equal false, non_main[:is_main]
  end

  def test_lookup_kana_only_entry_matches_via_reading_as_writing
    results = @matcher.lookup(writing: nil, reading: "ほん")
    assert_equal 1, results.size
    assert_equal 2001, results.first[:vocab_id]
  end

  def test_lookup_kana_only_entry_with_empty_writing
    results = @matcher.lookup(writing: "", reading: "ほん")
    assert_equal 1, results.size
    assert_equal 2001, results.first[:vocab_id]
  end

  def test_lookup_katakana_reading_stored_in_db_matched_by_katakana_query
    # DB stores "テスト" as KanaWriting (kana-only, so effective writing = "テスト").
    # key[0] = nfkc("テスト") = "テスト", key[1] = hira("テスト") = "てすと".
    # Query must supply the same katakana writing to hit key[0].
    results = @matcher.lookup(writing: nil, reading: "テスト")
    assert_equal 1, results.size
    assert_equal 3001, results.first[:vocab_id]
  end

  def test_lookup_katakana_kana_only_no_match_with_hiragana_reading
    # Hiragana query does NOT match a katakana-keyed kana-only entry:
    # key[0] = "てすと" ≠ "テスト"
    results = @matcher.lookup(writing: nil, reading: "てすと")
    assert_empty results
  end

  def test_lookup_miss_returns_empty_array
    results = @matcher.lookup(writing: "存在しない", reading: "そんざいしない")
    assert_empty results
  end

  def test_lookup_nfkc_normalisation_on_kanji_writing
    # Query with identical codepoints — should hit row 4001
    results = @matcher.lookup(writing: "日本語", reading: "にほんご")
    assert_equal 1, results.size
    assert_equal 4001, results.first[:vocab_id]
  end

  # ---------- reading-only fallback tests ------------------------------------

  def test_lookup_by_reading_matches_single_group
    results = @matcher.lookup_by_reading("わかる")
    assert_equal [1001, 1002], results.map { |r| r[:vocab_id] }.sort
  end

  def test_lookup_by_reading_converts_katakana
    results = @matcher.lookup_by_reading("てすと")
    assert_equal [3001], results.map { |r| r[:vocab_id] }
  end

  def test_lookup_by_reading_refuses_ambiguous_homophones
    assert_empty @matcher.lookup_by_reading("はし")
  end

  def test_lookup_by_reading_miss_returns_empty
    assert_empty @matcher.lookup_by_reading("そんざいしない")
  end
end
