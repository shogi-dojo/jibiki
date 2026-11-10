# frozen_string_literal: true

require 'digest'
require 'etc'
require 'fileutils'
require 'json'
require 'rexml/document'
require 'zlib'
require_relative 'jmdict_index'

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

      results = []
      each_entry_xml do |xml|
        next unless candidate_xml?(xml, written:, reading:, ent_seq:)

        entry = parse_entry(xml)
        next unless exact_match?(entry, written:, reading:, ent_seq:)

        results << entry
        # ent_seq is unique in JMdict: the first match is the only one.
        break if ent_seq
      end
      results
    end

    # Resolves many queries in a single pass over the archive. Takes an array
    # of {written:, reading:, ent_seq:} hashes and returns an array of match
    # arrays in the same order.
    def lookup_many(queries)
      queries = queries.map do |query|
        {
          written: normalize_query(query[:written]),
          reading: normalize_query(query[:reading]),
          ent_seq: query[:ent_seq]&.to_s
        }
      end
      queries.each do |query|
        raise ArgumentError, 'provide written, reading, or ent_seq' if query.values.all?(&:nil?)
      end

      results = Array.new(queries.length) { [] }
      by_key = candidate_index(queries)
      each_entry_xml do |xml|
        candidates = entry_keys(xml).flat_map { |key| by_key.fetch(key, []) }.uniq
        candidates.select! { |i| candidate_xml?(xml, **queries[i]) }
        next if candidates.empty?

        entry = parse_entry(xml)
        candidates.sort.each do |i|
          results[i] << entry if exact_match?(entry, **queries[i])
        end
      end
      results
    end

    def archive_sha256
      Digest::SHA256.file(path).hexdigest
    end

    # Builds the JmdictIndex for this archive and returns its path. Parsing
    # every entry with REXML takes about 12 CPU-minutes, so the entries are
    # dealt out to forked workers and their lines merged in ent_seq order.
    def write_index(cache_root: JmdictIndex.cache_root, workers: Etc.nprocessors)
      sha = JmdictIndex.archive_sha256(path, cache_root)
      target = JmdictIndex.index_path(sha, cache_root)
      FileUtils.mkdir_p(cache_root)
      xmls = each_entry_xml.to_a
      entities # parsed once here, inherited by every worker
      parts = Array.new(workers) { |worker| "#{target}.part#{worker}" }
      pids = parts.each_with_index.map do |part, worker|
        fork do
          File.open(part, 'w:UTF-8') do |out|
            worker.step(xmls.length - 1, workers) { |i| out.puts(JmdictIndex.line_for(parse_entry(xmls[i]))) }
          end
          exit!(0)
        end
      end
      failed = pids.reject { |pid| Process.wait2(pid).last.success? }
      raise "JMdict index: #{failed.length} worker(s) failed" unless failed.empty?

      lines = parts.flat_map { |part| File.readlines(part, chomp: true, encoding: 'UTF-8') }
      lines.sort_by! { |line| line.split("\t", 2)[0].to_i }
      File.open("#{target}.tmp", 'w:UTF-8') do |out|
        out.puts("# #{JmdictIndex::HEADER} sha256=#{sha}")
        lines.each { |line| out.puts(line) }
      end
      File.rename("#{target}.tmp", target)
      target
    ensure
      parts&.each { |part| FileUtils.rm_f(part) }
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

      Zlib::GzipReader.open(path, external_encoding: Encoding::UTF_8) do |gzip|
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

    # Maps each query's most selective key, as it appears in the raw XML, to
    # the indexes of the queries that need it. An entry can only satisfy a
    # query whose key it carries, so each archive entry is checked against a
    # handful of queries instead of all of them.
    def candidate_index(queries)
      by_key = Hash.new { |hash, key| hash[key] = [] }
      queries.each_with_index do |query, index|
        key =
          if query[:ent_seq] then "s:#{query[:ent_seq]}"
          elsif query[:written] then "k:#{xml_escape(query[:written])}"
          else "r:#{xml_escape(query[:reading])}"
          end
        by_key[key] << index
      end
      by_key
    end

    # The candidate keys one raw entry carries: its ent_seq, kebs and rebs.
    def entry_keys(xml)
      keys = ["s:#{xml[%r{<ent_seq>([^<]*)</ent_seq>}, 1]}"]
      xml.scan(%r{<keb>([^<]*)</keb>}) { |(text)| keys << "k:#{text}" }
      xml.scan(%r{<reb>([^<]*)</reb>}) { |(text)| keys << "r:#{text}" }
      keys
    end

    def candidate_xml?(xml, written:, reading:, ent_seq:)
      return false if ent_seq && !xml.include?("<ent_seq>#{ent_seq}</ent_seq>")
      return false if written && !xml.include?("<keb>#{xml_escape(written)}</keb>")
      return false if reading && !xml.include?("<reb>#{xml_escape(reading)}</reb>")

      true
    end

    # Escapes text as REXML::Text.normalize does, so a query matches the
    # element text exactly as the archive spells it.
    def xml_escape(text)
      text.gsub('&', '&amp;').gsub('<', '&lt;').gsub('>', '&gt;').gsub('"', '&quot;').gsub("'", '&apos;')
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
        Zlib::GzipReader.open(path, external_encoding: Encoding::UTF_8) do |gzip|
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
