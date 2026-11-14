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
end
