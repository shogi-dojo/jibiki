# frozen_string_literal: true

require 'minitest/autorun'
require 'json'
require_relative '../lib/kanji/draft_audit'

class KanjiDraftAuditTest < Minitest::Test
  POLICY = JSON.parse(File.read(File.expand_path('../drafts/kanji/audit-policy.json', __dir__)))

  def record(text)
    original = Kanji::Record.load(File.expand_path('fixtures/kanji/U+4E00.org', __dir__))
    Kanji::Record.new(keywords: original.keywords, source: original.source,
                      translations: [original.translations.first.with(text: text)], stored_fingerprint: original.stored_fingerprint)
  end

  def test_native_words_are_preserved_but_japanese_misspellings_are_reported
    report = Kanji::DraftAudit.call([record('дзьоб; зачіска; затишшя; чаші; того; чіплятися; зачісувати; кокудзі; сяку')], POLICY)
    assert_equal %w[кокудзі сяку], report[:findings].map { |finding| finding[:token] }
    assert_equal %w[кокуджі шяку], report[:findings].map { |finding| finding[:suggestion] }
    assert_equal '0.3.2', report[:yanagi_version]
  end

  def test_canonical_japanese_terms_remain_unchanged
    report = Kanji::DraftAudit.call([record('кокуджі; шяку; монме; шінто; шьоґі; Фуджі; ґьодза')], POLICY)
    assert_empty report[:findings]
  end

  def test_russian_only_letters_are_reported_without_rewriting_text
    entry = record('подавати сакэ')
    report = Kanji::DraftAudit.call([entry], POLICY)
    assert_equal ['U+4E00'], report[:foreign_script_drafts]
    assert_equal 'подавати сакэ', entry.translations.first.text
    assert_empty Kanji::DraftAudit.call([record('подавати саке')], POLICY)[:foreign_script_drafts]
  end

  def test_metadata_only_is_a_coverage_problem_and_audit_does_not_change_review_status
    entry = record('(кокуджі)')
    original = entry.translations.dup
    report = Kanji::DraftAudit.call([entry], POLICY)
    assert_equal ['U+4E00'], report[:metadata_only_drafts]
    assert_equal original, entry.translations
    assert_equal 1, report[:reviewed_records]
  end

  def test_tracks_untranslated_source_gaps_separately_from_source_gaps
    empty_source = Kanji::Source.new(stroke_count: 2, grade: nil, frequency: nil,
                                     on_readings: [], kun_readings: [], meanings: [])
    gap_only = Kanji::Record.new(
      keywords: { 'TITLE' => '𠂉', 'CODEPOINT' => 'U+20089', 'SCHEMA_VERSION' => '1',
                  'DEFAULT_LICENSE' => 'CC-BY-SA-4.0' },
      source: empty_source, translations: [], stored_fingerprint: empty_source.fingerprint
    )
    translated_gap = Kanji::Record.new(
      keywords: gap_only.keywords, source: empty_source,
      translations: [Kanji::Translation.new(id: 'uk-U+20089-001', text: 'сувій', status: 'draft',
                                            reviewed_by: nil)],
      stored_fingerprint: empty_source.fingerprint
    )
    report = Kanji::DraftAudit.call([gap_only, translated_gap], POLICY)
    assert_equal 2, report[:source_gaps]
    assert_equal 1, report[:untranslated_source_gaps]
    assert_equal 1, report[:translated_records]
  end
end
