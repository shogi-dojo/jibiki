# frozen_string_literal: true

require 'rexml/parsers/streamparser'
require 'rexml/streamlistener'
require 'stringio'
require 'zlib'

module Kanji
  module Import
    # KanjiVG (CC BY-SA 3.0), read in document order without retaining its XML tree.
    # A full DOM exceeded the application's 768 MB sync-job limit with the word corpus loaded.
    module KanjiVG
      Stroke = Data.define(:position, :kind, :path)

      class Collector
        include REXML::StreamListener
        attr_reader :strokes

        def initialize
          @strokes = {}
          @codepoint = nil
          @drawing = nil
        end

        def tag_start(name, attributes)
          case name
          when 'kanji'
            hex = attributes['id'].to_s[/kanji_([0-9a-f]{4,6})\z/, 1]
            @codepoint = hex && format('U+%04X', hex.to_i(16))
            @drawing = []
          when 'path'
            return unless @codepoint

            @drawing << Stroke.new(position: @drawing.size + 1, kind: attributes['kvg:type'].to_s,
                                    path: attributes['d'].to_s)
          end
        end

        def tag_end(name)
          return unless name == 'kanji'

          @strokes[@codepoint] = @drawing if @codepoint && @drawing.any?
          @codepoint = nil
          @drawing = nil
        end
      end

      module_function

      def parse_file(path)
        File.open(path, 'rb') do |file|
          input = path.end_with?('.gz') ? Zlib::GzipReader.new(file) : file
          parse_io(input)
        end
      end

      def parse(xml) = parse_io(StringIO.new(xml))

      def parse_io(input)
        collector = Collector.new
        REXML::Parsers::StreamParser.new(input, collector).parse
        collector.strokes
      end
      private_class_method :parse_io
    end
  end
end
