# frozen_string_literal: true

require 'minitest/autorun'
require 'tmpdir'
require 'zlib'
require 'fileutils'

require_relative '../lib/dictionary_sources/jmdict'
require_relative '../lib/dictionary_sources/n5_queue'
require_relative '../lib/dictionary_sources/warodai'

class DictionarySourcesTest < Minitest::Test
  def test_jmdict_exact_lookup_extracts_structured_metadata
    Dir.mktmpdir do |directory|
      path = File.join(directory, 'JMdict.xml.gz')
      write_gzip(path, <<~XML)
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE JMdict [
        <!ENTITY n "noun (common) (futsuumeishi)">
        ]>
        <JMdict>
        <entry>
        <ent_seq>1381380</ent_seq>
        <k_ele><keb>青</keb><ke_pri>ichi1</ke_pri></k_ele>
        <r_ele><reb>あお</reb><re_restr>青</re_restr></r_ele>
        <sense><pos>&n;</pos><gloss>blue</gloss><gloss xml:lang="rus">синий</gloss></sense>
        </entry>
        </JMdict>
      XML

      entries = DictionarySources::Jmdict.new(path).lookup(written: '青', reading: 'あお')

      assert_equal 1, entries.length
      assert_equal '1381380', entries.first[:ent_seq]
      assert_equal ['ichi1'], entries.first[:written_forms].first[:priorities]
      assert_equal ['青'], entries.first[:readings].first[:applies_to_written_forms]
      assert_equal ['n'], entries.first[:senses].first[:parts_of_speech]
      assert_equal({ 'eng' => [1], 'rus' => [1] }, entries.first[:sense_indexes_by_language])
      assert_match(/\A[0-9a-f]{64}\z/, entries.first[:senses].first[:source_fingerprint])

      source = DictionarySources::Jmdict.new(path)
      assert_equal ['1381380'], source.lookup(ent_seq: 1_381_380).map { |entry| entry[:ent_seq] }
      assert_empty source.lookup(written: '赤', reading: 'あお')
    end
  end

  def test_warodai_header_and_exact_lookup
    Dir.mktmpdir do |directory|
      path = File.join(directory, '004', '40', '004-40-72.txt')
      FileUtils.mkdir_p(File.dirname(path))
      File.write(path, "あう【会う･逢う】(ау) [разг.]〔004-40-72〕\nтестовое значение.", encoding: Encoding::UTF_8)

      entries = DictionarySources::Warodai.new(directory).lookup(written: '会う', reading: 'あう')

      assert_equal 1, entries.length
      assert_equal %w[会う 逢う], entries.first[:written_forms]
      assert_equal ['разг.'], entries.first[:corpus_codes]
      assert_equal ['тестовое значение.'], entries.first[:body_lines]
      assert_equal '004/40/004-40-72.txt', entries.first[:relative_path]

      by_id = DictionarySources::Warodai.new(directory).lookup(card_id: '004-40-72')
      assert_equal ['004-40-72'], by_id.map { |entry| entry[:card_id] }
    end
  end

  def test_warodai_rejects_malformed_headers
    source = DictionarySources::Warodai.new('/private/tmp')

    error = assert_raises(ArgumentError) { source.parse_header('あお【青】(ао)') }

    assert_match(/missing Warodai card ID/, error.message)
  end

  def test_n5_queue_uses_csv_aware_tsv_parsing
    Dir.mktmpdir do |directory|
      path = File.join(directory, 'n5.tsv')
      File.write(
        path,
        %("source_order"\t"written"\t"reading"\t"meaning_en"\n"2"\t"青"\t"あお"\t"blue; azure"\n),
        encoding: Encoding::UTF_8
      )

      row = DictionarySources::N5Queue.new(path).fetch(2)

      assert_equal '青', row[:written]
      assert_equal 'blue; azure', row[:meaning_en]

      assert_raises(KeyError) { DictionarySources::N5Queue.new(path).fetch(99) }
    end
  end

  private

  def write_gzip(path, content)
    Zlib::GzipWriter.open(path) { |gzip| gzip.write(content) }
  end
end
