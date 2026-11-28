# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/authoring/prompt'
require_relative 'support/authoring_rows'

class AuthoringPromptTest < Minitest::Test
  def test_word_lines_carry_senses_and_trimmed_warodai
    user = Authoring::Prompt.build([AuthoringRows.ao, AuthoringRows.shiraburu])[:user]

    assert_includes user, "@1 青【あお】\nS1 (n) blue; azure\nS2 (n) green light\nW: цв. синий; зелёный\n"
    assert_includes user, "@2 シラブル\nS1 (n) syllable\n"
    refute_includes user, '<i>'
  end

  def test_rules_are_static_and_reading_rule_is_opt_in
    plain = Authoring::Prompt.build([AuthoringRows.ao])
    other = Authoring::Prompt.build([AuthoringRows.shiraburu])

    assert_equal plain[:system], other[:system]
    refute_includes plain[:system], 'hiragana'
    assert_includes Authoring::Prompt.build([AuthoringRows.ao], readings: true)[:system], 'hiragana'
  end

  def test_retry_lists_errors_and_keeps_item_numbers
    user = Authoring::Prompt.build([AuthoringRows.ao], numbers: ['7'], errors: { '7' => ['expected 3 examples, got 2'] })[:user]

    assert_match(/\AYour previous reply had problems.*\n@7: expected 3 examples, got 2\n\n@7 青/m, user)
  end

  def test_long_warodai_is_truncated
    row = AuthoringRows.ao
    row['warodai_cards'] = [{ 'body' => 'а' * 400 }]

    line = Authoring::Prompt.build([row])[:user].lines.find { |l| l.start_with?('W: ') }
    assert_equal Authoring::Prompt::WARODAI_MAX_CHARS + 1, line.strip.delete_prefix('W: ').length
  end
end
