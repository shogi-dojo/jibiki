# SQLite Export Formats

This document describes the SQLite database schemas exported from the Japanese–Ukrainian learner dictionary.

## 1. Rich Learner Database (`build/jibiki.sqlite`)

The rich database contains all parsed elements of the Japanese–Ukrainian Org entries, including written forms, readings, senses, glosses, grammatical/dialect tags, learner notes, example sentences, and pitch accent data. It is intended as the primary data store for the Android app.

### Metadata Table

The `metadata` table stores key-value pairs describing the build:

| Key | Value Description |
|---|---|
| `SchemaVersion` | Always `1` for the jibiki schema. |
| `GeneratorCommit` | The Git commit SHA of the repository when exported. |
| `GeneratedAt` | UTC timestamp of generation (ISO-8601). |
| `EntryCount` | Number of dictionary entries exported. |
| `License` | The license of the exported data (`CC-BY-SA-4.0`). |
| `Attribution` | Exact license attribution and copyright notices (from the `NOTICE` file). |
| `VocabMappingBase` | Path or description of the base Houhou DB used for mapping (optional). |

### Tables and Schema

#### `entries`
Main entry record containing overall entry status and quality profile:
- `jmdict_id` (INTEGER, Primary Key) - The JMdict sequence number (ent_seq).
- `title` (TEXT) - Display title (first written form or reading).
- `primary_reading` (TEXT) - Primary reading.
- `romaji` (TEXT) - Hepburn romanization search alias.
- `entry_status` (TEXT) - `untranslated`, `draft`, or `reviewed`.
- `quality_profile` (TEXT) - `core`, `learner`, `enriched`, or `gold`.
- `created_at` (TEXT) - ISO-8601 creation date.
- `updated_at` (TEXT) - ISO-8601 last update date.

#### `written_forms`
Alternative kanji/writing forms:
- `id` (TEXT, Primary Key) - Stable wf ID (e.g. `wf-1000320-001`).
- `jmdict_id` (INTEGER) - Foreign key to `entries`.
- `position` (INTEGER) - 1-based order in JMdict.
- `text` (TEXT) - Normalized NFC written form.
- `information` (TEXT) - JSON array of raw info codes (e.g. `['oK']`).
- `priorities` (TEXT) - JSON array of raw priority codes (e.g. `['ichi1']`).

#### `readings`
Kana readings:
- `id` (TEXT, Primary Key) - Stable rd ID (e.g. `rd-1000320-001`).
- `jmdict_id` (INTEGER) - Foreign key to `entries`.
- `position` (INTEGER) - 1-based order in JMdict.
- `text` (TEXT) - Normalized NFC reading.
- `no_kanji` (INTEGER) - 1 if the reading cannot apply to kanji, 0 otherwise.
- `applies_to_written_forms` (TEXT) - JSON array of wf IDs or `['*']`.
- `information` (TEXT) - JSON array of raw info codes.
- `priorities` (TEXT) - JSON array of raw priority codes.

#### `senses`
Semantic divisions:
- `id` (TEXT, Primary Key) - Stable sense ID (e.g. `s-1000320-001`).
- `jmdict_id` (INTEGER) - Foreign key to `entries`.
- `position` (INTEGER) - 1-based order of the sense.
- `source_sense_index` (INTEGER) - Index of the sense in the source JMdict entry.
- `learner_priority` (TEXT) - `'primary'` or NULL.
- `applies_to_written` (TEXT) - JSON array of wf IDs or `['*']`.
- `applies_to_readings` (TEXT) - JSON array of reading strings/IDs or `['*']`.
- `parts_of_speech` (TEXT) - JSON array of POS codes.
- `misc` (TEXT) - JSON array of miscellaneous tags.
- `fields` (TEXT) - JSON array of field codes.
- `dialects` (TEXT) - JSON array of dialect codes.
- `sense_information` (TEXT) - JSON array of sense information comments.

#### `english_glosses`
Original English definitions:
- `sense_id` (TEXT) - Foreign key to `senses`.
- `position` (INTEGER) - 1-based order.
- `text` (TEXT) - Gloss text.
- `gloss_type` (TEXT) - Gloss type (`plain`, `lit`, `fig`, `expl`, etc.).
- `lang` (TEXT) - Language code (always `eng`).
- `gender` (TEXT) - Grammatical gender if applicable.
- *Primary Key*: `(sense_id, position)`

#### `ukrainian_glosses`
Independently authored Ukrainian definitions:
- `id` (TEXT, Primary Key) - Stable uk gloss ID.
- `sense_id` (TEXT) - Foreign key to `senses`.
- `position` (INTEGER) - 1-based order.
- `text` (TEXT) - Ukrainian definition.
- `qualifier` (TEXT) - Context/grammatical notes or NULL.
- `status` (TEXT) - `untranslated`, `draft`, or `reviewed`.
- `translator_id` (TEXT) - Contributor ID.
- `translated_at` (TEXT) - Date of translation.
- `reviewer_id` (TEXT) - Reviewer contributor ID.
- `reviewed_at` (TEXT) - Date of review.
- `source_type` (TEXT) - `original`, `licensed-corpus`, etc.
- `license` (TEXT) - Usually `CC-BY-SA-4.0`.

