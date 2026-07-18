# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/org_entry'

class OrgEntryTest < Minitest::Test
  def test_load_from_heredoc
    content = <<~ORG
      #+TITLE: 彼処
      #+JMDICT_ID: 1000320
      #+SCHEMA_VERSION: 2
      #+PRIMARY_READING: あそこ
      #+ROMAJI: asoko
      #+ENTRY_STATUS: reviewed
      #+QUALITY_PROFILE: learner
      #+JMDICT_SOURCE_SHA256: 08cfdf99863a0859570db7f7e0c8ab49dce8dea1fd090c3b99464fc12d20c81e
      #+CREATED_AT: 2026-07-17
      #+DEFAULT_AUTHOR_ID: antigravity
      #+DEFAULT_LICENSE: CC-BY-SA-4.0
      #+DEFAULT_SOURCE_TYPE: original
      #+DEFAULT_STATUS: reviewed

      * Forms
      ** Written form wf-1000320-001
      :PROPERTIES:
      :TEXT: 彼処
      :END:
      *** Information
      - rK
      ** Reading rd-1000320-001
      :PROPERTIES:
      :TEXT: あそこ
      :NO_KANJI: false
      :END:
      *** Applies to written forms
      - *
      *** Priorities
      - ichi1
      * Sense s-1000320-001
      :PROPERTIES:
      :SOURCE_SENSE_INDEX: 1
      :SOURCE_FINGERPRINT: 2329ffc1ac38e601148cd757a2fa0de10b12b37594f0e379b19d9d08868b96e8
      :LEARNER_PRIORITY: primary
      :END:
      ** Applies to forms
      *** Written forms
      - *
      *** Readings
      - あそこ
      ** JMdict metadata
      *** Parts of speech
      - pn
      ** English glosses
      - there
      - over there
      ** Ukrainian glosses
      *** uk-s-1000320-001-001
      :PROPERTIES:
      :END:
      - text :: там
      - qualifier :: neutral
      ** Russian reference
      - 12 :: : {～に} (уст.) там
      ** Learner notes
      *** note-s-1000320-001-001
      :PROPERTIES:
      :END:
      - UK :: Вказівний займенник.
      ** Examples
      *** ex-1000320-001-001
      :PROPERTIES:
      :LEVEL: beginner
      :REGISTER: neutral
      :END:
      - JA :: あそこは病院です。
      - READING :: あそこはびょういんです。
      - UK :: Там знаходиться лікарня.
    ORG

    doc = OrgEntry::Document.parse(content)
    entry = OrgEntry::Entry.new(doc)

    assert_equal 1000320, entry.jmdict_id
    assert_equal '彼処', entry.title
    assert_equal 'asoko', entry.romaji
    assert_equal 'reviewed', entry.entry_status

    # Forms
    assert_equal 1, entry.written_forms.length
    assert_equal 'wf-1000320-001', entry.written_forms[0].id
    assert_equal '彼処', entry.written_forms[0].text
    assert_equal ['rK'], entry.written_forms[0].information

    assert_equal 1, entry.readings.length
    assert_equal 'rd-1000320-001', entry.readings[0].id
    assert_equal 'あそこ', entry.readings[0].text
    assert_equal ['*'], entry.readings[0].applies_to_written_forms
    assert_equal ['ichi1'], entry.readings[0].priorities

    # Senses
    assert_equal 1, entry.senses.length
    sense = entry.senses[0]
    assert_equal 's-1000320-001', sense.id
    assert_equal 1, sense.source_sense_index
    assert_equal 'primary', sense.learner_priority
    assert_equal ['*'], sense.applies_to_written
    assert_equal ['あそこ'], sense.applies_to_readings
    assert_equal ['pn'], sense.parts_of_speech

    # English glosses
    assert_equal 2, sense.english_glosses.length
    assert_equal 'there', sense.english_glosses[0].text
    assert_equal 'over there', sense.english_glosses[1].text

    # Ukrainian glosses & Defaults resolution
    assert_equal 1, sense.ukrainian_glosses.length
    uk = sense.ukrainian_glosses[0]
    assert_equal 'uk-s-1000320-001-001', uk.id
    assert_equal 'там', uk.text
    assert_equal 'neutral', uk.qualifier
    assert_equal 'reviewed', uk.status # Inherited from file default
    assert_equal 'antigravity', uk.translator_id # Inherited
    assert_equal '2026-07-17', uk.translated_at # Inherited
    assert_equal 'original', uk.source_type # Inherited
    assert_equal 'CC-BY-SA-4.0', uk.license # Inherited

    # Russian references
    assert_equal 1, sense.russian_references.length
    assert_equal 12, sense.russian_references[0].source_sense_index
    assert_equal ': {～に} (уст.) там', sense.russian_references[0].text

    # Learner notes
    assert_equal 1, sense.learner_notes.length
    note = sense.learner_notes[0]
    assert_equal 'Вказівний займенник.', note.uk
    assert_equal 'reviewed', note.status # Inherited
    assert_equal 'antigravity', note.author_id # Inherited

    # Examples
    assert_equal 1, sense.examples.length
    ex = sense.examples[0]
    assert_equal 'あそこは病院です。', ex.ja
    assert_equal 'あそこはびょういんです。', ex.reading
    assert_equal 'Там знаходиться лікарня.', ex.uk
    assert_equal 'beginner', ex.level
    assert_equal 'neutral', ex.register
  end
end
