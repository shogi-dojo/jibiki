# frozen_string_literal: true

require 'minitest/autorun'

class GemspecTest < Minitest::Test
  ROOT = File.expand_path('..', __dir__)

  def spec
    @spec ||= Dir.chdir(ROOT) { Gem::Specification.load('jibiki.gemspec') }
  end

  def test_packages_the_library_entry_points
    assert_includes spec.files, 'lib/jibiki.rb'
    assert_includes spec.files, 'lib/org_entry.rb'
    assert_includes spec.files, 'lib/exporters/rich_sqlite.rb'
  end

  def test_ships_no_dictionary_content_or_scripts
    assert(spec.files.none? { |path| path.start_with?('entries/', 'scripts/', 'sources/') })
  end

  def test_carries_the_licence_notices
    assert_includes spec.files, 'LICENSE'
    assert_includes spec.files, 'NOTICE'
  end
end
