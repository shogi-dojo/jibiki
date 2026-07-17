# frozen_string_literal: true

require 'fileutils'
require 'minitest/autorun'
require 'open3'
require 'rbconfig'
require 'tmpdir'
require 'zlib'

class ValidateEntryCliTest < Minitest::Test
  SCRIPT = File.expand_path('../scripts/validate_entry.rb', __dir__)
  RUBY = RbConfig.ruby

  def test_validates_a_single_entry
    Dir.mktmpdir do |directory|
      jmdict = build_jmdict(directory)
      path = write_entry(directory, ent_seq: '1381380', jmdict: jmdict)

      _stdout, stderr, status = run_cli(jmdict, path)

      assert status.success?, stderr
    end
  end

  def test_validates_several_entries_in_one_invocation
    Dir.mktmpdir do |directory|
      jmdict = build_jmdict(directory, ent_seqs: %w[1381380 1381390])
      first = write_entry(directory, ent_seq: '1381380', jmdict: jmdict)
      second = write_entry(directory, ent_seq: '1381390', jmdict: jmdict)

      stdout, stderr, status = run_cli(jmdict, first, second)

      assert status.success?, stderr
      assert_equal 2, stdout.scan('Validation PASSED').length
    end
  end

  def test_one_bad_entry_fails_the_whole_batch
    Dir.mktmpdir do |directory|
      jmdict = build_jmdict(directory, ent_seqs: %w[1381380 1381390])
      good = write_entry(directory, ent_seq: '1381380', jmdict: jmdict)
      bad = write_entry(directory, ent_seq: '1381390', jmdict: jmdict, fingerprint: 'deadbeef')

      stdout, _stderr, status = run_cli(jmdict, good, bad)

      refute status.success?, 'a tampered fingerprint must fail the batch'
      assert_equal 1, stdout.scan('Validation PASSED').length
      assert_includes stdout, 'Fingerprint mismatch'
    end
  end

  def test_rejects_unedited_example_placeholders
    Dir.mktmpdir do |directory|
      jmdict = build_jmdict(directory)
      path = write_entry(directory, ent_seq: '1381380', jmdict: jmdict, examples: <<~ORG)
        ** Examples
        *** ex-1381380-001-001
        - JA :: 例
        - READING :: れい
        - UK :: Приклад.
        - EN :: Example.
        - FOCUS :: 例
      ORG

      stdout, _stderr, status = run_cli(jmdict, path)

      refute status.success?, 'placeholder examples must not validate'
      assert_includes stdout, 'unedited JA placeholder'
      assert_includes stdout, 'unedited UK placeholder'
    end
  end

  def test_rejects_the_unedited_learner_note_stub
    Dir.mktmpdir do |directory|
      jmdict = build_jmdict(directory)
      path = write_entry(directory, ent_seq: '1381380', jmdict: jmdict, examples: <<~ORG)
        ** Learner notes
        *** note-s-1381380-001-001
        - UK :: Basic word.
        - LEVEL :: beginner
      ORG

      stdout, _stderr, status = run_cli(jmdict, path)

      refute status.success?
      assert_includes stdout, 'unedited UK placeholder'
    end
  end

  def test_accepts_real_text_that_merely_contains_the_placeholder_word
    Dir.mktmpdir do |directory|
      jmdict = build_jmdict(directory)
      path = write_entry(directory, ent_seq: '1381380', jmdict: jmdict, examples: <<~ORG)
        ** Examples
        *** ex-1381380-001-001
        - JA :: 例えば、青い空を見ました。
        - READING :: たとえば、あおいそらをみました。
        - UK :: Наприклад, я побачив блакитне небо.
        - EN :: For example, I saw a blue sky.
        - FOCUS :: 例文
      ORG

      _stdout, stderr, status = run_cli(jmdict, path)

      assert status.success?, "a real sentence containing 例 must validate: #{stderr}"
    end
  end

  def test_reports_an_entry_missing_from_jmdict
    Dir.mktmpdir do |directory|
      jmdict = build_jmdict(directory)
      path = write_entry(directory, ent_seq: '9999999', fingerprint: 'unused')

      stdout, _stderr, status = run_cli(jmdict, path)

      refute status.success?
      assert_includes stdout, 'not found'
    end
  end

  private

  def run_cli(jmdict, *paths)
    Open3.capture3({ 'JMDICT_PATH' => jmdict }, RUBY, SCRIPT, *paths)
  end

  def build_jmdict(directory, ent_seqs: %w[1381380])
    path = File.join(directory, 'JMdict.xml.gz')
    entries = ent_seqs.map do |ent_seq|
      <<~XML
        <entry>
        <ent_seq>#{ent_seq}</ent_seq>
        <k_ele><keb>青</keb></k_ele>
        <r_ele><reb>あお</reb></r_ele>
        <sense><pos>&n;</pos><gloss>blue</gloss></sense>
        </entry>
      XML
    end.join
    xml = <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE JMdict [
      <!ENTITY n "noun (common) (futsuumeishi)">
      ]>
      <JMdict>
      #{entries}</JMdict>
    XML
    Zlib::GzipWriter.open(path) { |gzip| gzip.write(xml) }
    path
  end

  # Mirrors the on-disk layout the validator enforces: entries/<id[0,4]>/<id>-<romaji>.org
  def write_entry(directory, ent_seq:, jmdict: nil, fingerprint: nil, examples: nil)
    fingerprint ||= source_fingerprint(jmdict, ent_seq)
    path = File.join(directory, 'entries', ent_seq[0, 4], "#{ent_seq}-ao.org")
    FileUtils.mkdir_p(File.dirname(path))
    File.write(path, entry_body(ent_seq:, fingerprint:, examples:), encoding: Encoding::UTF_8)
    path
  end

  # Reads the fingerprint back out of the archive under test, so the fixture
  # always agrees with whatever the parser currently produces.
  def source_fingerprint(jmdict_path, ent_seq)
    lib = File.expand_path('../lib', __dir__)
    $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
    require 'dictionary_sources/jmdict'
    entry = DictionarySources::Jmdict.new(jmdict_path).lookup(ent_seq: ent_seq).first
    entry && entry[:senses].first[:source_fingerprint]
  end

  def entry_body(ent_seq:, fingerprint:, examples: nil)
    body = <<~ORG
      #+TITLE: 青
      #+JMDICT_ID: #{ent_seq}
      #+SCHEMA_VERSION: 1
      #+PRIMARY_READING: あお
      #+ROMAJI: ao
      #+ENTRY_STATUS: draft
      #+QUALITY_PROFILE: learner
      #+JMDICT_SOURCE_SHA256: 0000000000000000000000000000000000000000000000000000000000000000
      #+CREATED_AT: 2026-07-17

      * Forms
      ** Written form wf-#{ent_seq}-001
      :PROPERTIES:
      :TEXT: 青
      :END:
      *** Information
      *** Priorities
      ** Reading rd-#{ent_seq}-001
      :PROPERTIES:
      :TEXT: あお
      :NO_KANJI: false
      :END:
      *** Applies to written forms
      - *
      *** Information
      *** Priorities

      * Sense s-#{ent_seq}-001
      :PROPERTIES:
      :SOURCE_SENSE_INDEX: 1
      :SOURCE_FINGERPRINT: #{fingerprint}
      :END:
      ** Applies to forms
      *** Written forms
      - *
      *** Readings
      - *
      ** JMdict metadata
      *** Parts of speech
      - n
      *** Fields
      *** Miscellaneous and register
      *** Dialects
      *** Sense information
      *** Cross-references
      *** Antonyms
      *** Language sources
      ** English glosses
      *** en-s-#{ent_seq}-001-001
      :PROPERTIES:
      :LANG: eng
      :TYPE: plain
      :GENDER: none
      :PRIMARY: false
      :END:
      - text :: blue
      ** Ukrainian glosses
      *** uk-s-#{ent_seq}-001-001
      :PROPERTIES:
      :STATUS: draft
      :TRANSLATOR_ID: test
      :TRANSLATED_AT: 2026-07-17
      :REVIEWER_ID:
      :REVIEWED_AT:
      :SOURCE_TYPE: original
      :LICENSE: CC-BY-SA-4.0
      :END:
      - text :: синій
    ORG
    examples ? "#{body}#{examples}" : body
  end
end
