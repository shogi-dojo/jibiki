#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'json'
require_relative '../lib/entry_doctor'
require_relative '../lib/dictionary_sources/jmdict'

REPO_ROOT = File.expand_path('..', __dir__)
JMDICT_PATH = ENV.fetch(
  'JMDICT_PATH',
  File.join(REPO_ROOT, 'sources', 'jmdict', 'JMdict.xml.gz')
)

options = {
  json: false,
  report: nil,
  with_jmdict: false
}

parser = OptionParser.new do |opts|
  opts.banner = 'Usage: scripts/doctor.rb [options] [path ...]'

  opts.on('-j', '--json', 'Output report in JSON format') do
    options[:json] = true
  end

  opts.on('-r', '--report PATH', 'Generate HTML report to the specified file') do |path|
    options[:report] = path
  end

  opts.on('--with-jmdict', 'Cross-check against JMdict archive for Russian references') do
    options[:with_jmdict] = true
  end

  opts.on('-h', '--help', 'Show this help message') do
    puts opts
    exit 0
  end
end

parser.parse!(ARGV)

paths = ARGV.empty? ? Dir[File.join(REPO_ROOT, 'entries', '*', '*.org')].sort : ARGV.map { |p| File.expand_path(p) }
paths = paths.select { |p| File.exist?(p) }

if paths.empty?
  warn 'No valid entry files found to analyze.'
  exit 1
end

jmdict_entries = {}
if options[:with_jmdict] && File.exist?(JMDICT_PATH)
  jmdict = DictionarySources::Jmdict.new(JMDICT_PATH)
  ent_seqs = paths.filter_map do |path|
    File.binread(path).force_encoding('UTF-8')[/^#\+JMDICT_ID: (.*)$/, 1]
  end.uniq
  queries = ent_seqs.map { |seq| { ent_seq: seq } }
  jmdict.lookup_many(queries).each_with_index do |matches, index|
    jmdict_entries[ent_seqs[index]] = matches.first
  end
end

reports = paths.map do |path|
  ent_seq = File.binread(path).force_encoding('UTF-8')[/^#\+JMDICT_ID: (.*)$/, 1]
  jm_entry = jmdict_entries[ent_seq]
  EntryDoctor.analyze_file(path, jmdict_entry: jm_entry)
end

if options[:report]
  require_relative 'doctor_report'
  DoctorReport.generate(reports, options[:report])
  puts "Generated HTML doctor report at #{options[:report]}"
end

if options[:json]
  summary = {
    total_entries: reports.length,
    passed_entries: reports.count(&:passed?),
    failed_entries: reports.count { |r| !r.passed? },
    total_errors: reports.sum { |r| r.errors.length },
    total_warnings: reports.sum { |r| r.warnings.length },
    total_infos: reports.sum { |r| r.infos.length },
    average_health_score: reports.empty? ? 0 : (reports.sum(&:health_score).to_f / reports.length).round(1),
    reports: reports.map(&:to_h)
  }
  puts JSON.pretty_generate(summary)
  exit(summary[:total_errors].positive? ? 2 : 0)
end

# CLI Human-Readable Output
total_errors = reports.sum { |r| r.errors.length }
total_warnings = reports.sum { |r| r.warnings.length }
total_infos = reports.sum { |r| r.infos.length }
avg_score = reports.empty? ? 0 : (reports.sum(&:health_score).to_f / reports.length).round(1)

puts "========================================================"
puts "  JIBIKI ENTRY DOCTOR REPORT"
puts "========================================================"
puts "Analyzed entries: #{reports.length}"
puts "Average health score: #{avg_score}/100"
puts "Passed: #{reports.count(&:passed?)} | Failed: #{reports.count { |r| !r.passed? }}"
puts "Total findings: #{total_errors} errors, #{total_warnings} warnings, #{total_infos} infos"
puts "--------------------------------------------------------"

# Group findings by check
all_findings = reports.flat_map do |r|
  r.findings.map { |f| { report: r, finding: f } }
end

grouped_by_check = all_findings.group_by { |item| [item[:finding].check, item[:finding].severity] }

if grouped_by_check.any?
  puts "Findings by Check:"
  grouped_by_check.sort_by { |(check, sev), items| [sev == :error ? 0 : (sev == :warn ? 1 : 2), -items.length] }.each do |(check, sev), items|
    badge = case sev
            when :error then '[ERROR]'
            when :warn then '[WARN] '
            when :info then '[INFO] '
            end
    puts "  #{badge} #{check}: #{items.length} occurrence(s)"
  end
  puts "--------------------------------------------------------"
end

if reports.length == 1
  report = reports.first
  puts "Details for #{report.entry.title} (#{report.entry.jmdict_id}-#{report.entry.romaji}):"
  puts "  Health Score: #{report.health_score}/100"
  puts "  Profile: #{report.entry.quality_profile} | Status: #{report.entry.entry_status}"
  puts "  Senses: #{report.stats[:total_senses]} (English: #{report.stats[:eng_senses_count]}, Covered: #{report.stats[:covered_eng_senses]})"
  puts "  Examples: #{report.stats[:total_examples]}"
  if report.findings.any?
    puts "  Findings:"
    report.findings.each do |f|
      puts "    - [#{f.severity.upcase}] #{f.check} (#{f.sense_id || 'entry'}): #{f.detail}"
    end
  end
elsif total_errors.positive?
  puts "Failed Entries (showing first 10):"
  reports.reject(&:passed?).take(10).each do |r|
    puts "  - #{File.basename(r.path || r.entry.romaji)} (score: #{r.health_score}): #{r.errors.length} error(s)"
    r.errors.take(3).each do |err|
      puts "      * #{err.check}: #{err.detail}"
    end
  end
  puts "  ... and #{reports.count { |r| !r.passed? } - 10} more" if reports.count { |r| !r.passed? } > 10
  puts "--------------------------------------------------------"
end

if total_errors.positive?
  puts "Result: FAILED (#{total_errors} errors found)"
  exit 2
else
  puts "Result: PASSED (0 errors found)"
  exit 0
end
