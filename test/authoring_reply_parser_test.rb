# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/authoring/reply_parser'
require_relative 'support/authoring_rows'

class AuthoringReplyParserTest < Minitest::Test
  def parse(text, rows = { '1' => AuthoringRows.ao })
    Authoring::ReplyParser.parse(text, rows)
  end

  def test_valid_reply_maps_to_renderer_payload
    result = parse("```\n#{AuthoringRows.ao_reply}```\n")

    assert_empty result.errors
    data = result.payload.fetch('1')
    assert_equal '青', data['focus']
    assert_equal 2, data['primary_sense']
    assert_equal ['зелене світло світлофора', 'Розмовна назва дозвільного сигналу, хоча сам колір зелений.'], data['senses'][1]
    assert_equal ['青になりました。', nil, 'Загорілося зелене.'], data['examples'][0]
    assert_equal ['信号が青に変わったので渡った。', nil, 'Світлофор перемкнувся на зелений, і я перейшов дорогу.'], data['examples'][1]
    assert_equal '青色', data['examples'][2][3]
  end

  def test_readings_are_taken_when_present
    reply = AuthoringRows.ao_reply.sub('|Загорілося зелене.|', '|Загорілося зелене.||あおになりました。')

    assert_equal 'あおになりました。', parse(reply).payload['1']['examples'][0][1]
  end

  def test_missing_readings_fail_the_item_when_readings_are_requested
    reply = AuthoringRows.ao_reply.sub('|Загорілося зелене.|', '|Загорілося зелене.||あおになりました。')
    result = Authoring::ReplyParser.parse(reply, { '1' => AuthoringRows.ao }, readings: true)

    assert_empty result.payload
    assert_equal ['every E line needs its reading as the last field'], result.errors['1']
  end

  def test_problems_are_reported_per_item_and_good_items_survive
    rows = { '1' => AuthoringRows.ao, '2' => AuthoringRows.ao, '3' => AuthoringRows.ao }
    bad = AuthoringRows.ao_reply(2).sub(/^G2\|.*\n/, '').sub(/^E\|信号.*\n/, '')
    result = parse(AuthoringRows.ao_reply(1) + bad, rows)

    assert_equal ['1'], result.payload.keys
    assert_equal ['expected G1..G2, got G1', 'expected 3 examples, got 2'], result.errors['2']
    assert_equal ['missing from reply'], result.errors['3']
  end

  def test_structural_mistakes
    reply = AuthoringRows.ao_reply.sub('p=2', 'p=5').sub('G2|зелене світло світлофора|', 'G2|зелене||') + "ну ось\n"
    errors = parse(reply).errors['1']

    assert_includes errors, 'p=5 is not a sense number'
    assert(errors.any? { |e| e.start_with?('malformed gloss line: G2|зелене||') })
    assert_includes errors, 'unexpected line: ну ось'
  end

  def test_empty_note_and_duplicate_item
    reply = AuthoringRows.ao_reply.sub(/\|Базова назва.*$/, '|') * 2
    errors = parse(reply).errors['1']

    assert_includes errors, 'duplicated in reply'
    assert_includes errors, 'G1 has an empty gloss or note'
  end
end
