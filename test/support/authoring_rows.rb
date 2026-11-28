# frozen_string_literal: true

# Selection rows shaped like BccwjBatch::Selector output, for authoring tests.
module AuthoringRows
  module_function

  def sense(index, pos, *glosses)
    {
      'index' => index, 'source_fingerprint' => "fp-#{index}",
      'applies_to_written_forms' => [], 'applies_to_readings' => [],
      'parts_of_speech' => [pos], 'fields' => [], 'miscellaneous' => [], 'dialects' => [],
      'information' => [], 'cross_references' => [], 'antonyms' => [], 'language_sources' => [],
      'glosses' => glosses.map { |t| { 'lang' => 'eng', 'type' => 'plain', 'gender' => 'none', 'primary' => false, 'text' => t } }
    }
  end

  def ao(path: 'entries/1381/1381380-ao.org')
    {
      'source_order' => '42', 'written' => '青', 'reading' => 'あお', 'romaji' => 'ao',
      'jmdict_id' => '1381380', 'path' => path,
      'entry' => {
        'written_forms' => [{ 'text' => '青', 'information' => [], 'priorities' => [] }],
        'readings' => [{ 'text' => 'あお', 'no_kanji' => false, 'applies_to_written_forms' => [], 'information' => [], 'priorities' => [] }],
        'senses' => [sense(1, 'n', 'blue', 'azure'), sense(2, 'n', 'green light')]
      },
      'warodai_cards' => [{ 'card_id' => '005-14-12', 'body' => '<i>цв.</i> синий;   зелёный' }]
    }
  end

  def shiraburu
    {
      'source_order' => '43', 'written' => 'シラブル', 'reading' => 'シラブル', 'romaji' => 'shiraburu',
      'jmdict_id' => '1062900', 'path' => 'entries/1062/1062900-shiraburu.org',
      'entry' => {
        'written_forms' => [],
        'readings' => [{ 'text' => 'シラブル', 'no_kanji' => false, 'applies_to_written_forms' => [], 'information' => [], 'priorities' => [] }],
        'senses' => [sense(1, 'n', 'syllable')]
      },
      'warodai_cards' => []
    }
  end

  # A reply for ao() that passes every check.
  def ao_reply(number = 1)
    <<~REPLY
      @#{number} p=2
      G1|синій; блакитний|Базова назва кольору; у складних словах часто означає й зелений відтінок.
      G2|зелене світло світлофора|Розмовна назва дозвільного сигналу, хоча сам колір зелений.
      E|青になりました。|Загорілося зелене.|
      E|信号が青に変わったので渡った。|Світлофор перемкнувся на зелений, і я перейшов дорогу.
      E|青色の標識が目印として設置されている。|Синій вказівник встановлено як орієнтир.|青色
    REPLY
  end
end
