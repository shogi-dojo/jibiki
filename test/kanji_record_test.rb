# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/kanji'

class KanjiRecordTest < Minitest::Test
  FIXTURES = File.expand_path('fixtures/kanji', __dir__)

  def fixture(name) = File.join(FIXTURES, name)
  def load_fixture(name) = Kanji::Record.load(fixture(name))

  def test_parses_source_and_translations
    record = load_fixture('U+4E00.org')
    assert_equal '一', record.character
    assert_equal 'U+4E00', record.codepoint
    assert_equal 1, record.source.stroke_count
    assert_equal %w[イチ イツ], record.source.on_readings
    assert_equal %w[ひと ひと-つ], record.source.kun_readings
    assert_equal ['one'], record.source.meanings
    assert_equal %w[uk-U+4E00-001 uk-U+4E00-002], record.translations.map(&:id)
    assert_equal %w[reviewed draft], record.translations.map(&:status)
    assert_equal 'reviewer-fixture', record.translations.first.reviewed_by
  end

  def test_fingerprint_is_stored_and_matches_the_source
    record = load_fixture('U+4E00.org')
    assert_equal record.computed_fingerprint, record.stored_fingerprint
  end

  def test_a_valid_fixture_has_no_problems
    assert_empty Kanji::Validator.call(load_fixture('U+4E00.org'), filename: fixture('U+4E00.org'))
    assert_empty Kanji::Validator.call(load_fixture('U+65E5.org'), filename: fixture('U+65E5.org'))
  end

  def test_a_source_change_without_a_patch_is_stale
    problems = Kanji::Validator.call(load_fixture('U+4E00-stale.org'))
    assert_includes problems, 'SOURCE_FINGERPRINT is stale: the source data changed without a patch'
  end

  def test_translation_edits_do_not_change_the_fingerprint
    record = load_fixture('U+4E00.org')
    edited = record.translations.map { |t| t.id == 'uk-U+4E00-002' ? t.with(text: 'інший текст') : t }
    changed = Kanji::Record.new(keywords: record.keywords, source: record.source, translations: edited,
                                stored_fingerprint: record.stored_fingerprint)
    assert_equal record.computed_fingerprint, changed.computed_fingerprint
  end

  def test_rejects_a_codepoint_that_does_not_match_the_title_or_file
    text = File.read(fixture('U+4E00.org'), encoding: 'UTF-8')
    wrong_title = Kanji::Record.parse(text.sub('#+TITLE: 一', '#+TITLE: 二'))
    assert_includes Kanji::Validator.call(wrong_title), 'CODEPOINT U+4E00 does not match TITLE 二'

    problems = Kanji::Validator.call(load_fixture('U+4E00.org'), filename: 'U+65E5.org')
    assert_includes problems, 'file name U+65E5.org does not match CODEPOINT U+4E00'
  end

  def test_rejects_malformed_codepoints
    record = Kanji::Record.parse(File.read(fixture('U+4E00.org'), encoding: 'UTF-8').sub('U+4E00', 'U+4e00'))
    assert_includes Kanji::Validator.call(record), 'CODEPOINT "U+4e00" is not U+XXXX'
  end

  def test_rejects_translation_problems
    text = File.read(fixture('U+4E00.org'), encoding: 'UTF-8')
    duplicated = text.sub('** uk-U+4E00-002', '** uk-U+4E00-001')
    assert_includes Kanji::Validator.call(Kanji::Record.parse(duplicated)), 'translation uk-U+4E00-001 appears twice'

    bad_status = text.sub(':STATUS: draft', ':STATUS: approved')
    assert_includes Kanji::Validator.call(Kanji::Record.parse(bad_status)),
                    'translation uk-U+4E00-002 has status "approved"'

    no_reviewer = text.sub(":REVIEWED_BY: reviewer-fixture\n", '')
    assert_includes Kanji::Validator.call(Kanji::Record.parse(no_reviewer)),
                    'translation uk-U+4E00-001 is reviewed but names no REVIEWED_BY'

    foreign = text.sub('** uk-U+4E00-002', '** uk-U+65E5-002')
    assert_includes Kanji::Validator.call(Kanji::Record.parse(foreign)),
                    'translation uk-U+65E5-002 does not belong to U+4E00'
  end

  def test_a_record_without_a_source_section_does_not_parse
    error = assert_raises(OrgEntry::ParseError) { Kanji::Record.parse("#+TITLE: 一\n#+CODEPOINT: U+4E00\n") }
    assert_match(/missing "\* Source" section/, error.message)
  end

  def test_rendering_a_record_again_is_stable
    text = File.read(fixture('U+4E00.org'), encoding: 'UTF-8')
    assert_equal text, Kanji::Writer.patch_source(Kanji::Record.parse(text), Kanji::Record.parse(text).source)
  end

  def test_patching_the_source_keeps_translations_and_moves_the_fingerprint
    record = load_fixture('U+4E00.org')
    richer = record.source.with(meanings: ['one', 'single'], frequency: 2)
    patched = Kanji::Record.parse(Kanji::Writer.patch_source(record, richer))

    assert_equal record.translations, patched.translations
    assert_equal ['one', 'single'], patched.source.meanings
    assert_equal richer.fingerprint, patched.stored_fingerprint
    assert_empty Kanji::Validator.call(patched)
  end

  def test_exports_flat_rows_per_table
    rows = Kanji::Exporter.rows([load_fixture('U+4E00.org'), load_fixture('U+65E5.org')])
    assert_equal %w[U+4E00 U+65E5], rows[:kanji].map { |row| row[:codepoint] }
    assert_equal %w[on on kun kun], rows[:kanji_readings].first(4).map { |row| row[:kind] }
    assert_equal [0, 1], rows[:kanji_readings].select { |row| row[:kind] == 'kun' && row[:codepoint] == 'U+4E00' }.map { |row| row[:position] }
    assert_equal %w[day sun Japan], rows[:kanji_meanings].select { |row| row[:codepoint] == 'U+65E5' }.map { |row| row[:text] }
    assert_equal %w[uk-U+4E00-001 uk-U+4E00-002], rows[:kanji_translations].map { |row| row[:id] }
  end
end
