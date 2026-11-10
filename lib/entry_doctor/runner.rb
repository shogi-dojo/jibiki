# frozen_string_literal: true

require 'json'
require_relative '../entry_doctor'

module EntryDoctor
  # The doctor's command-line behaviour, shared by scripts/doctor.rb and the
  # `jb doctor` command: analyse entry files and print the summary.
  module Runner
    module_function

    # Reports for the given paths. jmdict_entries maps ent_seq to a JMdict
    # entry (from the index or the archive) for the Russian-reference check.
    def analyze(paths, jmdict_entries = {})
      paths.map do |path|
        ent_seq = File.binread(path).force_encoding('UTF-8')[/^#\+JMDICT_ID: (.*)$/, 1]
        EntryDoctor.analyze_file(path, jmdict_entry: jmdict_entries[ent_seq])
      end
    end

    # Prints the summary (JSON or the human report) and returns the exit code:
    # 2 when any entry has errors, 0 otherwise.
    def emit(reports, io: $stdout, json: false)
      json ? print_json(reports, io) : print_human(reports, io)
    end

    def print_json(reports, io)
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
      io.puts JSON.pretty_generate(summary)
      summary[:total_errors].positive? ? 2 : 0
    end

    def print_human(reports, io)
      total_errors = reports.sum { |r| r.errors.length }
      total_warnings = reports.sum { |r| r.warnings.length }
      total_infos = reports.sum { |r| r.infos.length }
      avg_score = reports.empty? ? 0 : (reports.sum(&:health_score).to_f / reports.length).round(1)

      io.puts '========================================================'
      io.puts '  JIBIKI ENTRY DOCTOR REPORT'
      io.puts '========================================================'
      io.puts "Analyzed entries: #{reports.length}"
      io.puts "Average health score: #{avg_score}/100"
      io.puts "Passed: #{reports.count(&:passed?)} | Failed: #{reports.count { |r| !r.passed? }}"
      io.puts "Total findings: #{total_errors} errors, #{total_warnings} warnings, #{total_infos} infos"
      io.puts '--------------------------------------------------------'

      # Group findings by check
      all_findings = reports.flat_map do |r|
        r.findings.map { |f| { report: r, finding: f } }
      end

      grouped_by_check = all_findings.group_by { |item| [item[:finding].check, item[:finding].severity] }

      if grouped_by_check.any?
        io.puts 'Findings by Check:'
        grouped_by_check.sort_by do |(_check, sev), items|
          [if sev == :error
             0
           else
             (sev == :warn ? 1 : 2)
           end, -items.length]
        end.each do |(check, sev), items|
          badge = case sev
                  when :error then '[ERROR]'
                  when :warn then '[WARN] '
                  when :info then '[INFO] '
                  end
          io.puts "  #{badge} #{check}: #{items.length} occurrence(s)"
        end
        io.puts '--------------------------------------------------------'
      end

      if reports.length == 1
        report = reports.first
        io.puts "Details for #{report.entry.title} (#{report.entry.jmdict_id}-#{report.entry.romaji}):"
        io.puts "  Health Score: #{report.health_score}/100"
        io.puts "  Profile: #{report.entry.quality_profile} | Status: #{report.entry.entry_status}"
        io.puts "  Senses: #{report.stats[:total_senses]} (English: #{report.stats[:eng_senses_count]}, Covered: #{report.stats[:covered_eng_senses]})"
        io.puts "  Examples: #{report.stats[:total_examples]}"
        if report.findings.any?
          io.puts '  Findings:'
          report.findings.each do |f|
            io.puts "    - [#{f.severity.upcase}] #{f.check} (#{f.sense_id || 'entry'}): #{f.detail}"
          end
        end
      elsif total_errors.positive?
        io.puts 'Failed Entries (showing first 10):'
        reports.reject(&:passed?).take(10).each do |r|
          io.puts "  - #{File.basename(r.path || r.entry.romaji)} (score: #{r.health_score}): #{r.errors.length} error(s)"
          r.errors.take(3).each do |err|
            io.puts "      * #{err.check}: #{err.detail}"
          end
        end
        io.puts "  ... and #{reports.count { |r| !r.passed? } - 10} more" if reports.count { |r| !r.passed? } > 10
        io.puts '--------------------------------------------------------'
      end

      if total_errors.positive?
        io.puts "Result: FAILED (#{total_errors} errors found)"
        2
      else
        io.puts 'Result: PASSED (0 errors found)'
        0
      end
    end
  end
end
