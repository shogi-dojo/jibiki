# frozen_string_literal: true

require 'minitest/autorun'
require 'tmpdir'
require_relative '../lib/entry_doctor'
require_relative '../scripts/doctor_report'

class DoctorReportTest < Minitest::Test
  def sample_org
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
      - UK :: Вживається для позначення тестування.
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

  def test_generates_html_report
    Dir.mktmpdir do |dir|
      entry = OrgEntry.parse(sample_org)
      report = EntryDoctor.analyze(entry)
      out_path = File.join(dir, 'report.html')

      DoctorReport.generate([report], out_path)

      assert File.exist?(out_path)
      content = File.read(out_path)
      assert_includes content, 'Jibiki Corpus Health & Quality Report'
      assert_includes content, '9999990'
      assert_includes content, 'テスト'
      assert_includes content, 'Average Health Score'
    end
  end
end
