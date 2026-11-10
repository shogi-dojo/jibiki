# frozen_string_literal: true

module JB
  module Commands
    # jb commit [--dry-run] [--template TEXT] <path>...: one commit per entry,
    # in the order given, titled from the entry's #+TITLE (the loop's "one
    # word, one commit" rule). Refuses to start when anything is already
    # staged, so each commit holds exactly its entry. Hooks run as usual.
    module Commit
      module_function

      USAGE = 'jb commit [--dry-run] [--template "feat: add %s vocabulary entry"] <path>...'
      DEFAULT_TEMPLATE = 'feat: add %s vocabulary entry'

      def run(args, out)
        dry_run = !args.delete('--dry-run').nil?
        template = option(args, '--template') || DEFAULT_TEMPLATE
        raise UsageError, "usage: #{USAGE}" if args.empty?

        plan = args.map { |path| [path, template.sub('%s', title(path))] }
        if dry_run
          plan.each { |path, message| out.puts "#{path}\t#{message}" }
          return EXIT_OK
        end

        staged = Git.run('diff', '--cached', '--name-only').strip
        raise Failed, "refusing to commit: already staged: #{staged.split("\n").join(', ')}" unless staged.empty?

        plan.each do |path, message|
          Git.run('add', '--', path)
          Git.run('commit', '--quiet', '-m', message)
        end
        out.puts Git.run('log', "-#{plan.length}", '--reverse', '--format=%h %s')
        EXIT_OK
      end

      def title(path)
        raise Failed, "#{path}: file does not exist" unless File.exist?(path)

        text = File.binread(path).force_encoding('UTF-8')
        text[/^#\+TITLE: (.+)$/, 1] || raise(Failed, "#{path}: no #+TITLE header")
      end

      # Removes `--name VALUE` from args and answers VALUE.
      def option(args, name)
        index = args.index(name)
        return nil unless index

        value = args[index + 1]
        raise UsageError, "#{name} needs a value" if value.nil?

        args.slice!(index, 2)
        value
      end
    end
  end
end
