# Houhou-SRS Integration Notes

This document is for **future Android-app agent developers** working on the Houhou-SRS
Kotlin port (`android-app/`). It explains how the jibiki export pipeline connects to the
app and where to hook in additional features.

---

## Background

Houhou-SRS reads vocabulary glosses from a **separate overlay file**
`DictionaryTranslations.sqlite` that it ATTACHes to the main `KanjiDatabase.sqlite`.
jibiki exports Ukrainian translations to a drop-in replacement of that file.

The contract is defined in
`android-app/.../database/DictionaryDatabase.kt` — the app ATTACHes the overlay as
`localized` and reads three tables:
- `Metadata` — key/value store; `SchemaVersion` must equal `'1'`.
- `LocalizedVocabMeaning` — one row per `(VocabId, Language, Meaning)`.
- `LocalizedVocabSearchFts` — FTS4 virtual table for search; one row per `(VocabId, Language)`.

Extra tables and extra `Metadata` keys are silently ignored → safe to add jibiki-specific
metadata without app changes.

---

## Drop-In Overlay

### Generating

```bash
# Minimal (Ukrainian only, no Russian rows)
bundle exec ruby scripts/export_houhou_overlay.rb \
  --base /path/to/KanjiDatabase.sqlite \
  --output build/DictionaryTranslations.sqlite

# With merge: preserves Russian rows from an existing overlay
bundle exec ruby scripts/export_houhou_overlay.rb \
  --base /path/to/KanjiDatabase.sqlite \
  --base-overlay /path/to/existing/DictionaryTranslations.sqlite \
  --output build/DictionaryTranslations.sqlite
```

### Deploying

Copy `build/DictionaryTranslations.sqlite` to the device location the app reads, e.g.:
```
/sdcard/Android/data/<app.package>/files/DictionaryTranslations.sqlite
```
or into the app's `assets/` folder if bundled at build time.

### Russian coverage

The app ships with a pre-generated overlay that includes Russian (`Language='ru'`) glosses
built from the same Houhou base DB via
`android-app/tools/build_localized_dictionary.py`. Because the app reads **one** overlay
file, any replacement must carry the Russian rows too — use `--base-overlay` to merge them.
jibiki's Ukrainian rows win conflicts for vocab IDs it covers.

---

## Rich DB Join Recipe

The rich learner database (`build/jibiki.sqlite`) contains a `vocab_mapping` table that
bridges JMdict ent_seq values to Houhou `VocabSet.ID` values:

```sql
SELECT vm.vocab_id, e.title, ug.text AS uk_gloss
FROM   vocab_mapping vm
JOIN   entries e       ON e.jmdict_id = vm.jmdict_id
JOIN   senses  s       ON s.jmdict_id = vm.jmdict_id
JOIN   ukrainian_glosses ug ON ug.sense_id = s.id
WHERE  vm.vocab_id = ?   -- Houhou VocabSet.ID
ORDER  BY s.position, ug.position;
```

To join against a live KanjiDatabase:

```sql
ATTACH '/path/to/KanjiDatabase.sqlite' AS houhou;

SELECT vs.KanjiWriting, vs.KanaWriting, ug.text AS uk_gloss
FROM   houhou.VocabSet vs
JOIN   vocab_mapping vm ON vm.vocab_id = vs.ID
JOIN   senses         s  ON s.jmdict_id = vm.jmdict_id
JOIN   ukrainian_glosses ug ON ug.sense_id = s.id
WHERE  vs.KanaWriting = 'わかる';
```

---

## Integration Ideas

### 1. Ukrainian glosses in the detail view
Display `LocalizedVocabMeaning` rows (language=`'uk'`) below the English meanings in the
vocabulary detail screen. The app already queries `LocalizedVocabMeaning` — adding a
`Language='uk'` result set requires only a UI list item.

### 2. Learner notes and qualifiers
`qualifier` in `LocalizedVocabMeaning.Meaning` is appended as `" (qualifier)"`. Parse
the parenthetical and render it as a secondary label or tooltip.

