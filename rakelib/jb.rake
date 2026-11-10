# frozen_string_literal: true

require 'json'
require 'open3'
require 'rbconfig'

# How rake runs the `jb` CLI (tools/jb): the native Spinel binary when it is
# built and current, otherwise the same sources under CRuby. Corpus-wide runs
# go through jb in batches of JB_BATCH paths (default 1000), one process each,
# so peak memory stays around 30 MB however large the corpus grows.
module JbTasks
  module_function

  ROOT = File.expand_path('..', __dir__)
  NATIVE = File.join(ROOT, 'tools', 'jb', 'build', 'bin', 'jb')
  SOURCE = File.join(ROOT, 'tools', 'jb', 'bin', 'jb.rb')

  def batch_size
    size = ENV.fetch('JB_BATCH', '1000').to_i
    size.positive? ? size : 1000
  end

  # The command that runs jb. JB=/path/to/jb overrides the choice.
  def command
    return [ENV['JB']] if ENV['JB'] && !ENV['JB'].empty?
    return [NATIVE] if native_current?

    [RbConfig.ruby, SOURCE]
  end

  # `spin build` judges staleness by tools/jb alone, so a binary can predate
  # an edit to lib/. Only a binary newer than every source it compiles is used.
  def native_current?
    return false unless File.executable?(NATIVE)

    built = File.mtime(NATIVE)
    sources = Dir[File.join(ROOT, 'lib', '**', '*.rb')] + Dir[File.join(ROOT, 'tools', 'jb', '**', '*.rb')]
    stale = sources.find { |path| File.mtime(path) > built }
    warn "jb: #{NATIVE} is older than #{stale}; using CRuby (rake jb:build to refresh)" if stale
    stale.nil?
  end

  # Paths from a task's arguments (each may hold several, space-separated),
  # or every entry when none are given.
  def paths(args, default_all: true)
    given = args.to_a.compact.flat_map(&:split)
    return given unless given.empty?

    default_all ? Dir[File.join('entries', '*', '*.org')].sort : []
  end

  # Runs `jb <subcommand> <flags> <batch>` per batch, streaming each batch's
  # output. Stops on a usage or index error; otherwise fails at the end when
  # any batch found problems.
  def run_batched(subcommand, paths, flags = [])
    failed = false
    paths.each_slice(batch_size) do |batch|
      system(*command, subcommand, *flags, *batch)
      status = $?.exitstatus
      abort "jb #{subcommand} stopped (exit #{status})" unless [0, 2].include?(status)
      failed ||= status == 2
    end
    abort "jb #{subcommand}: problems found" if failed
  end

  # The corpus doctor: per-batch JSON merged into one summary.
  def doctor(paths)
    reports = []
    paths.each_slice(batch_size) do |batch|
      stdout, stderr, status = Open3.capture3(*command, 'doctor', '--json', *batch)
      abort "jb doctor stopped (exit #{status.exitstatus}): #{stderr}" unless [0, 2].include?(status.exitstatus)

      reports.concat(JSON.parse(stdout)['reports'])
    end
    print_doctor(reports)
  end

  def print_doctor(reports)
    findings = reports.flat_map { |r| r['findings'].map { |f| f.merge('report' => r) } }
    errors = findings.count { |f| f['severity'] == 'error' }
    failed = reports.reject { |r| r['passed'] }
    average = reports.empty? ? 0 : (reports.sum { |r| r['health_score'] }.to_f / reports.length).round(1)
    puts '=' * 56, '  JIBIKI ENTRY DOCTOR REPORT', '=' * 56
    puts "Analyzed entries: #{reports.length}"
    puts "Average health score: #{average}/100"
    puts "Passed: #{reports.length - failed.length} | Failed: #{failed.length}"
    puts "Total findings: #{errors} errors, #{findings.count { |f| f['severity'] == 'warn' }} warnings, " \
         "#{findings.count { |f| f['severity'] == 'info' }} infos"
    puts '-' * 56
    by_check = findings.group_by { |f| [f['check'], f['severity']] }
    unless by_check.empty?
      puts 'Findings by Check:'
      by_check.sort_by { |(_c, sev), items| [%w[error warn info].index(sev), -items.length] }.each do |(check, sev), items|
        puts format('  %-8s %s: %d occurrence(s)', "[#{sev.upcase}]", check, items.length)
      end
      puts '-' * 56
    end
    failed.first(10).each do |r|
      puts "  - #{File.basename(r['path'].to_s)} (score: #{r['health_score']})"
      r['findings'].select { |f| f['severity'] == 'error' }.first(3).each { |f| puts "      * #{f['check']}: #{f['detail']}" }
    end
    puts "  ... and #{failed.length - 10} more" if failed.length > 10
    abort "Result: FAILED (#{errors} errors found)" if errors.positive?
    puts 'Result: PASSED (0 errors found)'
  end
end

namespace :entries do
  desc 'Validate entries with jb (all when no paths): rake "entries:validate[entries/1381/1381380-ao.org]"'
  task :validate, [:paths] => 'jmdict:index' do |_task, args|
    JbTasks.run_batched('validate', JbTasks.paths([args[:paths], *args.extras]))
  end

  desc "Lint entries with jb's native org-lint checkers (all when no paths); org:lint runs Emacs"
  task :lint, [:paths] do |_task, args|
    JbTasks.run_batched('lint', JbTasks.paths([args[:paths], *args.extras]))
  end

  desc 'Per-batch gate: validate + doctor + lint in one jb process: rake "entries:check[a.org b.org]"'
  task :check, [:paths] => 'jmdict:index' do |_task, args|
    paths = JbTasks.paths([args[:paths], *args.extras], default_all: false)
    abort 'Provide entry paths: rake "entries:check[entries/1381/1381380-ao.org entries/...]"' if paths.empty?

    sh(*JbTasks.command, 'check', *(ENV['YANAGI'] ? ['--yanagi'] : []), *(ENV['EMACS'] ? ['--emacs'] : []), *paths)
  end

  desc 'One commit per entry, titled from #+TITLE: rake "entries:commit[a.org b.org]"'
  task :commit, [:paths] do |_task, args|
    paths = JbTasks.paths([args[:paths], *args.extras], default_all: false)
    abort 'Provide entry paths: rake "entries:commit[entries/1381/1381380-ao.org entries/...]"' if paths.empty?

    sh(*JbTasks.command, 'commit', *paths)
  end
end

desc 'Score corpus health and check for editorial defects across all entries (jb, in batches)'
task :doctor do
  JbTasks.doctor(JbTasks.paths([]))
end

namespace :doctor do
  desc 'Score health and show verbose findings for one entry: rake "doctor:entry[entries/1464/1464530-nihongo.org]"'
  task :entry, [:path] do |_task, args|
    abort 'Provide an entry path: rake "doctor:entry[entries/1464/1464530-nihongo.org]"' unless args[:path]

    sh(*JbTasks.command, 'doctor', args[:path])
  end
end

namespace :jmdict do
  desc 'Print the indexed JMdict senses of entries: rake "jmdict:lookup[1381380]"'
  task :lookup, [:ids] => :index do |_task, args|
    ids = [args[:ids], *args.extras].compact.flat_map(&:split)
    abort 'Provide JMdict ids: rake "jmdict:lookup[1381380 1464530]"' if ids.empty?

    sh(*JbTasks.command, 'jmdict', *ids)
  end
end
