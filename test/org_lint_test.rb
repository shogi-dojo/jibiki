# frozen_string_literal: true

require 'minitest/autorun'
require 'open3'
require 'tmpdir'
require_relative '../lib/org_lint'

# OrgLint restates the org-lint checkers that can fire on an entry. Each
# mutant below breaks a real entry the way an author might; Emacs and OrgLint
# must report the same checker on the same line for every one of them.
class OrgLintTest < Minitest::Test
  ROOT = File.expand_path('..', __dir__)
  BASE = File.read(File.join(ROOT, 'entries/1381/1381380-ao.org'), encoding: 'UTF-8').split("\n")
  PROPS = BASE.index(':PROPERTIES:')
  PROPS_END = BASE.index(':END:')
  HEADING = BASE.index { |line| line.start_with?('* ') }

  MUTANTS = {
    'missing_end' => ->(l) { l.delete_at(PROPS_END) },
    'blank_before_drawer' => ->(l) { l.insert(PROPS, '') },
    'prop_no_colon' => ->(l) { l[PROPS + 1] = l[PROPS + 1].delete_prefix(':') },
    'spurious_colons' => ->(l) { l[HEADING] += ' :tag::bad:' },
    'keyword_no_colon' => ->(l) { l[0] = l[0].sub('#+TITLE: ', '#+TITLE') },
    'heading_in_drawer' => ->(l) { l.insert(PROPS + 1, '* inside drawer') },
    'trailing_bracket' => ->(l) { l << '- note :: see [[https://example.com][ex]]]' },
    'bad_priority' => ->(l) { l[HEADING] = l[HEADING].sub('* ', '* [#Z1] ') },
    'empty_prop_key' => ->(l) { l.insert(PROPS + 1, ':: empty') },
    'unclosed_block' => ->(l) { l << '#+BEGIN_SRC' },
    'item_number' => ->(l) { l.push('1. one', '3. three') },
    'special_prop' => ->(l) { l.insert(PROPS + 1, ':TODO: x') },
    'effort' => ->(l) { l.insert(PROPS + 1, ':EFFORT: abc') },
    'local_file' => ->(l) { l << '- see [[file:nope.org]]' },
    'bad_timestamp' => ->(l) { l << '- x :: <2026-13-45 Mon>' },
    'dangling_drawer' => ->(l) { l << ':LOGBOOK:' },
    'orphan_affiliated' => ->(l) { l << '#+CAPTION: orphan' },
    'custom_id_link' => ->(l) { l << '[[#nowhere]]' },
    'fuzzy_link' => ->(l) { l << '[[nowhere]]' },
    'footnote_ref' => ->(l) { l << '- x :: a  [fn:1] note' },
    'nested_drawer_start' => ->(l) { l.insert(PROPS + 1, ':PROPERTIES:') },
    'lowercase_end' => ->(l) { l[PROPS_END] = ':end:' },
    'prop_space_key' => ->(l) { l.insert(PROPS_END, ':BAD KEY: x') },
    'non_prop_line' => ->(l) { l.insert(PROPS_END, 'not a property') },
    'dup_property' => ->(l) { l.insert(PROPS + 1, l[PROPS + 1]) },
    'url_link' => ->(l) { l << '- see [[https://example.com][an example]].' },
    'nested_list' => ->(l) { l.push('- list ::', '  1. first', '  2. second', '- next :: x') }
  }.freeze

  def with_mutants
    Dir.mktmpdir do |directory|
      paths = MUTANTS.map do |name, mutate|
        lines = BASE.dup
        mutate.call(lines)
        path = File.join(directory, "#{name}.org")
        File.write(path, lines.join("\n"))
        path
      end
      yield paths
    end
  end

  def native(paths)
    paths.flat_map do |path|
      OrgLint.lint_file(path).map { |finding| [File.basename(path, '.org'), finding.line, finding.checker] }
    end.sort
  end

  def test_matches_emacs_org_lint_on_every_mutant
    skip 'emacs is not installed' unless system('command -v emacs >/dev/null 2>&1')

    with_mutants do |paths|
      elisp = <<~ELISP
        (progn (require 'org) (require 'org-lint)
          (dolist (path command-line-args-left)
            (with-current-buffer (find-file-noselect path)
              (dolist (r (org-lint))
                (let ((v (cadr r)))
                  (princ (format "%s\\t%s\\t%s\\n" (file-name-base path) (aref v 0)
                                 (org-lint-checker-name (aref v 3)))))))))
      ELISP
      stdout, stderr, status = Open3.capture3('emacs', '--batch', '--eval', elisp, *paths)
      assert status.success?, stderr
      emacs = stdout.lines.map do |line|
        name, n, checker = line.chomp.split("\t")
        [name, n.to_i, checker]
      end.sort

      assert_equal emacs, native(paths)
    end
  end

  def test_expected_findings_without_emacs
    with_mutants do |paths|
      found = native(paths).group_by(&:first).transform_values { |rows| rows.map(&:last) }

      assert_equal %w[incomplete-drawer], found['missing_end']
      assert_equal %w[obsolete-properties-drawer], found['blank_before_drawer']
      assert_equal %w[item-number item-number], found['item_number']
      assert_equal %w[invalid-keyword-syntax], found['keyword_no_colon']
      assert_nil found['nested_list']
      assert_nil found['url_link']
      assert_nil found['dup_property']
    end
  end

  def test_corpus_entry_is_clean
    assert_empty OrgLint.lint_file(File.join(ROOT, 'entries/1381/1381380-ao.org'))
  end
end
