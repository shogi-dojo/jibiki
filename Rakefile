# frozen_string_literal: true

require 'rbconfig'
require 'rake'
require 'rake/testtask'

# Ruby derives its default external encoding from the locale; when LANG is
# unset or not UTF-8 (GUI-launched shells, CI), that default is US-ASCII and
# reading the UTF-8 dictionary data fails. Pin it here once so every child
# process (ruby scripts, emacs org-lint, the test task) inherits it and no
# caller has to export LANG manually.
ENV['LANG'] = 'en_US.UTF-8' unless ENV['LANG'].to_s.match?(/UTF-8/i)
Encoding.default_external = Encoding::UTF_8

RUBY = RbConfig.ruby
ORG_LINT_EXPRESSION = <<~ELISP.lines.join(' ')
  (progn
    (require 'org)
    (let ((failed nil))
      (dolist (path command-line-args-left)
        (with-current-buffer (find-file-noselect path)
          (let ((issues (org-lint)))
            (when issues
              (princ (format "%s\\n" path))
              (prin1 issues)
              (princ "\\n")
              (setq failed t)))))
      (kill-emacs (if failed 1 0))))
ELISP

def lint_org_files(paths)
  sh 'emacs', '--batch', '--eval', ORG_LINT_EXPRESSION, *paths
end

namespace :sources do
  desc 'Extract exact JMdict matches: rake "sources:jmdict[青,あお]"'
  task :jmdict, %i[written reading ent_seq] do |_task, args|
    command = [RUBY, 'scripts/extract_jmdict.rb']
    command += ['--written', args[:written]] if args[:written]
    command += ['--reading', args[:reading]] if args[:reading]
    command += ['--id', args[:ent_seq]] if args[:ent_seq]
    sh(*command)
  end

  desc 'Extract exact Warodai matches: rake "sources:warodai[青,あお]"'
  task :warodai, %i[written reading card_id] do |_task, args|
    command = [RUBY, 'scripts/extract_warodai.rb']
    command += ['--written', args[:written]] if args[:written]
    command += ['--reading', args[:reading]] if args[:reading]
    command += ['--id', args[:card_id]] if args[:card_id]
    sh(*command)
  end

  desc 'Create a combined JMdict/Warodai dossier: rake "sources:word[青,あお]"'
  task :word, %i[written reading] do |_task, args|
    sh RUBY, 'scripts/extract_word.rb', '--written', args.fetch(:written), '--reading', args.fetch(:reading)
  end

  desc 'Create an ignored source dossier from one N5 row: rake "sources:n5[2]"'
  task :n5, [:source_order] do |_task, args|
    abort 'Provide an N5 source_order.' unless args[:source_order]

    sh RUBY, 'scripts/extract_word.rb', '--source-order', args[:source_order]
  end

  desc 'Create dossiers for a range of N5 rows in one pass: rake "sources:n5_batch[103,125]"'
  task :n5_batch, %i[from to] do |_task, args|
    abort 'Provide from and to N5 source_orders.' unless args[:from] && args[:to]

    sh RUBY, 'scripts/extract_n5_batch.rb', '--from', args[:from], '--to', args[:to]
  end
end

namespace :entries do
  desc 'Validate one entry path, or all entries when PATH is omitted'
  task :validate, [:path] do |_task, args|
    paths = args[:path] ? [args[:path]] : Dir['entries/*/*.org'].sort
    sh RUBY, 'scripts/validate_entry.rb', *paths
  end

  desc 'Run Emacs org-lint on one entry path, or all entries when PATH is omitted'
  task :lint, [:path] do |_task, args|
    paths = args[:path] ? [args[:path]] : Dir['entries/*/*.org'].sort
    lint_org_files(paths)
  end

  desc 'Migrate one entry path, or all entries when PATH is omitted, from schema v1 to v2'
  task :migrate_v2, [:path] do |_task, args|
    paths = args[:path] ? [args[:path]] : Dir['entries/*/*.org'].sort
    sh RUBY, 'scripts/migrate_schema_v2.rb', *paths
  end

  desc 'Scaffold a complete v2 entry from one N5 queue row: rake "entries:scaffold[299,juu]"'
  task :scaffold, %i[source_order romaji] do |_task, args|
    abort 'Provide source_order and romaji.' unless args[:source_order] && args[:romaji]

    sh RUBY, 'scripts/scaffold_entry.rb', '--source-order', args[:source_order], '--romaji', args[:romaji]
  end
end

namespace :org do
  desc 'Run Emacs org-lint on every tracked dictionary Org file'
  task :lint do
    lint_org_files(Dir['entries/*/*.org'].sort)
  end
end

Rake::TestTask.new(:test) do |task|
  task.libs << 'test'
  task.pattern = 'test/**/*_test.rb'
end

desc 'Test extractors, validate entries, and Org-lint dictionary files'
task default: [:test, 'entries:validate', 'org:lint']
