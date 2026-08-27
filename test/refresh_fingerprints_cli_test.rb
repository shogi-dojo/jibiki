# frozen_string_literal: true

require 'fileutils'
require 'minitest/autorun'
require 'open3'
require 'rbconfig'
require 'tmpdir'
require 'zlib'

class RefreshFingerprintsCliTest < Minitest::Test
  SCRIPT = File.expand_path('../scripts/refresh_fingerprints.rb', __dir__)
  RUBY = RbConfig.ruby
  STALE = 'dead' * 16

  def test_rewrites_a_drifted_fingerprint_and_restamps_the_archive_hash
    in_corpus do |jmdict, path|
      write_entry(path, fingerprint: STALE)

      stdout, stderr, status = run_cli(jmdict, path)

      assert status.success?, stderr
      assert_includes stdout, '1 fingerprint(s) drifted across 1 entry'
      assert_equal expected_fingerprint(jmdict), fingerprint_of(path)
      assert_equal Digest::SHA256.file(jmdict).hexdigest, archive_sha256_of(path)
    end
  end

  # The scaffolder leaves this empty when an entry is authored without the
  # archive, so the refresher has to treat "absent" as drift, not as a parse
  # failure that silently skips the sense.
  def test_fills_in_an_empty_fingerprint
    in_corpus do |jmdict, path|
      write_entry(path, fingerprint: nil)

      stdout, stderr, status = run_cli(jmdict, path)

      assert status.success?, stderr
      assert_includes stdout, '(none) ->'
      assert_equal expected_fingerprint(jmdict), fingerprint_of(path)
    end
  end

  def test_leaves_an_entry_that_already_agrees_untouched
    in_corpus do |jmdict, path|
      write_entry(path, fingerprint: expected_fingerprint(jmdict))
      before = File.binread(path)

      stdout, stderr, status = run_cli(jmdict, path)

      assert status.success?, stderr
      assert_includes stdout, 'All fingerprints already agree'
      assert_equal before, File.binread(path)
    end
  end

  def test_check_reports_drift_without_writing
    in_corpus do |jmdict, path|
      write_entry(path, fingerprint: STALE)
      before = File.binread(path)

      stdout, _stderr, status = run_cli(jmdict, path, '--check')

      refute status.success?, '--check must exit non-zero when the corpus has drifted'
      assert_includes stdout, 'drifted'
      assert_equal before, File.binread(path), '--check must leave the tree clean'
    end
  end

  # A sense index that no longer resolves means JMdict dropped or reordered
  # senses. Silently rewriting the surviving senses would half-reconcile the
  # entry, so that case belongs to entries:validate and a person.
  def test_leaves_a_sense_index_the_archive_no_longer_has
    in_corpus do |jmdict, path|
      write_entry(path, fingerprint: STALE, sense_index: 7)
      before = File.binread(path)

      _stdout, _stderr, status = run_cli(jmdict, path)

      assert status.success?
      assert_equal before, File.binread(path)
    end
  end

  def test_reports_an_entry_the_archive_does_not_contain
    in_corpus do |jmdict, path|
      write_entry(path, fingerprint: STALE, ent_seq: '9999999')

      _stdout, stderr, status = run_cli(jmdict, path)

      refute status.success?, 'an unresolvable entry must not exit clean'
      assert_includes stderr, 'Not found in archive'
    end
  end

  private

  def in_corpus
    Dir.mktmpdir do |directory|
      jmdict = build_jmdict(directory)
      path = File.join(directory, 'entries', '1381', '1381380-ao.org')
      FileUtils.mkdir_p(File.dirname(path))
      yield jmdict, path
    end
  end

  def run_cli(jmdict, *args)
    Open3.capture3({ 'JMDICT_PATH' => jmdict }, RUBY, SCRIPT, *args)
  end

  def expected_fingerprint(jmdict_path)
    lib = File.expand_path('../lib', __dir__)
    $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
    require 'dictionary_sources/jmdict'
    DictionarySources::Jmdict.new(jmdict_path).lookup(ent_seq: '1381380').first[:senses].first[:source_fingerprint]
  end

  def fingerprint_of(path)
    File.read(path, encoding: Encoding::UTF_8)[/^:SOURCE_FINGERPRINT: (\h{64})$/, 1]
  end

  def archive_sha256_of(path)
    File.read(path, encoding: Encoding::UTF_8)[/^#\+JMDICT_SOURCE_SHA256: (\h{64})$/, 1]
  end

  def build_jmdict(directory)
    path = File.join(directory, 'JMdict.xml.gz')
    xml = <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE JMdict [
      <!ENTITY n "noun (common) (futsuumeishi)">
      ]>
      <JMdict>
      <entry>
      <ent_seq>1381380</ent_seq>
      <k_ele><keb>青</keb></k_ele>
      <r_ele><reb>あお</reb></r_ele>
      <sense><pos>&n;</pos><gloss>blue</gloss></sense>
      </entry>
      </JMdict>
    XML
    Zlib::GzipWriter.open(path) { |gzip| gzip.write(xml) }
    path
  end

  def write_entry(path, fingerprint:, ent_seq: '1381380', sense_index: 1)
    File.write(path, <<~ORG, encoding: Encoding::UTF_8)
      #+TITLE: 青
      #+JMDICT_ID: #{ent_seq}
      #+SCHEMA_VERSION: 2
      #+PRIMARY_READING: あお
      #+ROMAJI: ao
      #+ENTRY_STATUS: draft
      #+QUALITY_PROFILE: learner
      #+JMDICT_SOURCE_SHA256: #{'0' * 64}

      * Sense s-#{ent_seq}-001
      :PROPERTIES:
      :SOURCE_SENSE_INDEX: #{sense_index}
      :SOURCE_FINGERPRINT:#{fingerprint ? " #{fingerprint}" : ''}
      :END:
      ** English glosses
      - blue
    ORG
  end
end
