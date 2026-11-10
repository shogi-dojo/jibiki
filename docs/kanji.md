# Canonical kanji records

`kanji/U+XXXX.org` is the editable source of truth for a character. Unicode codepoints identify
records; `uk-U+XXXX-NNN` identifies a Ukrainian translation block throughout proposals and reviews.
The gem exposes `Kanji::Record`, `Writer`, `Validator`, `Exporter`, and `Importer` via `require 'kanji'`.

KANJIDIC2 metadata lives in the Source section. Its SHA-256 fingerprint covers readings, meanings,
stroke count, grade, and frequency. Ukrainian edits do not change that fingerprint. Source refreshes
preserve translations and reviewers. KanjiVG paths are imported separately into the application's
content database, in source document order; absent paths never suppress character metadata.
Archives, versions, checksums and attribution are recorded in `sources/kanji/MANIFEST.json`.
KANJIDIC2 data is CC BY-SA 4.0; KanjiVG paths are CC BY-SA 3.0. See NOTICE.

## Ukrainian drafts and coverage

The snapshot contains 13,108 records. The 10,384 characters with English source meanings have
Ukrainian drafts, with `DRAFT_ORIGIN: codex` and the original `DRAFT_SOURCE_FINGERPRINT` recorded.
No generated draft is reviewed. The remaining 2,724 characters have no English source meaning;
the source-gap inventory in `drafts/kanji/placeholders.tsv` is never applied as translation text.
These characters remain available with their readings and other metadata. They may receive human
translations through proposals, but source gaps are not counted as translated characters.

```sh
bundle exec rake test
bundle exec rake kanji:validate
ruby scripts/kanji_drafts.rb coverage
ruby scripts/kanji_drafts.rb validate
ruby scripts/kanji_drafts.rb dump 0 300
ruby scripts/kanji_drafts.rb apply
ruby scripts/import_kanji.rb
```

Draft batches use UTF-8 `U+XXXX<TAB>text` rows. Duplicate codes, unknown records, and malformed
codes are errors. Applying batches skips any record with reviewed translations, preserves stable
block IDs, and is repeatable. `validate` checks records and verifies that every character with
source meanings has a batch or reviewed translation. A source fingerprint change is an editorial
review signal; drafts must be compared with the new source before regeneration.

## Web contribution contract

The application submits translation add/edit/remove/confirm requests against the SHA-256 of the
current public Org record. Edits and removals retain the previous text for conflict detection.
A confirmation request is pending until an authorized moderator approves it; only then is the
reviewer written. Approved changes are immediately overlaid in the app, then synced back to the
canonical Org file through the existing contribution PR process. The Contributions check validates
changed kanji records as well as word records.

## Faster local iteration

Reuse `rake test:fast` from the [jb performance work (PR #39)](https://github.com/shogi-dojo/jibiki/pull/39) for focused edits. It excludes only the two word-corpus round-trip tests; `rake test` remains the release gate and includes all kanji tests. The native jb CLI remains in that independent PR: it currently handles word records, not canonical kanji records, and its binary is specific to the checkout where it was built. Do not copy a binary from another checkout.