#### `russian_references`
Original Russian definitions from JMdict:
- `sense_id` (TEXT) - Foreign key to `senses`.
- `position` (INTEGER) - 1-based order.
- `source_sense_index` (INTEGER) - Original sense index.
- `text` (TEXT) - Russian translation.
- *Primary Key*: `(sense_id, position)`

#### `learner_notes`
Pedagogical explanations and notes:
- `id` (TEXT, Primary Key) - Stable note ID.
- `sense_id` (TEXT) - Foreign key to `senses`.
- `position` (INTEGER) - 1-based order.
- `uk` (TEXT) - Ukrainian note text.
- `level` (TEXT) - `beginner`, `intermediate`, or `advanced`.
- `register` (TEXT) - e.g. `neutral`, `colloquial`.
- `status` (TEXT) - note status.
- `author_id` (TEXT) - Contributor ID.
- `created_at` (TEXT) - Date of creation.
- `license` (TEXT) - note license.
- `source_type` (TEXT) - Note source type.

#### `collocations`
Learner collocations:
- `id` (TEXT, Primary Key) - Stable collocation ID.
- `sense_id` (TEXT) - Foreign key to `senses`.
- `position` (INTEGER) - 1-based order.
- `ja` (TEXT) - Japanese collocation.
- `reading` (TEXT) - Kana reading.
- `uk` (TEXT) - Ukrainian translation.
- `pattern` (TEXT) - Grammatical pattern description.
- `register` (TEXT) - register.
- `status`, `author_id`, `created_at`, `license`, `source_type` - Provenance fields.

#### `constructions`
Word constructions and derivatives:
- `id` (TEXT, Primary Key) - Stable ID.
- `sense_id` (TEXT) - Foreign key to `senses`.
- `position` (INTEGER) - 1-based order.
- `relation` (TEXT) - e.g., `derivative`.
- `target` (TEXT) - Target word.
- `target_id` (TEXT) - Optional target JMdict ID.
- `status`, `author_id`, `created_at`, `license`, `source_type` - Provenance fields.

#### `related_words`
Semantic relationships:
- `id` (TEXT, Primary Key) - Stable ID.
- `sense_id` (TEXT) - Foreign key to `senses`.
- `position` (INTEGER) - 1-based order.
- `relation` (TEXT) - e.g. `synonym`, `contrast`.
- `target` (TEXT) - Target word.
- `target_id` (TEXT) - Optional target JMdict ID.
- `status`, `author_id`, `created_at`, `license`, `source_type` - Provenance.

#### `idioms`
Idioms and proverbs:
- `id` (TEXT, Primary Key) - Stable ID.
- `sense_id` (TEXT) - Foreign key to `senses`.
- `position` (INTEGER) - 1-based order.
- `ja` (TEXT) - Japanese idiom.
- `reading` (TEXT) - Reading.
- `uk` (TEXT) - Ukrainian meaning.
- `en` (TEXT) - English meaning.
- `level` (TEXT) - level.
- `register` (TEXT) - register.
- `status`, `author_id`, `created_at`, `license`, `source_type` - Provenance.

#### `examples`
Authored and corpus example sentences:
- `id` (TEXT, Primary Key) - Stable ex ID.
- `sense_id` (TEXT) - Foreign key to `senses`.
- `position` (INTEGER) - 1-based order.
- `ja` (TEXT) - Japanese sentence.
- `reading` (TEXT) - Kana reading.
- `romaji` (TEXT) - Hepburn romanization.
- `uk` (TEXT) - Ukrainian translation.
- `en` (TEXT) - English translation.
- `focus` (TEXT) - Surface form focused on.
- `level` (TEXT) - `beginner`, `intermediate`, or `advanced`.
- `register` (TEXT) - register.
- `status`, `author_id`, `created_at`, `license`, `source_type` - Provenance fields.
- `source_id` (TEXT) - Corpus sentence ID (for licensed/public sentences).
- `source_url` (TEXT) - Source URL.

#### `pitch_accents`
Sourced pitch accent data:
- `id` (TEXT, Primary Key) - Stable accent ID.
- `jmdict_id` (INTEGER) - Foreign key to `entries`.
- `reading_id` (TEXT) - Target reading ID (e.g. `rd-1000320-001`).
- `system` (TEXT) - e.g., `Tokyo`.
- `mora_count` (INTEGER) - Total morae.
- `drop_after` (INTEGER) - Mora count before accent drop (0 for heiban).
- `pattern` (TEXT) - Pitch accent pattern name (e.g. `heiban`, `odaka`).
- `mora_pattern` (TEXT) - String representation of high/low states (e.g. `LHHH`).
- `context` (TEXT) - `lexical`, `isolated`, etc.
- `source_id`, `source_version`, `source_url`, `license` - Source info.
- `status` (TEXT) - `imported`, `reviewed`, etc.
- `verified_at` (TEXT) - Date verified.

