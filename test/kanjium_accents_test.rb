# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/kanjium_accents'

class KanjiumAccentsTest < Minitest::Test
  K = KanjiumAccents
  DAY = '2026-11-19'

  # --- parse_line ---------------------------------------------------------

  def test_parses_a_plain_row
    line = K.parse_line("日本語\tにほんご\t0\n")
    assert_equal ['日本語', 'にほんご', [0], false], [line.word, line.reading, line.drops, line.pos_tagged]
    refute line.kana_only?
  end

  def test_a_drop_list_keeps_source_order_and_drops_duplicates
    assert_equal [4, 0], K.parse_line("１０月\tじゅうがつ\t4,0").drops
    assert_equal [2], K.parse_line("x\tえっくす\t2,2").drops
  end

  def test_part_of_speech_prefixes_are_stripped_and_flagged
    line = K.parse_line("お手前\tおてまえ\t(名)2,(代)2,0")
    assert_equal [2, 0], line.drops
    assert line.pos_tagged
  end

  def test_an_empty_reading_marks_a_kana_word
    line = K.parse_line("かすかす\t\t(副)1,0,(形動)0")
    assert line.kana_only?
    assert_nil line.reading
    assert_equal [1, 0], line.drops
  end

  def test_malformed_rows_are_rejected
    assert_nil K.parse_line('')
    assert_nil K.parse_line("語\tご")
    assert_nil K.parse_line("語\tご\t")
    assert_nil K.parse_line("語\tご\t?")
    assert_nil K.parse_line("語\tご\t1,(名)")
  end

  # --- read_forms ---------------------------------------------------------

  def test_reads_written_forms_readings_and_restrictions
    forms = K.read_forms(entry(written: %w[蟇 蝦蟇], readings: [['ひき', ['蟇']], ['がま', nil], ['ガマ', :no_kanji]]))
    assert_equal '1000001', forms.ent_seq
    assert_equal %w[蟇 蝦蟇], forms.written
    hiki, gama, kata = forms.readings
    assert_equal ['rd-1000001-001', 'ひき', ['蟇']], [hiki.id, hiki.text, hiki.applies_to]
    assert hiki.applies_to?('蟇')
    refute hiki.applies_to?('蝦蟇')
    assert_nil gama.applies_to
    assert kata.no_kanji
    refute kata.applies_to?('蟇')
  end

  # --- Index#match --------------------------------------------------------

  def test_kanji_rows_join_on_written_form_and_reading
    index = index_of('a' => entry(written: %w[日本語], readings: [['にほんご', nil], ['にっぽんご', nil]]))
    match = index.match(K.parse_line("日本語\tにっぽんご\t0"))
    assert_equal :matched, match.status
    assert_equal ['rd-1000001-002'], match.targets.map { |t| t.reading.id }
  end

  def test_restricted_readings_only_join_their_written_forms
    index = index_of('a' => entry(written: %w[蟇 蝦蟇], readings: [['ひき', ['蟇']], ['がま', nil]]))
    assert_equal :unmatched, index.match(K.parse_line("蝦蟇\tひき\t2")).status
    assert_equal :matched, index.match(K.parse_line("蟇\tひき\t2")).status
  end

  def test_full_width_digits_and_katakana_readings_normalise
    index = index_of('a' => entry(written: %w[10月], readings: [['じゅうがつ', nil]]))
    assert_equal :matched, index.match(K.parse_line("１０月\tジュウガツ\t4")).status
  end

  def test_unknown_rows_are_unmatched
    index = index_of('a' => entry(written: %w[山], readings: [['やま', nil]]))
    assert_equal :unmatched, index.match(K.parse_line("川\tかわ\t2")).status
  end

  def test_a_kana_row_joins_a_single_entry_by_reading
    index = index_of('a' => entry(written: %w[有難う], readings: [['ありがとう', nil]]))
    assert_equal :matched, index.match(K.parse_line("ありがとう\t\t2")).status
  end

  def test_a_kana_row_matches_katakana_only_entries
    index = index_of('a' => entry(written: [], readings: [['コーヒー', :no_kanji]]))
    match = index.match(K.parse_line("コーヒー\t\t3"))
    assert_equal :matched, match.status
  end

  def test_a_kana_row_shared_by_homophones_keeps_only_the_kana_entry
    index = index_of('bridge' => entry(id: 1, written: %w[橋], readings: [['はし', nil]]),
                     'kana' => entry(id: 2, written: [], readings: [['はし', :no_kanji]]))
    match = index.match(K.parse_line("はし\t\t1"))
    assert_equal :matched, match.status
    assert_equal ['kana'], match.targets.map(&:key)
  end

  def test_a_kana_row_shared_by_kanji_homophones_is_ambiguous
    index = index_of('bridge' => entry(id: 1, written: %w[橋], readings: [['はし', nil]]),
                     'chopsticks' => entry(id: 2, written: %w[箸], readings: [['はし', nil]]))
    assert_equal :ambiguous, index.match(K.parse_line("はし\t\t1")).status
  end

  # --- render / merge -----------------------------------------------------

  def test_renders_the_section_eleven_block
    reading = K::Reading.new(id: 'rd-1464530-001', text: 'にほんご', no_kanji: false, applies_to: nil)
    block = K.render_block(id: 'accent-rd-1464530-001-001', reading: reading, drop: 0, verified_at: DAY)
    assert_equal <<~ORG.chomp, block.join("\n")
      ** Accent accent-rd-1464530-001-001
      :PROPERTIES:
      :TARGET_ID: rd-1464530-001
      :SYSTEM: Tokyo
      :MORA_COUNT: 4
      :DROP_AFTER: 0
      :PATTERN: heiban
      :MORA_PATTERN: LHHH
      :CONTEXT: lexical
      :SOURCE_ID: kanjium
      :SOURCE_VERSION: #{K::COMMIT}
      :SOURCE_URL: #{K::SOURCE_URL}
      :LICENSE: CC-BY-SA-4.0
      :STATUS: imported
      :VERIFIED_AT: #{DAY}
      :END:
      - reading :: にほんご
    ORG
  end

  def test_inserts_the_section_before_media
    text = entry(written: %w[日本], readings: [['にほん', nil]], media: true)
    result = merge(text, 0 => [2])
    assert_equal 1, result.written
    assert_match(/\n- uk-text :: x\n\n\* Pronunciation\n\*\* Accent accent-rd-1000001-001-001\n/, result.text)
    assert_match(/- reading :: にほん\n\n\* Media\n/, result.text)
  end

  def test_appends_the_section_at_the_end_and_numbers_each_drop
    result = merge(entry(written: %w[一], readings: [['ひと', nil]]), 0 => [0, 2])
    assert_equal 2, result.written
    assert_includes result.text, "** Accent accent-rd-1000001-001-001\n"
    assert_includes result.text, "** Accent accent-rd-1000001-001-002\n"
    assert_includes result.text, ":DROP_AFTER: 2\n:PATTERN: odaka\n:MORA_PATTERN: LH\n"
    assert result.text.end_with?("- reading :: ひと\n")
  end

  def test_rerunning_is_a_no_op_even_on_another_day
    text = entry(written: %w[一], readings: [['ひと', nil]], media: true)
    once = merge(text, 0 => [0, 2]).text
    twice = merge(once, { 0 => [0, 2] }, '2027-01-01').text
    assert_equal once, twice
  end

  def test_changed_source_data_replaces_only_imported_blocks
    once = merge(entry(written: %w[一], readings: [['ひと', nil]]), 0 => [0, 2]).text
    again = merge(once, 0 => [2, 1]).text
    assert_includes again, "accent-rd-1000001-001-002\n:PROPERTIES:\n:TARGET_ID: rd-1000001-001\n:SYSTEM: Tokyo\n:MORA_COUNT: 2\n:DROP_AFTER: 2"
    assert_includes again, "accent-rd-1000001-001-003\n"
    refute_includes again, 'accent-rd-1000001-001-001'
  end

  def test_no_drops_removes_the_imported_section
    text = entry(written: %w[一], readings: [['ひと', nil]], media: true)
    once = merge(text, 0 => [0]).text
    assert_equal text, merge(once, {}).text
    plain = entry(written: %w[一], readings: [['ひと', nil]])
    assert_equal plain, merge(merge(plain, 0 => [0]).text, {}).text
  end

  def test_hand_authored_accents_are_kept_and_not_duplicated
    text = entry(written: %w[日本語], readings: [['にほんご', nil], ['にっぽんご', nil]], media: true)
    hand = merge(text, 0 => [0]).text.sub("- reading :: にほんご\n", "- reading :: にほんご\n- explanation-uk :: Хейбан.\n")
    result = merge(hand, 0 => [0], 1 => [0])
    assert_equal 1, result.kept
    assert_equal 1, result.written
    assert_includes result.text, '- explanation-uk :: Хейбан.'
    assert_includes result.text, 'accent-rd-1000001-002-001'
    assert_equal 1, result.text.scan('TARGET_ID: rd-1000001-001').length
  end

  def test_other_sources_and_promoted_statuses_are_kept
    once = merge(entry(written: %w[一], readings: [['ひと', nil]]), 0 => [0]).text
    reviewed = once.sub(':STATUS: imported', ':STATUS: reviewed')
    assert_equal reviewed, merge(reviewed, {}).text
    other = once.sub(':SOURCE_ID: kanjium', ':SOURCE_ID: unidic')
    assert_equal other, merge(other, {}).text
  end

  def test_a_drop_past_the_last_mora_is_skipped
    result = merge(entry(written: %w[木], readings: [['き', nil]]), 0 => [3])
    assert_equal 1, result.invalid
    assert_equal 0, result.written
    refute_includes result.text, '* Pronunciation'
  end

  private

  def merge(text, drops, verified_at = DAY)
    readings = K.read_forms(text).readings
    K.merge(text, drops.transform_keys { |index| readings[index] }, verified_at: verified_at)
  end

  def index_of(entries)
    entries.each_with_object(K::Index.new) { |(key, text), index| index.add(key, K.read_forms(text)) }
  end

  # readings: [[text, restriction]] where restriction is nil (`- *`), an
  # array of written forms, or :no_kanji.
  def entry(written:, readings:, id: 1, media: false)
    ent = 1_000_000 + id
    out = +"#+TITLE: x\n#+JMDICT_ID: #{ent}\n\n* Forms\n"
    written.each_with_index do |text, i|
      out << format("** Written form wf-%<e>d-%<n>03d\n:PROPERTIES:\n:TEXT: %<t>s\n:END:\n", e: ent, n: i + 1, t: text)
    end
    readings.each_with_index do |(text, restriction), i|
      out << format("** Reading rd-%<e>d-%<n>03d\n:PROPERTIES:\n:TEXT: %<t>s\n:NO_KANJI: %<k>s\n:END:\n",
                    e: ent, n: i + 1, t: text, k: restriction == :no_kanji)
      next if restriction == :no_kanji

      out << "*** Applies to written forms\n"
      (restriction || ['*']).each { |form| out << "- #{form}\n" }
    end
    out << "\n* Sense s-#{ent}-001\n** Ukrainian glosses\n- uk-text :: x\n"
    out << "\n* Media\n** Audio audio-rd-#{ent}-001-001\n" if media
    out
  end
end
