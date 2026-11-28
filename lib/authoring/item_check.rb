# frozen_string_literal: true

require 'yanagi'
require_relative '../entry_doctor'
require_relative '../entry_validator'
require_relative '../org_entry'
require_relative 'prompt'

module Authoring
  # Renders each authored item in memory and runs the same gates `jb check`
  # runs on disk (validator, doctor errors and warnings, yanagi tier 1), plus
  # the note-length cap from the prompt. Returns { number => [messages] } for
  # the failing items only, so a retry can target exactly those words.
  module ItemCheck
    module_function

    # renderer: a BccwjBatch::Renderer; items: { number => [row, data] }.
    # scanner: anything answering scan_text like Yanagi::Audit.
    def run(renderer, items, scanner: Yanagi::Audit)
      items.each_with_object({}) do |(number, (row, data)), failures|
        messages = check(renderer, row, data, scanner:)
        failures[number] = messages unless messages.empty?
      end
    end

    def check(renderer, row, data, scanner: Yanagi::Audit)
      messages = note_length_messages(data)
      text = begin
        renderer.render_text(row:, data:)
      rescue RuntimeError, KeyError, IndexError => e
        return messages << e.message
      end

      messages.concat(EntryValidator.validate_text(text))
      messages.concat(doctor_messages(text))
      messages.concat(yanagi_messages(text, scanner))
    end

    def note_length_messages(data)
      Array(data['senses']).each_with_index.filter_map do |(_, note), idx|
        next if note.to_s.length <= Prompt::NOTE_MAX_CHARS

        "G#{idx + 1} note is #{note.length} characters (max #{Prompt::NOTE_MAX_CHARS})"
      end
    end

    def doctor_messages(text)
      report = EntryDoctor.analyze(OrgEntry.parse(text))
      report.findings.reject { |f| f.severity == :info }.map { |f| "#{f.check}: #{f.detail}" }
    end

    def yanagi_messages(text, scanner)
      scanner.scan_text(text, tier2: false).map do |f|
        "Polivanov spelling '#{f.token}'#{f.canonical ? " (use '#{f.canonical}')" : ''}"
      end
    end
  end
end
