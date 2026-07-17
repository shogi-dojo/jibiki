# Org format for the Japanese-Ukrainian dictionary

Status: schema version 1 draft
Canonical encoding: UTF-8, Unicode NFC, LF line endings

This document defines the constrained Org Mode subset used for authored
dictionary entries. It is intentionally narrower than general Org Mode: files
must remain comfortable to edit in Emacs, but every meaningful value must also
round-trip through a strict Ruby parser without guesswork.

The format has two complementary layers:

1. A lossless JMdict layer preserves imported spellings, readings, senses,
   tags, restrictions, references, loanword sources, and English glosses.
2. A learner layer contains independently authored Ukrainian translations,
   explanations, collocations, examples, pronunciation data, and licensed
   media.

Do not translate or adapt Warodai or the Bondarenko-Hino PDF. They may be used
privately to compare coverage and editorial conventions only. Every published
Ukrainian text must have its own provenance.

## 1. Design principles

- One JMdict `entry` is one Org file.
- JMdict `ent_seq` is the permanent entry identity.
- Each repeated value is a separate list item or child heading.
- Imported data and authored data are visibly separate.
- Every authored enrichment has a stable local ID, author, source type, and
  licence.
- A Ukrainian translation is attached to one exact dictionary sense.
- Missing data is not fabricated. An empty optional section means “none
  recorded yet,” not “verified absent.”
- Binary audio and images are not embedded in Org. Org stores references and
  metadata; applications resolve the assets.
- Romaji is a search aid, never the authoritative pronunciation.
- Generated JSON, SQLite, indexes, search aliases, and app records are not
  edited by hand.

## 2. File location and filename

Use:

```text
entries/<ent_seq divided by 1000>/<ent_seq>-<romaji>.org
```

For JMdict entry `1464530`, whose primary reading is `にほんご`:

```text
entries/1464/1464530-nihongo.org
```

The numeric prefix is authoritative and unique. The romaji suffix is a
deterministic fuzzy-finder alias. A filename must still resolve correctly when
two entries have the same reading because their numeric IDs differ.

Filename romaji uses lowercase Modified Hepburn:

- Long vowels are expanded with ASCII letters: `とうきょう` -> `toukyou`.
- Syllabic `ん` is `n`; before a vowel or `y`, use an apostrophe in display
  romaji but remove punctuation in filenames: `しんよう` -> `shin'you` for
  display and `shinyou` in a filename.
- Small `っ` doubles the following consonant: `がっこう` -> `gakkou`.
- Particles do not receive pronunciation exceptions in filenames; transliterate
  their dictionary reading literally.
- Characters not covered by the transliterator cause validation failure rather
  than being silently removed.

Renaming the romaji suffix does not change entry identity. Links and databases
must use `JMDICT_ID`, not the path.

## 3. Allowed Org syntax

Entry files may contain only:

- file keywords in the form `#+KEY: value`;
- headings beginning with one or more `*` characters;
- property drawers immediately below their owning heading;
- unordered list items beginning with `- `;
- descriptive list items in the form `- LABEL :: value`;
- blank lines;
- comments beginning with `# `, outside drawers and value blocks.

Tables, source blocks, inline macros, tags, TODO keywords, footnotes, includes,
radio targets, and arbitrary drawers are not part of schema version 1.

Heading depth is semantic. A heading must not skip a level.

## 4. Text, whitespace, and escaping

- Files must be valid UTF-8 and normalized to NFC.
- Line endings must be LF.
- Leading and trailing whitespace in scalar values is forbidden.
- Tabs are forbidden in Org entries.
- A scalar value normally occupies one physical line.
- Literal `::` is allowed inside a descriptive-list value; only the first
  whitespace-delimited ` :: ` separates label from value.
- Empty list items are forbidden.
- Duplicate scalar properties in one drawer are forbidden.
- Repeated semantic values must use repeated list items, not repeated drawer
  keys and not comma-packed text.

Multiline prose uses a child heading with one or more paragraph list items:

```org
** Usage notes
- First paragraph.
- Second paragraph.
```

Each list item is one paragraph. A parser joins wrapped physical continuation
lines with a single space. A continuation line must be indented by two spaces.
Hard line breaks inside a value are not semantically significant.

## 5. File-level metadata

Every entry begins with these keywords in this order:

```org
#+TITLE: 日本語
#+JMDICT_ID: 1464530
#+SCHEMA_VERSION: 1
#+PRIMARY_READING: にほんご
#+ROMAJI: nihongo
#+ENTRY_STATUS: draft
#+JMDICT_SOURCE_SHA256: <64 lowercase hexadecimal characters>
```

