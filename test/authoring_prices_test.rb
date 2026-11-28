# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/authoring/prices'

class AuthoringPricesTest < Minitest::Test
  def test_estimate_uses_input_cached_and_output_rates
    cost = Authoring::Prices.estimate('gpt-6.2-sol', input: 1_000_000, cached: 1_000_000, output: 1_000_000)

    assert_in_delta 12.10, cost
  end

  def test_effort_suffix_is_ignored_and_unknown_models_have_no_estimate
    assert_in_delta 7.50, Authoring::Prices.estimate('gemini-4-hydrogen[high]', input: 0, cached: 0, output: 1_000_000)
    assert_nil Authoring::Prices.estimate('sonnet', input: 1, cached: 0, output: 1)
  end
end
