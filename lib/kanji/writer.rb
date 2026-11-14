# frozen_string_literal: true

require_relative 'record'

module Kanji
  # Renders a character record as Org text in one canonical layout, and patches the source data of
  # an existing record without touching its translations.
  module Writer
    module_function

    def render(keywords:, source:, translations: [])
      lines = []
      header = { 'TITLE' => keywords.fetch('TITLE'), 'CODEPOINT' => keywords.fetch('CODEPOINT'),
                 'SCHEMA_VERSION' => Record::SCHEMA_VERSION, 'DEFAULT_LICENSE' => 'CC-BY-SA-4.0' }
      header.merge!(keywords.reject { |key, _| header.key?(key) })
      header.each { |key, value| lines << "#+#{key}: #{value}" }
      lines << ''
      lines.concat(source_lines(source))
      lines << ''
      lines.concat(translation_lines(translations))
      "#{lines.join("\n")}\n"
    end

    # The same record with new source data: keywords and translations are kept as parsed, and the
    # fingerprint is recomputed from the new source.
    def patch_source(record, source)
      render(keywords: record.keywords, source: source, translations: record.translations)
    end

    def source_lines(source)
      lines = [
        "* #{Record::SOURCE_HEADING}", ':PROPERTIES:',
        ":SOURCE_FINGERPRINT: #{source.fingerprint}", ":STROKE_COUNT: #{source.stroke_count}"
      ]
      lines << ":GRADE: #{source.grade}" unless source.grade.nil?
      lines << ":FREQUENCY: #{source.frequency}" unless source.frequency.nil?
      lines << ':END:'
      lines.concat(list_section('On readings', source.on_readings))
      lines.concat(list_section('Kun readings', source.kun_readings))
      lines.concat(list_section('English meanings', source.meanings))
      lines
    end

    def list_section(title, items)
      return [] if items.empty?

      ["** #{title}", *items.map { |item| "- #{item}" }]
    end

    def translation_lines(translations)
      lines = ["* #{Record::TRANSLATIONS_HEADING}"]
      translations.each do |translation|
        lines << "** #{translation.id}" << ':PROPERTIES:' << ":STATUS: #{translation.status}"
        lines << ":REVIEWED_BY: #{translation.reviewed_by}" if translation.reviewed_by
        lines << ':END:' << "- text :: #{translation.text}"
      end
      lines
    end
  end
end
