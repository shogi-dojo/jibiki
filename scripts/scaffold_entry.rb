#!/usr/bin/env ruby
# frozen_string_literal: true

# Canonical schema v2 entry scaffolder: reads the same N5 dossier sources as
# `rake sources:n5[N]` and emits a complete Org entry with every derived
# section (forms, senses, POS, English glosses, ru-ref, fingerprints) filled
# in, and every authored slot (Ukrainian gloss, learner note, example) marked
# with the exact validator placeholder text, so the gate stays red until an
# agent genuinely authors the content. Replaces the one-off
# `scratch/gen_n5_part*.py` scripts, which embedded content and leaked
# unedited placeholders past review.

require_relative '../lib/dictionary_sources/jmdict'
require_relative '../lib/dictionary_sources/n5_queue'
require_relative 'source_cli'
require_relative 'validate_entry'

def format_entry(ent_seq:, jmdict_entry:, primary_reading:, romaji:, sha256:, created_at:)
  title = jmdict_entry[:written_forms].first&.fetch(:text, nil) || primary_reading

  lines = []
  lines << "#+TITLE: #{title}"
  lines << "#+JMDICT_ID: #{ent_seq}"
  lines << '#+SCHEMA_VERSION: 2'
  lines << "#+PRIMARY_READING: #{primary_reading}"
  lines << "#+ROMAJI: #{romaji}"
  lines << '#+ENTRY_STATUS: draft'
  lines << '#+QUALITY_PROFILE: learner'
  lines << "#+JMDICT_SOURCE_SHA256: #{sha256}"
  lines << "#+CREATED_AT: #{created_at}"
  lines << '#+DEFAULT_AUTHOR_ID: antigravity'
  lines << '#+DEFAULT_LICENSE: CC-BY-SA-4.0'
  lines << '#+DEFAULT_SOURCE_TYPE: original'
  lines << '#+DEFAULT_STATUS: draft'
  lines << ''

  lines << '* Forms'
  jmdict_entry[:written_forms].each_with_index do |form, index|
    id = format('wf-%s-%03d', ent_seq, index + 1)
    lines << "** Written form #{id}"
    lines << ':PROPERTIES:'
    lines << ":TEXT: #{form[:text]}"
    lines << ':END:'
    lines.concat(list_subsection('Information', form[:information]))
    lines.concat(list_subsection('Priorities', form[:priorities]))
  end

  jmdict_entry[:readings].each_with_index do |reading, index|
    id = format('rd-%s-%03d', ent_seq, index + 1)
    lines << "** Reading #{id}"
    lines << ':PROPERTIES:'
    lines << ":TEXT: #{reading[:text]}"
    lines << ":NO_KANJI: #{reading[:no_kanji]}"
    lines << ':END:'

    if jmdict_entry[:written_forms].any?
      restr = reading[:applies_to_written_forms]
      lines << '*** Applies to written forms'
      lines.concat(restr.empty? ? ['- *'] : restr.map { |r| "- #{r}" })
    end
    lines.concat(list_subsection('Information', reading[:information]))
    lines.concat(list_subsection('Priorities', reading[:priorities]))
  end

  lines << ''

  first_english_sense_index = jmdict_entry[:senses].find_index { |sense| english_sense?(sense) } || 0

  jmdict_entry[:senses].each_with_index do |sense, index|
    s_id = format('s-%s-%03d', ent_seq, index + 1)
    lines << "* Sense #{s_id}"
    lines << ':PROPERTIES:'
    lines << ":SOURCE_SENSE_INDEX: #{sense[:index]}"
    lines << ":SOURCE_FINGERPRINT: #{sense[:source_fingerprint]}"
    lines << ':LEARNER_PRIORITY: primary' if index == first_english_sense_index
    lines << ':END:'

    restricted = sense[:applies_to_written_forms].any? || sense[:applies_to_readings].any?
    if restricted
      lines << '** Applies to forms'
      lines << '*** Written forms'
      lines.concat(sense[:applies_to_written_forms].empty? ? ['- *'] : sense[:applies_to_written_forms].map { |v| "- #{v}" })
      lines << '*** Readings'
      lines.concat(sense[:applies_to_readings].empty? ? ['- *'] : sense[:applies_to_readings].map { |v| "- #{v}" })
    end

    lines << '** JMdict metadata'
    lines << '*** Parts of speech'
    lines.concat(sense[:parts_of_speech].map { |pos| "- #{pos}" })
    lines.concat(list_subsection('Fields', sense[:fields]))
    lines.concat(list_subsection('Miscellaneous and register', sense[:miscellaneous]))
    lines.concat(list_subsection('Dialects', sense[:dialects]))
    lines.concat(list_subsection('Sense information', sense[:information]))
    lines.concat(list_subsection('Cross-references', sense[:cross_references]))
    lines.concat(list_subsection('Antonyms', sense[:antonyms]))
    # Language sources always need their own heading (lang/type/wasei
    # attributes), so they are never compacted to plain list items.
    if sense[:language_sources].any?
      lines << '*** Language sources'
      sense[:language_sources].each_with_index do |source, ls_index|
        lines << "**** Language source ls-#{s_id}-#{format('%03d', ls_index + 1)}"
        lines << ':PROPERTIES:'
        lines << ":LANG: #{source[:lang]}"
        lines << ":TYPE: #{source[:type]}"
        lines << ":WASEI: #{source[:wasei]}"
        lines << ':END:'
        lines << "- text :: #{source[:text]}"
      end
    end

    lines << '** English glosses'
    sense[:glosses].each_with_index do |gloss, gloss_index|
      default_attrs = gloss[:lang] == 'eng' && gloss[:type] == 'plain' && gloss[:gender] == 'none'
      if default_attrs
        lines << "- #{gloss[:text]}"
      else
        lines << "*** en-#{s_id}-#{format('%03d', gloss_index + 1)}"
        lines << ':PROPERTIES:'
        lines << ":LANG: #{gloss[:lang]}"
        lines << ":TYPE: #{gloss[:type]}"
        lines << ":GENDER: #{gloss[:gender]}"
        lines << ":PRIMARY: #{gloss[:primary]}"
        lines << ':END:'
        lines << "- text :: #{gloss[:text]}"
      end
    end

    lines << '** Ukrainian glosses'
    # A sense whose JMdict glosses are entirely non-English (French, German,
    # Spanish, etc. — JMdict encodes those as their own numbered senses
    # rather than as alternate glosses on the English sense) gets no
    # authoring slots: the established convention across the corpus leaves
    # such a sense's Ukrainian glosses empty rather than asking a translator
    # to work from a gloss they may not read. See e.g.
    # entries/1352/1352320-ageru.org sense s-1352320-053 (LANG: ger).
    if english_sense?(sense)
      lines << "*** uk-#{s_id}-001"
      lines << ':PROPERTIES:'
      lines << ':TRANSLATOR_ID:'
      lines << ':TRANSLATED_AT:'
      lines << ':REVIEWER_ID:'
      lines << ':REVIEWED_AT:'
      lines << ':END:'
      lines << '- text :: Приклад.'

      lines << '** Learner notes'
      lines << "*** note-#{s_id}-001"
      lines << ':PROPERTIES:'
      lines << ':END:'
      lines << "- UK :: #{PLACEHOLDER_FIELDS['UK'].last}"
      lines << '- LEVEL :: beginner'
      lines << '- REGISTER :: neutral'

      if index == first_english_sense_index
        lines << '** Examples'
        # ex- IDs are ex-<ent_seq>-<sense_num>-<ex_num>, unlike uk-/note- IDs
        # which keep the sense's own s- prefix (uk-s-<ent_seq>-<sense_num>-...).
        example_prefix = "ex-#{ent_seq}-#{format('%03d', index + 1)}"
        %w[beginner neutral intermediate].each_with_index do |level, ex_index|
          lines << "*** #{example_prefix}-#{format('%03d', ex_index + 1)}"
          lines << ':PROPERTIES:'
          lines << ":LEVEL: #{level}"
          lines << ':REGISTER: neutral'
          lines << ':END:'
          lines << "- JA :: #{PLACEHOLDER_FIELDS['JA'].first}"
          lines << "- READING :: #{PLACEHOLDER_FIELDS['READING'].first}"
          lines << "- UK :: #{PLACEHOLDER_FIELDS['UK'].first}"
          lines << "- EN :: #{PLACEHOLDER_FIELDS['EN'].first}"
          lines << "- FOCUS :: #{PLACEHOLDER_FIELDS['FOCUS'].first}"
        end
      end
    end

    lines << ''
  end

  lines.join("\n").gsub(/\n{3,}/, "\n\n").sub(/\n+\z/, "\n")
