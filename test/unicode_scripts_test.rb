# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../scripts/gen_unicode_scripts'
require_relative '../lib/generated/unicode_scripts'

# The generated classes stand in for \p{Han} and \p{Cyrillic}, which Spinel's
# regexp engine lacks; they must hold exactly the same codepoints.
class UnicodeScriptsTest < Minitest::Test
  def test_classes_match_ruby_script_properties_on_every_codepoint
    { UnicodeScripts::HAN => /\p{Han}/, UnicodeScripts::CYRILLIC => /\p{Cyrillic}/ }.each do |generated, property|
      wrong = UnicodeScriptTables.codepoints.select do |cp|
        char = [cp].pack('U')
        generated.match?(char) != property.match?(char)
      end
      assert_empty wrong.first(10).map { |cp| format('U+%04X', cp) }, property.source
    end
  end

  def test_generated_file_is_current
    current = File.read(UnicodeScriptTables::TARGET, encoding: 'UTF-8')

    assert_equal UnicodeScriptTables.source, current, 'rerun scripts/gen_unicode_scripts.rb'
  end
end
