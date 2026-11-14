# frozen_string_literal: true

require 'minitest/autorun'
require 'sequel'
require 'tmpdir'
require_relative '../lib/kanji'

class KanjiImportTest < Minitest::Test
  KANJIDIC = <<~XML
    <?xml version="1.0" encoding="UTF-8"?>
    <kanjidic2>
      <header><file_version>4</file_version><database_version>2026-001</database_version><date_of_creation>2026-11-10</date_of_creation></header>
      <character>
        <literal>一</literal>
        <codepoint><cp_value cp_type="ucs">4e00</cp_value></codepoint>
        <misc><grade>1</grade><stroke_count>1</stroke_count><freq>1</freq></misc>
        <reading_meaning><rmgroup>
          <reading r_type="ja_on">イチ</reading>
          <reading r_type="ja_on">イツ</reading>
          <reading r_type="ja_kun">ひと</reading>
          <meaning>one</meaning>
          <meaning m_lang="fr">un</meaning>
        </rmgroup></reading_meaning>
      </character>
      <character>
        <literal>𠀀</literal>
        <codepoint><cp_value cp_type="ucs">20000</cp_value></codepoint>
        <misc><stroke_count>2</stroke_count></misc>
      </character>
    </kanjidic2>
  XML

  KANJIVG = <<~XML
    <?xml version="1.0" encoding="UTF-8"?>
    <kanjivg xmlns:kvg="http://kanjivg.tagaini.net">
    <kanji id="kvg:kanji_04e00">
    <g id="kvg:04e00" kvg:element="一">
    <path id="kvg:04e00-s1" kvg:type="㇐" d="M11,54c3,0 5,0 8,1"/>
    </g>
    </kanji>
    <kanji id="kvg:kanji_20000"><g id="kvg:20000"><path id="kvg:20000-s1" kvg:type="㇐" d="M1,1"/><path id="kvg:20000-s2" kvg:type="㇑" d="M2,2"/></g></kanji>
    </kanjivg>
  XML

  def test_reads_kanjidic_characters_with_their_source_fields
    entries = Kanji::Import::Kanjidic2.parse(KANJIDIC)
    one = entries.find { |entry| entry.codepoint == 'U+4E00' }
    assert_equal '一', one.character
    assert_equal 1, one.source.stroke_count
    assert_equal 1, one.source.grade
    assert_equal 1, one.source.frequency
    assert_equal %w[イチ イツ], one.source.on_readings
    assert_equal %w[ひと], one.source.kun_readings
    assert_equal ['one'], one.source.meanings, 'meanings in other languages are left out'
  end

  def test_a_character_with_few_fields_still_imports
    entry = Kanji::Import::Kanjidic2.parse(KANJIDIC).find { |item| item.codepoint == 'U+20000' }
    assert_equal 2, entry.source.stroke_count
    assert_nil entry.source.grade
    assert_empty entry.source.on_readings
  end

  def test_reads_kanjivg_strokes_in_drawing_order
    strokes = Kanji::Import::KanjiVG.parse(KANJIVG)
    assert_equal ['U+4E00', 'U+20000'], strokes.keys
    assert_equal [1], strokes['U+4E00'].map(&:position)
    assert_equal %w[㇑], strokes['U+20000'].select { |stroke| stroke.position == 2 }.map(&:kind)
    assert_equal 'M11,54c3,0 5,0 8,1', strokes['U+4E00'].first.path
  end

  def test_import_writes_records_then_keeps_translations_when_the_source_changes
    Dir.mktmpdir do |root|
      kanjidic = File.join(root, 'kanjidic2.xml')
      kanjivg = File.join(root, 'kanjivg.xml')
      records = File.join(root, 'kanji')
      File.write(kanjidic, KANJIDIC)
      File.write(kanjivg, KANJIVG)

      first = Kanji::Importer.run(kanjidic: kanjidic, kanjivg: kanjivg, records_dir: records)
      assert_equal 2, first.new_records
      assert_equal 2, first.written
      assert_empty first.stroke_mismatches

      # A reviewed translation, then an upstream change to the stroke count.
      path = File.join(records, 'U+4E00.org')
      record = Kanji::Record.load(path)
      translated = record.translations + [Kanji::Translation.new(id: 'uk-U+4E00-001', text: 'один', status: 'reviewed', reviewed_by: 'reviewer-fixture')]
      File.write(path, Kanji::Writer.render(keywords: record.keywords, source: record.source, translations: translated))
      changed = KANJIDIC.sub('<stroke_count>1</stroke_count>', '<stroke_count>1</stroke_count><freq>9</freq>')
      File.write(kanjidic, changed)

      second = Kanji::Importer.run(kanjidic: kanjidic, kanjivg: kanjivg, records_dir: records)
      assert_equal 0, second.new_records
      assert_equal 2, second.unchanged + second.written
      rewritten = Kanji::Record.load(path)
      assert_equal 9, rewritten.source.frequency
      assert_equal 'один', rewritten.translations.first.text
      assert_equal 'reviewed', rewritten.translations.first.status
      assert_empty Kanji::Validator.call(rewritten, filename: path)
    end
  end

  def test_canonical_equivalent_meanings_keep_local_metadata_and_reviewed_translations
    source = Kanji::Import::Kanjidic2.parse(KANJIDIC).first.source
    canonical = Kanji::Import::Kanjidic2::Entry.new(codepoint: 'U+96E3', character: '難', source: source.with(meanings: ['difficult']))
    raw = source.with(stroke_count: 19, on_readings: ['ナン'], meanings: [])
    equivalent = Kanji::Import::Kanjidic2::Entry.new(codepoint: 'U+FA68', character: '難', source: raw)
    lookup = { '難' => canonical }
    text = Kanji::Importer.render_entry(equivalent, nil, lookup)
    record = Kanji::Record.parse(text)
    assert_equal ['difficult'], record.source.meanings
    assert_equal 19, record.source.stroke_count
    assert_equal ['ナン'], record.source.on_readings
    assert_equal 'U+96E3', record.keywords['SOURCE_MEANINGS_REFERENCE']
    assert_equal raw.fingerprint, record.keywords['KANJIDIC2_SOURCE_FINGERPRINT']
    keywords = record.keywords.merge('DRAFT_ORIGIN' => 'codex')
    after_draft = Kanji::Writer.render(keywords: keywords, source: record.source)
    assert_equal after_draft, Kanji::Importer.render_entry(equivalent, Kanji::Record.parse(after_draft), lookup)
    assert_empty Kanji::Validator.call(record)
    reviewed = Kanji::Translation.new(id: 'uk-U+FA68-001', text: 'складний', status: 'reviewed', reviewed_by: 'human')
    record = Kanji::Record.parse(Kanji::Writer.render(keywords: record.keywords, source: record.source, translations: [reviewed]))
    assert_equal [reviewed], Kanji::Record.parse(Kanji::Importer.render_entry(equivalent, record, lookup)).translations
    supplied = equivalent.with(source: raw.with(meanings: ['own upstream meaning']))
    own = Kanji::Record.parse(Kanji::Importer.render_entry(supplied, record, lookup))
    assert_equal ['own upstream meaning'], own.source.meanings
    assert_nil own.keywords['SOURCE_MEANINGS_REFERENCE']
    unrelated = equivalent.with(character: '南', codepoint: 'U+5357')
    assert_empty Kanji::Record.parse(Kanji::Importer.render_entry(unrelated, nil, lookup)).source.meanings
  end

  def test_missing_strokes_are_reported_not_fatal
    Dir.mktmpdir do |root|
      kanjidic = File.join(root, 'kanjidic2.xml')
      kanjivg = File.join(root, 'kanjivg.xml')
      File.write(kanjidic, KANJIDIC)
      File.write(kanjivg, '<kanjivg></kanjivg>')
      report = Kanji::Importer.run(kanjidic: kanjidic, kanjivg: kanjivg, records_dir: File.join(root, 'kanji'))
      assert_equal %w[U+4E00 U+20000], report.missing_strokes
      assert_equal 2, report.written
    end
  end

  def test_writes_the_kanji_tables_with_strokes_by_codepoint
    records = [
      Kanji::Record.parse(Kanji::Writer.render(keywords: { 'TITLE' => '一', 'CODEPOINT' => 'U+4E00' },
                                               source: Kanji::Source.new(stroke_count: 1, grade: 1, frequency: nil,
                                                                         on_readings: ['イチ'], kun_readings: ['ひと'],
                                                                         meanings: ['one']))),
    ]
    strokes = Kanji::Import::KanjiVG.parse(KANJIVG)
    db = Sequel.sqlite
    Kanji::Exporter.write_tables(db, records, strokes)

    assert_equal ['U+4E00'], db[:kanji].select_map(:codepoint)
    assert_equal %w[kun on], db[:kanji_readings].select_map(:kind).uniq.sort
    assert_equal ['one'], db[:kanji_meanings].select_map(:text)
    assert_equal 1, db[:kanji_strokes].where(codepoint: 'U+4E00').count
  end
end
