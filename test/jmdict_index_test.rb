# frozen_string_literal: true

require 'minitest/autorun'
require 'tmpdir'
require 'zlib'
require_relative '../lib/dictionary_sources/jmdict'
require_relative 'jmdict_lookup_test'

# The index stands in for a full archive parse in the validator and doctor,
# so every entry it answers must carry exactly what parse_entry computes.
class JmdictIndexTest < Minitest::Test
  def with_index(workers: 3)
    Dir.mktmpdir do |directory|
      archive = File.join(directory, 'JMdict.xml.gz')
      Zlib::GzipWriter.open(archive) { |gz| gz.write(JmdictLookupTest::ARCHIVE) }
      cache = File.join(directory, 'cache')
      jmdict = DictionarySources::Jmdict.new(archive)
      jmdict.write_index(cache_root: cache, workers: workers)
      yield jmdict, DictionarySources::JmdictIndex.open(archive, cache), archive, cache
    end
  end

  def test_every_entry_matches_parse_entry
    with_index do |jmdict, index|
      %w[1000010 1000020 1000030 1000040].each do |seq|
        parsed = jmdict.lookup(ent_seq: seq).first
        indexed = index.entry(seq)

        assert_equal seq, indexed[:ent_seq]
        assert_equal(parsed[:senses].map { |s| s[:source_fingerprint] }, indexed[:senses].map do |s|
          s[:source_fingerprint]
        end)
        assert_equal(parsed[:senses].map { |s| s[:index] }, indexed[:senses].map { |s| s[:index] })
        assert_equal(parsed[:senses].map { |s| s[:glosses].map { |g| g[:lang] }.uniq },
                     indexed[:senses].map { |s| s[:glosses].map { |g| g[:lang] } })
      end
    end
  end

  def test_lines_are_sorted_and_headed_with_the_archive_hash
    with_index(workers: 1) do |jmdict, index|
      lines = File.readlines(index.path, chomp: true)

      assert_equal "# #{DictionarySources::JmdictIndex::HEADER} sha256=#{jmdict.archive_sha256}", lines.first
      assert_equal(%w[1000010 1000020 1000030 1000040], lines.drop(1).map { |line| line.split("\t").first })
    end
  end

  def test_unknown_ids_answer_nil
    with_index do |_jmdict, index|
      assert_nil index.entry('999')
      assert_nil index.entry('1000015')
      assert_nil index.entry('9999999')
    end
  end

  def test_open_is_nil_without_an_index_or_an_archive
    Dir.mktmpdir do |directory|
      archive = File.join(directory, 'JMdict.xml.gz')

      assert_nil DictionarySources::JmdictIndex.open(archive, directory)
      Zlib::GzipWriter.open(archive) { |gz| gz.write(JmdictLookupTest::ARCHIVE) }

      assert_nil DictionarySources::JmdictIndex.open(archive, directory)
    end
  end

  def test_archive_hash_is_read_from_the_stamp_until_the_archive_changes
    with_index do |jmdict, _index, archive, cache|
      stamp = DictionarySources::JmdictIndex.stamp_path(archive, cache)
      fields = File.read(stamp).chomp.split("\t")
      File.write(stamp, "#{[*fields[0, 3], 'f' * 64].join("\t")}\n")

      assert_equal 'f' * 64, DictionarySources::JmdictIndex.archive_sha256(archive, cache)

      File.utime(Time.now, Time.now + 60, archive)

      assert_equal jmdict.archive_sha256, DictionarySources::JmdictIndex.archive_sha256(archive, cache)
    end
  end
end
