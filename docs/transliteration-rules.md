# Transliteration Rules

## Policy

When transliterating or writing Japanese words and readings in Ukrainian,
**DO NOT use the Polivanov system**. Transliterate by actual Japanese
pronunciation: **ші**, **чі**, **джі**, **ґ**, **дз** — never сі, ті, дзі, г, з.

*Examples*: **шьоґі** (not шогі/сьогі), **ґо** (not го), **шьоґун**
(not сьогун/шогун), **суші** (not сусі), **чібі** (not тібі), **чян** (not тян).

## Single source of truth

The full policy — the mora table, palatalised syllables (yōon), the syllabic
nasal ん, sokuon っ, long vowels, and the go/shōgi terminology minimum — lives in
one place, shared by this repo and the translation projects:

> **`meijin/shared/transliteration.md`**

Do not restate the rules here. This file previously carried a condensed copy
that drifted from the authoritative doc and contradicted it on long vowels;
that copy has been removed rather than corrected, so there is exactly one
policy document.

## Enforcement

The policy is executable, not advisory. The [`yanagi`](https://github.com/shogi-dojo/yanagi)
gem owns the kana→romaji and kana→Cyrillic engines used by this repo
(`scripts/validate_entry.rb`, `lib/exporters/houhou_vocab_matcher.rb`) and
validates the rules data against the authoritative doc:

```bash
yanagi cyrillic しゅうさい      # => шюсай
yanagi doc-sync  <path-to-transliteration.md>
yanagi verify-gold
```

**Mandatory action**: every agent working on glosses, examples, or any
Ukrainian text must follow the policy above. Do not fall back to
Russian-influenced (Polivanov) transliteration.
