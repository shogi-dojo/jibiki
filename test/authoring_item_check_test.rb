# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/bccwj_batch'
require_relative '../lib/authoring/item_check'
require_relative '../lib/authoring/reply_parser'
require_relative 'support/authoring_rows'

class AuthoringItemCheckTest < Minitest::Test
  def setup
    @row = AuthoringRows.ao
    @renderer = BccwjBatch::Renderer.new(sources: [@row], sha256: EntryValidator::KNOWN_JMDICT_SHA256S.first,
                                         created_at: '2026-11-28')
  end

  def good_data
    data = Authoring::ReplyParser.parse(AuthoringRows.ao_reply, { '1' => @row }).payload.fetch('1')
    readings = %w[あおになりました。 しんごうがあおにかわったのでわたった。 あおいろのひょうしきがめじるしとしてせっちされている。]
    data['examples'].each_with_index { |ex, i| ex[1] = readings[i] }
    data
  end

  def test_passing_item_has_no_failures
    assert_equal({}, Authoring::ItemCheck.run(@renderer, { '1' => [@row, good_data] }))
  end

  def test_failures_are_reported_per_item
    long_note = good_data.tap { |d| d['senses'][0][1] = 'д' * 250 }
    bad_reading = good_data.tap { |d| d['examples'][1][1] = 'しんごうがきいろになった。' }
    wrong_focus = good_data.tap { |d| d['examples'][0][3] = '赤' }

    failures = Authoring::ItemCheck.run(@renderer, {
                                          '1' => [@row, good_data], '2' => [@row, long_note], '3' => [@row, bad_reading],
                                          '4' => [@row, wrong_focus]
                                        })

    assert_equal %w[2 3 4], failures.keys
    assert_includes failures['2'], 'G1 note is 250 characters (max 200)'
    assert(failures['3'].any? { |m| m.include?('reading') || m.include?('READING') }, failures['3'].inspect)
    assert(failures['4'].any? { |m| m.include?("Focus '赤' absent") }, failures['4'].inspect)
  end

  def test_yanagi_findings_fail_the_item
    finding = Yanagi::Audit::Finding.new(token: 'Сіндзюку', canonical: 'Шінджюку', tier: 1, approved: true)
    scanner = Object.new
    scanner.define_singleton_method(:scan_text) { |_text, tier2:| tier2 ? [] : [finding] }
    failures = Authoring::ItemCheck.run(@renderer, { '1' => [@row, good_data] }, scanner:)

    assert_equal({ '1' => ["Polivanov spelling 'Сіндзюку' (use 'Шінджюку')"] }, failures)
  end
end
