# frozen_string_literal: true

require 'rexml/document'
require 'zlib'
require_relative '../record'

module Kanji
  module Import
    # Reads KANJIDIC2 (EDRDG, CC BY-SA 4.0): one character per <character> element. Only the
    # fields the records keep are read: the Unicode codepoint, grade, stroke count, frequency,
    # the on and kun readings, and the English meanings (meanings without an m_lang attribute).
    module Kanjidic2
      module_function

      Entry = Data.define(:codepoint, :character, :source)

      def parse_file(path)
        xml = path.end_with?('.gz') ? Zlib::GzipReader.open(path, &:read) : File.read(path, encoding: 'UTF-8')
        parse(xml)
      end

      def parse(xml)
        document = REXML::Document.new(xml)
        document.get_elements('/kanjidic2/character').filter_map { |node| entry(node) }
      end

      def entry(node)
        ucs = node.get_text('codepoint/cp_value[@cp_type="ucs"]')&.value
        character = node.get_text('literal')&.value
        return nil if ucs.nil? || character.nil?

        codepoint = format('U+%04X', ucs.to_i(16))
        Entry.new(codepoint: codepoint, character: character, source: source(node))
      end

      def source(node)
        Source.new(
          stroke_count: integer(node, 'misc/stroke_count'),
          grade: integer(node, 'misc/grade'),
          frequency: integer(node, 'misc/freq'),
          on_readings: readings(node, 'ja_on'),
          kun_readings: readings(node, 'ja_kun'),
          meanings: node.get_elements('reading_meaning/rmgroup/meaning[not(@m_lang)]').map { |m| m.text.to_s }
        )
      end

      def readings(node, type)
        node.get_elements("reading_meaning/rmgroup/reading[@r_type=\"#{type}\"]").map { |r| r.text.to_s }
      end

      def integer(node, path)
        text = node.get_text(path)&.value
        text && Integer(text, exception: false)
      end
    end
  end
end