Rules:

- `TITLE` is the preferred display form. Use the first JMdict written form; for
  a kana-only entry, use the primary reading.
- `JMDICT_ID` is the decimal `ent_seq` and must match the filename prefix.
- `SCHEMA_VERSION` is currently `1`.
- `PRIMARY_READING` selects one reading for display and filename generation.
- `ROMAJI` is generated from `PRIMARY_READING`, but is stored for convenient
  Emacs and shell searching. Validation must recompute it.
- `ENTRY_STATUS` is `untranslated`, `draft`, or `reviewed`.
- `JMDICT_SOURCE_SHA256` identifies the complete imported JMdict archive used
  for reconciliation.

Optional file keywords:

```org
#+CREATED_AT: 2026-07-17
#+UPDATED_AT: 2026-07-17
```

Dates use ISO 8601. Generated exporters may replace `UPDATED_AT`; translators
must not use it as a review record.

## 6. Required top-level order

Top-level headings occur at most once and in this order:

```org
* Forms
* Sense s-<ent_seq>-<three digits>
* Pronunciation
* Media
* Entry notes
```

There must be one `Forms` heading and at least one `Sense` heading.
`Pronunciation`, `Media`, and `Entry notes` are optional.

## 7. Forms

### 7.1 Written forms

Each JMdict `k_ele` becomes one heading:

```org
** Written form wf-1464530-001
:PROPERTIES:
:TEXT: 日本語
:END:
*** Information
*** Priorities
- news1
- nf02
```

- `TEXT` preserves `keb` exactly after NFC normalization.
- `Information` contains one raw JMdict `ke_inf` code per item.
- `Priorities` contains one raw `ke_pri` code per item.
- Empty `Information` and `Priorities` headings are allowed.
- A kana-only entry has no `Written form` headings.

### 7.2 Readings

Each JMdict `r_ele` becomes one heading:

```org
** Reading rd-1464530-001
:PROPERTIES:
:TEXT: にほんご
:NO_KANJI: false
:END:
*** Applies to written forms
- *
*** Information
*** Priorities
- news1
- nf02
```

- `TEXT` preserves `reb`.
- `NO_KANJI` is `true` exactly when JMdict has `re_nokanji`.
- `Applies to written forms` contains `*` when there are no `re_restr`
  elements; otherwise it contains referenced written-form IDs, one per item.
- `Information` preserves raw `re_inf` codes.
- `Priorities` preserves raw `re_pri` codes.
- Every entry has at least one reading.

IDs are assigned in JMdict source order and never reused inside an entry.

## 8. Senses

Each semantic sense is represented by a stable local sense heading:

```org
* Sense s-1464530-001
:PROPERTIES:
:SOURCE_SENSE_INDEX: 1
:SOURCE_FINGERPRINT: <sha256>
:END:
```

JMdict does not provide permanent sense IDs. The local ID remains stable during
reconciliation. `SOURCE_SENSE_INDEX` records the current source position, while
`SOURCE_FINGERPRINT` detects edits or reordering.

Required sense subsections, in order:

```org
** Applies to forms
** JMdict metadata
** English glosses
** Ukrainian glosses
** Russian reference
** Learner notes
** Collocations
** Constructions and derivatives
** Related words
** Idioms and proverbs
** Examples
```

All are present even when empty. This produces predictable folding in Emacs
and prevents accidental placement of an enrichment under the wrong sense.

### 8.1 Sense restrictions

```org
** Applies to forms
*** Written forms
- *
*** Readings
- *
```

Use `*` when unrestricted. Otherwise list stable `wf-...` or `rd-...` IDs.
These preserve JMdict `stagk` and `stagr` without copying fragile display text.

### 8.2 JMdict metadata

```org
** JMdict metadata
*** Parts of speech
- n
*** Fields
*** Miscellaneous and register
*** Dialects
*** Sense information
*** Cross-references
*** Antonyms
*** Language sources
```

Raw JMdict codes are canonical. Human-readable Ukrainian labels are generated
from a versioned tag catalogue and are not written into every entry.

`Cross-references` and `Antonyms` initially preserve the original JMdict text.
When resolved, use:

```org
- target :: 1234560#s-1234560-002
- source-text :: 書く・かく・2
```

One reference is one child heading if it needs both fields. Never discard the
source text after resolution.

A language source is a child heading because it has attributes:

```org
*** Language source ls-s-1234560-001-001
:PROPERTIES:
:LANG: eng
:TYPE: full
:WASEI: false
:END:
- text :: computer
```

