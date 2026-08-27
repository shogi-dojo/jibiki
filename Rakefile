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
    written = args.fetch(:written)
    reading = args[:reading] || written
    sh RUBY, 'scripts/extract_word.rb', '--written', written, '--reading', reading
  end

  desc 'Create an ignored source dossier from one N5 row: rake "sources:n5[2]"'
  task :n5, [:source_order] do |_task, args|
    abort 'Provide an N5 source_order.' unless args[:source_order]

    sh RUBY, 'scripts/extract_word.rb', '--level', 'n5', '--source-order', args[:source_order]
  end

  desc 'Create dossiers for a range of N5 rows in one pass: rake "sources:n5_batch[103,125]"'
  task :n5_batch, %i[from to] do |_task, args|
    abort 'Provide from and to N5 source_orders.' unless args[:from] && args[:to]

    sh RUBY, 'scripts/extract_n5_batch.rb', '--from', args[:from], '--to', args[:to]
  end

  desc 'Create an ignored source dossier from one N4 row: rake "sources:n4[2]"'
  task :n4, [:source_order] do |_task, args|
    abort 'Provide an N4 source_order.' unless args[:source_order]

    sh RUBY, 'scripts/extract_word.rb', '--level', 'n4', '--source-order', args[:source_order]
  end

  desc 'Create dossiers for a range of N4 rows in one pass: rake "sources:n4_batch[1,20]"'
  task :n4_batch, %i[from to] do |_task, args|
    abort 'Provide from and to N4 source_orders.' unless args[:from] && args[:to]

    sh RUBY, 'scripts/extract_n4_batch.rb', '--from', args[:from], '--to', args[:to]
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

  desc 'Scaffold a complete v2 entry from an N5/N4 queue row: rake "entries:scaffold[299,juu,n5]"'
  task :scaffold, %i[source_order romaji level] do |_task, args|
    abort 'Provide source_order and romaji.' unless args[:source_order] && args[:romaji]
    args.with_defaults(level: 'n5')
    abort 'Level must be n5 or n4.' unless %w[n5 n4].include?(args[:level])

    sh RUBY, 'scripts/scaffold_entry.rb', '--level', args[:level], '--source-order', args[:source_order], '--romaji', args[:romaji]
  end
end

namespace :fingerprints do
  desc 'Re-derive sense fingerprints from the JMdict archive on disk: rake "fingerprints:refresh[entries/1381/1381380-ao.org]"'
  task :refresh, [:path] do |_task, args|
    command = [RUBY, 'scripts/refresh_fingerprints.rb']
    command << args[:path] if args[:path]
    sh(*command)
  end

  desc 'Report fingerprint drift against the JMdict archive without writing'
  task :check do
    sh RUBY, 'scripts/refresh_fingerprints.rb', '--check'
  end
end

namespace :org do
  desc 'Run Emacs org-lint on every tracked dictionary Org file'
  task :lint do
    lint_org_files(Dir['entries/*/*.org'].sort)
  end
end

namespace :export do
  desc 'Export a private static HTML comparison dictionary: rake "export:html[build/dictionary.html]"'
  task :html, [:output] do |_task, args|
    args.with_defaults(output: 'build/dictionary.html')
    sh RUBY, 'scripts/export_static_html.rb', '--output', args[:output]
  end

  desc 'Export the rich learner SQLite database: rake "export:rich[build/jibiki.sqlite,base_db_path]"'
  task :rich, %i[output base] do |_task, args|
    args.with_defaults(output: 'build/jibiki.sqlite')
    command = [RUBY, 'scripts/export_rich_db.rb', '--output', args[:output]]
    command += ['--base', args[:base]] if args[:base]
    sh(*command)
  end

  desc 'Export the Houhou overlay DB: rake "export:overlay[base_db_path,output,base_overlay_path]"'
  task :overlay, %i[base output base_overlay] do |_task, args|
    abort 'Provide base KanjiDatabase.sqlite path as first argument.' unless args[:base]
    args.with_defaults(output: 'build/DictionaryTranslations.sqlite')
    command = [RUBY, 'scripts/export_houhou_overlay.rb',
               '--base', args[:base],
               '--output', args[:output]]
    command += ['--base-overlay', args[:base_overlay]] if args[:base_overlay]
    sh(*command)
  end

  desc 'Export both rich DB and overlay: rake "export:all[base_db_path]"'
  task :all, %i[base base_overlay] do |_task, args|
    abort 'Provide base KanjiDatabase.sqlite path as first argument.' unless args[:base]
    Rake::Task['export:rich'].invoke(nil, args[:base])
    Rake::Task['export:overlay'].invoke(args[:base], nil, args[:base_overlay])
  end
end

desc 'Score corpus health and check for editorial defects across all entries'
task :doctor do
  sh RUBY, 'scripts/doctor.rb'
end

namespace :doctor do
  desc 'Score health and show verbose findings for one entry: rake "doctor:entry[entries/1464/1464530-nihongo.org]"'
  task :entry, [:path] do |_task, args|
    abort 'Provide an entry path: rake "doctor:entry[entries/1464/1464530-nihongo.org]"' unless args[:path]
    sh RUBY, 'scripts/doctor.rb', args[:path]
  end

  desc 'Generate HTML doctor report: rake "doctor:report[build/doctor_report.html]"'
  task :report, [:output] do |_task, args|
    args.with_defaults(output: 'build/doctor_report.html')
    sh(RUBY, 'scripts/doctor.rb', '--report', args[:output]) { |_ok, _res| true }
  end
end

Rake::TestTask.new(:test) do |task|
  task.libs << 'test'
  task.pattern = 'test/**/*_test.rb'
end

desc 'Test extractors, validate entries, and Org-lint dictionary files'
task default: [:test, 'entries:validate', 'org:lint', :doctor]
