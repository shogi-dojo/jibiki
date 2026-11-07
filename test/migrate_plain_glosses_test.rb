# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../scripts/migrate_plain_glosses'

class MigratePlainGlossesTest < Minitest::Test
  HEADER = <<~ORG
    #+TITLE: 孫々
    #+JMDICT_ID: 1012110
    #+SCHEMA_VERSION: 2
    #+PRIMARY_READING: まごまご
    #+ROMAJI: magomago
    #+ENTRY_STATUS: draft
    #+QUALITY_PROFILE: learner
    #+JMDICT_SOURCE_SHA256: 08cfdf99863a0859570db7f7e0c8ab49dce8dea1fd090c3b99464fc12d20c81e
    #+CREATED_AT: 2026-07-17
    #+DEFAULT_AUTHOR_ID: codex
    #+DEFAULT_LICENSE: CC-BY-SA-4.0
    #+DEFAULT_SOURCE_TYPE: original
    #+DEFAULT_STATUS: draft

    * Forms
    ** Reading rd-1012110-001
    :PROPERTIES:
    :TEXT: まごまご
    :NO_KANJI: true
    :END:

  ORG

  def sense(glosses)
    HEADER + <<~ORG
      * Sense s-1012110-001
      :PROPERTIES:
      :SOURCE_SENSE_INDEX: 1
      :END:
      ** English glosses
      - confused
      ** Ukrainian glosses
      #{glosses.chomp}
      ** Learner notes
    ORG
  end

  def test_turns_plain_items_into_headings_with_the_parsed_ids
    text = sense("- розгублено\n- спантеличено")
    migrated = PlainGlossMigration.migrate(text)

    assert_includes migrated, <<~ORG
      ** Ukrainian glosses
      *** uk-s-1012110-001-001
      :PROPERTIES:
      :END:
      - text :: розгублено
      *** uk-s-1012110-001-002
      :PROPERTIES:
      :END:
      - text :: спантеличено
      ** Learner notes
    ORG
    assert_equal PlainGlossMigration.snapshot(text), PlainGlossMigration.snapshot(migrated)
  end

  def test_skips_ids_held_by_existing_headings_and_keeps_them_after
    text = sense(<<~ORG)
      - розгублено
      *** uk-s-1012110-001-001
      :PROPERTIES:
      :END:
      - text :: збентежено
    ORG
    migrated = PlainGlossMigration.migrate(text)

    assert_match(/\*\*\* uk-s-1012110-001-002\n:PROPERTIES:\n:END:\n- text :: розгублено\n\*\*\* uk-s-1012110-001-001\n/, migrated)
    assert_equal PlainGlossMigration.snapshot(text), PlainGlossMigration.snapshot(migrated)
  end

  def test_keeps_continuation_lines_with_their_item
    text = sense("- не знаючи,\n  що робити")
    migrated = PlainGlossMigration.migrate(text)

    assert_includes migrated, "- text :: не знаючи,\n  що робити\n"
    assert_equal PlainGlossMigration.snapshot(text), PlainGlossMigration.snapshot(migrated)
  end

  def test_leaves_files_without_plain_glosses_unchanged
    text = sense("*** uk-s-1012110-001-001\n:PROPERTIES:\n:END:\n- text :: розгублено")

    assert_equal text, PlainGlossMigration.migrate(text)
  end

  def test_snapshot_sees_a_changed_gloss
    refute_equal PlainGlossMigration.snapshot(sense('- розгублено')),
                 PlainGlossMigration.snapshot(sense('- збентежено'))
  end
end
