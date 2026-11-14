# frozen_string_literal: true

require 'digest'
require 'json'
require 'minitest/autorun'

# The pinned upstream files are what the records were built from. A changed file, or a manifest
# that no longer names it, fails here before any import runs.
class KanjiSourcesTest < Minitest::Test
  SOURCES = File.expand_path('../sources/kanji', __dir__)
  MANIFEST = JSON.parse(File.read(File.join(SOURCES, 'MANIFEST.json')))['sources']

  def test_every_pinned_file_matches_its_checksum
    MANIFEST.each do |source|
      digest = Digest::SHA256.file(File.join(SOURCES, source['file'])).hexdigest
      assert_equal source['sha256'], digest, "#{source['name']} does not match its pinned checksum"
    end
  end

  def test_every_source_names_its_licence_and_attribution
    MANIFEST.each do |source|
      refute_empty source['licence'].to_s, "#{source['name']} has no licence"
      refute_empty source['attribution'].to_s, "#{source['name']} has no attribution"
    end
  end
end
