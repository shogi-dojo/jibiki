# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/entry_doctor'

class EntryDoctorTest < Minitest::Test
  def sample_valid_org
    <<~ORG
      #+TITLE: テスト
      #+JMDICT_ID: 9999990
      #+SCHEMA_VERSION: 2
      #+PRIMARY_READING: てすと
      #+ROMAJI: tesuto
      #+ENTRY_STATUS: draft
      #+QUALITY_PROFILE: learner
      #+JMDICT_SOURCE_SHA256: 62f5fd402cfbff619e592e11b16276fa8cdb7c7524126194e9000af6019dfcf5
      #+CREATED_AT: 2026-08-14
      #+DEFAULT_AUTHOR_ID: tester
      #+DEFAULT_LICENSE: CC-BY-SA-4.0
      #+DEFAULT_SOURCE_TYPE: original
      #+DEFAULT_STATUS: draft

      * Forms
      ** Reading rd-9999990-001
      :PROPERTIES:
      :TEXT: てすと
      :NO_KANJI: true
      :END:
      * Sense s-9999990-001
      :PROPERTIES:
      :SOURCE_SENSE_INDEX: 1
      :SOURCE_FINGERPRINT: dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
      :LEARNER_PRIORITY: primary
      :END:
      ** English glosses
      - test
      ** Ukrainian glosses
      *** uk-s-9999990-001-001
      :PROPERTIES:
      :END:
      - text :: тест
      ** Learner notes
      *** note-s-9999990-001-001
      :PROPERTIES:
      :END:
      - UK :: Вживається для позначення випробування або тестування.
      ** Examples
      *** ex-9999990-001-001
      :PROPERTIES:
      :LEVEL: beginner
      :END:
      - JA :: これはテストです。
      - READING :: これはてすとです。
      - UK :: Це тест.
      - FOCUS :: テスト
      *** ex-9999990-001-002
      :PROPERTIES:
      :LEVEL: intermediate
      :END:
      - JA :: 明日テストがあります。
      - READING :: あしたてすとがあります。
      - UK :: Завтра буде тест.
      - FOCUS :: テスト
      *** ex-9999990-001-003
      :PROPERTIES:
      :LEVEL: advanced
      :END:
      - JA :: 難しいテストを受けた。
      - READING :: むずかしいてすとをうけた。
      - UK :: Я складав важкий тест.
      - FOCUS :: テスト
    ORG
  end

  def test_valid_learner_entry_passes_cleanly
    entry = OrgEntry.parse(sample_valid_org)
    report = EntryDoctor.analyze(entry)

    assert report.passed?
    assert_empty report.errors
    assert_empty report.warnings
    assert_equal 100, report.health_score
    assert_equal 1, report.stats[:covered_eng_senses]
    assert_equal 3, report.stats[:total_examples]
  end

  def test_flags_kanji_in_reading
    bad_org = sample_valid_org.gsub(
      '- READING :: これはてすとです。',
      '- READING :: これは本[ほん]です。'
    )
    entry = OrgEntry.parse(bad_org)
    report = EntryDoctor.analyze(entry)

    refute report.passed?
    finding = report.errors.find { |f| f.check == :reading_kana_only }
    refute_nil finding
    assert_includes finding.detail, 'contains kanji'
  end

  def test_flags_reading_mismatch_with_ja
    bad_org = sample_valid_org.gsub(
      '- READING :: これはてすとです。',
      '- READING :: あれはてすとです。'
    )
    entry = OrgEntry.parse(bad_org)
    report = EntryDoctor.analyze(entry)

    refute report.passed?
    finding = report.errors.find { |f| f.check == :reading_matches_ja }
    refute_nil finding
    assert_includes finding.detail, 'not a subsequence'
  end

  def test_flags_cyrillic_in_focus
    bad_org = sample_valid_org.gsub(
      '- FOCUS :: テスト',
      '- FOCUS :: テスト (тест)'
    )
    entry = OrgEntry.parse(bad_org)
    report = EntryDoctor.analyze(entry)

    refute report.passed?
    finding = report.errors.find { |f| f.check == :focus_no_cyrillic }
    refute_nil finding
    assert_includes finding.detail, 'contains Cyrillic text'
  end

  def test_flags_uncovered_english_sense
    bad_org = sample_valid_org.sub(
      "*** uk-s-9999990-001-001\n:PROPERTIES:\n:END:\n- text :: тест\n",
      ''
    )
    entry = OrgEntry.parse(bad_org)
    report = EntryDoctor.analyze(entry)

    refute report.passed?
    finding = report.errors.find { |f| f.check == :uk_gloss_present }
    refute_nil finding
    assert_includes finding.detail, 'no non-blank Ukrainian gloss'
  end

  def test_flags_blank_ukrainian_gloss
    bad_org = sample_valid_org.gsub(
      '- text :: тест',
      '- text ::'
    )
    entry = OrgEntry.parse(bad_org)
    report = EntryDoctor.analyze(entry)

    refute report.passed?
    finding = report.errors.find { |f| f.check == :uk_gloss_not_blank }
    refute_nil finding
    assert_includes finding.detail, 'empty text'
  end

  def test_flags_profile_mismatch
    # Declares learner but has only 1 example
    bad_org = sample_valid_org.sub(
      /\*\*\* ex-9999990-001-002[\s\S]*?\*\*\* ex-9999990-001-003[\s\S]*?- FOCUS :: テスト\n/,
      ''
    )
    entry = OrgEntry.parse(bad_org)
    report = EntryDoctor.analyze(entry)

    refute report.passed?
    finding = report.errors.find { |f| f.check == :profile_matches_content }
    refute_nil finding
    assert_includes finding.detail, "Declared profile 'learner' not met"
  end

  def test_warns_when_note_echoes_gloss
    bad_org = sample_valid_org.gsub(
      '- UK :: Вживається для позначення випробування або тестування.',
      '- UK :: тест'
    )
    entry = OrgEntry.parse(bad_org)
    report = EntryDoctor.analyze(entry)

    assert report.passed?
    finding = report.warnings.find { |f| f.check == :note_not_gloss_echo }
    refute_nil finding
    assert_includes finding.detail, 'echoes the sense gloss text'
  end

  def test_warns_when_primary_sense_lacks_learner_note
    bad_org = sample_valid_org.sub(
      /\*\* Learner notes\n\*\*\* note-s-9999990-001-001\n:PROPERTIES:\n:END:\n- UK :: .*\n/,
      ''
    )
    entry = OrgEntry.parse(bad_org)
    report = EntryDoctor.analyze(entry)

    finding = report.warnings.find { |f| f.check == :learner_note_present }
    refute_nil finding
    assert_includes finding.detail, 'Primary sense has no learner note'
  end

  def test_reports_russian_reference_info_when_present_in_jmdict
    entry = OrgEntry.parse(sample_valid_org)
    fake_jmdict_entry = {
      ent_seq: '9999990',
      senses: [
        {
          index: 1,
          glosses: [{ lang: 'rus', text: 'тест' }]
        }
      ]
    }
    report = EntryDoctor.analyze(entry, jmdict_entry: fake_jmdict_entry)

    finding = report.infos.find { |f| f.check == :russian_reference_present }
    refute_nil finding
    assert_includes finding.detail, 'JMdict sense 1 has Russian glosses'
  end

  def test_serializes_to_hash
    entry = OrgEntry.parse(sample_valid_org)
    report = EntryDoctor.analyze(entry)
    hash = report.to_h

    assert_equal 9999990, hash[:jmdict_id]
    assert_equal 'テスト', hash[:title]
    assert_equal 100, hash[:health_score]
    assert_equal true, hash[:passed]
    assert_kind_of Hash, hash[:stats]
    assert_kind_of Array, hash[:findings]
  end
end
