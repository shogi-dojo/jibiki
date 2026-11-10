# frozen_string_literal: true

require 'json'
require 'stringio'
require_relative 'version'
require_relative 'errors'
require_relative 'git'
require_relative 'help'
require_relative '../../../lib/entry_validator'
require_relative '../../../lib/entry_doctor/runner'
require_relative '../../../lib/org_lint'
require_relative 'commands/validate'
require_relative 'commands/doctor'
require_relative 'commands/jmdict'
require_relative 'commands/lint'
require_relative 'commands/check'
require_relative 'commands/commit'
require_relative 'commands/checkpoint'

module JB
  # The `jb` entry point: one word picks the command, the rest is its
  # arguments, and the result is the process exit code.
  module CLI
    module_function

    def main(argv, stdout: $stdout, stderr: $stderr)
      args = argv.dup
      command = args.shift
      return help(args.first, stdout) if command == 'help'
      return help(command, stdout) if Help.for(command.to_s) && (args.include?('--help') || args.include?('-h'))

      case command
      when nil, '-h', '--help'
        stdout.puts Help::OVERVIEW
        EXIT_OK
      when 'version', '--version'
        stdout.puts "jb #{VERSION}"
        EXIT_OK
      when 'check' then Commands::Check.run(args, stdout)
      when 'validate' then Commands::Validate.run(args, stdout)
      when 'doctor' then Commands::Doctor.run(args, stdout)
      when 'jmdict' then Commands::Jmdict.run(args, stdout)
      when 'lint' then Commands::Lint.run(args, stdout)
      when 'commit' then Commands::Commit.run(args, stdout)
      when 'checkpoint' then Commands::Checkpoint.run(args, stdout)
      else raise UsageError, "unknown command: #{command} (see jb --help)"
      end
    rescue UsageError => e
      stderr.puts "jb: #{e.message}"
      stderr.puts "see: jb help #{command}" if Help.for(command.to_s)
      EXIT_USAGE
    rescue EntryValidator::MissingJmdictIndex => e
      stderr.puts "jb: #{e.message}"
      EXIT_NO_INDEX
    rescue Failed => e
      stderr.puts "jb: #{e.message}"
      EXIT_FAILED
    end

    def help(command, out)
      if command.nil?
        out.puts Help::OVERVIEW
        return EXIT_OK
      end
      text = Help.for(command)
      raise UsageError, "no such command: #{command} (see jb --help)" unless text

      out.puts text
      EXIT_OK
    end
  end
end
