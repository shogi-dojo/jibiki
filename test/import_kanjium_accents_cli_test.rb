# frozen_string_literal: true

require 'fileutils'
require 'minitest/autorun'
require 'open3'
require 'rbconfig'
require 'tmpdir'

class ImportKanjiumAccentsCliTest < Minitest::Test
  SCRIPT = File.expand_path('../scripts/import_kanjium_accents.rb', __dir__)
  ENTRY = <<~ORG
    #+TITLE: 日本語
    #+JMDICT_ID: 1464530

    * Forms
    ** Written form wf-1464530-001
    :PROPERTIES:
    :TEXT: 日本語
    :END:
    ** Reading rd-1464530-001
    :PROPERTIES:
    :TEXT: にほんご
    :NO_KANJI: false
    :END:
    *** Applies to written forms
    - *

    * Sense s-1464530-001
    ** Ukrainian glosses
    - uk-text :: японська мова
  ORG

  def test_refuses_an_unpinned_accents_file
    in_repo("日本語\tにほんご\t0\n") do |root, accents|
      _out, err, status = run_cli(root, accents)
      refute status.success?
      assert_includes err, 'expected 8bd0dd12'
    end
  end

  def test_imports_then_reports_nothing_left_to_change
    in_repo("日本語\tにほんご\t0\n川\tかわ\t2\n") do |root, accents|
      out, err, status = run_cli(root, accents, '--allow-unpinned')
      assert status.success?, err
      assert_includes out, 'matched    1'
      assert_includes out, 'unmatched  1'
      assert_includes File.read(entry_path(root)), ":PATTERN: heiban\n:MORA_PATTERN: LHHH\n"

      out, err, status = run_cli(root, accents, '--allow-unpinned', '--check', date: '2030-01-01')
      assert status.success?, err
      assert_includes out, 'would change: 0'
    end
  end

  private

  def run_cli(root, accents, *extra, date: '2026-11-19')
    Open3.capture3(RbConfig.ruby, SCRIPT, '--root', root, '--accents', accents, '--date', date, *extra)
  end

  def entry_path(root) = File.join(root, 'entries', '1464', '1464530-nihongo.org')

  def in_repo(accents_text)
    Dir.mktmpdir do |root|
      FileUtils.mkdir_p(File.dirname(entry_path(root)))
      File.write(entry_path(root), ENTRY)
      accents = File.join(root, 'accents.txt')
      File.write(accents, accents_text)
      yield root, accents
    end
  end
end
