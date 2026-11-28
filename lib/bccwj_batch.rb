# frozen_string_literal: true

require 'date'
require 'digest'
require 'English'
require 'fileutils'
require 'json'
require 'set'
require 'sqlite3'
require_relative 'entry_validator'
require_relative '../scripts/scaffold_entry'

# Reusable tooling for selecting BCCWJ + JMdict + Warodai candidates into
# JSON queues/dossiers and rendering authored batch payloads into schema v2
# Org entries.
module BccwjBatch
  DEFAULT_BCCWJ_PATH = 'sources/bccwj/BCCWJ_frequencylist_luw2_ver1_0.zip'
  DEFAULT_BCCWJ_ENTRY = 'BCCWJ_frequencylist_luw2_ver1_0.tsv'
  DEFAULT_JMDICT_PATH = 'sources/jmdict/JMdict.xml.gz'
  DEFAULT_JMDICT_CACHE = 'tmp/jmdict_cache.sqlite'
  DEFAULT_WARODAI_CACHE = 'tmp/warodai_cache.sqlite'
  DEFAULT_POS_PREFIXES = %w[名詞-普通名詞 動詞-一般 形容詞-一般 形状詞-一般 副詞].freeze
  EXAMPLE_LEVELS = %w[beginner neutral intermediate].freeze
  SINGLE_NON_KANJI_CHAR = /\A\P{Han}\z/

  module_function

  def kata_to_hira(text)
    text.tr('ァ-ン', 'ぁ-ん')
  end

  def clean_lemma?(written, reading)
    return false if written.nil? || reading.nil? || written.empty? || reading.empty?
    return false if written.include?('・') || reading.include?('・')
    return false if written.start_with?('〜') || written.end_with?('〜') || written.include?('～')
    return false if written.length == 1 && written.match?(SINGLE_NON_KANJI_CHAR)

    EntryValidator.to_romaji(reading) !~ /[^a-z0-9_-]/
  end

  def open_bccwj_io(path, zip_entry: DEFAULT_BCCWJ_ENTRY, &block)
    if File.extname(path) == '.zip'
      IO.popen(['unzip', '-p', path, zip_entry], 'r:UTF-8', &block).tap do
        sigpipe = Signal.list['PIPE']
        ok = $CHILD_STATUS&.success? || ($CHILD_STATUS&.signaled? && $CHILD_STATUS.termsig == sigpipe)
        raise "unzip failed for #{path} (#{zip_entry})" unless ok
      end
    else
      File.open(path, 'r:UTF-8', &block)
    end
  end

  def symbolize_keys(value)
    case value
    when Hash then value.to_h { |k, v| [k.to_sym, symbolize_keys(v)] }
    when Array then value.map { |v| symbolize_keys(v) }
    else value
    end
  end

  # Selects unadded BCCWJ frequent words that resolve cleanly to an unadded
  # JMdict entry with English senses and at least one consult-only Warodai card.
  class Selector
    def initialize(jmdict_db:, warodai_db:, entries_dir: 'entries', min_rank: 1, limit: 500,
                   pos_prefixes: DEFAULT_POS_PREFIXES, excluded_words: [])
      @jmdict_db = jmdict_db
      @warodai_db = warodai_db
      @entries_dir = entries_dir
      @min_rank = min_rank.to_i
      @limit = limit.to_i
      @pos_prefixes = pos_prefixes
      @excluded_words = excluded_words.to_set
    end

    def select(io:, source_url:, source_sha256:)
      existing_ids = load_existing_jmdict_ids
      seen_ids = Set.new
      seen_words = Set.new
      candidates = []

      io.each_line.with_index do |line, line_idx|
        break if candidates.size >= @limit
        next if line_idx.zero?

        candidate = process_row(line, existing_ids:, seen_ids:, seen_words:, source_url:, source_sha256:)
        candidates << candidate if candidate
      end

      candidates
    end

    private

    def load_existing_jmdict_ids
      Dir.glob(File.join(@entries_dir, '*', '*.org')).map do |path|
        File.basename(path).split('-').first.to_i
      end.to_set
    end

    def process_row(line, existing_ids:, seen_ids:, seen_words:, source_url:, source_sha256:)
      rank, lform, lemma, pos = line.chomp.split("\t", 5)
      return nil if rank.to_i < @min_rank || pos.nil?
      return nil unless eligible_pos?(pos)
      return nil if @excluded_words.include?(lemma)

      reading = BccwjBatch.kata_to_hira(lform.to_s)
      return nil unless BccwjBatch.clean_lemma?(lemma, reading)
      return nil if seen_words.include?([lemma, reading])

      id = find_jmdict_id(lemma, reading, existing_ids)
      return nil if id.nil? || !seen_ids.add?(id)

      row = @jmdict_db.execute('SELECT written, reading, entry_json FROM entries WHERE id = ?', [id]).first
      return nil if row.nil?

      written, canonical_reading, entry_json = row
      romaji = EntryValidator.to_romaji(canonical_reading)
      return nil unless seen_words.add?([written, canonical_reading])

      path = File.join(@entries_dir, (id / 1000).to_s, "#{id}-#{romaji}.org")
      return nil if File.exist?(path)

      entry = JSON.parse(entry_json)
      return nil unless entry['senses'].any? { |s| s['glosses'].any? { |g| g['lang'] == 'eng' } }

      warodai_cards = find_warodai_cards(written, canonical_reading, entry)
      return nil if warodai_cards.empty?

      build_candidate(
        rank:, lemma:, written:, reading: canonical_reading, romaji:, id:,
        path:, entry:, warodai_cards:, source_url:, source_sha256:
      )
    end

    def eligible_pos?(pos)
      return false if pos.include?('固有名詞') || pos.include?('数詞')

      @pos_prefixes.any? { |prefix| pos.start_with?(prefix) }
    end

    def find_jmdict_id(written, reading, existing_ids)
      rows = @jmdict_db.execute('SELECT id FROM keb_reb WHERE written = ? AND reading = ?', [written, reading]).map(&:first)
      if rows.empty? && written.match?(/\A[ァ-ヴー]+\z/)
        rows = @jmdict_db.execute('SELECT id FROM keb_reb WHERE written = ? AND reading = ?', [written, written]).map(&:first)
        rows = @jmdict_db.execute('SELECT id FROM reb WHERE reading = ?', [written]).map(&:first) if rows.empty?
      end
      rows.reject { |id| existing_ids.include?(id) }.first
    end

    def find_warodai_cards(written, reading, entry)
      written_forms = entry['written_forms'] || entry['kanji'] || []
      forms = ([written] + written_forms.map { |k| k['text'] }).compact.uniq
      rows = forms.flat_map do |form|
        @warodai_db.execute(
          'SELECT c.card_id, c.written_raw, c.kana_raw, c.body FROM forms f ' \
          'JOIN cards c ON f.card_id = c.card_id WHERE f.written = ? AND f.reading = ?',
          [form, reading]
        )
      end

      if rows.empty? && written !~ /\p{Han}/
        rows = @warodai_db.execute(
          "SELECT c.card_id, c.written_raw, c.kana_raw, c.body FROM kana_index ki " \
          "JOIN cards c ON ki.card_id = c.card_id WHERE ki.reading = ? AND (c.written_raw IS NULL OR c.written_raw = '')",
          [reading]
        )
      end

      rows.uniq { |r| r[0] }.map do |r|
        { 'card_id' => r[0], 'written_raw' => r[1], 'kana_raw' => r[2], 'body' => r[3] }
      end
    end

    def build_candidate(rank:, lemma:, written:, reading:, romaji:, id:, path:, entry:, warodai_cards:,
                        source_url:, source_sha256:)
      {
        'level' => 'BCCWJ Top Frequent',
        'source_name' => 'BCCWJ Top Frequent',
        'source_order' => rank,
        'written' => written,
        'raw_written' => lemma,
        'reading' => reading,
        'romaji' => romaji,
        'jmdict_id' => id.to_s,
        'path' => path,
        'source_guid' => "bccwj-luw2-#{rank}",
        'source_tags' => 'BCCWJ',
        'source_url' => source_url,
        'source_page_sha256' => source_sha256,
        'entry' => entry,
        'warodai_cards' => warodai_cards
      }
    end
  end

  # Formats batch authoring dossiers combining JMdict senses and consult-only
  # Warodai cards. Dossiers are strictly transient authoring references.
  module DossierFormatter
    module_function

    def format_batch(batch_num:, start_index:, rows:)
      lines = ["=== BATCH #{batch_num} (items #{start_index + 1}..#{start_index + rows.size}) ===", '']
      rows.each_with_index do |row, idx|
        lines.concat(format_item(idx + 1, row))
        lines << ''
      end
      "#{lines.join("\n")}\n"
    end

    def write_batches(candidates, dir:, batch_size: 10)
      FileUtils.mkdir_p(dir)
      candidates.each_slice(batch_size).with_index(1).map do |rows, batch_num|
        out_path = File.join(dir, format('dossier-%02d.txt', batch_num))
        File.write(out_path, format_batch(batch_num:, start_index: (batch_num - 1) * batch_size, rows:), encoding: 'UTF-8')
        out_path
      end
    end

    def format_item(item_num, row)
      entry = row.fetch('entry')
      written_forms = entry['written_forms'] || entry['kanji'] || []
      forms = written_forms.map { |k| k['text'] }
      readings = (entry['readings'] || []).map { |r| r['text'] }
      eng_senses = (entry['senses'] || []).select { |s| (s['glosses'] || []).any? { |g| g['lang'] == 'eng' } }

      lines = [
        "## #{item_num}. #{row['written']} [#{row['reading']}] " \
        "(JMdict:#{row['jmdict_id']}, rank:#{row['source_order']}, romaji:#{row['romaji']})",
        "   Forms: #{forms.empty? ? '(kana-only)' : forms.join(' / ')} | Readings: #{readings.join(' / ')}",
        "   Senses count: #{eng_senses.size}"
      ]

      eng_senses.each_with_index do |sense, idx|
        tags = sense_tags(sense)
        glosses = sense['glosses'].select { |g| g['lang'] == 'eng' }.map { |g| g['text'] }.join('; ')
        lines << "   S#{idx + 1} [#{tags.join(' | ')}]: #{glosses}"
      end

      (row['warodai_cards'] || []).first(2).each do |card|
        preview = card['body'].to_s.gsub(/\s+/, ' ').strip[0, 180]
        lines << "   Warodai(consult-only): #{card['card_id']}: #{preview}"
      end

      lines
    end

    def sense_tags(sense)
      tags = []
      pos = sense['parts_of_speech'] || []
      tags << "pos:#{pos.join(',')}" unless pos.empty?
      misc = sense['miscellaneous'] || []
      tags << "misc:#{misc.join(',')}" unless misc.empty?
      fields = sense['fields'] || []
      tags << "fld:#{fields.join(',')}" unless fields.empty?
      lsrc = (sense['language_sources'] || []).map { |ls| "#{ls['lang']}:#{ls['text']}" }
      tags << "src:#{lsrc.join(',')}" unless lsrc.empty?
      tags
    end
  end

  # Renders authored JSON batch payloads alongside selection rows using
  # scripts/scaffold_entry.rb's canonical schema v2 formatter.
  class Renderer
    def initialize(sources:, sha256: nil, jmdict_path: DEFAULT_JMDICT_PATH,
                   created_at: Date.today.iso8601, batch_size: 10)
      @sources = sources
      @sha256 = sha256
      @jmdict_path = jmdict_path
      @created_at = created_at
      @batch_size = batch_size
    end

    def render_batch(batch_num:, payload:)
      batch_start = (batch_num - 1) * @batch_size
      batch_rows = @sources[batch_start, @batch_size]
      unless batch_rows&.size&.positive?
        raise "No source rows found for batch #{batch_num} (batch_size=#{@batch_size})"
      end

      batch_rows.each_with_index.map do |row, idx|
        key = (idx + 1).to_s
        data = payload[key]
        raise "Missing payload data for item #{key} (#{row['written']})" unless data

        render_item(row:, data:, item_label: key)
      end
    end

    def render_item(row:, data:, item_label: nil)
      text = render_text(row:, data:, item_label:)
      path = row.fetch('path')
      FileUtils.mkdir_p(File.dirname(path))
      File.write(path, text, encoding: 'UTF-8')
      path
    end

    # Renders one authored item to Org text without touching the filesystem,
    # so callers can validate a payload before committing it to disk.
    def render_text(row:, data:, item_label: nil)
      entry = BccwjBatch.symbolize_keys(row.fetch('entry'))
      id = row.fetch('jmdict_id').to_s
      english_senses = entry[:senses].select { |s| english_sense?(s) }
      senses_data = data['senses'] || []
      unless english_senses.size == senses_data.size
        label = item_label ? " (#{item_label})" : ''
        raise "Sense count mismatch for #{row['written']}#{label}: expected #{english_senses.size}, got #{senses_data.size}"
      end

      text = format_entry(
        ent_seq: id,
        jmdict_entry: entry,
        primary_reading: row.fetch('reading'),
        romaji: row.fetch('romaji'),
        sha256: resolved_sha256,
        created_at: @created_at
      )

      splice_authored_sections(text:, id:, row:, data:)
    end

    private

    def resolved_sha256
      @sha256 ||= DictionarySources::Jmdict.new(@jmdict_path).archive_sha256
    end

    def splice_authored_sections(text:, id:, row:, data:)
      blocks = text.split(/(?=^\* Sense )/)
      header = blocks.shift
      primary_idx = data.fetch('primary_sense', 1) - 1
      eng_idx = 0

      blocks.map! do |block|
        next block unless block.start_with?('* Sense ') && block.include?('Приклад.')

        sid = block[/^\* Sense (\S+)/, 1]
        gloss, note = data['senses'].fetch(eng_idx)
        is_primary = (eng_idx == primary_idx)
        eng_idx += 1

        block = block.sub(":LEARNER_PRIORITY: primary\n", '')
        block = block.sub(':END:', ":LEARNER_PRIORITY: primary\n:END:") if is_primary

        authored = build_sense_body(sid:, id:, gloss:, note:, row:, data:, is_primary:)
        block.sub(/\*\* Ukrainian glosses.*\z/m, "#{authored}\n")
      end

      [header, *blocks].join.lines.map { |line| "#{line.rstrip}\n" }.join
    end

    def build_sense_body(sid:, id:, gloss:, note:, row:, data:, is_primary:)
      sense_num = sid.split('-').last
      lines = [
        '** Ukrainian glosses',
        "*** uk-#{sid}-001",
        ':PROPERTIES:',
        ':END:',
        "- text :: #{gloss}",
        '** Learner notes',
        "*** note-#{sid}-001",
        ':PROPERTIES:',
        ':END:',
        "- UK :: #{note}",
        '- LEVEL :: advanced',
        '- REGISTER :: neutral'
      ]

      if is_primary
        examples = data['examples'] || []
        raise "Expected 3 examples for #{row['written']}, got #{examples.size}" unless examples.size == 3

        lines << '** Examples'
        examples.each_with_index do |example, ex_idx|
          ja, reading, uk, ex_focus = example
          focus = (ex_focus || data['focus'] || row['written']).to_s
          focus = row['reading'] if focus.empty?
          raise "Focus '#{focus}' absent from example JA '#{ja}' for #{row['written']}" unless ja.include?(focus)

          lines << "*** ex-#{id}-#{sense_num}-#{format('%03d', ex_idx + 1)}"
          lines << ':PROPERTIES:'
          lines << ":LEVEL: #{EXAMPLE_LEVELS[ex_idx]}"
          lines << ':REGISTER: neutral'
          lines << ':END:'
          lines << "- JA :: #{ja}"
          lines << "- READING :: #{reading}"
          lines << "- UK :: #{uk}"
          lines << "- FOCUS :: #{focus}"
        end
      end

      "#{lines.join("\n")}\n"
    end
  end
end
