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

The snapshot contains 13,108 records. The 10,423 characters with direct or canonically referenced English source meanings have
Ukrainian drafts, with `DRAFT_ORIGIN: codex` and the original `DRAFT_SOURCE_FINGERPRINT` recorded.
No generated draft is reviewed. The remaining 2,685 characters have no English source meaning;
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

Reuse `rake test:fast` from the [jb performance work (PR #39)](https://github.com/shogi-dojo/jibiki/pull/39) for focused edits. It excludes only the two word-corpus round-trip tests; `rake test` remains the release gate and includes all kanji tests. The merged native jb CLI is reused here: it currently handles word records, not canonical kanji records, and its binary is specific to the checkout where it was built. Do not copy a binary from another checkout.

## Editorial verification (2026-11-10)

Development and audit tooling pin Yanagi 0.3.2 at `ed2226111babf742195bb4b6c2c2f85bd6961ae2`,
the same revision as the app. RubyGems currently supplies only 0.1.0, so the Git source is explicit.
`bundle exec ruby scripts/audit_kanji_drafts.rb` checks every record with the committed
`drafts/kanji/audit-policy.json`: Japanese anchors, documented native Ukrainian exceptions, missing
translations, metadata-only text and Russian-only letters. Its JSON output is advisory; it never
changes translations or marks them reviewed. A zero finding count is not semantic verification.
The complete result is recorded in `drafts/kanji/reviews/2026-11-10-audit.json`.

The correction ledger records original/new text, English source meanings, source fingerprint and
AI verification scope. It covers direct source comparison of the 250 most frequent characters
with more than four source glosses, metadata-only drafts and suspicious generic translations.
The `dump` command now emits ALL source meanings: the earlier four-gloss truncation made drafts
incomplete. Remaining meanings and specialist botanical/zoological terms still need editorial review.
All translations remain drafts, with no human reviewer recorded.

For 39 originally empty records, Unicode NFC identifies a canonically equivalent character with
meanings in the same pinned KANJIDIC2 archive. Import copies only its meanings, retains this
character's readings/strokes, and records `SOURCE_MEANINGS_REFERENCE` plus the raw upstream
`KANJIDIC2_SOURCE_FINGERPRINT`. Its effective source fingerprint includes the referenced meanings.
An upstream meaning takes precedence if supplied later; source refreshes keep reviewed translations.
This uses canonical equivalence, never a shape guess or an NFKC fold. These 39 records have drafts
in `batch-035.tsv`. The remaining 2,685 source gaps are explicitly untranslated.
