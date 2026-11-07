# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/entry_validator'
require_relative '../lib/org_entry/patch'

class EntryValidatorTextTest < Minitest::Test
  ROOT = File.expand_path('..', __dir__)
  AO = File.read(File.join(ROOT, 'entries/1381/1381380-ao.org'), encoding: 'UTF-8')

  def test_a_corpus_entry_validates_without_the_jmdict_archive
    assert_empty EntryValidator.validate_text(AO)
  end

  def test_reports_problems_in_the_text
    errors = EntryValidator.validate_text(AO.sub("- text :: синій колір\n", "- text :: синій колір \n"))

    assert(errors.any? { |error| error.include?('trailing whitespace') })
  end

  def test_rejects_text_without_identity_headers
    assert_equal ['Missing JMDICT_ID or ROMAJI header'], EntryValidator.validate_text("* Forms\n")
  end

  def test_rejects_a_romaji_header_that_is_not_a_file_name
    assert_equal ['Missing JMDICT_ID or ROMAJI header'],
                 EntryValidator.validate_text(AO.sub('#+ROMAJI: ao', '#+ROMAJI: ../ao'))
  end

  # Typical web edits on a spread of real entries must not add validation
  # errors the entry did not already have.
  def test_patched_corpus_entries_stay_valid
    paths = Dir[File.join(ROOT, 'entries/*/*.org')].sort.each_slice(150).map(&:first)
    regressions = paths.filter_map do |path|
      text = File.read(path, encoding: 'UTF-8')
      patched = OrgEntry::Patch.apply(text, sample_ops(text), author: 'dojo:test', reviewer: 'dojo:mod',
                                                              date: '2026-11-08')
      added = EntryValidator.validate_text(patched) - EntryValidator.validate_text(text)
      "#{File.basename(path)}: #{added.first}" unless added.empty?
    end

    assert_empty regressions
  end

  private

  def sample_ops(text)
    sense = OrgEntry.parse(text).senses.first
    ops = [
      { 'op' => 'gloss.add', 'sense' => sense.id, 'values' => { 'text' => 'перевірка', 'qualifier' => 'тест' } },
      { 'op' => 'note.add', 'sense' => sense.id, 'values' => { 'uk' => 'Примітка.', 'level' => 'beginner' } }
    ]
    if (gloss = sense.ukrainian_glosses.first)
      ops << { 'op' => 'gloss.edit', 'id' => gloss.id, 'values' => { 'text' => "#{gloss.text} (уточнено)" } }
    end
    if (example = sense.examples.first)
      ops << { 'op' => 'example.edit', 'id' => example.id, 'values' => { 'en' => 'Checked.' } }
    end
    ops
  end
end
