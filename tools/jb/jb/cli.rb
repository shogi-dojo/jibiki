# frozen_string_literal: true

require 'json'
require 'stringio'
require_relative 'version'
require_relative 'errors'
require_relative '../../../lib/entry_validator'
require_relative '../../../lib/entry_doctor/runner'
require_relative '../../../lib/org_lint'
require_relative 'commands/validate'
require_relative 'commands/doctor'
require_relative 'commands/jmdict'
require_relative 'commands/lint'
require_relative 'commands/check'

module JB
  # The `jb` entry point: one word picks the command, the rest is its
  # arguments, and the result is the process exit code.
  module CLI
    module_function

    USAGE = <<~TEXT
      jb #{VERSION}: the jibiki word-adding loop in one process

      usage: jb <command> [args]

        check [--yanagi] [--emacs] <path>...        validate + doctor + lint: the per-batch gate
        validate [--json] <path>...                 the entry validator (docs/org-format.md §18)
        doctor [--json] [--with-jmdict] <path>...   entry health report
        lint [--json] <path>...                     org-lint's entry checkers, without Emacs
        jmdict <ent_seq>...                         indexed JMdict senses, as JSON
        version                                     print the version

      JMdict is read from the index `rake jmdict:index` builds.
    TEXT

    def main(argv, stdout: $stdout, stderr: $stderr)
      args = argv.dup
      command = args.shift
      case command
      when nil, 'help', '-h', '--help'
        stdout.puts USAGE
        EXIT_OK
      when 'version', '--version'
        stdout.puts "jb #{VERSION}"
        EXIT_OK
      when 'check' then Commands::Check.run(args, stdout)
      when 'validate' then Commands::Validate.run(args, stdout)
      when 'doctor' then Commands::Doctor.run(args, stdout)
      when 'jmdict' then Commands::Jmdict.run(args, stdout)
      when 'lint' then Commands::Lint.run(args, stdout)
      else raise UsageError, "unknown command: #{command} (see jb --help)"
      end
    rescue UsageError => e
      stderr.puts "jb: #{e.message}"
      EXIT_USAGE
    rescue EntryValidator::MissingJmdictIndex => e
      stderr.puts "jb: #{e.message}"
      EXIT_NO_INDEX
    end
  end
end
