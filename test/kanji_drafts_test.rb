# frozen_string_literal: true

require 'minitest/autorun'
require 'tmpdir'
require 'fileutils'
require 'open3'
require_relative '../lib/kanji'

class KanjiDraftsTest < Minitest::Test
  SCRIPT = File.expand_path('../scripts/kanji_drafts.rb', __dir__)
  FIXTURE = File.expand_path('fixtures/kanji/U+4E00.org', __dir__)

  def setup
    @root = Dir.mktmpdir('kanji-drafts-test')
    FileUtils.mkdir_p(File.join(@root, 'kanji'))
    FileUtils.mkdir_p(File.join(@root, 'drafts/kanji'))
    @path = File.join(@root, 'kanji/U+4E00.org')
    @batch = File.join(@root, 'drafts/kanji/batch-000.tsv')
    FileUtils.cp(FIXTURE, @path)
  end

  def teardown = FileUtils.rm_rf(@root)

  def run_script(command)
    Open3.capture3({ 'KANJI_DRAFT_ROOT' => @root }, RbConfig.ruby, SCRIPT, command)
  end

  def test_preserves_the_entire_record_when_it_has_a_reviewed_translation
    original = File.read(@path)
    File.write(@batch, "U+4E00\tзаміна\n")
    _, error, status = run_script('apply')
    assert status.success?, error
    assert_equal original, File.read(@path)
  end

  def test_applies_a_draft_with_provenance_and_is_repeatable
    record = Kanji::Record.load(@path)
    File.write(@path, Kanji::Writer.render(keywords: record.keywords, source: record.source))
    File.write(@batch, "U+4E00\tодин; єдиний\n")
    _, error, status = run_script('apply')
    assert status.success?, error
    applied = File.read(@path)
    draft = Kanji::Record.load(@path)
    assert_equal 'codex', draft.keywords['DRAFT_ORIGIN']
    assert_equal draft.computed_fingerprint, draft.keywords['DRAFT_SOURCE_FINGERPRINT']
    assert_equal 'draft', draft.translations.first.status
    assert_nil draft.translations.first.reviewed_by
    run_script('apply')
    assert_equal applied, File.read(@path)
  end

  def test_dump_keeps_every_source_meaning_for_editorial_review
    record = Kanji::Record.load(@path)
    meanings = %w[one two three four fifth]
    File.write(@path, Kanji::Writer.render(keywords: record.keywords, source: record.source.with(meanings: meanings)))
    output, error, status = Open3.capture3({ 'KANJI_DRAFT_ROOT' => @root }, RbConfig.ruby, SCRIPT, 'dump', '0', '1')
    assert status.success?, error
    assert_includes output, 'one; two; three; four; fifth'
  end

  def test_rejects_duplicate_batches_before_applying_anything
    original = File.read(@path)
    File.write(@batch, "U+4E00\tодин\nU+4E00\tдва\n")
    _, error, status = run_script('apply')
    refute status.success?
    assert_includes error, 'duplicate draft'
    assert_equal original, File.read(@path)
  end

  def test_does_not_apply_source_gap_inventory_as_translation_content
    File.write(File.join(@root, 'drafts/kanji/placeholders.tsv'), "U+4E00\tу джерелі не вказано значення\n")
    original = File.read(@path)
    _, error, status = run_script('apply')
    assert status.success?, error
    assert_equal original, File.read(@path)
  end

  def test_applies_and_counts_batch_draft_when_source_meanings_are_empty
    gap_source = Kanji::Source.new(stroke_count: 6, grade: nil, frequency: nil,
                                   on_readings: [], kun_readings: [], meanings: [])
    gap_path = File.join(@root, 'kanji/U+20509.org')
    File.write(gap_path, <<~ORG)
      #+TITLE: 𠔉
      #+CODEPOINT: U+20509
      #+SCHEMA_VERSION: 1
      #+DEFAULT_LICENSE: CC-BY-SA-4.0

      * Source
      :PROPERTIES:
      :SOURCE_FINGERPRINT: #{gap_source.fingerprint}
      :STROKE_COUNT: 6
      :END:

      * Ukrainian meanings
    ORG
    File.write(@batch, "U+20509\tсувій\n")

    _, error, status = run_script('apply')
    assert status.success?, error
    record = Kanji::Record.load(gap_path)
    assert_equal ['сувій'], record.translations.map(&:text)

    out, err, cov_status = run_script('coverage')
    assert cov_status.success?, err
    assert_includes out, '"draft": 1'
    assert_includes out, '"reviewed": 1'
  end
end
