# frozen_string_literal: true

require 'json'
require 'minitest/autorun'
require 'open3'
require 'rbconfig'
require 'tmpdir'
require_relative '../lib/exporters/static_html'
require_relative '../lib/org_entry'

class StaticHtmlExporterTest < Minitest::Test
  CARD = {
    card_id: '009-61-79',
    header: 'ぼうえき【貿易】(бо:эки)〔009-61-79〕',
    kana_forms: ['ぼうえき'],
    written_forms: ['貿易'],
    polivanov: 'бо:эки',
    corpus_codes: ['экон.'],
    body_lines: ['<i>внешняя</i> торговля; <a href="#001-00-01">ссылка</a>.']
  }.freeze

  class FakeWarodai
    attr_reader :queries

    def lookup_many(queries)
      @queries = queries
      queries.map { |query| query[:reading] == 'ぼうえき' ? [CARD] : [] }
    end
  end

  def sample_entry
    OrgEntry.parse(<<~ORG)
      #+TITLE: 貿易
      #+JMDICT_ID: 1520120
      #+SCHEMA_VERSION: 2
      #+PRIMARY_READING: ぼうえき
      #+ROMAJI: boueki
      #+ENTRY_STATUS: draft
      #+QUALITY_PROFILE: learner
      #+JMDICT_SOURCE_SHA256: 62f5fd402cfbff619e592e11b16276fa8cdb7c7524126194e9000af6019dfcf5
      #+CREATED_AT: 2026-08-18
      #+DEFAULT_AUTHOR_ID: tester
      #+DEFAULT_LICENSE: CC-BY-SA-4.0
      #+DEFAULT_SOURCE_TYPE: original
      #+DEFAULT_STATUS: draft

      * Forms
      ** Written form wf-1520120-001
      :PROPERTIES:
      :TEXT: 貿易
      :END:
      ** Written form wf-1520120-002
      :PROPERTIES:
      :TEXT: 交易
      :END:
      ** Reading rd-1520120-001
      :PROPERTIES:
      :TEXT: ぼうえき
      :NO_KANJI: false
      :END:
      *** Applies to written forms
      - *
      * Sense s-1520120-001
      :PROPERTIES:
      :SOURCE_SENSE_INDEX: 1
      :SOURCE_FINGERPRINT: aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
      :LEARNER_PRIORITY: primary
      :END:
      ** JMdict metadata
      *** Parts of speech
      - n
      ** English glosses
      - foreign trade
      ** Ukrainian glosses
      *** uk-s-1520120-001-001
      :PROPERTIES:
      :END:
      - text :: зовнішня торгівля </script><script>alert(1)</script>
      ** Examples
      *** ex-1520120-001-001
      :PROPERTIES:
      :LEVEL: beginner
      :REGISTER: neutral
      :END:
      - JA :: 日本は貿易が盛んです。
      - READING :: にほんはぼうえきがさかんです。
      - UK :: Японія веде активну зовнішню торгівлю.
      - EN :: Japan is active in foreign trade.
    ORG
  end

  def embedded_data(html)
    json = html[/<script id="dictionary-data" type="application\/json">(.*?)<\/script>/m, 1]
    JSON.parse(json, symbolize_names: true)
  end

  def test_exports_safe_self_contained_search_page_with_deduplicated_cards
    Dir.mktmpdir do |directory|
      output = File.join(directory, 'dictionary.html')
      warodai = FakeWarodai.new

      Exporters::StaticHtml.export([sample_entry], output, warodai:)

      html = File.read(output, encoding: Encoding::UTF_8)
      data = embedded_data(html)
      entry = data.first

      assert_includes html, 'Private local QA only.'
      assert_includes html, "languageSection('uk', 'Ukrainian authored content', true"
      assert_includes html, "languageSection('ru', 'Warodai · Russian reference', false"
      assert_includes html, "languageSection('en', 'JMdict · English', false"
      assert_includes html, 'Search all languages'
      assert_includes html, '\\u003c/script\\u003e'
      refute_includes html, '</script><script>alert(1)</script>'
      refute_match(/<(?:script|link)[^>]+(?:src|href)=["']https?:/i, html)

      assert_equal 1520120, entry[:id]
      assert_equal 1, entry[:warodai].length
      assert_equal '009-61-79', entry[:warodai].first[:card_id]
      assert_includes entry[:search_text], 'зовнішня торгівля'
      assert_includes entry[:search_text], 'foreign trade'
      assert_equal '</script><script>alert(1)</script>', entry[:senses].first[:ukrainian_glosses].first[:text].delete_prefix('зовнішня торгівля ')
      assert_equal [
        { written: '貿易', reading: 'ぼうえき' },
        { written: '交易', reading: 'ぼうえき' }
      ], warodai.queries
    end
  end

  def test_failure_does_not_replace_existing_output
    Dir.mktmpdir do |directory|
      output = File.join(directory, 'dictionary.html')
      File.write(output, 'previous', encoding: Encoding::UTF_8)

      error = assert_raises(ArgumentError) do
        Exporters::StaticHtml.export([sample_entry, sample_entry], output, warodai: FakeWarodai.new)
      end

      assert_includes error.message, 'duplicate JMdict IDs'
      assert_equal 'previous', File.read(output, encoding: Encoding::UTF_8)
    end
  end

  def test_rejects_an_empty_entry_set
    error = assert_raises(ArgumentError) do
      Exporters::StaticHtml.export([], '/unused/dictionary.html', warodai: FakeWarodai.new)
    end

    assert_equal 'no dictionary entries provided', error.message
  end

  def test_cli_fails_clearly_when_warodai_source_is_missing
    Dir.mktmpdir do |directory|
      missing = File.join(directory, 'missing-warodai')
      script = File.expand_path('../scripts/export_static_html.rb', __dir__)
      _stdout, stderr, status = Open3.capture3(
        RbConfig.ruby, script, '--warodai', missing, '--output', File.join(directory, 'dictionary.html')
      )

      refute status.success?
      assert_includes stderr, "Missing local Warodai source: #{missing}"
      refute File.exist?(File.join(directory, 'dictionary.html'))
    end
  end
end
