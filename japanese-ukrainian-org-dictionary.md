# Build an Org-first Japanese–Ukrainian dictionary with Ruby

**Full Path**: `/Users/mac/projects/jisho/japanese-ukrainian-org-dictionary.md`

## Context
Create a new Japanese–Ukrainian dictionary from scratch in `/Users/mac/projects/jisho`. The canonical authored data must be human-readable Org Mode files maintained primarily in Emacs; Ruby will provide validation, JMdict import/reconciliation, and deterministic app exports. Combine JMdict's semantic precision with independently authored learner-oriented details inspired by Warodai, while keeping English and Ukrainian available to the Android app.

## Reproduce Steps
1. `cd /Users/mac/projects/jisho`
2. Run `git status --short --branch`; the working tree intentionally removes the previous Python/JSONL bootstrap.
3. Read this document before adding files or dependencies.
4. Inspect `origin/main` with `git ls-tree -r --name-only origin/main`; it is an empty initial branch.
5. Treat the repository as a clean design and implementation start. Do not restore the removed Python code.

## Current Issue
There is intentionally no implementation yet. The earlier agent created a Python/JSONL project before tooling and format were agreed; those files have been removed. The next agent must establish a small Ruby project and prove the Org schema on fixtures before building a large ingestion pipeline.

## Non-negotiable Decisions
- Ruby is the implementation language. Do not introduce Python, Node, or a second build system.
- Org is the canonical editable data format; JSON and SQLite are generated artifacts for applications.
- Store one JMdict entry per file, because one entry can contain multiple spellings, readings, and senses.
- Use `entries/<ent_seq div 1000>/<ent_seq>-<primary-reading-romaji>.org` so the numeric ID remains authoritative while fuzzy finders can also match a deterministic lowercase Modified-Hepburn alias (for example, `entries/1464/1464530-nihongo.org`).
- English JMdict glosses and Ukrainian translations are first-class app languages. Russian JMdict glosses may be retained as optional translator reference.
- Backporting Ukrainian enrichment to JMdict is optional; compatibility means stable IDs and lossless mapping, not that every custom field must fit upstream XML.
- Warodai may inspire article organization only. Do not copy or translate its definitions, examples, sense ordering, or other protected content because its CC BY-NC-ND 3.0 licence prohibits adaptations.

## Semantic Requirements
- Preserve JMdict `ent_seq`, kanji forms, readings, reading restrictions, priorities/frequency tags, sense order, POS, fields, miscellaneous/register tags, dialects, language sources, sense restrictions, cross-references, antonyms, and English glosses.
- Attach Ukrainian glosses and workflow state to the exact JMdict sense. Keep a source fingerprint so upstream reordering or edits require explicit reconciliation.
- Support independently authored usage notes, collocations, constructions/derivatives, idioms/proverbs, and examples under each sense.
- Give every local example or enrichment a stable local ID, provenance, and licence.
- Represent repeated semantic values as separate Org nodes/list items, never comma-packed prose.
- Track `untranslated`, `draft`, and `reviewed` states plus translator/reviewer metadata.

## Org Prototype
Specify a constrained, parseable Org subset based on this shape:

```org
#+TITLE: 日本語
#+JMDICT_ID: 1000001
#+SCHEMA_VERSION: 1

* Forms
** Kanji
- 日本語
  - priority :: ichi1
  - priority :: nf05
** Readings
- にほんご
  - applies-to :: *

* Sense 1
:PROPERTIES:
:SOURCE_FINGERPRINT: <sha256>
:STATUS: draft
:END:
** Part of speech
- noun
** English
- Japanese language
** Ukrainian
- японська мова
** Russian reference
- японский язык
** Usage notes
** Collocations
** Constructions and derivatives
** Idioms and proverbs
** Examples
*** ex-1000001-1-001
:PROPERTIES:
:SOURCE: original
:LICENSE: CC-BY-SA-4.0
:END:
- JA :: 日本語を勉強しています。
- UK :: Я вивчаю японську мову.
- EN :: I am studying Japanese.
```

Document exact rules for multiline text, escaping, empty sections, comments, repeated properties, ordering, Unicode normalization, editable versus generated fields, unknown future JMdict tags, and stable local IDs.

## Plan
1. Initialize a minimal Bundler project. Prefer Ruby's standard library and Minitest; justify every gem before adding it. Nokogiri may be appropriate for streaming large JMdict XML, and `sqlite3` may be appropriate only for generated app databases.
2. Write `docs/org-format.md` before the parser. Add one simple and one complex `.org` fixture.
3. Implement a strict Ruby parser and validator for the constrained Org subset with file, heading, and line diagnostics.
4. Implement streaming JMdict XML → Org import/reconciliation without loading the entire dictionary into memory.
5. Implement deterministic Org → normalized JSON export, followed later by SQLite export for Android.
6. Add tests for forms, restrictions, multilingual glosses, polysemy, xrefs, source fingerprints, upstream sense changes, provenance, malformed Org, and byte-identical repeat exports.
7. Only after fixtures round-trip correctly, add README, licences, contribution rules, CI, and bulk data generation.

## How to Verify
- `bundle exec ruby -Itest -e 'Dir["test/**/*_test.rb"].sort.each { |f| require_relative f }'` passes after scaffolding.
- A complex JMdict fixture round-trips through XML → Org → normalized Ruby objects without losing any supported field or sense association.
- Two exports from unchanged Org sources are byte-identical.
- Emacs folds, navigates, searches, and edits fixtures naturally; `org-lint` finds no structural errors.
- Validation rejects duplicate IDs, malformed headings/properties, missing readings, invalid workflow state, stale fingerprints, and enrichments lacking provenance/licence.
- Generated app records expose English and Ukrainian independently and contain no Warodai-derived text.

## Out of Scope
- Translating the full dictionary during schema development.
- A web editor, cloud service, or production Android integration before the Org model stabilizes.
- A general-purpose Org parser; support only the documented dictionary subset.
- Any Python compatibility or migration layer.

## Relevant Files
- `/Users/mac/projects/jisho/japanese-ukrainian-org-dictionary.md` — this source-of-truth handoff.
- `/Users/mac/projects/other/Houhou-SRS/android-app` — eventual consumer; keep it decoupled from Org authoring internals.

## Notes
- JMdict DTD: https://www.edrdg.org/jmdict/jmdict_dtd_h.html
- Warodai structure reference only: https://github.com/WarodaiProject/warodai-source
- Warodai licence: https://github.com/WarodaiProject/warodai-source/blob/master/LICENSE
