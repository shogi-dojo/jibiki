# JLPT N5 entry agent instructions

## Mission

Create exactly one new Japanese–Ukrainian Org entry from the candidate JLPT N5
queue at Core or Learner quality. Preserve JMdict faithfully, author Ukrainian
content independently, validate the result, and report the selected queue row
and JMdict ID.

Do not copy or translate Warodai or the Bondarenko–Hino PDF. Wiktionary chooses
the candidate word only; JMdict is the authority for identity, forms, readings,
senses, restrictions, tags, and English glosses.

## Inputs

The coordinating task should provide:

- `SOURCE_ORDER`: preferred row from `sources/jlpt-n5/wiktionary-n5.tsv`;
- `QUALITY_PROFILE`: `core` or `learner` (default: `core`);
- `TRANSLATOR_ID`: contributor identifier to write in provenance;
- `COMMIT`: whether this agent is authorized to commit (default: `false`).

Separate Git worktrees do not share ignored claim directories, so
`SOURCE_ORDER` is mandatory when agents run in separate worktrees. In a shared
workspace an agent may claim the next available row atomically as described
below.

## 1. Preflight

1. Read `docs/org-format.md` completely.
2. Run `git status --short` and preserve all unrelated user or agent changes.
3. Confirm these local ignored sources exist:
   - `sources/jlpt-n5/wiktionary-n5.tsv`
   - `sources/jmdict/JMdict.xml.gz`
4. Never stage or commit anything under `sources/`.

## 2. Select and claim one candidate

Prefer the assigned `SOURCE_ORDER`. Read that TSV row with a CSV-aware tool;
the file is quoted tab-separated data, so do not parse it with whitespace
splitting.

When several agents share one workspace and no row was assigned:

1. Consider rows in ascending `source_order`.
2. Skip rows already represented under `entries/`.
3. Atomically create
   `sources/jlpt-n5/claims/<six-digit-source-order>` with `mkdir`.
4. If `mkdir` reports that it already exists, try the next row.
5. Leave a successful ignored claim in place until integration. Remove only a
   claim created by this agent when abandoning the candidate.

An empty-directory `mkdir` is the lock operation; checking and then creating a
normal file is racy. This fallback works only in a shared filesystem.

## 3. Reconcile the candidate with JMdict

Use the queue's `written`, `reading`, and English hint to locate the exact
JMdict entry in `sources/jmdict/JMdict.xml.gz`.

- Require an exact reading match.
- Match the written form when one is supplied; kana-only rows may match a
  reading-only entry.
- If several JMdict entries match, choose only when the N5 meaning clearly
  identifies one. Otherwise abandon the claim and select another word.
- If the resolved `ent_seq` already has an entry file, select another word.
- Preserve the entire resolved JMdict entry, not only the N5-relevant sense.
- Recompute every source fingerprint according to section 13 of
  `docs/org-format.md`; never invent a hash or copy one from another entry.

The Wiktionary meaning and frequency are prioritization hints. Do not copy its
English wording into the entry and do not translate that wording into
Ukrainian. Translate the Japanese concept represented by each JMdict sense,
using JMdict metadata as the semantic guide.

## 4. Create the Org entry

The path is:

```text
entries/<ent_seq divided by 1000>/<ent_seq>-<filename-romaji>.org
```

Use lowercase Modified Hepburn exactly as specified in section 2 of
`docs/org-format.md`. Use `entries/1464/1464530-nihongo.org` as a structural
example, not as text to duplicate.

Write the required metadata in schema order, including:

```org
#+ENTRY_STATUS: draft
#+QUALITY_PROFILE: core
```

Import all JMdict forms, readings, priorities, restrictions, senses, tags,
language sources, references, antonyms, and English/Russian glosses without
editorial rewriting. Attach every Ukrainian gloss to one exact JMdict sense.

For Ukrainian authored content:

- use current Ukrainian orthography and lowercase dictionary equivalents;
- prefer a concise equivalent over a translated English definition;
- separate real synonyms into separate Ukrainian gloss nodes;
- add a short qualifier when required to distinguish senses;
- set `STATUS: draft`, the supplied `TRANSLATOR_ID`, the current date,
  `SOURCE_TYPE: original`, and `LICENSE: CC-BY-SA-4.0`;
- never mark your own work `reviewed`.

## 5. Meet the requested profile

### Core

- Preserve the complete JMdict layer.
- Add at least one responsible Ukrainian draft gloss for every sense.
- Add qualifiers where omission would mislead.
- Omit empty optional learner subsections; do not pad the entry.

### Learner

Meet Core, then add for the main/common sense when relevant:

- one concise Ukrainian distinction or usage note;
- essential grammar, government, register, or politeness guidance;
- one or two original examples containing `JA`, `READING`, and `UK`.

Examples must be natural, independently authored, and no harder than necessary
for an N5 learner. English and romaji are optional. Do not add pitch accent,
audio, collocations, or related-word research merely to make the file look
full; those belong to later Enriched work.

## 6. Validate

At minimum:

1. Run `git diff --check`.
2. Run Emacs `org-lint` on the new entry.
3. Confirm UTF-8, NFC, LF line endings, no tabs, and no trailing whitespace.
4. Check the directory, filename prefix, `JMDICT_ID`, primary reading, romaji,
   stable IDs, source indexes, restrictions, and fingerprints against JMdict.
5. Confirm every authored node has provenance and that no source-only file is
   staged.
6. Review the Ukrainian text for meaning, naturalness, and sense boundaries.

Do not weaken the schema, fabricate missing data, or modify unrelated entries
to make validation pass. If exact reconciliation is not possible, report the
candidate as blocked and select another unambiguous row.

## 7. Handoff and commit boundary

Report:

- N5 `source_order`, written form, and reading;
- resolved JMdict `ent_seq`;
- entry path and achieved quality profile;
- validation performed;
- uncertainties requiring a Ukrainian or Japanese reviewer.

By default, leave the entry uncommitted for the coordinating agent. If and only
if `COMMIT: true` was provided, stage that one entry and commit it alone with a
semantic message such as:

```text
feat: add au core dictionary entry
```

One agent task creates one entry. Do not bundle source downloads, schema edits,
audio generation, or another vocabulary word into the same change.

## 8. Coordinator prompt

Assign a different `SOURCE_ORDER` to each parallel agent. A minimal task is:

```text
Follow docs/n5-entry-agent.md completely.
SOURCE_ORDER: 1
QUALITY_PROFILE: core
TRANSLATOR_ID: <agent-or-contributor-id>
COMMIT: false
Create exactly one entry and report the handoff fields required by the file.
```

For separate worktrees, pre-allocate unique row numbers centrally. For agents
sharing this workspace, either pre-allocate rows or let them use the atomic
ignored claim directories. The coordinator integrates and commits completed
entries one file at a time.
