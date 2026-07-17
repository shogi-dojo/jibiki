# Build an Org-first Japanese–Ukrainian dictionary with Ruby

**Full Path**: `/Users/mac/projects/jisho/japanese-ukrainian-org-dictionary.md`

## Context
Create a new Japanese–Ukrainian dictionary from scratch in `/Users/mac/projects/jisho`. The canonical authored data must be human-readable Org Mode files maintained primarily in Emacs; Ruby will provide validation, JMdict import/reconciliation, and deterministic app exports. Combine JMdict's semantic precision with independently authored learner-oriented details inspired by Warodai, while keeping English and Ukrainian available to the Android app.

## Reproduce Steps
1. `cd /Users/mac/projects/jisho`
2. Run `git status --short --branch` and preserve unrelated work.
3. Read `README.md`, `docs/org-format.md`, and `docs/n5-entry-agent.md`.
4. Run `rake -T` to inspect the supported Ruby workflow.
5. Run `rake "sources:n5[<source-order>]"` to prepare one ignored source dossier.
6. Run `rake` to test source parsing, validate every entry, and run Org lint.

## Current State
The constrained Org schema, progressive quality profiles, three example
entries, pronunciation/media model, source-aware validator, and Ruby source
extraction workflow are implemented. JMdict, Warodai, the N5 queue, and other
large or restricted sources remain ignored local inputs. Combined source
dossiers are generated under ignored `tmp/` so agents can reconcile a word
mechanically without publishing Warodai text.

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

## Next Implementation Priorities
1. Generate an Org Core scaffold from one unambiguous extracted JMdict object.
2. Complete strict parsing and validation for every documented Org node and
   property, including media and provenance.
3. Implement deterministic Org → normalized JSON, followed later by SQLite for
   Android.
4. Add fixtures for restrictions, multilingual glosses, polysemy, xrefs,
   upstream sense changes, malformed Org, and byte-identical repeat exports.
5. Add CI after source-independent fixtures cover the local-source workflow.

## How to Verify
- `rake test` passes without local source dependencies.
- `rake "sources:n5[2]"` resolves `青 / あお` to JMdict `1381380` and Warodai
  card `005-14-12` in an ignored dossier.
- `rake entries:validate` checks every committed entry against local JMdict.
- `rake org:lint` reports no structural warnings in entries or asset manifests.
- `rake` runs the complete current quality gate.
- Generated or committed public records contain no Warodai-derived text.

## Out of Scope
- Translating the full dictionary during schema development.
- A web editor, cloud service, or production Android integration before the Org model stabilizes.
- A general-purpose Org parser; support only the documented dictionary subset.
- Any Python compatibility or migration layer.

## Relevant Files
- `/Users/mac/projects/jisho/japanese-ukrainian-org-dictionary.md` — this source-of-truth handoff.

## Notes
- JMdict DTD: https://www.edrdg.org/jmdict/jmdict_dtd_h.html
- JMdict licence: CC BY-SA 4.0, https://www.edrdg.org/edrdg/licence.html — entries
  are derived works, so ShareAlike applies to `entries/` and the EDRDG
  acknowledgement must reach consuming applications. See `NOTICE`.
- Warodai structure reference only: https://github.com/WarodaiProject/warodai-source
- Warodai licence: https://github.com/WarodaiProject/warodai-source/blob/master/LICENSE
- Project licences: MIT for code, CC BY-SA 4.0 for dictionary content. See `LICENSE`.
