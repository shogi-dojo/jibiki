# frozen_string_literal: true

require 'fileutils'
require_relative 'record'
require_relative 'writer'
require_relative 'import/kanjidic2'
require_relative 'import/kanjivg'

module Kanji
  # Writes one record per KANJIDIC2 character into the records directory, keyed by codepoint. A
  # record that already exists keeps its Ukrainian translations: only its source section is
  # replaced, so reruns after an upstream update never discard reviewed text.
  module Importer
    module_function

    Report = Data.define(:written, :unchanged, :new_records, :stroke_mismatches, :missing_strokes)

    def run(kanjidic:, kanjivg:, records_dir:)
      entries = Import::Kanjidic2.parse_file(kanjidic)
      by_character = entries.to_h { |entry| [entry.character, entry] }
      strokes = Import::KanjiVG.parse_file(kanjivg)
      FileUtils.mkdir_p(records_dir)

      counts = { written: 0, unchanged: 0, new_records: 0, stroke_mismatches: [], missing_strokes: [] }
      entries.each do |entry|
        path = File.join(records_dir, "#{entry.codepoint}.org")
        existing = File.exist?(path) ? Record.load(path) : nil
        text = render_entry(entry, existing, by_character)
        counts[:new_records] += 1 unless existing
        note_strokes(counts, entry, strokes)
        if existing && File.read(path, encoding: 'UTF-8') == text
          counts[:unchanged] += 1
        else
          File.write(path, text, encoding: 'UTF-8')
          counts[:written] += 1
        end
      end
      Report.new(**counts)
    end

    # Unicode canonical equivalents are the same abstract character. Reuse only the pinned
    # counterpart's meanings (never a shape/similarity guess or an NFKC compatibility fold).
    # Keep this character's readings/strokes and the raw KANJIDIC2 fingerprint for provenance.
    def render_entry(entry, existing, by_character)
      keywords = existing ? existing.keywords.dup : { 'TITLE' => entry.character, 'CODEPOINT' => entry.codepoint }
      source = entry.source
      normalized = entry.character.unicode_normalize(:nfc)
      reference = by_character[normalized] if normalized != entry.character
      if source.meanings.empty? && reference && reference.source.meanings.any?
        keywords['SOURCE_MEANINGS_REFERENCE'] = reference.codepoint
        keywords['KANJIDIC2_SOURCE_FINGERPRINT'] = source.fingerprint
        source = source.with(meanings: reference.source.meanings)
      else
        keywords.delete('SOURCE_MEANINGS_REFERENCE')
        keywords.delete('KANJIDIC2_SOURCE_FINGERPRINT')
      end
      Writer.render(keywords: keywords, source: source, translations: existing&.translations || [])
    end

    def note_strokes(counts, entry, strokes)
      drawn = strokes[entry.codepoint]
      if drawn.nil?
        counts[:missing_strokes] << entry.codepoint
      elsif entry.source.stroke_count && drawn.size != entry.source.stroke_count
        counts[:stroke_mismatches] << "#{entry.codepoint}: KANJIDIC2 #{entry.source.stroke_count}, KanjiVG #{drawn.size}"
      end
    end
  end
end
