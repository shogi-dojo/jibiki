# frozen_string_literal: true

require 'yanagi'
require_relative 'record'

module Kanji
  # Advisory findings, never automatic edits or human-review status changes. Native Ukrainian
  # words must be supplied to Yanagi's checker: transliteration rules alone are not a spellchecker.
  module DraftAudit
    module_function

    def call(records, policy)
      anchors = Yanagi::Checker::MemoryAnchors.new(policy.fetch('anchors'))
      words = Yanagi::Checker::WordSet.new(policy.fetch('ukrainian_words').keys)
      checker = Yanagi::Checker.new(anchors: anchors, ukrainian: words)
      findings = records.flat_map do |record|
        record.translations.flat_map do |translation|
          checker.check(translation.text).map do |finding|
            { codepoint: record.codepoint, id: translation.id, token: finding.token,
              suggestion: finding.suggestion, kind: finding.kind, source: finding.source }
          end
        end
      end
      empty = records.select { |record| record.source.meanings.any? && record.translations.empty? }.map(&:codepoint)
      metadata_only = records.select do |record|
        record.translations.any? { |translation| translation.text.gsub(/\([^)]*\)/, '').strip.empty? }
      end.map(&:codepoint)
      { yanagi_version: Yanagi::VERSION, records: records.size,
        translated_records: records.count { |record| record.translations.any? },
        source_gaps: records.count { |record| record.source.meanings.empty? },
        untranslated_source_gaps: records.count do |record|
          record.source.meanings.empty? && record.translations.empty?
        end,
        reviewed_records: records.count { |record| record.translations.any? { |t| t.status == 'reviewed' } },
        missing_drafts: empty, metadata_only_drafts: metadata_only,
        foreign_script_drafts: records.select { |record| record.translations.any? { |t| t.text.match?(/[ыэъё]/i) } }.map(&:codepoint),
        findings: findings }
    end
  end
end
