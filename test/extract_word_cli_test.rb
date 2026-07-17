# frozen_string_literal: true

require 'fileutils'
require 'json'
require 'minitest/autorun'
require 'open3'
require 'rbconfig'
require 'tmpdir'
require 'zlib'

class ExtractWordCliTest < Minitest::Test
  SCRIPT = File.expand_path('../scripts/extract_word.rb', __dir__)

  def test_writes_a_deterministic_combined_dossier
    Dir.mktmpdir do |directory|
      paths = build_sources(directory, ent_seqs: %w[1381380])
      output = File.join(directory, 'dossier.json')

      first_stdout, first_stderr, first_status = run_cli(paths, '--source-order', '2', '--output', output)
      first_json = File.binread(output)
      second_stdout, second_stderr, second_status = run_cli(paths, '--source-order', '2', '--output', output)

      assert first_status.success?, first_stderr
      assert second_status.success?, second_stderr
      assert_equal first_json, File.binread(output)
      assert_equal "#{output}\n", first_stdout
      assert_equal "#{output}\n", second_stdout
      assert_empty first_stderr
      assert_empty second_stderr

      dossier = JSON.parse(first_json)
      assert_equal 2, dossier.dig('query', 'source_order')
      assert_equal ['1381380'], dossier.dig('jmdict', 'matches').map { |entry| entry.fetch('ent_seq') }
      assert_equal ['005-14-12'], dossier.dig('warodai', 'matches').map { |entry| entry.fetch('card_id') }
      assert_equal 'Private read-only comparison; do not copy, translate, or publish Warodai text.',
                   dossier.dig('warodai', 'usage')
    end
  end

  def test_writes_ambiguous_dossier_then_fails_n5_reconciliation
    Dir.mktmpdir do |directory|
      paths = build_sources(directory, ent_seqs: %w[1381380 2381380])
      output = File.join(directory, 'ambiguous.json')

      stdout, stderr, status = run_cli(paths, '--source-order', '2', '--output', output)

      refute status.success?
      assert_equal "#{output}\n", stdout
      assert_match(/resolved to 2 JMdict entries/, stderr)
      assert_equal 2, JSON.parse(File.binread(output)).dig('jmdict', 'match_count')
    end
  end

  private

  def build_sources(directory, ent_seqs:)
    jmdict_path = File.join(directory, 'JMdict.xml.gz')
    warodai_root = File.join(directory, 'warodai')
    n5_path = File.join(directory, 'n5.tsv')

    entries = ent_seqs.map do |ent_seq|
      <<~XML
        <entry>
        <ent_seq>#{ent_seq}</ent_seq>
        <k_ele><keb>青</keb><ke_pri>ichi1</ke_pri></k_ele>
        <r_ele><reb>あお</reb></r_ele>
        <sense><pos>&n;</pos><gloss>blue</gloss></sense>
        </entry>
      XML
    end.join
    xml = <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE JMdict [
      <!ENTITY n "noun (common) (futsuumeishi)">
      ]>
      <JMdict>
      #{entries}</JMdict>
    XML
    Zlib::GzipWriter.open(jmdict_path) { |gzip| gzip.write(xml) }

    warodai_path = File.join(warodai_root, '005', '14', '005-14-12.txt')
    FileUtils.mkdir_p(File.dirname(warodai_path))
    File.write(warodai_path, "あお【青】(ао)〔005-14-12〕\nтестовое значение.", encoding: Encoding::UTF_8)
    File.write(
      n5_path,
      %("source_order"\t"written"\t"reading"\t"meaning_en"\n"2"\t"青"\t"あお"\t"blue"\n),
      encoding: Encoding::UTF_8
    )

    { jmdict: jmdict_path, warodai: warodai_root, n5: n5_path }
  end

  def run_cli(paths, *arguments)
    environment = {
      'JMDICT_PATH' => paths.fetch(:jmdict),
      'WARODAI_PATH' => paths.fetch(:warodai),
      'N5_PATH' => paths.fetch(:n5)
    }
    Open3.capture3(environment, RbConfig.ruby, SCRIPT, *arguments)
  end
end
