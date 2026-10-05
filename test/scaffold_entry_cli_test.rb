# frozen_string_literal: true

require 'fileutils'
require 'json'
require 'minitest/autorun'
require 'open3'
require 'rbconfig'
require 'tmpdir'
require 'zlib'

class ScaffoldEntryCliTest < Minitest::Test
  SCRIPT = File.expand_path('../scripts/scaffold_entry.rb', __dir__)

  def test_scaffolds_via_queue_file_with_entry_index
    Dir.mktmpdir do |directory|
      paths = build_sources(directory, ent_seqs: %w[1381380])
      queue_file = File.join(directory, 'queue.json')
      queue_data = [
        {
          'order' => 101,
          'source_row' => 1,
          'title' => '青',
          'reading' => 'あお',
          'romaji' => 'ao',
          'jmdict_id' => '1381380'
        }
      ]
      File.write(queue_file, JSON.pretty_generate(queue_data), encoding: Encoding::UTF_8)
      output = File.join(directory, 'out.org')

      stdout, stderr, status = run_cli(
        paths,
        '--queue-file', queue_file,
        '--entry-index', '0',
        '--output', output
      )

      assert status.success?, stderr
      assert_match(/scaffolded/, stdout)
      assert File.exist?(output)
      content = File.read(output, encoding: Encoding::UTF_8)
      assert_includes content, '#+TITLE: 青'
      assert_includes content, '#+JMDICT_ID: 1381380'
      assert_includes content, '#+PRIMARY_READING: あお'
      assert_includes content, '#+ROMAJI: ao'
    end
  end

  def test_scaffolds_via_queue_file_with_source_order
    Dir.mktmpdir do |directory|
      paths = build_sources(directory, ent_seqs: %w[1381380])
      queue_file = File.join(directory, 'queue.json')
      queue_data = [
        {
          'order' => 205,
          'source_row' => 42,
          'title' => '青',
          'reading' => 'あお',
          'romaji' => 'ao',
          'jmdict_id' => '1381380'
        }
      ]
      File.write(queue_file, JSON.pretty_generate(queue_data), encoding: Encoding::UTF_8)
      output = File.join(directory, 'out.org')

      stdout, stderr, status = run_cli(
        paths,
        '--queue-file', queue_file,
        '--source-order', '205',
        '--output', output
      )

      assert status.success?, stderr
      assert_match(/scaffolded/, stdout)
      assert File.exist?(output)
    end
  end

  def test_queue_file_out_of_bounds_index_fails
    Dir.mktmpdir do |directory|
      paths = build_sources(directory, ent_seqs: %w[1381380])
      queue_file = File.join(directory, 'queue.json')
      File.write(queue_file, '[]', encoding: Encoding::UTF_8)
      output = File.join(directory, 'out.org')

      _stdout, stderr, status = run_cli(
        paths,
        '--queue-file', queue_file,
        '--entry-index', '5',
        '--output', output
      )

      refute status.success?
      assert_match(/out of bounds/, stderr)
    end
  end

  def test_refuses_to_overwrite_existing_file
    Dir.mktmpdir do |directory|
      paths = build_sources(directory, ent_seqs: %w[1381380])
      output = File.join(directory, 'existing.org')
      File.write(output, '# existing', encoding: Encoding::UTF_8)

      _stdout, stderr, status = run_cli(
        paths,
        '--jmdict-id', '1381380',
        '--romaji', 'ao',
        '--output', output
      )

      refute status.success?
      assert_match(/refuses to overwrite/, stderr)
    end
  end

  def test_rejects_negative_index
    assert_queue_failure([{ 'jmdict_id' => '1381380', 'romaji' => 'ao' }],
                         ['--entry-index', '-1'], /out of bounds/)
  end

  def test_rejects_conflicting_selectors
    assert_queue_failure([{ 'jmdict_id' => '1381380', 'romaji' => 'ao' }],
                         ['--entry-index', '0', '--jmdict-id', '1381380'], /only one/)
  end

  def test_rejects_non_object_records
    [nil, 'word', [42]].each do |data|
      assert_queue_failure(data, [], /JSON objects/)
    end
  end

  def test_rejects_duplicate_source_orders
    record = { 'order' => 1, 'jmdict_id' => '1381380', 'romaji' => 'ao' }
    assert_queue_failure([record, record], ['--source-order', '1'], /resolved to 2 records/)
  end

  def test_source_row_does_not_override_explicit_order
    assert_queue_failure([{ 'order' => 205, 'source_row' => 42, 'jmdict_id' => '1381380', 'romaji' => 'ao' }],
                         ['--source-order', '42'], /resolved to 0 records/)
  end

  def test_rejects_non_numeric_source_order
    assert_queue_failure([{ 'order' => '1wrong', 'jmdict_id' => '1381380', 'romaji' => 'ao' }],
                         ['--source-order', '1'], /resolved to 0 records/)
  end

  def test_rejects_missing_identity
    assert_queue_failure({ 'romaji' => 'ao' }, [], /must provide/)
  end

  def test_rejects_mismatched_identity
    assert_queue_failure({ 'jmdict_id' => '1381380', 'written' => '赤', 'reading' => 'あか', 'romaji' => 'ao' },
                         [], /No JMdict match/)
  end

  def test_rejects_invalid_field_types_and_filename
    assert_queue_failure({ 'jmdict_id' => '1381380', 'reading' => 42, 'romaji' => 'ao' }, [], /field reading/)
    assert_queue_failure({ 'jmdict_id' => '1381380', 'romaji' => '../../escape' }, [], /Filename romaji/)
  end

  def test_rejects_ambiguous_jmdict_matches
    Dir.mktmpdir do |directory|
      paths = build_sources(directory, ent_seqs: %w[1381380 1381381])
      queue_file = File.join(directory, 'queue.json')
      File.write(queue_file, JSON.generate({ 'written' => '青', 'reading' => 'あお', 'romaji' => 'ao' }))
      output = File.join(directory, 'out.org')
      _stdout, stderr, status = run_cli(paths, '--queue-file', queue_file, '--output', output)
      refute status.success?
      assert_match(/2 JMdict entries/, stderr)
      refute File.exist?(output)
    end
  end

  def test_rejects_entry_index_without_queue
    Dir.mktmpdir do |directory|
      paths = build_sources(directory, ent_seqs: %w[1381380])
      _stdout, stderr, status = run_cli(paths, '--entry-index', '0', '--romaji', 'ao')
      refute status.success?
      assert_match(/requires --queue-file/, stderr)
    end
  end

  def test_rejects_malformed_json
    Dir.mktmpdir do |directory|
      paths = build_sources(directory, ent_seqs: %w[1381380])
      queue_file = File.join(directory, 'queue.json')
      File.write(queue_file, '{')
      output = File.join(directory, 'out.org')
      _stdout, stderr, status = run_cli(paths, '--queue-file', queue_file, '--output', output)
      refute status.success?
      assert_match(/Invalid queue JSON/, stderr)
      refute File.exist?(output)
    end
  end

  def test_selects_by_id_and_resolves_without_an_id
    [{ 'jmdict_id' => 1381380, 'romaji' => 'ao' },
     { 'written' => '青', 'reading' => 'あお', 'romaji' => 'ao' }].each do |record|
      Dir.mktmpdir do |directory|
        paths = build_sources(directory, ent_seqs: %w[1381380])
        queue_file = File.join(directory, 'queue.json')
        File.write(queue_file, JSON.generate(record))
        output = File.join(directory, 'out.org')
        arguments = record.key?('jmdict_id') ? ['--jmdict-id', '1381380'] : []
        _stdout, stderr, status = run_cli(paths, '--queue-file', queue_file, '--output', output, *arguments)
        assert status.success?, stderr
        assert_includes File.read(output), '#+JMDICT_ID: 1381380'
      end
    end
  end

  private

  def assert_queue_failure(data, arguments, message)
    Dir.mktmpdir do |directory|
      paths = build_sources(directory, ent_seqs: %w[1381380])
      queue_file = File.join(directory, 'queue.json')
      File.write(queue_file, JSON.generate(data))
      output = File.join(directory, 'out.org')
      _stdout, stderr, status = run_cli(paths, '--queue-file', queue_file, '--output', output, *arguments)
      refute status.success?
      assert_match message, stderr
      refute File.exist?(output)
      refute_match(/NoMethodError|TypeError/, stderr)
    end
  end

  def build_sources(directory, ent_seqs:)
    jmdict_path = File.join(directory, 'JMdict.xml.gz')
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

    { jmdict: jmdict_path }
  end

  def run_cli(paths, *arguments)
    environment = {
      'JMDICT_PATH' => paths.fetch(:jmdict)
    }
    Open3.capture3(environment, RbConfig.ruby, SCRIPT, *arguments)
  end
end
