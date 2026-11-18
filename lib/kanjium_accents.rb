# frozen_string_literal: true

require_relative 'kana'
require_relative 'pitch_accent'

# Imports Kanjium's Tokyo pitch accents (data/source_files/raw/accents.txt)
# into entry `* Pronunciation` sections (docs/org-format.md §11).
#
# Everything here is pure text in, text out; scripts/import_kanjium_accents.rb
# does the file IO. The pipeline is:
#
#   parse_line   -> Line (word, reading, drop positions)
#   read_forms   -> Forms (the written forms and readings of one entry)
#   Index#match  -> the entry readings a Line describes
#   merge        -> the entry text with its Kanjium accent blocks rewritten
#
# Blocks the importer owns are Kanjium blocks still `STATUS: imported` whose
# only list item is `- reading ::`. Anything else — another source, a
# promoted status, an `explanation-uk` someone wrote — is hand-authored and
# kept byte for byte; the importer does not add a duplicate of its drop.
module KanjiumAccents
  module_function

  SOURCE_ID = 'kanjium'
  COMMIT = '8a0cdaa16d64a281a2048de2eee2ec5e3a440fa6'
  SOURCE_URL = "https://github.com/mifunetoshiro/kanjium/blob/#{COMMIT}/data/source_files/raw/accents.txt".freeze
  RAW_URL = "https://raw.githubusercontent.com/mifunetoshiro/kanjium/#{COMMIT}/data/source_files/raw/accents.txt".freeze
  SHA256 = '8bd0dd127dab32ceec94cb03ab1ba6b68858ea73421dfa1731af2f373deb4f20'
  LICENSE = 'CC-BY-SA-4.0'

  # One accents.txt row. `drops` are distinct drop positions in source order;
  # `pos_tagged` is true when any carried a part-of-speech prefix like `(名)`.
  Line = Data.define(:word, :reading, :drops, :pos_tagged) do
    def kana_only? = reading.nil?
  end

  DROP_TOKEN = /\A(?:\([^()]*\))?(\d+)\z/

  # Parses `word\treading\tdrops`. An empty reading means the word is itself
  # kana. Part-of-speech prefixes are dropped: the schema has no field for
  # them, and each value is still a lexical accent of the word. Returns nil
  # for a blank or malformed row.
  def parse_line(raw)
    fields = raw.chomp.split("\t", -1)
    return nil unless fields.length == 3

    word, reading, drops_field = fields.map(&:strip)
    return nil if word.empty? || drops_field.empty?

    tokens = drops_field.split(',').map(&:strip)
    drops = tokens.map { |token| DROP_TOKEN.match(token)&.[](1)&.to_i }
    return nil if drops.any?(&:nil?)

    Line.new(word: word, reading: reading.empty? ? nil : reading,
             drops: drops.uniq, pos_tagged: tokens.any? { |token| token.start_with?('(') })
  end

  def normalize_reading(text) = Kana.to_hiragana(Kana.nfkc(text))
  def normalize_written(text) = Kana.nfkc(text)

  Reading = Data.define(:id, :text, :no_kanji, :applies_to) do
    # applies_to is nil for the `- *` wildcard.
    def applies_to?(written)
      return false if no_kanji

      applies_to.nil? || applies_to.include?(written)
    end
  end

  Forms = Data.define(:ent_seq, :written, :readings)

  # Reads the `* Forms` section of an entry.
  def read_forms(text)
    ent_seq = text[/^#\+JMDICT_ID:\s*(\d+)/, 1]
    written = []
    readings = []
    current = nil
    in_forms = false
    in_applies = false

    text.each_line(chomp: true) do |line|
      if line.start_with?('* ')
        in_forms = line == '* Forms'
        next
      end
      next unless in_forms

      case line
      when /\A\*\* Written form /
        current = { kind: :written }
        in_applies = false
      when /\A\*\* Reading (rd-\d+-\d{3})\z/
        current = { kind: :reading, id: Regexp.last_match(1), applies_to: [] }
        readings << current
        in_applies = false
      when /\A\*\*\* Applies to written forms\z/
        in_applies = current && current[:kind] == :reading
      when /\A\*/
        in_applies = false
      when /\A:TEXT:\s*(.*)\z/
        next unless current

        value = Regexp.last_match(1)
        current[:kind] == :written ? written << value : current[:text] = value
      when /\A:NO_KANJI:\s*(.*)\z/
        current[:no_kanji] = Regexp.last_match(1) == 'true' if current
      when /\A- (.*)\z/
        current[:applies_to] << Regexp.last_match(1) if in_applies
      end
    end

    Forms.new(
      ent_seq: ent_seq,
      written: written,
      readings: readings.map do |r|
        applies = r[:applies_to]
        Reading.new(id: r[:id], text: r[:text], no_kanji: r[:no_kanji] || false,
                    applies_to: applies.empty? || applies == ['*'] ? nil : applies)
      end
    )
  end

  # One entry reading a Line can land on. `key` is opaque to the index (the
  # importer passes the entry path).
  Target = Data.define(:key, :forms, :reading)

  Match = Data.define(:status, :targets)

  # Looks entry readings up by (written form, reading) and by reading alone.
  class Index
    def initialize
      @by_pair = Hash.new { |hash, key| hash[key] = [] }
      @by_reading = Hash.new { |hash, key| hash[key] = [] }
    end

    def add(key, forms)
      forms.readings.each do |reading|
        next unless reading.text

        target = Target.new(key: key, forms: forms, reading: reading)
        kana = KanjiumAccents.normalize_reading(reading.text)
        @by_reading[kana] << target
        forms.written.each do |written|
          @by_pair[[KanjiumAccents.normalize_written(written), kana]] << target if reading.applies_to?(written)
        end
      end
      self
    end

    # A kanji row joins on written form plus reading, and every entry that
    # carries that pair gets it. A kana row joins on the reading alone, which
    # homophones share, so when several entries have the reading it keeps
    # only entries that are written in kana (no written forms, a NO_KANJI
    # reading, or a written form spelled exactly so); if that still leaves
    # more than one entry the row is :ambiguous and nothing is written.
    def match(line)
      targets = line.kana_only? ? kana_targets(line.word) : pair_targets(line)
      return Match.new(status: :unmatched, targets: []) if targets.empty?
      return Match.new(status: :ambiguous, targets: targets) if targets == :ambiguous

      Match.new(status: :matched, targets: targets)
    end

    private

    def pair_targets(line)
      @by_pair.fetch([KanjiumAccents.normalize_written(line.word), KanjiumAccents.normalize_reading(line.reading)], []).uniq
    end

    def kana_targets(word)
      candidates = @by_reading.fetch(KanjiumAccents.normalize_reading(word), []).uniq
      return candidates if candidates.map(&:key).uniq.length <= 1

      spelled = KanjiumAccents.normalize_written(word)
      kana_headed = candidates.select do |target|
        target.forms.written.empty? || target.reading.no_kanji ||
          target.forms.written.any? { |written| KanjiumAccents.normalize_written(written) == spelled }
      end
      return :ambiguous if kana_headed.map(&:key).uniq.length != 1

      kana_headed
    end
  end

  def accent_id(reading_id, number) = format('accent-%<rd>s-%<n>03d', rd: reading_id, n: number)

  # The Org block for one drop of one reading, or nil when the drop does not
  # fit the reading's morae.
  def render_block(id:, reading:, drop:, verified_at:)
    count = PitchAccent.mora_count(reading.text)
    return nil unless PitchAccent.valid_drop?(drop, count)

    <<~ORG.lines(chomp: true)
      ** Accent #{id}
      :PROPERTIES:
      :TARGET_ID: #{reading.id}
      :SYSTEM: Tokyo
      :MORA_COUNT: #{count}
      :DROP_AFTER: #{drop}
      :PATTERN: #{PitchAccent.pattern(drop, count)}
      :MORA_PATTERN: #{PitchAccent.mora_pattern(drop, count)}
      :CONTEXT: lexical
      :SOURCE_ID: #{SOURCE_ID}
      :SOURCE_VERSION: #{COMMIT}
      :SOURCE_URL: #{SOURCE_URL}
      :LICENSE: #{LICENSE}
      :STATUS: imported
      :VERIFIED_AT: #{verified_at}
      :END:
      - reading :: #{reading.text}
    ORG
  end

  Result = Data.define(:text, :written, :kept, :invalid)

  # Rewrites the importer-owned accent blocks of one entry.
  #
  # `drops_by_reading` maps a Reading to its drop positions (empty or missing
  # readings get none, so stale imported blocks are removed). An unchanged
  # block keeps its VERIFIED_AT and its ID, so a re-run is a no-op; a new drop
  # takes the next number after every accent ID the reading has had.
  def merge(text, drops_by_reading, verified_at:)
    lines = text.split("\n", -1)
    trailing_newline = lines.last == ''
    lines.pop if trailing_newline

    start = lines.index('* Pronunciation')
    finish = start ? next_top_level(lines, start + 1) : nil
    existing = start ? split_blocks(lines[(start + 1)...finish]) : { preamble: [], blocks: [] }

    kept = existing[:blocks].reject { |block| owned?(block) }
    owned = existing[:blocks].select { |block| owned?(block) }
    kept_keys = kept.to_set { |block| [block[:props]['TARGET_ID'], block[:props]['DROP_AFTER']] }
    owned_by_key = owned.to_h { |block| [[block[:props]['TARGET_ID'], block[:props]['DROP_AFTER']], block] }
    highest = Hash.new(0)
    existing[:blocks].each do |block|
      next unless (m = /\Aaccent-(rd-\d+-\d{3})-(\d{3})\z/.match(block[:id].to_s))

      highest[m[1]] = [highest[m[1]], m[2].to_i].max
    end

    generated = []
    invalid = 0
    drops_by_reading.each do |reading, drops|
      drops.each do |drop|
        key = [reading.id, drop.to_s]
        next if kept_keys.include?(key)

        previous = owned_by_key[key]
        id = previous ? previous[:id] : accent_id(reading.id, highest[reading.id] += 1)
        block = render_block(id: id, reading: reading, drop: drop, verified_at: verified_at)
        unless block
          invalid += 1
          next
        end
        block = previous[:lines] if previous && same_except_verified?(strip_blank(previous[:lines]), block)
        generated << { id: id, lines: strip_blank(block) }
      end
    end

    blocks = (kept.map { |block| block.merge(lines: strip_blank(block[:lines])) } + generated)
             .sort_by.with_index { |block, index| [block[:id].to_s, index] }
    preamble = strip_blank(existing[:preamble])
    section = blocks.empty? && preamble.empty? ? [] : ['* Pronunciation', *preamble, *blocks.flat_map { |b| b[:lines] }]

    out = if start
            tail_blanks = lines[start...finish].reverse.take_while(&:empty?)
            replace_section(lines, start, finish, section, tail_blanks)
          else
            insert_section(lines, section)
          end
    out_text = out.join("\n")
    out_text += "\n" if trailing_newline
    Result.new(text: out_text, written: generated.length, kept: kept.length, invalid: invalid)
  end

  def next_top_level(lines, from)
    (from...lines.length).find { |index| lines[index].start_with?('* ') } || lines.length
  end

  def split_blocks(body)
    preamble = []
    blocks = []
    body.each do |line|
      if (m = /\A\*\* (?:Accent (\S+)|.*)\z/.match(line))
        blocks << { id: m[1], lines: [line], props: {}, items: [] }
      elsif blocks.empty?
        preamble << line
      else
        block = blocks.last
        block[:lines] << line
        if (prop = /\A:([A-Z_]+):\s?(.*)\z/.match(line))
          block[:props][prop[1]] = prop[2]
        elsif (item = /\A- (\S+) ::/.match(line))
          block[:items] << item[1]
        elsif line.start_with?('-')
          block[:items] << nil
        end
      end
    end
    { preamble: preamble, blocks: blocks }
  end

  def owned?(block)
    block[:id]&.start_with?('accent-') &&
      block[:props]['SOURCE_ID'] == SOURCE_ID &&
      block[:props]['STATUS'] == 'imported' &&
      block[:items] == ['reading'] &&
      block[:lines].none? { |line| line.start_with?('***') }
  end

  def same_except_verified?(old_lines, new_lines)
    drop_verified = ->(ls) { ls.reject { |line| line.start_with?(':VERIFIED_AT:') } }
    drop_verified.call(old_lines) == drop_verified.call(new_lines)
  end

  def strip_blank(lines)
    lines = lines.dup
    lines.pop while lines.last&.empty?
    lines
  end

  def replace_section(lines, start, finish, section, tail_blanks)
    before = lines[0...start]
    after = lines[finish..]
    return after.empty? ? strip_blank(before) : before + after if section.empty?

    before + section + tail_blanks + after
  end

  # Places a new section before `* Media` / `* Entry notes` (§6), else at the end.
  def insert_section(lines, section)
    return lines if section.empty?

    at = lines.index { |line| ['* Media', '* Entry notes'].include?(line) } || lines.length
    before = lines[0...at]
    after = lines[at..]
    before.pop while before.last&.empty?
    before + [''] + section + (after.empty? ? [] : ['']) + after
  end
end
