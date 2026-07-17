# Japanese–Ukrainian Org dictionary

An Org-first Japanese–Ukrainian learner dictionary. JMdict supplies stable
entry identity and structured Japanese/English metadata; Ukrainian glosses,
notes, and examples are authored independently. Ruby scripts make source
lookup, extraction, fingerprinting, validation, and Org linting reproducible.

## Requirements

- Ruby with Rake (the tools currently use only the standard library)
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

JMdict is authoritative. A normal candidate must resolve to exactly one JMdict
entry before authoring begins. Warodai is CC BY-NC-ND 3.0 and is exposed only
for local read-only comparison: never copy, translate, adapt, commit, or publish
its text. Generated dossiers remain under ignored `tmp/` for the same reason.

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

## Author and validate an entry

Follow `docs/n5-entry-agent.md` for the complete one-word workflow and
`docs/org-format.md` for the schema. Validate one entry with:

```sh
rake "entries:validate[entries/1381/1381380-ao.org]"
rake "entries:lint[entries/1381/1381380-ao.org]"
```

Run the full local quality gate with:

```sh
rake
```

The default task runs extractor unit tests, validates all entries against the
local JMdict archive, and runs `org-lint` on entries and asset manifests.

## Repository layout

- `entries/` — canonical authored Org dictionary entries
- `lib/dictionary_sources/` — reusable source readers and parsers
- `scripts/` — command-line extraction and validation tools
- `docs/` — Org schema and contributor/agent workflow
- `assets/` — licensed media and manifests
- `sources/` — ignored upstream inputs
- `tmp/source-extracts/` — ignored private source dossiers
