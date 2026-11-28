# frozen_string_literal: true

require_relative 'item_check'
require_relative 'prompt'
require_relative 'reading'
require_relative 'reply_parser'

module Authoring
  # Authors one batch: prompt → reply → parse → in-memory checks, then
  # re-asks only for the items that failed, with their error messages, up to
  # max_retries times. The model sees nothing but the word lines; rendering,
  # IDs and every other field stay mechanical.
  class BatchAuthor
    Outcome = Struct.new(:payload, :failures, :attempts, :reading_flags, keyword_init: true)
    Attempt = Struct.new(:items, :chars_in, :chars_out, :seconds, :usage, :usage_update, :tool_calls, :failed,
                         keyword_init: true)

    # llm: responds to call(system:, user:) with an object carrying text,
    #   seconds, usage, usage_update (AcpClient::Result).
    # analyzer: a Reading analyzer used to cross-check model readings, or nil.
    def initialize(llm:, renderer:, max_retries: 2, analyzer: nil, scanner: Yanagi::Audit)
      @llm = llm
      @renderer = renderer
      @max_retries = max_retries
      @analyzer = analyzer
      @scanner = scanner
    end

    # rows: { "N" => selection row }. Returns an Outcome whose payload holds
    # every item that passed and whose failures holds the rest.
    def author(rows)
      payload = {}
      attempts = []
      errors = {}
      pending = rows

      (@max_retries + 1).times do
        prompt = Prompt.build(pending.values, numbers: pending.keys, errors:, readings: true)
        reply = @llm.call(**prompt)
        parsed = ReplyParser.parse(reply.text, pending)
        checked = ItemCheck.run(@renderer, parsed.payload.to_h { |n, data| [n, [pending[n], data]] },
                                scanner: @scanner)
        payload.merge!(parsed.payload.reject { |n, _| checked.key?(n) })
        errors = parsed.errors.merge(checked)
        attempts << Attempt.new(items: pending.size, chars_in: prompt[:system].size + prompt[:user].size,
                                chars_out: reply.text.size, seconds: reply.seconds, usage: reply.usage,
                                usage_update: reply.usage_update, tool_calls: reply.tool_calls,
                                failed: errors.size)
        pending = rows.slice(*errors.keys)
        break if pending.empty?
      end

      Outcome.new(payload: sort(payload), failures: errors, attempts:, reading_flags: reading_flags(rows, payload))
    end

    private

    def sort(payload) = payload.sort_by { |n, _| n.to_i }.to_h

    # Example readings the analyzer reads differently: worth a human look,
    # never a retry (the analyzer is wrong about as often as the model).
    def reading_flags(rows, payload)
      return [] unless @analyzer

      sentences = payload.flat_map do |n, data|
        row = rows[n]
        data['examples'].map do |ja, reading, _uk, focus|
          focus ||= data['focus']
          { number: n, ja:, reading:, focus:, focus_reading: focus == row['written'] ? row['reading'] : nil }
        end
      end
      got = Reading.readings(sentences, analyzer: @analyzer)
      sentences.zip(got).filter_map do |s, analyzer_reading|
        next if analyzer_reading.nil? || Kana.to_hiragana(analyzer_reading) == Kana.to_hiragana(s[:reading].to_s)

        { 'number' => s[:number], 'ja' => s[:ja], 'model' => s[:reading], 'analyzer' => analyzer_reading }
      end
    end
  end
end
