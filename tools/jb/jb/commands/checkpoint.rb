# frozen_string_literal: true

require 'json'

module JB
  module Commands
    # jb checkpoint: records which commit added each selected word, in the
    # set ledgers (docs/*.tsv), a PROGRESS.md section per set and a state
    # file. The commits are found with one `git log` over baseline..HEAD, not
    # one `git diff-tree` per commit.
    #
    #   --sources FILE          selection rows (JSON array; each has at least `path`)
    #   --baseline SHA|FILE     the commit the set started from (or a file holding it)
    #   --ledger PATH           one per set, in order (repeat the option)
    #   --set-names A,B,...     set names for the PROGRESS headings (default "Set 1", ...)
    #   --date YYYY-MM-DD       the date in the headings (default today)
    #   --set-size N            words per set (default 100)
    #   --batch-size N          words per batch (default 10)
    #   --examples-per-word N   for the progress text (default 3)
    #   --progress FILE         default PROGRESS.md
    #   --progress-template F   section template (default: the 100-word goal text)
    #   --state FILE            default: the sources path with -state.json
    #   --dry-run               print the progress line, write nothing
    module Checkpoint
      module_function

      USAGE = 'jb checkpoint --sources FILE --baseline SHA|FILE --ledger PATH... [options]'

      COLUMNS = %w[batch source source_order written reading jmdict_id entry_path add_commit source_url
                   source_page_sha256 source_guid source_tags].freeze

      TEMPLATE = <<~TEXT
        ## {name} {set_size}-word vocabulary goal ({date})

        Baseline: `{baseline}`. Target: {batches} batches of {batch_size}, with a separate addition commit for each word.
        **{done}/{set_size} committed; {remaining} remain.**

        Vocabulary selected from the BCCWJ corpus joined with Warodai as requested.
        The ledger records the actual source and deck level.
        Only identities, readings, and level tags are taken from Anki and source corpora.
        Ukrainian glosses, notes, and Japanese examples are independently authored from JMdict senses and Warodai references.
        Entries remain learner-profile drafts pending independent linguistic review.

        [Selection and commit ledger]({ledger}).
        Completed {batches_done} batches have {examples} original examples and passed JMdict validation, Org lint,
        and doctor checks. {status}
        Ignored helper files: `{helpers}`; the pre-existing untracked files are preserved.
      TEXT

      NUMBER_WORDS = %w[zero one two three four five six seven eight nine ten eleven twelve].freeze

      def run(args, out)
        opts = parse(args)
        rows = JSON.parse(File.read(opts[:sources], encoding: 'UTF-8'))
        commits = added_entries(opts[:baseline])
        done = commits.length
        expected = rows.first(done).map { |row| row['path'] }
        unless commits.keys.sort == expected.sort
          raise Failed, "commits since the baseline do not add the first #{done} selected entries in order"
        end

        set_count = [1, (done + opts[:set_size] - 1) / opts[:set_size]].max
        if opts[:ledgers].length < set_count
          raise UsageError, "#{set_count} sets have started but only #{opts[:ledgers].length} --ledger paths were given"
        end

        unless opts[:dry_run]
          progress = File.exist?(opts[:progress]) ? File.read(opts[:progress], encoding: 'UTF-8') : ''
          set_count.times do |set|
            set_rows = rows[set * opts[:set_size], opts[:set_size]] || []
            File.write(opts[:ledgers][set], ledger(set_rows, commits, opts[:batch_size]))
            progress = replace_section(progress, section(opts, set, done))
          end
          File.write(opts[:progress], progress)
          File.write(opts[:state], "#{JSON.pretty_generate(state(rows.length, done, opts[:batch_size]))}\n")
        end

        out.puts "Progress checkpoint: #{done}/#{rows.length} committed (#{done * 100 / rows.length}%). " \
                 "Next batch: #{(done / opts[:batch_size]) + 1}."
        EXIT_OK
      end

      def parse(args)
        opts = { ledgers: [], set_size: 100, batch_size: 10, examples: 3, progress: 'PROGRESS.md',
                 date: Time.now.strftime('%Y-%m-%d'), dry_run: false, set_names: nil, template: TEMPLATE }
        until args.empty?
          flag = args.shift
          if flag == '--dry-run'
            opts[:dry_run] = true
            next
          end
          value = args.shift
          raise UsageError, "#{flag} needs a value (usage: #{USAGE})" if value.nil?

          case flag
          when '--sources' then opts[:sources] = value
          when '--baseline' then opts[:baseline] = File.exist?(value) ? File.read(value).strip : value
          when '--ledger' then opts[:ledgers] << value
          when '--set-names' then opts[:set_names] = value.split(',')
          when '--date' then opts[:date] = value
          when '--set-size' then opts[:set_size] = positive(flag, value)
          when '--batch-size' then opts[:batch_size] = positive(flag, value)
          when '--examples-per-word' then opts[:examples] = positive(flag, value)
          when '--progress' then opts[:progress] = value
          when '--progress-template' then opts[:template] = File.read(value, encoding: 'UTF-8')
          when '--state' then opts[:state] = value
          else raise UsageError, "unknown option #{flag} (usage: #{USAGE})"
          end
        end
        raise UsageError, "usage: #{USAGE}" if opts[:sources].nil? || opts[:baseline].nil? || opts[:ledgers].empty?

        opts[:state] ||= opts[:sources].sub(/-sources\.json\z/, '-state.json')
        opts[:helpers] = opts[:sources].sub(/-sources\.json\z/, '-*')
        opts
      end

      def positive(flag, value)
        number = value.to_i
        raise UsageError, "#{flag} must be a positive number" unless number.positive? && number.to_s == value

        number
      end

      # entry path => the commit that added it, from one git log.
      def added_entries(baseline)
        commits = {}
        log = Git.run('log', '--reverse', '--no-merges', '--diff-filter=A', '--name-only', '--format=%x01%H',
                      "#{baseline}..HEAD", '--', 'entries')
        log.split("\x01").each do |chunk|
          sha, *paths = chunk.split("\n").reject(&:empty?)
          next if sha.nil? || paths.empty?
          raise Failed, "commit #{sha} adds #{paths.length} entries; expected one per commit" if paths.length > 1

          commits[paths.first] = sha
        end
        commits
      end

      def ledger(rows, commits, batch_size)
        lines = [COLUMNS.join("\t")]
        rows.each_with_index do |row, index|
          lines << [(index / batch_size) + 1, row['source_name'], row['source_order'], row['written'], row['reading'],
                    row['jmdict_id'], row['path'], commits.fetch(row['path'], ''), row['source_url'],
                    row['source_page_sha256'], row['source_guid'], row['source_tags']].map { |v| tsv_field(v) }
                                                                                      .join("\t")
        end
        "#{lines.join("\n")}\n"
      end

      # Python's csv module, excel-tab dialect: quote only when needed.
      def tsv_field(value)
        text = value.nil? ? '' : value.to_s
        return text unless text.include?("\t") || text.include?('"') || text.include?("\n") || text.include?("\r")

        "\"#{text.gsub('"', '""')}\""
      end

      def section(opts, set, done)
        size = opts[:set_size]
        set_done = (done - (set * size)).clamp(0, size)
        batches = (size + opts[:batch_size] - 1) / opts[:batch_size]
        status = if set_done < size
                   "Continue with batch #{(set_done / opts[:batch_size]) + 1}."
                 else
                   "All #{NUMBER_WORDS.fetch(batches, batches.to_s)} batches are complete."
                 end
        values = {
          'name' => (opts[:set_names] || [])[set] || "Set #{set + 1}", 'date' => opts[:date],
          'set_size' => size.to_s, 'batch_size' => opts[:batch_size].to_s, 'batches' => batches.to_s,
          'baseline' => opts[:baseline], 'done' => set_done.to_s, 'remaining' => (size - set_done).to_s,
          'ledger' => opts[:ledgers][set], 'batches_done' => (set_done / opts[:batch_size]).to_s,
          'examples' => (opts[:examples] * set_done).to_s, 'status' => status, 'helpers' => opts[:helpers]
        }
        opts[:template].gsub(/\{([a-z_]+)\}/) { values.fetch(Regexp.last_match(1), Regexp.last_match(0)) }
      end

      # Replaces the section with this heading (and everything after it, since
      # sets are written in order) or appends it.
      def replace_section(text, section)
        heading = section.lines.first.chomp
        at = text.index(heading)
        head = at ? text[0, at] : text
        "#{head.rstrip}\n\n#{section.chomp}\n"
      end

      def state(total, done, batch_size)
        { 'total_target' => total, 'total_completed' => done, 'total_remaining' => total - done,
          'current_batch' => (done / batch_size) + 1 }
      end
    end
  end
end
