# N1 1000-word goal completion audit

Completed on 2026-10-13. Baseline: `6a973e0f1beb5d0d8daed77e702e10994d2f99a3`.

The [ledger](n1-goal1000-2026-10-11.tsv) contains exactly 1000 distinct JMdict IDs and entry paths, all absent at the baseline, organized into 100 batches of 10. Every selected word has its own addition commit. Git's net added entry files match the ledger exactly. The previous 500-word goal ledger is unchanged. The [two documented homonym corrections](n1-goal1000-identity-corrections.json) exclude the retired incorrect entry from the final count.

All source rows, N1 deck labels, GUIDs, tags, and the archived CSV SHA-256 were checked against the archived Egg rolls JLPT10k deck. N1 is the community study-list classification. Only identities, readings, and tags were taken from that deck.

The completed entries contain 1738 independently authored Ukrainian gloss blocks and 1738 usage notes, covering every English JMdict sense. Each has three graded original examples with kana and Ukrainian translations: 3000 distinct Japanese sentences total, none present in the archived deck text. Every contextual third example has at least 53 Japanese characters. All entries retain original attribution to codex, CC-BY-SA-4.0, the learner quality profile, and draft status pending independent linguistic review.

Final verification covered all 1000 entries: JMdict validation and Org lint passed; doctor reported 1000/1000 passing, average health 100, zero errors and warnings. A fresh canonical audit verified forms, readings, sense restrictions, source fingerprints, and original JMdict glosses. The repository suite passed 154 tests and 35234 assertions with zero failures, errors, or skips.

The two pre-existing untracked files were left untouched. No push or pull request was requested.
