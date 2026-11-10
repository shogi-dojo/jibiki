# frozen_string_literal: true

module JB
  module Commands
    # jb doctor [--json] [--with-jmdict] <path>...: scripts/doctor.rb's report
    # (without the HTML export), with the Russian-reference check answered
    # from the JMdict index.
    module Doctor
      module_function

      USAGE = 'jb doctor [--json] [--with-jmdict] <path>...'

      def run(args, out)
        json = !args.delete('--json').nil?
        with_jmdict = !args.delete('--with-jmdict').nil?
        raise UsageError, "usage: #{USAGE}" if args.empty?

        paths = args.map { |path| File.expand_path(path) }.select { |path| File.exist?(path) }
        raise UsageError, 'no valid entry files found to analyze' if paths.empty?

        reports = EntryDoctor::Runner.analyze(paths, with_jmdict ? jmdict_entries(paths) : {})
        EntryDoctor::Runner.emit(reports, io: out, json: json)
      end

      def jmdict_entries(paths)
        entries = {}
        paths.each do |path|
          seq = File.binread(path).force_encoding('UTF-8')[/^#\+JMDICT_ID: (.*)$/, 1]
          entries[seq] = EntryValidator.jmdict_entry(seq) if seq
        end
        entries
      end
    end
  end
end