end

# A sense with no glosses at all, or with at least one `eng` gloss, is a
# real semantic sense for a Ukrainian learner. A sense whose glosses are
# entirely non-English is JMdict's way of encoding an alternate-language
# gloss set as its own numbered sense, not new lexical content.
def english_sense?(sense)
  sense[:glosses].empty? || sense[:glosses].any? { |gloss| gloss[:lang] == 'eng' }
end

def list_subsection(name, items)
  return [] if items.empty?

  ["*** #{name}"] + items.map { |item| "- #{item}" }
end

if __FILE__ == $PROGRAM_NAME
  options = {}
  parser = SourceCLI.common_parser(options, banner: 'Usage: scaffold_entry.rb --source-order N --romaji ROMAJI') do |cli|
    cli.on('--source-order NUMBER', Integer, 'N5 queue source_order to scaffold') { |value| options[:source_order] = value }
    cli.on('--romaji TEXT', 'Filename romaji (Modified Hepburn, lowercase)') { |value| options[:romaji] = value }
  end
  parser.parse!

  abort 'Provide --source-order.' unless options[:source_order]
  abort 'Provide --romaji.' unless options[:romaji]

  SourceCLI.ensure_exists!(SourceCLI::JMDICT_PATH, SourceCLI::N5_PATH)

  queue_record = DictionarySources::N5Queue.new(SourceCLI::N5_PATH).fetch(options[:source_order])
  jmdict = DictionarySources::Jmdict.new(SourceCLI::JMDICT_PATH)
  matches = jmdict.lookup(written: queue_record[:written], reading: queue_record[:reading])

  if matches.length != 1
    abort "N5 source_order #{options[:source_order]} resolved to #{matches.length} JMdict entries; inspect and reconcile explicitly before scaffolding."
  end

  entry = matches.first
  ent_seq = entry[:ent_seq]
  primary_reading = entry[:readings].first.fetch(:text)
  path = File.join(SourceCLI::REPO_ROOT, 'entries', (ent_seq.to_i / 1000).to_s, "#{ent_seq}-#{options[:romaji]}.org")

  if File.exist?(path)
    abort "#{SourceCLI.relative_path(path)} already exists; scaffold_entry.rb refuses to overwrite an existing entry."
  end

  content = format_entry(
    ent_seq:,
    jmdict_entry: entry,
    primary_reading:,
    romaji: options[:romaji],
    sha256: jmdict.archive_sha256,
    created_at: Time.now.strftime('%Y-%m-%d')
  )

  FileUtils.mkdir_p(File.dirname(path))
  File.write(path, content, encoding: Encoding::UTF_8)
  puts "scaffolded #{SourceCLI.relative_path(path)}"
end
