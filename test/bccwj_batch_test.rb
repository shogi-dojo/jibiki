# frozen_string_literal: true

require 'json'
require 'minitest/autorun'
require 'open3'
require 'rbconfig'
require 'sqlite3'
require 'stringio'
require 'tmpdir'
require_relative '../lib/bccwj_batch'
require_relative '../lib/entry_validator'

class BccwjBatchTest < Minitest::Test
  SELECT_SCRIPT = File.expand_path('../scripts/select_bccwj.rb', __dir__)
  RENDER_SCRIPT = File.expand_path('../scripts/render_batch.rb', __dir__)

  def test_clean_lemma_filters_noise
    assert BccwjBatch.clean_lemma?('山', 'やま')
    assert BccwjBatch.clean_lemma?('サドル', 'さどる')
    refute BccwjBatch.clean_lemma?('す', 'す')
    refute BccwjBatch.clean_lemma?('山・川', 'やまかわ')
    refute BccwjBatch.clean_lemma?('〜的', 'てき')
    refute BccwjBatch.clean_lemma?('テスト', 'a?b')
  end

  def test_selector_filters_rank_pos_existing_and_missing_warodai
    Dir.mktmpdir do |dir|
      entries_dir, jmdict_db, warodai_db = build_fixture_dbs(dir)
      selector = BccwjBatch::Selector.new(
        jmdict_db:,
        warodai_db:,
        entries_dir:,
        min_rank: 10,
        limit: 5,
        excluded_words: ['除外語']
      )

      tsv = <<~TSV
        rank\tlForm\tlemma\tpos
        5\tヤマ\t山\t名詞-普通名詞-一般
        10\tコバルト\tコバルト\t名詞-普通名詞-一般
        11\tジョガイゴ\t除外語\t名詞-普通名詞-一般
        12\tキゾン\t既存\t名詞-普通名詞-一般
        13\tコユウ\t固有\t名詞-固有名詞-一般
        14\tワロナシ\tワロナシ\t名詞-普通名詞-一般
        15\tアオイ\t青い\t形容詞-一般
      TSV

      candidates = selector.select(
        io: StringIO.new(tsv),
        source_url: 'sources/bccwj/test.tsv',
        source_sha256: 'abc123'
      )

      assert_equal %w[コバルト 青い], candidates.map { |c| c['written'] }
      assert_equal '1050560', candidates.first['jmdict_id']
      assert_equal 'kobaruto', candidates.first['romaji']
      assert_equal 1, candidates.first['warodai_cards'].size
    ensure
      jmdict_db&.close
      warodai_db&.close
    end
  end

  def test_dossier_formatter_and_renderer_produce_valid_org_entry
    Dir.mktmpdir do |dir|
      out_path = File.join(dir, 'entries', '1381', '1381380-ao.org')
      sources = [
        {
          'source_order' => '42',
          'written' => '青',
          'reading' => 'あお',
          'romaji' => 'ao',
          'jmdict_id' => '1381380',
          'path' => out_path,
          'entry' => sample_jmdict_entry,
          'warodai_cards' => [{ 'card_id' => '005-14-12', 'body' => 'синій колір (довідково)' }]
        }
      ]

      dossier_paths = BccwjBatch::DossierFormatter.write_batches(sources, dir:, batch_size: 10)
      assert_equal 1, dossier_paths.size
      dossier = File.read(dossier_paths.first, encoding: 'UTF-8')
      assert_includes dossier, '## 1. 青 [あお] (JMdict:1381380, rank:42, romaji:ao)'
      assert_includes dossier, 'Forms: 青 | Readings: あお'
      assert_includes dossier, 'Senses count: 2'
      assert_includes dossier, 'Warodai(consult-only): 005-14-12:'

      payload = {
        '1' => {
          'focus' => '青',
          'primary_sense' => 2,
          'senses' => [
            ['синій, блакитний', 'Базова назва кольору у спектрі між зеленим і фіолетовим.'],
            ['зелене світло світлофора', 'У правилах дорожнього руху позначає дозвільний сигнал.']
          ],
          'examples' => [
            ['青になりました。', 'あおになりました。', 'Загорілося зелене світло.'],
            ['交差点の信号が青に変わったので渡った。', 'こうさてんのしんごうがあおにかわったのでわたった。', 'На перехресті світлофор перемкнувся на зелений, і я перейшов дорогу.'],
            ['青色の標識が目印として設置されている。', 'あおいろのひょうしきがめじるしとしてせっちされている。', 'Синій вказівник встановлено як орієнтир.', '青色']
          ]
        }
      }

      renderer = BccwjBatch::Renderer.new(
        sources:,
        sha256: EntryValidator::KNOWN_JMDICT_SHA256S.first,
        created_at: '2026-11-15',
        batch_size: 10
      )
      rendered = renderer.render_batch(batch_num: 1, payload:)
      assert_equal [out_path], rendered

      content = File.read(out_path, encoding: 'UTF-8')
      assert_equal content, renderer.render_text(row: sources.first, data: payload['1'])
      assert_includes content, '#+TITLE: 青'
      assert_includes content, ':LEARNER_PRIORITY: primary'
      assert_includes content, '- text :: синій, блакитний'
      assert_includes content, '- FOCUS :: 青色'
      assert_equal [], EntryValidator.validate_text(content)
    end
  end

  def test_renderer_rejects_sense_mismatch_and_missing_focus
    sources = [
      {
        'written' => '青',
        'reading' => 'あお',
        'romaji' => 'ao',
        'jmdict_id' => '1381380',
        'path' => 'entries/1381/1381380-ao.org',
        'entry' => sample_jmdict_entry
      }
    ]
    renderer = BccwjBatch::Renderer.new(sources:, sha256: 'deadbeef' * 8, created_at: '2026-11-15')

    err = assert_raises(RuntimeError) do
      renderer.render_batch(batch_num: 1, payload: { '1' => { 'senses' => [%w[синій нотатка]], 'examples' => [] } })
    end
    assert_match(/Sense count mismatch/, err.message)

    err2 = assert_raises(RuntimeError) do
      renderer.render_batch(
        batch_num: 1,
        payload: {
          '1' => {
            'focus' => '青',
            'senses' => [%w[синій нотатка], %w[зелений нотатка]],
            'examples' => [
              ['赤です。', 'あかです。', 'Червоний.'],
              ['青です。', 'あおです。', 'Синій.'],
              ['青い。', 'あおい。', 'Синій.']
            ]
          }
        }
      )
    end
    assert_match(/Focus '青' absent/, err2.message)
  end

  def test_cli_scripts_end_to_end_and_error_handling
    _out, err, status = Open3.capture3(RbConfig.ruby, SELECT_SCRIPT)
    refute status.success?
    assert_match(/Provide --output PATH/, err)

    _out2, err2, status2 = Open3.capture3(RbConfig.ruby, RENDER_SCRIPT)
    refute status2.success?
    assert_match(/Provide --sources, --batch, and --payload/, err2)

    Dir.mktmpdir do |dir|
      entries_dir, jmdict_db, warodai_db = build_fixture_dbs(dir)
      jmdict_db.close
      warodai_db.close

      tsv_path = File.join(dir, 'bccwj.tsv')
      File.write(tsv_path, "rank\tlForm\tlemma\tpos\n10\tコバルト\tコバルト\t名詞-普通名詞-一般\n", encoding: 'UTF-8')

      sources_path = File.join(dir, 'sources.json')
      dossiers_dir = File.join(dir, 'dossiers')
      stdout, stderr, st = Open3.capture3(
        RbConfig.ruby, SELECT_SCRIPT,
        '--bccwj', tsv_path,
        '--jmdict-cache', File.join(dir, 'jmdict.sqlite'),
        '--warodai-cache', File.join(dir, 'warodai.sqlite'),
        '--entries-dir', entries_dir,
        '--min-rank', '10',
        '--limit', '10',
        '--output', sources_path,
        '--dossier-dir', dossiers_dir
      )
      assert st.success?, stderr
      assert_match(/Selected 1 candidates/, stdout)
      assert File.exist?(File.join(dossiers_dir, 'dossier-01.txt'))

      # Rewrite candidate path into tmpdir so render_batch CLI writes safely in tmpdir.
      rows = JSON.parse(File.read(sources_path, encoding: 'UTF-8'))
      rendered_org = File.join(dir, 'rendered.org')
      rows.first['path'] = rendered_org
      File.write(sources_path, JSON.generate(rows), encoding: 'UTF-8')

      payload_path = File.join(dir, 'payload.json')
      File.write(
        payload_path,
        JSON.generate(
          '1' => {
            'focus' => 'コバルト',
            'senses' => [['кобальт', 'Хімічний елемент і синій пігмент.']],
            'examples' => [
              ['コバルトの色。', 'こばるとのいろ。', 'Колір кобальту.'],
              ['ガラスにコバルトを加える。', 'がらすにこばるとをくわえる。', 'До скла додають кобальт.'],
              ['陶磁器の絵付けには古くからコバルトが使われてきた。', 'とうじきのえつけにはふるくからこばるとがつかわれてきた。', 'У розписі кераміки кобальт використовують здавна.']
            ]
          }
        ),
        encoding: 'UTF-8'
      )

      out_r, err_r, st_r = Open3.capture3(
        RbConfig.ruby, RENDER_SCRIPT,
        '--sources', sources_path,
        '--batch', '1',
        '--payload', payload_path,
        '--sha256', 'deadbeef' * 8,
        '--date', '2026-11-15'
      )
      assert st_r.success?, err_r
      assert_includes out_r, "Rendered #{rendered_org}"
      assert File.exist?(rendered_org)
    end
  end

  private

  def build_fixture_dbs(dir)
    entries_dir = File.join(dir, 'entries')
    FileUtils.mkdir_p(File.join(entries_dir, '9999'))
    File.write(File.join(entries_dir, '9999', '9999999-kizon.org'), '')

    jmdict_db = SQLite3::Database.new(File.join(dir, 'jmdict.sqlite'))
    jmdict_db.execute('CREATE TABLE entries (id INTEGER PRIMARY KEY, written TEXT, reading TEXT, romaji TEXT, entry_json TEXT)')
    jmdict_db.execute('CREATE TABLE keb_reb (written TEXT, reading TEXT, id INTEGER)')
    jmdict_db.execute('CREATE TABLE reb (reading TEXT, id INTEGER)')

    warodai_db = SQLite3::Database.new(File.join(dir, 'warodai.sqlite'))
    warodai_db.execute('CREATE TABLE cards (card_id TEXT PRIMARY KEY, written_raw TEXT, kana_raw TEXT, body TEXT)')
    warodai_db.execute('CREATE TABLE forms (written TEXT, reading TEXT, card_id TEXT)')
    warodai_db.execute('CREATE TABLE kana_index (reading TEXT, card_id TEXT)')

    cobalt_entry = {
      'written_forms' => [],
      'readings' => [{ 'text' => 'コバルト', 'no_kanji' => true, 'applies_to_written_forms' => [], 'information' => [], 'priorities' => [] }],
      'senses' => [
        {
          'index' => 1, 'source_fingerprint' => 'fp-cobalt-1',
          'applies_to_written_forms' => [], 'applies_to_readings' => [],
          'parts_of_speech' => ['noun (common) (futsuumeishi)'],
          'fields' => [], 'miscellaneous' => [], 'dialects' => [], 'information' => [],
          'cross_references' => [], 'antonyms' => [], 'language_sources' => [],
          'glosses' => [{ 'lang' => 'eng', 'type' => 'plain', 'gender' => 'none', 'primary' => false, 'text' => 'cobalt' }]
        }
      ]
    }
    aoi_entry = sample_jmdict_entry.merge('written_forms' => [{ 'text' => '青い', 'information' => [], 'priorities' => [] },
                                                              { 'text' => '蒼い', 'information' => [], 'priorities' => [] }],
                                          'readings' => [{ 'text' => 'あおい', 'no_kanji' => false, 'applies_to_written_forms' => [], 'information' => [], 'priorities' => [] }])

    seed = [
      [1050560, 'コバルト', 'こばると', 'kobaruto', cobalt_entry, '004-01-01', nil],
      [9999999, '既存', 'きぞん', 'kizon', cobalt_entry, '004-01-02', '既存'],
      [8888888, 'ワロナシ', 'わろなし', 'waronashi', cobalt_entry, nil, nil],
      [1000010, '青い', 'あおい', 'aoi', aoi_entry, '001-01-01', '蒼い']
    ]
    seed.each do |id, w, r, rom, ent, card_id, form_w|
      jmdict_db.execute('INSERT INTO entries VALUES (?, ?, ?, ?, ?)', [id, w, r, rom, JSON.generate(ent)])
      jmdict_db.execute('INSERT INTO keb_reb VALUES (?, ?, ?)', [w, r, id])
      jmdict_db.execute('INSERT INTO reb VALUES (?, ?)', [w, id])
      next unless card_id

      warodai_db.execute('INSERT INTO cards VALUES (?, ?, ?, ?)', [card_id, form_w, r, 'тест'])
      if form_w
        warodai_db.execute('INSERT INTO forms VALUES (?, ?, ?)', [form_w, r, card_id])
      else
        warodai_db.execute('INSERT INTO kana_index VALUES (?, ?)', [r, card_id])
      end
    end

    [entries_dir, jmdict_db, warodai_db]
  end

  def sample_jmdict_entry
    {
      'written_forms' => [{ 'text' => '青', 'information' => [], 'priorities' => [] }],
      'readings' => [{ 'text' => 'あお', 'no_kanji' => false, 'applies_to_written_forms' => [], 'information' => [], 'priorities' => [] }],
      'senses' => [
        {
          'index' => 1, 'source_fingerprint' => 'fp-1',
          'applies_to_written_forms' => [], 'applies_to_readings' => [],
          'parts_of_speech' => ['noun (common) (futsuumeishi)'],
          'fields' => [], 'miscellaneous' => [], 'dialects' => [], 'information' => [],
          'cross_references' => [], 'antonyms' => [], 'language_sources' => [],
          'glosses' => [{ 'lang' => 'eng', 'type' => 'plain', 'gender' => 'none', 'primary' => false, 'text' => 'blue' }]
        },
        {
          'index' => 2, 'source_fingerprint' => 'fp-2',
          'applies_to_written_forms' => [], 'applies_to_readings' => [],
          'parts_of_speech' => ['noun (common) (futsuumeishi)'],
          'fields' => [], 'miscellaneous' => [], 'dialects' => [], 'information' => [],
          'cross_references' => [], 'antonyms' => [], 'language_sources' => [],
          'glosses' => [{ 'lang' => 'eng', 'type' => 'plain', 'gender' => 'none', 'primary' => false, 'text' => 'green light' }]
        }
      ]
    }
  end
end
