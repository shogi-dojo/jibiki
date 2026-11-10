# frozen_string_literal: true

module JB
  module Commands
    # jb lint [--json] <path>...: the org-lint checkers that apply to entries
    # (lib/org_lint.rb), without starting Emacs. `rake org:lint` stays the
    # full Emacs check.
    module Lint
      module_function

      USAGE = 'jb lint [--json] <path>...'

      def run(args, out)
        json = !args.delete('--json').nil?
        raise UsageError, "usage: #{USAGE}" if args.empty?

        results = args.map { |path| [path, File.exist?(path) ? OrgLint.lint_file(path) : nil] }
        json ? print_json(results, out) : print_text(results, out)
        results.all? { |_path, findings| findings && findings.empty? } ? EXIT_OK : EXIT_FAILED
      end

      def print_text(results, out)
        results.each do |path, findings|
          if findings.nil?
            out.puts "#{path}: file does not exist"
            next
          end
          findings.each { |f| out.puts "#{path}:#{f.line}: #{f.checker}: #{f.message}" }
        end
      end

      def print_json(results, out)
        entries = results.map do |path, findings|
          rows = (findings || []).map { |f| { 'line' => f.line, 'checker' => f.checker, 'message' => f.message } }
          { 'path' => path, 'exists' => !findings.nil?, 'findings' => rows }
        end
        out.puts JSON.pretty_generate(entries)
      end
    end
  end
end
