# frozen_string_literal: true

require 'digest'
require 'json'
require 'rexml/document'
require 'zlib'

module DictionarySources
  class Jmdict
    KNOWN_ENTRY_ELEMENTS = %w[ent_seq k_ele r_ele sense].freeze

    attr_reader :path

    def initialize(path)
      @path = File.expand_path(path)
      @entities = nil
    end

    def lookup(written: nil, reading: nil, ent_seq: nil)
      written = normalize_query(written)
      reading = normalize_query(reading)
      ent_seq = ent_seq.to_s unless ent_seq.nil?
      raise ArgumentError, 'provide written, reading, or ent_seq' if [written, reading, ent_seq].all?(&:nil?)

      each_entry_xml.filter_map do |xml|
        next unless candidate_xml?(xml, written:, reading:, ent_seq:)

        entry = parse_entry(xml)
        next unless exact_match?(entry, written:, reading:, ent_seq:)

        entry
      end
    end

    def archive_sha256
      Digest::SHA256.file(path).hexdigest
    end

    private

    def normalize_query(value)
      return nil if value.nil? || value.empty?

      value.unicode_normalize(:nfc)
    end

    def each_entry_xml
      return enum_for(__method__) unless block_given?

      inside_entry = false
      entry_lines = []

      Zlib::GzipReader.open(path) do |gzip|
        gzip.each_line do |line|
          if line.include?('<entry>')
            inside_entry = true
            entry_lines = [line]
          elsif inside_entry
            entry_lines << line
            if line.include?('</entry>')
              yield entry_lines.join
              inside_entry = false
              entry_lines = []
            end
          end
        end
      end
    end

    def candidate_xml?(xml, written:, reading:, ent_seq:)
      return false if ent_seq && !xml.include?("<ent_seq>#{ent_seq}</ent_seq>")
      return false if written && !xml.include?("<keb>#{REXML::Text.normalize(written)}</keb>")
      return false if reading && !xml.include?("<reb>#{REXML::Text.normalize(reading)}</reb>")

      true
    end

    def exact_match?(entry, written:, reading:, ent_seq:)
      return false if ent_seq && entry[:ent_seq] != ent_seq
      return false if written && entry[:written_forms].none? { |form| form[:text] == written }
      return false if reading && entry[:readings].none? { |form| form[:text] == reading }

      true
    end

    def parse_entry(xml)
      entry_element = REXML::Document.new(xml).root
      ent_seq = entry_element.elements['ent_seq'].text
      senses = entry_element.get_elements('sense').each_with_index.map do |sense, index|
        parse_sense(ent_seq, index + 1, sense)
      end

      {
        ent_seq:,
        written_forms: entry_element.get_elements('k_ele').map { |element| parse_written_form(element) },
        readings: entry_element.get_elements('r_ele').map { |element| parse_reading(element) },
        senses:,
        sense_indexes_by_language: sense_indexes_by_language(senses),
        unknown_entry_elements: entry_element.elements.filter_map do |element|
          element.name unless KNOWN_ENTRY_ELEMENTS.include?(element.name)
        end.uniq,
        source_entry_sha256: Digest::SHA256.hexdigest(xml)
      }
    end

    def parse_written_form(element)
      {
        text: element.elements['keb'].text.unicode_normalize(:nfc),
        information: codes(element, 'ke_inf'),
        priorities: texts(element, 'ke_pri')
      }
    end

    def parse_reading(element)
      {
        text: element.elements['reb'].text.unicode_normalize(:nfc),
        no_kanji: !element.elements['re_nokanji'].nil?,
        applies_to_written_forms: texts(element, 're_restr'),
        information: codes(element, 're_inf'),
        priorities: texts(element, 're_pri')
      }
    end

    def parse_sense(ent_seq, index, element)
      fingerprint = fingerprint_for(ent_seq, index, element)

      {
        index:,
        applies_to_written_forms: texts(element, 'stagk'),
        applies_to_readings: texts(element, 'stagr'),
        parts_of_speech: codes(element, 'pos'),
        cross_references: texts(element, 'xref'),
        antonyms: texts(element, 'ant'),
        fields: codes(element, 'field'),
        miscellaneous: codes(element, 'misc'),
        information: texts(element, 's_inf'),
        language_sources: language_sources(element),
        dialects: codes(element, 'dial'),
        glosses: glosses(element),
        examples: examples(element),
        source_fingerprint: fingerprint
      }
    end

    def fingerprint_for(ent_seq, index, element)
      data = {
        'ent_seq' => ent_seq,
        'sense_index' => index,
        'stagk' => texts(element, 'stagk'),
        'stagr' => texts(element, 'stagr'),
        'pos' => codes(element, 'pos'),
        'xref' => texts(element, 'xref'),
        'ant' => texts(element, 'ant'),
        'field' => codes(element, 'field'),
        'misc' => codes(element, 'misc'),
        's_inf' => texts(element, 's_inf'),
        'lsource' => language_sources(element).map { |source| stringify_keys(source) },
        'dial' => codes(element, 'dial'),
        'gloss' => glosses(element).map { |gloss| stringify_keys(gloss) },
        'example' => examples(element).map { |example| stringify_keys(example) }
      }

      Digest::SHA256.hexdigest(JSON.generate(data))
    end

    def language_sources(element)
      element.get_elements('lsource').map do |source|
        {
          lang: source.attribute('lang', 'xml')&.value || 'eng',
          type: source.attribute('ls_type')&.value || 'full',
          wasei: source.attribute('ls_wasei')&.value == 'y',
          text: (source.text || '').unicode_normalize(:nfc)
        }
      end
    end

    def glosses(element)
      element.get_elements('gloss').map do |gloss|
        {
          lang: gloss.attribute('lang', 'xml')&.value || 'eng',
          type: gloss.attribute('g_type')&.value || 'plain',
          gender: gloss.attribute('g_gend')&.value || 'none',
          primary: !gloss.elements['pri'].nil?,
          text: (gloss.text || '').unicode_normalize(:nfc)
        }
      end
    end

    def examples(element)
      element.get_elements('example').map do |example|
        {
          db: example.attribute('db')&.value || '',
          id: example.attribute('id')&.value || '',
          text: (example.text || '').unicode_normalize(:nfc)
        }
      end
    end

    def texts(element, name)
      element.get_elements(name).map { |child| (child.text || '').unicode_normalize(:nfc) }
    end

    def codes(element, name)
      texts(element, name).map do |text|
        if text.match?(/\A&\S+;\z/)
          text[1...-1]
        else
          entities.fetch(text, text)
        end
      end
    end

    def entities
      @entities ||= begin
        result = {}
        Zlib::GzipReader.open(path) do |gzip|
          gzip.each_line.with_index do |line, index|
            break if index > 2_000

            match = line.match(/<!ENTITY\s+(\S+)\s+"([^"]+)"\s*>/)
            result[match[2]] = match[1] if match
          end
        end
        result
      end
    end

    def stringify_keys(hash)
      hash.transform_keys(&:to_s)
    end

    def sense_indexes_by_language(senses)
      senses.each_with_object(Hash.new { |hash, key| hash[key] = [] }) do |sense, grouped|
        sense[:glosses].map { |gloss| gloss[:lang] }.uniq.each do |language|
          grouped[language] << sense[:index]
        end
      end
    end
  end
end
