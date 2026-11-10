# frozen_string_literal: true

module JB
  module Commands
    # jb jmdict <ent_seq>...: the indexed senses of JMdict entries, as JSON
    # (fingerprints and gloss languages: what the validator compares against).
    module Jmdict
      module_function

      USAGE = 'jb jmdict <ent_seq>...'

      def run(args, out)
        raise UsageError, "usage: #{USAGE}" if args.empty?

        missing = 0
        entries = args.map do |seq|
          entry = EntryValidator.jmdict_entry(seq)
          missing += 1 if entry.nil?
          entry || { ent_seq: seq, missing: true }
        end
        out.puts JSON.pretty_generate(entries)
        missing.zero? ? EXIT_OK : EXIT_FAILED
      end
    end
  end
end
