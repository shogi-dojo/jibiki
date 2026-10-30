# Next 1000-word vocabulary goal completion audit

Completed on 2026-10-18. Baseline: `16ac8d34675fd5a7b0ee7006e4d69fd271906cfa`.

The [ledger](n1-next1000-2026-10-13.tsv) contains exactly 1000 distinct JMdict IDs and entry paths, all absent at the baseline, organized into 100 batches of 10. Every selected word has its own atomic addition commit. Git's net added entry files match the ledger exactly.

All source rows, deck labels, GUIDs, tags, and archived source SHA-256 hashes were checked and verified against the candidate sources:
- Egg rolls JLPT10k N1: 288
- Open Anki N1: 2
- Wiktionary N1: 142
- Egg rolls JLPT10k N2: 309
- Egg rolls JLPT10k N3: 175
- Egg rolls JLPT10k N4: 45
- Egg rolls JLPT10k N5: 39

The completed entries contain 1,703 independently authored Ukrainian gloss blocks and 1,703 usage notes, covering every English JMdict sense. Each primary sense has three graded original examples with pure-kana readings and natural Ukrainian translations: 3,000 distinct Japanese sentences in total, none duplicated or present in source deck texts. Every contextual third example has at least 53 Japanese characters. All entries retain original attribution to codex, CC-BY-SA-4.0 license, learner quality profile, and draft status pending independent linguistic review.

Final verification covered all 1000 entries:
- JMdict validation and Org lint: 0 errors
- Doctor health checks: 1000/1000 passing with 100.0/100 average health score, 0 errors, 0 warnings
- Canonical derived audit: preserved derived JMdict forms, readings, senses, restrictions, and glosses
- Full content audit: 1000 entries, 1703 glosses, 1703 notes, 3000 distinct original sentences
- Repository test suite: 155 runs, 38,239 assertions, 0 failures, 0 errors, 0 skips

The two pre-existing untracked files (`entries/1296/1296680-tsumi.org` and `scripts/find_next_100_candidates.rb`) remain untouched.
