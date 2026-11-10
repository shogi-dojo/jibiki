# frozen_string_literal: true

module JB
  module Commands
    # jb validate [--json] <path>...: the checks of scripts/validate_entry.rb,
    # with the same output and exit codes, answering JMdict from the index.
    module Validate
      module_function

      USAGE = 'jb validate [--json] <path>...'

      def run(args, out)
        json = !args.delete('--json').nil?
        raise UsageError, "usage: #{USAGE}" if args.empty?

        EntryValidator.run(args, io: out, json: json)
      end
    end
  end
end
