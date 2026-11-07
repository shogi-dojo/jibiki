# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/org_entry'
require_relative '../lib/org_entry/patch'

# Runs the patcher against every entry in the corpus: what it reads must be
# what the parser reads, and an edit must leave a file the parser accepts.
# One pass over the corpus serves both checks, since parsing dominates.
class OrgEntryPatchCorpusTest < Minitest::Test
  PATHS = Dir[File.expand_path('../entries/*/*.org', __dir__)].sort.freeze

  FIELDS = {
    ukrainian_glosses: %w[text qualifier],
    learner_notes: %w[uk],
    examples: %w[ja reading romaji uk en focus],
    collocations: %w[ja reading uk pattern]
  }.freeze

  def normalize(value)
    text = value.to_s.unicode_normalize(:nfc).strip.gsub(/ {2,}/, ' ')
    text.empty? ? nil : text
  end

  def test_reads_blocks_as_the_parser_does_and_edits_keep_entries_parseable
    refute_empty PATHS
    mismatches = []
    broken = []

    PATHS.each do |path|
      text = File.read(path, encoding: 'UTF-8')
      entry = OrgEntry.parse(text)
      mismatches.concat(read_mismatches(text, entry).map { |item| "#{File.basename(path)} #{item}" })
      broken << File.basename(path) unless add_keeps_parseable?(text, entry.senses.first)
    rescue StandardError => e
      broken << "#{File.basename(path)}: #{e.message}"
    end

    assert_empty mismatches.first(20), "#{mismatches.length} fields read differently"
    assert_empty broken.first(20), "#{broken.length} entries broke"
  end

  private

  def read_mismatches(text, entry)
    reader = OrgEntry::Patch.reader(text)
    entry.senses.flat_map do |sense|
      FIELDS.flat_map do |list, fields|
        sense.public_send(list).flat_map do |block|
          read = reader.values(block.id)
          fields.reject { |field| read && normalize(block.public_send(field)) == read[field] }
                .map { |field| "#{block.id} #{field}" }
        end
      end
    end
  end

  def add_keeps_parseable?(text, sense)
    return true unless sense

    patched = OrgEntry::Patch.apply(
      text, [{ 'op' => 'gloss.add', 'sense' => sense.id, 'values' => { 'text' => 'перевірка' } }],
      author: 'dojo:test', date: '2026-11-08'
    )
    glosses = OrgEntry.parse(patched).senses.first.ukrainian_glosses
    glosses.length == sense.ukrainian_glosses.length + 1 && glosses.last.text == 'перевірка'
  end
end
