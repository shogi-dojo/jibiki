# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/org_entry'
require_relative '../scripts/validate_entry'

class OrgEntryCorpusSmokeTest < Minitest::Test
  def test_load_all_corpus_files
    paths = Dir[File.expand_path('../entries/*/*.org', __dir__)]
    refute_empty paths, "No Org files found in the entries/ directory"

    paths.each do |path|
      begin
        entry = OrgEntry.load(path)
        assert_instance_of OrgEntry::Entry, entry
        assert_operator entry.jmdict_id, :>, 0
      rescue => e
        flunk "Failed to load entry at #{path}: #{e.message}\n#{e.backtrace.join("\n")}"
      end
    end
  end

  # `entries:scaffold` stamps whichever JMdict generation the author had on
  # disk, so an entry can merge carrying an archive hash the validator has
  # never been told about: it passes review only because the same archive is
  # still the live download, then turns validation red for the whole corpus the
  # day EDRDG rotates it. Pinning the corpus to KNOWN_JMDICT_SHA256S here fails
  # in the JMdict-free test job instead, at the commit that introduced the hash.
  def test_every_corpus_archive_hash_is_recognised
    paths = Dir[File.expand_path('../entries/*/*.org', __dir__)]
    refute_empty paths, 'No Org files found in the entries/ directory'

    by_hash = paths.group_by do |path|
      File.binread(path).force_encoding('UTF-8')[/^#\+JMDICT_SOURCE_SHA256: (\h{64})$/, 1]
    end
    unknown = by_hash.reject { |sha256, _| KNOWN_JMDICT_SHA256S.include?(sha256) }

    assert_empty unknown.map { |sha256, entries|
      "#{sha256.inspect} (#{entries.length} entries, e.g. #{File.basename(entries.min)})"
    }, 'Corpus archive hashes missing from KNOWN_JMDICT_SHA256S in scripts/validate_entry.rb'
  end
end
