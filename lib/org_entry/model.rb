# frozen_string_literal: true

module OrgEntry
  class Entry
    attr_reader :jmdict_id, :title, :schema_version, :primary_reading, :romaji,
                :entry_status, :quality_profile, :jmdict_source_sha256,
                :created_at, :updated_at, :default_author_id, :default_license,
                :default_source_type, :default_status,
                :written_forms, :readings, :senses,
                :pronunciations, :media, :entry_notes

    def initialize(doc)
      @jmdict_id = doc.keywords['JMDICT_ID'].to_i
      @title = doc.keywords['TITLE']
      @schema_version = doc.keywords['SCHEMA_VERSION'].to_i
      @primary_reading = doc.keywords['PRIMARY_READING']
      @romaji = doc.keywords['ROMAJI']
      @entry_status = doc.keywords['ENTRY_STATUS']
      @quality_profile = doc.keywords['QUALITY_PROFILE']
      @jmdict_source_sha256 = doc.keywords['JMDICT_SOURCE_SHA256']
      @created_at = doc.keywords['CREATED_AT']
      @updated_at = doc.keywords['UPDATED_AT']
      @default_author_id = doc.keywords['DEFAULT_AUTHOR_ID']
      @default_license = doc.keywords['DEFAULT_LICENSE']
      @default_source_type = doc.keywords['DEFAULT_SOURCE_TYPE']
      @default_status = doc.keywords['DEFAULT_STATUS']

      @written_forms = []
      @readings = []
      @senses = []
      @pronunciations = []
      @media = []
      @entry_notes = []

      parse_nodes(doc.nodes)
    end

    private

    def parse_nodes(nodes)
      nodes.each do |node|
        case node.title
        when 'Forms'
          parse_forms(node)
        when /\ASense\s+(s-\d+-\d+)\z/
          @senses << Sense.new(node, self)
        when 'Pronunciation'
          parse_pronunciations(node)
        when 'Media'
          parse_media(node)
        when 'Entry notes'
          parse_entry_notes(node)
        end
      end
    end

    def parse_forms(forms_node)
      forms_node.children.each do |child|
        if child.title =~ /\AWritten form\s+(wf-\d+-\d+)\z/
          @written_forms << WrittenForm.new(child)
        elsif child.title =~ /\AReading\s+(rd-\d+-\d+)\z/
          @readings << Reading.new(child)
        end
      end
    end

    def parse_pronunciations(pron_node)
      pron_node.children.each do |child|
        if child.title =~ /\AAccent\s+(accent-rd-\d+-\d+-\d+)\z/
          @pronunciations << Pronunciation.new(child)
        end
      end
    end

    def parse_media(media_node)
      media_node.children.each do |child|
        if child.title =~ /\AAudio\s+(audio-rd-\d+-\d+-\d+)\z/
          @media << MediaItem.new(child)
        end
      end
    end

    def parse_entry_notes(notes_node)
      notes_node.content.each do |item|
        @entry_notes << EntryNote.new(item)
      end
    end
  end

  class WrittenForm
    attr_reader :id, :text, :information, :priorities

    def initialize(node)
      @id = node.title.split.last
      @text = node.properties['TEXT']
      
      info_node = node.find_child('Information')
      @information = info_node ? info_node.content.map(&:value) : []

      pri_node = node.find_child('Priorities')
      @priorities = pri_node ? pri_node.content.map(&:value) : []
    end
  end

  class Reading
    attr_reader :id, :text, :no_kanji, :applies_to_written_forms, :information, :priorities

    def initialize(node)
      @id = node.title.split.last
      @text = node.properties['TEXT']
      @no_kanji = node.properties['NO_KANJI'] == 'true'

      app_node = node.find_child('Applies to written forms')
      @applies_to_written_forms = app_node ? app_node.content.map(&:value) : []

      info_node = node.find_child('Information')
      @information = info_node ? info_node.content.map(&:value) : []

      pri_node = node.find_child('Priorities')
      @priorities = pri_node ? pri_node.content.map(&:value) : []
    end
  end

  class Sense
    attr_reader :id, :source_sense_index, :source_fingerprint, :learner_priority,
                :applies_to_written, :applies_to_readings,
                :parts_of_speech, :miscellaneous, :fields, :dialects, :sense_information,
                :cross_references, :antonyms, :language_sources,
                :english_glosses, :ukrainian_glosses, :russian_references,
                :learner_notes, :collocations, :constructions, :related_words, :idioms, :examples

    def initialize(node, entry)
      @id = node.title.split.last
      @source_sense_index = node.properties['SOURCE_SENSE_INDEX'].to_i
      @source_fingerprint = node.properties['SOURCE_FINGERPRINT']
      @learner_priority = node.properties['LEARNER_PRIORITY']

      # Applies to forms
      app_node = node.find_child('Applies to forms')
      if app_node
        wf_node = app_node.find_child('Written forms')
        @applies_to_written = wf_node ? wf_node.content.map(&:value) : ['*']
        rd_node = app_node.find_child('Readings')
        @applies_to_readings = rd_node ? rd_node.content.map(&:value) : ['*']
      else
        @applies_to_written = ['*']
        @applies_to_readings = ['*']
      end

      # JMdict metadata
      meta_node = node.find_child('JMdict metadata')
      if meta_node
        pos_node = meta_node.find_child('Parts of speech')
        @parts_of_speech = pos_node ? pos_node.content.map(&:value) : []

        misc_node = meta_node.find_child('Miscellaneous and register')
        @miscellaneous = misc_node ? misc_node.content.map(&:value) : []

        fields_node = meta_node.find_child('Fields')
        @fields = fields_node ? fields_node.content.map(&:value) : []

        dial_node = meta_node.find_child('Dialects')
        @dialects = dial_node ? dial_node.content.map(&:value) : []

        info_node = meta_node.find_child('Sense information')
        @sense_information = info_node ? info_node.content.map(&:value) : []

        xref_node = meta_node.find_child('Cross-references')
        @cross_references = parse_xrefs_or_antonyms(xref_node)

        ant_node = meta_node.find_child('Antonyms')
        @antonyms = parse_xrefs_or_antonyms(ant_node)

        @language_sources = meta_node.children.select { |c| c.title =~ /\ALanguage source\s+/ }.map do |ls_node|
          LanguageSource.new(ls_node)
        end
      else
        @parts_of_speech = []
        @miscellaneous = []
        @fields = []
        @dialects = []
        @sense_information = []
        @cross_references = []
        @antonyms = []
        @language_sources = []
      end

      # English glosses
      eg_node = node.find_child('English glosses')
      @english_glosses = []
      if eg_node
        # Plain list items
        eg_node.content.each do |item|
          @english_glosses << EnglishGloss.new(item.value)
        end
        # Non-default heading glosses
        eg_node.children.each do |child|
          if child.title =~ /\Aen-s-/
            @english_glosses << EnglishGloss.new(child)
          end
        end
      end

      # Ukrainian glosses
      ug_node = node.find_child('Ukrainian glosses')
      @ukrainian_glosses = []
      if ug_node
        ug_node.children.each do |child|
          if child.title =~ /\Auk-s-/
            @ukrainian_glosses << UkrainianGloss.new(child, entry)
          end
        end
      end

      # Russian references
      rr_node = node.find_child('Russian reference')
      @russian_references = []
      if rr_node
        # Plain descriptive list items
        rr_node.content.each do |item|
          @russian_references << RussianReference.new(item)
        end
        # Non-default heading references
        rr_node.children.each do |child|
          if child.title =~ /\Aru-ref-/
            @russian_references << RussianReference.new(child)
          end
        end
      end

      # Enrichment sections
      @learner_notes = parse_enrichment_headings(node, 'Learner notes', LearnerNote, entry)
      @collocations = parse_enrichment_headings(node, 'Collocations', Collocation, entry)
      @constructions = parse_enrichment_headings(node, 'Constructions and derivatives', Construction, entry)
      @related_words = parse_enrichment_headings(node, 'Related words', RelatedWord, entry)
      @idioms = parse_enrichment_headings(node, 'Idioms and proverbs', Idiom, entry)
      @examples = parse_enrichment_headings(node, 'Examples', Example, entry)
    end

    private

    def parse_xrefs_or_antonyms(meta_child_node)
      return [] unless meta_child_node
      # They can be plain list items, descriptive list items, or child headings.
      # Let's collect them as clean hashes/objects.
      results = []
      meta_child_node.content.each do |item|
        if item.label
          results << { 'target' => item.value, 'source_text' => item.label }
        else
          results << { 'text' => item.value }
        end
      end
      meta_child_node.children.each do |child|
        target_item = child.content.find { |item| item.label == 'target' }
        src_item = child.content.find { |item| item.label == 'source-text' }
        results << {
          'target' => target_item ? target_item.value : nil,
          'source_text' => src_item ? src_item.value : nil
        }
      end
      results
    end

    def parse_enrichment_headings(sense_node, title, klass, entry)
      sec_node = sense_node.find_child(title)
      return [] unless sec_node
      sec_node.children.map { |child| klass.new(child, entry) }
    end
  end

  class LanguageSource
    attr_reader :id, :lang, :type, :wasei, :text

    def initialize(node)
      @id = node.title.split.last
      @lang = node.properties['LANG'] || 'eng'
      @type = node.properties['TYPE'] || 'full'
      @wasei = node.properties['WASEI'] == 'true'
      
      text_item = node.content.find { |item| item.label == 'text' }
      @text = text_item ? text_item.value : ''
    end
  end

  class EnglishGloss
    attr_reader :id, :text, :lang, :type, :gender, :primary

    def initialize(source)
      if source.is_a?(String)
        @id = nil
        @text = source
        @lang = 'eng'
        @type = 'plain'
        @gender = 'none'
        @primary = false
      else
        @id = source.title
        @lang = source.properties['LANG'] || 'eng'
        @type = source.properties['TYPE'] || 'plain'
        @gender = source.properties['GENDER'] || 'none'
        @primary = source.properties['PRIMARY'] == 'true'
        text_item = source.content.find { |item| item.label == 'text' }
        @text = text_item ? text_item.value : ''
      end
    end
  end

  class UkrainianGloss
    attr_reader :id, :status, :translator_id, :translated_at, :reviewer_id, :reviewed_at,
                :source_type, :license, :text, :qualifier

    def initialize(node, entry)
      @id = node.title
      @status = node.properties['STATUS'] || entry.default_status || 'draft'
      @translator_id = node.properties['TRANSLATOR_ID'] || entry.default_author_id
      @translated_at = node.properties['TRANSLATED_AT'] || entry.created_at
      @reviewer_id = node.properties['REVIEWER_ID']
      @reviewed_at = node.properties['REVIEWED_AT']
      @source_type = node.properties['SOURCE_TYPE'] || entry.default_source_type || 'original'
      @license = node.properties['LICENSE'] || entry.default_license || 'CC-BY-SA-4.0'

      text_item = node.content.find { |item| item.label == 'text' }
      @text = text_item ? text_item.value : ''

      qual_item = node.content.find { |item| item.label == 'qualifier' }
      @qualifier = qual_item ? qual_item.value : nil
    end
  end

  class RussianReference
    attr_reader :id, :source_sense_index, :text

    def initialize(source)
      if source.is_a?(ListItem)
        @id = nil
        @source_sense_index = source.label.to_i
        @text = source.value
      else
        @id = source.title
        @source_sense_index = source.properties['SOURCE_SENSE_INDEX'].to_i
        text_item = source.content.find { |item| item.label == 'text' }
        @text = text_item ? text_item.value : ''
      end
    end
  end

  # Placeholders for enrichment classes (to be extended in Task 5 but defined here)
  class LearnerNote
    attr_reader :id, :status, :author_id, :created_at, :license, :source_type, :uk, :level, :register

    def initialize(node, entry)
      @id = node.title
      @status = node.properties['STATUS'] || entry.default_status || 'draft'
      @author_id = node.properties['AUTHOR_ID'] || entry.default_author_id
      @created_at = node.properties['CREATED_AT'] || entry.created_at
      @license = node.properties['LICENSE'] || entry.default_license || 'CC-BY-SA-4.0'
      @source_type = node.properties['SOURCE_TYPE'] || entry.default_source_type || 'original'
      
      uk_item = node.content.find { |item| item.label == 'UK' }
      @uk = uk_item ? uk_item.value : ''

      lvl_item = node.content.find { |item| item.label == 'LEVEL' }
      @level = lvl_item ? lvl_item.value : 'beginner'

      reg_item = node.content.find { |item| item.label == 'REGISTER' }
      @register = reg_item ? reg_item.value : 'neutral'
    end
  end

  class Collocation
    attr_reader :id, :status, :author_id, :created_at, :license, :source_type, :ja, :reading, :uk, :pattern, :register

    def initialize(node, entry)
      @id = node.title
      @status = node.properties['STATUS'] || entry.default_status || 'draft'
      @author_id = node.properties['AUTHOR_ID'] || entry.default_author_id
      @created_at = node.properties['CREATED_AT'] || entry.created_at
      @license = node.properties['LICENSE'] || entry.default_license || 'CC-BY-SA-4.0'
      @source_type = node.properties['SOURCE_TYPE'] || entry.default_source_type || 'original'

      ja_item = node.content.find { |item| item.label == 'JA' }
      @ja = ja_item ? ja_item.value : ''

      rd_item = node.content.find { |item| item.label == 'READING' }
      @reading = rd_item ? rd_item.value : ''

      uk_item = node.content.find { |item| item.label == 'UK' }
      @uk = uk_item ? uk_item.value : ''

      pat_item = node.content.find { |item| item.label == 'PATTERN' }
      @pattern = pat_item ? pat_item.value : nil

      reg_item = node.content.find { |item| item.label == 'REGISTER' }
      @register = reg_item ? reg_item.value : 'neutral'
    end
  end

  class Construction
    attr_reader :id, :status, :author_id, :created_at, :license, :source_type, :relation, :target, :target_id

    def initialize(node, entry)
      @id = node.title
      @status = node.properties['STATUS'] || entry.default_status || 'draft'
      @author_id = node.properties['AUTHOR_ID'] || entry.default_author_id
      @created_at = node.properties['CREATED_AT'] || entry.created_at
      @license = node.properties['LICENSE'] || entry.default_license || 'CC-BY-SA-4.0'
      @source_type = node.properties['SOURCE_TYPE'] || entry.default_source_type || 'original'

      rel_item = node.content.find { |item| item.label == 'RELATION' }
      @relation = rel_item ? rel_item.value : ''

      tgt_item = node.content.find { |item| item.label == 'TARGET' }
      @target = tgt_item ? tgt_item.value : ''

      tgt_id_item = node.content.find { |item| item.label == 'TARGET_ID' }
      @target_id = tgt_id_item ? tgt_id_item.value : nil
    end
  end

  class RelatedWord
    attr_reader :id, :status, :author_id, :created_at, :license, :source_type, :relation, :target, :target_id

    def initialize(node, entry)
      @id = node.title
      @status = node.properties['STATUS'] || entry.default_status || 'draft'
      @author_id = node.properties['AUTHOR_ID'] || entry.default_author_id
      @created_at = node.properties['CREATED_AT'] || entry.created_at
      @license = node.properties['LICENSE'] || entry.default_license || 'CC-BY-SA-4.0'
      @source_type = node.properties['SOURCE_TYPE'] || entry.default_source_type || 'original'

      rel_item = node.content.find { |item| item.label == 'RELATION' }
      @relation = rel_item ? rel_item.value : ''

      tgt_item = node.content.find { |item| item.label == 'TARGET' }
      @target = tgt_item ? tgt_item.value : ''

      tgt_id_item = node.content.find { |item| item.label == 'TARGET_ID' }
      @target_id = tgt_id_item ? tgt_id_item.value : nil
    end
  end

  class Idiom
    attr_reader :id, :status, :author_id, :created_at, :license, :source_type, :ja, :reading, :uk, :en, :level, :register

    def initialize(node, entry)
      @id = node.title
      @status = node.properties['STATUS'] || entry.default_status || 'draft'
      @author_id = node.properties['AUTHOR_ID'] || entry.default_author_id
      @created_at = node.properties['CREATED_AT'] || entry.created_at
      @license = node.properties['LICENSE'] || entry.default_license || 'CC-BY-SA-4.0'
      @source_type = node.properties['SOURCE_TYPE'] || entry.default_source_type || 'original'

      ja_item = node.content.find { |item| item.label == 'JA' }
      @ja = ja_item ? ja_item.value : ''

      rd_item = node.content.find { |item| item.label == 'READING' }
      @reading = rd_item ? rd_item.value : ''

      uk_item = node.content.find { |item| item.label == 'UK' }
      @uk = uk_item ? uk_item.value : ''

      en_item = node.content.find { |item| item.label == 'EN' }
      @en = en_item ? en_item.value : nil

      lvl_item = node.content.find { |item| item.label == 'LEVEL' }
      @level = lvl_item ? lvl_item.value : 'beginner'

      reg_item = node.content.find { |item| item.label == 'REGISTER' }
      @register = reg_item ? reg_item.value : 'neutral'
    end
  end

  class Example
    attr_reader :id, :status, :author_id, :created_at, :license, :source_type, :source_id, :source_url,
                :ja, :reading, :romaji, :uk, :en, :focus, :level, :register

    def initialize(node, entry)
      @id = node.title
      @status = node.properties['STATUS'] || entry.default_status || 'draft'
      @author_id = node.properties['AUTHOR_ID'] || entry.default_author_id
      @created_at = node.properties['CREATED_AT'] || entry.created_at
      @license = node.properties['LICENSE'] || entry.default_license || 'CC-BY-SA-4.0'
      @source_type = node.properties['SOURCE_TYPE'] || entry.default_source_type || 'original'
      @source_id = node.properties['SOURCE_ID']
      @source_url = node.properties['SOURCE_URL']

      ja_item = node.content.find { |item| item.label == 'JA' }
      @ja = ja_item ? ja_item.value : ''

      rd_item = node.content.find { |item| item.label == 'READING' }
      @reading = rd_item ? rd_item.value : ''

      rom_item = node.content.find { |item| item.label == 'ROMAJI' }
      @romaji = rom_item ? rom_item.value : nil

      uk_item = node.content.find { |item| item.label == 'UK' }
      @uk = uk_item ? uk_item.value : ''

      en_item = node.content.find { |item| item.label == 'EN' }
      @en = en_item ? en_item.value : nil

      foc_item = node.content.find { |item| item.label == 'FOCUS' }
      @focus = foc_item ? foc_item.value : nil

      lvl_item = node.properties['LEVEL'] || 'beginner'
      @level = lvl_item

      reg_item = node.properties['REGISTER'] || 'neutral'
      @register = reg_item
    end
  end

  # Pronunciation & Pitch Accent
  class Pronunciation
    attr_reader :id, :target_id, :system, :mora_count, :drop_after, :pattern, :mora_pattern, :context,
                :source_id, :source_version, :source_url, :license, :status, :verified_at

    def initialize(node)
      @id = node.title
      @target_id = node.properties['TARGET_ID']
      @system = node.properties['SYSTEM']
      @mora_count = node.properties['MORA_COUNT']&.to_i
      @drop_after = node.properties['DROP_AFTER']&.to_i
      @pattern = node.properties['PATTERN']
      @mora_pattern = node.properties['MORA_PATTERN']
      @context = node.properties['CONTEXT']
      @source_id = node.properties['SOURCE_ID']
      @source_version = node.properties['SOURCE_VERSION']
      @source_url = node.properties['SOURCE_URL']
      @license = node.properties['LICENSE']
      @status = node.properties['STATUS']
      @verified_at = node.properties['VERIFIED_AT']
    end
  end

  # Media
  class MediaItem
    attr_reader :id, :target_type, :target_id, :source_id, :source_url, :asset_path, :mime, :license,
                :speaker_id, :speaker_region, :recording_type, :engine, :engine_version, :voice_model,
                :voice_version, :generation_input, :recorded_at, :generated_at, :distribution_terms_url,
                :credit, :verified_at, :text, :reading

    def initialize(node)
      @id = node.title
      @target_type = node.properties['TARGET_TYPE']
      @target_id = node.properties['TARGET_ID']
      @source_id = node.properties['SOURCE_ID']
      @source_url = node.properties['SOURCE_URL']
      @asset_path = node.properties['ASSET_PATH']
      @mime = node.properties['MIME']
      @license = node.properties['LICENSE']
      @speaker_id = node.properties['SPEAKER_ID']
      @speaker_region = node.properties['SPEAKER_REGION']
      @recording_type = node.properties['RECORDING_TYPE']
      @engine = node.properties['ENGINE']
      @engine_version = node.properties['ENGINE_VERSION']
      @voice_model = node.properties['VOICE_MODEL']
      @voice_version = node.properties['VOICE_VERSION']
      @generation_input = node.properties['GENERATION_INPUT']
      @recorded_at = node.properties['RECORDED_AT']
      @generated_at = node.properties['GENERATED_AT']
      @distribution_terms_url = node.properties['DISTRIBUTION_TERMS_URL']
      @credit = node.properties['CREDIT']
      @verified_at = node.properties['VERIFIED_AT']

      txt_item = node.content.find { |item| item.label == 'text' }
      @text = txt_item ? txt_item.value : ''

      rd_item = node.content.find { |item| item.label == 'reading' }
      @reading = rd_item ? rd_item.value : ''
    end
  end

  # Entry Note
  class EntryNote
    attr_reader :value

    def initialize(item)
      @value = item.value
    end
  end
end