The text may be empty. `LANG` defaults to `eng`, `TYPE` to `full`, and `WASEI`
to `false`, but the normalized Org form writes all three explicitly.

### 8.3 English glosses

Every JMdict English gloss is independently addressable:

```org
*** en-s-1464530-001-001
:PROPERTIES:
:LANG: eng
:TYPE: plain
:GENDER: none
:PRIMARY: false
:END:
- text :: Japanese (language)
```

`TYPE` is `plain` when `g_type` is absent; otherwise preserve the JMdict value
such as `lit`, `fig`, or `expl`. `GENDER` and `PRIMARY` preserve `g_gend` and
nested `pri` information.

### 8.4 Ukrainian glosses

Each Ukrainian equivalent is a reviewed unit rather than an anonymous bullet:

```org
*** uk-s-1464530-001-001
:PROPERTIES:
:STATUS: draft
:TRANSLATOR_ID: codex
:TRANSLATED_AT: 2026-07-17
:REVIEWER_ID:
:REVIEWED_AT:
:SOURCE_TYPE: original
:LICENSE: CC-BY-SA-4.0
:END:
- text :: японська мова
- qualifier :: neutral
```

Rules:

- `STATUS` is `untranslated`, `draft`, or `reviewed`.
- `TRANSLATOR_ID` and `REVIEWER_ID` refer to a future contributor registry.
- A person must not review their own translation for a `reviewed` state.
- `text` is a concise Ukrainian equivalent, not an English sentence translated
  word-for-word.
- `qualifier` is optional and may record register, domain, grammatical case
  behavior, or a short disambiguator.
- Several Ukrainian glosses are separate headings, not synonyms separated by
  commas.
- Ukrainian typography follows current Ukrainian orthography; dictionary
  glosses begin lowercase unless inherently capitalized.

### 8.5 Russian reference

Russian JMdict glosses may be retained for translators but are never a source
to be mechanically translated. A reference records its original JMdict sense:

```org
*** ru-ref-1464530-001
:PROPERTIES:
:SOURCE_SENSE_INDEX: 5
:END:
- text :: японский язык
```

Applications may hide this section from ordinary learners.

## 9. Learner enrichments

Every enrichment child heading has a stable ID and this provenance drawer:

```org
:PROPERTIES:
:SOURCE_TYPE: original
:AUTHOR_ID: codex
:LICENSE: CC-BY-SA-4.0
:CREATED_AT: 2026-07-17
:STATUS: draft
:END:
```

Allowed `SOURCE_TYPE` values are `original`, `licensed-corpus`, `public-domain`,
and `external-reference`. An `external-reference` may link to information but
must not reproduce protected text.

### 9.1 Learner notes

Use separate items for distinct pedagogical facts:

```org
*** note-s-1464530-001-001
<provenance drawer>
- UK :: У конструкції 日本語で частка で позначає мову спілкування.
- LEVEL :: beginner
- REGISTER :: neutral
```

`LEVEL` is `beginner`, `intermediate`, or `advanced`. It is editorial guidance,
not a JLPT claim.

### 9.2 Collocations

```org
*** col-s-1464530-001-001
<provenance drawer>
- JA :: 日本語を話す
- READING :: にほんごをはなす
- UK :: говорити японською
- PATTERN :: 日本語を + verb
- REGISTER :: neutral
```

Collocations are conventional combinations, not full example sentences.

### 9.3 Constructions and derivatives

Use this section for productive patterns and derived lexemes. Record the exact
relationship:

```org
- RELATION :: derivative
- TARGET :: 日本語学
```

When a target has a JMdict entry, also record `TARGET_ID`.

### 9.4 Related words

Use typed relationships such as `synonym`, `near-synonym`, `contrast`,
`transitive-pair`, `intransitive-pair`, `formal-alternative`, or
`colloquial-alternative`. A learner note should explain important differences;
do not present near-synonyms as interchangeable.

### 9.5 Idioms and proverbs

Idioms use the same provenance requirements as examples. Provide literal and
idiomatic Ukrainian explanations separately when useful.

## 10. Examples

Each example belongs to one sense:

```org
*** ex-1464530-001-001
:PROPERTIES:
:SOURCE_TYPE: original
:SOURCE_ID:
:SOURCE_URL:
:AUTHOR_ID: codex
:LICENSE: CC-BY-SA-4.0
:CREATED_AT: 2026-07-17
:STATUS: draft
:LEVEL: beginner
:REGISTER: neutral
:END:
- JA :: 日本語を勉強しています。
- READING :: にほんごをべんきょうしています。
- ROMAJI :: Nihongo o benkyou shite imasu.
- UK :: Я вивчаю японську мову.
- EN :: I am studying Japanese.
- FOCUS :: 日本語
```

