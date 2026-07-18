# Japanese–Ukrainian Org dictionary

An Org-first Japanese–Ukrainian learner dictionary. JMdict supplies stable
entry identity and structured Japanese/English metadata; Ukrainian glosses,
notes, and examples are authored independently. Ruby scripts make source
lookup, extraction, fingerprinting, validation, and Org linting reproducible.

This dictionary uses the JMdict dictionary file, copyright James William Breen
and The [Electronic Dictionary Research and Development Group](https://www.edrdg.org/wiki/index.php/JMdict-EDICT_Dictionary_Project),
used under CC BY-SA 4.0.

## Requirements

- Ruby with Bundler (run `bundle install` to install dependencies)
- Emacs for the `org-lint` task
- ignored local sources described in `sources/README.md`:
  - `sources/jmdict/JMdict.xml.gz`
  - `sources/warodai/`
  - `sources/jlpt-n5/wiktionary-n5.tsv`

Run `rake -T` to list the supported workflow.

## Prepare one N5 word

Use the queue's `source_order`; do not search or parse the source files by hand:

```sh
rake "sources:n5[3]"
```

This writes an ignored dossier such as
`tmp/source-extracts/n5-000003.json`. The dossier contains:

- the exact N5 candidate row;
- exact JMdict matches with entry IDs, forms, readings, restrictions,
  priorities, senses, tags, multilingual glosses, and source fingerprints;
- `sense_indexes_by_language`, which identifies the English semantic senses
  and any Russian reference senses;
- exact Warodai header metadata and body lines for private comparison;
- archive/file checksums for reconciliation.

JMdict is authoritative (CC BY-SA 4.0; see `NOTICE`). A normal candidate must
resolve to exactly one JMdict entry before authoring begins. Warodai is
CC BY-NC-ND 3.0 and is exposed only for local read-only comparison: never copy,
translate, adapt, commit, or publish its text — the NoDerivatives term makes a
translation an infringing adaptation. Generated dossiers mix JMdict and Warodai
material, so they remain under ignored `tmp/` and are never committed.

For direct diagnostics:

```sh
rake "sources:jmdict[青,あお]"
rake "sources:warodai[青,あお]"
rake "sources:word[青,あお]"
ruby scripts/extract_jmdict.rb --id 1381380
ruby scripts/extract_warodai.rb --id 005-14-12
```

The source paths can be overridden with `JMDICT_PATH`, `WARODAI_PATH`, and
`N5_PATH` without editing repository files.

## Scaffold, author, and validate an entry

Follow `docs/org-format.md` for the schema (currently schema version 2). Use
`PROGRESS.md` to see the current queue coverage and editorial maturity, and
update its row whenever an entry advances.

Scaffold a complete entry from one N5 queue row instead of writing Org by
hand or reaching for a one-off script:

```sh
rake "entries:scaffold[299,juu]"
```

This reads the same dossier sources as `rake sources:n5[N]` (JMdict plus the
N5 queue row) and writes a full `entries/<dir>/<id>-<romaji>.org`: every
derived section (forms, senses, POS, English glosses, Russian reference,
fingerprints, `LEARNER_PRIORITY`) is filled in, and every authored slot
(Ukrainian gloss, learner note, example) is pre-filled with the exact
placeholder text the validator rejects — the gate stays red until the
placeholders are replaced with genuine content. It refuses to overwrite an
existing entry file. The `--romaji` value is chosen the same way it always
has been: a human picks the filename's Modified Hepburn romanization: there
is no automated transliterator.

The intended flow is **scaffold → author payload → validate**, one agent, one
pass, rather than generating many entries up front and backfilling debt
later. Batch size guidance is therefore ~10 words authored to completion
rather than 20 scaffolded with placeholders left in.

Validate one entry with:

```sh
rake "entries:validate[entries/1381/1381380-ao.org]"
rake "entries:lint[entries/1381/1381380-ao.org]"
```

Run the full local quality gate with:

```sh
rake
```

The default task runs extractor unit tests, validates all entries against the
local JMdict archive, and runs `org-lint` on entries.

## Export

Two SQLite files can be exported from the corpus. Both are written to the `build/`
directory (gitignored):

| File | Purpose |
|---|---|
| `build/jibiki.sqlite` | Rich learner DB with all parsed content (senses, glosses, examples, pitch accent, vocab mapping). |
| `build/DictionaryTranslations.sqlite` | Drop-in Houhou-SRS overlay (SchemaVersion 1, FTS4, Ukrainian/Russian glosses). |

### Rich learner database

```sh
bundle exec rake "export:rich[build/jibiki.sqlite]"

# With Houhou vocab mapping (optional):
bundle exec rake "export:rich[build/jibiki.sqlite,/path/to/KanjiDatabase.sqlite]"
```

### Houhou overlay

```sh
# Ukrainian-only:
bundle exec rake "export:overlay[/path/to/KanjiDatabase.sqlite]"

# With merged Russian rows from an existing overlay:
bundle exec rake "export:overlay[/path/to/KanjiDatabase.sqlite,build/DictionaryTranslations.sqlite,/path/to/donor/DictionaryTranslations.sqlite]"
```

### Both at once

```sh
bundle exec rake "export:all[/path/to/KanjiDatabase.sqlite]"
```

See [`docs/export-formats.md`](docs/export-formats.md) for full schema documentation and
[`docs/houhou-integration.md`](docs/houhou-integration.md) for Android-app integration notes.

## Repository layout

- `PROGRESS.md` — merge-oriented inventory and editorial maturity ledger
- `entries/` — canonical authored Org dictionary entries
- `lib/dictionary_sources/` — reusable source readers and parsers
- `scripts/` — command-line extraction and validation tools
- `docs/` — Org schema
- `assets/` — ignored locally generated media and manifests
- `sources/` — ignored upstream inputs
- `tmp/source-extracts/` — ignored private source dossiers

## Licensing

Two licences apply; see `LICENSE` for the full terms and `NOTICE` for
third-party attribution and provenance.

- **Code** (`scripts/`, `lib/`, `Rakefile`, `test/`) — MIT.
- **Dictionary content** (`entries/`, `docs/`) — CC BY-SA 4.0.

Entries are derived from JMdict, which is CC BY-SA 4.0, so ShareAlike applies
to the dictionary content: redistributions and adaptations must stay under
CC BY-SA 4.0 and must preserve the attribution in `NOTICE`. Commercial use is
permitted under both licences.

If you build an application on this data, EDRDG asks that the JMdict
acknowledgement appear **in the application itself**, not only in a repository
or launch page. Carry the JMdict section of `NOTICE` into your product.

Upstream sources in `sources/` are third-party works, are excluded from this
repository, and are not licensed here. Warodai in particular is CC BY-NC-ND
3.0: no Warodai text is present in this repository, and its content must not
be copied, translated, or published as part of this project.
