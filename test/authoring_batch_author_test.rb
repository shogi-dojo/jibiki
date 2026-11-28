# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/bccwj_batch'
require_relative '../lib/authoring/batch_author'
require_relative 'support/authoring_rows'

class AuthoringBatchAuthorTest < Minitest::Test
  Reply = Struct.new(:text, :seconds, :usage, :usage_update, :tool_calls, keyword_init: true)

  # Replays canned replies and records every prompt it was sent.
  class ScriptedLlm
    attr_reader :prompts

    def initialize(*replies)
      @replies = replies
      @prompts = []
    end

    def call(system:, user:)
      @prompts << user
      Reply.new(text: @replies.shift, seconds: 1.0, usage: { 'outputTokens' => 10 })
    end
  end

  class NoFindings
    def self.scan_text(_text, tier2:) = tier2 ? nil : []
  end

  READINGS = %w[あおになりました。 しんごうがあおにかわったのでわたった。 あおいろのひょうしきがめじるしとしてせっちされている。].freeze

  def reply(number)
    lines = AuthoringRows.ao_reply(number).lines
    ex = 0
    lines.map do |line|
      next line unless line.start_with?('E|')

      fields = line.chomp.split('|', -1)
      fields << '' while fields.size < 4
      ex += 1
      "#{(fields + [READINGS[ex - 1]]).join('|')}\n"
    end.join
  end

  def setup
    @row = AuthoringRows.ao
    @renderer = BccwjBatch::Renderer.new(sources: [@row], sha256: EntryValidator::KNOWN_JMDICT_SHA256S.first,
                                         created_at: '2026-11-28')
  end

  def author(llm, **opts)
    Authoring::BatchAuthor.new(llm:, renderer: @renderer, scanner: NoFindings, **opts)
                          .author({ '1' => @row, '2' => @row })
  end

  def test_retries_only_failing_items_with_their_errors
    broken = reply(2).sub(/^E\|信号.*\n/, '')
    llm = ScriptedLlm.new(reply(1) + broken, reply(2))
    outcome = author(llm)

    assert_equal %w[1 2], outcome.payload.keys
    assert_empty outcome.failures
    assert_equal [2, 1], outcome.attempts.map(&:items)
    assert_equal [1, 0], outcome.attempts.map(&:failed)
    assert_includes llm.prompts[1], '@2: expected 3 examples, got 2'
    refute_includes llm.prompts[1], '@1 青'
  end

  def test_gives_up_after_max_retries
    llm = ScriptedLlm.new(reply(1), '', '')
    outcome = author(llm, max_retries: 2)

    assert_equal ['1'], outcome.payload.keys
    assert_equal({ '2' => ['missing from reply'] }, outcome.failures)
    assert_equal 3, outcome.attempts.size
  end

  def test_reading_flags_list_analyzer_disagreements
    analyzer = Object.new
    analyzer.define_singleton_method(:tokenize) do |lines|
      lines.map { |l| l == 'になりました。' ? [%w[に ニ], %w[なり ナリ], %w[まし マシ], %w[た タ], ['。', '']] : [[l, '']] }
    end
    llm = ScriptedLlm.new(reply(1) + reply(2).sub('あおになりました。', 'あをになりました。'))
    flags = author(llm, analyzer:).reading_flags

    assert_equal [{ 'number' => '2', 'ja' => '青になりました。', 'model' => 'あをになりました。', 'analyzer' => 'あおになりました。' }], flags
  end
end