Rules:

- `JA`, `READING`, and `UK` are required.
- `EN`, `ROMAJI`, and `FOCUS` are optional but recommended for beginner-facing
  entries.
- `READING` must preserve word boundaries only if a future tokenizer specifies
  them; version 1 stores continuous kana.
- `ROMAJI` is sentence-initially capitalized Modified Hepburn for display.
- `FOCUS` gives the exact surface form demonstrated in the sentence.
- At least three examples are recommended for common polyfunctional words: a
  minimal beginner example, a typical neutral example, and a context-rich
  intermediate example.
- Corpus examples require the corpus sentence ID, URL when available, exact
  licence, and attribution. Audio licensing is tracked separately.
- Do not assume a sentence licence also covers attached audio.

## 11. Pronunciation and pitch accent

JMdict readings do not encode pitch accent. Accent data is optional and must
have an independent source:

```org
* Pronunciation
** Accent accent-rd-1464530-001-001
:PROPERTIES:
:TARGET_ID: rd-1464530-001
:SYSTEM: Tokyo
:MORA_COUNT: 4
:DROP_AFTER: 0
:PATTERN: heiban
:SOURCE_ID: <source catalogue ID>
:SOURCE_URL: <URL>
:LICENSE: <licence>
:VERIFIED_AT: 2026-07-17
:END:
```

`DROP_AFTER: 0` means no lexical drop (heiban). Accent can vary by region,
speaker, compound context, and inflection, so multiple sourced patterns are
allowed. Never infer an accent pattern from audio without marking it as an
unreviewed analysis.

## 12. Audio and other media

Jisho demonstrates the value of word audio and example search, but its audio
provider relationship does not grant this project redistribution rights. This
dictionary accepts audio only when the individual asset has a compatible,
recorded licence.

```org
* Media
** Audio audio-rd-1464530-001-001
:PROPERTIES:
:TARGET_TYPE: reading
:TARGET_ID: rd-1464530-001
:SOURCE_ID: <source catalogue ID>
:SOURCE_URL: <original asset URL>
:FILE: assets/audio/<source>/<asset-id>.ogg
:MIME: audio/ogg
:LICENSE: <licence>
:SPEAKER_ID: <speaker or voice ID>
:SPEAKER_REGION: Tokyo
:RECORDING_TYPE: human
:RECORDED_AT:
:VERIFIED_AT: 2026-07-17
:END:
- text :: 日本語
- reading :: にほんご
```

`TARGET_TYPE` is `reading`, `example`, or `note`. `RECORDING_TYPE` is `human`
or `tts`. For TTS, record engine name, model/version, voice, generation date,
and distribution terms. A URL alone is not permission to redistribute.

Allowed canonical audio formats are Ogg Vorbis/Opus and MP3. Exporters may
transcode only when the source licence permits derivatives. Checksums belong in
an asset manifest rather than every entry.

Stroke-order diagrams, kanji metadata, and images follow the same source and
licence rules. Prefer joining KANJIDIC2 and KanjiVG during export instead of
duplicating their data inside every vocabulary entry.

## 13. Source fingerprints

`SOURCE_FINGERPRINT` is SHA-256 over UTF-8 bytes of compact canonical JSON.
The JSON object uses this exact key order:

```text
ent_seq, sense_index, stagk, stagr, pos, xref, ant, field, misc,
s_inf, lsource, dial, gloss, example
```

Rules:

- Strings are NFC.
- Arrays preserve JMdict source order.
- Missing repeatable elements are empty arrays.
- `lsource` objects use key order `lang`, `type`, `wasei`, `text` and write
  explicit defaults.
- `gloss` objects use key order `lang`, `type`, `gender`, `primary`, `text` and
  write explicit defaults.
- `example` objects preserve source identifiers, focus text, and sentences with
  explicit language codes.
- JSON uses no insignificant whitespace and ends without a newline.
- Entity names such as `n` are hashed as stable JMdict codes, not expanded
  English descriptions.

Changing only Ukrainian authored content does not change the source
fingerprint. Any imported source change forces reconciliation before the sense
may remain `reviewed`.

## 14. Unknown future JMdict data

An importer must never silently discard an element or attribute it does not
understand. It must:

1. preserve the entry's original XML fragment in an import cache;
2. write the unknown name and value under `JMdict metadata / Unknown source
   data`;
3. emit a validation warning containing the file, sense, and source name;
4. block `reviewed` status until the schema mapping is decided.

Unknown raw data is not exported as if it were a understood public field.

