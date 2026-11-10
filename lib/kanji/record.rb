# frozen_string_literal: true

require 'digest'
require 'json'
require_relative '../org_entry/document'

module Kanji
  # The source data for one character: KANJIDIC2 metadata (readings, English meanings, stroke
  # count, school grade, frequency). Stroke paths come from KanjiVG by codepoint and are not kept
  # in the Org record.
  Source = Data.define(:stroke_count, :grade, :frequency, :on_readings, :kun_readings, :meanings) do
    # A stable digest of the source data. Ukrainian translations never affect it, so editing a
    # translation does not mark the source as changed.
    def fingerprint
      canonical = {
        stroke_count: stroke_count, grade: grade, frequency: frequency,
        on: on_readings, kun: kun_readings, meanings: meanings
      }
      Digest::SHA256.hexdigest(JSON.generate(canonical))
    end
  end

  # One Ukrainian translation block. Its ID is stable for the life of the record, so reviews and
  # contributor proposals can address it across rebuilds.
  Translation = Data.define(:id, :text, :status, :reviewed_by)

  # One character's canonical Org record, keyed by codepoint (U+4E00.org for 一).
  class Record
    SCHEMA_VERSION = 1
    CODEPOINT_FORMAT = /\AU\+[0-9A-F]{4,6}\z/
    STATUSES = %w[draft reviewed].freeze
    SOURCE_HEADING = 'Source'
    TRANSLATIONS_HEADING = 'Ukrainian meanings'

    attr_reader :keywords, :source, :translations, :stored_fingerprint, :parse_problems

    def initialize(keywords:, source:, translations:, stored_fingerprint:)
      @keywords = keywords
      @source = source
      @translations = translations
      @stored_fingerprint = stored_fingerprint
    end

    def self.codepoint_for(character) = format('U+%04X', character.ord)

    def self.load(path)
      parse(File.read(path, encoding: 'UTF-8'))
    end

    def self.parse(content)
      doc = OrgEntry::Document.parse(content)
      source_node = doc.nodes.find { |node| node.title == SOURCE_HEADING }
      raise OrgEntry::ParseError.new('missing "* Source" section', 1) unless source_node

      new(
        keywords: doc.keywords,
        source: parse_source(source_node),
        translations: parse_translations(doc.nodes.find { |node| node.title == TRANSLATIONS_HEADING }),
        stored_fingerprint: source_node.properties['SOURCE_FINGERPRINT']
      )
    end

    def character = keywords['TITLE']
    def codepoint = keywords['CODEPOINT']

    # The fingerprint the source data actually has now, to compare with the stored one.
    def computed_fingerprint = source.fingerprint

    def self.parse_source(node)
      Source.new(
        stroke_count: integer_property(node, 'STROKE_COUNT'),
        grade: integer_property(node, 'GRADE'),
        frequency: integer_property(node, 'FREQUENCY'),
        on_readings: list_under(node, 'On readings'),
        kun_readings: list_under(node, 'Kun readings'),
        meanings: list_under(node, 'English meanings')
      )
    end

    def self.parse_translations(node)
      return [] unless node

      node.children.map do |child|
        Translation.new(
          id: child.title,
          text: child.content.find { |item| item.label == 'text' }&.value,
          status: child.properties['STATUS'],
          reviewed_by: child.properties['REVIEWED_BY']
        )
      end
    end

    def self.integer_property(node, key)
      value = node.properties[key]
      value.nil? || value.empty? ? nil : Integer(value, exception: false)
    end

    def self.list_under(node, title)
      child = node.find_child(title)
      return [] unless child

      child.content.map { |item| item.value.to_s }.reject(&:empty?)
    end
    private_class_method :parse_source, :parse_translations, :integer_property, :list_under
  end
end
