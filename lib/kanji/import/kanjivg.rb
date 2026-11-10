# frozen_string_literal: true

require 'rexml/document'
require 'zlib'

module Kanji
  module Import
    # Reads KanjiVG (CC BY-SA 3.0): the stroke paths of each character, in drawing order. The
    # stroke numbering is the document order of the <path> elements under the character's <kanji>.
    module KanjiVG
      module_function

      Stroke = Data.define(:position, :kind, :path)

      # codepoint (U+4E00) => [Stroke, ...], for every character that has strokes.
      def parse_file(path)
        xml = path.end_with?('.gz') ? Zlib::GzipReader.open(path, &:read) : File.read(path, encoding: 'UTF-8')
        parse(xml)
      end

      def parse(xml)
        REXML::Document.new(xml).get_elements('//kanji').each_with_object({}) do |kanji, strokes|
          hex = kanji.attributes['id'].to_s[/kanji_([0-9a-f]{4,6})\z/, 1]
          next unless hex

          paths = kanji.get_elements('.//path')
          next if paths.empty?

          strokes[format('U+%04X', hex.to_i(16))] = paths.each_with_index.map do |path, index|
            Stroke.new(position: index + 1, kind: path.attributes['kvg:type'].to_s, path: path.attributes['d'].to_s)
          end
        end
      end
    end
  end
end
