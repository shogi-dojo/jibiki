# frozen_string_literal: true

require 'fileutils'
require 'minitest/autorun'
require 'open3'
require 'rbconfig'
require 'tmpdir'
require 'json'

class DoctorCliTest < Minitest::Test
  SCRIPT = File.expand_path('../scripts/doctor.rb', __dir__)
  RUBY = RbConfig.ruby

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

  def test_passes_valid_entry
    Dir.mktmpdir do |dir|
      path = File.join(dir, '9999990-tesuto.org')
      File.write(path, sample_valid_org)

      stdout, stderr, status = Open3.capture3(RUBY, SCRIPT, path)

      assert status.success?, stderr
      assert_equal 0, status.exitstatus
      assert_includes stdout, 'Result: PASSED'
      assert_includes stdout, 'Health Score: 100/100'
    end
  end

  def test_fails_entry_with_errors
    Dir.mktmpdir do |dir|
      bad_org = sample_valid_org.gsub(
        '- READING :: これはてすとです。',
        '- READING :: あれはてすとです。'
      )
      path = File.join(dir, '9999990-tesuto.org')
      File.write(path, bad_org)

      stdout, _stderr, status = Open3.capture3(RUBY, SCRIPT, path)

      refute status.success?
      assert_equal 2, status.exitstatus
      assert_includes stdout, 'Result: FAILED'
      assert_includes stdout, 'reading_matches_ja'
    end
  end

  def test_json_output_mode
    Dir.mktmpdir do |dir|
      path = File.join(dir, '9999990-tesuto.org')
      File.write(path, sample_valid_org)

      stdout, _stderr, status = Open3.capture3(RUBY, SCRIPT, '--json', path)

      assert status.success?
      data = JSON.parse(stdout)
      assert_equal 1, data['total_entries']
      assert_equal 1, data['passed_entries']
      assert_equal 0, data['total_errors']
      assert_equal 100, data['average_health_score']
    end
  end

  def test_json_output_failure_mode
    Dir.mktmpdir do |dir|
      bad_org = sample_valid_org.sub(
        '- FOCUS :: テスト',
        '- FOCUS :: テスト (тест)'
      )
      path = File.join(dir, '9999990-tesuto.org')
      File.write(path, bad_org)

      stdout, _stderr, status = Open3.capture3(RUBY, SCRIPT, '--json', path)

      assert_equal 2, status.exitstatus
      data = JSON.parse(stdout)
      assert_equal 1, data['failed_entries']
      assert_equal 1, data['total_errors']
    end
  end
end
