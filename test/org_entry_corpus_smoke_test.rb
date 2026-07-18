# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/org_entry'

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
end
