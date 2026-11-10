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
end
