# frozen_string_literal: true

require_relative 'record'

module Kanji
  # Checks one character record and returns its problems as messages (empty when it is valid).
  # Rules: the codepoint is well formed and matches the title and the file name; the stored source
  # fingerprint matches the source data; translation IDs are unique and belong to this character;
  # every translation has text and a known status; a reviewed translation names its reviewer.
  module Validator
    module_function

    def call(record, filename: nil)
      problems = []
      problems.concat(codepoint_problems(record, filename))
      problems.concat(source_problems(record))
      problems.concat(translation_problems(record))
      problems
    end

    def codepoint_problems(record, filename)
      codepoint = record.codepoint
      problems = []
      unless codepoint.to_s.match?(Record::CODEPOINT_FORMAT)
        problems << "CODEPOINT #{codepoint.inspect} is not U+XXXX"
      end
      if record.character.to_s.length != 1
        problems << "TITLE must be a single character, got #{record.character.inspect}"
      elsif codepoint && codepoint != Record.codepoint_for(record.character)
        problems << "CODEPOINT #{codepoint} does not match TITLE #{record.character}"
      end
      if filename && codepoint && File.basename(filename, '.org') != codepoint
        problems << "file name #{File.basename(filename)} does not match CODEPOINT #{codepoint}"
      end
      problems
    end

    def source_problems(record)
      problems = []
      stroke_count = record.source.stroke_count
      problems << 'STROKE_COUNT must be a positive integer' unless stroke_count&.positive?
      if record.stored_fingerprint.nil? || record.stored_fingerprint.empty?
        problems << 'SOURCE_FINGERPRINT is missing; rerun the source patch'
      elsif record.stored_fingerprint != record.computed_fingerprint
        problems << 'SOURCE_FINGERPRINT is stale: the source data changed without a patch'
      end
      problems
    end

    def translation_problems(record)
      problems = []
      seen = {}
      record.translations.each do |translation|
        id = translation.id
        problems << "translation #{id} appears twice" if seen[id]
        seen[id] = true
        unless id.start_with?("uk-#{record.codepoint}-")
          problems << "translation #{id} does not belong to #{record.codepoint}"
        end
        problems << "translation #{id} has no text" if translation.text.to_s.strip.empty?
        unless Record::STATUSES.include?(translation.status)
          problems << "translation #{id} has status #{translation.status.inspect}"
        end
        if translation.status == 'reviewed' && translation.reviewed_by.to_s.empty?
          problems << "translation #{id} is reviewed but names no REVIEWED_BY"
        end
      end
      problems
    end
  end
end
