# frozen_string_literal: true

require 'fileutils'
require 'minitest/autorun'
require 'tmpdir'
require_relative '../lib/authoring/set_names'

class AuthoringSetNamesTest < Minitest::Test
  def test_ordinals_match_progress_headings
    {
      1 => 'First', 12 => 'Twelfth', 20 => 'Twentieth', 43 => 'Forty-third', 100 => 'One Hundredth',
      113 => 'One Hundred Thirteenth', 163 => 'One Hundred Sixty-third', 184 => 'One Hundred Eighty-fourth',
      190 => 'One Hundred Ninetieth', 201 => 'Two Hundred First', 205 => 'Two Hundred Fifth'
    }.each { |n, name| assert_equal name, Authoring::SetNames.ordinal(n), n }
  end

  def test_last_bccwj_rank_reads_the_ledgers
    Dir.mktmpdir do |root|
      FileUtils.mkdir_p(File.join(root, 'docs'))
      header = "batch\tsource\tsource_order\twritten\n"
      File.write(File.join(root, 'docs/n10k-next100-2026-11-27a.tsv'), "#{header}1\tBCCWJ Top Frequent\t81734\t上訴\n")
      File.write(File.join(root, 'docs/n10k-next100-2026-11-28a.tsv'),
                 "#{header}1\tBCCWJ Top Frequent\t86332\t桎梏\n2\tN1 list\t99999\t他\n")
      File.write(File.join(root, 'docs/n10k-next100-2026-10-01a.tsv'), "id\tword\n1\t古い\n")

      assert_equal 86_332, Authoring::SetNames.last_bccwj_rank(root)
    end
  end

  def test_ledgers_skip_letters_taken_that_day
    Dir.mktmpdir do |root|
      FileUtils.mkdir_p(File.join(root, 'docs'))
      %w[2026-11-28a 2026-11-28b 2026-11-27a].each { |s| FileUtils.touch(File.join(root, "docs/n10k-next100-#{s}.tsv")) }

      assert_equal 4, Authoring::SetNames.next_set_number(root)
      assert_equal %w[docs/n10k-next100-2026-11-28c.tsv docs/n10k-next100-2026-11-28d.tsv],
                   Authoring::SetNames.ledger_paths('2026-11-28', 2, root)
    end
  end
end
