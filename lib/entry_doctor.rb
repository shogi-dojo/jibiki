# frozen_string_literal: true

require_relative 'org_entry'
require_relative 'exporters/houhou_vocab_matcher'
require_relative 'dictionary_sources/jmdict'

module EntryDoctor
  Finding = Struct.new(:check, :severity, :sense_id, :item_id, :line, :detail, keyword_init: true)

  class EntryReport
    attr_reader :entry, :path, :findings, :health_score, :stats

    def initialize(entry:, path: nil, findings: [], health_score: 100, stats: {})
      @entry = entry
      @path = path
      @findings = findings
      @health_score = health_score
      @stats = stats
    end

    def errors
      @findings.select { |f| f.severity == :error }
    end

    def warnings
      @findings.select { |f| f.severity == :warn }
    end

    def infos
      @findings.select { |f| f.severity == :info }
    end

    def passed?
      errors.empty?
    end

    def to_h
      {
        jmdict_id: @entry.jmdict_id,
        title: @entry.title,
        primary_reading: @entry.primary_reading,
        romaji: @entry.romaji,
        path: @path,
        quality_profile: @entry.quality_profile,
        entry_status: @entry.entry_status,
        health_score: @health_score,
        passed: passed?,
        stats: @stats,
        findings: @findings.map do |f|
          {
            check: f.check,
            severity: f.severity,
            sense_id: f.sense_id,
            item_id: f.item_id,
            line: f.line,
            detail: f.detail
          }
        end
      }
    end
  end

  class << self
    def kana_skeleton(str)
      return [] if str.nil?

      normalized = Exporters::HouhouVocabMatcher.nfkc(str.to_s)
      hira = Exporters::HouhouVocabMatcher.to_hiragana(normalized)
      hira.chars.select do |ch|
        cp = ch.ord
        cp >= 0x3041 && cp <= 0x3096 && ch != 'ー' && ch != 'っ'
      end
    end

    def subsequence?(needle, haystack)
      return true if needle.empty?

      n_idx = 0
      haystack.each do |ch|
        n_idx += 1 if ch == needle[n_idx]
        return true if n_idx == needle.length
      end
      false
    end

    def analyze_file(path, jmdict_entry: nil)
      entry = OrgEntry.load(path)
      analyze(entry, jmdict_entry:, path:)
    end

    def analyze(entry, jmdict_entry: nil, path: nil)
      findings = []
      stats = compute_stats(entry)

      # 1. reading_kana_only
      check_reading_kana_only(entry, findings)

      # 2. reading_matches_ja
      check_reading_matches_ja(entry, findings)

      # 3. focus_no_cyrillic
      check_focus_no_cyrillic(entry, findings)

      # 4. uk_gloss_present & 5. uk_gloss_not_blank
      check_ukrainian_glosses(entry, findings)

      # 6. profile_matches_content
      check_profile_matches_content(entry, findings, stats)

      # 7. note_not_gloss_echo
      check_note_not_gloss_echo(entry, findings)

      # 8. learner_note_present
      check_learner_note_present(entry, findings)

      # 9. russian_reference_present
      check_russian_reference_present(entry, jmdict_entry, findings) if jmdict_entry

      # 10. example_count
      check_example_count(entry, findings, stats)

      health_score = calculate_health_score(stats, findings)

      EntryReport.new(
        entry:,
        path:,
        findings:,
        health_score:,
        stats:
      )
    end

    def compute_stats(entry)
      total_senses = entry.senses.length
      eng_senses = entry.senses.select { |s| s.english_glosses.any? { |eg| eg.lang == 'eng' } }
      uk_glosses = entry.senses.flat_map(&:ukrainian_glosses).select { |ug| ug.text && !ug.text.strip.empty? }
      
      covered_eng_senses = eng_senses.count do |s|
        s.ukrainian_glosses.any? { |ug| ug.text && !ug.text.strip.empty? }
      end

      total_examples = entry.senses.sum { |s| s.examples.length }
      primary_senses = entry.senses.select { |s| s.learner_priority == 'primary' }
      primary_with_examples = primary_senses.count { |s| s.examples.length >= 3 }
      primary_with_notes = primary_senses.count { |s| s.learner_notes.any? { |n| n.uk && !n.uk.strip.empty? } }

      {
        total_senses:,
        eng_senses_count: eng_senses.length,
        covered_eng_senses:,
        uk_gloss_count: uk_glosses.length,
        uk_per_eng_sense: eng_senses.empty? ? 0.0 : (uk_glosses.length.to_f / eng_senses.length).round(2),
        total_examples:,
        examples_per_sense: total_senses.zero? ? 0.0 : (total_examples.to_f / total_senses).round(2),
        primary_senses_count: primary_senses.length,
        primary_with_examples:,
        primary_with_notes:
      }
    end

    def calculate_health_score(stats, findings)
      eng_count = stats[:eng_senses_count]
      covered = stats[:covered_eng_senses]

      # Sense coverage: up to 60 points
      coverage_score = eng_count.zero? ? 60.0 : (covered.to_f / eng_count) * 60.0

      # Primary sense quality: up to 25 points (examples + notes)
      primary_count = stats[:primary_senses_count]
      quality_score =
        if primary_count.zero?
          25.0
        else
          ex_ratio = stats[:primary_with_examples].to_f / primary_count
          note_ratio = stats[:primary_with_notes].to_f / primary_count
          (ex_ratio * 15.0) + (note_ratio * 10.0)
        end

      # Base integrity score: 15 points
      base_score = 15.0

      total = coverage_score + quality_score + base_score

      # Deductions
      errors_count = findings.count { |f| f.severity == :error }
      warns_count = findings.count { |f| f.severity == :warn }

      total -= (errors_count * 15.0)
      total -= (warns_count * 5.0)

      [[total.round, 0].max, 100].min
    end

    private

    def check_reading_kana_only(entry, findings)
      entry.senses.each do |sense|
        (sense.examples + sense.collocations + sense.idioms).each do |item|
          rd = item.reading.to_s
          next if rd.empty?

          # Strip ruby brackets first: [furigana]
          without_ruby = rd.gsub(/\[.*?\]/, '')
          if without_ruby.match?(/\p{Han}/)
            findings << Finding.new(
              check: :reading_kana_only,
              severity: :error,
              sense_id: sense.id,
              item_id: item.id,
              detail: "READING '#{rd}' contains kanji (must be kana-only furigana)"
            )
          end
        end
      end
    end

    def check_reading_matches_ja(entry, findings)
      entry.senses.each do |sense|
        (sense.examples + sense.collocations + sense.idioms).each do |item|
          rd = item.reading.to_s
          next if rd.strip.empty?

          ja_skel = kana_skeleton(item.ja)
          # In reading, strip bracketed ruby notation if any
          rd_without_ruby = rd.gsub(/\[.*?\]/, '')
          rd_skel = kana_skeleton(rd_without_ruby)

          unless subsequence?(ja_skel, rd_skel)
            findings << Finding.new(
              check: :reading_matches_ja,
              severity: :error,
              sense_id: sense.id,
              item_id: item.id,
              detail: "Kana skeleton of JA '#{item.ja}' is not a subsequence of READING '#{rd}'"
            )
          end
        end
      end
    end

    def check_focus_no_cyrillic(entry, findings)
      entry.senses.each do |sense|
        sense.examples.each do |ex|
          if ex.focus&.match?(/\p{Cyrillic}/)
            findings << Finding.new(
              check: :focus_no_cyrillic,
              severity: :error,
              sense_id: sense.id,
              item_id: ex.id,
              detail: "FOCUS '#{ex.focus}' contains Cyrillic text (must be Japanese surface form)"
            )
          end
        end
      end
    end

    def check_ukrainian_glosses(entry, findings)
      entry.senses.each do |sense|
        has_eng = sense.english_glosses.any? { |eg| eg.lang == 'eng' }
        valid_uk = sense.ukrainian_glosses.select { |ug| ug.text && !ug.text.strip.empty? }

        if has_eng && valid_uk.empty?
          findings << Finding.new(
            check: :uk_gloss_present,
            severity: :error,
            sense_id: sense.id,
            detail: "English sense has no non-blank Ukrainian gloss (§19.1)"
          )
        end

        sense.ukrainian_glosses.each do |ug|
          if ug.text.nil? || ug.text.strip.empty?
            findings << Finding.new(
              check: :uk_gloss_not_blank,
              severity: :error,
              sense_id: sense.id,
              item_id: ug.id,
              detail: "Ukrainian gloss '#{ug.id}' has empty text"
            )
          end
        end
      end
    end

    def check_profile_matches_content(entry, findings, stats)
      prof = entry.quality_profile

      has_uncovered_eng = stats[:covered_eng_senses] < stats[:eng_senses_count]

      primary_senses = entry.senses.select { |s| s.learner_priority == 'primary' }
      primary_fails_learner = primary_senses.any? do |s|
        has_note = s.learner_notes.any? { |n| n.uk && !n.uk.strip.empty? }
        levels = s.examples.map { |ex| ex.level || 'beginner' }
        has_graded_ex = levels.length >= 3 && levels.include?('beginner') &&
                        (levels.include?('intermediate') || levels.include?('neutral'))
        !has_note || !has_graded_ex
      end

      case prof
      when 'core'
        if has_uncovered_eng
          findings << Finding.new(
            check: :profile_matches_content,
            severity: :error,
            detail: "Declared profile 'core' requires all English senses to have Ukrainian glosses"
          )
        end
      when 'learner'
        if has_uncovered_eng || primary_fails_learner
          reasons = []
          reasons << 'uncovered English senses' if has_uncovered_eng
          reasons << 'primary senses missing notes or graded examples' if primary_fails_learner
          findings << Finding.new(
            check: :profile_matches_content,
            severity: :error,
            detail: "Declared profile 'learner' not met: #{reasons.join(', ')}"
          )
        end
      when 'enriched'
        if has_uncovered_eng || primary_fails_learner
          findings << Finding.new(
            check: :profile_matches_content,
            severity: :error,
            detail: "Declared profile 'enriched' requires learner requirements to be met"
          )
        end
      when 'gold'
        reasons = []
        reasons << 'uncovered English senses' if has_uncovered_eng
        reasons << 'primary senses missing notes or graded examples' if primary_fails_learner
        reasons << "ENTRY_STATUS is '#{entry.entry_status}' (must be 'reviewed')" unless entry.entry_status == 'reviewed'
        
        unless reasons.empty?
          findings << Finding.new(
            check: :profile_matches_content,
            severity: :error,
            detail: "Declared profile 'gold' not met: #{reasons.join(', ')}"
          )
        end
      end
    end

    def check_note_not_gloss_echo(entry, findings)
      entry.senses.each do |sense|
        gloss_texts = sense.ukrainian_glosses.map { |ug| ug.text.to_s.strip.downcase }
        sense.learner_notes.each do |note|
          note_text = note.uk.to_s.strip.downcase
          next if note_text.empty?

          if gloss_texts.include?(note_text)
            findings << Finding.new(
              check: :note_not_gloss_echo,
              severity: :warn,
              sense_id: sense.id,
              item_id: note.id,
              detail: "Learner note '#{note.uk}' echoes the sense gloss text"
            )
          end
        end
      end
    end

    def check_learner_note_present(entry, findings)
      return unless %w[learner enriched gold].include?(entry.quality_profile)

      entry.senses.each do |sense|
        next unless sense.learner_priority == 'primary'

        has_note = sense.learner_notes.any? { |n| n.uk && !n.uk.strip.empty? }
        unless has_note
          findings << Finding.new(
            check: :learner_note_present,
            severity: :warn,
            sense_id: sense.id,
            detail: "Primary sense has no learner note (recommended for #{entry.quality_profile} profile)"
          )
        end
      end
    end

    def check_russian_reference_present(entry, jmdict_entry, findings)
      return unless jmdict_entry

      jmdict_entry[:senses].each do |src_sense|
        has_rus = src_sense[:glosses].any? { |g| g[:lang] == 'rus' }
        next unless has_rus

        # Check if corresponding OrgEntry sense has russian references
        org_sense = entry.senses.find { |s| s.source_sense_index == src_sense[:index] }
        if org_sense && org_sense.russian_references.empty?
          findings << Finding.new(
            check: :russian_reference_present,
            severity: :info,
            sense_id: org_sense.id,
            detail: "JMdict sense #{src_sense[:index]} has Russian glosses but entry omits Russian reference"
          )
        end
      end
    end

    def check_example_count(entry, findings, stats)
      findings << Finding.new(
        check: :example_count,
        severity: :info,
        detail: "Entry has #{stats[:total_examples]} example(s) across #{stats[:total_senses]} sense(s)"
      )
    end
  end
end
