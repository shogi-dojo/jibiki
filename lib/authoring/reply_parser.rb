# frozen_string_literal: true

require_relative 'prompt'

module Authoring
  # Parses the line-format reply described in Authoring::Prompt::RULES into
  # the payload hash BccwjBatch::Renderer consumes:
  #   { "N" => { "focus", "primary_sense", "senses" => [[gloss, note]],
  #              "examples" => [[ja, reading, uk, focus?]] } }
  # Readings are left nil unless the reply carries them; problems are
  # reported per item so only the failing words need a retry.
  module ReplyParser
    Result = Struct.new(:payload, :errors, keyword_init: true)

    HEADER = /\A@(\d+)\s+p=(\d+)\s*\z/
    EXAMPLE_COUNT = 3

    module_function

    # rows_by_number: { "N" => selection row } for the items that were asked.
    def parse(text, rows_by_number)
      items = collect(text)
      payload = {}
      errors = Hash.new { |h, k| h[k] = [] }

      rows_by_number.each do |number, row|
        item = items[number]
        if item.nil?
          errors[number] << 'missing from reply'
          next
        end

        errors[number].concat(item[:problems])
        data = build_item(item, row, errors[number])
        payload[number] = data if errors[number].empty?
      end

      Result.new(payload:, errors: errors.reject { |_, v| v.empty? })
    end

    def collect(text)
      items = {}
      current = nil
      text.to_s.each_line do |raw|
        line = raw.strip
        next if line.empty? || line.start_with?('```')

        if (m = HEADER.match(line))
          current = { primary: m[2].to_i, senses: {}, examples: [], problems: [] }
          current[:problems] << 'duplicated in reply' if items.key?(m[1])
          items[m[1]] = current
        elsif current.nil?
          next
        elsif line.start_with?('G')
          parse_gloss(line, current)
        elsif line.start_with?('E|')
          current[:examples] << line.split('|', -1).drop(1).map(&:strip)
        else
          current[:problems] << "unexpected line: #{line[0, 40]}"
        end
      end
      items
    end

    def parse_gloss(line, item)
      tag, gloss, note, *rest = line.split('|', -1).map(&:strip)
      index = tag[/\AG(\d+)\z/, 1]&.to_i
      if index.nil? || !rest.empty?
        item[:problems] << "malformed gloss line: #{line[0, 40]}"
      elsif item[:senses].key?(index)
        item[:problems] << "G#{index} given twice"
      else
        item[:senses][index] = [gloss.to_s, note.to_s]
      end
    end

    def build_item(item, row, errors)
      sense_count = Prompt.english_senses(row).size
      expected = (1..sense_count).to_a
      got = item[:senses].keys.sort
      errors << "expected G1..G#{sense_count}, got #{got.map { |i| "G#{i}" }.join(',')}" unless got == expected
      errors << "p=#{item[:primary]} is not a sense number" unless expected.include?(item[:primary])
      item[:senses].each do |index, (gloss, note)|
        errors << "G#{index} has an empty gloss or note" if gloss.empty? || note.empty?
      end

      examples = item[:examples].map { |fields| example_tuple(fields, errors) }
      errors << "expected #{EXAMPLE_COUNT} examples, got #{examples.size}" unless examples.size == EXAMPLE_COUNT
      return nil unless errors.empty?

      {
        'focus' => row['written'],
        'primary_sense' => item[:primary],
        'senses' => expected.map { |i| item[:senses][i] },
        'examples' => examples
      }
    end

    # E|ja|uk[|focus[|reading]]
    def example_tuple(fields, errors)
      ja, uk, focus, reading, *rest = fields
      if ja.to_s.empty? || uk.to_s.empty? || !rest.empty?
        errors << "malformed example: #{fields.join('|')[0, 40]}"
        return nil
      end

      tuple = [ja, reading.to_s.empty? ? nil : reading, uk]
      tuple << focus unless focus.to_s.empty?
      tuple
    end
  end
end
