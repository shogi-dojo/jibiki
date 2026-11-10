# frozen_string_literal: true

require 'minitest/autorun'
require 'rexml/document'
require 'tmpdir'
require 'zlib'
require_relative '../lib/dictionary_sources/jmdict'

# lookup_many resolves queries through a key index rather than testing every
# query against every entry; it must answer exactly what one lookup per query
# answers, in query order.
class JmdictLookupTest < Minitest::Test
  ARCHIVE = <<~XML
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE JMdict [
    <!ENTITY n "noun (common) (futsuumeishi)">
    ]>
    <JMdict>
    <entry>
    <ent_seq>1000010</ent_seq>
    <k_ele><keb>青</keb></k_ele>
    <r_ele><reb>あお</reb></r_ele>
    <sense><pos>&n;</pos><gloss>blue</gloss></sense>
    </entry>
    <entry>
    <ent_seq>1000020</ent_seq>
    <k_ele><keb>粟</keb></k_ele>
    <k_ele><keb>泡</keb></k_ele>
    <r_ele><reb>あわ</reb></r_ele>
    <sense><pos>&n;</pos><gloss>millet</gloss></sense>
    </entry>
    <entry>
    <ent_seq>1000030</ent_seq>
    <k_ele><keb>泡</keb></k_ele>
    <r_ele><reb>あぶく</reb></r_ele>
    <r_ele><reb>あわ</reb></r_ele>
    <sense><pos>&n;</pos><gloss>bubble</gloss></sense>
    </entry>
    <entry>
    <ent_seq>1000040</ent_seq>
    <k_ele><keb>Ｒ＆Ｄ</keb></k_ele>
    <k_ele><keb>R&amp;D</keb></k_ele>
    <r_ele><reb>アールアンドディー</reb></r_ele>
    <sense><pos>&n;</pos><gloss>research and development</gloss></sense>
    </entry>
    </JMdict>
  XML

  QUERIES = [
    { ent_seq: '1000030' },
    { written: '泡' },
    { reading: 'あわ' },
    { written: '泡', reading: 'あぶく' },
    { written: '粟', reading: 'あぶく' },
    { written: 'R&D' },
    { reading: 'アールアンドディー', ent_seq: 1_000_040 },
    { ent_seq: '1000010' },
    { ent_seq: '9999999' },
    { written: '泡' }
  ].freeze

  def with_archive
    Dir.mktmpdir do |directory|
      path = File.join(directory, 'JMdict.xml.gz')
      Zlib::GzipWriter.open(path) { |gz| gz.write(ARCHIVE) }
      yield DictionarySources::Jmdict.new(path)
    end
  end

  def seqs(matches)
    matches.map { |entry| entry[:ent_seq] }
  end

  def test_lookup_many_answers_what_single_lookups_answer
    with_archive do |jmdict|
      expected = QUERIES.map { |query| seqs(jmdict.lookup(**query)) }

      assert_equal expected, jmdict.lookup_many(QUERIES).map { |matches| seqs(matches) }
    end
  end

  def test_expected_matches
    with_archive do |jmdict|
      assert_equal [%w[1000030], %w[1000020 1000030], %w[1000020 1000030], %w[1000030], [], %w[1000040],
                    %w[1000040], %w[1000010], [], %w[1000020 1000030]],
                   jmdict.lookup_many(QUERIES).map { |matches| seqs(matches) }
    end
  end

  def test_lookup_by_ent_seq_returns_one_entry
    with_archive do |jmdict|
      assert_equal %w[1000020], seqs(jmdict.lookup(ent_seq: 1_000_020))
    end
  end

  def test_escape_matches_rexml
    with_archive do |jmdict|
      text = %(a&b<c>"d'e)

      assert_equal REXML::Text.normalize(text), jmdict.send(:xml_escape, text)
    end
  end
end