## 15. Comments and empty sections

- Comments may explain editorial decisions but are not application data.
- A parser ignores lines beginning with `# `.
- Comments must not be used to store translations, source IDs, or licences.
- Required section headings remain present when empty.
- Optional top-level `Pronunciation`, `Media`, and `Entry notes` headings may be
  omitted when they contain no data.
- `STATUS: untranslated` is explicit workflow data and is not represented by an
  empty Ukrainian section alone.

## 16. Editable and generated fields

Authored in Org:

- Ukrainian glosses and explanations;
- learner notes, collocations, constructions, relationships, and examples;
- contributor and review metadata;
- licensed pronunciation and media references.

Imported but not casually edited:

- IDs, forms, readings, restrictions, JMdict metadata, English glosses,
  Russian reference, source indexes, and fingerprints.

Generated elsewhere:

- romaji validation aliases;
- resolved cross-reference IDs;
- inherited JMdict POS/display labels;
- frequency ranks from external corpora;
- JLPT and kanji details;
- JSON, SQLite, search indexes, and app-specific records.

Manual edits to imported fields must be rejected unless performed through an
explicit reconciliation command that records the reason.

## 17. Ordering and stable IDs

- Preserve JMdict source order for forms, readings, senses, tags, and glosses.
- Preserve authored order for Ukrainian glosses and learner enrichments.
- Numeric suffixes are three digits and never renumbered merely to close gaps.
- Deleted local IDs are not reused.
- Moving an item does not change its ID.
- A source item that changes substantially keeps its local ID only after
  explicit reconciliation.

ID prefixes:

| Prefix | Meaning |
|---|---|
| `wf-` | written form |
| `rd-` | reading |
| `s-` | sense |
| `en-` | English gloss |
| `uk-` | Ukrainian gloss |
| `ru-ref-` | Russian source reference |
| `note-` | learner note |
| `col-` | collocation |
| `con-` | construction or derivative |
| `rel-` | related-word relation |
| `idiom-` | idiom or proverb |
| `ex-` | example |
| `accent-` | pitch-accent record |
| `audio-` | audio record |

## 18. Validation requirements

A strict validator must reject:

- invalid UTF-8 or non-NFC text;
- CRLF, tabs, trailing whitespace, and malformed headings;
- a path that disagrees with `JMDICT_ID` or `ROMAJI`;
- unknown or duplicated required headings/properties;
- duplicate stable IDs;
- missing readings or senses;
- invalid restrictions or references to nonexistent local IDs;
- unknown workflow states;
- a reviewed gloss without translator, independent reviewer, and dates;
- an enrichment without author, source type, and licence;
- media without source and licence;
- a stale source fingerprint;
- unknown JMdict data that was discarded;
- malformed locale codes, dates, hashes, MIME types, or asset paths.

Validation should warn, but not necessarily reject, when a common entry lacks
learner notes, three varied examples, pitch accent, or audio. Content coverage
quality and structural validity are different concerns.

## 19. Recommended learner completeness

A high-quality common-word entry should eventually have:

- every JMdict form, reading, sense, restriction, and tag;
- one or more reviewed Ukrainian glosses per sense;
- a short Ukrainian distinction note where English glosses are ambiguous;
- government/case patterns for verbs and adjectives;
- two to five frequent collocations;
- at least three independently authored or compatibly licensed examples;
- readings and optional display romaji for beginner examples;
- register and politeness guidance where relevant;
- links to confusingly similar or contrasting words;
- sourced Tokyo pitch accent when available;
- at least one compatibly licensed human recording or clearly labelled TTS
  recording when available.

“Complete” never means filling fields with guesses. A visible, tracked gap is
better than unsourced data.

## 20. External source architecture

Follow the modular pattern used by mature learner dictionaries:

- JMdict: vocabulary identity and semantics;
- JMnedict: names, kept separate from ordinary vocabulary;
- KANJIDIC2: kanji readings and metadata;
- KanjiVG: stroke order, subject to its licence;
- Tatoeba or another corpus: examples, only with sentence-level attribution and
  compatible licences;
- an approved accent source: pitch accent;
- approved human recordings or redistributable TTS: audio;
- BCCWJ frequency tables: translation prioritization and frequency context,
  used according to their research/education and redistribution terms;
- independently authored Ukrainian editorial content: the public learner layer.

Jisho is a useful product reference, not a source to scrape. Its About page
attributes vocabulary to JMdict, kanji data to KANJIDIC2/Radkfile, names to
JMnedict, examples to Tatoeba, and audio to WaniKani. This project records those
concerns independently so one provider's licence never leaks into another
field.
