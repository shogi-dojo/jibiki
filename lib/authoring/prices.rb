# frozen_string_literal: true

module Authoring
  # API list prices per 1M tokens (input, cached input, output), checked
  # 2026-11-28, to estimate the cost of runs whose agent reports none (Codex,
  # Antigravity). Cached input is taken as 10% of input where none is listed.
  module Prices
    PER_MILLION = {
      'gpt-6.2-sol' => [2.00, 0.10, 10.00], 'gpt-6.2-astra' => [8.00, 0.40, 40.00],
      'gpt-6.1-sol' => [2.00, 0.10, 10.00], 'gpt-6-luna' => [0.10, 0.01, 0.50],
      'gemini-4-hydrogen' => [1.50, 0.15, 7.50], 'gemini-3.8-flash' => [0.75, 0.075, 3.75],
      'gemini-4-neon' => [3.00, 0.30, 15.00], 'gemini-4-carbon' => [2.00, 0.20, 10.00],
      'gemini-4-argon' => [2.00, 0.20, 10.00]
    }.freeze

    module_function

    # model: an id as usage.tsv records it (an effort suffix such as
    # "[high]" is ignored). Returns dollars, or nil for an unpriced model.
    def estimate(model, input:, cached:, output:)
      price = PER_MILLION[model.to_s.sub(/\[.*\]\z/, '')] or return nil
      [input, cached, output].zip(price).sum { |tokens, rate| tokens.to_f * rate } / 1_000_000
    end
  end
end