### 3. Example sentences screen
The overlay has no example sentences (Houhou stores none). Use the rich DB's `examples`
table (attached or bundled separately) to add an examples sheet:

```sql
SELECT ex.ja, ex.reading, ex.uk, ex.en
FROM   examples ex
JOIN   senses   s  ON s.id = ex.sense_id
WHERE  s.jmdict_id = ?
ORDER  BY ex.position;
```

### 4. Pitch accent display
The `pitch_accents` table carries `mora_pattern`, `drop_after`, and `pattern` (heiban,
atamadaka, nakadaka, odaka). Render the pitch pattern in the reading line.

### 5. Ukrainian FTS search tab
`LocalizedVocabSearchFts` supports FTS4 `MATCH` queries — add a Ukrainian search tab
that queries `Meanings MATCH ?` and returns matching `VocabId` values to look up.

---

## Licensing

This section is a project-level compatibility assessment, not legal advice.

### Houhou application and overlay format

Houhou-SRS's current upstream [`LICENSE.md`](https://github.com/Doublevil/Houhou-SRS/blob/master/LICENSE.md)
matches the [CC BY-SA 3.0 Unported legal code](https://creativecommons.org/licenses/by-sa/3.0/legalcode.en).
The license file has not been changed upstream since 2014.

An independently generated database does not become an adaptation of Houhou merely
because it uses the table, column, and schema-version contract required for
interoperability. A Ukrainian-only overlay produced from jibiki content therefore has no
Houhou share-alike obligation on account of its *format*. This conclusion assumes the
export does not copy Houhou code, documentation prose, or protected content. Merge mode is
different: `--base-overlay` copies donor rows, so redistributors must separately confirm
and preserve the donor data's provenance and licence.

The Android port in the Houhou repository is derived from the Houhou application, so its
distribution remains subject to Houhou's CC BY-SA 3.0 terms: retain attribution and the
licence notice, identify modifications, and distribute adaptations under CC BY-SA 3.0 or
another licence that version 3.0 permits. Creative Commons itself
[discourages CC licences for software](https://creativecommons.org/faq/#can-i-apply-a-creative-commons-license-to-software),
but that recommendation does not replace the licence already selected by Houhou's
copyright holder.

### CC BY-SA 3.0 application with CC BY-SA 4.0 data

The app and the attached dictionary database remain distinguishable works and may be
distributed together while retaining their respective licences: CC BY-SA 3.0 for the
Houhou-derived app and CC BY-SA 4.0 for jibiki/JMdict-derived data. Do not relabel the
database as 3.0. If the materials are adapted into one inseparable work instead, obtain
project-specific legal review; Creative Commons explains that ShareAlike compatibility is
directional and that adaptations can remain subject to both versions' terms.
See its [ShareAlike compatibility guidance](https://wiki.creativecommons.org/wiki/ShareAlike_compatibility).

Both exporters record `License=CC-BY-SA-4.0` and embed the required notice under
`Attribution` in the output `Metadata` table. Redistributions must keep those values and
the accompanying attribution available.

### CC BY-SA 4.0 attribution obligation

Both the overlay and the rich DB embed the full EDRDG attribution text in their `Metadata`
tables (key `Attribution`). The app's **About screen** must display this text to comply
with the JMdict CC BY-SA 4.0 license. Per `NOTICE`, the acknowledgement must appear within
the application itself; placing it only on a launch page is insufficient.

Minimum required credit line:
> This app uses data from the JMdict/EDICT dictionary file, which is the property of the
> Electronic Dictionary Research and Development Group, and is used in conformance with
> the Group's licence.

The full notice is available in the exported DB:
```sql
SELECT Value FROM Metadata WHERE Key = 'Attribution';
```

---

## Schema Version Compatibility

The overlay's `SchemaVersion` is always `'1'` to match the Houhou contract. jibiki's
own schema version (also `'1'`) is stored in the rich DB's `metadata` table under key
`SchemaVersion`.

If the Houhou contract ever changes (new required table, changed column name), update
`lib/exporters/houhou_overlay.rb`'s `create_schema` method and bump the test that checks
`SchemaVersion`.
