# frozen_string_literal: true

require 'rbconfig'
require 'rake'
require 'rake/testtask'

RUBY = RbConfig.ruby
ORG_LINT_EXPRESSION = <<~ELISP.lines.join(' ')
  (progn
    (require 'org)
    (let ((issues (org-lint)))
      (when issues
        (prin1 issues)
        (kill-emacs 1))))
ELISP

def lint_org_files(paths)
  paths.each { |path| sh 'emacs', '--batch', path, '--eval', ORG_LINT_EXPRESSION }
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
end

namespace :entries do
  desc 'Validate one entry path, or all entries when PATH is omitted'
  task :validate, [:path] do |_task, args|
    paths = args[:path] ? [args[:path]] : Dir['entries/*/*.org'].sort
    paths.each { |path| sh RUBY, 'scripts/validate_entry.rb', path }
  end

  desc 'Run Emacs org-lint on one entry path, or all entries when PATH is omitted'
  task :lint, [:path] do |_task, args|
    paths = args[:path] ? [args[:path]] : Dir['entries/*/*.org'].sort
    lint_org_files(paths)
  end
end

namespace :org do
  desc 'Run Emacs org-lint on every tracked dictionary Org file'
  task :lint do
    lint_org_files((Dir['entries/*/*.org'] + Dir['assets/**/*.org']).sort)
  end
end

Rake::TestTask.new(:test) do |task|
  task.libs << 'test'
  task.pattern = 'test/**/*_test.rb'
end

desc 'Test extractors, validate entries, and Org-lint dictionary files'
task default: [:test, 'entries:validate', 'org:lint']
