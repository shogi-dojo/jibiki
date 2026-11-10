# frozen_string_literal: true

module JB
  # Everything `jb --help` and `jb help <command>` print. Written for a reader
  # (person or agent) who has only this text: what each command does, what it
  # needs, what it prints, and what its exit code means.
  module Help
    OVERVIEW = <<~TEXT
      jb #{VERSION}: the jibiki word-adding loop in one process

      usage: jb <command> [options] [args]
             jb help <command>        (or: jb <command> --help)

      Per batch of ~10 authored entries, in this order:
        jb check <path>...            validate + doctor + lint; fix until it exits 0
        jb commit <path>...           one "feat: add <word> vocabulary entry" commit per entry
        jb checkpoint --sources ...   ledgers, PROGRESS.md section and state file from git
      then `rake test:fast`, and the full `rake test` before a pull request.

      commands:
        check       validate + doctor + lint in one process: the per-batch gate
        validate    the entry validator (docs/org-format.md §18), as scripts/validate_entry.rb
        doctor      entry health report (scores, editorial findings)
        lint        org-lint's checkers for entry files, without starting Emacs
        commit      one commit per entry, in the order given
        checkpoint  record which commit added each selected word
        jmdict      print the indexed JMdict senses of entries, as JSON
        version     print the version
        help        print this, or one command's help

      exit codes (every command):
        0  success: nothing to report
        1  usage error: bad command, option or missing argument (message on stderr)
        2  the command ran and found problems, or could not finish its job (git refused, ...)
        3  no JMdict index for the archive on disk: run `rake jmdict:index`, then retry

      setup:
        rake jmdict:index             once per JMdict archive (~1.5 min, all cores); validate,
                                      check and `doctor --with-jmdict` read JMdict only through it
        tools/jb/install/install.sh   installs ~/.local/bin/jb (native with Spinel, else CRuby shim)
        ruby tools/jb/bin/jb.rb ...   runs the same code without installing anything

      environment:
        JMDICT_PATH       the JMdict archive (default sources/jmdict/JMdict.xml.gz)
        JIBIKI_CACHE_DIR  where the index lives (default tmp/cache)

      Paths are entry files such as entries/1381/1381380-ao.org; run jb from the repository root.
    TEXT

    COMMANDS = {
      'check' => <<~TEXT,
        usage: jb check [--yanagi] [--emacs] <path>...

        The per-batch gate. Runs, in one process: validate (structure, schema, romaji,
        JMdict fingerprints), doctor (editorial errors), lint (org-lint's entry checkers).
        Prints one line per step, then the full output of every step that failed:

          validate  ok   10 entries, 0 failed
          doctor    ok   10 entries, 0 errors, 0 warnings
          lint      FAIL 1 findings

          --- lint
          entries/1381/1381380-ao.org:17: incomplete-drawer: Possible incomplete drawer ":PROPERTIES:"

        options:
          --yanagi  also run the yanagi transliteration audit (needs Ruby + bundler; ~0.3 s)
          --emacs   also run Emacs org-lint, the authority `jb lint` restates (~1 s)

        exit: 0 every step passed; 2 any step failed (fix and rerun); 3 no JMdict index.
        Doctor warnings and infos do not fail the gate; doctor errors do.

        example:
          jb check --yanagi entries/1956/1956790-nada.org entries/1229/1229760-nakitsuku.org
      TEXT
      'validate' => <<~TEXT,
        usage: jb validate [--json] <path>...

        Validates entry files exactly as scripts/validate_entry.rb does (same lines, same
        exit codes): headers, NFC, whitespace, placeholders, schema v2 rules, file name
        and romaji, duplicate JMDICT_IDs across the given files, stable IDs, examples on
        primary senses, and every sense's SOURCE_FINGERPRINT against JMdict.

        Text output, per path:
          Validating Org entry: <path>
          Looking up entry <id> in JMdict...
          Validation PASSED successfully!          or
          Validation FAILED with N errors:
          - <error>

        --json prints one document instead, written as each entry finishes:
          {"entries":[{"path":"...","errors":["..."]},...],"total_entries":N,"failed_entries":F}

        exit: 0 all passed; 2 any failed; 3 no JMdict index (run `rake jmdict:index`).

        example:
          jb validate entries/1381/1381380-ao.org
      TEXT
      'doctor' => <<~TEXT,
        usage: jb doctor [--json] [--with-jmdict] <path>...

        Scores entry health (0-100) and reports editorial findings by severity: error,
        warn, info. Same report as scripts/doctor.rb (without its HTML --report).
        One path prints that entry's details and findings; several print a summary
        grouped by check, then the failed entries.

        options:
          --json         the summary and every report as JSON (totals, then reports[])
          --with-jmdict  also check that JMdict senses with Russian glosses have a
                         Russian reference section (reads the JMdict index)

        exit: 0 no errors (warnings allowed); 2 any error; 1 no existing path given.

        example:
          jb doctor entries/1464/1464530-nihongo.org
      TEXT
      'lint' => <<~TEXT,
        usage: jb lint [--json] <path>...

        org-lint's checkers for the Org constructs entries use, with Emacs's checker names,
        line numbers and messages: incomplete-drawer, obsolete-properties-drawer (a
        PROPERTIES drawer not directly under its heading, or with a line that is not a
        property), special-property-in-properties-drawer, invalid-effort-property,
        invalid-keyword-syntax, orphaned-affiliated-keywords, priority, spurious-colons,
        item-number, invalid-block, trailing-bracket-after-link, invalid-custom-id-link,
        invalid-fuzzy-link, link-to-local-file, undefined-footnote-reference,
        unreferenced-footnote-definition, timestamp-syntax.

        Prints one line per finding, nothing when clean:
          <path>:<line>: <checker>: <message>
        --json prints [{"path":...,"exists":true,"findings":[{"line","checker","message"}]}].

        `rake org:lint` (Emacs, all of org-lint) remains the authoritative full check;
        `jb check --emacs` adds it to a batch.

        exit: 0 clean; 2 any finding or a missing file.
      TEXT
      'commit' => <<~TEXT,
        usage: jb commit [--dry-run] [--template TEXT] <path>...

        Makes one commit per entry, in the order given: `git add <path>` then
        `git commit -m <message>`, with git hooks running as usual. The message is the
        template with %s replaced by the entry's #+TITLE (default
        "feat: add %s vocabulary entry"). Refuses to start while anything is already
        staged, so each commit holds exactly its entry. Prints "<short sha> <subject>"
        per new commit, oldest first.

        options:
          --dry-run        print "<path>\\t<message>" per entry and commit nothing
          --template TEXT  the commit subject, %s for the title

        exit: 0 all committed; 2 something was staged, an entry is missing or has no
        #+TITLE, or git refused (entries committed before the failure stay committed).

        Run `jb check` on the same paths first: commit does not validate.
      TEXT
      'checkpoint' => <<~TEXT,
        usage: jb checkpoint --sources FILE --baseline SHA|FILE --ledger PATH [--ledger PATH...] [options]

        Records progress of a selection of words added one commit each since a baseline:
          - each set's ledger TSV (docs/...tsv): the selection rows with the commit that
            added each entry in add_commit (empty while not yet committed);
          - one PROGRESS.md section per set, replaced in place on every run;
          - a state file: total_target, total_completed, total_remaining, current_batch.
        Commits are found with one `git log --diff-filter=A` over baseline..HEAD.
        Prints: Progress checkpoint: <done>/<total> committed (<pct>%). Next batch: <n>.

        required:
          --sources FILE         JSON array of selection rows in commit order; each row has
                                 path, written, reading, jmdict_id, source_name, source_order,
                                 source_url, source_page_sha256, source_guid, source_tags
          --baseline SHA|FILE    the commit the selection started from, or a file holding it
          --ledger PATH          one per set of --set-size rows, in order (repeat the option)

        options:
          --set-names A,B,...      names for the PROGRESS headings (default "Set 1", "Set 2", ...)
          --date YYYY-MM-DD        the date in the headings (default today)
          --set-size N             rows per set (default 100)
          --batch-size N           rows per batch (default 10)
          --examples-per-word N    for the progress text (default 3)
          --progress FILE          default PROGRESS.md
          --progress-template FILE the section text; placeholders {name} {date} {set_size}
                                   {batch_size} {batches} {baseline} {done} {remaining} {ledger}
                                   {batches_done} {examples} {status} {helpers}; its first line
                                   is the heading that identifies the section
          --state FILE             default: the sources path with -sources.json -> -state.json
          --dry-run                print the progress line only, write nothing

        exit: 0 written; 1 a required option is missing; 2 the commits since the baseline are
        not the first selected entries in order, or a commit adds more than one entry.

        example:
          jb checkpoint --sources tmp/n10k-500h-sources.json --baseline tmp/n10k-500h-baseline \\
            --ledger docs/n10k-next100-2026-11-09g.tsv --ledger docs/n10k-next100-2026-11-09h.tsv \\
            --set-names Ninety-third,Ninety-fourth --date 2026-11-09
      TEXT
      'jmdict' => <<~TEXT,
        usage: jb jmdict <ent_seq>...

        Prints, as a JSON array, what the index holds for each JMdict entry: its senses
        with index, source_fingerprint (what SOURCE_FINGERPRINT must equal) and gloss
        languages. An unknown id prints {"ent_seq": "...", "missing": true}.

        exit: 0 all found; 2 any missing; 3 no JMdict index (run `rake jmdict:index`).

        example:
          jb jmdict 1381380
      TEXT
      'version' => <<~TEXT,
        usage: jb version   (or: jb --version)

        Prints "jb <version>".
      TEXT
      'help' => <<~TEXT
        usage: jb help [command]

        Prints the overview, or one command's help. `jb <command> --help` does the same.
      TEXT
    }.freeze

    def self.for(command)
      COMMANDS[command]
    end
  end
end
