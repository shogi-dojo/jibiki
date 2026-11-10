# frozen_string_literal: true

require 'open3'

module JB
  module Commands
    # jb check [--yanagi] [--emacs] <path>...: the per-batch gate in one
    # process: validate, doctor and lint. Prints one summary line per step and
    # the full output of any step that failed; exit 2 when any did.
    #
    #   --yanagi  also run the yanagi transliteration audit (CRuby + bundler,
    #             since the audit loads its YAML lexicons at run time)
    #   --emacs   also run Emacs org-lint, the authority jb lint restates
    module Check
      module_function

      USAGE = 'jb check [--yanagi] [--emacs] <path>...'

      Step = Data.define(:name, :ok, :summary, :output)

      def run(args, out)
        yanagi = !args.delete('--yanagi').nil?
        emacs = !args.delete('--emacs').nil?
        raise UsageError, "usage: #{USAGE}" if args.empty?

        steps = [validate(args), doctor(args), lint(args)]
        steps << external('yanagi', yanagi_command(args)) if yanagi
        steps << external('emacs', emacs_command(args)) if emacs
        report(steps, out)
        steps.all?(&:ok) ? EXIT_OK : EXIT_FAILED
      end

      def report(steps, out)
        steps.each { |step| out.puts format('%-9s %-4s %s', step.name, step.ok ? 'ok' : 'FAIL', step.summary) }
        steps.reject(&:ok).each do |step|
          out.puts
          out.puts "--- #{step.name}"
          out.puts step.output
        end
      end

      def validate(paths)
        io = StringIO.new
        code = EntryValidator.run(paths, io: io)
        failed = io.string.lines.count { |line| line.start_with?('Validation FAILED') }
        Step.new(name: 'validate', ok: code.zero?, summary: "#{paths.length} entries, #{failed} failed",
                 output: io.string)
      end

      # An entry that does not parse fails this step (validate reports why)
      # rather than stopping the gate.
      def doctor(paths)
        reports = []
        unreadable = []
        paths.each do |path|
          next unreadable << "#{path}: file does not exist" unless File.exist?(path)

          begin
            reports.concat(EntryDoctor::Runner.analyze([path]))
          rescue OrgEntry::ParseError => e
            unreadable << "#{path}: #{e.message}"
          end
        end
        io = StringIO.new
        code = EntryDoctor::Runner.emit(reports, io: io)
        unreadable.each { |line| io.puts "unreadable: #{line}" }
        errors = reports.sum { |r| r.errors.length } + unreadable.length
        warnings = reports.sum { |r| r.warnings.length }
        Step.new(name: 'doctor', ok: code.zero? && unreadable.empty?,
                 summary: "#{reports.length} entries, #{errors} errors, #{warnings} warnings", output: io.string)
      end

      def lint(paths)
        io = StringIO.new
        code = Lint.run(paths.dup, io)
        Step.new(name: 'lint', ok: code.zero?, summary: "#{io.string.lines.length} findings", output: io.string)
      end

      def external(name, command)
        output, status = Open3.capture2e(*command, chdir: EntryValidator::REPO_ROOT)
        Step.new(name: name, ok: status.success?, summary: status.success? ? 'clean' : "exit #{status.exitstatus}",
                 output: output)
      rescue SystemCallError => e
        Step.new(name: name, ok: false, summary: "could not run #{command.first}", output: e.message)
      end

      def yanagi_command(paths)
        script = 'f = Yanagi.audit(ARGV, tier2: false); f.each { |x| puts x.inspect }; exit(f.empty? ? 0 : 1)'
        ['bundle', 'exec', 'ruby', '-r', 'yanagi', '-e', script, *paths.map { |path| File.expand_path(path) }]
      end

      ORG_LINT_ELISP = "(progn (require 'org) (let ((failed nil)) (dolist (path command-line-args-left) " \
                       '(with-current-buffer (find-file-noselect path) (let ((issues (org-lint))) (when issues ' \
                       '(princ (format "%s\n" path)) (prin1 issues) (princ "\n") (setq failed t))))) ' \
                       '(kill-emacs (if failed 1 0))))'

      def emacs_command(paths)
        ['emacs', '--batch', '--eval', ORG_LINT_ELISP, *paths.map { |path| File.expand_path(path) }]
      end
    end
  end
end
