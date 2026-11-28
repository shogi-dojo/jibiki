# frozen_string_literal: true

require 'open3'
require_relative '../kana'

module Authoring
  # Produces the hiragana READING of an example sentence mechanically, so the
  # model never has to write it. Kana in the sentence are kept as written
  # (katakana folded to hiragana) and kanji take MeCab's reading; the headword
  # itself always takes its JMdict reading. A sentence the analyzer cannot
  # read fully (digits, Latin letters, unknown kanji) yields nil, and the
  # caller asks the model for that one reading instead.
  module Reading
    KANA = /\A[\p{Hiragana}\p{Katakana}ー]+\z/
    SYMBOLS = /\A[\p{P}\p{S}\p{Zs}]+\z/

    # Wraps the mecab binary: one process call reads any number of lines.
    class Mecab
      FORMAT = ['-F', "%m\t%f[7]\n", '-U', "%m\t\n", '-E', "EOS\n"].freeze

      def initialize(command: 'mecab')
        @command = command
      end

      # lines: strings without newlines. Returns one [[surface, reading]] per line.
      def tokenize(lines)
        return [] if lines.empty?

        out, err, status = Open3.capture3(@command, *FORMAT, stdin_data: "#{lines.join("\n")}\n")
        raise "mecab failed: #{err}" unless status.success?

        out.force_encoding('UTF-8').split("EOS\n", -1).first(lines.size).map do |block|
          block.lines.map { |l| l.chomp.split("\t", 2) }.map { |surface, reading| [surface, reading.to_s] }
        end
      end
    end

    module_function

    # sentences: [{ ja:, focus:, focus_reading: }] where focus_reading is the
    # JMdict reading when focus is the dictionary form, else nil.
    # Returns one reading (or nil) per sentence, using a single analyzer call.
    def readings(sentences, analyzer: Mecab.new)
      plans = sentences.map { |s| segments(s) }
      tokens = analyzer.tokenize(plans.flat_map { |plan| plan.reject { |seg| seg.is_a?(Fixed) } }.reject(&:empty?))
      cursor = 0
      plans.map do |plan|
        parts = plan.map do |seg|
          next seg.text if seg.is_a?(Fixed)
          next '' if seg.empty?

          reading_of(tokens.fetch(cursor).tap { cursor += 1 })
        end
        parts.include?(nil) ? nil : parts.join
      end
    end

    Fixed = Struct.new(:text)

    def segments(sentence)
      ja = sentence.fetch(:ja)
      focus = sentence[:focus].to_s
      focus_reading = sentence[:focus_reading]
      return [ja] if focus.empty? || focus_reading.nil? || !ja.include?(focus)

      ja.split(focus, -1).flat_map { |part| [part, Fixed.new(Kana.to_hiragana(focus_reading))] }[0...-1]
    end

    def reading_of(tokens)
      parts = tokens.map do |surface, reading|
        if surface.match?(KANA) then Kana.to_hiragana(surface)
        elsif surface.match?(SYMBOLS) then surface
        elsif reading.match?(KANA) then Kana.to_hiragana(reading)
        end
      end
      parts.include?(nil) ? nil : parts.join
    end
  end
end
