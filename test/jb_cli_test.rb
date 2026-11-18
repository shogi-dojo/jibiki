# frozen_string_literal: true

require 'minitest/autorun'
require 'open3'
require 'rake'
require 'rbconfig'
require_relative '../lib/dictionary_sources/jmdict_index'
load File.expand_path('../rakelib/jb.rake', __dir__)

# Runs tools/jb's print-and-diff tests under CRuby so `rake test` covers the
# CLI. (`spin test` in tools/jb runs the same files compiled, diffing each
# against CRuby.) They read the real JMdict index, so they need
# `rake jmdict:index` to have been run.
class JbCliTest < Minitest::Test
  ROOT = File.expand_path('..', __dir__)
  ARCHIVE = ENV.fetch('JMDICT_PATH', File.join(ROOT, 'sources', 'jmdict', 'JMdict.xml.gz'))

  def test_jb_checks_pass_under_cruby
    skip 'no JMdict index: run `rake jmdict:index`' unless DictionarySources::JmdictIndex.open(ARCHIVE)

    stdout, stderr, status = Open3.capture3(RbConfig.ruby, '-w', File.join(ROOT, 'tools/jb/bin/test.rb'))

    assert status.success?, "#{stdout.lines.grep(/^FAIL/).join}#{stderr}"
    assert_empty stderr
  end

  def test_compiled_sources_tracks_transitive_jb_requires_only
    sources = JbTasks.compiled_sources

    assert_includes sources, File.join(ROOT, 'tools/jb/bin/jb.rb')
    assert_includes sources, File.join(ROOT, 'lib/entry_validator.rb')
    assert_includes sources, File.join(ROOT, 'lib/entry_doctor.rb')
    assert_includes sources, File.join(ROOT, 'lib/org_lint.rb')
    refute_includes sources, File.join(ROOT, 'lib/bccwj_batch.rb')
    refute_includes sources, File.join(ROOT, 'lib/kanji.rb')
  end
end