#### `vocab_mapping`
Join table linking JMdict sequence IDs (`jmdict_id`) to Houhou-SRS target vocabulary IDs (`vocab_id`):
- `jmdict_id` (INTEGER) - Foreign key to `entries`.
- `vocab_id` (INTEGER) - Foreign key to Houhou's `VocabSet.ID`.
- `writing` (TEXT) - Normalised matching writing.
- `reading` (TEXT) - Normalised matching reading.
- `is_main` (INTEGER) - 1 if primary entry mapping, 0 if secondary.
- *Primary Key*: `(jmdict_id, vocab_id)`

#### `entry_search`
FTS4 Virtual table for lightning-fast text search over entries:
- `jmdict_id` (notindexed) - Entry sequence ID.
- `writings` - Space-joined written forms.
- `readings` - Space-joined readings.
- `romaji` - Romanized alias.
- `uk_glosses` - Space-joined Ukrainian glosses.
- `en_glosses` - Space-joined English glosses.

---

## 2. Houhou Overlay (`build/DictionaryTranslations.sqlite`)

A drop-in replacement for Houhou-SRS's `DictionaryTranslations.sqlite`. The Houhou app
ATTACHes this file and reads from `LocalizedVocabMeaning` and `LocalizedVocabSearchFts`.
Extra tables and extra `Metadata` keys are silently ignored by the app, so this file is
safe to extend.

### Required Tables (verbatim Houhou contract)

```sql
CREATE TABLE Metadata(Key TEXT NOT NULL PRIMARY KEY, Value TEXT NOT NULL);

CREATE TABLE LocalizedVocabMeaning(
    VocabId  INTEGER NOT NULL,
    Language TEXT    NOT NULL,
    Meaning  TEXT    NOT NULL,
    PRIMARY KEY(VocabId, Language, Meaning)
) WITHOUT ROWID;

CREATE INDEX IX_LocalizedVocabMeaning_Language_VocabId
    ON LocalizedVocabMeaning(Language, VocabId);

CREATE VIRTUAL TABLE LocalizedVocabSearchFts USING fts4(
    VocabId, Language, Meanings,
    notindexed=VocabId,
    tokenize=unicode61
);
```

### Metadata Keys

| Key | Value Description |
|---|---|
| `SchemaVersion` | Always `1` (required by Houhou). |
| `UkrainianSource` | Always `jibiki`. |
| `MatchedEntries` | Number of jibiki entries matched to at least one VocabId. |
| `UnmatchedEntries` | Number of jibiki entries with no VocabSet match (reported on stdout). |
| `MeaningCount` | Total number of meaning rows inserted. |
| `GeneratedAt` | UTC timestamp (ISO-8601). |
| `GeneratorCommit` | Git commit SHA at export time. |
| `License` | `CC-BY-SA-4.0` |
| `Attribution` | Full EDRDG attribution text (from `NOTICE`). |
| `MergedFrom` | Basename of the donor overlay (merge mode only). |

### Matching Strategy

VocabId lookup mirrors the reference `build_localized_dictionary.py`:

```
key = [nfkc(COALESCE(NULLIF(KanjiWriting,''), KanaWriting)), hiragana(nfkc(KanaWriting))]
```

Katakana in `KanaWriting` is converted to hiragana (shift −0x60 for codepoints U+30A1–U+30F6).
Both writing and reading are NFKC-normalised. Kana-only entries use the reading as the
effective writing.

### Meaning Format

Each Ukrainian gloss becomes one `LocalizedVocabMeaning` row:
- `Meaning = gloss_text` when no qualifier is present.
- `Meaning = "gloss_text (qualifier)"` when the gloss carries a qualifier (register/style tag).

### FTS Rows

One `LocalizedVocabSearchFts` row is written per `(VocabId, Language)` pair.
The `Meanings` column is the space-joined list of all meanings for that pair.

### Merge Mode

When `--base-overlay PATH` is supplied, the donor overlay's rows are copied first:
- All `Language='ru'` rows are copied unconditionally.
- `Language='uk'` rows for VocabIds **not covered** by jibiki are copied.
- jibiki rows win all conflicts.

This preserves Russian gloss coverage in the single overlay file the Houhou app reads.

### Generating the Overlay

```bash
# Basic export
bundle exec ruby scripts/export_houhou_overlay.rb \
  --base /path/to/KanjiDatabase.sqlite

# With merge to preserve Russian rows
bundle exec ruby scripts/export_houhou_overlay.rb \
  --base /path/to/KanjiDatabase.sqlite \
  --base-overlay /path/to/existing/DictionaryTranslations.sqlite \
  --output build/DictionaryTranslations.sqlite

# Via Rake
bundle exec rake "export:overlay[/path/to/KanjiDatabase.sqlite]"
bundle exec rake "export:all[/path/to/KanjiDatabase.sqlite]"
```
