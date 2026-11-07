# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/org_entry'
require_relative '../lib/org_entry/patch'

class OrgEntryPatchTest < Minitest::Test
  ENTRY = <<~ORG
    #+TITLE: 青
    #+JMDICT_ID: 1381380
    #+SCHEMA_VERSION: 2
    #+PRIMARY_READING: あお
    #+ROMAJI: ao
    #+ENTRY_STATUS: draft
    #+QUALITY_PROFILE: learner
    #+JMDICT_SOURCE_SHA256: 08cfdf99863a0859570db7f7e0c8ab49dce8dea1fd090c3b99464fc12d20c81e
    #+CREATED_AT: 2026-07-17
    #+DEFAULT_AUTHOR_ID: codex
    #+DEFAULT_LICENSE: CC-BY-SA-4.0
    #+DEFAULT_SOURCE_TYPE: original
    #+DEFAULT_STATUS: draft

    * Forms
    ** Written form wf-1381380-001
    :PROPERTIES:
    :TEXT: 青
    :END:
    ** Reading rd-1381380-001
    :PROPERTIES:
    :TEXT: あお
    :NO_KANJI: false
    :END:

    * Sense s-1381380-001
    :PROPERTIES:
    :SOURCE_SENSE_INDEX: 1
    :END:
    ** JMdict metadata
    *** Parts of speech
    - n
    ** English glosses
    - blue
    ** Ukrainian glosses
    *** uk-s-1381380-001-001
    :PROPERTIES:
    :TRANSLATOR_ID: codex
    :TRANSLATED_AT: 2026-07-17
    :REVIEWER_ID:
    :REVIEWED_AT:
    :END:
    - text :: синій колір
    *** uk-s-1381380-001-002
    :PROPERTIES:
    :TRANSLATOR_ID: codex
    :TRANSLATED_AT: 2026-07-17
    :REVIEWER_ID:
    :REVIEWED_AT:
    :END:
    - text :: блакитний колір
    - qualifier :: про небо
    ** Examples
    *** ex-1381380-001-001
    :PROPERTIES:
    :LEVEL: beginner
    :END:
    - JA :: 青は空の色です。
    - READING :: あおはそらのいろです。
    - UK :: Синій — колір неба.

    * Sense s-1381380-002
    :PROPERTIES:
    :SOURCE_SENSE_INDEX: 2
    :END:
    ** JMdict metadata
    *** Parts of speech
    - n
    ** English glosses
    - green
    ** Ukrainian glosses
    *** uk-s-1381380-002-001
    :PROPERTIES:
    :TRANSLATOR_ID: codex
    :TRANSLATED_AT: 2026-07-17
    :REVIEWER_ID:
    :REVIEWED_AT:
    :END:
    - text :: зелений колір
  ORG

  CONTEXT = { author: 'dojo:olena', date: '2026-11-08' }.freeze

  # Fills in `from` with the current values where a test leaves it out, as
  # the site does from what the author saw.
  def patch(ops, text: ENTRY, **context)
    ops = ops.map do |op|
      next op if op.key?('from') || !op['id'] || op['op'].end_with?('.add')

      op.merge('from' => seen(op['id'], text) || {})
    end
    OrgEntry::Patch.apply(text, ops, **CONTEXT, **context)
  end

  def seen(id, text = ENTRY) = OrgEntry::Patch.read(text, id)&.compact

  def entry(text) = OrgEntry.parse(text)

  def glosses(text, sense = 0) = entry(text).senses[sense].ukrainian_glosses

  def block(text, id)
    lines = text.lines(chomp: true)
    start = lines.index("*** #{id}")
    stop = ((start + 1)...lines.length).find { |index| lines[index].match?(/\A\*{1,3} /) } || lines.length
    lines[start...stop].join("\n")
  end

  # --- glosses ----------------------------------------------------------

  def test_adds_a_gloss_at_the_end_of_the_sense_with_the_next_id
    text = patch([{ 'op' => 'gloss.add', 'sense' => 's-1381380-001', 'values' => { 'text' => 'лазур' } }])

    gloss = glosses(text).last
    assert_equal 'uk-s-1381380-001-003', gloss.id
    assert_equal 'лазур', gloss.text
    assert_equal 'dojo:olena', gloss.translator_id
    assert_equal '2026-11-08', gloss.translated_at
    assert_equal 'draft', gloss.status
    assert_equal <<~ORG.chomp, block(text, 'uk-s-1381380-001-003')
      *** uk-s-1381380-001-003
      :PROPERTIES:
      :TRANSLATOR_ID: dojo:olena
      :TRANSLATED_AT: 2026-11-08
      :REVIEWER_ID:
      :REVIEWED_AT:
      :END:
      - text :: лазур
    ORG
  end

  def test_adds_after_a_named_gloss
    text = patch([{ 'op' => 'gloss.add', 'sense' => 's-1381380-001', 'after' => 'uk-s-1381380-001-001',
                    'values' => { 'text' => 'лазур' } }])

    assert_equal %w[uk-s-1381380-001-001 uk-s-1381380-001-003 uk-s-1381380-001-002], glosses(text).map(&:id)
  end

  def test_an_approved_gloss_is_reviewed_by_the_moderator
    text = patch([{ 'op' => 'gloss.add', 'sense' => 's-1381380-002', 'values' => { 'text' => 'зелений' } }],
                 reviewer: 'dojo:taras')

    gloss = glosses(text, 1).last
    assert_equal 'reviewed', gloss.status
    assert_equal 'dojo:taras', gloss.reviewer_id
    assert_equal '2026-11-08', gloss.reviewed_at
  end

  def test_a_self_approved_gloss_stays_a_draft
    text = patch([{ 'op' => 'gloss.add', 'sense' => 's-1381380-002', 'values' => { 'text' => 'зелений' } }],
                 reviewer: 'dojo:olena')

    assert_equal 'draft', glosses(text, 1).last.status
    assert_nil glosses(text, 1).last.reviewer_id
  end

  def test_edits_text_and_removes_an_emptied_qualifier
    text = patch([{ 'op' => 'gloss.edit', 'id' => 'uk-s-1381380-001-002',
                    'from' => { 'text' => 'блакитний колір', 'qualifier' => 'про небо' },
                    'values' => { 'text' => 'блакитний', 'qualifier' => '' } }])

    gloss = glosses(text).last
    assert_equal 'блакитний', gloss.text
    assert_nil gloss.qualifier
    assert_equal 'dojo:olena', gloss.translator_id
    refute_includes text, 'qualifier ::'
  end

  def test_adds_a_qualifier_after_the_text
    text = patch([{ 'op' => 'gloss.edit', 'id' => 'uk-s-1381380-001-001', 'values' => { 'qualifier' => 'колір' } }])

    assert_match(/- text :: синій колір\n- qualifier :: колір\n/, text)
  end

  def test_an_edit_that_changes_nothing_leaves_the_file_alone
    ops = [{ 'op' => 'gloss.edit', 'id' => 'uk-s-1381380-001-001', 'values' => { 'text' => 'синій  колір ' } }]

    assert_equal ENTRY, patch(ops)
  end

  def test_an_edit_against_changed_text_is_a_conflict
    error = assert_raises(OrgEntry::Patch::Conflict) do
      patch([{ 'op' => 'gloss.edit', 'id' => 'uk-s-1381380-001-001', 'from' => { 'text' => 'синій' },
               'values' => { 'text' => 'синя барва' } }])
    end

    assert_equal 0, error.op_index
    assert_includes error.message, 'синій колір'
  end

  def test_a_partial_from_is_a_conflict_when_another_field_changed
    assert_raises(OrgEntry::Patch::Conflict) do
      patch([{ 'op' => 'gloss.edit', 'id' => 'uk-s-1381380-001-002', 'from' => { 'text' => 'блакитний колір' },
               'values' => { 'text' => 'блакитний' } }])
    end
  end

  def test_an_edit_needs_the_values_the_author_saw
    error = assert_raises(OrgEntry::Patch::Invalid) do
      OrgEntry::Patch.apply(ENTRY, [{ 'op' => 'gloss.remove', 'id' => 'uk-s-1381380-001-001' }], **CONTEXT)
    end

    assert_includes error.message, 'from'
  end

  def test_an_edit_of_a_missing_gloss_is_a_conflict
    assert_raises(OrgEntry::Patch::Conflict) do
      patch([{ 'op' => 'gloss.edit', 'id' => 'uk-s-1381380-001-009', 'values' => { 'text' => 'x' } }])
    end
  end

  def test_removes_a_gloss_but_keeps_the_required_section
    text = patch([{ 'op' => 'gloss.remove', 'id' => 'uk-s-1381380-002-001', 'from' => { 'text' => 'зелений колір' } }])

    assert_empty glosses(text, 1)
    assert_includes text, "** Ukrainian glosses\n"
    entry(text)
  end

  def test_new_ids_do_not_fill_gaps
    text = patch([{ 'op' => 'gloss.remove', 'id' => 'uk-s-1381380-001-001' },
                  { 'op' => 'gloss.add', 'sense' => 's-1381380-001', 'values' => { 'text' => 'лазур' } }])

    assert_equal %w[uk-s-1381380-001-002 uk-s-1381380-001-003], glosses(text).map(&:id)
  end

  def test_confirm_records_the_reviewer
    text = patch([{ 'op' => 'gloss.confirm', 'id' => 'uk-s-1381380-001-001', 'from' => { 'text' => 'синій колір' } }])

    gloss = glosses(text).first
    assert_equal 'reviewed', gloss.status
    assert_equal 'dojo:olena', gloss.reviewer_id
    assert_equal 'codex', gloss.translator_id
  end

  def test_nobody_confirms_their_own_translation
    assert_raises(OrgEntry::Patch::Invalid) do
      patch([{ 'op' => 'gloss.confirm', 'id' => 'uk-s-1381380-001-001' }], author: 'codex')
    end
  end

  # --- entry status and keywords -----------------------------------------

  def test_the_entry_is_reviewed_once_every_gloss_is
    ops = %w[uk-s-1381380-001-001 uk-s-1381380-001-002 uk-s-1381380-002-001].map do |id|
      { 'op' => 'gloss.confirm', 'id' => id }
    end

    assert_equal 'draft', entry(patch(ops.take(2))).entry_status
    assert_equal 'reviewed', entry(patch(ops)).entry_status
  end

  def test_an_edit_to_a_reviewed_entry_makes_it_a_draft_again
    reviewed = patch(%w[uk-s-1381380-001-001 uk-s-1381380-001-002 uk-s-1381380-002-001].map do |id|
      { 'op' => 'gloss.confirm', 'id' => id }
    end)
    text = patch([{ 'op' => 'gloss.edit', 'id' => 'uk-s-1381380-002-001', 'values' => { 'text' => 'зелений' } }],
                 text: reviewed)

    assert_equal 'draft', entry(text).entry_status
  end

  def test_records_the_update_date_after_created_at
    text = patch([{ 'op' => 'gloss.confirm', 'id' => 'uk-s-1381380-001-001' }])

    assert_includes text, "#+CREATED_AT: 2026-07-17\n#+UPDATED_AT: 2026-11-08\n"
    assert_equal '2026-11-08', entry(text).updated_at
  end

  # --- enrichments -------------------------------------------------------

  def test_adds_a_note_creating_its_section_in_order
    text = patch([{ 'op' => 'note.add', 'sense' => 's-1381380-001',
                    'values' => { 'uk' => 'Охоплює і синій, і зелений.', 'level' => 'beginner' } }])

    assert_match(/\*\* Ukrainian glosses\n.*\*\* Learner notes\n\*\*\* note-s-1381380-001-001\n.*\*\* Examples/m, text)
    note = entry(text).senses.first.learner_notes.first
    assert_equal 'Охоплює і синій, і зелений.', note.uk
    assert_equal 'dojo:olena', note.author_id
    assert_equal '2026-11-08', note.created_at
  end

  def test_adds_an_example_to_a_sense_without_examples
    text = patch([{ 'op' => 'example.add', 'sense' => 's-1381380-002',
                    'values' => { 'ja' => '信号が青になる。', 'reading' => 'しんごうがあおになる。',
                                  'uk' => 'Світлофор стає зеленим.', 'level' => 'beginner' } }])

    example = entry(text).senses.last.examples.first
    assert_equal 'ex-1381380-002-001', example.id
    assert_equal '信号が青になる。', example.ja
    assert_equal 'beginner', example.level
    assert text.end_with?("- UK :: Світлофор стає зеленим.\n")
  end

  def test_edits_an_example_field_in_the_drawer
    text = patch([{ 'op' => 'example.edit', 'id' => 'ex-1381380-001-001', 'from' => seen('ex-1381380-001-001'),
                    'values' => { 'level' => 'intermediate', 'en' => 'Blue is the colour of the sky.' } }])

    example = entry(text).senses.first.examples.first
    assert_equal 'intermediate', example.level
    assert_equal 'Blue is the colour of the sky.', example.en
    assert_match(/- UK :: Синій — колір неба.\n- EN :: Blue/, text)
  end

  def test_removing_the_last_example_drops_the_section
    text = patch([{ 'op' => 'example.remove', 'id' => 'ex-1381380-001-001' }])

    refute_includes text, '** Examples'
    assert_includes text, "- qualifier :: про небо\n\n* Sense s-1381380-002\n"
    entry(text)
  end

  def test_an_example_needs_its_required_fields
    error = assert_raises(OrgEntry::Patch::Invalid) do
      patch([{ 'op' => 'example.add', 'sense' => 's-1381380-001', 'values' => { 'ja' => '青。' } }])
    end

    assert_includes error.message, 'reading, uk'
  end

  def test_rejects_an_unknown_level
    assert_raises(OrgEntry::Patch::Invalid) do
      patch([{ 'op' => 'note.add', 'sense' => 's-1381380-001', 'values' => { 'uk' => 'x', 'level' => 'expert' } }])
    end
  end

  def test_rejects_multiline_values
    assert_raises(OrgEntry::Patch::Invalid) do
      patch([{ 'op' => 'gloss.add', 'sense' => 's-1381380-001', 'values' => { 'text' => "синій\n* Sense" } }])
    end
  end

  # --- whole entries and malformed input ----------------------------------

  def test_entry_delete_returns_nil
    assert_nil patch([{ 'op' => 'entry.delete' }])
  end

  def test_entry_delete_stands_alone
    assert_raises(OrgEntry::Patch::Invalid) do
      patch([{ 'op' => 'entry.delete' }, { 'op' => 'gloss.confirm', 'id' => 'uk-s-1381380-001-001' }])
    end
  end

  def test_rejects_unknown_operations_and_kind_mismatches
    assert_raises(OrgEntry::Patch::Invalid) { patch([{ 'op' => 'form.edit' }]) }
    assert_raises(OrgEntry::Patch::Invalid) do
      patch([{ 'op' => 'note.edit', 'id' => 'uk-s-1381380-001-001', 'values' => { 'uk' => 'x' } }])
    end
  end

  def test_rejects_a_malformed_author
    assert_raises(OrgEntry::Patch::Invalid) do
      patch([{ 'op' => 'gloss.confirm', 'id' => 'uk-s-1381380-001-001' }], author: 'Olena K')
    end
  end

  def test_read_returns_current_values
    assert_equal({ 'text' => 'блакитний колір', 'qualifier' => 'про небо' },
                 OrgEntry::Patch.read(ENTRY, 'uk-s-1381380-001-002'))
    assert_nil OrgEntry::Patch.read(ENTRY, 'uk-s-1381380-009-001')
  end
end
