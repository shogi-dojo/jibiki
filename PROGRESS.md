# Dictionary entry progress

This is the merge ledger for the authored dictionary. It records what exists,
what has actually been reviewed, and what may be described as release-ready.
It must not be used to infer linguistic approval merely because an entry passes
the automated JMdict and Org checks.

Last reconciled with the tracked entry tree: **2026-10-04**.
Uncommitted drafts are excluded from the snapshot.

## Schema flag day (2026-07-17)

All 291 entries were mechanically migrated from schema v1 to schema v2 in
commit `2b8d5cc` (`scripts/migrate_schema_v2.rb`, with a built-in
before/after content-preservation check — zero content loss across all 291
files). Schema v2 (`docs/org-format.md`) adds omit-when-empty list
subsections, file-level provenance defaults (`#+DEFAULT_*`), compact English
gloss / Russian reference syntax, and a sense-level `:LEARNER_PRIORITY:
primary` property with a structural 3-graded-example validator requirement
(`9fd4201`). Total `entries/` line count dropped from 96,518 to 55,334
(~43%); a typical entry is now roughly a third of its former size (e.g.
音楽/ongaku 156→108 lines). The new canonical generator is
`scripts/scaffold_entry.rb` (`rake "entries:scaffold[order,romaji,level]"`),
replacing the old `scratch/gen_n5_part*.py` one-off scripts. Migration
surfaced 11 entries (the `codex-agent-N` batch) whose `LEARNER_PRIORITY`
sense failed the new example-count gate; all 15 affected senses have since
been brought to three graded examples and the full gate is green. One
defective example was replaced in the process: 開く(あく) sense 3 carried
お腹が空きました read すきました, which belongs to the separate JMdict entry
空く(すく) and taught the wrong reading for あく.

## Snapshot

| Metric | Current |
| --- | ---: |
| Canonical entry files | 5563 |
| Canonical N5 entries | 656 |
| N5 queue rows covered | 667 / 667 (100.0%) |
| Canonical N4 entries | 712 |
| N4 queue rows covered | 724 / 724 (100.0%) |
| Canonical N2 entries | 2591 |
| Canonical N3 entries | 1603 |
| N2 queue rows covered | 1634 / 1635 (99.9%) |
| N3 queue rows covered | 1675 / 1677 (99.9%) |
| Extra seed entries | 1 (`日本語`) |
| `new` | 5526 |
| `changes-requested` | 0 |
| `reviewed` | 9 |
| `confirmed` | 28 |
| `solid` | 0 |
| Entry metadata still marked `draft` | 5553 |
| Core profile | 163 |
| Learner profile | 5399 |
| Enriched profile | 1 |

All 667 N5 queue rows and all 724 N4 queue rows are represented. JLPT N3 queue has 1675 rows covered (1671 distinct tracked files, including entries shared with other levels) out of 1677.
Coverage reaches N3-1677 with N3-1084 and N3-1191 excluded: the previous agent left
`entries/1296/1296680-tsumi.org` as an uncommitted draft. It was preserved
unchanged. The standard N3 queue is exhausted; N3-1084 and N3-1191 remain deferred. New work continues with the N2 candidate queue.

N3-1085–1094 were authored sequentially by `codex`, with one Git commit
per word using Ihor’s configured identity. Each passed JMdict validation,
Org lint, and the entry doctor (100/100, zero errors or warnings). These
entries remain `new` / `draft`, pending editorial review. N3-1075–1083
were already committed by the previous agent and are now recorded below.
Canonical N4 queue rows produce 712 canonical N4 entry files due to aliases and shared JMdict entries.
The seed entry `日本語` is outside the N5/N4/N3 queues.

## Completed 50-word continuation (2026-09-27)

Goal baseline: commit `755b6eeb`, after the initial 10-word request.
Completed: **50/50 new entries**, in completed batches of 10.
Latest completed batch: N3-1137–1146. Each word was authored and
committed individually, with Ukrainian glosses and usage notes for every
English sense and three graded examples. Existing queue aliases were recorded
without counting them toward the 50 new entries. Every new entry passed JMdict
validation, Org lint, and doctor 100/100 with zero errors or warnings.
Git author remains Ihor; content author is `codex`. Editorial review remains
pending. The pre-existing uncommitted 罪 draft is excluded and unchanged.

| Batch | Queue rows | New entries | Existing aliases |
| --- | --- | ---: | --- |
| 1 | N3-1095–1104 | 10 | — |
| 2 | N3-1105–1114 | 10 | — |
| 3 | N3-1115–1125 | 10 | N3-1116 出来るだけ |
| 4 | N3-1126–1136 | 10 | N3-1132 通り |
| 5 | N3-1137–1146 | 10 | — |

Total: 50 distinct new JMdict entries, with 150 graded Japanese examples,
readings, and Ukrainian/English translations. Every English sense has an
original Ukrainian gloss and usage explanation.

## Completed 100-word continuation (2026-09-27)

Goal baseline: commit `342862e4`, after the completed 50-word continuation.
Completed: **100/100 new entries**, in 10 batches of 10.
Final baseline audit verified 100 unique new JMdict entries, 100 individual
word commits under Ihor, 288 English senses with Ukrainian glosses and notes,
and 300 graded examples. Previously committed entries are unchanged.
Latest completed batch: N3-1241–1250. Each word was authored and
committed individually, with Ukrainian glosses and usage notes for every
English sense and three graded examples. Existing queue aliases were recorded without counting
them toward the 100 new entries. Every new entry passed JMdict
validation, Org lint, and doctor 100/100 with zero errors or warnings.
Git author remains Ihor; content author is `codex`. Editorial review remains
pending. The pre-existing uncommitted 罪 draft is excluded and unchanged.

| Batch | Queue rows | New entries |
| --- | --- | ---: |
| 1 | N3-1147–1156 | 10 |
| 2 | N3-1157–1166 | 10 |
| 3 | N3-1167–1176 | 10 |
| 4 | N3-1177–1186 | 10 |
| 5 | N3-1187–1198 | 10 |
| 6 | N3-1199–1208 | 10 |
| 7 | N3-1209–1219 | 10 |
| 8 | N3-1220–1229 | 10 |
| 9 | N3-1230–1240 | 10 |
| 10 | N3-1241–1250 | 10 |

Deferred queue rows: N3-1191.
N3-1191 直（なお）needs a dedicated historical-usage review; it is not
counted as covered or toward the 100 new entries. The common modern
なお is a different lemma. [Published dictionary reference](https://kotobank.jp/word/%E7%9B%B4-25740).

## Next 10-word continuation (2026-09-27)

Completed N3-1251–1261: 10 new entries, each committed individually under
Ihor with `codex` as content author. N3-1259 喉 was already present and was
recorded as an existing alias without changing its content. The ten new
entries contain Ukrainian glosses and usage notes for all 49 English senses
and 30 graded examples. Each passed JMdict validation, Org lint and doctor
100/100 with zero errors or warnings. Editorial review remains pending;
the uncommitted 罪 draft remains preserved.

## Additional 10-word batch (2026-09-30)

N3-1262–1271 adds ten new entries on the current branch, bringing this PR
to twenty new words. Each was committed individually under Ihor with
`codex` as content author. This batch covers all 18 English senses with
Ukrainian glosses and usage notes, plus 30 graded examples. Each entry
passed JMdict validation, Org lint and doctor 100/100 with zero errors or
warnings. Entries remain drafts pending editorial review.

## Completed current-branch 100-word continuation (2026-09-30)

Baseline: `f94d38a2` (merged PR #10). Completed **100/100 new words**
on this branch in batches of ten, each word committed separately under Ihor.
Final audit verified 100 unique new JMdict entries, 100 individual word commits,
278 English senses with Ukrainian glosses and notes, and 300 graded examples.
Content author is `codex`; every new English sense has an independently authored
Ukrainian gloss and usage note, and each entry has three graded examples.
The completion audit verified 400 distinct new JMdict IDs, 1,001 English
semantic senses with Ukrainian content, 1,200 graded examples, and 400
individual word commits across 40 batches.
All completed entries passed JMdict validation, Org lint and doctor 100/100
with zero errors or warnings. Existing aliases are recorded without counting
as new entries. Editorial review remains pending.
N2-69 佚（いつ）is deferred for a dedicated standalone-usage review;
N2-67 and N2-68 are aliases of existing entries and are not counted as new.

| Batch | Queue rows | New entries |
| --- | --- | ---: |
| 1 | N3-1251–1261 | 10 |
| 2 | N3-1262–1271 | 10 |
| 3 | N3-1272–1283 | 10 |
| 4 | N3-1284–1293 | 10 |
| 5 | N3-1294–1303 | 10 |
| 6 | N3-1304–1313 | 10 |
| 7 | N3-1314–1323 | 10 |
| 8 | N3-1324–1333 | 10 |
| 9 | N3-1334–1343 | 10 |
| 10 | N3-1344–1353 | 10 |

## Completed current-branch 200-word continuation (2026-09-30)

Baseline: `f94d38a2` (merged PR #10). Completed **200/200 new words**
on this branch in twenty batches of ten, with 200 separate word commits under Ihor.
The completion audit verified 200 distinct JMdict IDs, Ukrainian glosses and usage
notes for all 515 English semantic senses, and 600 graded examples. Content author
is `codex`; original JMdict sense fingerprints were checked against the source archive.
All completed entries passed JMdict validation, Org lint and doctor 100/100
with zero errors or warnings. Existing aliases are recorded without counting
as new entries. Editorial review remains pending.

| Batch | Queue rows | New entries |
| --- | --- | ---: |
| 1 | N3-1251–1261 | 10 |
| 2 | N3-1262–1271 | 10 |
| 3 | N3-1272–1283 | 10 |
| 4 | N3-1284–1293 | 10 |
| 5 | N3-1294–1303 | 10 |
| 6 | N3-1304–1313 | 10 |
| 7 | N3-1314–1323 | 10 |
| 8 | N3-1324–1333 | 10 |
| 9 | N3-1334–1343 | 10 |
| 10 | N3-1344–1353 | 10 |
| 11 | N3-1354–1364 | 10 |
| 12 | N3-1365–1374 | 10 |
| 13 | N3-1375–1384 | 10 |
| 14 | N3-1385–1394 | 10 |
| 15 | N3-1395–1404 | 10 |
| 16 | N3-1405–1414 | 10 |
| 17 | N3-1415–1424 | 10 |
| 18 | N3-1425–1434 | 10 |
| 19 | N3-1435–1445 | 10 |
| 20 | N3-1446–1457 | 10 |

## Completed current-branch 300-word continuation (2026-09-30)

Baseline: `f94d38a2` (merged PR #10). Completed **300/300 new words**
on this branch in thirty batches of ten, with 300 separate word commits under Ihor.
The completion audit verified 300 distinct new JMdict IDs, Ukrainian glosses and usage
notes for all 794 English semantic senses, and 900 graded examples. Content author
is `codex`; original JMdict sense fingerprints were checked against the source archive.
All completed entries passed JMdict validation, Org lint and doctor 100/100
with zero errors or warnings. Existing aliases are recorded without counting
as new entries. Editorial review remains pending.

| Batch | Queue rows | New entries |
| --- | --- | ---: |
| 1 | N3-1251–1261 | 10 |
| 2 | N3-1262–1271 | 10 |
| 3 | N3-1272–1283 | 10 |
| 4 | N3-1284–1293 | 10 |
| 5 | N3-1294–1303 | 10 |
| 6 | N3-1304–1313 | 10 |
| 7 | N3-1314–1323 | 10 |
| 8 | N3-1324–1333 | 10 |
| 9 | N3-1334–1343 | 10 |
| 10 | N3-1344–1353 | 10 |
| 11 | N3-1354–1364 | 10 |
| 12 | N3-1365–1374 | 10 |
| 13 | N3-1375–1384 | 10 |
| 14 | N3-1385–1394 | 10 |
| 15 | N3-1395–1404 | 10 |
| 16 | N3-1405–1414 | 10 |
| 17 | N3-1415–1424 | 10 |
| 18 | N3-1425–1434 | 10 |
| 19 | N3-1435–1445 | 10 |
| 20 | N3-1446–1457 | 10 |
| 21 | N3-1458–1467 | 10 |
| 22 | N3-1468–1477 | 10 |
| 23 | N3-1478–1489 | 10 |
| 24 | N3-1490–1499 | 10 |
| 25 | N3-1500–1509 | 10 |
| 26 | N3-1510–1520 | 10 |
| 27 | N3-1521–1530 | 10 |
| 28 | N3-1531–1540 | 10 |
| 29 | N3-1541–1550 | 10 |
| 30 | N3-1551–1562 | 10 |

## Completed current-branch 400-word continuation (2026-09-30)

Baseline: `f94d38a2` (merged PR #10). Completed **400/400 new words**
on this branch in batches of ten, each word committed separately under Ihor.
Content author is `codex`; every new English sense has an independently authored
Ukrainian gloss and usage note, and each entry has three graded examples.
The completion audit verified 400 distinct new JMdict IDs, 1,001 English
semantic senses with Ukrainian content, 1,200 graded examples, and 400
individual word commits across 40 batches.
All completed entries passed JMdict validation, Org lint and doctor 100/100
with zero errors or warnings. Existing aliases are recorded without counting
as new entries. Editorial review remains pending.

| Batch | Queue rows | New entries |
| --- | --- | ---: |
| 1 | N3-1251–1261 | 10 |
| 2 | N3-1262–1271 | 10 |
| 3 | N3-1272–1283 | 10 |
| 4 | N3-1284–1293 | 10 |
| 5 | N3-1294–1303 | 10 |
| 6 | N3-1304–1313 | 10 |
| 7 | N3-1314–1323 | 10 |
| 8 | N3-1324–1333 | 10 |
| 9 | N3-1334–1343 | 10 |
| 10 | N3-1344–1353 | 10 |
| 11 | N3-1354–1364 | 10 |
| 12 | N3-1365–1374 | 10 |
| 13 | N3-1375–1384 | 10 |
| 14 | N3-1385–1394 | 10 |
| 15 | N3-1395–1404 | 10 |
| 16 | N3-1405–1414 | 10 |
| 17 | N3-1415–1424 | 10 |
| 18 | N3-1425–1434 | 10 |
| 19 | N3-1435–1445 | 10 |
| 20 | N3-1446–1457 | 10 |
| 21 | N3-1458–1467 | 10 |
| 22 | N3-1468–1477 | 10 |
| 23 | N3-1478–1489 | 10 |
| 24 | N3-1490–1499 | 10 |
| 25 | N3-1500–1509 | 10 |
| 26 | N3-1510–1520 | 10 |
| 27 | N3-1521–1530 | 10 |
| 28 | N3-1531–1540 | 10 |
| 29 | N3-1541–1550 | 10 |
| 30 | N3-1551–1562 | 10 |
| 31 | N3-1563–1573 | 10 |
| 32 | N3-1574–1584 | 10 |
| 33 | N3-1585–1594 | 10 |
| 34 | N3-1595–1607 | 10 |
| 35 | N3-1608–1617 | 10 |
| 36 | N3-1618–1627 | 10 |
| 37 | N3-1628–1638 | 10 |
| 38 | N3-1639–1648 | 10 |
| 39 | N3-1649–1658 | 10 |
| 40 | N3-1659–1668 | 10 |

## Completed current-branch 500-word continuation (2026-09-30)

Baseline: `f94d38a2` (merged PR #10). Completed **500/500 new words**
in batches of ten, one commit per word under Ihor. Content author is `codex`.
Each English semantic sense has an original Ukrainian gloss and usage note;
each entry has three graded examples. All added entries passed validation,
Org lint, and doctor 100/100 with zero errors or warnings. The remaining
standard N3 entries are followed by N2 candidates, as requested.
The completion audits verified 500 distinct new JMdict IDs (409 N3 and 91 N2),
1,201 English semantic senses with Ukrainian glosses and usage notes,
1,500 graded examples, and 500 individual word commits in 50 batches.
Original JMdict sense fingerprints and Git authorship were verified throughout.
Editorial review remains pending.
N2-69 is deferred for a dedicated standalone-usage review.
The next untouched N2 queue row is N2-95 (うっかり).
N2-67 and N2-68 are aliases of existing entries and are not counted as new.

| Batch | Queue rows | New entries |
| --- | --- | ---: |
| 1 | N3-1251–1261 | 10 |
| 2 | N3-1262–1271 | 10 |
| 3 | N3-1272–1283 | 10 |
| 4 | N3-1284–1293 | 10 |
| 5 | N3-1294–1303 | 10 |
| 6 | N3-1304–1313 | 10 |
| 7 | N3-1314–1323 | 10 |
| 8 | N3-1324–1333 | 10 |
| 9 | N3-1334–1343 | 10 |
| 10 | N3-1344–1353 | 10 |
| 11 | N3-1354–1364 | 10 |
| 12 | N3-1365–1374 | 10 |
| 13 | N3-1375–1384 | 10 |
| 14 | N3-1385–1394 | 10 |
| 15 | N3-1395–1404 | 10 |
| 16 | N3-1405–1414 | 10 |
| 17 | N3-1415–1424 | 10 |
| 18 | N3-1425–1434 | 10 |
| 19 | N3-1435–1445 | 10 |
| 20 | N3-1446–1457 | 10 |
| 21 | N3-1458–1467 | 10 |
| 22 | N3-1468–1477 | 10 |
| 23 | N3-1478–1489 | 10 |
| 24 | N3-1490–1499 | 10 |
| 25 | N3-1500–1509 | 10 |
| 26 | N3-1510–1520 | 10 |
| 27 | N3-1521–1530 | 10 |
| 28 | N3-1531–1540 | 10 |
| 29 | N3-1541–1550 | 10 |
| 30 | N3-1551–1562 | 10 |
| 31 | N3-1563–1573 | 10 |
| 32 | N3-1574–1584 | 10 |
| 33 | N3-1585–1594 | 10 |
| 34 | N3-1595–1607 | 10 |
| 35 | N3-1608–1617 | 10 |
| 36 | N3-1618–1627 | 10 |
| 37 | N3-1628–1638 | 10 |
| 38 | N3-1639–1648 | 10 |
| 39 | N3-1649–1658 | 10 |
| 40 | N3-1659–1668 | 10 |
| 41 | N3-1669, N3-1670, N3-1671, N3-1672, N3-1673, N3-1674, N3-1675, N3-1676, N3-1677, N2-1 | 10 |
| 42 | N2-2, N2-3, N2-4, N2-5, N2-6, N2-7, N2-8, N2-9, N2-10, N2-11 | 10 |
| 43 | N2-12, N2-13, N2-14, N2-15, N2-16, N2-17, N2-18, N2-19, N2-20, N2-21 | 10 |
| 44 | N2-22, N2-23, N2-24, N2-25, N2-26, N2-27, N2-28, N2-29, N2-30, N2-31 | 10 |
| 45 | N2-32, N2-33, N2-34, N2-35, N2-36, N2-37, N2-38, N2-39, N2-40, N2-41 | 10 |
| 46 | N2-42, N2-43, N2-44, N2-45, N2-46, N2-47, N2-48, N2-49, N2-50, N2-51 | 10 |
| 47 | N2-52, N2-53, N2-54, N2-55, N2-56, N2-57, N2-58, N2-59, N2-60, N2-61 | 10 |
| 48 | N2-62, N2-63, N2-64, N2-65, N2-66, N2-67, N2-68, N2-70, N2-71, N2-72, N2-73, N2-74 | 10 |
| 49 | N2-75, N2-76, N2-77, N2-78, N2-79, N2-80, N2-81, N2-82, N2-83, N2-84 | 10 |
| 50 | N2-85, N2-86, N2-87, N2-88, N2-89, N2-90, N2-91, N2-92, N2-93, N2-94 | 10 |

## Completed current-branch 100-word N2 continuation (2026-09-30)

Baseline: `8014141b` (merged PR #11). Completed **100/100 new words**
in ten batches, with one commit per word under Ihor and content author `codex`.
All 190 English semantic senses have independently authored Ukrainian glosses
and usage notes, and each entry has three graded examples (300 in total).
Each word passed JMdict validation, Org lint, and doctor 100/100 with zero
errors or warnings. Full-branch audits verified 100 distinct new JMdict IDs,
complete source-sense fingerprints, source archive hashes, all authored
content, the primary example sense, and Git authorship.

N2-95–197 are covered. N2-149, N2-167, and N2-178 are aliases of existing
entries and are excluded from the new-word count. At this checkpoint, the
next untouched row was N2-198 (蚊). The earlier N2-69 usage review remains deferred.
All new entries remain `new` / `draft`, pending editorial review.

| Batch | Queue rows | New entries |
| --- | --- | ---: |
| 1 | N2-95–104 | 10 |
| 2 | N2-105–114 | 10 |
| 3 | N2-115–124 | 10 |
| 4 | N2-125–134 | 10 |
| 5 | N2-135–144 | 10 |
| 6 | N2-145–155 | 10 |
| 7 | N2-156–165 | 10 |
| 8 | N2-166–176 | 10 |
| 9 | N2-177–187 | 10 |
| 10 | N2-188–197 | 10 |

## Completed current-branch 200-word N2 continuation (2026-09-30)

Baseline: `8014141b` (merged PR #11). Completed **200/200 new words**
in twenty batches of ten, with one commit per word under Ihor and content
author `codex`. All 366 English semantic senses have independently authored
Ukrainian glosses and usage notes. The entries include 600 graded examples,
each with Japanese text, kana reading, Ukrainian and English translations.

Fresh checks across all 200 added entries passed JMdict validation, Org lint,
and doctor 100/100 with zero errors or warnings. The test suite passed
137 tests and 10,334 assertions. Full-branch audits verified 200 distinct
new JMdict IDs, complete source-sense fingerprints, source archive hashes,
all authored content, the primary example sense, and Git authorship.

N2-95–298 are covered. N2-149, N2-167, N2-178, and N2-241 are unchanged
aliases of existing entries and are excluded from the new-word count.
The next untouched row is N2-299 (関西). N2-69 remains deferred for a
dedicated standalone-usage review. All new entries remain `new` / `draft`,
pending editorial review. The uncommitted 罪 draft was preserved.

| Batch | Queue rows | New entries |
| --- | --- | ---: |
| 1 | N2-95–104 | 10 |
| 2 | N2-105–114 | 10 |
| 3 | N2-115–124 | 10 |
| 4 | N2-125–134 | 10 |
| 5 | N2-135–144 | 10 |
| 6 | N2-145–155 | 10 |
| 7 | N2-156–165 | 10 |
| 8 | N2-166–176 | 10 |
| 9 | N2-177–187 | 10 |
| 10 | N2-188–197 | 10 |
| 11 | N2-198–207 | 10 |
| 12 | N2-208–217 | 10 |
| 13 | N2-218–227 | 10 |
| 14 | N2-228–237 | 10 |
| 15 | N2-238–248 | 10 |
| 16 | N2-249–258 | 10 |
| 17 | N2-259–268 | 10 |
| 18 | N2-269–278 | 10 |
| 19 | N2-279–288 | 10 |
| 20 | N2-289–298 | 10 |

## Current-branch 300-word checkpoint (2026-09-30)

The current branch contains 300 new N2 entries in thirty batches of ten,
with one commit per word under Ihor and content author `codex`. All 564
English semantic senses have original Ukrainian glosses and usage notes;
the entries contain 900 graded examples with Japanese, kana, Ukrainian,
and English fields. The active goal is 400 new entries, so 100 remain.

Coverage now reaches N2-399 (クーラー). N2-149, N2-167, N2-178, N2-241,
and N2-321 are unchanged existing aliases excluded from the new-word count.
The next untouched row at this checkpoint is N2-400 (偶数).
Fresh validation and Org lint passed for all 300 added entries. Their doctor
score is 100/100 with zero errors or warnings. Source and content audits
verified unique IDs, all source-sense fingerprints, complete authored fields,
primary example senses, and Git authorship. The test suite passed 137 tests
and 10,643 assertions.
All added entries remain `new` / `draft`, pending editorial review.

## Completed current-branch 400-word N2 continuation (2026-09-30)

Baseline: `8014141bbfd7fb45edfaf0a1b4172d3f55961b50` (merged PR #11). Completed **400/400 new words**
in batches of ten, one commit per word under Ihor. Content author is `codex`.
Each English semantic sense has an original Ukrainian gloss and usage note;
each entry has three graded examples. All added entries passed validation,
Org lint, and doctor 100/100 with zero errors or warnings. All new entries are N2 candidates from the pinned queue.
Editorial review remains pending.
N2-69 is deferred for a dedicated standalone-usage review.
Previously authored aliases remain excluded from the new-word count.
Full audits confirmed 400 distinct new IDs, 734 English senses, 1,200 graded examples,
and 400 individual word commits. Fresh validation, Org lint and doctor checks passed
for all 400 entries; doctor averaged 100/100 with zero errors or warnings.
The test suite passed 137 tests and 10,943 assertions. The next untouched row
at this checkpoint is N2-500 (紺). The subsequent 500-word completion is recorded below.

| Batch | Queue rows | New entries |
| --- | --- | ---: |
| 1 | N2-95, N2-96, N2-97, N2-98, N2-99, N2-100, N2-101, N2-102, N2-103, N2-104 | 10 |
| 2 | N2-105, N2-106, N2-107, N2-108, N2-109, N2-110, N2-111, N2-112, N2-113, N2-114 | 10 |
| 3 | N2-115, N2-116, N2-117, N2-118, N2-119, N2-120, N2-121, N2-122, N2-123, N2-124 | 10 |
| 4 | N2-125, N2-126, N2-127, N2-128, N2-129, N2-130, N2-131, N2-132, N2-133, N2-134 | 10 |
| 5 | N2-135, N2-136, N2-137, N2-138, N2-139, N2-140, N2-141, N2-142, N2-143, N2-144 | 10 |
| 6 | N2-145, N2-146, N2-147, N2-148, N2-149, N2-150, N2-151, N2-152, N2-153, N2-154, N2-155 | 10 |
| 7 | N2-156, N2-157, N2-158, N2-159, N2-160, N2-161, N2-162, N2-163, N2-164, N2-165 | 10 |
| 8 | N2-166, N2-167, N2-168, N2-169, N2-170, N2-171, N2-172, N2-173, N2-174, N2-175, N2-176 | 10 |
| 9 | N2-177, N2-178, N2-179, N2-180, N2-181, N2-182, N2-183, N2-184, N2-185, N2-186, N2-187 | 10 |
| 10 | N2-188, N2-189, N2-190, N2-191, N2-192, N2-193, N2-194, N2-195, N2-196, N2-197 | 10 |
| 11 | N2-198, N2-199, N2-200, N2-201, N2-202, N2-203, N2-204, N2-205, N2-206, N2-207 | 10 |
| 12 | N2-208, N2-209, N2-210, N2-211, N2-212, N2-213, N2-214, N2-215, N2-216, N2-217 | 10 |
| 13 | N2-218, N2-219, N2-220, N2-221, N2-222, N2-223, N2-224, N2-225, N2-226, N2-227 | 10 |
| 14 | N2-228, N2-229, N2-230, N2-231, N2-232, N2-233, N2-234, N2-235, N2-236, N2-237 | 10 |
| 15 | N2-238, N2-239, N2-240, N2-241, N2-242, N2-243, N2-244, N2-245, N2-246, N2-247, N2-248 | 10 |
| 16 | N2-249, N2-250, N2-251, N2-252, N2-253, N2-254, N2-255, N2-256, N2-257, N2-258 | 10 |
| 17 | N2-259, N2-260, N2-261, N2-262, N2-263, N2-264, N2-265, N2-266, N2-267, N2-268 | 10 |
| 18 | N2-269, N2-270, N2-271, N2-272, N2-273, N2-274, N2-275, N2-276, N2-277, N2-278 | 10 |
| 19 | N2-279, N2-280, N2-281, N2-282, N2-283, N2-284, N2-285, N2-286, N2-287, N2-288 | 10 |
| 20 | N2-289, N2-290, N2-291, N2-292, N2-293, N2-294, N2-295, N2-296, N2-297, N2-298 | 10 |
| 21 | N2-299, N2-300, N2-301, N2-302, N2-303, N2-304, N2-305, N2-306, N2-307, N2-308 | 10 |
| 22 | N2-309, N2-310, N2-311, N2-312, N2-313, N2-314, N2-315, N2-316, N2-317, N2-318 | 10 |
| 23 | N2-319, N2-320, N2-321, N2-322, N2-323, N2-324, N2-325, N2-326, N2-327, N2-328, N2-329 | 10 |
| 24 | N2-330, N2-331, N2-332, N2-333, N2-334, N2-335, N2-336, N2-337, N2-338, N2-339 | 10 |
| 25 | N2-340, N2-341, N2-342, N2-343, N2-344, N2-345, N2-346, N2-347, N2-348, N2-349 | 10 |
| 26 | N2-350, N2-351, N2-352, N2-353, N2-354, N2-355, N2-356, N2-357, N2-358, N2-359 | 10 |
| 27 | N2-360, N2-361, N2-362, N2-363, N2-364, N2-365, N2-366, N2-367, N2-368, N2-369 | 10 |
| 28 | N2-370, N2-371, N2-372, N2-373, N2-374, N2-375, N2-376, N2-377, N2-378, N2-379 | 10 |
| 29 | N2-380, N2-381, N2-382, N2-383, N2-384, N2-385, N2-386, N2-387, N2-388, N2-389 | 10 |
| 30 | N2-390, N2-391, N2-392, N2-393, N2-394, N2-395, N2-396, N2-397, N2-398, N2-399 | 10 |
| 31 | N2-400, N2-401, N2-402, N2-403, N2-404, N2-405, N2-406, N2-407, N2-408, N2-409 | 10 |
| 32 | N2-410, N2-411, N2-412, N2-413, N2-414, N2-415, N2-416, N2-417, N2-418, N2-419 | 10 |
| 33 | N2-420, N2-421, N2-422, N2-423, N2-424, N2-425, N2-426, N2-427, N2-428, N2-429 | 10 |
| 34 | N2-430, N2-431, N2-432, N2-433, N2-434, N2-435, N2-436, N2-437, N2-438, N2-439 | 10 |
| 35 | N2-440, N2-441, N2-442, N2-443, N2-444, N2-445, N2-446, N2-447, N2-448, N2-449 | 10 |
| 36 | N2-450, N2-451, N2-452, N2-453, N2-454, N2-455, N2-456, N2-457, N2-458, N2-459 | 10 |
| 37 | N2-460, N2-461, N2-462, N2-463, N2-464, N2-465, N2-466, N2-467, N2-468, N2-469 | 10 |
| 38 | N2-470, N2-471, N2-472, N2-473, N2-474, N2-475, N2-476, N2-477, N2-478, N2-479 | 10 |
| 39 | N2-480, N2-481, N2-482, N2-483, N2-484, N2-485, N2-486, N2-487, N2-488, N2-489 | 10 |
| 40 | N2-490, N2-491, N2-492, N2-493, N2-494, N2-495, N2-496, N2-497, N2-498, N2-499 | 10 |

## Completed current-branch 500-word N2 continuation (2026-09-30)

Baseline: `8014141bbfd7fb45edfaf0a1b4172d3f55961b50` (merged PR #11).
Completed **500/500 new words** in 50 batches of ten, one commit per word
under Ihor. Content author is `codex`. All 500 are distinct new N2 candidate
entries from the pinned Wiktionary queue; the five existing aliases are
excluded from this total.

The entries cover 906 English semantic senses with original Ukrainian
glosses and usage explanations, and contain 1,500 graded examples with
Japanese text, kana readings, Ukrainian and English translations.
Full audits verified distinct JMdict IDs, complete source-sense fingerprints,
primary example senses, example focus spans, Git authorship, and ledger links.
Fresh validation and Org lint passed for every entry. Doctor averaged 100/100
across all 500 entries with zero errors or warnings. The test suite passed
137 tests and 11,243 assertions. Pinned JMdict and N2 source checksums were verified.

All entries remain learner-profile drafts awaiting independent editorial review;
automated checks do not establish linguistic approval. The next untouched
candidate at the 500-word checkpoint was N2-600 (縛る, しばる). N2-69 remains deferred for a standalone-usage review.
The previous agent's uncommitted N3-1084 draft (罪) remains preserved.

| Batch | Queue rows | New entries |
| --- | --- | ---: |
| 1 | N2-95–104 | 10 |
| 2 | N2-105–114 | 10 |
| 3 | N2-115–124 | 10 |
| 4 | N2-125–134 | 10 |
| 5 | N2-135–144 | 10 |
| 6 | N2-145–155 | 10 |
| 7 | N2-156–165 | 10 |
| 8 | N2-166–176 | 10 |
| 9 | N2-177–187 | 10 |
| 10 | N2-188–197 | 10 |
| 11 | N2-198–207 | 10 |
| 12 | N2-208–217 | 10 |
| 13 | N2-218–227 | 10 |
| 14 | N2-228–237 | 10 |
| 15 | N2-238–248 | 10 |
| 16 | N2-249–258 | 10 |
| 17 | N2-259–268 | 10 |
| 18 | N2-269–278 | 10 |
| 19 | N2-279–288 | 10 |
| 20 | N2-289–298 | 10 |
| 21 | N2-299–308 | 10 |
| 22 | N2-309–318 | 10 |
| 23 | N2-319–329 | 10 |
| 24 | N2-330–339 | 10 |
| 25 | N2-340–349 | 10 |
| 26 | N2-350–359 | 10 |
| 27 | N2-360–369 | 10 |
| 28 | N2-370–379 | 10 |
| 29 | N2-380–389 | 10 |
| 30 | N2-390–399 | 10 |
| 31 | N2-400–409 | 10 |
| 32 | N2-410–419 | 10 |
| 33 | N2-420–429 | 10 |
| 34 | N2-430–439 | 10 |
| 35 | N2-440–449 | 10 |
| 36 | N2-450–459 | 10 |
| 37 | N2-460–469 | 10 |
| 38 | N2-470–479 | 10 |
| 39 | N2-480–489 | 10 |
| 40 | N2-490–499 | 10 |
| 41 | N2-500–509 | 10 |
| 42 | N2-510–519 | 10 |
| 43 | N2-520–529 | 10 |
| 44 | N2-530–539 | 10 |
| 45 | N2-540–549 | 10 |
| 46 | N2-550–559 | 10 |
| 47 | N2-560–569 | 10 |
| 48 | N2-570–579 | 10 |
| 49 | N2-580–589 | 10 |
| 50 | N2-590–599 | 10 |

## Completed current-branch 600-word N2 continuation (2026-09-30)

Baseline: `8014141bbfd7fb45edfaf0a1b4172d3f55961b50` (merged PR #11).
Completed **600/600 new words** in 60 batches of ten, one commit per word
under Ihor. Content author is `codex`. All 600 are distinct new N2 candidate
entries from the pinned Wiktionary queue; the five existing aliases are
excluded from this total.

The entries cover 1,059 English semantic senses with original Ukrainian
glosses and usage explanations, and contain 1,800 graded examples with
Japanese text, kana readings, Ukrainian and English translations.
Full audits verified distinct JMdict IDs, complete source-sense fingerprints,
primary example senses, example focus spans, Git authorship, and ledger links.
Fresh validation and Org lint passed for every entry. Doctor averaged 100/100
across all 600 entries with zero errors or warnings. The test suite passed
137 tests and 11,543 assertions. Pinned JMdict and N2 source checksums were verified.

All entries remain learner-profile drafts awaiting independent editorial review;
automated checks do not establish linguistic approval. The next untouched
candidate at the 600-word checkpoint was N2-700 (地盤, じばん). N2-69 remains deferred for a standalone-usage review.
The previous agent's uncommitted N3-1084 draft (罪) remains preserved.

| Batch | Queue rows | New entries |
| --- | --- | ---: |
| 1 | N2-95–104 | 10 |
| 2 | N2-105–114 | 10 |
| 3 | N2-115–124 | 10 |
| 4 | N2-125–134 | 10 |
| 5 | N2-135–144 | 10 |
| 6 | N2-145–155 | 10 |
| 7 | N2-156–165 | 10 |
| 8 | N2-166–176 | 10 |
| 9 | N2-177–187 | 10 |
| 10 | N2-188–197 | 10 |
| 11 | N2-198–207 | 10 |
| 12 | N2-208–217 | 10 |
| 13 | N2-218–227 | 10 |
| 14 | N2-228–237 | 10 |
| 15 | N2-238–248 | 10 |
| 16 | N2-249–258 | 10 |
| 17 | N2-259–268 | 10 |
| 18 | N2-269–278 | 10 |
| 19 | N2-279–288 | 10 |
| 20 | N2-289–298 | 10 |
| 21 | N2-299–308 | 10 |
| 22 | N2-309–318 | 10 |
| 23 | N2-319–329 | 10 |
| 24 | N2-330–339 | 10 |
| 25 | N2-340–349 | 10 |
| 26 | N2-350–359 | 10 |
| 27 | N2-360–369 | 10 |
| 28 | N2-370–379 | 10 |
| 29 | N2-380–389 | 10 |
| 30 | N2-390–399 | 10 |
| 31 | N2-400–409 | 10 |
| 32 | N2-410–419 | 10 |
| 33 | N2-420–429 | 10 |
| 34 | N2-430–439 | 10 |
| 35 | N2-440–449 | 10 |
| 36 | N2-450–459 | 10 |
| 37 | N2-460–469 | 10 |
| 38 | N2-470–479 | 10 |
| 39 | N2-480–489 | 10 |
| 40 | N2-490–499 | 10 |
| 41 | N2-500–509 | 10 |
| 42 | N2-510–519 | 10 |
| 43 | N2-520–529 | 10 |
| 44 | N2-530–539 | 10 |
| 45 | N2-540–549 | 10 |
| 46 | N2-550–559 | 10 |
| 47 | N2-560–569 | 10 |
| 48 | N2-570–579 | 10 |
| 49 | N2-580–589 | 10 |
| 50 | N2-590–599 | 10 |
| 51 | N2-600–609 | 10 |
| 52 | N2-610–619 | 10 |
| 53 | N2-620–629 | 10 |
| 54 | N2-630–639 | 10 |
| 55 | N2-640–649 | 10 |
| 56 | N2-650–659 | 10 |
| 57 | N2-660–669 | 10 |
| 58 | N2-670–679 | 10 |
| 59 | N2-680–689 | 10 |
| 60 | N2-690–699 | 10 |

## Completed current-branch 700-word N2 continuation (2026-10-01)

Baseline: `8014141bbfd7fb45edfaf0a1b4172d3f55961b50` (merged PR #11).
Completed **700/700 new words** in 70 batches of ten, one commit per word
under Ihor. Content author is `codex`. All 700 are distinct new N2 candidate
entries from the pinned Wiktionary queue; the five existing aliases are
excluded from this total.

The entries cover 1,223 English semantic senses with original Ukrainian
glosses and usage explanations, and contain 2,100 graded examples with
Japanese text, kana readings, Ukrainian and English translations.
Full audits verified distinct JMdict IDs, complete source-sense fingerprints,
primary example senses, example focus spans, Git authorship, and ledger links.
Fresh validation and Org lint passed for every entry. Doctor averaged 100/100
across all 700 entries with zero errors or warnings. The test suite passed
137 tests and 11,843 assertions. Pinned JMdict and N2 source checksums were verified.

All entries remain learner-profile drafts awaiting independent editorial review;
automated checks do not establish linguistic approval. The next untouched
candidate at the 700-word checkpoint was N2-800 (正方形, せいほうけい). N2-69 remains deferred for a standalone-usage review.
The previous agent's uncommitted N3-1084 draft (罪) remains preserved.

| Batch | Queue rows | New entries |
| --- | --- | ---: |
| 1 | N2-95–104 | 10 |
| 2 | N2-105–114 | 10 |
| 3 | N2-115–124 | 10 |
| 4 | N2-125–134 | 10 |
| 5 | N2-135–144 | 10 |
| 6 | N2-145–155 | 10 |
| 7 | N2-156–165 | 10 |
| 8 | N2-166–176 | 10 |
| 9 | N2-177–187 | 10 |
| 10 | N2-188–197 | 10 |
| 11 | N2-198–207 | 10 |
| 12 | N2-208–217 | 10 |
| 13 | N2-218–227 | 10 |
| 14 | N2-228–237 | 10 |
| 15 | N2-238–248 | 10 |
| 16 | N2-249–258 | 10 |
| 17 | N2-259–268 | 10 |
| 18 | N2-269–278 | 10 |
| 19 | N2-279–288 | 10 |
| 20 | N2-289–298 | 10 |
| 21 | N2-299–308 | 10 |
| 22 | N2-309–318 | 10 |
| 23 | N2-319–329 | 10 |
| 24 | N2-330–339 | 10 |
| 25 | N2-340–349 | 10 |
| 26 | N2-350–359 | 10 |
| 27 | N2-360–369 | 10 |
| 28 | N2-370–379 | 10 |
| 29 | N2-380–389 | 10 |
| 30 | N2-390–399 | 10 |
| 31 | N2-400–409 | 10 |
| 32 | N2-410–419 | 10 |
| 33 | N2-420–429 | 10 |
| 34 | N2-430–439 | 10 |
| 35 | N2-440–449 | 10 |
| 36 | N2-450–459 | 10 |
| 37 | N2-460–469 | 10 |
| 38 | N2-470–479 | 10 |
| 39 | N2-480–489 | 10 |
| 40 | N2-490–499 | 10 |
| 41 | N2-500–509 | 10 |
| 42 | N2-510–519 | 10 |
| 43 | N2-520–529 | 10 |
| 44 | N2-530–539 | 10 |
| 45 | N2-540–549 | 10 |
| 46 | N2-550–559 | 10 |
| 47 | N2-560–569 | 10 |
| 48 | N2-570–579 | 10 |
| 49 | N2-580–589 | 10 |
| 50 | N2-590–599 | 10 |
| 51 | N2-600–609 | 10 |
| 52 | N2-610–619 | 10 |
| 53 | N2-620–629 | 10 |
| 54 | N2-630–639 | 10 |
| 55 | N2-640–649 | 10 |
| 56 | N2-650–659 | 10 |
| 57 | N2-660–669 | 10 |
| 58 | N2-670–679 | 10 |
| 59 | N2-680–689 | 10 |
| 60 | N2-690–699 | 10 |
| 61 | N2-700–709 | 10 |
| 62 | N2-710–719 | 10 |
| 63 | N2-720–729 | 10 |
| 64 | N2-730–739 | 10 |
| 65 | N2-740–749 | 10 |
| 66 | N2-750–759 | 10 |
| 67 | N2-760–769 | 10 |
| 68 | N2-770–779 | 10 |
| 69 | N2-780–789 | 10 |
| 70 | N2-790–799 | 10 |

## Completed current-branch 900-word N2 continuation (2026-10-01)

Baseline: `8014141bbfd7fb45edfaf0a1b4172d3f55961b50` (merged PR #11).
Completed **900/900 new words** in 90 batches of ten, one commit per word
under Ihor. Content author is `codex`. All 900 are distinct new N2 candidate
entries from the pinned Wiktionary queue; the six existing aliases are
excluded from this total.

The entries cover 1,586 English semantic senses with original Ukrainian
glosses and usage explanations, and contain 2,700 graded examples with
Japanese text, kana readings, Ukrainian and English translations.
Full audits verified distinct JMdict IDs, complete source-sense fingerprints,
primary example senses, example focus spans, Git authorship, and ledger links.
Fresh validation and Org lint passed for every entry. Doctor averaged 100/100
across all 900 entries with zero errors or warnings. The test suite passed
137 tests and 12,443 assertions. Pinned JMdict and N2 source checksums were verified.

All entries remain learner-profile drafts awaiting independent editorial review;
automated checks do not establish linguistic approval. The next untouched
candidate at the 900-word checkpoint was N2-1001 (努める, つとめる). N2-69 remains deferred for a standalone-usage review.
The previous agent's uncommitted N3-1084 draft (罪) remains preserved.

| Batch | Queue rows | New entries |
| --- | --- | ---: |
| 1 | N2-95–104 | 10 |
| 2 | N2-105–114 | 10 |
| 3 | N2-115–124 | 10 |
| 4 | N2-125–134 | 10 |
| 5 | N2-135–144 | 10 |
| 6 | N2-145–155 | 10 |
| 7 | N2-156–165 | 10 |
| 8 | N2-166–176 | 10 |
| 9 | N2-177–187 | 10 |
| 10 | N2-188–197 | 10 |
| 11 | N2-198–207 | 10 |
| 12 | N2-208–217 | 10 |
| 13 | N2-218–227 | 10 |
| 14 | N2-228–237 | 10 |
| 15 | N2-238–248 | 10 |
| 16 | N2-249–258 | 10 |
| 17 | N2-259–268 | 10 |
| 18 | N2-269–278 | 10 |
| 19 | N2-279–288 | 10 |
| 20 | N2-289–298 | 10 |
| 21 | N2-299–308 | 10 |
| 22 | N2-309–318 | 10 |
| 23 | N2-319–329 | 10 |
| 24 | N2-330–339 | 10 |
| 25 | N2-340–349 | 10 |
| 26 | N2-350–359 | 10 |
| 27 | N2-360–369 | 10 |
| 28 | N2-370–379 | 10 |
| 29 | N2-380–389 | 10 |
| 30 | N2-390–399 | 10 |
| 31 | N2-400–409 | 10 |
| 32 | N2-410–419 | 10 |
| 33 | N2-420–429 | 10 |
| 34 | N2-430–439 | 10 |
| 35 | N2-440–449 | 10 |
| 36 | N2-450–459 | 10 |
| 37 | N2-460–469 | 10 |
| 38 | N2-470–479 | 10 |
| 39 | N2-480–489 | 10 |
| 40 | N2-490–499 | 10 |
| 41 | N2-500–509 | 10 |
| 42 | N2-510–519 | 10 |
| 43 | N2-520–529 | 10 |
| 44 | N2-530–539 | 10 |
| 45 | N2-540–549 | 10 |
| 46 | N2-550–559 | 10 |
| 47 | N2-560–569 | 10 |
| 48 | N2-570–579 | 10 |
| 49 | N2-580–589 | 10 |
| 50 | N2-590–599 | 10 |
| 51 | N2-600–609 | 10 |
| 52 | N2-610–619 | 10 |
| 53 | N2-620–629 | 10 |
| 54 | N2-630–639 | 10 |
| 55 | N2-640–649 | 10 |
| 56 | N2-650–659 | 10 |
| 57 | N2-660–669 | 10 |
| 58 | N2-670–679 | 10 |
| 59 | N2-680–689 | 10 |
| 60 | N2-690–699 | 10 |
| 61 | N2-700–709 | 10 |
| 62 | N2-710–719 | 10 |
| 63 | N2-720–729 | 10 |
| 64 | N2-730–739 | 10 |
| 65 | N2-740–749 | 10 |
| 66 | N2-750–759 | 10 |
| 67 | N2-760–769 | 10 |
| 68 | N2-770–779 | 10 |
| 69 | N2-780–789 | 10 |
| 70 | N2-790–799 | 10 |
| 71 | N2-800–809 | 10 |
| 72 | N2-810–819 | 10 |
| 73 | N2-820–829 | 10 |
| 74 | N2-830–839 | 10 |
| 75 | N2-840–849 | 10 |
| 76 | N2-850–859 | 10 |
| 77 | N2-860–869 | 10 |
| 78 | N2-870–879 | 10 |
| 79 | N2-880–889 | 10 |
| 80 | N2-890–899 | 10 |
| 81 | N2-900–909 | 10 |
| 82 | N2-910–919 | 10 |
| 83 | N2-920–929 | 10 |
| 84 | N2-930–939 | 10 |
| 85 | N2-940–949 | 10 |
| 86 | N2-950–959 | 10 |
| 87 | N2-960–969 | 10 |
| 88 | N2-970–979 | 10 |
| 89 | N2-980–989 | 10 |
| 90 | N2-990–1000 | 10 |

## Completed current-branch 1000-word N2 continuation (2026-10-01)

Baseline: `8014141bbfd7fb45edfaf0a1b4172d3f55961b50` (merged PR #11).
Completed **1000/1000 new words** in 100 batches of ten, one commit per word
under Ihor. Content author is `codex`. All 1000 are distinct new N2 candidate
entries from the pinned Wiktionary queue; the seven queue aliases are
excluded from this total.

The entries cover 1,796 English semantic senses with original Ukrainian
glosses and usage explanations, and contain 3,000 graded examples with
Japanese text, kana readings, Ukrainian and English translations.
Full audits verified distinct JMdict IDs, complete source-sense fingerprints,
primary example senses, example focus spans, Git authorship, and ledger links.
Fresh validation and Org lint passed for every entry. Doctor averaged 100/100
across all 1000 entries with zero errors or warnings. The test suite passed
137 tests and 12,743 assertions. Pinned JMdict and N2 source checksums were verified.

All entries remain learner-profile drafts awaiting independent editorial review;
automated checks do not establish linguistic approval. The next untouched
candidate at the 1000-word checkpoint was N2-1102 (銅, どう). N2-69 remains deferred for a standalone-usage review.
The previous agent's uncommitted N3-1084 draft (罪) remains preserved.

| Batch | Queue rows | New entries |
| --- | --- | ---: |
| 1 | N2-95–104 | 10 |
| 2 | N2-105–114 | 10 |
| 3 | N2-115–124 | 10 |
| 4 | N2-125–134 | 10 |
| 5 | N2-135–144 | 10 |
| 6 | N2-145–155 | 10 |
| 7 | N2-156–165 | 10 |
| 8 | N2-166–176 | 10 |
| 9 | N2-177–187 | 10 |
| 10 | N2-188–197 | 10 |
| 11 | N2-198–207 | 10 |
| 12 | N2-208–217 | 10 |
| 13 | N2-218–227 | 10 |
| 14 | N2-228–237 | 10 |
| 15 | N2-238–248 | 10 |
| 16 | N2-249–258 | 10 |
| 17 | N2-259–268 | 10 |
| 18 | N2-269–278 | 10 |
| 19 | N2-279–288 | 10 |
| 20 | N2-289–298 | 10 |
| 21 | N2-299–308 | 10 |
| 22 | N2-309–318 | 10 |
| 23 | N2-319–329 | 10 |
| 24 | N2-330–339 | 10 |
| 25 | N2-340–349 | 10 |
| 26 | N2-350–359 | 10 |
| 27 | N2-360–369 | 10 |
| 28 | N2-370–379 | 10 |
| 29 | N2-380–389 | 10 |
| 30 | N2-390–399 | 10 |
| 31 | N2-400–409 | 10 |
| 32 | N2-410–419 | 10 |
| 33 | N2-420–429 | 10 |
| 34 | N2-430–439 | 10 |
| 35 | N2-440–449 | 10 |
| 36 | N2-450–459 | 10 |
| 37 | N2-460–469 | 10 |
| 38 | N2-470–479 | 10 |
| 39 | N2-480–489 | 10 |
| 40 | N2-490–499 | 10 |
| 41 | N2-500–509 | 10 |
| 42 | N2-510–519 | 10 |
| 43 | N2-520–529 | 10 |
| 44 | N2-530–539 | 10 |
| 45 | N2-540–549 | 10 |
| 46 | N2-550–559 | 10 |
| 47 | N2-560–569 | 10 |
| 48 | N2-570–579 | 10 |
| 49 | N2-580–589 | 10 |
| 50 | N2-590–599 | 10 |
| 51 | N2-600–609 | 10 |
| 52 | N2-610–619 | 10 |
| 53 | N2-620–629 | 10 |
| 54 | N2-630–639 | 10 |
| 55 | N2-640–649 | 10 |
| 56 | N2-650–659 | 10 |
| 57 | N2-660–669 | 10 |
| 58 | N2-670–679 | 10 |
| 59 | N2-680–689 | 10 |
| 60 | N2-690–699 | 10 |
| 61 | N2-700–709 | 10 |
| 62 | N2-710–719 | 10 |
| 63 | N2-720–729 | 10 |
| 64 | N2-730–739 | 10 |
| 65 | N2-740–749 | 10 |
| 66 | N2-750–759 | 10 |
| 67 | N2-760–769 | 10 |
| 68 | N2-770–779 | 10 |
| 69 | N2-780–789 | 10 |
| 70 | N2-790–799 | 10 |
| 71 | N2-800–809 | 10 |
| 72 | N2-810–819 | 10 |
| 73 | N2-820–829 | 10 |
| 74 | N2-830–839 | 10 |
| 75 | N2-840–849 | 10 |
| 76 | N2-850–859 | 10 |
| 77 | N2-860–869 | 10 |
| 78 | N2-870–879 | 10 |
| 79 | N2-880–889 | 10 |
| 80 | N2-890–899 | 10 |
| 81 | N2-900–909 | 10 |
| 82 | N2-910–919 | 10 |
| 83 | N2-920–929 | 10 |
| 84 | N2-930–939 | 10 |
| 85 | N2-940–949 | 10 |
| 86 | N2-950–959 | 10 |
| 87 | N2-960–969 | 10 |
| 88 | N2-970–979 | 10 |
| 89 | N2-980–989 | 10 |
| 90 | N2-990–1000 | 10 |
| 91 | N2-1001–1010 | 10 |
| 92 | N2-1011–1020 | 10 |
| 93 | N2-1021–1030 | 10 |
| 94 | N2-1031–1040 | 10 |
| 95 | N2-1041–1050 | 10 |
| 96 | N2-1051–1060 | 10 |
| 97 | N2-1061–1070 | 10 |
| 98 | N2-1071–1080 | 10 |
| 99 | N2-1081–1090 | 10 |
| 100 | N2-1091–1101 | 10 |

## Current-branch 400-word N2 continuation (2026-10-03)

Baseline: `610b4e8b0b6b19ccd0b408cfd3c09cd4a5b21fac` (merged PR #12).
Completed **400/400 new words** in batches of ten, one commit per word
under Ihor. Content author is `codex`. All are distinct new N2 candidate
entries from the pinned queue. N2-1144 (憎い), N2-1233 (バック), and N2-1423
(混ぜる) are unchanged existing entries or aliases and are excluded from the
new-word count.

The additions cover English semantic senses with original Ukrainian glosses
and usage explanations, plus graded examples with Japanese text, kana,
Ukrainian and English translations. Audits verified distinct JMdict IDs,
complete original-source sense fingerprints, primary example senses, example
focus spans, Git authorship and ledger links. Fresh validation and Org lint
passed for all entries. Doctor averaged 100/100 with zero errors or warnings.
The test suite passed; pinned JMdict and N2 source checksums were verified.

All additions remain learner-profile drafts awaiting independent editorial
review. Automated checks do not constitute linguistic approval. The next
untouched candidate is N2-1506 (木材, もくざい). N2-69 remains deferred for a
dedicated standalone-usage review. The earlier uncommitted N3-1084 draft (罪)
remains preserved.

| Batch | Queue rows | New entries |
| --- | --- | ---: |
| 1 | N2-1102–1111 | 10 |
| 2 | N2-1112–1121 | 10 |
| 3 | N2-1122–1131 | 10 |
| 4 | N2-1132–1141 | 10 |
| 5 | N2-1142–1152 | 10 |
| 6 | N2-1153–1162 | 10 |
| 7 | N2-1163–1172 | 10 |
| 8 | N2-1173–1182 | 10 |
| 9 | N2-1183–1192 | 10 |
| 10 | N2-1193–1202 | 10 |
| 11 | N2-1203–1212 | 10 |
| 12 | N2-1213–1222 | 10 |
| 13 | N2-1223–1232 | 10 |
| 14 | N2-1233–1243 | 10 |
| 15 | N2-1244–1253 | 10 |
| 16 | N2-1254–1263 | 10 |
| 17 | N2-1264–1273 | 10 |
| 18 | N2-1274–1283 | 10 |
| 19 | N2-1284–1293 | 10 |
| 20 | N2-1294–1303 | 10 |
| 21 | N2-1304–1313 | 10 |
| 22 | N2-1314–1323 | 10 |
| 23 | N2-1324–1333 | 10 |
| 24 | N2-1334–1343 | 10 |
| 25 | N2-1344–1353 | 10 |
| 26 | N2-1354–1363 | 10 |
| 27 | N2-1364–1373 | 10 |
| 28 | N2-1374–1383 | 10 |
| 29 | N2-1384–1393 | 10 |
| 30 | N2-1394–1403 | 10 |
| 31 | N2-1404–1413 | 10 |
| 32 | N2-1414–1424 | 10 |
| 33 | N2-1425–1434 | 10 |
| 34 | N2-1435–1444 | 10 |
| 35 | N2-1445–1454 | 10 |
| 36 | N2-1455–1464 | 10 |
| 37 | N2-1465–1474 | 10 |
| 38 | N2-1475–1484 | 10 |
| 39 | N2-1485–1495 | 10 |
| 40 | N2-1496–1505 | 10 |

## Current-branch next 100 N2 words (2026-10-04)

Baseline for this request: `dbdcb446` (**400** new entries on this branch).
Completed **100/100** additional distinct entries; branch total **500**.
One commit per word, in batches of ten, using Ihor’s Git identity and
`codex` content attribution. Every English sense has original Ukrainian
glosses and usage notes; every primary sense has three graded examples.
Completed batches passed pinned-JMdict validation, Org lint, and doctor
100/100 with zero errors or warnings. Entries remain learner drafts,
pending independent editorial review. The pre-existing 罪 draft is unchanged.
Final audit: **100 unique new JMdict IDs**, **100 individual word commits**,
**191 English senses translated with 191 usage notes**, and **300 graded examples**.
The 400 pre-existing branch additions are unchanged. The test suite passed
(137 tests, 14,243 assertions, zero failures or errors); source archive and
N2 queue checksums match their pinned records. The next untouched candidate
is **N2-1608**. N2-69 remains deferred for standalone-usage review.

N2-1541 is an existing entry; N2-1592 is deferred pending reconciliation
of its three JMdict matches and is excluded from the new-word count.

| Batch | Queue rows | New entries |
| --- | --- | ---: |
| 1 | N2-1506–1515 | 10 |
| 2 | N2-1516–1525 | 10 |
| 3 | N2-1526–1535 | 10 |
| 4 | N2-1536–1546 | 10 |
| 5 | N2-1547–1556 | 10 |
| 6 | N2-1557–1566 | 10 |
| 7 | N2-1567–1576 | 10 |
| 8 | N2-1577–1586 | 10 |
| 9 | N2-1587–1597 | 10 |
| 10 | N2-1598–1607 | 10 |

| Queue row | Word | Reading | JMdict ID | Status |
| --- | --- | --- | --- | --- |
| N2-1506 | [木材](entries/1534/1534660-mokuzai.org) | もくざい | 1534660 | new / draft |
| N2-1507 | [目次](entries/1535/1535460-mokuji.org) | もくじ | 1535460 | new / draft |
| N2-1508 | [潜る](entries/1609/1609715-moguru.org) | もぐる | 1609715 | new / draft |
| N2-1509 | [若しかしたら](entries/1012/1012510-moshikashitara.org) | もしかしたら | 1012510 | new / draft |
| N2-1510 | [若しかすると](entries/1012/1012530-moshikasuruto.org) | もしかすると | 1012530 | new / draft |
| N2-1511 | [凭れる](entries/1564/1564380-motareru.org) | もたれる | 1564380 | new / draft |
| N2-1512 | [モダン](entries/1134/1134990-modan.org) | モダン | 1134990 | new / draft |
| N2-1513 | [餅](entries/1535/1535790-mochi.org) | もち | 1535790 | new / draft |
| N2-1514 | [勿体ない](entries/1605/1605250-mottainai.org) | もったいない | 1605250 | new / draft |
| N2-1515 | [モデル](entries/1135/1135270-moderu.org) | モデル | 1135270 | new / draft |
| N2-1516 | [元々](entries/1605/1605280-motomoto.org) | もともと | 1605280 | new / draft |
| N2-1517 | [物置](entries/1502/1502690-monooki.org) | ものおき | 1502690 | new / draft |
| N2-1518 | [物語る](entries/1502/1502490-monogataru.org) | ものがたる | 1502490 | new / draft |
| N2-1519 | [物差し](entries/1502/1502530-monosashi.org) | ものさし | 1502530 | new / draft |
| N2-1520 | [物凄い](entries/1502/1502630-monosugoi.org) | ものすごい | 1502630 | new / draft |
| N2-1521 | [モノレール](entries/1135/1135680-monoreeru.org) | モノレール | 1135680 | new / draft |
| N2-1522 | [揉む](entries/1567/1567610-momu.org) | もむ | 1567610 | new / draft |
| N2-1523 | [燃やす](entries/1582/1582900-moyasu.org) | もやす | 1582900 | new / draft |
| N2-1524 | [催し](entries/1292/1292140-moyooshi.org) | もよおし | 1292140 | new / draft |
| N2-1525 | [盛る](entries/1379/1379740-moru.org) | もる | 1379740 | new / draft |
| N2-1526 | [問答](entries/1536/1536060-mondou.org) | もんどう | 1536060 | new / draft |
| N2-1527 | [モーター](entries/1134/1134480-mootaa.org) | モーター | 1134480 | new / draft |
| N2-1528 | [喧しい](entries/1211/1211380-yakamashii.org) | やかましい | 1211380 | new / draft |
| N2-1529 | [夜間](entries/1536/1536530-yakan.org) | やかん | 1536530 | new / draft |
| N2-1530 | [役者](entries/1538/1538010-yakusha.org) | やくしゃ | 1538010 | new / draft |
| N2-1531 | [役所](entries/1538/1538020-yakusho.org) | やくしょ | 1538020 | new / draft |
| N2-1532 | [訳す](entries/1538/1538350-yakusu.org) | やくす | 1538350 | new / draft |
| N2-1533 | [役人](entries/1538/1538050-yakunin.org) | やくにん | 1538050 | new / draft |
| N2-1534 | [薬品](entries/1538/1538280-yakuhin.org) | やくひん | 1538280 | new / draft |
| N2-1535 | [役目](entries/1538/1538080-yakume.org) | やくめ | 1538080 | new / draft |
| N2-1536 | [火傷](entries/1577/1577310-yakedo.org) | やけど | 1577310 | new / draft |
| N2-1537 | [夜行](entries/1584/1584820-yakou.org) | やこう | 1584820 | new / draft |
| N2-1538 | [矢印](entries/1537/1537770-yajirushi.org) | やじるし | 1537770 | new / draft |
| N2-1539 | [薬局](entries/1538/1538200-yakkyoku.org) | やっきょく | 1538200 | new / draft |
| N2-1540 | [遣っ付ける](entries/1612/1612950-yattsukeru.org) | やっつける | 1612950 | new / draft |
| N2-1542 | [家主](entries/1191/1191990-yanushi.org) | やぬし | 1191990 | new / draft |
| N2-1543 | [破く](entries/1983/1983750-yabuku.org) | やぶく | 1983750 | new / draft |
| N2-1544 | [破れる](entries/1471/1471210-yabureru.org) | やぶれる | 1471210 | new / draft |
| N2-1545 | [やむを得ない](entries/1612/1612100-yamuwoenai.org) | やむをえない | 1612100 | new / draft |
| N2-1546 | [遊園地](entries/1542/1542170-yuuenchi.org) | ゆうえんち | 1542170 | new / draft |
| N2-1547 | [夕刊](entries/1542/1542690-yuukan.org) | ゆうかん | 1542690 | new / draft |
| N2-1548 | [友好](entries/1540/1540080-yuukou.org) | ゆうこう | 1540080 | new / draft |
| N2-1549 | [郵送](entries/1542/1542380-yuusou.org) | ゆうそう | 1542380 | new / draft |
| N2-1550 | [夕立](entries/1542/1542820-yuudachi.org) | ゆうだち | 1542820 | new / draft |
| N2-1551 | [夕日](entries/1542/1542750-yuuhi.org) | ゆうひ | 1542750 | new / draft |
| N2-1552 | [悠々](entries/1605/1605700-yuuyuu.org) | ゆうゆう | 1605700 | new / draft |
| N2-1553 | [有料](entries/1541/1541690-yuuryou.org) | ゆうりょう | 1541690 | new / draft |
| N2-1554 | [浴衣](entries/1584/1584990-yukata.org) | ゆかた | 1584990 | new / draft |
| N2-1555 | [輸血](entries/1538/1538810-yuketsu.org) | ゆけつ | 1538810 | new / draft |
| N2-1556 | [湯気](entries/1448/1448600-yuge.org) | ゆげ | 1448600 | new / draft |
| N2-1557 | [輸送](entries/1538/1538850-yusou.org) | ゆそう | 1538850 | new / draft |
| N2-1558 | [油断](entries/1538/1538690-yudan.org) | ゆだん | 1538690 | new / draft |
| N2-1559 | [茹でる](entries/1571/1571470-yuderu.org) | ゆでる | 1571470 | new / draft |
| N2-1560 | [湯のみ](entries/1612/1612130-yunomi.org) | ゆのみ | 1612130 | new / draft |
| N2-1561 | [緩い](entries/1214/1214410-yurui.org) | ゆるい | 1214410 | new / draft |
| N2-1562 | [溶岩](entries/1546/1546120-yougan.org) | ようがん | 1546120 | new / draft |
| N2-1563 | [容器](entries/1545/1545370-youki.org) | ようき | 1545370 | new / draft |
| N2-1564 | [用語](entries/1546/1546270-yougo.org) | ようご | 1546270 | new / draft |
| N2-1565 | [要旨](entries/1546/1546770-youshi.org) | ようし | 1546770 | new / draft |
| N2-1566 | [幼児](entries/1545/1545160-youji.org) | ようじ | 1545160 | new / draft |
| N2-1567 | [容積](entries/1545/1545420-youseki.org) | ようせき | 1545420 | new / draft |
| N2-1568 | [幼稚](entries/1545/1545250-youchi.org) | ようち | 1545250 | new / draft |
| N2-1569 | [幼稚園](entries/1545/1545260-youchien.org) | ようちえん | 1545260 | new / draft |
| N2-1570 | [用途](entries/1546/1546380-youto.org) | ようと | 1546380 | new / draft |
| N2-1571 | [洋品店](entries/1794/1794470-youhinten.org) | ようひんてん | 1794470 | new / draft |
| N2-1572 | [養分](entries/1662/1662130-youbun.org) | ようぶん | 1662130 | new / draft |
| N2-1573 | [羊毛](entries/1546/1546530-youmou.org) | ようもう | 1546530 | new / draft |
| N2-1574 | [漸く](entries/1394/1394600-youyaku.org) | ようやく | 1394600 | new / draft |
| N2-1575 | [要領](entries/1546/1546850-youryou.org) | ようりょう | 1546850 | new / draft |
| N2-1576 | [欲張り](entries/1547/1547390-yokubari.org) | よくばり | 1547390 | new / draft |
| N2-1577 | [余計](entries/1544/1544090-yokei.org) | よけい | 1544090 | new / draft |
| N2-1578 | [寄越す](entries/1013/1013140-yokosu.org) | よこす | 1013140 | new / draft |
| N2-1579 | [汚す](entries/1178/1178960-yogosu.org) | よごす | 1178960 | new / draft |
| N2-1580 | [寄せる](entries/1219/1219560-yoseru.org) | よせる | 1219560 | new / draft |
| N2-1581 | [余所](entries/1605/1605940-yoso.org) | よそ | 1605940 | new / draft |
| N2-1582 | [酔っ払い](entries/1372/1372660-yopparai.org) | よっぱらい | 1372660 | new / draft |
| N2-1583 | [四つ角](entries/1307/1307060-yotsukado.org) | よつかど | 1307060 | new / draft |
| N2-1584 | [予備](entries/1543/1543320-yobi.org) | よび | 1543320 | new / draft |
| N2-1585 | [呼びかける](entries/1266/1266280-yobikakeru.org) | よびかける | 1266280 | new / draft |
| N2-1586 | [呼び出す](entries/1266/1266350-yobidasu.org) | よびだす | 1266350 | new / draft |
| N2-1587 | [蘇る](entries/1606/1606020-yomigaeru.org) | よみがえる | 1606020 | new / draft |
| N2-1588 | [依る](entries/1168/1168660-yoru.org) | よる | 1168660 | new / draft |
| N2-1589 | [来日](entries/1548/1548200-rainichi.org) | らいにち | 1548200 | new / draft |
| N2-1590 | [落第](entries/1548/1548810-rakudai.org) | らくだい | 1548810 | new / draft |
| N2-1591 | [ラッシュアワー](entries/1139/1139190-rasshuawaa.org) | ラッシュアワー | 1139190 | new / draft |
| N2-1593 | [ランニング](entries/1140/1140270-ranningu.org) | ランニング | 1140270 | new / draft |
| N2-1594 | [乱暴](entries/1549/1549100-ranbou.org) | らんぼう | 1549100 | new / draft |
| N2-1595 | [理科](entries/1549/1549900-rika.org) | りか | 1549900 | new / draft |
| N2-1596 | [利害](entries/1549/1549500-rigai.org) | りがい | 1549500 | new / draft |
| N2-1597 | [リズム](entries/1141/1141620-rizumu.org) | リズム | 1141620 | new / draft |
| N2-1598 | [リットル](entries/1141/1141870-rittoru.org) | リットル | 1141870 | new / draft |
| N2-1599 | [リボン](entries/1142/1142880-ribon.org) | リボン | 1142880 | new / draft |
| N2-1600 | [略す](entries/1551/1551960-ryakusu.org) | りゃくす | 1551960 | new / draft |
| N2-1601 | [流域](entries/1552/1552230-ryuuiki.org) | りゅういき | 1552230 | new / draft |
| N2-1602 | [寮](entries/1554/1554230-ryou.org) | りょう | 1554230 | new / draft |
| N2-1603 | [両側](entries/1585/1585140-ryougawa.org) | りょうがわ | 1585140 | new / draft |
| N2-1604 | [漁師](entries/1233/1233010-ryoushi.org) | りょうし | 1233010 | new / draft |
| N2-1605 | [領収](entries/1554/1554750-ryoushuu.org) | りょうしゅう | 1554750 | new / draft |
| N2-1606 | [領事](entries/1554/1554730-ryouji.org) | りょうじ | 1554730 | new / draft |
| N2-1607 | [留守番](entries/1552/1552800-rusuban.org) | るすばん | 1552800 | new / draft |

## Further 100-word N2 continuation (2026-10-04)

Baseline: `9a46c7b4`, with **500** new translated words on this branch.
Completed **100/100** further distinct words; branch total **600**.
Words are committed individually in batches of ten under Ihor’s Git identity;
original content is attributed to `codex`. Every English sense is translated
with Ukrainian usage notes, and each primary sense has three graded examples.
Completed batches passed JMdict validation, Org lint, and doctor 100/100
with zero errors or warnings. All remain learner drafts awaiting editorial review.
The earlier uncommitted 罪 draft is preserved.

Final audit verified **100 unique new JMdict IDs**, **100 individual addition
commits**, **175 translated English senses with 175 usage notes**, and
**300 graded examples**. One subsequent correction clarifies the reading note
for 上品; all 500 earlier branch additions are unchanged. Fresh validation
and doctor checks passed for all 100 entries; Org lint passed in each batch.
The test suite passed (137 tests, 14,543 assertions, no failures or errors).
All supplementary candidates match the pinned CSV rows and selection manifest;
source checksums were verified. The pinned queue now covers **1634/1635 rows**;
only N2-69 remains deferred.

Selection: 29 remaining/reconciled Wiktionary candidates and 71 candidates
from [pinned Open Anki N2 source](sources/jlpt-n2/open-anki/README.md).
N2-69 (佚) remains deferred for standalone-usage review; it is not counted.

| Batch | Candidates | New entries |
| --- | --- | ---: |
| 1 | N2-1608–N2-1618 | 10 |
| 2 | N2-1592–N2-1626 | 10 |
| 3 | N2-1627–N2-S135 | 10 |
| 4 | N2-S137–N2-S323 | 10 |
| 5 | N2-S327–N2-S420 | 10 |
| 6 | N2-S434–N2-S561 | 10 |
| 7 | N2-S573–N2-S626 | 10 |
| 8 | N2-S635–N2-S758 | 10 |
| 9 | N2-S776–N2-S903 | 10 |
| 10 | N2-S905–N2-S1024 | 10 |

| Candidate | Word | Reading | JMdict ID | Status |
| --- | --- | --- | --- | --- |
| N2-1608 | [例外](entries/1556/1556410-reigai.org) | れいがい | 1556410 | new / draft |
| N2-1609 | [零点](entries/1557/1557710-reiten.org) | れいてん | 1557710 | new / draft |
| N2-1610 | [レインコート](entries/1144/1144700-reinkooto.org) | レインコート | 1144700 | new / draft |
| N2-1611 | [レクリエーション](entries/1144/1144860-rekurieeshon.org) | レクリエーション | 1144860 | new / draft |
| N2-1612 | [レジャー](entries/1145/1145220-rejaa.org) | レジャー | 1145220 | new / draft |
| N2-1613 | [列島](entries/1558/1558390-rettou.org) | れっとう | 1558390 | new / draft |
| N2-1615 | [煉瓦](entries/1559/1559090-renga.org) | れんが | 1559090 | new / draft |
| N2-1616 | [レンズ](entries/1146/1146140-renzu.org) | レンズ | 1146140 | new / draft |
| N2-1617 | [蝋燭](entries/1561/1561240-rousoku.org) | ろうそく | 1561240 | new / draft |
| N2-1618 | [録音](entries/1561/1561590-rokuon.org) | ろくおん | 1561590 | new / draft |
| N2-1592 | [ランチ](entries/1140/1140100-ranchi.org) | ランチ | 1140100 | new / draft |
| N2-1614 | [レベル](entries/1145/1145910-reberu.org) | レベル | 1145910 | new / draft |
| N2-1619 | [ロッカー](entries/1147/1147560-rokkaa.org) | ロッカー | 1147560 | new / draft |
| N2-1620 | [ロビー](entries/1147/1147800-robii.org) | ロビー | 1147800 | new / draft |
| N2-1621 | [論ずる](entries/1561/1561640-ronzuru.org) | ろんずる | 1561640 | new / draft |
| N2-1622 | [ローマ字](entries/1146/1146810-roomaji.org) | ローマじ | 1146810 | new / draft |
| N2-1623 | [ローンチ](entries/2448/2448600-roonchi.org) | ローンチ | 2448600 | new / draft |
| N2-1624 | [和英](entries/1561/1561970-waei.org) | わえい | 1561970 | new / draft |
| N2-1625 | [分かれる](entries/1606/1606600-wakareru.org) | わかれる | 1606600 | new / draft |
| N2-1626 | [若々しい](entries/1606/1606610-wakawakashii.org) | わかわかしい | 1606610 | new / draft |
| N2-1627 | [湧く](entries/1606/1606685-waku.org) | わく | 1606685 | new / draft |
| N2-1628 | [詫びる](entries/1606/1606790-wabiru.org) | わびる | 1606790 | new / draft |
| N2-1629 | [和服](entries/1562/1562190-wafuku.org) | わふく | 1562190 | new / draft |
| N2-1630 | [割合に](entries/1612/1612360-wariaini.org) | わりあいに | 1612360 | new / draft |
| N2-1631 | [割り算](entries/1606/1606880-warizan.org) | わりざん | 1606880 | new / draft |
| N2-1632 | [割と](entries/1983/1983690-warito.org) | わりと | 1983690 | new / draft |
| N2-1633 | [割引](entries/1606/1606950-waribiki.org) | わりびき | 1606950 | new / draft |
| N2-1634 | [椀](entries/1562/1562780-wan.org) | わん | 1562780 | new / draft |
| N2-1635 | [碗](entries/1562/1562840-wan.org) | わん | 1562840 | new / draft |
| N2-S135 | [朝寝坊](entries/1428/1428410-asanebou.org) | あさねぼう | 1428410 | new / draft |
| N2-S137 | [足元](entries/1586/1586390-ashimoto.org) | あしもと | 1586390 | new / draft |
| N2-S140 | [温まる](entries/1586/1586430-atatamaru.org) | あたたまる | 1586430 | new / draft |
| N2-S145 | [宛名](entries/1586/1586520-atena.org) | あてな | 1586520 | new / draft |
| N2-S169 | [荒れる](entries/1281/1281490-areru.org) | あれる | 1281490 | new / draft |
| N2-S255 | [絵の具](entries/1202/1202290-enogu.org) | えのぐ | 1202290 | new / draft |
| N2-S296 | [伯父](entries/1607/1607070-oji.org) | おじ | 1607070 | new / draft |
| N2-S312 | [各々](entries/2826/2826190-onoono.org) | おのおの | 2826190 | new / draft |
| N2-S313 | [伯母](entries/1607/1607100-oba.org) | おば | 1607100 | new / draft |
| N2-S315 | [小母さん](entries/2261/2261510-obasan.org) | おばさん | 2261510 | new / draft |
| N2-S323 | [思い切り](entries/2834/2834138-omoikiri.org) | おもいきり | 2834138 | new / draft |
| N2-S327 | [重たい](entries/1335/1335780-omotai.org) | おもたい | 1335780 | new / draft |
| N2-S337 | [御中](entries/1270/1270530-onchuu.org) | おんちゅう | 1270530 | new / draft |
| N2-S341 | [貝](entries/1203/1203100-kai.org) | かい | 1203100 | new / draft |
| N2-S345 | [改札](entries/1200/1200840-kaisatsu.org) | かいさつ | 1200840 | new / draft |
| N2-S366 | [書留](entries/1589/1589960-kakitome.org) | かきとめ | 1589960 | new / draft |
| N2-S369 | [限り](entries/1264/1264610-kagiri.org) | かぎり | 1264610 | new / draft |
| N2-S376 | [拡張](entries/1205/1205220-kakuchou.org) | かくちょう | 1205220 | new / draft |
| N2-S392 | [貸し出し](entries/1590/1590240-kashidashi.org) | かしだし | 1590240 | new / draft |
| N2-S397 | [箇所](entries/1590/1590250-kasho.org) | かしょ | 1590250 | new / draft |
| N2-S420 | [勝手に](entries/1346/1346200-katteni.org) | かってに | 1346200 | new / draft |
| N2-S434 | [構いません](entries/1279/1279670-kamaimasen.org) | かまいません | 1279670 | new / draft |
| N2-S456 | [元日](entries/1261/1261010-ganjitsu.org) | がんじつ | 1261010 | new / draft |
| N2-S458 | [感ずる](entries/1609/1609650-kanzuru.org) | かんずる | 1609650 | new / draft |
| N2-S470 | [乾杯](entries/1590/1590950-kanpai.org) | かんぱい | 1590950 | new / draft |
| N2-S477 | [着替える](entries/1423/1423170-kigaeru.org) | きがえる | 1423170 | new / draft |
| N2-S480 | [器具](entries/1218/1218920-kigu.org) | きぐ | 1218920 | new / draft |
| N2-S503 | [休養](entries/1228/1228100-kyuuyou.org) | きゅうよう | 1228100 | new / draft |
| N2-S530 | [苦心](entries/1244/1244530-kushin.org) | くしん | 1244530 | new / draft |
| N2-S535 | [砕く](entries/1295/1295170-kudaku.org) | くだく | 1295170 | new / draft |
| N2-S561 | [毛糸](entries/1533/1533860-keito.org) | けいと | 1533860 | new / draft |
| N2-S573 | [下旬](entries/1185/1185330-gejun.org) | げじゅん | 1185330 | new / draft |
| N2-S581 | [月末](entries/1255/1255840-getsumatsu.org) | げつまつ | 1255840 | new / draft |
| N2-S582 | [気配](entries/1222/1222510-kehai.org) | けはい | 1222510 | new / draft |
| N2-S585 | [煙い](entries/1177/1177190-kemui.org) | けむい | 1177190 | new / draft |
| N2-S594 | [厳重](entries/1262/1262660-genjuu.org) | げんじゅう | 1262660 | new / draft |
| N2-S595 | [謙遜](entries/1260/1260240-kenson.org) | けんそん | 1260240 | new / draft |
| N2-S597 | [限度](entries/1264/1264690-gendo.org) | げんど | 1264690 | new / draft |
| N2-S600 | [懸命](entries/1257/1257730-kenmei.org) | けんめい | 1257730 | new / draft |
| N2-S620 | [口実](entries/1276/1276220-koujitsu.org) | こうじつ | 1276220 | new / draft |
| N2-S626 | [功績](entries/1275/1275070-kouseki.org) | こうせき | 1275070 | new / draft |
| N2-S635 | [肯定](entries/1281/1281180-koutei.org) | こうてい | 1281180 | new / draft |
| N2-S655 | [焦げる](entries/1350/1350730-kogeru.org) | こげる | 1350730 | new / draft |
| N2-S656 | [凍える](entries/1446/1446180-kogoeru.org) | こごえる | 1446180 | new / draft |
| N2-S673 | [言葉遣い](entries/1264/1264560-kotobazukai.org) | ことばづかい | 1264560 | new / draft |
| N2-S680 | [堪える](entries/2827/2827352-koraeru.org) | こらえる | 2827352 | new / draft |
| N2-S681 | [娯楽](entries/1269/1269290-goraku.org) | ごらく | 1269290 | new / draft |
| N2-S697 | [在学](entries/1296/1296440-zaigaku.org) | ざいがく | 1296440 | new / draft |
| N2-S706 | [逆さ](entries/1226/1226970-sakasa.org) | さかさ | 1226970 | new / draft |
| N2-S750 | [寺院](entries/1315/1315250-jiin.org) | じいん | 1315250 | new / draft |
| N2-S758 | [仕方がない](entries/1305/1305420-shikataganai.org) | しかたがない | 1305420 | new / draft |
| N2-S776 | [自宅](entries/1318/1318260-jitaku.org) | じたく | 1318260 | new / draft |
| N2-S808 | [締切](entries/1594/1594590-shimekiri.org) | しめきり | 1594590 | new / draft |
| N2-S813 | [地面](entries/1421/1421510-jimen.org) | じめん | 1421510 | new / draft |
| N2-S822 | [社説](entries/1322/1322890-shasetsu.org) | しゃせつ | 1322890 | new / draft |
| N2-S831 | [住居](entries/2841/2841455-juukyo.org) | じゅうきょ | 2841455 | new / draft |
| N2-S851 | [主人](entries/1579/1579780-shujin.org) | しゅじん | 1579780 | new / draft |
| N2-S882 | [上旬](entries/1353/1353410-joujun.org) | じょうじゅん | 1353410 | new / draft |
| N2-S891 | [上品](entries/1354/1354230-jouhin.org) | じょうひん | 1354230 | new / draft |
| N2-S897 | [消耗](entries/1580/1580310-shoumou.org) | しょうもう | 1580310 | new / draft |
| N2-S903 | [職場](entries/1357/1357540-shokuba.org) | しょくば | 1357540 | new / draft |
| N2-S905 | [書籍](entries/1344/1344090-shoseki.org) | しょせき | 1344090 | new / draft |
| N2-S909 | [書道](entries/1344/1344130-shodou.org) | しょどう | 1344130 | new / draft |
| N2-S910 | [初歩](entries/1343/1343050-shoho.org) | しょほ | 1343050 | new / draft |
| N2-S916 | [汁](entries/1335/1335520-shiru.org) | しる | 1335520 | new / draft |
| N2-S922 | [人事](entries/1367/1367870-jinji.org) | じんじ | 1367870 | new / draft |
| N2-S939 | [炊事](entries/1372/1372350-suiji.org) | すいじ | 1372350 | new / draft |
| N2-S950 | [水面](entries/1372/1372120-suimen.org) | すいめん | 1372120 | new / draft |
| N2-S957 | [隙](entries/1253/1253780-suki.org) | すき | 1253780 | new / draft |
| N2-S967 | [涼む](entries/1554/1554380-suzumu.org) | すずむ | 1554380 | new / draft |
| N2-S1024 | [台詞](entries/1577/1577270-serifu.org) | せりふ | 1577270 | new / draft |

## Additional supplementary 100-word N2 continuation (2026-10-04)

Baseline: `1f6b5bcf`, with **600** new translated words on this branch.
Completed **100/100** additional distinct words; branch total **700**.
Words are committed individually in batches of ten. Every English sense has
original Ukrainian translations and nuance notes; each primary sense has
three graded Japanese, kana, Ukrainian, and English examples.
All completed batches passed JMdict validation, Org lint, and doctor 100/100
with zero errors or warnings. These remain learner drafts for editorial review.
The earlier uncommitted 罪 draft is preserved.

Selection: 56 candidates from [pinned Open Anki N2](sources/jlpt-n2/open-anki/README.md)
and 44 from [documented JTest N2 sections](sources/jlpt-n2/jtest/README.md).
Candidates are reconciled against pinned JMdict and existing entry IDs.
N2-69 (佚) remains deferred and is not counted.

Final audit: **100 distinct added JMdict IDs**, **100 individual word commits**,
**164 English senses translated with 164 Ukrainian nuance notes**, and
**300 graded examples**. Earlier 600 branch additions were preserved unchanged.
The full test suite passed: **137 tests, 14,843 assertions**, zero failures,
errors, or skips. `git diff --check` passed. Only the pre-existing 罪 draft
remains uncommitted.

| Batch | New entries |
| --- | ---: |
| 1 | 10 |
| 2 | 10 |
| 3 | 10 |
| 4 | 10 |
| 5 | 10 |
| 6 | 10 |
| 7 | 10 |
| 8 | 10 |
| 9 | 10 |
| 10 | 10 |

| Source candidate | Word | Reading | JMdict ID | Status |
| --- | --- | --- | --- | --- |
| N2-S1029 | [全集](entries/1395/1395340-zenshuu.org) | ぜんしゅう | 1395340 | new / draft |
| N2-S1042 | [洗面](entries/1391/1391050-senmen.org) | せんめん | 1391050 | new / draft |
| N2-S1043 | [全力](entries/1396/1396390-zenryoku.org) | ぜんりょく | 1396390 | new / draft |
| N2-S1061 | [送料](entries/1402/1402870-souryou.org) | そうりょう | 1402870 | new / draft |
| N2-S1066 | [測量](entries/1404/1404590-sokuryou.org) | そくりょう | 1404590 | new / draft |
| N2-S1090 | [大学院](entries/1413/1413250-daigakuin.org) | だいがくいん | 1413250 | new / draft |
| N2-S1145 | [断定](entries/1419/1419740-dantei.org) | だんてい | 1419740 | new / draft |
| N2-S1150 | [近々](entries/1578/1578110-chikajika.org) | ちかぢか | 1578110 | new / draft |
| N2-S1189 | [直通](entries/1431/1431440-chokutsuu.org) | ちょくつう | 1431440 | new / draft |
| N2-S1209 | [月日](entries/1255/1255780-tsukihi.org) | つきひ | 1255780 | new / draft |
| N2-S1213 | [務める](entries/2872/2872052-tsutomeru.org) | つとめる | 2872052 | new / draft |
| N2-S1238 | [定休日](entries/1435/1435540-teikyuubi.org) | ていきゅうび | 1435540 | new / draft |
| N2-S1241 | [停電](entries/1435/1435020-teiden.org) | ていでん | 1435020 | new / draft |
| N2-S1251 | [凸凹](entries/1582/1582410-dekoboko.org) | でこぼこ | 1582410 | new / draft |
| N2-S1254 | [弟子](entries/1581/1581960-deshi.org) | でし | 1581960 | new / draft |
| N2-S1271 | [伝染](entries/1442/1442110-densen.org) | でんせん | 1442110 | new / draft |
| N2-S1313 | [退ける](entries/2850/2850084-dokeru.org) | どける | 2850084 | new / draft |
| N2-S1323 | [殿](entries/1442/1442500-dono.org) | どの | 1442500 | new / draft |
| N2-S1332 | [採る](entries/1599/1599160-toru.org) | とる | 1599160 | new / draft |
| N2-S1340 | [長引く](entries/1610/1610950-nagabiku.org) | ながびく | 1610950 | new / draft |
| N2-S1346 | [為す](entries/2861/2861111-nasu.org) | なす | 2861111 | new / draft |
| N2-S1358 | [並木](entries/1599/1599640-namiki.org) | なみき | 1599640 | new / draft |
| N2-S1374 | [濁る](entries/1415/1415960-nigoru.org) | にごる | 1415960 | new / draft |
| N2-S1404 | [糊](entries/1267/1267400-nori.org) | のり | 1267400 | new / draft |
| N2-S1407 | [乗り越し](entries/1600/1600480-norikoshi.org) | のりこし | 1600480 | new / draft |
| N2-S1408 | [鈍い](entries/2838/2838553-noroi.org) | のろい | 2838553 | new / draft |
| N2-S1414 | [売店](entries/1474/1474040-baiten.org) | ばいてん | 1474040 | new / draft |
| N2-S1422 | [吐き気](entries/1444/1444120-hakike.org) | はきけ | 1444120 | new / draft |
| N2-S1440 | [発](entries/1477/1477120-hatsu.org) | はつ | 1477120 | new / draft |
| N2-S1452 | [甚だしい](entries/1370/1370010-hanahadashii.org) | はなはだしい | 1370010 | new / draft |
| N2-S1456 | [跳ねる](entries/1429/1429620-haneru.org) | はねる | 1429620 | new / draft |
| N2-S1460 | [早口](entries/1400/1400240-hayakuchi.org) | はやくち | 1400240 | new / draft |
| N2-S1475 | [半島](entries/1479/1479770-hantou.org) | はんとう | 1479770 | new / draft |
| N2-S1479 | [日帰り](entries/1463/1463920-higaeri.org) | ひがえり | 1463920 | new / draft |
| N2-S1488 | [卑怯](entries/1482/1482710-hikyou.org) | ひきょう | 1482710 | new / draft |
| N2-S1498 | [筆記](entries/1487/1487800-hikki.org) | ひっき | 1487800 | new / draft |
| N2-S1543 | [風船](entries/1499/1499940-fuusen.org) | ふうせん | 1499940 | new / draft |
| N2-S1556 | [不潔](entries/1492/1492160-fuketsu.org) | ふけつ | 1492160 | new / draft |
| N2-S1587 | [振り向く](entries/1361/1361190-furimuku.org) | ふりむく | 1361190 | new / draft |
| N2-S1659 | [盆](entries/1523/1523700-bon.org) | ぼん | 1523700 | new / draft |
| N2-S1662 | [本部](entries/1523/1523170-honbu.org) | ほんぶ | 1523170 | new / draft |
| N2-S1701 | [見上げる](entries/1259/1259740-miageru.org) | みあげる | 1259740 | new / draft |
| N2-S1705 | [三日月](entries/1301/1301340-mikazuki.org) | みかづき | 1301340 | new / draft |
| N2-S1706 | [岬](entries/1611/1611700-misaki.org) | みさき | 1611700 | new / draft |
| N2-S1710 | [自ら](entries/1317/1317340-mizukara.org) | みずから | 1317340 | new / draft |
| N2-S1711 | [水着](entries/1371/1371830-mizugi.org) | みずぎ | 1371830 | new / draft |
| N2-S1716 | [見詰める](entries/1604/1604580-mitsumeru.org) | みつめる | 1604580 | new / draft |
| N2-S1735 | [無数](entries/1530/1530280-musuu.org) | むすう | 1530280 | new / draft |
| N2-S1736 | [紫](entries/1311/1311640-murasaki.org) | むらさき | 1311640 | new / draft |
| N2-S1761 | [免税](entries/1533/1533230-menzei.org) | めんぜい | 1533230 | new / draft |
| N2-S1784 | [紅葉](entries/2857/2857870-momiji.org) | もみじ | 2857870 | new / draft |
| N2-S1820 | [行方](entries/1282/1282180-yukue.org) | ゆくえ | 1282180 | new / draft |
| N2-S1859 | [欄](entries/1549/1549350-ran.org) | らん | 1549350 | new / draft |
| N2-S1877 | [臨時](entries/1555/1555610-rinji.org) | りんじ | 1555610 | new / draft |
| N2-S1881 | [冷凍](entries/1557/1557170-reitou.org) | れいとう | 1557170 | new / draft |
| N2-S1887 | [連合](entries/1559/1559450-rengou.org) | れんごう | 1559450 | new / draft |
| JTest 1.1.3 | [向き合う](entries/1277/1277060-mukiau.org) | むきあう | 1277060 | new / draft |
| JTest 1.1.7 | [甘える](entries/1213/1213440-amaeru.org) | あまえる | 1213440 | new / draft |
| JTest 1.1.8 | [世間知らず](entries/1848/1848140-sekenshirazu.org) | せけんしらず | 1848140 | new / draft |
| JTest 1.1.11 | [自立](entries/1318/1318880-jiritsu.org) | じりつ | 1318880 | new / draft |
| JTest 1.1.15 | [説得](entries/1386/1386440-settoku.org) | せっとく | 1386440 | new / draft |
| JTest 1.1.19 | [放っておく](entries/1907/1907980-houtteoku.org) | ほうっておく | 1907980 | new / draft |
| JTest 1.1.20 | [介護](entries/1198/1198060-kaigo.org) | かいご | 1198060 | new / draft |
| JTest 1.1.22 | [世代](entries/1374/1374190-sedai.org) | せだい | 1374190 | new / draft |
| JTest 1.1.24 | [妊娠](entries/1467/1467350-ninshin.org) | にんしん | 1467350 | new / draft |
| JTest 1.1.25 | [出産](entries/1339/1339010-shussan.org) | しゅっさん | 1339010 | new / draft |
| JTest 1.1.26 | [産む](entries/1588/1588410-umu.org) | うむ | 1588410 | new / draft |
| JTest 1.2.9 | [見習う](entries/1259/1259700-minarau.org) | みならう | 1259700 | new / draft |
| JTest 1.2.10 | [打ち明ける](entries/1588/1588130-uchiakeru.org) | うちあける | 1588130 | new / draft |
| JTest 1.2.11 | [励ます](entries/1557/1557350-hagemasu.org) | はげます | 1557350 | new / draft |
| JTest 1.2.14 | [察する](entries/1298/1298740-sassuru.org) | さっする | 1298740 | new / draft |
| JTest 1.2.15 | [思いやり](entries/1309/1309180-omoiyari.org) | おもいやり | 1309180 | new / draft |
| JTest 1.2.16 | [何気ない](entries/1599/1599570-nanigenai.org) | なにげない | 1599570 | new / draft |
| JTest 1.2.18 | [幹事](entries/1212/1212110-kanji.org) | かんじ | 1212110 | new / draft |
| JTest 1.2.20 | [盛り上がる](entries/1379/1379690-moriagaru.org) | もりあがる | 1379690 | new / draft |
| JTest 1.2.23 | [久しい](entries/1227/1227340-hisashii.org) | ひさしい | 1227340 | new / draft |
| JTest 1.3.1 | [初対面](entries/1342/1342890-shotaimen.org) | しょたいめん | 1342890 | new / draft |
| JTest 1.3.2 | [自己紹介](entries/1317/1317650-jikoshoukai.org) | じこしょうかい | 1317650 | new / draft |
| JTest 1.3.6 | [飼い主](entries/1589/1589720-kainushi.org) | かいぬし | 1589720 | new / draft |
| JTest 1.3.7 | [交わす](entries/1590/1590750-kawasu.org) | かわす | 1590750 | new / draft |
| JTest 1.3.8 | [呼び止める](entries/1266/1266330-yobitomeru.org) | よびとめる | 1266330 | new / draft |
| JTest 1.3.9 | [振り返る](entries/1361/1361290-furikaeru.org) | ふりかえる | 1361290 | new / draft |
| JTest 1.3.10 | [再会](entries/1292/1292390-saikai.org) | さいかい | 1292390 | new / draft |
| JTest 1.3.13 | [結びつく](entries/1254/1254640-musubitsuku.org) | むすびつく | 1254640 | new / draft |
| JTest 1.3.22 | [気配り](entries/1614/1614540-kikubari.org) | きくばり | 1614540 | new / draft |
| JTest 1.3.24 | [同期](entries/1452/1452030-douki.org) | どうき | 1452030 | new / draft |
| JTest 1.4.3 | [同士](entries/1452/1452400-doushi.org) | どうし | 1452400 | new / draft |
| JTest 1.4.8 | [視線](entries/1312/1312060-shisen.org) | しせん | 1312060 | new / draft |
| JTest 1.4.19 | [禁物](entries/1241/1241660-kinmotsu.org) | きんもつ | 1241660 | new / draft |
| JTest 1.4.23 | [運命](entries/1173/1173030-unmei.org) | うんめい | 1173030 | new / draft |
| JTest 1.4.24 | [決意](entries/1254/1254220-ketsui.org) | けつい | 1254220 | new / draft |
| JTest 1.5.5 | [言い訳](entries/1587/1587030-iiwake.org) | いいわけ | 1587030 | new / draft |
| JTest 1.5.16 | [行為](entries/1281/1281830-koui.org) | こうい | 1281830 | new / draft |
| JTest 1.5.17 | [口論](entries/1277/1277000-kouron.org) | こうろん | 1277000 | new / draft |
| JTest 1.5.20 | [貸し借り](entries/1825/1825040-kashikari.org) | かしかり | 1825040 | new / draft |
| JTest 1.5.22 | [気まずい](entries/1222/1222550-kimazui.org) | きまずい | 1222550 | new / draft |
| JTest 1.5.23 | [今さら](entries/1289/1289150-imasara.org) | いまさら | 1289150 | new / draft |
| JTest 1.5.24 | [台無し](entries/1412/1412770-dainashi.org) | だいなし | 1412770 | new / draft |
| JTest 1.5.26 | [追い出す](entries/1432/1432350-oidasu.org) | おいだす | 1432350 | new / draft |
| JTest 1.5.27 | [仲間外れ](entries/1425/1425800-nakamahazure.org) | なかまはずれ | 1425800 | new / draft |

## Next JTest 100-word N2 continuation (2026-10-04)

Baseline: `91af692d`, with **700** new translated words on this branch.
Completed **100/100** additional distinct words; branch total **800**.
Words are committed individually in batches of ten. Every English sense has
original Ukrainian translations and nuance notes; each primary sense has
three graded Japanese, kana, Ukrainian, and English examples.
All completed batches passed JMdict validation, Org lint, and doctor 100/100
with zero errors or warnings. These remain learner drafts for editorial review.
The earlier uncommitted 罪 draft is preserved.

Selection: 100 candidates from [documented JTest N2 sections](sources/jlpt-n2/jtest/README.md).
Candidates are reconciled against pinned JMdict and existing entry IDs.
N2-69 (佚) remains deferred and is not counted.

Final audit: **100 distinct added JMdict IDs**, **100 individual word addition
commits**, **163 English senses with 163 Ukrainian nuance notes**, and
**300 graded examples**. The earlier 700 branch additions were preserved.
All 100 entries passed final JMdict validation, Org lint, and doctor 100/100,
with zero errors or warnings. Source snapshot checksums were verified for
17 documented sections. The full suite passed: **137 tests, 15,143 assertions**,
zero failures, errors, or skips. `git diff --check` passed. Only the pre-existing
uncommitted 罪 draft remains. Entries are learner drafts pending editorial review.

| Batch | New entries |
| --- | ---: |
| 1 | 10 |
| 2 | 10 |
| 3 | 10 |
| 4 | 10 |
| 5 | 10 |
| 6 | 10 |
| 7 | 10 |
| 8 | 10 |
| 9 | 10 |
| 10 | 10 |

| Source candidate | Word | Reading | JMdict ID | Status |
| --- | --- | --- | --- | --- |
| JTest 2.1.2 | [賃貸](entries/1432/1432030-chintai.org) | ちんたい | 1432030 | new / draft |
| JTest 2.1.3 | [敷金](entries/1497/1497040-shikikin.org) | しききん | 1497040 | new / draft |
| JTest 2.1.4 | [更新](entries/1279/1279370-koushin.org) | こうしん | 1279370 | new / draft |
| JTest 2.1.7 | [一戸建て](entries/1162/1162320-ikkodate.org) | いっこだて | 1162320 | new / draft |
| JTest 2.1.14 | [間取り](entries/1215/1215490-madori.org) | まどり | 1215490 | new / draft |
| JTest 2.1.15 | [空間](entries/1245/1245450-kuukan.org) | くうかん | 1245450 | new / draft |
| JTest 2.1.18 | [南向き](entries/1460/1460290-minamimuki.org) | みなみむき | 1460290 | new / draft |
| JTest 2.1.19 | [温もり](entries/1183/1183330-nukumori.org) | ぬくもり | 1183330 | new / draft |
| JTest 2.1.21 | [点検](entries/1441/1441540-tenken.org) | てんけん | 1441540 | new / draft |
| JTest 2.1.27 | [新築](entries/1362/1362160-shinchiku.org) | しんちく | 1362160 | new / draft |
| JTest 2.2.4 | [出費](entries/1340/1340180-shuppi.org) | しゅっぴ | 1340180 | new / draft |
| JTest 2.2.6 | [大金](entries/1413/1413500-taikin.org) | たいきん | 1413500 | new / draft |
| JTest 2.2.10 | [公共料金](entries/1273/1273590-koukyouryoukin.org) | こうきょうりょうきん | 1273590 | new / draft |
| JTest 2.2.12 | [引き落とし](entries/1950/1950210-hikiotoshi.org) | ひきおとし | 1950210 | new / draft |
| JTest 2.2.13 | [手数料](entries/1327/1327980-tesuuryou.org) | てすうりょう | 1327980 | new / draft |
| JTest 2.2.14 | [出し入れ](entries/1338/1338100-dashiire.org) | だしいれ | 1338100 | new / draft |
| JTest 2.2.15 | [高くつく](entries/2104/2104970-takakutsuku.org) | たかくつく | 2104970 | new / draft |
| JTest 2.2.16 | [残高](entries/1304/1304590-zandaka.org) | ざんだか | 1304590 | new / draft |
| JTest 2.2.21 | [立て替える](entries/1551/1551550-tatekaeru.org) | たてかえる | 1551550 | new / draft |
| JTest 2.2.23 | [返済](entries/1512/1512210-hensai.org) | へんさい | 1512210 | new / draft |
| JTest 2.3.2 | [好物](entries/1277/1277790-koubutsu.org) | こうぶつ | 1277790 | new / draft |
| JTest 2.3.4 | [物足りない](entries/1502/1502650-monotarinai.org) | ものたりない | 1502650 | new / draft |
| JTest 2.3.20 | [器](entries/1218/1218880-utsuwa.org) | うつわ | 1218880 | new / draft |
| JTest 2.3.23 | [主食](entries/1325/1325640-shushoku.org) | しゅしょく | 1325640 | new / draft |
| JTest 2.3.26 | [特製](entries/1455/1455100-tokusei.org) | とくせい | 1455100 | new / draft |
| JTest 2.4.1 | [購入](entries/1282/1282440-kounyuu.org) | こうにゅう | 1282440 | new / draft |
| JTest 2.4.2 | [買い得](entries/1752/1752990-kaidoku.org) | かいどく | 1752990 | new / draft |
| JTest 2.4.4 | [値引き](entries/1600/1600190-nebiki.org) | ねびき | 1600190 | new / draft |
| JTest 2.4.6 | [返品](entries/1512/1512300-henpin.org) | へんぴん | 1512300 | new / draft |
| JTest 2.4.7 | [返金](entries/1512/1512200-henkin.org) | へんきん | 1512200 | new / draft |
| JTest 2.4.12 | [品質](entries/1490/1490580-hinshitsu.org) | ひんしつ | 1490580 | new / draft |
| JTest 2.4.13 | [消費税](entries/1350/1350320-shouhizei.org) | しょうひぜい | 1350320 | new / draft |
| JTest 2.4.16 | [取り寄せる](entries/1326/1326620-toriyoseru.org) | とりよせる | 1326620 | new / draft |
| JTest 2.4.18 | [買い換える](entries/2012/2012810-kaikaeru.org) | かいかえる | 2012810 | new / draft |
| JTest 2.4.19 | [売り出す](entries/1473/1473860-uridasu.org) | うりだす | 1473860 | new / draft |
| JTest 2.4.21 | [切り取る](entries/1384/1384260-kiritoru.org) | きりとる | 1384260 | new / draft |
| JTest 2.4.24 | [試食](entries/1312/1312490-shishoku.org) | ししょく | 1312490 | new / draft |
| JTest 2.4.25 | [試着](entries/1312/1312500-shichaku.org) | しちゃく | 1312500 | new / draft |
| JTest 2.5.10 | [本年](entries/1523/1523120-honnen.org) | ほんねん | 1523120 | new / draft |
| JTest 2.5.16 | [後日](entries/1269/1269980-gojitsu.org) | ごじつ | 1269980 | new / draft |
| JTest 2.5.22 | [従来](entries/1335/1335400-juurai.org) | じゅうらい | 1335400 | new / draft |
| JTest 3.1.5 | [乳製品](entries/1465/1465260-nyuuseihin.org) | にゅうせいひん | 1465260 | new / draft |
| JTest 3.1.6 | [洗い物](entries/1609/1609080-araimono.org) | あらいもの | 1609080 | new / draft |
| JTest 3.1.7 | [欠かす](entries/1253/1253890-kakasu.org) | かかす | 1253890 | new / draft |
| JTest 3.1.10 | [一切](entries/1164/1164170-issai.org) | いっさい | 1164170 | new / draft |
| JTest 3.1.11 | [合間](entries/1284/1284670-aima.org) | あいま | 1284670 | new / draft |
| JTest 3.2.2 | [何度も](entries/1189/1189200-nandomo.org) | なんども | 1189200 | new / draft |
| JTest 3.2.4 | [寄り道](entries/1219/1219650-yorimichi.org) | よりみち | 1219650 | new / draft |
| JTest 3.2.8 | [物干し](entries/1605/1605290-monohoshi.org) | ものほし | 1605290 | new / draft |
| JTest 3.2.10 | [後回し](entries/1269/1269500-atomawashi.org) | あとまわし | 1269500 | new / draft |
| JTest 3.2.15 | [売り買い](entries/2012/2012850-urikai.org) | うりかい | 2012850 | new / draft |
| JTest 3.2.16 | [思い浮かべる](entries/1658/1658200-omoiukaberu.org) | おもいうかべる | 1658200 | new / draft |
| JTest 3.2.18 | [風呂場](entries/1500/1500140-furoba.org) | ふろば | 1500140 | new / draft |
| JTest 3.2.20 | [寝つき](entries/1360/1360000-netsuki.org) | ねつき | 1360000 | new / draft |
| JTest 3.3.8 | [味付け](entries/1526/1526980-ajitsuke.org) | あじつけ | 1526980 | new / draft |
| JTest 3.3.10 | [甘み](entries/1609/1609070-amami.org) | あまみ | 1609070 | new / draft |
| JTest 3.3.21 | [賞味期限](entries/1351/1351980-shoumikigen.org) | しょうみきげん | 1351980 | new / draft |
| JTest 3.3.22 | [手作り](entries/1598/1598360-tezukuri.org) | てづくり | 1598360 | new / draft |
| JTest 3.4.7 | [取り除く](entries/1326/1326780-torinozoku.org) | とりのぞく | 1326780 | new / draft |
| JTest 3.4.16 | [可燃ごみ](entries/2770/2770250-kanengomi.org) | かねんごみ | 2770250 | new / draft |
| JTest 3.4.17 | [資源ごみ](entries/2112/2112630-shigengomi.org) | しげんごみ | 2112630 | new / draft |
| JTest 3.4.18 | [粗大ごみ](entries/1397/1397030-sodaigomi.org) | そだいごみ | 1397030 | new / draft |
| JTest 3.4.19 | [古新聞](entries/1631/1631020-furushinbun.org) | ふるしんぶん | 1631020 | new / draft |
| JTest 3.4.20 | [分別](entries/1504/1504200-bunbetsu.org) | ぶんべつ | 1504200 | new / draft |
| JTest 3.4.21 | [ごみ袋](entries/2106/2106370-gomibukuro.org) | ごみぶくろ | 2106370 | new / draft |
| JTest 3.4.27 | [衣類](entries/1613/1613280-irui.org) | いるい | 1613280 | new / draft |
| JTest 3.4.28 | [入れ替える](entries/1587/1587790-irekaeru.org) | いれかえる | 1587790 | new / draft |
| JTest 3.5.2 | [不用品](entries/1495/1495190-fuyouhin.org) | ふようひん | 1495190 | new / draft |
| JTest 3.5.6 | [段ボール](entries/1419/1419930-danbooru.org) | だんボール | 1419930 | new / draft |
| JTest 3.5.8 | [押し込む](entries/1180/1180260-oshikomu.org) | おしこむ | 1180260 | new / draft |
| JTest 3.5.19 | [居心地](entries/1630/1630070-igokochi.org) | いごこち | 1630070 | new / draft |
| JTest 3.5.20 | [一変](entries/1166/1166420-ippen.org) | いっぺん | 1166420 | new / draft |
| JTest 1.1.5 | [養う](entries/1547/1547090-yashinau.org) | やしなう | 1547090 | new / draft |
| JTest 1.1.23 | [継ぐ](entries/1251/1251750-tsugu.org) | つぐ | 1251750 | new / draft |
| JTest 1.3.23 | [込める](entries/1288/1288790-komeru.org) | こめる | 1288790 | new / draft |
| JTest 2.2.5 | [赤字](entries/1383/1383440-akaji.org) | あかじ | 1383440 | new / draft |
| JTest 2.2.19 | [差し引く](entries/1291/1291100-sashihiku.org) | さしひく | 1291100 | new / draft |
| JTest 2.3.6 | [一口](entries/1162/1162370-hitokuchi.org) | ひとくち | 1162370 | new / draft |
| JTest 2.3.11 | [渋い](entries/1335/1335540-shibui.org) | しぶい | 1335540 | new / draft |
| JTest 3.1.20 | [整える](entries/1376/1376140-totonoeru.org) | ととのえる | 1376140 | new / draft |
| JTest 3.3.4 | [流し](entries/1552/1552100-nagashi.org) | ながし | 1552100 | new / draft |
| JTest 3.3.12 | [添える](entries/1596/1596490-soeru.org) | そえる | 1596490 | new / draft |
| JTest 3.4.8 | [素材](entries/1397/1397220-sozai.org) | そざい | 1397220 | new / draft |
| JTest 3.4.9 | [表示](entries/1489/1489610-hyouji.org) | ひょうじ | 1489610 | new / draft |
| JTest 3.4.22 | [生臭い](entries/1379/1379110-namagusai.org) | なまぐさい | 1379110 | new / draft |
| JTest 3.5.1 | [処分](entries/1342/1342490-shobun.org) | しょぶん | 1342490 | new / draft |
| JTest 4.1.7 | [絶える](entries/1386/1386710-taeru.org) | たえる | 1386710 | new / draft |
| JTest 4.1.17 | [抽選](entries/1426/1426220-chuusen.org) | ちゅうせん | 1426220 | new / draft |
| JTest 4.1.18 | [避難](entries/1484/1484660-hinan.org) | ひなん | 1484660 | new / draft |
| JTest 4.1.20 | [見回る](entries/1641/1641610-mimawaru.org) | みまわる | 1641610 | new / draft |
| JTest 4.1.21 | [築く](entries/1422/1422140-kizuku.org) | きずく | 1422140 | new / draft |
| JTest 4.1.23 | [落書き](entries/1548/1548770-rakugaki.org) | らくがき | 1548770 | new / draft |
| JTest 4.2.1 | [自治体](entries/1317/1317830-jichitai.org) | じちたい | 1317830 | new / draft |
| JTest 4.2.3 | [応える](entries/1179/1179810-kotaeru.org) | こたえる | 1179810 | new / draft |
| JTest 4.2.5 | [身分証明書](entries/1365/1365820-mibunshoumeisho.org) | みぶんしょうめいしょ | 1365820 | new / draft |
| JTest 4.2.9 | [年金](entries/1468/1468540-nenkin.org) | ねんきん | 1468540 | new / draft |
| JTest 4.2.10 | [施設](entries/1310/1310410-shisetsu.org) | しせつ | 1310410 | new / draft |
| JTest 4.2.15 | [福祉](entries/1501/1501060-fukushi.org) | ふくし | 1501060 | new / draft |
| JTest 4.2.18 | [収集](entries/1594/1594720-shuushuu.org) | しゅうしゅう | 1594720 | new / draft |
| JTest 4.2.19 | [配布](entries/1473/1473190-haifu.org) | はいふ | 1473190 | new / draft |

## Final 900-word branch N2 continuation (2026-10-04)

Baseline: `0ffefe81`, with **800** new translated words on this branch.
Completed **100/100** additional distinct words; branch total **900**.
Words are committed individually in batches of ten. Every English sense has
original Ukrainian translations and nuance notes; each primary sense has
three graded Japanese, kana, Ukrainian, and English examples.
All completed batches passed JMdict validation, Org lint, and doctor 100/100
with zero errors or warnings. These remain learner drafts for editorial review.
The earlier uncommitted 罪 draft is preserved.

Candidates are reconciled against pinned JMdict and existing entry IDs.
The 100 supplementary N2 labels come from the [documented JTest list](sources/jlpt-n2/jtest/README.md);
only lexical labels and readings were used, with original Ukrainian content.
N2-69 (佚) remains deferred and is not counted.

Final audit: **800 → 900** branch additions, exactly **100** distinct new
JMdict IDs, **100** individual word-addition commits, **10** batch ledger
commits, **166** translated English senses with Ukrainian nuance notes, and
**300** graded examples. The preceding 800 entry files are unchanged.
All 28 documented JTest HTML checksums match the retrieved source pages.
The full suite passed: **137 tests, 15,443 assertions, zero failures or errors**.
The preserved uncommitted 罪 draft is excluded from these counts.

| Batch | New entries |
| --- | ---: |
| 1 | 10 |
| 2 | 10 |
| 3 | 10 |
| 4 | 10 |
| 5 | 10 |
| 6 | 10 |
| 7 | 10 |
| 8 | 10 |
| 9 | 10 |
| 10 | 10 |

| Source candidate | Word | Reading | JMdict ID | Status |
| --- | --- | --- | --- | --- |
| JTest 1.3.4 | [近所付き合い](entries/2116/2116150-kinjozukiai.org) | きんじょづきあい | 2116150 | new / draft |
| JTest 1.3.11 | [覚え](entries/1206/1206040-oboe.org) | おぼえ | 1206040 | new / draft |
| JTest 1.4.21 | [合コン](entries/1951/1951580-goukon.org) | ごうコン | 1951580 | new / draft |
| JTest 2.1.1 | [一人住まい](entries/2405/2405230-hitorizumai.org) | ひとりずまい | 2405230 | new / draft |
| JTest 2.1.9 | [我が家](entries/1606/1606650-wagaya.org) | わがや | 1606650 | new / draft |
| JTest 2.1.12 | [洗面所](entries/1391/1391070-senmenjo.org) | せんめんじょ | 1391070 | new / draft |
| JTest 4.2.22 | [提供](entries/1436/1436360-teikyou.org) | ていきょう | 1436360 | new / draft |
| JTest 4.3.1 | [故郷](entries/2853/2853884-kokyou.org) | こきょう | 2853884 | new / draft |
| JTest 4.3.2 | [地元](entries/1421/1421060-jimoto.org) | じもと | 1421060 | new / draft |
| JTest 4.3.5 | [帰省](entries/1221/1221390-kisei.org) | きせい | 1221390 | new / draft |
| JTest 4.3.15 | [近郊](entries/1242/1242290-kinkou.org) | きんこう | 1242290 | new / draft |
| JTest 4.3.17 | [若者](entries/1324/1324350-wakamono.org) | わかもの | 1324350 | new / draft |
| JTest 4.3.20 | [担う](entries/1599/1599900-ninau.org) | になう | 1599900 | new / draft |
| JTest 4.4.6 | [歩行者](entries/1514/1514380-hokousha.org) | ほこうしゃ | 1514380 | new / draft |
| JTest 4.4.10 | [運賃](entries/1172/1172820-unchin.org) | うんちん | 1172820 | new / draft |
| JTest 4.4.13 | [見合わせる](entries/1259/1259570-miawaseru.org) | みあわせる | 1259570 | new / draft |
| JTest 4.4.14 | [乱れる](entries/1548/1548940-midareru.org) | みだれる | 1548940 | new / draft |
| JTest 4.4.15 | [再開](entries/1292/1292400-saikai.org) | さいかい | 1292400 | new / draft |
| JTest 4.4.28 | [気を抜く](entries/2127/2127660-kiwonuku.org) | きをぬく | 2127660 | new / draft |
| JTest 4.5.3 | [栽培](entries/1294/1294910-saibai.org) | さいばい | 1294910 | new / draft |
| JTest 4.5.7 | [栄える](entries/1173/1173860-sakaeru.org) | さかえる | 1173860 | new / draft |
| JTest 4.5.9 | [急増](entries/1228/1228870-kyuuzou.org) | きゅうぞう | 1228870 | new / draft |
| JTest 4.5.10 | [情緒](entries/1580/1580510-joucho.org) | じょうちょ | 1580510 | new / draft |
| JTest 4.5.11 | [向上](entries/1277/1277250-koujou.org) | こうじょう | 1277250 | new / draft |
| JTest 4.5.19 | [著しい](entries/1427/1427070-ichijirushii.org) | いちじるしい | 1427070 | new / draft |
| JTest 4.5.22 | [現地](entries/1263/1263860-genchi.org) | げんち | 1263860 | new / draft |
| JTest 5.1.2 | [願書](entries/1218/1218050-gansho.org) | がんしょ | 1218050 | new / draft |
| JTest 5.1.7 | [通常](entries/1433/1433280-tsuujou.org) | つうじょう | 1433280 | new / draft |
| JTest 5.1.8 | [担任](entries/1418/1418200-tannin.org) | たんにん | 1418200 | new / draft |
| JTest 5.1.12 | [充実](entries/1334/1334340-juujitsu.org) | じゅうじつ | 1334340 | new / draft |
| JTest 5.1.19 | [修了](entries/1332/1332450-shuuryou.org) | しゅうりょう | 1332450 | new / draft |
| JTest 5.1.21 | [認識](entries/1467/1467550-ninshiki.org) | にんしき | 1467550 | new / draft |
| JTest 5.2.5 | [参考書](entries/1302/1302300-sankousho.org) | さんこうしょ | 1302300 | new / draft |
| JTest 5.2.6 | [書き込む](entries/1343/1343730-kakikomu.org) | かきこむ | 1343730 | new / draft |
| JTest 5.2.7 | [書き取る](entries/1343/1343780-kakitoru.org) | かきとる | 1343780 | new / draft |
| JTest 5.2.12 | [志す](entries/1309/1309060-kokorozasu.org) | こころざす | 1309060 | new / draft |
| JTest 5.2.17 | [根気](entries/1290/1290110-konki.org) | こんき | 1290110 | new / draft |
| JTest 5.2.27 | [混同](entries/1290/1290480-kondou.org) | こんどう | 1290480 | new / draft |
| JTest 5.3.1 | [挑戦](entries/1428/1428240-chousen.org) | ちょうせん | 1428240 | new / draft |
| JTest 5.3.5 | [課題](entries/1195/1195820-kadai.org) | かだい | 1195820 | new / draft |
| JTest 5.3.6 | [段落](entries/1419/1419980-danraku.org) | だんらく | 1419980 | new / draft |
| JTest 5.3.8 | [用紙](entries/1546/1546290-youshi.org) | ようし | 1546290 | new / draft |
| JTest 5.3.13 | [言い換える](entries/1610/1610580-iikaeru.org) | いいかえる | 1610580 | new / draft |
| JTest 5.3.14 | [考え込む](entries/1281/1281030-kangaekomu.org) | かんがえこむ | 1281030 | new / draft |
| JTest 5.3.16 | [紛らわしい](entries/1504/1504990-magirawashii.org) | まぎらわしい | 1504990 | new / draft |
| JTest 5.3.19 | [本番](entries/1523/1523150-honban.org) | ほんばん | 1523150 | new / draft |
| JTest 5.3.24 | [回収](entries/1199/1199470-kaishuu.org) | かいしゅう | 1199470 | new / draft |
| JTest 5.4.1 | [受講](entries/1329/1329760-jukou.org) | じゅこう | 1329760 | new / draft |
| JTest 5.4.2 | [書き留める](entries/1343/1343940-kakitomeru.org) | かきとめる | 1343940 | new / draft |
| JTest 5.4.4 | [心構え](entries/1360/1360670-kokorogamae.org) | こころがまえ | 1360670 | new / draft |
| JTest 5.4.7 | [取り組む](entries/1326/1326820-torikumu.org) | とりくむ | 1326820 | new / draft |
| JTest 5.4.8 | [意欲](entries/1587/1587690-iyoku.org) | いよく | 1587690 | new / draft |
| JTest 5.4.14 | [受け入れる](entries/1329/1329670-ukeireru.org) | うけいれる | 1329670 | new / draft |
| JTest 5.4.27 | [挙げる](entries/2864/2864818-ageru.org) | あげる | 2864818 | new / draft |
| JTest 5.4.29 | [手書き](entries/1327/1327830-tegaki.org) | てがき | 1327830 | new / draft |
| JTest 5.4.30 | [一気に](entries/1161/1161730-ikkini.org) | いっきに | 1161730 | new / draft |
| JTest 5.5.1 | [起動](entries/1223/1223880-kidou.org) | きどう | 1223880 | new / draft |
| JTest 5.5.2 | [本体](entries/1522/1522950-hontai.org) | ほんたい | 1522950 | new / draft |
| JTest 5.5.6 | [検索](entries/1257/1257900-kensaku.org) | けんさく | 1257900 | new / draft |
| JTest 5.5.7 | [転送](entries/1441/1441250-tensou.org) | てんそう | 1441250 | new / draft |
| JTest 5.5.8 | [文書](entries/1583/1583840-bunsho.org) | ぶんしょ | 1583840 | new / draft |
| JTest 5.5.9 | [設定](entries/1386/1386060-settei.org) | せってい | 1386060 | new / draft |
| JTest 5.5.10 | [余白](entries/1544/1544480-yohaku.org) | よはく | 1544480 | new / draft |
| JTest 5.5.13 | [改行](entries/1200/1200820-kaigyou.org) | かいぎょう | 1200820 | new / draft |
| JTest 5.5.15 | [貼り付ける](entries/1601/1601120-haritsukeru.org) | はりつける | 1601120 | new / draft |
| JTest 5.5.18 | [消去](entries/1350/1350190-shoukyo.org) | しょうきょ | 1350190 | new / draft |
| JTest 5.5.19 | [上書き保存](entries/2830/2830197-uwagakihozon.org) | うわがきほぞん | 2830197 | new / draft |
| JTest 6.1.1 | [求人](entries/1229/1229500-kyuujin.org) | きゅうじん | 1229500 | new / draft |
| JTest 6.1.2 | [志望](entries/1309/1309140-shibou.org) | しぼう | 1309140 | new / draft |
| JTest 6.1.4 | [携わる](entries/1250/1250660-tazusawaru.org) | たずさわる | 1250660 | new / draft |
| JTest 6.1.5 | [生かす](entries/1587/1587070-ikasu.org) | いかす | 1587070 | new / draft |
| JTest 6.1.6 | [貴社](entries/1223/1223510-kisha.org) | きしゃ | 1223510 | new / draft |
| JTest 6.1.8 | [動機](entries/1451/1451310-douki.org) | どうき | 1451310 | new / draft |
| JTest 6.1.9 | [熱意](entries/1467/1467760-netsui.org) | ねつい | 1467760 | new / draft |
| JTest 6.1.10 | [学歴](entries/1207/1207200-gakureki.org) | がくれき | 1207200 | new / draft |
| JTest 6.1.11 | [不問](entries/1495/1495130-fumon.org) | ふもん | 1495130 | new / draft |
| JTest 6.1.13 | [特技](entries/1454/1454740-tokugi.org) | とくぎ | 1454740 | new / draft |
| JTest 6.1.14 | [協調](entries/1235/1235700-kyouchou.org) | きょうちょう | 1235700 | new / draft |
| JTest 6.1.16 | [精一杯](entries/1379/1379870-seiippai.org) | せいいっぱい | 1379870 | new / draft |
| JTest 6.1.18 | [対応](entries/1409/1409840-taiou.org) | たいおう | 1409840 | new / draft |
| JTest 6.1.20 | [望ましい](entries/1519/1519610-nozomashii.org) | のぞましい | 1519610 | new / draft |
| JTest 6.1.21 | [好ましい](entries/1277/1277490-konomashii.org) | このましい | 1277490 | new / draft |
| JTest 6.1.25 | [内定](entries/1458/1458920-naitei.org) | ないてい | 1458920 | new / draft |
| JTest 6.1.26 | [辞退](entries/1318/1318990-jitai.org) | じたい | 1318990 | new / draft |
| JTest 6.1.30 | [社会人](entries/1322/1322770-shakaijin.org) | しゃかいじん | 1322770 | new / draft |
| JTest 6.1.31 | [自覚](entries/1317/1317490-jikaku.org) | じかく | 1317490 | new / draft |
| JTest 6.2.1 | [大企業](entries/1413/1413300-daikigyou.org) | だいきぎょう | 1413300 | new / draft |
| JTest 6.2.2 | [大手](entries/1414/1414010-oote.org) | おおて | 1414010 | new / draft |
| JTest 6.2.6 | [従業員](entries/1335/1335250-juugyouin.org) | じゅうぎょういん | 1335250 | new / draft |
| JTest 6.2.7 | [新入社員](entries/1362/1362250-shinnyuushain.org) | しんにゅうしゃいん | 1362250 | new / draft |
| JTest 6.2.8 | [派遣社員](entries/1999/1999690-hakenshain.org) | はけんしゃいん | 1999690 | new / draft |
| JTest 6.2.13 | [出世](entries/1339/1339340-shusse.org) | しゅっせ | 1339340 | new / draft |
| JTest 6.2.14 | [昇進](entries/1349/1349780-shoushin.org) | しょうしん | 1349780 | new / draft |
| JTest 6.2.15 | [転勤](entries/1441/1441120-tenkin.org) | てんきん | 1441120 | new / draft |
| JTest 6.2.16 | [赴任](entries/1498/1498200-funin.org) | ふにん | 1498200 | new / draft |
| JTest 6.2.17 | [有給休暇](entries/1541/1541210-yuukyuukyuuka.org) | ゆうきゅうきゅうか | 1541210 | new / draft |
| JTest 6.2.19 | [人材](entries/1367/1367760-jinzai.org) | じんざい | 1367760 | new / draft |
| JTest 6.2.22 | [業績](entries/1239/1239460-gyouseki.org) | ぎょうせき | 1239460 | new / draft |
| JTest 6.2.30 | [果たす](entries/1192/1192850-hatasu.org) | はたす | 1192850 | new / draft |
| JTest 6.3.3 | [生きがい](entries/1378/1378550-ikigai.org) | いきがい | 1378550 | new / draft |

## Final 1100-word branch N2 continuation (2026-10-04)

Baseline: `945bbe61`, with **900** new translated words on this branch.
Completed **200/200** additional distinct words; branch total **1100**.
Words are committed individually in batches of ten. Every English sense has
original Ukrainian translations and nuance notes; each primary sense has
three graded Japanese, kana, Ukrainian, and English examples.
All completed batches passed JMdict validation, Org lint, and doctor 100/200
with zero errors or warnings. These remain learner drafts for editorial review.
The earlier uncommitted 罪 draft is preserved.

Candidates are reconciled against pinned JMdict and existing entry IDs.
The 200 supplementary N2 labels come from the [documented JTest list](sources/jlpt-n2/jtest/README.md);
only lexical labels and readings were used, with original Ukrainian content.
N2-69 (佚) remains deferred and is not counted.

Final audit: **900 → 1100** branch additions, exactly **200** distinct new
JMdict IDs, **200** individual word-addition commits, **20** batch ledger
commits, **311** translated English senses with Ukrainian nuance notes, and
**600** graded examples. The preceding 900 entry files are unchanged.
All 54 documented JTest HTML checksums match the retrieved source pages.
The full suite passed: **137 tests, 16,043 assertions, zero failures or errors**.
All 200 entries passed JMdict validation, Org lint, and doctor 100/100 with
zero errors or warnings. The [熱中症 entry](entries/2097/2097700-netchuushou.org)
includes an official source for its broader heat-related-illness terminology.
The preserved uncommitted 罪 draft is excluded from these counts.

| Batch | New entries |
| --- | ---: |
| 1 | 10 |
| 2 | 10 |
| 3 | 10 |
| 4 | 10 |
| 5 | 10 |
| 6 | 10 |
| 7 | 10 |
| 8 | 10 |
| 9 | 10 |
| 10 | 10 |
| 11 | 10 |
| 12 | 10 |
| 13 | 10 |
| 14 | 10 |
| 15 | 10 |
| 16 | 10 |
| 17 | 10 |
| 18 | 10 |
| 19 | 10 |
| 20 | 10 |

| Source candidate | Word | Reading | JMdict ID | Status |
| --- | --- | --- | --- | --- |
| JTest 6.3.9 | [伝言](entries/1582/1582180-dengon.org) | でんごん | 1582180 | new / draft |
| JTest 6.3.13 | [意図](entries/1156/1156690-ito.org) | いと | 1156690 | new / draft |
| JTest 6.3.16 | [取り引き](entries/1599/1599120-torihiki.org) | とりひき | 1599120 | new / draft |
| JTest 6.3.21 | [成果](entries/1375/1375650-seika.org) | せいか | 1375650 | new / draft |
| JTest 6.3.22 | [達成](entries/1416/1416260-tassei.org) | たっせい | 1416260 | new / draft |
| JTest 6.3.24 | [保留](entries/1514/1514030-horyuu.org) | ほりゅう | 1514030 | new / draft |
| JTest 6.3.25 | [やり直す](entries/1605/1605620-yarinaosu.org) | やりなおす | 1605620 | new / draft |
| JTest 6.3.26 | [件](entries/1255/1255940-ken.org) | けん | 1255940 | new / draft |
| JTest 6.3.27 | [急用](entries/1228/1228990-kyuuyou.org) | きゅうよう | 1228990 | new / draft |
| JTest 6.3.29 | [手順](entries/1327/1327810-tejun.org) | てじゅん | 1327810 | new / draft |
| JTest 6.4.6 | [忠告](entries/1426/1426140-chuukoku.org) | ちゅうこく | 1426140 | new / draft |
| JTest 6.4.9 | [押し付ける](entries/1180/1180360-oshitsukeru.org) | おしつける | 1180360 | new / draft |
| JTest 6.4.15 | [反論](entries/1481/1481130-hanron.org) | はんろん | 1481130 | new / draft |
| JTest 6.4.17 | [やる気](entries/2005/2005890-yaruki.org) | やるき | 2005890 | new / draft |
| JTest 6.4.18 | [お世辞](entries/1002/1002250-oseji.org) | おせじ | 1002250 | new / draft |
| JTest 6.4.24 | [平社員](entries/2078/2078660-hirashain.org) | ひらしゃいん | 2078660 | new / draft |
| JTest 6.5.1 | [退職](entries/1411/1411420-taishoku.org) | たいしょく | 1411420 | new / draft |
| JTest 6.5.2 | [転職](entries/1441/1441210-tenshoku.org) | てんしょく | 1441210 | new / draft |
| JTest 6.5.3 | [首になる](entries/1640/1640370-kubininaru.org) | くびになる | 1640370 | new / draft |
| JTest 6.5.10 | [辛抱](entries/1365/1365930-shinbou.org) | しんぼう | 1365930 | new / draft |
| JTest 6.5.12 | [負う](entries/1497/1497930-ou.org) | おう | 1497930 | new / draft |
| JTest 6.5.14 | [やむを得ず](entries/1310/1310650-yamuwoezu.org) | やむをえず | 1310650 | new / draft |
| JTest 6.5.15 | [立ち上げる](entries/1551/1551380-tachiageru.org) | たちあげる | 1551380 | new / draft |
| JTest 6.5.16 | [試みる](entries/1312/1312280-kokoromiru.org) | こころみる | 1312280 | new / draft |
| JTest 6.5.17 | [専念](entries/1389/1389850-sennen.org) | せんねん | 1389850 | new / draft |
| JTest 6.5.20 | [逃す](entries/1450/1450430-nogasu.org) | のがす | 1450430 | new / draft |
| JTest 6.5.24 | [身の回り](entries/1365/1365590-minomawari.org) | みのまわり | 1365590 | new / draft |
| JTest 7.1.2 | [競う](entries/1234/1234040-kisou.org) | きそう | 1234040 | new / draft |
| JTest 7.1.6 | [勝利](entries/1346/1346240-shouri.org) | しょうり | 1346240 | new / draft |
| JTest 7.1.9 | [敗れる](entries/1472/1472510-yabureru.org) | やぶれる | 1472510 | new / draft |
| JTest 7.1.11 | [逆転](entries/1227/1227170-gyakuten.org) | ぎゃくてん | 1227170 | new / draft |
| JTest 7.1.13 | [中断](entries/1424/1424900-chuudan.org) | ちゅうだん | 1424900 | new / draft |
| JTest 7.1.21 | [順位](entries/1342/1342260-juni.org) | じゅんい | 1342260 | new / draft |
| JTest 7.1.27 | [技](entries/1225/1225090-waza.org) | わざ | 1225090 | new / draft |
| JTest 7.2.2 | [持ち物](entries/1605/1605240-mochimono.org) | もちもの | 1605240 | new / draft |
| JTest 7.2.3 | [身につける](entries/1980/1980660-minitsukeru.org) | みにつける | 1980660 | new / draft |
| JTest 7.2.10 | [見た目](entries/1611/1611750-mitame.org) | みため | 1611750 | new / draft |
| JTest 7.2.11 | [人目](entries/1580/1580760-hitome.org) | ひとめ | 1580760 | new / draft |
| JTest 7.2.12 | [色彩](entries/1357/1357720-shikisai.org) | しきさい | 1357720 | new / draft |
| JTest 7.3.4 | [興奮](entries/1238/1238380-koufun.org) | こうふん | 1238380 | new / draft |
| JTest 7.3.15 | [芸術家](entries/1253/1253070-geijutsuka.org) | げいじゅつか | 1253070 | new / draft |
| JTest 7.4.2 | [絵本](entries/1202/1202380-ehon.org) | えほん | 1202380 | new / draft |
| JTest 7.4.5 | [書き手](entries/1701/1701600-kakite.org) | かきて | 1701600 | new / draft |
| JTest 7.4.7 | [主人公](entries/1325/1325680-shujinkou.org) | しゅじんこう | 1325680 | new / draft |
| JTest 7.4.16 | [背景](entries/1472/1472720-haikei.org) | はいけい | 1472720 | new / draft |
| JTest 7.4.21 | [由来](entries/1541/1541810-yurai.org) | ゆらい | 1541810 | new / draft |
| JTest 7.4.26 | [生み出す](entries/1378/1378720-umidasu.org) | うみだす | 1378720 | new / draft |
| JTest 7.4.27 | [読書家](entries/1688/1688400-dokushoka.org) | どくしょか | 1688400 | new / draft |
| JTest 7.5.1 | [習い事](entries/1642/1642710-naraigoto.org) | ならいごと | 1642710 | new / draft |
| JTest 7.5.4 | [凝る](entries/1239/1239070-koru.org) | こる | 1239070 | new / draft |
| JTest 7.5.9 | [初心者](entries/1342/1342860-shoshinsha.org) | しょしんしゃ | 1342860 | new / draft |
| JTest 7.5.17 | [占い](entries/1389/1389410-uranai.org) | うらない | 1389410 | new / draft |
| JTest 7.5.18 | [手話](entries/1328/1328440-shuwa.org) | しゅわ | 1328440 | new / draft |
| JTest 7.5.23 | [宝くじ](entries/1516/1516170-takarakuji.org) | たからくじ | 1516170 | new / draft |
| JTest 7.5.27 | [組み合わせる](entries/1397/1397480-kumiawaseru.org) | くみあわせる | 1397480 | new / draft |
| JTest 7.5.28 | [身近](entries/1365/1365650-mijika.org) | みぢか | 1365650 | new / draft |
| JTest 8.1.6 | [初夏](entries/1342/1342580-shoka.org) | しょか | 1342580 | new / draft |
| JTest 8.1.17 | [冷え込む](entries/1556/1556640-hiekomu.org) | ひえこむ | 1556640 | new / draft |
| JTest 8.1.19 | [日和](entries/1464/1464950-hiyori.org) | ひより | 1464950 | new / draft |
| JTest 8.2.5 | [降水量](entries/1282/1282900-kousuiryou.org) | こうすいりょう | 1282900 | new / draft |
| JTest 8.2.7 | [大気](entries/1413/1413330-taiki.org) | たいき | 1413330 | new / draft |
| JTest 8.2.11 | [応答](entries/1180/1180000-outou.org) | おうとう | 1180000 | new / draft |
| JTest 8.2.15 | [及ぶ](entries/1228/1228170-oyobu.org) | およぶ | 1228170 | new / draft |
| JTest 8.2.23 | [災害](entries/1295/1295100-saigai.org) | さいがい | 1295100 | new / draft |
| JTest 8.3.1 | [大地](entries/1414/1414520-daichi.org) | だいち | 1414520 | new / draft |
| JTest 8.3.7 | [海辺](entries/1201/1201750-umibe.org) | うみべ | 1201750 | new / draft |
| JTest 8.3.19 | [夕焼け](entries/1542/1542720-yuuyake.org) | ゆうやけ | 1542720 | new / draft |
| JTest 8.3.20 | [飛び回る](entries/1485/1485270-tobimawaru.org) | とびまわる | 1485270 | new / draft |
| JTest 8.4.10 | [切り替える](entries/1591/1591780-kirikaeru.org) | きりかえる | 1591780 | new / draft |
| JTest 8.4.22 | [見渡す](entries/1259/1259920-miwatasu.org) | みわたす | 1259920 | new / draft |
| JTest 8.5.3 | [訪れる](entries/1518/1518080-otozureru.org) | おとずれる | 1518080 | new / draft |
| JTest 8.5.4 | [体験](entries/1409/1409420-taiken.org) | たいけん | 1409420 | new / draft |
| JTest 8.5.6 | [見聞き](entries/1260/1260040-mikiki.org) | みきき | 1260040 | new / draft |
| JTest 8.5.9 | [思い立つ](entries/1309/1309420-omoitatsu.org) | おもいたつ | 1309420 | new / draft |
| JTest 8.5.11 | [手配](entries/1328/1328260-tehai.org) | てはい | 1328260 | new / draft |
| JTest 8.5.12 | [前もって](entries/1603/1603820-maemotte.org) | まえもって | 1603820 | new / draft |
| JTest 8.5.14 | [空席](entries/1245/1245690-kuuseki.org) | くうせき | 1245690 | new / draft |
| JTest 8.5.17 | [思いがけず](entries/1309/1309200-omoigakezu.org) | おもいがけず | 1309200 | new / draft |
| JTest 8.5.22 | [旅先](entries/1553/1553220-tabisaki.org) | たびさき | 1553220 | new / draft |
| JTest 8.5.26 | [免税店](entries/1823/1823120-menzeiten.org) | めんぜいてん | 1823120 | new / draft |
| JTest 9.1.4 | [体力](entries/1409/1409760-tairyoku.org) | たいりょく | 1409760 | new / draft |
| JTest 9.1.10 | [一般に](entries/1165/1165800-ippanni.org) | いっぱんに | 1165800 | new / draft |
| JTest 9.1.13 | [つま先](entries/1433/1433910-tsumasaki.org) | つまさき | 1433910 | new / draft |
| JTest 9.1.14 | [血管](entries/1255/1255180-kekkan.org) | けっかん | 1255180 | new / draft |
| JTest 9.1.18 | [乗り越える](entries/1354/1354770-norikoeru.org) | のりこえる | 1354770 | new / draft |
| JTest 9.1.19 | [傷跡](entries/1591/1591230-kizuato.org) | きずあと | 1591230 | new / draft |
| JTest 9.2.2 | [疲労](entries/1483/1483780-hirou.org) | ひろう | 1483780 | new / draft |
| JTest 9.2.3 | [不調](entries/1493/1493840-fuchou.org) | ふちょう | 1493840 | new / draft |
| JTest 9.2.4 | [体調](entries/1409/1409610-taichou.org) | たいちょう | 1409610 | new / draft |
| JTest 9.2.6 | [寝心地](entries/1792/1792820-negokochi.org) | ねごこち | 1792820 | new / draft |
| JTest 9.2.8 | [念のため](entries/1469/1469350-nennotame.org) | ねんのため | 1469350 | new / draft |
| JTest 9.2.9 | [通院](entries/1433/1433040-tsuuin.org) | つういん | 1433040 | new / draft |
| JTest 9.2.16 | [補給](entries/1514/1514510-hokyuu.org) | ほきゅう | 1514510 | new / draft |
| JTest 9.2.19 | [取り戻す](entries/1326/1326940-torimodosu.org) | とりもどす | 1326940 | new / draft |
| JTest 9.2.21 | [加入](entries/1190/1190430-kanyuu.org) | かにゅう | 1190430 | new / draft |
| JTest 9.3.7 | [視野](entries/1312/1312140-shiya.org) | しや | 1312140 | new / draft |
| JTest 9.3.11 | [便秘](entries/1512/1512580-benpi.org) | べんぴ | 1512580 | new / draft |
| JTest 9.3.13 | [寒気](entries/1210/1210410-samuke.org) | さむけ | 1210410 | new / draft |
| JTest 9.3.19 | [伴う](entries/1478/1478370-tomonau.org) | ともなう | 1478370 | new / draft |
| JTest 9.3.22 | [反応](entries/1480/1480210-hannou.org) | はんのう | 1480210 | new / draft |
| JTest 9.4.1 | [病む](entries/1490/1490210-yamu.org) | やむ | 1490210 | new / draft |
| JTest 9.4.2 | [負傷](entries/1498/1498100-fushou.org) | ふしょう | 1498100 | new / draft |
| JTest 9.4.4 | [熱中症](entries/2097/2097700-netchuushou.org) | ねっちゅうしょう | 2097700 | new / draft |
| JTest 9.4.5 | [細菌](entries/1295/1295590-saikin.org) | さいきん | 1295590 | new / draft |
| JTest 9.4.10 | [負担](entries/1498/1498130-futan.org) | ふたん | 1498130 | new / draft |
| JTest 9.4.12 | [手当て](entries/1598/1598240-teate.org) | てあて | 1598240 | new / draft |
| JTest 9.4.13 | [尽くす](entries/1370/1370090-tsukusu.org) | つくす | 1370090 | new / draft |
| JTest 9.4.15 | [作用](entries/1298/1298000-sayou.org) | さよう | 1298000 | new / draft |
| JTest 9.4.17 | [副作用](entries/1500/1500400-fukusayou.org) | ふくさよう | 1500400 | new / draft |
| JTest 9.4.21 | [告げる](entries/1285/1285990-tsugeru.org) | つげる | 1285990 | new / draft |
| JTest 9.4.24 | [配慮](entries/1473/1473210-hairyo.org) | はいりょ | 1473210 | new / draft |
| JTest 9.4.25 | [遺伝](entries/1159/1159460-iden.org) | いでん | 1159460 | new / draft |
| JTest 9.5.12 | [脂肪](entries/1311/1311820-shibou.org) | しぼう | 1311820 | new / draft |
| JTest 9.5.13 | [肥満](entries/1484/1484300-himan.org) | ひまん | 1484300 | new / draft |
| JTest 9.5.14 | [減量](entries/1263/1263350-genryou.org) | げんりょう | 1263350 | new / draft |
| JTest 9.5.16 | [一向に](entries/1609/1609230-ikkouni.org) | いっこうに | 1609230 | new / draft |
| JTest 9.5.17 | [疑わしい](entries/1225/1225530-utagawashii.org) | うたがわしい | 1225530 | new / draft |
| JTest 9.5.20 | [依存](entries/1575/1575870-izon.org) | いぞん | 1575870 | new / draft |
| JTest 10.1.2 | [続出](entries/1405/1405820-zokushutsu.org) | ぞくしゅつ | 1405820 | new / draft |
| JTest 10.1.6 | [拒否](entries/1232/1232410-kyohi.org) | きょひ | 1232410 | new / draft |
| JTest 10.1.14 | [暴力](entries/1519/1519590-bouryoku.org) | ぼうりょく | 1519590 | new / draft |
| JTest 10.1.16 | [進入](entries/1366/1366180-shinnyuu.org) | しんにゅう | 1366180 | new / draft |
| JTest 10.1.18 | [見知らぬ](entries/1259/1259860-mishiranu.org) | みしらぬ | 1259860 | new / draft |
| JTest 10.1.20 | [縮まる](entries/1337/1337540-chijimaru.org) | ちぢまる | 1337540 | new / draft |
| JTest 10.1.21 | [無理やり](entries/1531/1531030-muriyari.org) | むりやり | 1531030 | new / draft |
| JTest 10.1.22 | [捜査](entries/1399/1399660-sousa.org) | そうさ | 1399660 | new / draft |
| JTest 10.1.23 | [確定](entries/1205/1205880-kakutei.org) | かくてい | 1205880 | new / draft |
| JTest 10.1.27 | [居場所](entries/1630/1630060-ibasho.org) | いばしょ | 1630060 | new / draft |
| JTest 10.1.28 | [持ち主](entries/1605/1605230-mochinushi.org) | もちぬし | 1605230 | new / draft |
| JTest 10.1.30 | [実に](entries/2820/2820720-jitsuni.org) | じつに | 2820720 | new / draft |
| JTest 10.2.1 | [発生](entries/1477/1477620-hassei.org) | はっせい | 1477620 | new / draft |
| JTest 10.2.2 | [相次ぐ](entries/1400/1400980-aitsugu.org) | あいつぐ | 1400980 | new / draft |
| JTest 10.2.5 | [あり得ない](entries/2109/2109610-arienai.org) | ありえない | 2109610 | new / draft |
| JTest 10.2.6 | [荒っぽい](entries/1281/1281470-arappoi.org) | あらっぽい | 1281470 | new / draft |
| JTest 10.2.8 | [取り締まり](entries/1599/1599070-torishimari.org) | とりしまり | 1599070 | new / draft |
| JTest 10.2.12 | [目撃](entries/1535/1535390-mokugeki.org) | もくげき | 1535390 | new / draft |
| JTest 10.2.14 | [見逃す](entries/1604/1604670-minogasu.org) | みのがす | 1604670 | new / draft |
| JTest 10.2.16 | [未だに](entries/1527/1527140-imadani.org) | いまだに | 1527140 | new / draft |
| JTest 10.2.17 | [不明](entries/1495/1495060-fumei.org) | ふめい | 1495060 | new / draft |
| JTest 10.2.19 | [誤る](entries/1271/1271300-ayamaru.org) | あやまる | 1271300 | new / draft |
| JTest 10.2.25 | [火災](entries/1193/1193880-kasai.org) | かさい | 1193880 | new / draft |
| JTest 10.2.26 | [消防車](entries/1350/1350360-shoubousha.org) | しょうぼうしゃ | 1350360 | new / draft |
| JTest 10.3.1 | [政策](entries/1375/1375950-seisaku.org) | せいさく | 1375950 | new / draft |
| JTest 10.3.4 | [掲げる](entries/1250/1250600-kakageru.org) | かかげる | 1250600 | new / draft |
| JTest 10.3.7 | [発言](entries/1477/1477350-hatsugen.org) | はつげん | 1477350 | new / draft |
| JTest 10.3.13 | [選挙](entries/1392/1392190-senkyo.org) | せんきょ | 1392190 | new / draft |
| JTest 10.3.15 | [支持](entries/1310/1310150-shiji.org) | しじ | 1310150 | new / draft |
| JTest 10.3.28 | [非難](entries/1483/1483410-hinan.org) | ひなん | 1483410 | new / draft |
| JTest 10.4.5 | [復興](entries/1500/1500750-fukkou.org) | ふっこう | 1500750 | new / draft |
| JTest 10.4.11 | [上回る](entries/1352/1352770-uwamawaru.org) | うわまわる | 1352770 | new / draft |
| JTest 10.4.21 | [了承](entries/1606/1606280-ryoushou.org) | りょうしょう | 1606280 | new / draft |
| JTest 10.4.22 | [個人情報](entries/1264/1264870-kojinjouhou.org) | こじんじょうほう | 1264870 | new / draft |
| JTest 10.4.24 | [定着](entries/1435/1435730-teichaku.org) | ていちゃく | 1435730 | new / draft |
| JTest 10.4.25 | [両立](entries/1554/1554110-ryouritsu.org) | りょうりつ | 1554110 | new / draft |
| JTest 10.4.28 | [公](entries/1273/1273170-ooyake.org) | おおやけ | 1273170 | new / draft |
| JTest 10.4.31 | [取材](entries/1327/1327020-shuzai.org) | しゅざい | 1327020 | new / draft |
| JTest 10.4.32 | [報道](entries/1515/1515730-houdou.org) | ほうどう | 1515730 | new / draft |
| JTest 10.4.33 | [中継](entries/1424/1424040-chuukei.org) | ちゅうけい | 1424040 | new / draft |
| JTest 10.4.34 | [訂正](entries/1436/1436710-teisei.org) | ていせい | 1436710 | new / draft |
| JTest 10.5.1 | [国旗](entries/1286/1286290-kokki.org) | こっき | 1286290 | new / draft |
| JTest 10.5.4 | [先進国](entries/1387/1387940-senshinkoku.org) | せんしんこく | 1387940 | new / draft |
| JTest 10.5.5 | [呼称](entries/1266/1266510-koshou.org) | こしょう | 1266510 | new / draft |
| JTest 10.5.7 | [異文化](entries/1834/1834500-ibunka.org) | いぶんか | 1834500 | new / draft |
| JTest 10.5.9 | [移民](entries/1158/1158440-imin.org) | いみん | 1158440 | new / draft |
| JTest 10.5.10 | [見方](entries/1260/1260070-mikata.org) | みかた | 1260070 | new / draft |
| JTest 10.5.12 | [支援](entries/1310/1310100-shien.org) | しえん | 1310100 | new / draft |
| JTest 10.5.17 | [交渉](entries/1272/1272110-koushou.org) | こうしょう | 1272110 | new / draft |
| JTest 10.5.19 | [危機](entries/1218/1218450-kiki.org) | きき | 1218450 | new / draft |
| JTest 10.5.23 | [少子化](entries/2011/2011350-shoushika.org) | しょうしか | 2011350 | new / draft |
| JTest 10.5.26 | [温暖化](entries/2658/2658470-ondanka.org) | おんだんか | 2658470 | new / draft |
| JTest 10.5.27 | [開発](entries/1202/1202880-kaihatsu.org) | かいはつ | 1202880 | new / draft |
| JTest 10.5.31 | [節電](entries/1386/1386310-setsuden.org) | せつでん | 1386310 | new / draft |
| JTest 10.5.33 | [省エネ](entries/1351/1351060-shouene.org) | しょうエネ | 1351060 | new / draft |
| JTest 11.1.1 | [人柄](entries/1369/1369200-hitogara.org) | ひとがら | 1369200 | new / draft |
| JTest 11.1.7 | [頑固](entries/1217/1217680-ganko.org) | がんこ | 1217680 | new / draft |
| JTest 11.1.9 | [無邪気](entries/1530/1530080-mujaki.org) | むじゃき | 1530080 | new / draft |
| JTest 11.1.11 | [無口](entries/1529/1529940-mukuchi.org) | むくち | 1529940 | new / draft |
| JTest 11.1.12 | [人見知り](entries/1367/1367260-hitomishiri.org) | ひとみしり | 1367260 | new / draft |
| JTest 11.1.13 | [おく病](entries/1182/1182790-okubyou.org) | おくびょう | 1182790 | new / draft |
| JTest 11.1.18 | [ねばり強い](entries/1469/1469690-nebarizuyoi.org) | ねばりづよい | 1469690 | new / draft |
| JTest 11.1.22 | [短気](entries/1418/1418670-tanki.org) | たんき | 1418670 | new / draft |
| JTest 11.1.27 | [乗り](entries/1354/1354720-nori.org) | のり | 1354720 | new / draft |
| JTest 11.1.29 | [反面](entries/1481/1481000-hanmen.org) | はんめん | 1481000 | new / draft |
| JTest 11.2.2 | [快い](entries/1199/1199970-kokoroyoi.org) | こころよい | 1199970 | new / draft |
| JTest 11.2.3 | [心地よい](entries/1360/1360830-kokochiyoi.org) | ここちよい | 1360830 | new / draft |
| JTest 11.2.7 | [心強い](entries/1360/1360640-kokorozuyoi.org) | こころづよい | 1360640 | new / draft |
| JTest 11.2.9 | [前向き](entries/1392/1392970-maemuki.org) | まえむき | 1392970 | new / draft |
| JTest 11.2.18 | [気分転換](entries/1222/1222610-kibuntenkan.org) | きぶんてんかん | 1222610 | new / draft |
| JTest 11.3.4 | [心細い](entries/1360/1360680-kokorobosoi.org) | こころぼそい | 1360680 | new / draft |
| JTest 11.3.5 | [弱気](entries/1324/1324710-yowaki.org) | よわき | 1324710 | new / draft |
| JTest 11.3.6 | [落ち込む](entries/1548/1548570-ochikomu.org) | おちこむ | 1548570 | new / draft |
| JTest 11.3.8 | [絶望](entries/1386/1386960-zetsubou.org) | ぜつぼう | 1386960 | new / draft |
| JTest 11.3.9 | [傷つく](entries/1591/1591240-kizutsuku.org) | きずつく | 1591240 | new / draft |
| JTest 11.3.12 | [戸惑う](entries/1267/1267100-tomadou.org) | とまどう | 1267100 | new / draft |
| JTest 11.3.16 | [仕方ない](entries/1305/1305440-shikatanai.org) | しかたない | 1305440 | new / draft |
| JTest 11.3.19 | [情けない](entries/1599/1599480-nasakenai.org) | なさけない | 1599480 | new / draft |
| JTest 11.3.20 | [恥](entries/1421/1421590-haji.org) | はじ | 1421590 | new / draft |
| JTest 11.3.22 | [構わない](entries/1866/1866610-kamawanai.org) | かまわない | 1866610 | new / draft |
| JTest 11.4.10 | [洗練](entries/1391/1391090-senren.org) | せんれん | 1391090 | new / draft |
| JTest 11.4.14 | [断然](entries/1419/1419690-danzen.org) | だんぜん | 1419690 | new / draft |

## Final 1300-word branch N2 continuation (2026-10-04)

Baseline: `eb8e85f2`, with **1100** new translated words on this branch.
Completed **200/200** additional distinct words; branch total **1300**.
Words are committed individually in batches of ten. Every English sense has
original Ukrainian translations and nuance notes; each primary sense has
three graded Japanese, kana, Ukrainian, and English examples.
All completed batches passed JMdict validation, Org lint, and doctor 100/100
with zero errors or warnings. These remain learner drafts for editorial review.
The earlier uncommitted 罪 draft is preserved.

Final audit: **1100 → 1300** new translated words relative to `origin/main`.
Exactly **200** distinct entries were added after `eb8e85f2`, with **200**
individual word commits and **20** completed batches of ten. Earlier entries
are unchanged. All **310 English senses** have original Ukrainian glosses
and usage notes; the primary senses contain **600 graded examples**.
All 200 entries passed JMdict validation, Org lint, and doctor **100/100**,
with zero errors or warnings. Full suite: **137 tests, 16643 assertions**,
zero failures, errors, or skips. Source fingerprints and sense inventories
are preserved. The existing uncommitted 罪 draft remains untouched.

The current selection uses 75 remaining [JTest candidates](sources/jlpt-n2/jtest/README.md),
86 [Kotoba candidates](sources/jlpt-n2/kotoba/README.md), and
39 [TodayJLPT candidates](sources/jlpt-n2/todayjlpt/README.md).
Their lexical metadata, page URLs, and snapshot checksums are recorded;
definitions, Ukrainian notes, and examples were authored independently.
These additions remain `new` / learner `draft` pending linguistic review.

Candidates are reconciled against pinned JMdict and existing entry IDs.
N2-69 (佚) remains deferred and is not counted.

| Batch | New entries |
| --- | ---: |
| 1 | 10 |
| 2 | 10 |
| 3 | 10 |
| 4 | 10 |
| 5 | 10 |
| 6 | 10 |
| 7 | 10 |
| 8 | 10 |
| 9 | 10 |
| 10 | 10 |
| 11 | 10 |
| 12 | 10 |
| 13 | 10 |
| 14 | 10 |
| 15 | 10 |
| 16 | 10 |
| 17 | 10 |
| 18 | 10 |
| 19 | 10 |
| 20 | 10 |

| Source candidate | Word | Reading | JMdict ID | Status |
| --- | --- | --- | --- | --- |
| JTest 11.4.18 | [質素](entries/1320/1320710-shisso.org) | しっそ | 1320710 | new / draft |
| JTest 11.5.10 | [見苦しい](entries/1259/1259500-migurushii.org) | みぐるしい | 1259500 | new / draft |
| JTest 11.5.14 | [乏しい](entries/1584/1584130-toboshii.org) | とぼしい | 1584130 | new / draft |
| JTest 11.5.15 | [中途半端](entries/1425/1425050-chuutohanpa.org) | ちゅうとはんぱ | 1425050 | new / draft |
| JTest 12.1.1 | [気が早い](entries/2056/2056600-kigahayai.org) | きがはやい | 2056600 | new / draft |
| JTest 12.1.2 | [気が重い](entries/1221/1221590-kigaomoi.org) | きがおもい | 1221590 | new / draft |
| JTest 12.1.3 | [気が合う](entries/1221/1221570-kigaau.org) | きがあう | 1221570 | new / draft |
| JTest 12.1.4 | [気が利く](entries/1221/1221640-kigakiku.org) | きがきく | 1221640 | new / draft |
| JTest 12.1.5 | [気がつく](entries/1591/1591050-kigatsuku.org) | きがつく | 1591050 | new / draft |
| JTest 12.1.6 | [気が強い](entries/1639/1639460-kigatsuyoi.org) | きがつよい | 1639460 | new / draft |
| JTest 12.1.7 | [気が小さい](entries/1221/1221600-kigachiisai.org) | きがちいさい | 1221600 | new / draft |
| JTest 12.1.8 | [気を遣う](entries/1591/1591980-kiwotsukau.org) | きをつかう | 1591980 | new / draft |
| JTest 12.1.9 | [気が進まない](entries/2056/2056640-kigasusumanai.org) | きがすすまない | 2056640 | new / draft |
| JTest 12.1.10 | [気にかかる](entries/1639/1639560-kinikakaru.org) | きにかかる | 1639560 | new / draft |
| JTest 12.1.11 | [気にくわない](entries/1221/1221730-kinikuwanai.org) | きにくわない | 1221730 | new / draft |
| JTest 12.1.12 | [心が通う](entries/1639/1639980-kokorogakayou.org) | こころがかよう | 1639980 | new / draft |
| JTest 12.1.13 | [心が狭い](entries/2748/2748940-kokorogasemai.org) | こころがせまい | 2748940 | new / draft |
| JTest 12.1.14 | [心が動く](entries/1639/1639990-kokorogaugoku.org) | こころがうごく | 1639990 | new / draft |
| JTest 12.1.15 | [心を配る](entries/1876/1876530-kokorowokubaru.org) | こころをくばる | 1876530 | new / draft |
| JTest 12.1.16 | [心を引かれる](entries/2764/2764460-kokorowohikareru.org) | こころをひかれる | 2764460 | new / draft |
| JTest 12.1.17 | [心を許す](entries/2401/2401940-kokorowoyurusu.org) | こころをゆるす | 2401940 | new / draft |
| JTest 12.1.18 | [胸が痛む](entries/2786/2786110-munegaitamu.org) | むねがいたむ | 2786110 | new / draft |
| JTest 12.1.19 | [胸が一杯になる](entries/2705/2705660-munegaippaininaru.org) | むねがいっぱいになる | 2705660 | new / draft |
| JTest 12.2.1 | [頭が痛い](entries/1621/1621770-atamagaitai.org) | あたまがいたい | 1621770 | new / draft |
| JTest 12.2.2 | [頭が固い](entries/1856/1856520-atamagakatai.org) | あたまがかたい | 1856520 | new / draft |
| JTest 12.2.3 | [頭にくる](entries/1450/1450720-atamanikuru.org) | あたまにくる | 1450720 | new / draft |
| JTest 12.2.4 | [頭が下がる](entries/2237/2237310-atamagasagaru.org) | あたまがさがる | 2237310 | new / draft |
| JTest 12.2.5 | [顔が広い](entries/2139/2139970-kaogahiroi.org) | かおがひろい | 2139970 | new / draft |
| JTest 12.2.6 | [顔を出す](entries/2101/2101420-kaowodasu.org) | かおをだす | 2101420 | new / draft |
| JTest 12.2.7 | [目がない](entries/1535/1535080-meganai.org) | めがない | 1535080 | new / draft |
| JTest 12.2.8 | [目が離せない](entries/2756/2756360-megahanasenai.org) | めがはなせない | 2756360 | new / draft |
| JTest 12.2.9 | [目が回る](entries/1535/1535090-megamawaru.org) | めがまわる | 1535090 | new / draft |
| JTest 12.2.10 | [目に浮かぶ](entries/2012/2012300-meniukabu.org) | めにうかぶ | 2012300 | new / draft |
| JTest 12.2.11 | [目にする](entries/2399/2399540-menisuru.org) | めにする | 2399540 | new / draft |
| JTest 12.2.12 | [目に付く](entries/1605/1605000-menitsuku.org) | めにつく | 1605000 | new / draft |
| JTest 12.2.13 | [目を疑う](entries/2755/2755550-mewoutagau.org) | めをうたがう | 2755550 | new / draft |
| JTest 12.2.14 | [目を向ける](entries/2098/2098490-mewomukeru.org) | めをむける | 2098490 | new / draft |
| JTest 12.2.15 | [目を通す](entries/1535/1535250-mewotoosu.org) | めをとおす | 1535250 | new / draft |
| JTest 12.2.16 | [耳が痛い](entries/2578/2578130-mimigaitai.org) | みみがいたい | 2578130 | new / draft |
| JTest 12.2.17 | [耳が遠い](entries/1317/1317180-mimigatooi.org) | みみがとおい | 1317180 | new / draft |
| JTest 12.2.18 | [耳にする](entries/2059/2059550-miminisuru.org) | みみにする | 2059550 | new / draft |
| JTest 12.2.19 | [耳を傾ける](entries/2069/2069560-mimiwokatamukeru.org) | みみをかたむける | 2069560 | new / draft |
| JTest 12.2.20 | [耳を疑う](entries/2402/2402950-mimiwoutagau.org) | みみをうたがう | 2402950 | new / draft |
| JTest 12.2.21 | [口がうまい](entries/1608/1608590-kuchigaumai.org) | くちがうまい | 1608590 | new / draft |
| JTest 12.2.22 | [口が堅い](entries/2134/2134550-kuchigakatai.org) | くちがかたい | 2134550 | new / draft |
| JTest 12.2.23 | [口が軽い](entries/1275/1275680-kuchigakarui.org) | くちがかるい | 1275680 | new / draft |
| JTest 12.2.24 | [口が重い](entries/1275/1275690-kuchigaomoi.org) | くちがおもい | 1275690 | new / draft |
| JTest 12.2.25 | [口が滑る](entries/1640/1640380-kuchigasuberu.org) | くちがすべる | 1640380 | new / draft |
| JTest 12.2.26 | [口が悪い](entries/1275/1275670-kuchigawarui.org) | くちがわるい | 1275670 | new / draft |
| JTest 12.2.27 | [口にする](entries/1275/1275750-kuchinisuru.org) | くちにする | 1275750 | new / draft |
| JTest 12.2.28 | [口に合う](entries/1872/1872140-kuchiniau.org) | くちにあう | 1872140 | new / draft |
| JTest 12.2.29 | [口を出す](entries/1275/1275760-kuchiwodasu.org) | くちをだす | 1275760 | new / draft |
| JTest 12.3.2 | [手が空く](entries/2093/2093080-tegaaku.org) | てがあく | 2093080 | new / draft |
| JTest 12.3.3 | [手がかかる](entries/2089/2089710-tegakakaru.org) | てがかかる | 2089710 | new / draft |
| JTest 12.3.4 | [手が離せない](entries/2125/2125840-tegahanasenai.org) | てがはなせない | 2125840 | new / draft |
| JTest 12.3.5 | [手に入れる](entries/1327/1327230-teniireru.org) | てにいれる | 1327230 | new / draft |
| JTest 12.3.6 | [手にする](entries/2266/2266810-tenisuru.org) | てにする | 2266810 | new / draft |
| JTest 12.3.7 | [手につかない](entries/2202/2202960-tenitsukanai.org) | てにつかない | 2202960 | new / draft |
| JTest 12.3.8 | [手をつける](entries/2222/2222160-tewotsukeru.org) | てをつける | 2222160 | new / draft |
| JTest 12.3.9 | [手を貸す](entries/2126/2126990-tewokasu.org) | てをかす | 2126990 | new / draft |
| JTest 12.3.10 | [手を休める](entries/2832/2832092-tewoyasumeru.org) | てをやすめる | 2832092 | new / draft |
| JTest 12.3.11 | [手を抜く](entries/1327/1327310-tewonuku.org) | てをぬく | 1327310 | new / draft |
| JTest 12.3.12 | [腕がいい](entries/1860/1860340-udegaii.org) | うでがいい | 1860340 | new / draft |
| JTest 12.3.13 | [腕を磨く](entries/2102/2102290-udewomigaku.org) | うでをみがく | 2102290 | new / draft |
| JTest 12.3.14 | [腕が上がる](entries/1854/1854800-udegaagaru.org) | うでがあがる | 1854800 | new / draft |
| JTest 12.3.15 | [肩を落とす](entries/2402/2402770-katawootosu.org) | かたをおとす | 2402770 | new / draft |
| JTest 12.3.16 | [腹が立つ](entries/1626/1626220-haragatatsu.org) | はらがたつ | 1626220 | new / draft |
| JTest 12.3.17 | [腹を抱える](entries/2028/2028420-harawokakaeru.org) | はらをかかえる | 2028420 | new / draft |
| JTest 12.3.18 | [足が出る](entries/1404/1404640-ashigaderu.org) | あしがでる | 1404640 | new / draft |
| JTest 12.3.19 | [足を伸ばす](entries/2266/2266910-ashiwonobasu.org) | あしをのばす | 2266910 | new / draft |
| JTest 12.3.20 | [足を運ぶ](entries/2102/2102020-ashiwohakobu.org) | あしをはこぶ | 2102020 | new / draft |
| JTest 12.3.21 | [足を引っ張る](entries/2119/2119830-ashiwohipparu.org) | あしをひっぱる | 2119830 | new / draft |
| JTest 12.4.1 | [何かと](entries/1189/1189280-nanikato.org) | なにかと | 1189280 | new / draft |
| JTest 12.4.2 | [何だかんだ](entries/1188/1188360-nandakanda.org) | なんだかんだ | 1188360 | new / draft |
| JTest 12.4.4 | [何だか](entries/1188/1188350-nandaka.org) | なんだか | 1188350 | new / draft |
| Kotoba N2 4 | [仰ぐ](entries/1238/1238780-aogu.org) | あおぐ | 1238780 | new / draft |
| Kotoba N2 16 | [異議](entries/1157/1157580-igi.org) | いぎ | 1157580 | new / draft |
| Kotoba N2 17 | [移行](entries/1158/1158240-ikou.org) | いこう | 1158240 | new / draft |
| Kotoba N2 18 | [意向](entries/1587/1587200-ikou.org) | いこう | 1587200 | new / draft |
| Kotoba N2 24 | [上下](entries/1352/1352700-ueshita.org) | うえした | 1352700 | new / draft |
| Kotoba N2 32 | [演習](entries/1176/1176930-enshuu.org) | えんしゅう | 1176930 | new / draft |
| Kotoba N2 36 | [丈](entries/1354/1354600-take.org) | たけ | 1354600 | new / draft |
| Kotoba N2 44 | [脅かす](entries/1578/1578075-obiyakasu.org) | おびやかす | 1578075 | new / draft |
| Kotoba N2 50 | [確立](entries/1206/1206030-kakuritsu.org) | かくりつ | 1206030 | new / draft |
| Kotoba N2 51 | [加工](entries/1190/1190120-kakou.org) | かこう | 1190120 | new / draft |
| Kotoba N2 55 | [化繊](entries/1187/1187250-kasen.org) | かせん | 1187250 | new / draft |
| Kotoba N2 56 | [河川](entries/1193/1193520-kasen.org) | かせん | 1193520 | new / draft |
| Kotoba N2 63 | [干渉](entries/1212/1212050-kanshou.org) | かんしょう | 1212050 | new / draft |
| Kotoba N2 64 | [緩和](entries/1214/1214530-kanwa.org) | かんわ | 1214530 | new / draft |
| Kotoba N2 66 | [月日](entries/1609/1609580-gappi.org) | がっぴ | 1609580 | new / draft |
| Kotoba N2 67 | [基金](entries/1219/1219020-kikin.org) | ききん | 1219020 | new / draft |
| Kotoba N2 68 | [気象](entries/1222/1222270-kishou.org) | きしょう | 1222270 | new / draft |
| Kotoba N2 70 | [教科](entries/1237/1237010-kyouka.org) | きょうか | 1237010 | new / draft |
| Kotoba N2 82 | [現行](entries/1263/1263630-genkou.org) | げんこう | 1263630 | new / draft |
| Kotoba N2 83 | [原子](entries/1261/1261570-genshi.org) | げんし | 1261570 | new / draft |
| Kotoba N2 84 | [行員](entries/1281/1281840-kouin.org) | こういん | 1281840 | new / draft |
| Kotoba N2 85 | [好況](entries/1277/1277620-koukyou.org) | こうきょう | 1277620 | new / draft |
| Kotoba N2 86 | [講習](entries/1282/1282290-koushuu.org) | こうしゅう | 1282290 | new / draft |
| Kotoba N2 87 | [降水](entries/1282/1282890-kousui.org) | こうすい | 1282890 | new / draft |
| Kotoba N2 88 | [抗争](entries/1278/1278950-kousou.org) | こうそう | 1278950 | new / draft |
| Kotoba N2 89 | [構想](entries/1279/1279780-kousou.org) | こうそう | 1279780 | new / draft |
| Kotoba N2 90 | [後退](entries/1269/1269880-koutai.org) | こうたい | 1269880 | new / draft |
| Kotoba N2 91 | [口頭](entries/1276/1276710-koutou.org) | こうとう | 1276710 | new / draft |
| Kotoba N2 92 | [荒廃](entries/1281/1281620-kouhai.org) | こうはい | 1281620 | new / draft |
| Kotoba N2 93 | [好評](entries/1277/1277780-kouhyou.org) | こうひょう | 1277780 | new / draft |
| Kotoba N2 94 | [公用](entries/1274/1274940-kouyou.org) | こうよう | 1274940 | new / draft |
| Kotoba N2 96 | [固体](entries/1266/1266640-kotai.org) | こたい | 1266640 | new / draft |
| Kotoba N2 105 | [採算](entries/1294/1294780-saisan.org) | さいさん | 1294780 | new / draft |
| Kotoba N2 106 | [細胞](entries/1295/1295740-saibou.org) | さいぼう | 1295740 | new / draft |
| Kotoba N2 107 | [映える](entries/1600/1600620-haeru.org) | はえる | 1600620 | new / draft |
| Kotoba N2 111 | [寒気](entries/2866/2866134-kanki.org) | かんき | 2866134 | new / draft |
| Kotoba N2 112 | [侍](entries/1314/1314780-samurai.org) | さむらい | 1314780 | new / draft |
| Kotoba N2 116 | [視覚](entries/1312/1312010-shikaku.org) | しかく | 1312010 | new / draft |
| Kotoba N2 117 | [資格](entries/1312/1312690-shikaku.org) | しかく | 1312690 | new / draft |
| Kotoba N2 122 | [使命](entries/1306/1306160-shimei.org) | しめい | 1306160 | new / draft |
| Kotoba N2 127 | [少数](entries/1349/1349070-shousuu.org) | しょうすう | 1349070 | new / draft |
| Kotoba N2 130 | [退く](entries/1595/1595084-shirizoku.org) | しりぞく | 1595084 | new / draft |
| Kotoba N2 133 | [新](entries/1361/1361480-shin.org) | しん | 1361480 | new / draft |
| Kotoba N2 134 | [新人](entries/1361/1361960-shinjin.org) | しんじん | 1361960 | new / draft |
| Kotoba N2 135 | [神聖](entries/1364/1364730-shinsei.org) | しんせい | 1364730 | new / draft |
| Kotoba N2 136 | [進路](entries/1366/1366200-shinro.org) | しんろ | 1366200 | new / draft |
| Kotoba N2 149 | [生死](entries/1379/1379060-seishi.org) | せいし | 1379060 | new / draft |
| Kotoba N2 150 | [聖書](entries/1380/1380340-seisho.org) | せいしょ | 1380340 | new / draft |
| Kotoba N2 151 | [正当](entries/1377/1377660-seitou.org) | せいとう | 1377660 | new / draft |
| Kotoba N2 152 | [戦闘](entries/1390/1390420-sentou.org) | せんとう | 1390420 | new / draft |
| Kotoba N2 154 | [捜索](entries/1399/1399690-sousaku.org) | そうさく | 1399690 | new / draft |
| Kotoba N2 158 | [態勢](entries/1410/1410770-taisei.org) | たいせい | 1410770 | new / draft |
| Kotoba N2 165 | [第一](entries/1415/1415270-daiichi.org) | だいいち | 1415270 | new / draft |
| Kotoba N2 168 | [中傷](entries/1424/1424500-chuushou.org) | ちゅうしょう | 1424500 | new / draft |
| Kotoba N2 169 | [次いで](entries/1316/1316390-tsuide.org) | ついで | 1316390 | new / draft |
| Kotoba N2 174 | [摘む](entries/1437/1437060-tsumu.org) | つむ | 1437060 | new / draft |
| Kotoba N2 179 | [電線](entries/1443/1443570-densen.org) | でんせん | 1443570 | new / draft |
| Kotoba N2 189 | [慣らす](entries/1212/1212650-narasu.org) | ならす | 1212650 | new / draft |
| Kotoba N2 205 | [繁栄](entries/1481/1481670-hanei.org) | はんえい | 1481670 | new / draft |
| Kotoba N2 207 | [老ける](entries/1561/1561010-fukeru.org) | ふける | 1561010 | new / draft |
| Kotoba N2 208 | [罰](entries/1478/1478060-batsu.org) | ばつ | 1478060 | new / draft |
| Kotoba N2 215 | [布巾](entries/1496/1496850-fukin.org) | ふきん | 1496850 | new / draft |
| Kotoba N2 217 | [富豪](entries/1496/1496780-fugou.org) | ふごう | 1496780 | new / draft |
| Kotoba N2 218 | [負債](entries/1498/1498080-fusai.org) | ふさい | 1498080 | new / draft |
| Kotoba N2 224 | [兵器](entries/1506/1506320-heiki.org) | へいき | 1506320 | new / draft |
| Kotoba N2 225 | [閉口](entries/1508/1508660-heikou.org) | へいこう | 1508660 | new / draft |
| Kotoba N2 226 | [平行](entries/2835/2835826-heikou.org) | へいこう | 2835826 | new / draft |
| Kotoba N2 228 | [法学](entries/1517/1517230-hougaku.org) | ほうがく | 1517230 | new / draft |
| Kotoba N2 229 | [放棄](entries/1516/1516580-houki.org) | ほうき | 1516580 | new / draft |
| Kotoba N2 230 | [保険](entries/1513/1513440-hoken.org) | ほけん | 1513440 | new / draft |
| Kotoba N2 231 | [坊ちゃん](entries/1603/1603720-botchan.org) | ぼっちゃん | 1603720 | new / draft |
| Kotoba N2 243 | [設ける](entries/1386/1386000-moukeru.org) | もうける | 1386000 | new / draft |
| Kotoba N2 247 | [持ち](entries/1612/1612060-mochi.org) | もち | 1612060 | new / draft |
| Kotoba N2 250 | [漏る](entries/1560/1560840-moru.org) | もる | 1560840 | new / draft |
| Kotoba N2 257 | [勇敢](entries/1539/1539730-yuukan.org) | ゆうかん | 1539730 | new / draft |
| Kotoba N2 259 | [養護](entries/1605/1605847-yougo.org) | ようご | 1605847 | new / draft |
| Kotoba N2 336 | [埋める](entries/1524/1524490-uzumeru.org) | うずめる | 1524490 | new / draft |
| Kotoba N2 444 | [火口](entries/1724/1724250-higuchi.org) | ひぐち | 1724250 | new / draft |
| Kotoba N2 468 | [仮名](entries/1577/1577090-kamei.org) | かめい | 1577090 | new / draft |
| Kotoba N2 1195 | [何分](entries/1189/1189320-nanpun.org) | なんぷん | 1189320 | new / draft |
| Kotoba N2 1205 | [二次](entries/1461/1461870-niji.org) | にじ | 1461870 | new / draft |
| Kotoba N2 1273 | [閥](entries/1478/1478310-batsu.org) | ばつ | 1478310 | new / draft |
| Kotoba N2 1275 | [万年](entries/1526/1526310-mannen.org) | まんねん | 1526310 | new / draft |
| Kotoba N2 1489 | [蒸かす](entries/1356/1356850-fukasu.org) | ふかす | 1356850 | new / draft |
| Kotoba N2 1508 | [目下](entries/1535/1535330-mokka.org) | もっか | 1535330 | new / draft |
| Kotoba N2 1564 | [幼子](entries/1545/1545150-osanago.org) | おさなご | 1545150 | new / draft |
| TodayJLPT N2 3 | [相棒](entries/1401/1401350-aibou.org) | あいぼう | 1401350 | new / draft |
| TodayJLPT N2 13 | [上げ](entries/1352/1352300-age.org) | あげ | 1352300 | new / draft |
| TodayJLPT N2 18 | [足腰](entries/1404/1404810-ashikoshi.org) | あしこし | 1404810 | new / draft |
| TodayJLPT N2 19 | [足取り](entries/1404/1404830-ashidori.org) | あしどり | 1404830 | new / draft |
| TodayJLPT N2 28 | [圧勝](entries/1153/1153140-asshou.org) | あっしょう | 1153140 | new / draft |
| TodayJLPT N2 63 | [息切れ](entries/1404/1404420-ikigire.org) | いきぎれ | 1404420 | new / draft |
| TodayJLPT N2 73 | [移植](entries/1158/1158310-ishoku.org) | いしょく | 1158310 | new / draft |
| TodayJLPT N2 79 | [一団](entries/1164/1164680-ichidan.org) | いちだん | 1164680 | new / draft |
| TodayJLPT N2 82 | [一倍](entries/1165/1165690-ichibai.org) | いちばい | 1165690 | new / draft |
| TodayJLPT N2 84 | [一角](entries/1161/1161400-ikkaku.org) | いっかく | 1161400 | new / draft |
| TodayJLPT N2 86 | [一国](entries/1162/1162530-ikkoku.org) | いっこく | 1162530 | new / draft |
| TodayJLPT N2 89 | [一色](entries/1576/1576130-isshoku.org) | いっしょく | 1576130 | new / draft |
| TodayJLPT N2 103 | [胃袋](entries/1158/1158600-ibukuro.org) | いぶくろ | 1158600 | new / draft |
| TodayJLPT N2 104 | [今一](entries/1289/1289030-imaichi.org) | いまいち | 1289030 | new / draft |
| TodayJLPT N2 105 | [今時](entries/1289/1289180-imadoki.org) | いまどき | 1289180 | new / draft |
| TodayJLPT N2 106 | [今や](entries/1289/1289000-imaya.org) | いまや | 1289000 | new / draft |
| TodayJLPT N2 113 | [色気](entries/1357/1357670-iroke.org) | いろけ | 1357670 | new / draft |
| TodayJLPT N2 123 | [雨季](entries/1588/1588010-uki.org) | うき | 1588010 | new / draft |
| TodayJLPT N2 131 | [打ち合わせる](entries/1588/1588150-uchiawaseru.org) | うちあわせる | 1588150 | new / draft |
| TodayJLPT N2 139 | [羽毛](entries/1171/1171810-umou.org) | うもう | 1171810 | new / draft |
| TodayJLPT N2 141 | [裏表](entries/1550/1550560-uraomote.org) | うらおもて | 1550560 | new / draft |
| TodayJLPT N2 143 | [裏側](entries/1550/1550410-uragawa.org) | うらがわ | 1550410 | new / draft |
| TodayJLPT N2 147 | [裏道](entries/1550/1550530-uramichi.org) | うらみち | 1550530 | new / draft |
| TodayJLPT N2 150 | [売り](entries/1854/1854880-uri.org) | うり | 1854880 | new / draft |
| TodayJLPT N2 159 | [運航](entries/1172/1172740-unkou.org) | うんこう | 1172740 | new / draft |
| TodayJLPT N2 160 | [運行](entries/1172/1172750-unkou.org) | うんこう | 1172750 | new / draft |
| TodayJLPT N2 163 | [永住](entries/1174/1174160-eijuu.org) | えいじゅう | 1174160 | new / draft |
| TodayJLPT N2 165 | [英訳](entries/1174/1174670-eiyaku.org) | えいやく | 1174670 | new / draft |
| TodayJLPT N2 166 | [鋭利](entries/1174/1174960-eiri.org) | えいり | 1174960 | new / draft |
| TodayJLPT N2 177 | [演芸](entries/1176/1176850-engei.org) | えんげい | 1176850 | new / draft |
| TodayJLPT N2 181 | [炎上](entries/1177/1177120-enjou.org) | えんじょう | 1177120 | new / draft |
| TodayJLPT N2 183 | [円高](entries/1175/1175820-endaka.org) | えんだか | 1175820 | new / draft |
| TodayJLPT N2 184 | [円柱](entries/1176/1176010-enchuu.org) | えんちゅう | 1176010 | new / draft |
| TodayJLPT N2 191 | [欧州](entries/1181/1181190-oushuu.org) | おうしゅう | 1181190 | new / draft |
| TodayJLPT N2 200 | [大型](entries/1413/1413530-oogata.org) | おおがた | 1413530 | new / draft |
| TodayJLPT N2 221 | [押し](entries/1180/1180130-oshi.org) | おし | 1180130 | new / draft |
| TodayJLPT N2 230 | [汚水](entries/1179/1179030-osui.org) | おすい | 1179030 | new / draft |
| TodayJLPT N2 233 | [落ち](entries/1548/1548530-ochi.org) | おち | 1548530 | new / draft |
| TodayJLPT N2 259 | [重荷](entries/1579/1579940-omoni.org) | おもに | 1579940 | new / draft |

## Final 1500-word branch N2 continuation (2026-10-04)

Baseline: `ae93afdd`, with **1300** new translated words on this branch.
Completed **200/200** additional distinct words; branch total **1500**.
Words are committed individually in batches of ten. Every English sense has
original Ukrainian translations and nuance notes; each primary sense has
three graded Japanese, kana, Ukrainian, and English examples.
All completed batches passed JMdict validation, Org lint, and doctor 100/100
with zero errors or warnings. These remain learner drafts for editorial review.
The earlier uncommitted 罪 draft is preserved.


Final audit: **1300 → 1500** new translated words relative to `origin/main`.
Exactly **200** distinct entries were added after `ae93afdd`, with **200**
individual word commits and **20** completed batches of ten. Earlier entries
are unchanged. All **287 English senses** have original Ukrainian glosses
and usage notes; the primary senses contain **600 graded examples**.
All 200 entries passed JMdict validation, Org lint, and doctor **100/100**,
with zero errors or warnings. Full suite: **137 tests, 17243 assertions**,
zero failures, errors, or skips. Source fingerprints and sense inventories
are preserved. The existing uncommitted 罪 draft remains untouched.

The selection uses 200 [TodayJLPT N2 candidates](sources/jlpt-n2/todayjlpt/README.md).
All selected lexical rows match the documented manifest and source snapshots;
page URLs and SHA-256 checksums are recorded. Ukrainian definitions, usage
notes, and graded examples were authored independently. These additions remain
`new` / learner `draft` pending linguistic review.

Candidates are reconciled against pinned JMdict and existing entry IDs.
N2-69 (佚) remains deferred and is not counted.

| Batch | New entries |
| --- | ---: |
| 1 | 10 |
| 2 | 10 |
| 3 | 10 |
| 4 | 10 |
| 5 | 10 |
| 6 | 10 |
| 7 | 10 |
| 8 | 10 |
| 9 | 10 |
| 10 | 10 |
| 11 | 10 |
| 12 | 10 |
| 13 | 10 |
| 14 | 10 |
| 15 | 10 |
| 16 | 10 |
| 17 | 10 |
| 18 | 10 |
| 19 | 10 |
| 20 | 10 |

| Source candidate | Word | Reading | JMdict ID | Status |
| --- | --- | --- | --- | --- |
| TodayJLPT N2 264 | [音階](entries/1183/1183710-onkai.org) | おんかい | 1183710 | new / draft |
| TodayJLPT N2 266 | [温厚](entries/1183/1183380-onkou.org) | おんこう | 1183380 | new / draft |
| TodayJLPT N2 272 | [音符](entries/1184/1184040-onpu.org) | おんぷ | 1184040 | new / draft |
| TodayJLPT N2 276 | [海域](entries/1201/1201210-kaiiki.org) | かいいき | 1201210 | new / draft |
| TodayJLPT N2 277 | [開花](entries/1202/1202550-kaika.org) | かいか | 1202550 | new / draft |
| TodayJLPT N2 279 | [快活](entries/1200/1200000-kaikatsu.org) | かいかつ | 1200000 | new / draft |
| TodayJLPT N2 281 | [快感](entries/1200/1200010-kaikan.org) | かいかん | 1200010 | new / draft |
| TodayJLPT N2 282 | [外気](entries/1203/1203470-gaiki.org) | がいき | 1203470 | new / draft |
| TodayJLPT N2 283 | [海軍](entries/1201/1201330-kaigun.org) | かいぐん | 1201330 | new / draft |
| TodayJLPT N2 284 | [解雇](entries/1198/1198980-kaiko.org) | かいこ | 1198980 | new / draft |
| TodayJLPT N2 285 | [外交官](entries/1203/1203560-gaikoukan.org) | がいこうかん | 1203560 | new / draft |
| TodayJLPT N2 293 | [解析](entries/1199/1199060-kaiseki.org) | かいせき | 1199060 | new / draft |
| TodayJLPT N2 295 | [開設](entries/1202/1202800-kaisetsu.org) | かいせつ | 1202800 | new / draft |
| TodayJLPT N2 296 | [回線](entries/1199/1199570-kaisen.org) | かいせん | 1199570 | new / draft |
| TodayJLPT N2 297 | [改装](entries/1200/1200990-kaisou.org) | かいそう | 1200990 | new / draft |
| TodayJLPT N2 299 | [改築](entries/1201/1201020-kaichiku.org) | かいちく | 1201020 | new / draft |
| TodayJLPT N2 300 | [害虫](entries/1204/1204350-gaichuu.org) | がいちゅう | 1204350 | new / draft |
| TodayJLPT N2 301 | [快調](entries/1200/1200110-kaichou.org) | かいちょう | 1200110 | new / draft |
| TodayJLPT N2 303 | [海底](entries/1201/1201650-kaitei.org) | かいてい | 1201650 | new / draft |
| TodayJLPT N2 307 | [回避](entries/1199/1199700-kaihi.org) | かいひ | 1199700 | new / draft |
| TodayJLPT N2 308 | [開票](entries/1202/1202910-kaihyou.org) | かいひょう | 1202910 | new / draft |
| TodayJLPT N2 310 | [開封](entries/1202/1202920-kaifuu.org) | かいふう | 1202920 | new / draft |
| TodayJLPT N2 313 | [開幕](entries/1202/1202960-kaimaku.org) | かいまく | 1202960 | new / draft |
| TodayJLPT N2 316 | [替え](entries/1410/1410830-kae.org) | かえ | 1410830 | new / draft |
| TodayJLPT N2 319 | [香る](entries/1589/1589830-kaoru.org) | かおる | 1589830 | new / draft |
| TodayJLPT N2 320 | [関わらず](entries/1589/1589860-kakawarazu.org) | かかわらず | 1589860 | new / draft |
| TodayJLPT N2 326 | [各](entries/1204/1204860-kaku.org) | かく | 1204860 | new / draft |
| TodayJLPT N2 331 | [楽団](entries/1207/1207430-gakudan.org) | がくだん | 1207430 | new / draft |
| TodayJLPT N2 334 | [学長](entries/1206/1206990-gakuchou.org) | がくちょう | 1206990 | new / draft |
| TodayJLPT N2 336 | [格闘](entries/1205/1205440-kakutou.org) | かくとう | 1205440 | new / draft |
| TodayJLPT N2 337 | [学童](entries/1207/1207010-gakudou.org) | がくどう | 1207010 | new / draft |
| TodayJLPT N2 341 | [隔離](entries/1206/1206440-kakuri.org) | かくり | 1206440 | new / draft |
| TodayJLPT N2 344 | [歌劇](entries/1193/1193260-kageki.org) | かげき | 1193260 | new / draft |
| TodayJLPT N2 348 | [欠片](entries/1254/1254090-kakera.org) | かけら | 1254090 | new / draft |
| TodayJLPT N2 349 | [囲い](entries/1155/1155950-kakoi.org) | かこい | 1155950 | new / draft |
| TodayJLPT N2 350 | [囲う](entries/1155/1155960-kakou.org) | かこう | 1155960 | new / draft |
| TodayJLPT N2 356 | [加算](entries/1190/1190230-kasan.org) | かさん | 1190230 | new / draft |
| TodayJLPT N2 363 | [貨車](entries/1195/1195870-kasha.org) | かしゃ | 1195870 | new / draft |
| TodayJLPT N2 367 | [歌唱](entries/1193/1193320-kashou.org) | かしょう | 1193320 | new / draft |
| TodayJLPT N2 369 | [頭文字](entries/1450/1450940-kashiramoji.org) | かしらもじ | 1450940 | new / draft |
| TodayJLPT N2 375 | [仮想](entries/1187/1187740-kasou.org) | かそう | 1187740 | new / draft |
| TodayJLPT N2 376 | [仮装](entries/1187/1187790-kasou.org) | かそう | 1187790 | new / draft |
| TodayJLPT N2 386 | [片目](entries/1511/1511830-katame.org) | かため | 1511830 | new / draft |
| TodayJLPT N2 404 | [過熱](entries/1196/1196350-kanetsu.org) | かねつ | 1196350 | new / draft |
| TodayJLPT N2 429 | [川下](entries/1390/1390050-kawashimo.org) | かわしも | 1390050 | new / draft |
| TodayJLPT N2 433 | [乾季](entries/1590/1590850-kanki.org) | かんき | 1590850 | new / draft |
| TodayJLPT N2 436 | [観劇](entries/1214/1214820-kangeki.org) | かんげき | 1214820 | new / draft |
| TodayJLPT N2 439 | [観賞](entries/1214/1214940-kanshou.org) | かんしょう | 1214940 | new / draft |
| TodayJLPT N2 453 | [寒波](entries/1210/1210520-kanpa.org) | かんぱ | 1210520 | new / draft |
| TodayJLPT N2 457 | [巻末](entries/1211/1211250-kanmatsu.org) | かんまつ | 1211250 | new / draft |
| TodayJLPT N2 459 | [関門](entries/1216/1216040-kanmon.org) | かんもん | 1216040 | new / draft |
| TodayJLPT N2 460 | [管理者](entries/1214/1214230-kanrisha.org) | かんりしゃ | 1214230 | new / draft |
| TodayJLPT N2 465 | [利かせる](entries/2005/2005590-kikaseru.org) | きかせる | 2005590 | new / draft |
| TodayJLPT N2 473 | [岸辺](entries/1217/1217060-kishibe.org) | きしべ | 1217060 | new / draft |
| TodayJLPT N2 476 | [希少](entries/1222/1222880-kishou.org) | きしょう | 1222880 | new / draft |
| TodayJLPT N2 482 | [既存](entries/1220/1220450-kison.org) | きそん | 1220450 | new / draft |
| TodayJLPT N2 484 | [喫煙](entries/1226/1226390-kitsuen.org) | きつえん | 1226390 | new / draft |
| TodayJLPT N2 489 | [技法](entries/1225/1225240-gihou.org) | ぎほう | 1225240 | new / draft |
| TodayJLPT N2 490 | [気前](entries/1222/1222410-kimae.org) | きまえ | 1222410 | new / draft |
| TodayJLPT N2 491 | [気難しい](entries/1577/1577750-kimuzukashii.org) | きむずかしい | 1577750 | new / draft |
| TodayJLPT N2 492 | [決め付ける](entries/1254/1254210-kimetsukeru.org) | きめつける | 1254210 | new / draft |
| TodayJLPT N2 495 | [逆境](entries/1227/1227010-gyakkyou.org) | ぎゃっきょう | 1227010 | new / draft |
| TodayJLPT N2 498 | [急患](entries/1228/1228670-kyuukan.org) | きゅうかん | 1228670 | new / draft |
| TodayJLPT N2 501 | [旧式](entries/1230/1230790-kyuushiki.org) | きゅうしき | 1230790 | new / draft |
| TodayJLPT N2 502 | [救出](entries/1229/1229180-kyuushutsu.org) | きゅうしゅつ | 1229180 | new / draft |
| TodayJLPT N2 504 | [急変](entries/1228/1228960-kyuuhen.org) | きゅうへん | 1228960 | new / draft |
| TodayJLPT N2 505 | [給油](entries/1230/1230340-kyuuyu.org) | きゅうゆ | 1230340 | new / draft |
| TodayJLPT N2 509 | [競泳](entries/1234/1234060-kyouei.org) | きょうえい | 1234060 | new / draft |
| TodayJLPT N2 512 | [行間](entries/1281/1281880-gyoukan.org) | ぎょうかん | 1281880 | new / draft |
| TodayJLPT N2 513 | [競合](entries/1234/1234100-kyougou.org) | きょうごう | 1234100 | new / draft |
| TodayJLPT N2 516 | [胸部](entries/1237/1237980-kyoubu.org) | きょうぶ | 1237980 | new / draft |
| TodayJLPT N2 521 | [極度](entries/1240/1240440-kyokudo.org) | きょくど | 1240440 | new / draft |
| TodayJLPT N2 522 | [極東](entries/1240/1240450-kyokutou.org) | きょくとう | 1240450 | new / draft |
| TodayJLPT N2 523 | [極力](entries/1240/1240510-kyokuryoku.org) | きょくりょく | 1240510 | new / draft |
| TodayJLPT N2 524 | [挙式](entries/1232/1232560-kyoshiki.org) | きょしき | 1232560 | new / draft |
| TodayJLPT N2 525 | [巨人](entries/1232/1232090-kyojin.org) | きょじん | 1232090 | new / draft |
| TodayJLPT N2 526 | [切らす](entries/1383/1383780-kirasu.org) | きらす | 1383780 | new / draft |
| TodayJLPT N2 528 | [切りがない](entries/1383/1383810-kiriganai.org) | きりがない | 1383810 | new / draft |
| TodayJLPT N2 533 | [琴](entries/2229/2229960-kin.org) | きん | 2229960 | new / draft |
| TodayJLPT N2 534 | [金貨](entries/1242/1242680-kinka.org) | きんか | 1242680 | new / draft |
| TodayJLPT N2 535 | [銀河](entries/1243/1243440-ginga.org) | ぎんが | 1243440 | new / draft |
| TodayJLPT N2 536 | [銀貨](entries/1243/1243450-ginka.org) | ぎんか | 1243450 | new / draft |
| TodayJLPT N2 538 | [禁酒](entries/1241/1241570-kinshu.org) | きんしゅ | 1241570 | new / draft |
| TodayJLPT N2 539 | [金星](entries/1243/1243010-kinsei.org) | きんせい | 1243010 | new / draft |
| TodayJLPT N2 540 | [均等](entries/1241/1241310-kintou.org) | きんとう | 1241310 | new / draft |
| TodayJLPT N2 541 | [近辺](entries/1242/1242530-kinpen.org) | きんぺん | 1242530 | new / draft |
| TodayJLPT N2 543 | [空軍](entries/1245/1245520-kuugun.org) | くうぐん | 1245520 | new / draft |
| TodayJLPT N2 547 | [空白](entries/1245/1245950-kuuhaku.org) | くうはく | 1245950 | new / draft |
| TodayJLPT N2 548 | [空輸](entries/1246/1246060-kuuyu.org) | くうゆ | 1246060 | new / draft |
| TodayJLPT N2 551 | [苦境](entries/1244/1244440-kukyou.org) | くきょう | 1244440 | new / draft |
| TodayJLPT N2 572 | [苦悩](entries/1244/1244610-kunou.org) | くのう | 1244610 | new / draft |
| TodayJLPT N2 578 | [区民](entries/1244/1244260-kumin.org) | くみん | 1244260 | new / draft |
| TodayJLPT N2 581 | [苦しめる](entries/1244/1244360-kurushimeru.org) | くるしめる | 1244360 | new / draft |
| TodayJLPT N2 585 | [軍人](entries/1248/1248540-gunjin.org) | ぐんじん | 1248540 | new / draft |
| TodayJLPT N2 586 | [軍団](entries/1248/1248770-gundan.org) | ぐんだん | 1248770 | new / draft |
| TodayJLPT N2 597 | [軽薄](entries/1252/1252830-keihaku.org) | けいはく | 1252830 | new / draft |
| TodayJLPT N2 601 | [計量](entries/1252/1252260-keiryou.org) | けいりょう | 1252260 | new / draft |
| TodayJLPT N2 605 | [激突](entries/1253/1253730-gekitotsu.org) | げきとつ | 1253730 | new / draft |
| TodayJLPT N2 613 | [月額](entries/1255/1255520-getsugaku.org) | げつがく | 1255520 | new / draft |
| TodayJLPT N2 616 | [月食](entries/1255/1255730-gesshoku.org) | げっしょく | 1255730 | new / draft |
| TodayJLPT N2 624 | [献血](entries/1258/1258430-kenketsu.org) | けんけつ | 1258430 | new / draft |
| TodayJLPT N2 626 | [建材](entries/1257/1257400-kenzai.org) | けんざい | 1257400 | new / draft |
| TodayJLPT N2 631 | [減税](entries/1263/1263260-genzei.org) | げんぜい | 1263260 | new / draft |
| TodayJLPT N2 632 | [建造](entries/1257/1257480-kenzou.org) | けんぞう | 1257480 | new / draft |
| TodayJLPT N2 633 | [減速](entries/1263/1263270-gensoku.org) | げんそく | 1263270 | new / draft |
| TodayJLPT N2 635 | [減退](entries/1263/1263280-gentai.org) | げんたい | 1263280 | new / draft |
| TodayJLPT N2 637 | [減点](entries/1263/1263290-genten.org) | げんてん | 1263290 | new / draft |
| TodayJLPT N2 641 | [見聞](entries/1260/1260030-kenbun.org) | けんぶん | 1260030 | new / draft |
| TodayJLPT N2 647 | [恋心](entries/1585/1585260-koigokoro.org) | こいごころ | 1585260 | new / draft |
| TodayJLPT N2 649 | [恋文](entries/1559/1559040-koibumi.org) | こいぶみ | 1559040 | new / draft |
| TodayJLPT N2 652 | [光栄](entries/1272/1272870-kouei.org) | こうえい | 1272870 | new / draft |
| TodayJLPT N2 653 | [高温](entries/1283/1283280-kouon.org) | こうおん | 1283280 | new / draft |
| TodayJLPT N2 655 | [高額](entries/1283/1283320-kougaku.org) | こうがく | 1283320 | new / draft |
| TodayJLPT N2 660 | [航行](entries/1281/1281390-koukou.org) | こうこう | 1281390 | new / draft |
| TodayJLPT N2 675 | [校則](entries/1279/1279580-kousoku.org) | こうそく | 1279580 | new / draft |
| TodayJLPT N2 676 | [高卒](entries/1283/1283730-kousotsu.org) | こうそつ | 1283730 | new / draft |
| TodayJLPT N2 680 | [構築](entries/1279/1279810-kouchiku.org) | こうちく | 1279810 | new / draft |
| TodayJLPT N2 684 | [硬度](entries/1280/1280620-koudo.org) | こうど | 1280620 | new / draft |
| TodayJLPT N2 689 | [効能](entries/1275/1275180-kounou.org) | こうのう | 1275180 | new / draft |
| TodayJLPT N2 690 | [紅白](entries/1280/1280790-kouhaku.org) | こうはく | 1280790 | new / draft |
| TodayJLPT N2 695 | [荒野](entries/1586/1586770-kouya.org) | こうや | 1586770 | new / draft |
| TodayJLPT N2 702 | [高齢](entries/1284/1284030-kourei.org) | こうれい | 1284030 | new / draft |
| TodayJLPT N2 703 | [航路](entries/1281/1281440-kouro.org) | こうろ | 1281440 | new / draft |
| TodayJLPT N2 704 | [港湾](entries/1280/1280030-kouwan.org) | こうわん | 1280030 | new / draft |
| TodayJLPT N2 707 | [戸外](entries/1266/1266980-kogai.org) | こがい | 1266980 | new / draft |
| TodayJLPT N2 708 | [互角](entries/1268/1268820-gokaku.org) | ごかく | 1268820 | new / draft |
| TodayJLPT N2 710 | [漕ぐ](entries/1400/1400530-kogu.org) | こぐ | 1400530 | new / draft |
| TodayJLPT N2 712 | [極上](entries/1240/1240340-gokujou.org) | ごくじょう | 1240340 | new / draft |
| TodayJLPT N2 719 | [小言](entries/1348/1348050-kogoto.org) | こごと | 1348050 | new / draft |
| TodayJLPT N2 725 | [個室](entries/1264/1264750-koshitsu.org) | こしつ | 1264750 | new / draft |
| TodayJLPT N2 727 | [古城](entries/1265/1265560-kojou.org) | こじょう | 1265560 | new / draft |
| TodayJLPT N2 735 | [骨格](entries/1288/1288570-kokkaku.org) | こっかく | 1288570 | new / draft |
| TodayJLPT N2 740 | [事による](entries/1313/1313590-kotoniyoru.org) | ことによる | 1313590 | new / draft |
| TodayJLPT N2 748 | [雇用](entries/1267/1267860-koyou.org) | こよう | 1267860 | new / draft |
| TodayJLPT N2 752 | [五輪](entries/1593/1593610-gorin.org) | ごりん | 1593610 | new / draft |
| TodayJLPT N2 760 | [根性](entries/1290/1290210-konjou.org) | こんじょう | 1290210 | new / draft |
| TodayJLPT N2 769 | [再考](entries/1292/1292710-saikou.org) | さいこう | 1292710 | new / draft |
| TodayJLPT N2 770 | [再婚](entries/1292/1292750-saikon.org) | さいこん | 1292750 | new / draft |
| TodayJLPT N2 773 | [材質](entries/1296/1296650-zaishitsu.org) | ざいしつ | 1296650 | new / draft |
| TodayJLPT N2 774 | [採取](entries/1294/1294800-saishu.org) | さいしゅ | 1294800 | new / draft |
| TodayJLPT N2 775 | [在籍](entries/1296/1296530-zaiseki.org) | ざいせき | 1296530 | new / draft |
| TodayJLPT N2 776 | [再選](entries/1293/1293070-saisen.org) | さいせん | 1293070 | new / draft |
| TodayJLPT N2 778 | [最短](entries/1294/1294210-saitan.org) | さいたん | 1294210 | new / draft |
| TodayJLPT N2 779 | [財団](entries/1296/1296940-zaidan.org) | ざいだん | 1296940 | new / draft |
| TodayJLPT N2 781 | [再度](entries/1293/1293240-saido.org) | さいど | 1293240 | new / draft |
| TodayJLPT N2 783 | [細部](entries/1295/1295710-saibu.org) | さいぶ | 1295710 | new / draft |
| TodayJLPT N2 800 | [鎖国](entries/1291/1291740-sakoku.org) | さこく | 1291740 | new / draft |
| TodayJLPT N2 813 | [錯覚](entries/1298/1298400-sakkaku.org) | さっかく | 1298400 | new / draft |
| TodayJLPT N2 814 | [殺菌](entries/1299/1299070-sakkin.org) | さっきん | 1299070 | new / draft |
| TodayJLPT N2 826 | [山間](entries/1302/1302810-sankan.org) | さんかん | 1302810 | new / draft |
| TodayJLPT N2 827 | [算出](entries/1303/1303910-sanshutsu.org) | さんしゅつ | 1303910 | new / draft |
| TodayJLPT N2 828 | [三振](entries/1300/1300990-sanshin.org) | さんしん | 1300990 | new / draft |
| TodayJLPT N2 832 | [参拝](entries/1302/1302570-sanpai.org) | さんぱい | 1302570 | new / draft |
| TodayJLPT N2 833 | [散布](entries/1303/1303600-sanpu.org) | さんぷ | 1303600 | new / draft |
| TodayJLPT N2 835 | [産卵](entries/1303/1303890-sanran.org) | さんらん | 1303890 | new / draft |
| TodayJLPT N2 837 | [史](entries/2080/2080900-shi.org) | し | 2080900 | new / draft |
| TodayJLPT N2 838 | [誌](entries/1312/1312610-shi.org) | し | 1312610 | new / draft |
| TodayJLPT N2 849 | [塩辛](entries/1178/1178740-shiokara.org) | しおから | 1178740 | new / draft |
| TodayJLPT N2 855 | [志願](entries/1309/1309080-shigan.org) | しがん | 1309080 | new / draft |
| TodayJLPT N2 861 | [死語](entries/1310/1310840-shigo.org) | しご | 1310840 | new / draft |
| TodayJLPT N2 862 | [資材](entries/1312/1312740-shizai.org) | しざい | 1312740 | new / draft |
| TodayJLPT N2 864 | [指示](entries/1309/1309800-shiji.org) | しじ | 1309800 | new / draft |
| TodayJLPT N2 869 | [史上](entries/1306/1306860-shijou.org) | しじょう | 1306860 | new / draft |
| TodayJLPT N2 871 | [静める](entries/1594/1594280-shizumeru.org) | しずめる | 1594280 | new / draft |
| TodayJLPT N2 894 | [失礼しました](entries/1320/1320240-shitsureishimashita.org) | しつれいしました | 1320240 | new / draft |
| TodayJLPT N2 900 | [市販](entries/1308/1308660-shihan.org) | しはん | 1308660 | new / draft |
| TodayJLPT N2 908 | [島国](entries/1582/1582260-shimaguni.org) | しまぐに | 1582260 | new / draft |
| TodayJLPT N2 921 | [弱者](entries/1324/1324780-jakusha.org) | じゃくしゃ | 1324780 | new / draft |
| TodayJLPT N2 925 | [謝罪](entries/1323/1323030-shazai.org) | しゃざい | 1323030 | new / draft |
| TodayJLPT N2 929 | [車線](entries/1323/1323180-shasen.org) | しゃせん | 1323180 | new / draft |
| TodayJLPT N2 942 | [就寝](entries/1331/1331740-shuushin.org) | しゅうしん | 1331740 | new / draft |
| TodayJLPT N2 949 | [周年](entries/1331/1331240-shuunen.org) | しゅうねん | 1331240 | new / draft |
| TodayJLPT N2 950 | [収納](entries/1330/1330830-shuunou.org) | しゅうのう | 1330830 | new / draft |
| TodayJLPT N2 953 | [収量](entries/1330/1330970-shuuryou.org) | しゅうりょう | 1330970 | new / draft |
| TodayJLPT N2 958 | [収録](entries/1330/1330980-shuuroku.org) | しゅうろく | 1330980 | new / draft |
| TodayJLPT N2 962 | [祝杯](entries/1337/1337510-shukuhai.org) | しゅくはい | 1337510 | new / draft |
| TodayJLPT N2 963 | [祝福](entries/1337/1337520-shukufuku.org) | しゅくふく | 1337520 | new / draft |
| TodayJLPT N2 964 | [熟練](entries/1337/1337930-jukuren.org) | じゅくれん | 1337930 | new / draft |
| TodayJLPT N2 968 | [主将](entries/1325/1325590-shushou.org) | しゅしょう | 1325590 | new / draft |
| TodayJLPT N2 969 | [受賞](entries/1329/1329790-jushou.org) | じゅしょう | 1329790 | new / draft |
| TodayJLPT N2 971 | [酒造](entries/1329/1329140-shuzou.org) | しゅぞう | 1329140 | new / draft |
| TodayJLPT N2 972 | [種族](entries/1328/1328840-shuzoku.org) | しゅぞく | 1328840 | new / draft |
| TodayJLPT N2 973 | [術](entries/1340/1340780-jutsu.org) | じゅつ | 1340780 | new / draft |
| TodayJLPT N2 974 | [出火](entries/1338/1338330-shukka.org) | しゅっか | 1338330 | new / draft |
| TodayJLPT N2 975 | [出荷](entries/1338/1338350-shukka.org) | しゅっか | 1338350 | new / draft |
| TodayJLPT N2 979 | [出展](entries/1339/1339800-shutten.org) | しゅってん | 1339800 | new / draft |
| TodayJLPT N2 980 | [出入](entries/1339/1339900-shutsunyuu.org) | しゅつにゅう | 1339900 | new / draft |
| TodayJLPT N2 984 | [巡回](entries/1342/1342070-junkai.org) | じゅんかい | 1342070 | new / draft |
| TodayJLPT N2 986 | [純金](entries/1341/1341880-junkin.org) | じゅんきん | 1341880 | new / draft |
| TodayJLPT N2 992 | [順路](entries/1609/1609940-junro.org) | じゅんろ | 1609940 | new / draft |
| TodayJLPT N2 993 | [上映](entries/1352/1352650-jouei.org) | じょうえい | 1352650 | new / draft |
| TodayJLPT N2 995 | [少額](entries/1348/1348960-shougaku.org) | しょうがく | 1348960 | new / draft |
| TodayJLPT N2 996 | [昇格](entries/1349/1349740-shoukaku.org) | しょうかく | 1349740 | new / draft |
| TodayJLPT N2 1002 | [昇給](entries/1349/1349760-shoukyuu.org) | しょうきゅう | 1349760 | new / draft |
| TodayJLPT N2 1007 | [将軍](entries/1347/1347680-shougun.org) | しょうぐん | 1347680 | new / draft |
| TodayJLPT N2 1009 | [小国](entries/1348/1348100-shoukoku.org) | しょうこく | 1348100 | new / draft |
| TodayJLPT N2 1010 | [賞賛](entries/1594/1594920-shousan.org) | しょうさん | 1594920 | new / draft |
| TodayJLPT N2 1020 | [小児](entries/1348/1348190-shouni.org) | しょうに | 1348190 | new / draft |
| TodayJLPT N2 1021 | [小人](entries/1348/1348350-shounin.org) | しょうにん | 1348350 | new / draft |
| TodayJLPT N2 1030 | [消滅](entries/1350/1350380-shoumetsu.org) | しょうめつ | 1350380 | new / draft |

## Final 1700-word branch N2 continuation (2026-10-04)

Baseline: `f0d52112`, with **1500** new translated words on this branch.
Completed **80/200** additional distinct words; branch total **1580**.
Words are committed individually in batches of ten. Every English sense has
original Ukrainian translations and nuance notes; each primary sense has
three graded Japanese, kana, Ukrainian, and English examples.
All completed batches passed JMdict validation, Org lint, and doctor 100/100
with zero errors or warnings. These remain learner drafts for editorial review.
The earlier uncommitted 罪 draft is preserved.

Candidates are reconciled against pinned JMdict and existing entry IDs.
N2-69 (佚) remains deferred and is not counted.

| Batch | New entries |
| --- | ---: |
| 1 | 10 |
| 2 | 10 |
| 3 | 10 |
| 4 | 10 |
| 5 | 10 |
| 6 | 10 |
| 7 | 10 |
| 8 | 10 |

| Source candidate | Word | Reading | JMdict ID | Status |
| --- | --- | --- | --- | --- |
| TodayJLPT N2 1051 | [書名](entries/1344/1344170-shomei.org) | しょめい | 1344170 | new / draft |
| TodayJLPT N2 1042 | [諸国](entries/1344/1344270-shokoku.org) | しょこく | 1344270 | new / draft |
| TodayJLPT N2 1049 | [諸島](entries/1344/1344330-shotou.org) | しょとう | 1344330 | new / draft |
| TodayJLPT N2 1041 | [職歴](entries/1357/1357590-shokureki.org) | しょくれき | 1357590 | new / draft |
| Nihon Torii N2 29 | [湿る](entries/1320/1320390-shimeru.org) | しめる | 1320390 | new / draft |
| Nihon Torii N2 108 | [揚げる](entries/2864/2864817-ageru.org) | あげる | 2864817 | new / draft |
| Nihon Torii N2 132 | [討つ](entries/1478/1478010-utsu.org) | うつ | 1478010 | new / draft |
| Nihon Torii N2 148 | [脅す](entries/1238/1238070-odosu.org) | おどす | 1238070 | new / draft |
| Nihon Torii N2 151 | [衰える](entries/1372/1372430-otoroeru.org) | おとろえる | 1372430 | new / draft |
| Nihon Torii N2 155 | [買い込む](entries/1473/1473610-kaikomu.org) | かいこむ | 1473610 | new / draft |
| Nihon Torii N2 175 | [鍛える](entries/1419/1419120-kitaeru.org) | きたえる | 1419120 | new / draft |
| Nihon Torii N2 251 | [発つ](entries/2857/2857436-tatsu.org) | たつ | 2857436 | new / draft |
| Nihon Torii N2 295 | [亡くす](entries/2835/2835808-nakusu.org) | なくす | 2835808 | new / draft |
| Nihon Torii N2 345 | [蒔く](entries/2611/2611890-maku.org) | まく | 2611890 | new / draft |
| Nihon Torii N2 1611 | [薬缶](entries/1605/1605370-yakan.org) | やかん | 1605370 | new / draft |
| TodayJLPT N2 1034 | [少量](entries/1595/1595030-shouryou.org) | しょうりょう | 1595030 | new / draft |
| TodayJLPT N2 1040 | [植林](entries/1357/1357390-shokurin.org) | しょくりん | 1357390 | new / draft |
| TodayJLPT N2 1053 | [知らん顔](entries/1420/1420440-shirankao.org) | しらんかお | 1420440 | new / draft |
| TodayJLPT N2 1059 | [試練](entries/1312/1312590-shiren.org) | しれん | 1312590 | new / draft |
| TodayJLPT N2 1061 | [白黒](entries/1475/1475160-shirokuro.org) | しろくろ | 1475160 | new / draft |
| TodayJLPT N2 1064 | [新型](entries/1361/1361770-shingata.org) | しんがた | 1361770 | new / draft |
| TodayJLPT N2 1065 | [新刊](entries/1361/1361580-shinkan.org) | しんかん | 1361580 | new / draft |
| TodayJLPT N2 1067 | [心境](entries/1360/1360630-shinkyou.org) | しんきょう | 1360630 | new / draft |
| TodayJLPT N2 1071 | [浸水](entries/1362/1362610-shinsui.org) | しんすい | 1362610 | new / draft |
| TodayJLPT N2 1074 | [新設](entries/1362/1362070-shinsetsu.org) | しんせつ | 1362070 | new / draft |
| TodayJLPT N2 1078 | [新党](entries/1362/1362230-shintou.org) | しんとう | 1362230 | new / draft |
| TodayJLPT N2 1079 | [神童](entries/1364/1364780-shindou.org) | しんどう | 1364780 | new / draft |
| TodayJLPT N2 1089 | [水域](entries/1371/1371300-suiiki.org) | すいいき | 1371300 | new / draft |
| TodayJLPT N2 1090 | [水温](entries/1371/1371330-suion.org) | すいおん | 1371330 | new / draft |
| TodayJLPT N2 1091 | [吸い込む](entries/1228/1228230-suikomu.org) | すいこむ | 1228230 | new / draft |
| TodayJLPT N2 1107 | [数値](entries/1373/1373160-suuchi.org) | すうち | 1373160 | new / draft |
| TodayJLPT N2 1146 | [精液](entries/1379/1379890-seieki.org) | せいえき | 1379890 | new / draft |
| TodayJLPT N2 1147 | [声援](entries/1380/1380460-seien.org) | せいえん | 1380460 | new / draft |
| TodayJLPT N2 1149 | [生協](entries/1378/1378910-seikyou.org) | せいきょう | 1378910 | new / draft |
| TodayJLPT N2 1150 | [生後](entries/1378/1378950-seigo.org) | せいご | 1378950 | new / draft |
| TodayJLPT N2 1157 | [生前](entries/1379/1379200-seizen.org) | せいぜん | 1379200 | new / draft |
| TodayJLPT N2 1158 | [正装](entries/1377/1377480-seisou.org) | せいそう | 1377480 | new / draft |
| TodayJLPT N2 1163 | [青銅](entries/1381/1381710-seidou.org) | せいどう | 1381710 | new / draft |
| TodayJLPT N2 1175 | [赤面](entries/1383/1383620-sekimen.org) | せきめん | 1383620 | new / draft |
| TodayJLPT N2 1177 | [絶叫](entries/1386/1386780-zekkyou.org) | ぜっきょう | 1386780 | new / draft |
| TodayJLPT N2 1179 | [摂取](entries/1385/1385710-sesshu.org) | せっしゅ | 1385710 | new / draft |
| TodayJLPT N2 1184 | [接点](entries/1385/1385610-setten.org) | せってん | 1385610 | new / draft |
| TodayJLPT N2 1195 | [全額](entries/1394/1394970-zengaku.org) | ぜんがく | 1394970 | new / draft |
| TodayJLPT N2 1198 | [潜在](entries/1391/1391310-senzai.org) | せんざい | 1391310 | new / draft |
| TodayJLPT N2 1200 | [全焼](entries/1395/1395390-zenshou.org) | ぜんしょう | 1395390 | new / draft |
| TodayJLPT N2 1201 | [染色](entries/1391/1391210-senshoku.org) | せんしょく | 1391210 | new / draft |
| TodayJLPT N2 1205 | [前線](entries/1393/1393510-zensen.org) | ぜんせん | 1393510 | new / draft |
| TodayJLPT N2 1211 | [前兆](entries/1596/1596330-zenchou.org) | ぜんちょう | 1596330 | new / draft |
| TodayJLPT N2 1214 | [先導](entries/1388/1388280-sendou.org) | せんどう | 1388280 | new / draft |
| TodayJLPT N2 1216 | [前年](entries/1393/1393840-zennen.org) | ぜんねん | 1393840 | new / draft |
| TodayJLPT N2 1219 | [専務](entries/1389/1389870-senmu.org) | せんむ | 1389870 | new / draft |
| TodayJLPT N2 1221 | [戦略](entries/1390/1390600-senryaku.org) | せんりゃく | 1390600 | new / draft |
| TodayJLPT N2 1229 | [総計](entries/1401/1401540-soukei.org) | そうけい | 1401540 | new / draft |
| TodayJLPT N2 1235 | [蔵書](entries/1403/1403510-zousho.org) | ぞうしょ | 1403510 | new / draft |
| TodayJLPT N2 1236 | [総数](entries/1401/1401660-sousuu.org) | そうすう | 1401660 | new / draft |
| TodayJLPT N2 1237 | [増税](entries/1403/1403280-zouzei.org) | ぞうぜい | 1403280 | new / draft |
| TodayJLPT N2 1238 | [増設](entries/1403/1403290-zousetsu.org) | ぞうせつ | 1403290 | new / draft |
| TodayJLPT N2 1244 | [挿入](entries/1399/1399840-sounyuu.org) | そうにゅう | 1399840 | new / draft |
| TodayJLPT N2 1246 | [双方](entries/1398/1398940-souhou.org) | そうほう | 1398940 | new / draft |
| TodayJLPT N2 1247 | [総理](entries/1401/1401810-souri.org) | そうり | 1401810 | new / draft |
| TodayJLPT N2 1251 | [族](entries/1405/1405770-zoku.org) | ぞく | 1405770 | new / draft |
| TodayJLPT N2 1256 | [即売](entries/1404/1404300-sokubai.org) | そくばい | 1404300 | new / draft |
| TodayJLPT N2 1259 | [底力](entries/1436/1436120-sokojikara.org) | そこぢから | 1436120 | new / draft |
| TodayJLPT N2 1262 | [注ぎ込む](entries/1581/1581720-sosogikomu.org) | そそぎこむ | 1581720 | new / draft |
| TodayJLPT N2 1279 | [村長](entries/1406/1406840-sonchou.org) | そんちょう | 1406840 | new / draft |
| TodayJLPT N2 1283 | [大火](entries/1413/1413170-taika.org) | たいか | 1413170 | new / draft |
| TodayJLPT N2 1288 | [大国](entries/1413/1413710-taikoku.org) | たいこく | 1413710 | new / draft |
| TodayJLPT N2 1289 | [題材](entries/1415/1415480-daizai.org) | だいざい | 1415480 | new / draft |
| TodayJLPT N2 1292 | [退社](entries/1411/1411400-taisha.org) | たいしゃ | 1411400 | new / draft |
| TodayJLPT N2 1294 | [大将](entries/1581/1581510-taishou.org) | たいしょう | 1581510 | new / draft |
| TodayJLPT N2 1296 | [大賞](entries/1414/1414140-taishou.org) | たいしょう | 1414140 | new / draft |
| TodayJLPT N2 1301 | [代替](entries/1581/1581470-daitai.org) | だいたい | 1581470 | new / draft |
| TodayJLPT N2 1302 | [大仏](entries/1414/1414890-daibutsu.org) | だいぶつ | 1414890 | new / draft |
| TodayJLPT N2 1311 | [大量](entries/1415/1415190-tairyou.org) | たいりょう | 1415190 | new / draft |
| TodayJLPT N2 1320 | [多数](entries/1407/1407860-tasuu.org) | たすう | 1407860 | new / draft |
| TodayJLPT N2 1329 | [脱皮](entries/1416/1416600-dappi.org) | だっぴ | 1416600 | new / draft |
| TodayJLPT N2 1330 | [脱落](entries/1416/1416640-datsuraku.org) | だつらく | 1416640 | new / draft |
| TodayJLPT N2 1333 | [谷底](entries/1416/1416760-tanizoko.org) | たにぞこ | 1416760 | new / draft |
| TodayJLPT N2 1334 | [谷間](entries/1416/1416740-tanima.org) | たにま | 1416740 | new / draft |
| TodayJLPT N2 1345 | [団員](entries/1419/1419180-danin.org) | だんいん | 1419180 | new / draft |

## Maturity workflow

Maturity and schema breadth answer different questions. The maturity state below
tracks confidence; the profile (`core`, `learner`, `enriched`, or `gold`)
tracks how much detail the entry promises.

- **new** — authored and available, but no documented editorial review.
- **changes-requested** — a review found one or more unresolved findings.
- **reviewed** — an editorial/structural review was completed and its known
  findings were fixed; this is not yet independent bilingual approval.
- **confirmed** — a named reviewer independently checked the Japanese
  meaning/usage and the Ukrainian rendering, and filled the review metadata.
- **solid** — confirmed and release-ready within its declared profile: relevant
  examples and pronunciation data are reviewed, automated checks pass, and
  there are no open findings.

Only `confirmed` and `solid` entries may be presented as linguistically
approved. A successful `rake` run is a separate automated gate and never
upgrades maturity by itself.

Allowed progress normally follows:

`new → changes-requested → reviewed → confirmed → solid`

An entry with no findings may move directly from `new` to `reviewed`.

## Midway merge checkpoint

A midpoint merge is ready when:

- the full `rake` quality gate passes;
- every committed entry has one row in this ledger;
- every `changes-requested` row is either fixed or explicitly accepted as
  draft follow-up work in the PR;
- the PR describes `new` and `reviewed` entries as drafts, not as confirmed
  translations.

Draft entries can merge at the midpoint. Their maturity must remain visible so
later agents do not mistake volume for completed bilingual review.

## Open findings

- None open. Resolved on 2026-07-17 (editorial pass by `claude`):
  - `青い / あおい (1381390)`: sense 2 and sense 4 qualifiers corrected.
  - `上げる / あげる (1352320)`: senses 21–23 and 25 had misaligned/incorrect
    Ukrainian glosses (21 "increase of market price" glossed as *блювати*,
    22 "vomit" as *робити послугу*, 23 aux "for someone else" as *для себе*,
    25 humble aux as *вказує на крайній стан*); all corrected and sense 24
    completive gloss clarified.
  - `明後日 / あさって (1584640)`: sense 2 ("wrong (e.g. direction)") had no
    Ukrainian gloss; added *хибний* (idiomatic あさっての方を向く).
  - `足 / あし (1404630)`: sense 1 (足, foot) was glossed *нога* (leg) and
    sense 2 (脚, leg) was glossed *стопа* (foot) — foot/leg swapped; sense 4
    ("pace") was glossed *опора меблів* (furniture leg). Corrected sense 1 to
    *стопа* (+ *лапа*, *щупальце*), sense 2 to *нога*, sense 4 to *темп ходи*.
  - `熱い / あつい (1467720)`: sense 4 gloss *ентузіастичний* (non-standard
    calque for "enthusiastic") replaced with *запальний*.
  - `浴びる / あびる (1547450)`: sense 2 gloss *засипати похвалою* ("to shower
    someone with praise" — wrong valence; 浴びる is the receiver) replaced with
    *отримувати похвалу*.
  - `余り / あまり (1584930)`: example 1 UK translation *Отримати решту з решти*
    (redundant/unclear) reworded to *Отримати залишок решти*.
  Entries above are at `reviewed` and await independent bilingual confirmation.

## Maintenance rules

- Add a row in the same change that adds an entry. New entries start at
  `new`.
- Change maturity only when the corresponding gate above is satisfied.
- Record unresolved review findings in this file, not only in chat.
- Keep `ENTRY_STATUS` and Ukrainian gloss review properties authoritative for
  publication state; this ledger is the cross-entry planning view.
- Reconcile the counts and queue coverage before each merge checkpoint.

## Entry inventory

| Queue order | Entry | Reading | Romaji | JMdict ID | Profile | Entry state | Maturity | Next gate |
| ---: | --- | --- | --- | ---: | --- | --- | --- | --- |
| 1 | [会う](entries/1198/1198180-au.org) | あう | au | 1198180 | learner | draft | **reviewed** | Independent bilingual confirmation |
| 2 | [青](entries/1381/1381380-ao.org) | あお | ao | 1381380 | learner | draft | **reviewed** | Independent bilingual confirmation |
| 3 | [青い](entries/1381/1381390-aoi.org) | あおい | aoi | 1381390 | learner | draft | **reviewed** | Independent bilingual confirmation |
| 4 | [赤](entries/2013/2013900-aka.org) | あか | aka | 2013900 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 5 | [赤い](entries/1383/1383240-akai.org) | あかい | akai | 1383240 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 6 | [明るい](entries/1532/1532350-akarui.org) | あかるい | akarui | 1532350 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 7 | [秋](entries/1332/1332650-aki.org) | あき | aki | 1332650 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 8–10 | [開く](entries/1586/1586270-aku.org) | あく | aku | 1586270 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 11–12 | [開ける](entries/1202/1202450-akeru.org) | あける | akeru | 1202450 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 13 | [上げる](entries/1352/1352320-ageru.org) | あげる | ageru | 1352320 | learner | draft | **reviewed** | Independent bilingual confirmation |
| 14 | [朝](entries/1428/1428280-asa.org) | あさ | asa | 1428280 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 15 | [朝ご飯](entries/1586/1586330-asagohan.org) | あさごはん | asagohan | 1586330 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 16 | [明後日](entries/1584/1584640-asatte.org) | あさって | asatte | 1584640 | learner | draft | **reviewed** | Independent bilingual confirmation |
| 17 | [足](entries/1404/1404630-ashi.org) | あし | ashi | 1404630 | learner | draft | **reviewed** | Independent bilingual confirmation |
| 18 | [明日](entries/1584/1584660-ashita.org) | あした | ashita | 1584660 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 19 | [彼処](entries/1000/1000320-asoko.org) | あそこ | asoko | 1000320 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 20 | [遊ぶ](entries/1542/1542160-asobu.org) | あそぶ | asobu | 1542160 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 21–22 | [温かい](entries/1586/1586420-atatakai.org) | あたたかい | atatakai | 1586420 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 23 | [頭](entries/1582/1582310-atama.org) | あたま | atama | 1582310 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 24 | [新しい](entries/1361/1361490-atarashii.org) | あたらしい | atarashii | 1361490 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 25 | [彼方](entries/1483/1483185-achira.org) | あちら | achira | 1483185 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 26 | [暑い](entries/1343/1343460-atsui.org) | あつい | atsui | 1343460 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 27 | [熱い](entries/1467/1467720-atsui.org) | あつい | atsui | 1467720 | learner | draft | **reviewed** | Independent bilingual confirmation |
| 28 | [厚い](entries/1275/1275320-atsui.org) | あつい | atsui | 1275320 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 29 | [後](entries/1269/1269320-ato.org) | あと | ato | 1269320 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 30 | [貴方](entries/1223/1223615-anata.org) | あなた | anata | 1223615 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 31 | [兄](entries/1249/1249900-ani.org) | あに | ani | 1249900 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 32 | [姉](entries/1307/1307630-ane.org) | あね | ane | 1307630 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 33–34 | [彼の](entries/1000/1000420-ano.org) | あの | ano | 1000420 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 35 | [アパート](entries/1017/1017760-apaato.org) | アパート | apaato | 1017760 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 36 | [浴びる](entries/1547/1547450-abiru.org) | あびる | abiru | 1547450 | learner | draft | **reviewed** | Independent bilingual confirmation |
| 37 | [危ない](entries/1218/1218380-abunai.org) | あぶない | abunai | 1218380 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 38 | [甘い](entries/1213/1213400-amai.org) | あまい | amai | 1213400 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 39 | [余り](entries/1584/1584930-amari.org) | あまり | amari | 1584930 | learner | draft | **reviewed** | Independent bilingual confirmation |
| 40 | [雨](entries/1171/1171900-ame.org) | あめ | ame | 1171900 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 41 | [飴](entries/1153/1153520-ame.org) | あめ | ame | 1153520 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 42 | [洗う](entries/1390/1390930-arau.org) | あらう | arau | 1390930 | learner | reviewed | **confirmed** | Release-readiness audit for solid |
| 43 | [有る](entries/1296/1296400-aru.org) | ある | aru | 1296400 | learner | draft | **new** | Editorial review |
| 44 | [歩く](entries/1514/1514320-aruku.org) | あるく | aruku | 1514320 | learner | draft | **new** | Editorial review |
| 45 | [彼](entries/1000/1000580-are.org) | あれ | are | 1000580 | learner | draft | **new** | Editorial review |
| 46 | [いいえ](entries/1583/1583250-iie.org) | いいえ | iie | 1583250 | learner | draft | **new** | Editorial review |
| 47 | [言う](entries/1587/1587040-iu.org) | いう | iu | 1587040 | learner | draft | **new** | Editorial review |
| 48 | [家](entries/1191/1191730-ie.org) | いえ | ie | 1191730 | learner | draft | **new** | Editorial review |
| 49 | [行く](entries/1578/1578850-iku.org) | いく | iku | 1578850 | learner | draft | **new** | Editorial review |
| 50 | [幾つ](entries/1219/1219960-ikutsu.org) | いくつ | ikutsu | 1219960 | learner | draft | **new** | Editorial review |
| 51 | [幾ら](entries/1219/1219980-ikura.org) | いくら | ikura | 1219980 | learner | draft | **new** | Editorial review |
| 52 | [池](entries/1421/1421700-ike.org) | いけ | ike | 1421700 | learner | draft | **new** | Editorial review |
| 53 | [医者](entries/1159/1159980-isha.org) | いしゃ | isha | 1159980 | learner | draft | **new** | Editorial review |
| 54 | [椅子](entries/1157/1157070-isu.org) | いす | isu | 1157070 | learner | draft | **new** | Editorial review |
| 55 | [忙しい](entries/1519/1519290-isogashii.org) | いそがしい | isogashii | 1519290 | learner | draft | **new** | Editorial review |
| 56 | [痛い](entries/1432/1432680-itai.org) | いたい | itai | 1432680 | learner | draft | **new** | Editorial review |
| 57 | [一](entries/1160/1160790-ichi.org) | いち | ichi | 1160790 | learner | draft | **new** | Editorial review |
| 58 | [一日](entries/1576/1576260-ichinichi.org) | いちにち | ichinichi | 1576260 | learner | draft | **new** | Editorial review |
| 59 | [一番](entries/1165/1165970-ichiban.org) | いちばん | ichiban | 1165970 | learner | draft | **new** | Editorial review |
| 60 | [一緒](entries/1163/1163400-issho.org) | いっしょ | issho | 1163400 | learner | draft | **new** | Editorial review |
| 61 | [何時](entries/1188/1188760-itsu.org) | いつ | itsu | 1188760 | learner | draft | **new** | Editorial review |
| 62 | [５日](entries/1268/1268570-itsuka.org) | いつか | itsuka | 1268570 | learner | draft | **new** | Editorial review |
| 63 | [五つ](entries/1268/1268070-itsutsu.org) | いつつ | itsutsu | 1268070 | learner | draft | **new** | Editorial review |
| 64 | [何時も](entries/1188/1188890-itsumo.org) | いつも | itsumo | 1188890 | learner | draft | **new** | Editorial review |
| 65 | [犬](entries/1258/1258330-inu.org) | いぬ | inu | 1258330 | learner | draft | **new** | Editorial review |
| 66 | [今](entries/1288/1288850-ima.org) | いま | ima | 1288850 | learner | draft | **new** | Editorial review |
| 67 | [意味](entries/1156/1156800-imi.org) | いみ | imi | 1156800 | learner | draft | **new** | Editorial review |
| 68 | [妹](entries/1524/1524590-imouto.org) | いもうと | imouto | 1524590 | learner | draft | **new** | Editorial review |
| 69 | [嫌](entries/1587/1587610-iya.org) | いや | iya | 1587610 | learner | draft | **new** | Editorial review |
| 70 | [入り口](entries/1582/1582820-iriguchi.org) | いりぐち | iriguchi | 1582820 | learner | draft | **new** | Editorial review |
| 71 | [居る](entries/1577/1577980-iru.org) | いる | iru | 1577980 | learner | draft | **new** | Editorial review |
| 72 | [要る](entries/1546/1546640-iru.org) | いる | iru | 1546640 | learner | draft | **new** | Editorial review |
| 73 | [入れる](entries/1465/1465610-ireru.org) | いれる | ireru | 1465610 | learner | draft | **new** | Editorial review |
| 74 | [色](entries/1357/1357600-iro.org) | いろ | iro | 1357600 | learner | draft | **new** | Editorial review |
| 75 | [色々](entries/1587/1587850-iroiro.org) | いろいろ | iroiro | 1587850 | learner | draft | **new** | Editorial review |
| 76 | [上](entries/1352/1352130-ue.org) | うえ | ue | 1352130 | learner | draft | **new** | Editorial review |
| 77 | [後ろ](entries/1269/1269410-ushiro.org) | うしろ | ushiro | 1269410 | learner | draft | **new** | Editorial review |
| 78 | [薄い](entries/1475/1475480-usui.org) | うすい | usui | 1475480 | learner | draft | **new** | Editorial review |
| 79 | [歌](entries/1193/1193180-uta.org) | うた | uta | 1193180 | learner | draft | **new** | Editorial review |
| 80 | [歌う](entries/1588/1588120-utau.org) | うたう | utau | 1588120 | learner | draft | **new** | Editorial review |
| 81 | [生まれる](entries/1378/1378690-umareru.org) | うまれる | umareru | 1378690 | learner | draft | **new** | Editorial review |
| 82 | [海](entries/1201/1201190-umi.org) | うみ | umi | 1201190 | learner | draft | **new** | Editorial review |
| 83 | [売る](entries/1473/1473950-uru.org) | うる | uru | 1473950 | learner | draft | **new** | Editorial review |
| 84 | [煩い](entries/1481/1481920-urusai.org) | うるさい | urusai | 1481920 | learner | draft | **new** | Editorial review |
| 85 | [上着](entries/1580/1580340-uwagi.org) | うわぎ | uwagi | 1580340 | learner | draft | **new** | Editorial review |
| 86 | [絵](entries/1202/1202270-e.org) | え | e | 1202270 | learner | draft | **new** | Editorial review |
| 87 | [映画](entries/1173/1173720-eiga.org) | えいが | eiga | 1173720 | learner | draft | **new** | Editorial review |
| 88 | [映画館](entries/1173/1173750-eigakan.org) | えいがかん | eigakan | 1173750 | learner | draft | **new** | Editorial review |
| 89 | [英語](entries/1174/1174420-eigo.org) | えいご | eigo | 1174420 | learner | draft | **new** | Editorial review |
| 90 | [ええ](entries/1001/1001140-ee.org) | ええ | ee | 1001140 | learner | draft | **new** | Editorial review |
| 91 | [駅](entries/1175/1175140-eki.org) | えき | eki | 1175140 | learner | draft | **new** | Editorial review |
| 92 | [エレベーター](entries/1030/1030630-erebeetaa.org) | エレベーター | erebeetaa | 1030630 | learner | draft | **new** | Editorial review |
| 93 | [鉛筆](entries/1178/1178590-enpitsu.org) | えんぴつ | enpitsu | 1178590 | learner | draft | **new** | Editorial review |
| 94 | [美味しい](entries/1486/1486650-oishii.org) | おいしい | oishii | 1486650 | learner | draft | **new** | Editorial review |
| 95 | [多い](entries/1407/1407460-ooi.org) | おおい | ooi | 1407460 | learner | draft | **new** | Editorial review |
| 96 | [大きい](entries/1588/1588880-ookii.org) | おおきい | ookii | 1588880 | learner | draft | **new** | Editorial review |
| 97 | [大きな](entries/1412/1412890-ookina.org) | おおきな | ookina | 1412890 | learner | draft | **new** | Editorial review |
| 98 | [大勢](entries/1414/1414220-oozei.org) | おおぜい | oozei | 1414220 | learner | draft | **new** | Editorial review |
| 99 | [お母さん](entries/1002/1002650-okaasan.org) | おかあさん | okaasan | 1002650 | learner | draft | **new** | Editorial review |
| 100 | [お菓子](entries/1001/1001710-okashi.org) | おかし | okashi | 1001710 | learner | draft | **new** | Editorial review |
| 101 | [お金](entries/1001/1001820-okane.org) | おかね | okane | 1001820 | learner | draft | **new** | Editorial review |
| 102 | [起きる](entries/1223/1223640-okiru.org) | おきる | okiru | 1223640 | learner | draft | **new** | Editorial review |
| 103 | [置く](entries/1421/1421850-oku.org) | おく | oku | 1421850 | learner | draft | **new** | Editorial review |
| 104 | [奥さん](entries/1179/1179330-okusan.org) | おくさん | okusan | 1179330 | learner | draft | **new** | Editorial review |
| 105 | [お酒](entries/1329/1329015-osake.org) | おさけ | osake | 1329015 | learner | draft | **new** | Editorial review |
| 106 | [お皿](entries/1299/1299685-osara.org) | おさら | osara | 1299685 | learner | draft | **new** | Editorial review |
| 107 | [教える](entries/1236/1236900-oshieru.org) | おしえる | oshieru | 1236900 | learner | draft | **new** | Editorial review |
| 108 | [押す](entries/1180/1180470-osu.org) | おす | osu | 1180470 | learner | draft | **new** | Editorial review |
| 109 | [遅い](entries/1421/1421970-osoi.org) | おそい | osoi | 1421970 | learner | draft | **new** | Editorial review |
| 110 | [お茶](entries/1002/1002430-ocha.org) | おちゃ | ocha | 1002430 | learner | draft | **new** | Editorial review |
| 111 | [お手洗い](entries/1002/1002100-otearai.org) | おてあらい | otearai | 1002100 | learner | draft | **new** | Editorial review |
| 112 | [お父さん](entries/1002/1002590-otousan.org) | おとうさん | otousan | 1002590 | learner | draft | **new** | Editorial review |
| 113 | [弟](entries/1581/1581930-otouto.org) | おとうと | otouto | 1581930 | learner | draft | **new** | Editorial review |
| 114 | [男](entries/1419/1419990-otoko.org) | おとこ | otoko | 1419990 | learner | draft | **new** | Editorial review |
| 115 | [男の子](entries/1420/1420010-otokonoko.org) | おとこのこ | otokonoko | 1420010 | learner | draft | **new** | Editorial review |
| 116 | [一昨日](entries/1576/1576050-ototoi.org) | おととい | ototoi | 1576050 | learner | draft | **new** | Editorial review |
| 117 | [一昨年](entries/1576/1576060-ototoshi.org) | おととし | ototoshi | 1576060 | learner | draft | **new** | Editorial review |
| 118 | [大人](entries/1414/1414170-otona.org) | おとな | otona | 1414170 | learner | draft | **new** | Editorial review |
| 119 | [お腹](entries/1002/1002610-onaka.org) | おなか | onaka | 1002610 | learner | draft | **new** | Editorial review |
| 120 | [同じ](entries/1451/1451750-onaji.org) | おなじ | onaji | 1451750 | learner | draft | **new** | Editorial review |
| 121 | [お兄さん](entries/1001/1001830-oniisan.org) | おにいさん | oniisan | 1001830 | learner | draft | **new** | Editorial review |
| 122 | [お姉さん](entries/1001/1001990-oneesan.org) | おねえさん | oneesan | 1001990 | learner | draft | **new** | Editorial review |
| 123 | [お祖母さん](entries/1002/1002330-obaasan.org) | おばあさん | obaasan | 1002330 | learner | draft | **new** | Editorial review |
| 124 | [伯母さん](entries/2261/2261500-obasan.org) | おばさん | obasan | 2261500 | learner | draft | **new** | Editorial review |
| 125 | [お風呂](entries/2220/2220600-ofuro.org) | おふろ | ofuro | 2220600 | learner | draft | **new** | Editorial review |
| 126 | [お弁当](entries/1513/1513065-obentou.org) | おべんとう | obentou | 1513065 | learner | draft | **new** | Editorial review |
| 127 | [覚える](entries/1206/1206050-oboeru.org) | おぼえる | oboeru | 1206050 | learner | draft | **new** | Editorial review |
| 128 | [お巡りさん](entries/1002/1002120-omawarisan.org) | おまわりさん | omawarisan | 1002120 | learner | draft | **new** | Editorial review |
| 129 | [重い](entries/1335/1335750-omoi.org) | おもい | omoi | 1335750 | learner | draft | **new** | Editorial review |
| 130 | [思う](entries/1589/1589350-omou.org) | おもう | omou | 1589350 | learner | draft | **new** | Editorial review |
| 131 | [面白い](entries/1533/1533580-omoshiroi.org) | おもしろい | omoshiroi | 1533580 | learner | draft | **new** | Editorial review |
| 132 | [泳ぐ](entries/1174/1174340-oyogu.org) | およぐ | oyogu | 1174340 | learner | draft | **new** | Editorial review |
| 133–134 | [下りる](entries/1589/1589500-oriru.org) | おりる | oriru | 1589500 | learner | draft | **new** | Editorial review |
| 135 | [終わる](entries/1589/1589600-owaru.org) | おわる | owaru | 1589600 | learner | draft | **new** | Editorial review |
| 136 | [音楽](entries/1183/1183720-ongaku.org) | おんがく | ongaku | 1183720 | learner | draft | **new** | Editorial review |
| 137 | [女](entries/1344/1344930-onna.org) | おんな | onna | 1344930 | learner | draft | **new** | Editorial review |
| 138 | [女の子](entries/1344/1344970-onnanoko.org) | おんなのこ | onnanoko | 1344970 | learner | draft | **new** | Editorial review |
| 139 | [会社](entries/1198/1198550-kaisha.org) | かいしゃ | kaisha | 1198550 | learner | draft | **new** | Editorial review |
| 140 | [階段](entries/1203/1203090-kaidan.org) | かいだん | kaidan | 1203090 | learner | draft | **new** | Editorial review |
| 141 | [買い物](entries/1589/1589730-kaimono.org) | かいもの | kaimono | 1589730 | learner | draft | **new** | Editorial review |
| 142 | [買う](entries/1473/1473740-kau.org) | かう | kau | 1473740 | learner | draft | **new** | Editorial review |
| 143 | [返す](entries/1512/1512130-kaesu.org) | かえす | kaesu | 1512130 | learner | draft | **new** | Editorial review |
| 144 | [帰る](entries/1221/1221270-kaeru.org) | かえる | kaeru | 1221270 | learner | draft | **new** | Editorial review |
| 145 | [掛かる](entries/1207/1207590-kakaru.org) | かかる | kakaru | 1207590 | learner | draft | **new** | Editorial review |
| 146 | [鍵](entries/1260/1260490-kagi.org) | かぎ | kagi | 1260490 | learner | draft | **new** | Editorial review |
| 147 | [書く](entries/1343/1343950-kaku.org) | かく | kaku | 1343950 | learner | draft | **new** | Editorial review |
| 148 | [掛ける](entries/1207/1207610-kakeru.org) | かける | kakeru | 1207610 | learner | draft | **new** | Editorial review |
| 149 | [傘](entries/1301/1301940-kasa.org) | かさ | kasa | 1301940 | learner | draft | **new** | Editorial review |
| 150 | [貸す](entries/1411/1411160-kasu.org) | かす | kasu | 1411160 | learner | draft | **new** | Editorial review |
| 151 | [風](entries/1499/1499720-kaze.org) | かぜ | kaze | 1499720 | learner | draft | **new** | Editorial review |
| 152 | [風邪](entries/1583/1583720-kaze.org) | かぜ | kaze | 1583720 | learner | draft | **new** | Editorial review |
| 153 | [家族](entries/1192/1192150-kazoku.org) | かぞく | kazoku | 1192150 | learner | draft | **new** | Editorial review |
| 154 | [方](entries/1516/1516925-kata.org) | かた | kata | 1516925 | learner | draft | **new** | Editorial review |
| 155 | [カップ](entries/1037/1037670-kappu.org) | カップ | kappu | 1037670 | learner | draft | **new** | Editorial review |
| 156 | [家庭](entries/1192/1192280-katei.org) | かてい | katei | 1192280 | learner | draft | **new** | Editorial review |
| 157 | [角](entries/1206/1206110-kado.org) | かど | kado | 1206110 | learner | draft | **new** | Editorial review |
| 158 | [鞄](entries/1208/1208910-kaban.org) | かばん | kaban | 1208910 | learner | draft | **new** | Editorial review |
| 159 | [花瓶](entries/1194/1194870-kabin.org) | かびん | kabin | 1194870 | learner | draft | **new** | Editorial review |
| 160 | [紙](entries/1311/1311530-kami.org) | かみ | kami | 1311530 | learner | draft | **new** | Editorial review |
| 161 | [カメラ](entries/1038/1038350-kamera.org) | カメラ | kamera | 1038350 | learner | draft | **new** | Editorial review |
| 162 | [火曜日](entries/1194/1194290-kayoubi.org) | かようび | kayoubi | 1194290 | learner | draft | **new** | Editorial review |
| 163 | [辛い](entries/1365/1365850-karai.org) | からい | karai | 1365850 | learner | draft | **new** | Editorial review |
| 164 | [体](entries/1409/1409140-karada.org) | からだ | karada | 1409140 | learner | draft | **new** | Editorial review |
| 165 | [借りる](entries/1323/1323560-kariru.org) | かりる | kariru | 1323560 | learner | draft | **new** | Editorial review |
| 166 | [軽い](entries/1252/1252560-karui.org) | かるい | karui | 1252560 | learner | draft | **new** | Editorial review |
| 167 | [カレンダー](entries/1039/1039220-karendaa.org) | カレンダー | karendaa | 1039220 | learner | draft | **new** | Editorial review |
| 168 | [カレー](entries/1039/1039140-karee.org) | カレー | karee | 1039140 | learner | draft | **new** | Editorial review |
| 169 | [川](entries/1390/1390020-kawa.org) | かわ | kawa | 1390020 | learner | draft | **new** | Editorial review |
| 170 | [可愛い](entries/1577/1577200-kawaii.org) | かわいい | kawaii | 1577200 | learner | draft | **new** | Editorial review |
| 171 | [漢字](entries/1213/1213170-kanji.org) | かんじ | kanji | 1213170 | learner | draft | **new** | Editorial review |
| 172 | [外国](entries/1203/1203620-gaikoku.org) | がいこく | gaikoku | 1203620 | learner | draft | **new** | Editorial review |
| 173 | [外国人](entries/1203/1203650-gaikokujin.org) | がいこくじん | gaikokujin | 1203650 | learner | draft | **new** | Editorial review |
| 174 | [学生](entries/1206/1206900-gakusei.org) | がくせい | gakusei | 1206900 | learner | draft | **new** | Editorial review |
| 175 | [学校](entries/1206/1206730-gakkou.org) | がっこう | gakkou | 1206730 | learner | draft | **new** | Editorial review |
| 176 | [木](entries/1534/1534520-ki.org) | き | ki | 1534520 | learner | draft | **new** | Editorial review |
| 177 | [黄色](entries/1576/1576760-kiiro.org) | きいろ | kiiro | 1576760 | learner | draft | **new** | Editorial review |
| 178 | [黄色い](entries/1182/1182030-kiiroi.org) | きいろい | kiiroi | 1182030 | learner | draft | **new** | Editorial review |
| 179 | [消える](entries/1350/1350040-kieru.org) | きえる | kieru | 1350040 | learner | draft | **new** | Editorial review |
| 180–181 | [聞く](entries/1591/1591110-kiku.org) | きく | kiku | 1591110 | learner | draft | **new** | Editorial review |
| 182 | [北](entries/1520/1520670-kita.org) | きた | kita | 1520670 | learner | draft | **new** | Editorial review |
| 183 | [汚い](entries/1178/1178940-kitanai.org) | きたない | kitanai | 1178940 | learner | draft | **new** | Editorial review |
| 184 | [喫茶店](entries/1226/1226440-kissaten.org) | きっさてん | kissaten | 1226440 | learner | draft | **new** | Editorial review |
| 185 | [切手](entries/1385/1385070-kitte.org) | きって | kitte | 1385070 | learner | draft | **new** | Editorial review |
| 186 | [切符](entries/1385/1385170-kippu.org) | きっぷ | kippu | 1385170 | learner | draft | **new** | Editorial review |
| 187 | [昨日](entries/1579/1579260-kinou.org) | きのう | kinou | 1579260 | learner | draft | **new** | Editorial review |
| 188, 249 | [今日](entries/1579/1579110-kyou.org) | きょう | kyou | 1579110 | learner | draft | **new** | Editorial review |
| 189 | [教室](entries/1237/1237150-kyoushitsu.org) | きょうしつ | kyoushitsu | 1237150 | learner | draft | **new** | Editorial review |
| 190 | [兄弟](entries/1249/1249960-kyoudai.org) | きょうだい | kyoudai | 1249960 | learner | draft | **new** | Editorial review |
| 191 | [去年](entries/1231/1231690-kyonen.org) | きょねん | kyonen | 1231690 | learner | draft | **new** | Editorial review |
| 192 | [嫌い](entries/1257/1257240-kirai.org) | きらい | kirai | 1257240 | learner | draft | **new** | Editorial review |
| 193 | [切る](entries/1384/1384830-kiru.org) | きる | kiru | 1384830 | learner | draft | **new** | Editorial review |
| 194 | [着る](entries/1423/1423000-kiru.org) | きる | kiru | 1423000 | learner | draft | **new** | Editorial review |
| 195 | [綺麗](entries/1591/1591900-kirei.org) | きれい | kirei | 1591900 | learner | draft | **new** | Editorial review |
| 196 | [キロ](entries/1042/1042610-kiro.org) | キロ | kiro | 1042610 | learner | draft | **new** | Editorial review |
| 197 | [瓩](entries/1042/1042620-kiroguramu.org) | キログラム | kiroguramu | 1042620 | learner | draft | **new** | Editorial review |
| 198 | [粁](entries/1042/1042650-kiromeetoru.org) | キロメートル | kiromeetoru | 1042650 | learner | draft | **new** | Editorial review |
| 199 | [金曜日](entries/1243/1243320-kinyoubi.org) | きんようび | kinyoubi | 1243320 | learner | draft | **new** | Editorial review |
| 200 | [ギター](entries/1042/1042820-gitaa.org) | ギター | gitaa | 1042820 | learner | draft | **new** | Editorial review |
| 201 | [牛肉](entries/1231/1231580-gyuuniku.org) | ぎゅうにく | gyuuniku | 1231580 | learner | draft | **new** | Editorial review |
| 202 | [牛乳](entries/1231/1231590-gyuunyuu.org) | ぎゅうにゅう | gyuunyuu | 1231590 | learner | draft | **new** | Editorial review |
| 203 | [銀行](entries/1243/1243490-ginkou.org) | ぎんこう | ginkou | 1243490 | learner | draft | **new** | Editorial review |
| 204 | [薬](entries/1538/1538160-kusuri.org) | くすり | kusuri | 1538160 | learner | draft | **new** | Editorial review |
| 205 | [下さい](entries/1184/1184270-kudasai.org) | ください | kudasai | 1184270 | learner | draft | **new** | Editorial review |
| 206 | [果物](entries/1193/1193060-kudamono.org) | くだもの | kudamono | 1193060 | learner | draft | **new** | Editorial review |
| 207 | [口](entries/1275/1275640-kuchi.org) | くち | kuchi | 1275640 | learner | draft | **new** | Editorial review |
| 208 | [靴](entries/1246/1246700-kutsu.org) | くつ | kutsu | 1246700 | learner | draft | **new** | Editorial review |
| 209 | [靴下](entries/1246/1246740-kutsushita.org) | くつした | kutsushita | 1246740 | learner | draft | **new** | Editorial review |
| 210 | [国](entries/1592/1592250-kuni.org) | くに | kuni | 1592250 | learner | draft | **new** | Editorial review |
| 211 | [曇り](entries/1592/1592340-kumori.org) | くもり | kumori | 1592340 | learner | draft | **new** | Editorial review |
| 212 | [曇る](entries/1457/1457560-kumoru.org) | くもる | kumoru | 1457560 | learner | draft | **new** | Editorial review |
| 213 | [暗い](entries/1154/1154330-kurai.org) | くらい | kurai | 1154330 | learner | draft | **new** | Editorial review |
| 214 | [クラス](entries/1044/1044070-kurasu.org) | クラス | kurasu | 1044070 | learner | draft | **new** | Editorial review |
| 215 | [来る](entries/1547/1547720-kuru.org) | くる | kuru | 1547720 | learner | draft | **new** | Editorial review |
| 216 | [車](entries/1323/1323080-kuruma.org) | くるま | kuruma | 1323080 | learner | draft | **new** | Editorial review |
| 217 | [黒](entries/1287/1287410-kuro.org) | くろ | kuro | 1287410 | learner | draft | **new** | Editorial review |
| 218 | [黒い](entries/1287/1287420-kuroi.org) | くろい | kuroi | 1287420 | learner | draft | **new** | Editorial review |
| 219 | [瓦](entries/1046/1046810-guramu.org) | グラム | guramu | 1046810 | learner | draft | **new** | Editorial review |
| 220 | [警官](entries/1252/1252330-keikan.org) | けいかん | keikan | 1252330 | learner | draft | **new** | Editorial review |
| 221 | [今朝](entries/1579/1579100-kesa.org) | けさ | kesa | 1579100 | learner | draft | **new** | Editorial review |
| 222 | [消す](entries/1350/1350110-kesu.org) | けす | kesu | 1350110 | learner | draft | **new** | Editorial review |
| 223 | [結構](entries/1254/1254760-kekkou.org) | けっこう | kekkou | 1254760 | learner | draft | **new** | Editorial review |
| 224 | [結婚](entries/1254/1254790-kekkon.org) | けっこん | kekkon | 1254790 | learner | draft | **new** | Editorial review |
| 225 | [月曜日](entries/1255/1255890-getsuyoubi.org) | げつようび | getsuyoubi | 1255890 | learner | draft | **new** | Editorial review |
| 226 | [玄関](entries/1263/1263400-genkan.org) | げんかん | genkan | 1263400 | learner | draft | **new** | Editorial review |
| 227 | [元気](entries/1260/1260720-genki.org) | げんき | genki | 1260720 | learner | draft | **new** | Editorial review |
| 228 | [公園](entries/1273/1273270-kouen.org) | こうえん | kouen | 1273270 | learner | draft | **new** | Editorial review |
| 229 | [交差点](entries/1592/1592970-kousaten.org) | こうさてん | kousaten | 1592970 | learner | draft | **new** | Editorial review |
| 230 | [紅茶](entries/1280/1280770-koucha.org) | こうちゃ | koucha | 1280770 | learner | draft | **new** | Editorial review |
| 231 | [交番](entries/1272/1272500-kouban.org) | こうばん | kouban | 1272500 | learner | draft | **new** | Editorial review |
| 232 | [声](entries/1380/1380440-koe.org) | こえ | koe | 1380440 | learner | draft | **new** | Editorial review |
| 233 | [此処](entries/1288/1288810-koko.org) | ここ | koko | 1288810 | learner | draft | **new** | Editorial review |
| 234 | [９日](entries/1243/1243850-kokonoka.org) | ここのか | kokonoka | 1243850 | learner | draft | **new** | Editorial review |
| 235 | [九つ](entries/1243/1243600-kokonotsu.org) | ここのつ | kokonotsu | 1243600 | learner | draft | **new** | Editorial review |
| 236 | [答える](entries/1449/1449540-kotaeru.org) | こたえる | kotaeru | 1449540 | learner | draft | **new** | Editorial review |
| 237 | [此方](entries/1004/1004500-kochira.org) | こちら | kochira | 1004500 | learner | draft | **new** | Editorial review |
| 238 | [洋杯](entries/1050/1050390-koppu.org) | コップ | koppu | 1050390 | learner | draft | **new** | Editorial review |
| 239 | [今年](entries/1579/1579130-kotoshi.org) | ことし | kotoshi | 1579130 | learner | draft | **new** | Editorial review |
| 240 | [言葉](entries/1264/1264540-kotoba.org) | ことば | kotoba | 1264540 | learner | draft | **new** | Editorial review |
| 241 | [子供](entries/1307/1307850-kodomo.org) | こども | kodomo | 1307850 | learner | draft | **new** | Editorial review |
| 242 | [此の](entries/1582/1582920-kono.org) | この | kono | 1582920 | learner | draft | **new** | Editorial review |
| 243 | [コピー](entries/1050/1050590-kopii.org) | コピー | kopii | 1050590 | learner | draft | **new** | Editorial review |
| 244 | [困る](entries/1289/1289590-komaru.org) | こまる | komaru | 1289590 | learner | draft | **new** | Editorial review |
| 245 | [此れ](entries/1628/1628530-kore.org) | これ | kore | 1628530 | learner | draft | **new** | Editorial review |
| 246 | [今月](entries/1289/1289100-kongetsu.org) | こんげつ | kongetsu | 1289100 | learner | draft | **new** | Editorial review |
| 247 | [今週](entries/1289/1289220-konshuu.org) | こんしゅう | konshuu | 1289220 | learner | draft | **new** | Editorial review |
| 248 | [こんな](entries/1004/1004880-konna.org) | こんな | konna | 1004880 | learner | draft | **new** | Editorial review |
| 250 | [今晩](entries/1289/1289470-konban.org) | こんばん | konban | 1289470 | learner | draft | **new** | Editorial review |
| 251 | [コート](entries/1049/1049000-kooto.org) | コート | kooto | 1049000 | learner | draft | **new** | Editorial review |
| 252 | [珈琲](entries/1049/1049180-koohii.org) | コーヒー | koohii | 1049180 | learner | draft | **new** | Editorial review |
| 253 | [五](entries/1268/1268060-go.org) | ご | go | 1268060 | learner | draft | **new** | Editorial review |
| 254 | [午後](entries/1268/1268990-gogo.org) | ごご | gogo | 1268990 | learner | draft | **new** | Editorial review |
| 255 | [午前](entries/1269/1269060-gozen.org) | ごぜん | gozen | 1269060 | learner | draft | **new** | Editorial review |
| 256 | [ご飯](entries/1270/1270590-gohan.org) | ごはん | gohan | 1270590 | learner | draft | **new** | Editorial review |
| 257 | [さあ](entries/1005/1005110-saa.org) | さあ | saa | 1005110 | learner | draft | **new** | Editorial review |
| 258 | [財布](entries/1296/1296970-saifu.org) | さいふ | saifu | 1296970 | learner | draft | **new** | Editorial review |
| 259 | [魚](entries/1578/1578010-sakana.org) | さかな | sakana | 1578010 | learner | draft | **new** | Editorial review |
| 260 | [先](entries/1387/1387210-saki.org) | さき | saki | 1387210 | learner | draft | **new** | Editorial review |
| 261 | [咲く](entries/1297/1297210-saku.org) | さく | saku | 1297210 | learner | draft | **new** | Editorial review |
| 262 | [作文](entries/1297/1297960-sakubun.org) | さくぶん | sakubun | 1297960 | learner | draft | **new** | Editorial review |
| 263 | [差す](entries/1291/1291330-sasu.org) | さす | sasu | 1291330 | learner | draft | **new** | Editorial review |
| 264 | [砂糖](entries/1291/1291600-satou.org) | さとう | satou | 1291600 | learner | draft | **new** | Editorial review |
| 265 | [寒い](entries/1210/1210360-samui.org) | さむい | samui | 1210360 | learner | draft | **new** | Editorial review |
| 266 | [再来年](entries/1293/1293660-sarainen.org) | さらいねん | sarainen | 1293660 | learner | draft | **new** | Editorial review |
| 267 | [三](entries/1579/1579350-san.org) | さん | san | 1579350 | learner | draft | **new** | Editorial review |
| 268 | [散歩](entries/1303/1303620-sanpo.org) | さんぽ | sanpo | 1303620 | learner | draft | **new** | Editorial review |
| 269 | [雑誌](entries/1299/1299400-zasshi.org) | ざっし | zasshi | 1299400 | learner | draft | **new** | Editorial review |
| 270 | [四](entries/1579/1579470-shi.org) | し | shi | 1579470 | learner | draft | **new** | Editorial review |
| 271 | [塩](entries/1576/1576630-shio.org) | しお | shio | 1576630 | learner | draft | **new** | Editorial review |
| 272 | [然し](entries/1505/1505990-shikashi.org) | しかし | shikashi | 1505990 | learner | draft | **new** | Editorial review |
| 273 | [仕事](entries/1304/1304970-shigoto.org) | しごと | shigoto | 1304970 | learner | draft | **new** | Editorial review |
| 274 | [静か](entries/1381/1381820-shizuka.org) | しずか | shizuka | 1381820 | learner | draft | **new** | Editorial review |
| 275 | [下](entries/1184/1184140-shita.org) | した | shita | 1184140 | learner | draft | **new** | Editorial review |
| 276 | [七](entries/1319/1319210-shichi.org) | しち | shichi | 1319210 | learner | draft | **new** | Editorial review |
| 277 | [質問](entries/1320/1320760-shitsumon.org) | しつもん | shitsumon | 1320760 | learner | draft | **new** | Editorial review |
| 278 | [死ぬ](entries/1310/1310730-shinu.org) | しぬ | shinu | 1310730 | learner | draft | **new** | Editorial review |
| 279 | [閉まる](entries/1436/1436560-shimaru.org) | しまる | shimaru | 1436560 | learner | draft | **new** | Editorial review |
| 280 | [締める](entries/1436/1436570-shimeru.org) | しめる | shimeru | 1436570 | learner | draft | **new** | Editorial review |
| 281 | [閉める](entries/1508/1508590-shimeru2.org) | しめる | shimeru2 | 1508590 | learner | draft | **new** | Editorial review |
| 282 | [写真](entries/1321/1321900-shashin.org) | しゃしん | shashin | 1321900 | learner | draft | **new** | Editorial review |
| 283 | [シャツ](entries/1061/1061520-shatsu.org) | シャツ | shatsu | 1061520 | learner | draft | **new** | Editorial review |
| 284 | [シャワー](entries/1061/1061820-shawaa.org) | シャワー | shawaa | 1061820 | learner | draft | **new** | Editorial review |
| 285 | [宿題](entries/1337/1337270-shukudai.org) | しゅくだい | shukudai | 1337270 | learner | draft | **new** | Editorial review |
| 286 | [醤油](entries/1595/1595020-shouyu.org) | しょうゆ | shouyu | 1595020 | learner | draft | **new** | Editorial review |
| 287 | [食堂](entries/1358/1358550-shokudou.org) | しょくどう | shokudou | 1358550 | learner | draft | **new** | Editorial review |
| 288 | [知る](entries/1420/1420470-shiru.org) | しる | shiru | 1420470 | learner | draft | **new** | Editorial review |
| 289 | [白](entries/1474/1474900-shiro.org) | しろ | shiro | 1474900 | learner | draft | **new** | Editorial review |
| 290 | [白い](entries/1474/1474910-shiroi.org) | しろい | shiroi | 1474910 | learner | draft | **new** | Editorial review |
| 291 | [新聞](entries/1362/1362360-shinbun.org) | しんぶん | shinbun | 1362360 | learner | draft | **new** | Editorial review |
| 292 | [時間](entries/1315/1315920-jikan.org) | じかん | jikan | 1315920 | learner | draft | **new** | Editorial review |
| 293 | [辞書](entries/1318/1318970-jisho.org) | じしょ | jisho | 1318970 | learner | draft | **new** | Editorial review |
| 294 | [自転車](entries/1318/1318290-jitensha.org) | じてんしゃ | jitensha | 1318290 | learner | draft | **new** | Editorial review |
| 295 | [自動車](entries/1318/1318400-jidousha.org) | じどうしゃ | jidousha | 1318400 | learner | draft | **new** | Editorial review |
| 296 | [字引](entries/1315/1315140-jibiki.org) | じびき | jibiki | 1315140 | learner | draft | **new** | Editorial review |
| 297 | [自分](entries/1318/1318610-jibun.org) | じぶん | jibun | 1318610 | learner | draft | **new** | Editorial review |
| 298 | [じゃあ](entries/1005/1005900-jaa.org) | じゃあ | jaa | 1005900 | learner | draft | **new** | Editorial review |
| 299 | [十](entries/1579/1579840-juu.org) | じゅう | juu | 1579840 | learner | draft | **new** | Editorial review |
| 300 | [授業](entries/1330/1330290-jugyou.org) | じゅぎょう | jugyou | 1330290 | learner | draft | **new** | Editorial review |
| 301 | [上手](entries/1353/1353320-jouzu.org) | じょうず | jouzu | 1353320 | learner | draft | **new** | Editorial review |
| 302 | [丈夫](entries/1580/1580480-joubu.org) | じょうぶ | joubu | 1580480 | learner | draft | **new** | Editorial review |
| 303 | [水曜日](entries/1372/1372190-suiyoubi.org) | すいようび | suiyoubi | 1372190 | learner | draft | **new** | Editorial review |
| 304 | [吸う](entries/1228/1228260-suu.org) | すう | suu | 1228260 | learner | draft | **new** | Editorial review |
| 305 | [スカート](entries/1067/1067470-sukaato.org) | スカート | sukaato | 1067470 | learner | draft | **new** | Editorial review |
| 306 | [好き](entries/1277/1277450-suki.org) | すき | suki | 1277450 | learner | draft | **new** | Editorial review |
| 307 | [少ない](entries/1348/1348910-sukunai.org) | すくない | sukunai | 1348910 | learner | draft | **new** | Editorial review |
| 308 | [直ぐに](entries/1430/1430620-suguni.org) | すぐに | suguni | 1430620 | learner | draft | **new** | Editorial review |
| 309 | [少し](entries/1348/1348870-sukoshi.org) | すこし | sukoshi | 1348870 | learner | draft | **new** | Editorial review |
| 310 | [涼しい](entries/1554/1554370-suzushii.org) | すずしい | suzushii | 1554370 | learner | draft | **new** | Editorial review |
| 311 | [ストーブ](entries/1070/1070790-sutoobu.org) | ストーブ | sutoobu | 1070790 | learner | draft | **new** | Editorial review |
| 312 | [スプーン](entries/1072/1072590-supuun.org) | スプーン | supuun | 1072590 | learner | draft | **new** | Editorial review |
| 313 | [スポーツ](entries/1073/1073210-supootsu.org) | スポーツ | supootsu | 1073210 | learner | draft | **new** | Editorial review |
| 314 | [住む](entries/1334/1334040-sumu.org) | すむ | sumu | 1334040 | learner | draft | **new** | Editorial review |
| 315 | [スリッパ](entries/1073/1073900-surippa.org) | スリッパ | surippa | 1073900 | learner | draft | **new** | Editorial review |
| 316 | [為る](entries/1157/1157170-suru.org) | する | suru | 1157170 | learner | draft | **new** | Editorial review |
| 317 | [座る](entries/1291/1291800-suwaru.org) | すわる | suwaru | 1291800 | learner | draft | **new** | Editorial review |
| 318 | [洋袴](entries/1074/1074260-zubon.org) | ズボン | zubon | 1074260 | learner | draft | **new** | Editorial review |
| 319 | [背](entries/2147/2147990-se.org) | せ | se | 2147990 | learner | draft | **new** | Editorial review |
| 320 | [生徒](entries/1379/1379380-seito.org) | せいと | seito | 1379380 | learner | draft | **new** | Editorial review |
| 321 | [石鹸](entries/1382/1382590-sekken.org) | せっけん | sekken | 1382590 | learner | draft | **new** | Editorial review |
| 322 | [背広](entries/1472/1472740-sebiro.org) | せびろ | sebiro | 1472740 | learner | draft | **new** | Editorial review |
| 323 | [狭い](entries/1237/1237680-semai.org) | せまい | semai | 1237680 | learner | draft | **new** | Editorial review |
| 324 | [千](entries/1388/1388740-sen.org) | せん | sen | 1388740 | learner | draft | **new** | Editorial review |
| 325 | [先月](entries/1387/1387500-sengetsu.org) | せんげつ | sengetsu | 1387500 | learner | draft | **new** | Editorial review |
| 326 | [先週](entries/1387/1387870-senshuu.org) | せんしゅう | senshuu | 1387870 | learner | draft | **new** | Editorial review |
| 327 | [先生](entries/1387/1387990-sensei.org) | せんせい | sensei | 1387990 | learner | draft | **new** | Editorial review |
| 328 | [洗濯](entries/1390/1390980-sentaku.org) | せんたく | sentaku | 1390980 | learner | draft | **new** | Editorial review |
| 329 | [セーター](entries/1074/1074270-seetaa.org) | セーター | seetaa | 1074270 | learner | draft | **new** | Editorial review |
| 330 | [全部](entries/1396/1396130-zenbu.org) | ぜんぶ | zenbu | 1396130 | learner | draft | **new** | Editorial review |
| 331 | [然うして](entries/1612/1612860-soushite.org) | そうして | soushite | 1612860 | learner | draft | **new** | Editorial review |
| 332 | [掃除](entries/1399/1399790-souji.org) | そうじ | souji | 1399790 | learner | draft | **new** | Editorial review |
| 333 | [其処](entries/1006/1006670-soko.org) | そこ | soko | 1006670 | learner | draft | **new** | Editorial review |
| 334 | [而して](entries/1006/1006730-soshite.org) | そして | soshite | 1006730 | learner | draft | **new** | Editorial review |
| 335 | [其方](entries/1006/1006780-sochira.org) | そちら | sochira | 1006780 | learner | draft | **new** | Editorial review |
| 336 | [外](entries/1203/1203250-soto.org) | そと | soto | 1203250 | learner | draft | **new** | Editorial review |
| 337 | [其の](entries/1006/1006830-sono.org) | その | sono | 1006830 | learner | draft | **new** | Editorial review |
| 338 | [側](entries/1403/1403830-soba.org) | そば | soba | 1403830 | learner | draft | **new** | Editorial review |
| 339 | [空](entries/1245/1245290-sora.org) | そら | sora | 1245290 | learner | draft | **new** | Editorial review |
| 340 | [其れ](entries/1006/1006970-sore.org) | それ | sore | 1006970 | learner | draft | **new** | Editorial review |
| 341 | [それから](entries/1006/1006980-sorekara.org) | それから | sorekara | 1006980 | learner | draft | **new** | Editorial review |
| 342 | [それでは](entries/1406/1406050-soredewa.org) | それでは | soredewa | 1406050 | learner | draft | **new** | Editorial review |
| 343 | [大使館](entries/1413/1413890-taishikan.org) | たいしかん | taishikan | 1413890 | learner | draft | **new** | Editorial review |
| 344 | [大切](entries/1414/1414340-taisetsu.org) | たいせつ | taisetsu | 1414340 | learner | draft | **new** | Editorial review |
| 345 | [大変](entries/1415/1415000-taihen.org) | たいへん | taihen | 1415000 | learner | draft | **new** | Editorial review |
| 346 | [高い](entries/1283/1283190-takai.org) | たかい | takai | 1283190 | learner | draft | **new** | Editorial review |
| 347 | [沢山](entries/1415/1415870-takusan.org) | たくさん | takusan | 1415870 | learner | draft | **new** | Editorial review |
| 348 | [タクシー](entries/1076/1076190-takushii.org) | タクシー | takushii | 1076190 | learner | draft | **new** | Editorial review |
| 349 | [立つ](entries/1597/1597040-tatsu.org) | たつ | tatsu | 1597040 | learner | draft | **new** | Editorial review |
| 350 | [縦](entries/1335/1335640-tate.org) | たて | tate | 1335640 | learner | draft | **new** | Editorial review |
| 351 | [建物](entries/1257/1257540-tatemono.org) | たてもの | tatemono | 1257540 | learner | draft | **new** | Editorial review |
| 352 | [楽しい](entries/1207/1207240-tanoshii.org) | たのしい | tanoshii | 1207240 | learner | draft | **new** | Editorial review |
| 353 | [頼む](entries/1548/1548370-tanomu.org) | たのむ | tanomu | 1548370 | learner | draft | **new** | Editorial review |
| 354 | [煙草](entries/1597/1597150-tabako.org) | タバコ | tabako | 1597150 | learner | draft | **new** | Editorial review |
| 355 | [多分](entries/1407/1407980-tabun.org) | たぶん | tabun | 1407980 | learner | draft | **new** | Editorial review |
| 356 | [食べ物](entries/1358/1358340-tabemono.org) | たべもの | tabemono | 1358340 | learner | draft | **new** | Editorial review |
| 357 | [食べる](entries/1358/1358280-taberu.org) | たべる | taberu | 1358280 | learner | draft | **new** | Editorial review |
| 358 | [卵](entries/1549/1549140-tamago.org) | たまご | tamago | 1549140 | learner | draft | **new** | Editorial review |
| 359 | [誕生日](entries/1419/1419110-tanjoubi.org) | たんじょうび | tanjoubi | 1419110 | learner | draft | **new** | Editorial review |
| 360 | [大学](entries/1413/1413240-daigaku.org) | だいがく | daigaku | 1413240 | learner | draft | **new** | Editorial review |
| 361 | [大丈夫](entries/1414/1414150-daijoubu.org) | だいじょうぶ | daijoubu | 1414150 | learner | draft | **new** | Editorial review |
| 362 | [大好き](entries/1413/1413660-daisuki.org) | だいすき | daisuki | 1413660 | learner | draft | **new** | Editorial review |
| 363 | [台所](entries/1412/1412640-daidokoro.org) | だいどころ | daidokoro | 1412640 | learner | draft | **new** | Editorial review |
| 364 | [出す](entries/1338/1338180-dasu.org) | だす | dasu | 1338180 | learner | draft | **new** | Editorial review |
| 365 | [誰](entries/1416/1416830-dare.org) | だれ | dare | 1416830 | learner | draft | **new** | Editorial review |
| 366 | [誰か](entries/1416/1416840-dareka.org) | だれか | dareka | 1416840 | learner | draft | **new** | Editorial review |
| 367 | [段々](entries/1597/1597350-dandan.org) | だんだん | dandan | 1597350 | learner | draft | **new** | Editorial review |
| 368 | [小さい](entries/1347/1347750-chiisai.org) | ちいさい | chiisai | 1347750 | learner | draft | **new** | Editorial review |
| 369 | [小さな](entries/2136/2136180-chiisana.org) | ちいさな | chiisana | 2136180 | learner | draft | **new** | Editorial review |
| 370 | [近い](entries/1242/1242130-chikai.org) | ちかい | chikai | 1242130 | learner | draft | **new** | Editorial review |
| 371 | [近く](entries/1242/1242160-chikaku.org) | ちかく | chikaku | 1242160 | learner | draft | **new** | Editorial review |
| 372 | [地下鉄](entries/1420/1420900-chikatetsu.org) | ちかてつ | chikatetsu | 1420900 | learner | draft | **new** | Editorial review |
| 373 | [違う](entries/1158/1158880-chigau.org) | ちがう | chigau | 1158880 | learner | draft | **new** | Editorial review |
| 374 | [地図](entries/1421/1421290-chizu.org) | ちず | chizu | 1421290 | learner | draft | **new** | Editorial review |
| 375 | [茶色](entries/1422/1422720-chairo.org) | ちゃいろ | chairo | 1422720 | learner | draft | **new** | Editorial review |
| 376 | [茶碗](entries/1597/1597530-chawan.org) | ちゃわん | chawan | 1597530 | learner | draft | **new** | Editorial review |
| 377 | [丁度](entries/1427/1427340-choudo.org) | ちょうど | choudo | 1427340 | learner | draft | **new** | Editorial review |
| 378 | [一寸](entries/1163/1163940-chotto.org) | ちょっと | chotto | 1163940 | learner | draft | **new** | Editorial review |
| 379 | [１日](entries/2225/2225040-tsuitachi.org) | ついたち | tsuitachi | 2225040 | learner | draft | **new** | Editorial review |
| 380 | [使う](entries/1305/1305990-tsukau.org) | つかう | tsukau | 1305990 | learner | draft | **new** | Editorial review |
| 381 | [疲れる](entries/1483/1483740-tsukareru.org) | つかれる | tsukareru | 1483740 | learner | draft | **new** | Editorial review |
| 382 | [次](entries/1316/1316380-tsugi.org) | つぎ | tsugi | 1316380 | learner | draft | **new** | Editorial review |
| 383 | [着く](entries/1422/1422970-tsuku.org) | つく | tsuku | 1422970 | learner | draft | **new** | Editorial review |
| 384 | [机](entries/1220/1220210-tsukue.org) | つくえ | tsukue | 1220210 | learner | draft | **new** | Editorial review |
| 385 | [作る](entries/1597/1597890-tsukuru.org) | つくる | tsukuru | 1597890 | learner | draft | **new** | Editorial review |
| 386 | [付ける](entries/1495/1495770-tsukeru.org) | つける | tsukeru | 1495770 | learner | draft | **new** | Editorial review |
| 387 | [勤める](entries/1240/1240825-tsutomeru.org) | つとめる | tsutomeru | 1240825 | learner | draft | **new** | Editorial review |
| 388 | [詰らない](entries/1008/1008190-tsumaranai.org) | つまらない | tsumaranai | 1008190 | learner | draft | **new** | Editorial review |
| 389 | [冷たい](entries/1556/1556730-tsumetai.org) | つめたい | tsumetai | 1556730 | learner | draft | **new** | Editorial review |
| 390 | [強い](entries/1236/1236070-tsuyoi.org) | つよい | tsuyoi | 1236070 | learner | draft | **new** | Editorial review |
| 391 | [手](entries/1327/1327190-te.org) | て | te | 1327190 | learner | draft | **new** | Editorial review |
| 392 | [手紙](entries/1327/1327720-tegami.org) | てがみ | tegami | 1327720 | learner | draft | **new** | Editorial review |
| 393 | [テスト](entries/1079/1079760-tesuto.org) | テスト | tesuto | 1079760 | learner | draft | **new** | Editorial review |
| 394 | [テレビ](entries/1080/1080510-terebi.org) | テレビ | terebi | 1080510 | learner | draft | **new** | Editorial review |
| 395 | [天気](entries/1438/1438690-tenki.org) | てんき | tenki | 1438690 | learner | draft | **new** | Editorial review |
| 396 | [テーブル](entries/1078/1078630-teeburu.org) | テーブル | teeburu | 1078630 | learner | draft | **new** | Editorial review |
| 397 | [テープ](entries/1078/1078750-teepu.org) | テープ | teepu | 1078750 | learner | draft | **new** | Editorial review |
| 398 | [テープレコーダー](entries/1078/1078810-teepurekoodaa.org) | テープレコーダー | teepurekoodaa | 1078810 | learner | draft | **new** | Editorial review |
| 399 | [出かける](entries/1598/1598550-dekakeru.org) | でかける | dekakeru | 1598550 | learner | draft | **new** | Editorial review |
| 400 | [出来る](entries/1340/1340450-dekiru.org) | できる | dekiru | 1340450 | learner | draft | **new** | Editorial review |
| 401 | [出口](entries/1338/1338850-deguchi.org) | でぐち | deguchi | 1338850 | learner | draft | **new** | Editorial review |
| 402 | [では](entries/1008/1008450-dewa.org) | では | dewa | 1008450 | learner | draft | **new** | Editorial review |
| 403 | [デパート](entries/1083/1083590-depaato.org) | デパート | depaato | 1083590 | learner | draft | **new** | Editorial review |
| 404 | [でも](entries/1008/1008460-demo.org) | でも | demo | 1008460 | learner | draft | **new** | Editorial review |
| 405 | [出る](entries/1338/1338240-deru.org) | でる | deru | 1338240 | learner | draft | **new** | Editorial review |
| 406 | [電気](entries/1443/1443000-denki.org) | でんき | denki | 1443000 | learner | draft | **new** | Editorial review |
| 407 | [電車](entries/1443/1443530-densha.org) | でんしゃ | densha | 1443530 | learner | draft | **new** | Editorial review |
| 408 | [電話](entries/1443/1443840-denwa.org) | でんわ | denwa | 1443840 | learner | draft | **new** | Editorial review |
| 409 | [戸](entries/1266/1266970-to.org) | と | to | 1266970 | learner | draft | **new** | Editorial review |
| 410 | [トイレ](entries/1084/1084810-toire.org) | トイレ | toire | 1084810 | learner | draft | **new** | Editorial review |
| 411 | [遠い](entries/1177/1177800-tooi.org) | とおい | tooi | 1177800 | learner | draft | **new** | Editorial review |
| 412 | [１０日](entries/1335/1335000-tooka.org) | とおか | tooka | 1335000 | learner | draft | **new** | Editorial review |
| 413 | [時々](entries/1598/1598680-tokidoki.org) | ときどき | tokidoki | 1598680 | learner | draft | **new** | Editorial review |
| 414 | [時計](entries/1316/1316140-tokei.org) | とけい | tokei | 1316140 | learner | draft | **new** | Editorial review |
| 415 | [所](entries/1343/1343100-tokoro.org) | ところ | tokoro | 1343100 | learner | draft | **new** | Editorial review |
| 416 | [年](entries/1468/1468060-toshi.org) | とし | toshi | 1468060 | learner | draft | **new** | Editorial review |
| 417 | [図書館](entries/1370/1370420-toshokan.org) | としょかん | toshokan | 1370420 | learner | draft | **new** | Editorial review |
| 418 | [迚も](entries/1008/1008630-totemo.org) | とても | totemo | 1008630 | learner | draft | **new** | Editorial review |
| 419 | [隣](entries/1555/1555830-tonari.org) | となり | tonari | 1555830 | learner | draft | **new** | Editorial review |
| 420 | [飛ぶ](entries/1429/1429700-tobu.org) | とぶ | tobu | 1429700 | learner | draft | **new** | Editorial review |
| 421 | [止まる](entries/1310/1310620-tomaru.org) | とまる | tomaru | 1310620 | learner | draft | **new** | Editorial review |
| 422 | [友達](entries/1540/1540170-tomodachi.org) | ともだち | tomodachi | 1540170 | learner | draft | **new** | Editorial review |
| 423 | [鳥](entries/1430/1430250-tori.org) | とり | tori | 1430250 | learner | draft | **new** | Editorial review |
| 424 | [取る](entries/1326/1326980-toru.org) | とる | toru | 1326980 | learner | draft | **new** | Editorial review |
| 425 | [撮る](entries/1298/1298790-toru.org) | とる | toru | 1298790 | learner | draft | **new** | Editorial review |
| 426 | [ドア](entries/1087/1087820-doa.org) | ドア | doa | 1087820 | learner | draft | **new** | Editorial review |
| 427 | [如何](entries/1008/1008910-doo.org) | どう | doo | 1008910 | learner | draft | **new** | Editorial review |
| 428 | [如何して](entries/1466/1466940-dooshite.org) | どうして | dōshite | 1466940 | learner | draft | **new** | Editorial review |
| 429 | [どうぞ](entries/1189/1189130-doozo.org) | どうぞ | dōzo | 1189130 | learner | draft | **new** | Editorial review |
| 430 | [動物](entries/1451/1451470-doobutsu.org) | どうぶつ | dōbutsu | 1451470 | learner | draft | **new** | Editorial review |
| 431 | [どうも](entries/1009/1009000-doomo.org) | どうも | doomo | 1009000 | learner | draft | **new** | Editorial review |
| 432 | [何処](entries/1577/1577140-doko.org) | どこ | doko | 1577140 | learner | draft | **new** | Editorial review |
| 433 | [何方](entries/1189/1189360-dochira.org) | どちら | dochira | 1189360 | learner | draft | **new** | Editorial review |
| 434 | [何方](entries/1189/1189370-donata.org) | どなた | donata | 1189370 | learner | draft | **new** | Editorial review |
| 435 | [何の](entries/1920/1920240-dono.org) | どの | dono | 1920240 | learner | draft | **new** | Editorial review |
| 436 | [土曜日](entries/1445/1445590-doyoobi.org) | どようび | doyōbi | 1445590 | learner | draft | **new** | Editorial review |
| 437 | [何れ](entries/1009/1009290-dore.org) | どれ | dore | 1009290 | learner | draft | **new** | Editorial review |
| 438 | [ナイフ](entries/1089/1089890-naifu.org) | ナイフ | naifu | 1089890 | learner | draft | **new** | Editorial review |
| 439 | [中](entries/1423/1423310-naka.org) | なか | naka | 1423310 | learner | draft | **new** | Editorial review |
| 440 | [長い](entries/1429/1429750-nagai.org) | ながい | nagai | 1429750 | learner | draft | **new** | Editorial review |
| 441 | [鳴く](entries/1532/1532870-naku.org) | なく | naku | 1532870 | learner | draft | **new** | Editorial review |
| 442 | [無くす](entries/1529/1529530-nakusu.org) | なくす | nakusu | 1529530 | learner | draft | **new** | Editorial review |
| 443 | [何故](entries/1577/1577120-naze.org) | なぜ | naze | 1577120 | learner | draft | **new** | Editorial review |
| 444 | [夏](entries/1191/1191320-natsu.org) | なつ | natsu | 1191320 | learner | draft | **new** | Editorial review |
| 445 | [夏休み](entries/1191/1191420-natsuyasumi.org) | なつやすみ | natsuyasumi | 1191420 | learner | draft | **new** | Editorial review |
| 446 | [等](entries/1582/1582300-nado.org) | など | nado | 1582300 | learner | draft | **new** | Editorial review |
| 447 | [七つ](entries/1319/1319220-nanatsu.org) | ななつ | nanatsu | 1319220 | learner | draft | **new** | Editorial review |
| 448 | [何](entries/1577/1577100-nani.org) | なに | nani | 1577100 | learner | draft | **new** | Editorial review |
| 449 | [７日](entries/1579/1579630-nanoka.org) | なのか | nanoka | 1579630 | learner | draft | **new** | Editorial review |
| 450 | [名前](entries/1531/1531710-namae.org) | なまえ | namae | 1531710 | learner | draft | **new** | Editorial review |
| 451 | [習う](entries/1333/1333070-narau.org) | ならう | narau | 1333070 | learner | draft | **new** | Editorial review |
| 452 | [並ぶ](entries/1508/1508380-narabu.org) | ならぶ | narabu | 1508380 | learner | draft | **new** | Editorial review |
| 453 | [並べる](entries/1508/1508390-naraberu.org) | ならべる | naraberu | 1508390 | learner | draft | **new** | Editorial review |
| 454 | [成る](entries/1375/1375610-naru.org) | なる | naru | 1375610 | learner | draft | **new** | Editorial review |
| 455 | [二](entries/1461/1461140-ni.org) | に | ni | 1461140 | learner | draft | **new** | Editorial review |
| 456 | [賑やか](entries/1463/1463480-nigiyaka.org) | にぎやか | nigiyaka | 1463480 | learner | draft | **new** | Editorial review |
| 457 | [肉](entries/1463/1463520-niku.org) | にく | niku | 1463520 | learner | draft | **new** | Editorial review |
| 458 | [西](entries/1380/1380840-nishi.org) | にし | nishi | 1380840 | learner | draft | **new** | Editorial review |
| 459, 486 | [２０歳](entries/1600/1600790-hatachi.org) | はたち / にじゅうさい | hatachi | 1600790 | learner | draft | **new** | Editorial review |
| 460 | [日曜日](entries/1464/1464900-nichiyoubi.org) | にちようび | nichiyoubi | 1464900 | learner | draft | **new** | Editorial review |
| 461 | [荷物](entries/1195/1195430-nimotsu.org) | にもつ | nimotsu | 1195430 | learner | draft | **new** | Editorial review |
| 462 | [ニュース](entries/1091/1091500-nyuusu.org) | ニュース | nyuusu | 1091500 | learner | draft | **new** | Editorial review |
| 463 | [庭](entries/1436/1436130-niwa.org) | にわ | niwa | 1436130 | learner | draft | **new** | Editorial review |
| 464 | [脱ぐ](entries/1416/1416400-nugu.org) | ぬぐ | nugu | 1416400 | learner | draft | **new** | Editorial review |
| 465 | [温い](entries/1183/1183300-nurui.org) | ぬるい | nurui | 1183300 | learner | draft | **new** | Editorial review |
| 466 | [ネクタイ](entries/1092/1092820-nekutai.org) | ネクタイ | nekutai | 1092820 | learner | draft | **new** | Editorial review |
| 467 | [猫](entries/1467/1467640-neko.org) | ねこ | neko | 1467640 | learner | draft | **new** | Editorial review |
| 468 | [寝る](entries/1360/1360010-neru.org) | ねる | neru | 1360010 | learner | draft | **new** | Editorial review |
| 469 | [上る](entries/1352/1352570-noboru.org) | のぼる | noboru | 1352570 | learner | draft | **new** | Editorial review |
| 470 | [飲み物](entries/1600/1600430-nomimono.org) | のみもの | nomimono | 1600430 | learner | draft | **new** | Editorial review |
| 471 | [飲む](entries/1169/1169870-nomu.org) | のむ | nomu | 1169870 | learner | draft | **new** | Editorial review |
| 472 | [乗る](entries/1355/1355120-noru.org) | のる | noru | 1355120 | learner | draft | **new** | Editorial review |
| 473 | [ノート](entries/1093/1093450-nooto.org) | ノート | nooto | 1093450 | learner | draft | **new** | Editorial review |
| 474 | [歯](entries/1313/1313000-ha.org) | は | ha | 1313000 | learner | draft | **new** | Editorial review |
| 475 | [はい](entries/1010/1010080-hai.org) | はい | hai | 1010080 | learner | draft | **new** | Editorial review |
| 476 | [灰皿](entries/1201/1201940-haizara.org) | はいざら | haizara | 1201940 | learner | draft | **new** | Editorial review |
| 477 | [入る](entries/1465/1465590-hairu.org) | はいる | hairu | 1465590 | learner | draft | **new** | Editorial review |
| 478 | [葉書](entries/1546/1546590-hagaki.org) | はがき | hagaki | 1546590 | learner | draft | **new** | Editorial review |
| 479 | [箱](entries/1585/1585650-hako.org) | はこ | hako | 1585650 | learner | draft | **new** | Editorial review |
| 480 | [橋](entries/1237/1237410-hashi.org) | はし | hashi | 1237410 | learner | draft | **new** | Editorial review |
| 481 | [箸](entries/1476/1476410-hashi.org) | はし | hashi | 1476410 | learner | draft | **new** | Editorial review |
| 482 | [走る](entries/1402/1402540-hashiru.org) | はしる | hashiru | 1402540 | learner | draft | **new** | Editorial review |
| 483 | [始まる](entries/1307/1307500-hajimaru.org) | はじまる | hajimaru | 1307500 | learner | draft | **new** | Editorial review |
| 484 | [始め](entries/1342/1342540-hajime.org) | はじめ | hajime | 1342540 | learner | draft | **new** | Editorial review |
| 485 | [初めて](entries/1342/1342550-hajimete.org) | はじめて | hajimete | 1342550 | learner | draft | **new** | Editorial review |
| 487 | [働く](entries/1451/1451150-hataraku.org) | はたらく | hataraku | 1451150 | learner | draft | **new** | Editorial review |
| 488 | [八](entries/1583/1583090-hachi.org) | はち | hachi | 1583090 | learner | draft | **new** | Editorial review |
| 489 | [２０日](entries/1600/1600850-hatsuka.org) | はつか | hatsuka | 1600850 | learner | draft | **new** | Editorial review |
| 490 | [花](entries/1194/1194500-hana.org) | はな | hana | 1194500 | learner | draft | **new** | Editorial review |
| 491 | [鼻](entries/1486/1486720-hana.org) | はな | hana | 1486720 | learner | draft | **new** | Editorial review |
| 492 | [話](entries/1600/1600900-hanashi.org) | はなし | hanashi | 1600900 | learner | draft | **new** | Editorial review |
| 493 | [話す](entries/1562/1562350-hanasu.org) | はなす | hanasu | 1562350 | learner | draft | **new** | Editorial review |
| 494 | [早い](entries/1404/1404975-hayai.org) | はやい | hayai | 1404975 | learner | draft | **new** | Editorial review |
| 495 | [春](entries/1341/1341000-haru.org) | はる | haru | 1341000 | learner | draft | **new** | Editorial review |
| 496 | [張る](entries/1427/1427900-haru.org) | はる | haru | 1427900 | learner | draft | **new** | Editorial review |
| 497 | [晴れ](entries/1376/1376460-hare.org) | はれ | hare | 1376460 | learner | draft | **new** | Editorial review |
| 498 | [晴れる](entries/1376/1376470-hareru.org) | はれる | hareru | 1376470 | learner | draft | **new** | Editorial review |
| 499 | [半](entries/1478/1478750-han.org) | はん | han | 1478750 | learner | draft | **new** | Editorial review |
| 500 | [ハンカチ](entries/1096/1096420-hankachi.org) | ハンカチ | hankachi | 1096420 | learner | draft | **new** | Editorial review |
| 501 | [半分](entries/1479/1479890-hanbun.org) | はんぶん | hanbun | 1479890 | learner | draft | **new** | Editorial review |
| 502 | [バス](entries/1098/1098390-basu.org) | バス | basu | 1098390 | learner | draft | **new** | Editorial review |
| 503 | [バター](entries/1098/1098620-bataa.org) | バター | bataa | 1098620 | learner | draft | **new** | Editorial review |
| 504 | [晩](entries/1482/1482110-ban.org) | ばん | ban | 1482110 | learner | draft | **new** | Editorial review |
| 505 | [番号](entries/1482/1482290-bangou.org) | ばんごう | bangou | 1482290 | learner | draft | **new** | Editorial review |
| 506 | [晩御飯](entries/1601/1601340-bangohan.org) | ばんごはん | bangohan | 1601340 | learner | draft | **new** | Editorial review |
| 507 | [パン](entries/1103/1103090-pan.org) | パン | pan | 1103090 | learner | draft | **new** | Editorial review |
| 508 | [パーティー](entries/1100/1100760-paatii.org) | パーティー | paatii | 1100760 | learner | draft | **new** | Editorial review |
| 509 | [東](entries/1447/1447440-higashi.org) | ひがし | higashi | 1447440 | learner | draft | **new** | Editorial review |
| 510 | [引く](entries/1169/1169250-hiku.org) | ひく | hiku | 1169250 | learner | draft | **new** | Editorial review |
| 511 | [弾く](entries/1419/1419370-hiku.org) | ひく | hiku | 1419370 | learner | draft | **new** | Editorial review |
| 512 | [低い](entries/1434/1434180-hikui.org) | ひくい | hikui | 1434180 | learner | draft | **new** | Editorial review |
| 513 | [飛行機](entries/1485/1485470-hikouki.org) | ひこうき | hikouki | 1485470 | learner | draft | **new** | Editorial review |
| 514 | [左](entries/1290/1290800-hidari.org) | ひだり | hidari | 1290800 | learner | draft | **new** | Editorial review |
| 515 | [人](entries/1580/1580640-hito.org) | ひと | hito | 1580640 | learner | draft | **new** | Editorial review |
| 516 | [一つ](entries/1160/1160820-hitotsu.org) | ひとつ | hitotsu | 1160820 | learner | draft | **new** | Editorial review |
| 517 | [一月](entries/1162/1162130-hitotsuki.org) | ひとつき | hitotsuki | 1162130 | learner | draft | **new** | Editorial review |
| 518 | [一人](entries/1576/1576150-hitori.org) | ひとり | hitori | 1576150 | learner | draft | **new** | Editorial review |
| 519 | [暇](entries/1577/1577280-hima.org) | ひま | hima | 1577280 | learner | draft | **new** | Editorial review |
| 520 | [百](entries/1488/1488000-hyaku.org) | ひゃく | hyaku | 1488000 | learner | draft | **new** | Editorial review |
| 521 | [昼](entries/1426/1426250-hiru.org) | ひる | hiru | 1426250 | learner | draft | **new** | Editorial review |
| 522 | [昼ご飯](entries/1602/1602340-hirugohan.org) | ひるごはん | hirugohan | 1602340 | learner | draft | **new** | Editorial review |
| 523 | [広い](entries/1278/1278410-hiroi.org) | ひろい | hiroi | 1278410 | learner | draft | **new** | Editorial review |
| 524 | [病院](entries/1490/1490220-byooin.org) | びょういん | byōin | 1490220 | learner | draft | **new** | Editorial review |
| 525 | [病気](entries/1490/1490230-byooki.org) | びょうき | byōki | 1490230 | learner | draft | **new** | Editorial review |
| 526 | [フィルム](entries/1109/1109380-firumu.org) | フィルム | firumu | 1109380 | learner | draft | **new** | Editorial review |
| 527 | [封筒](entries/1499/1499690-fuutoo.org) | ふうとう | fūtō | 1499690 | learner | draft | **new** | Editorial review |
| 528 | [フォーク](entries/1110/1110110-fooku.org) | フォーク | fooku | 1110110 | learner | draft | **new** | Editorial review |
| 529 | [服](entries/1500/1500940-fuku.org) | ふく | fuku | 1500940 | learner | draft | **new** | Editorial review |
| 530 | [吹く](entries/1370/1370760-fuku.org) | ふく | fuku | 1370760 | learner | draft | **new** | Editorial review |
| 531 | [二つ](entries/1461/1461160-futatsu.org) | ふたつ | futatsu | 1461160 | learner | draft | **new** | Editorial review |
| 532 | [二人](entries/1582/1582670-futari.org) | ふたり | futari | 1582670 | learner | draft | **new** | Editorial review |
| 533 | [２日](entries/1462/1462900-futsuka.org) | ふつか | futsuka | 1462900 | learner | draft | **new** | Editorial review |
| 534 | [太い](entries/1408/1408180-futoi.org) | ふとい | futoi | 1408180 | learner | draft | **new** | Editorial review |
| 535 | [冬](entries/1446/1446070-fuyu.org) | ふゆ | fuyu | 1446070 | learner | draft | **new** | Editorial review |
| 536 | [降る](entries/1282/1282790-furu.org) | ふる | furu | 1282790 | learner | draft | **new** | Editorial review |
| 537 | [古い](entries/1265/1265070-furui.org) | ふるい | furui | 1265070 | learner | draft | **new** | Editorial review |
| 538 | [風呂](entries/1500/1500100-furo.org) | ふろ | furo | 1500100 | learner | draft | **new** | Editorial review |
| 539 | [豚肉](entries/1457/1457440-butaniku.org) | ぶたにく | butaniku | 1457440 | learner | draft | **new** | Editorial review |
| 540 | [文章](entries/1505/1505470-bunshou.org) | ぶんしょう | bunshou | 1505470 | learner | draft | **new** | Editorial review |
| 541 | [プール](entries/1115/1115150-puuru.org) | プール | puuru | 1115150 | learner | draft | **new** | Editorial review |
| 542 | [下手](entries/1185/1185200-heta.org) | へた | heta | 1185200 | learner | draft | **new** | Editorial review |
| 543 | [部屋](entries/1499/1499320-heya.org) | へや | heya | 1499320 | learner | draft | **new** | Editorial review |
| 544 | [辺](entries/1512/1512070-hen.org) | へん | hen | 1512070 | learner | draft | **new** | Editorial review |
| 545 | [ベッド](entries/1119/1119650-beddo.org) | ベッド | beddo | 1119650 | learner | draft | **new** | Editorial review |
| 546 | [勉強](entries/1512/1512670-benkyou.org) | べんきょう | benkyou | 1512670 | learner | draft | **new** | Editorial review |
| 547 | [便利](entries/1512/1512610-benri.org) | べんり | benri | 1512610 | learner | draft | **new** | Editorial review |
| 548 | [ペット](entries/1120/1120990-petto.org) | ペット | petto | 1120990 | learner | draft | **new** | Editorial review |
| 549 | [ＰＥＴ](entries/2189/2189230-petto.org) | ペット | petto | 2189230 | learner | draft | **new** | Editorial review |
| 550 | [ペン](entries/1121/1121380-pen.org) | ペン | pen | 1121380 | learner | draft | **new** | Editorial review |
| 551 | [頁](entries/1120/1120410-peeji.org) | ページ | peeji | 1120410 | learner | draft | **new** | Editorial review |
| 552 | [他](entries/1203/1203260-hoka.org) | ほか | hoka | 1203260 | learner | draft | **new** | Editorial review |
| 553 | [欲しい](entries/1547/1547330-hoshii.org) | ほしい | hoshii | 1547330 | learner | draft | **new** | Editorial review |
| 554 | [細い](entries/1295/1295510-hosoi.org) | ほそい | hosoi | 1295510 | learner | draft | **new** | Editorial review |
| 555 | [ホテル](entries/1122/1122650-hoteru.org) | ホテル | hoteru | 1122650 | learner | draft | **new** | Editorial review |
| 556 | [本](entries/1522/1522150-hon.org) | ほん | hon | 1522150 | learner | draft | **new** | Editorial review |
| 557 | [本棚](entries/1522/1522980-hondana.org) | ほんだな | hondana | 1522980 | learner | draft | **new** | Editorial review |
| 558 | [本当](entries/1523/1523060-hontou.org) | ほんとう | hontou | 1523060 | learner | draft | **new** | Editorial review |
| 559 | [帽子](entries/1519/1519170-boushi.org) | ぼうし | boushi | 1519170 | learner | draft | **new** | Editorial review |
| 560 | [釦](entries/1123/1123880-botan.org) | ボタン | botan | 1123880 | learner | draft | **new** | Editorial review |
| 561 | [ボールペン](entries/1123/1123590-bo-rupen.org) | ボールペン | rupen | 1123590 | learner | draft | **new** | Editorial review |
| 562 | [ポケット](entries/1124/1124970-poketto.org) | ポケット | poketto | 1124970 | learner | draft | **new** | Editorial review |
| 563 | [ポスト](entries/1125/1125150-posuto.org) | ポスト | posuto | 1125150 | learner | draft | **new** | Editorial review |
| 564 | [毎朝](entries/1524/1524700-maiasa.org) | まいあさ | maiasa | 1524700 | learner | draft | **new** | Editorial review |
| 565 | [毎週](entries/1524/1524690-maishuu.org) | まいしゅう | maishuu | 1524690 | learner | draft | **new** | Editorial review |
| 566 | [毎月](entries/1584/1584350-maitsuki.org) | まいつき | maitsuki | 1584350 | learner | draft | **new** | Editorial review |
| 567 | [毎年](entries/1584/1584360-maitoshi.org) | まいとし | maitoshi | 1584360 | learner | draft | **new** | Editorial review |
| 568 | [毎日](entries/1524/1524720-mainichi.org) | まいにち | mainichi | 1524720 | learner | draft | **new** | Editorial review |
| 569 | [毎晩](entries/1524/1524730-maiban.org) | まいばん | maiban | 1524730 | learner | draft | **new** | Editorial review |
| 570 | [前](entries/1392/1392580-mae.org) | まえ | mae | 1392580 | learner | draft | **new** | Editorial review |
| 571 | [不味い](entries/1495/1495000-mazui.org) | まずい | mazui | 1495000 | learner | draft | **new** | Editorial review |
| 572 | [又](entries/1524/1524930-mata.org) | また | mata | 1524930 | learner | draft | **new** | Editorial review |
| 573 | [未だ](entries/1527/1527110-mada.org) | まだ | mada | 1527110 | learner | draft | **new** | Editorial review |
| 574 | [町](entries/1603/1603990-machi.org) | まち | machi | 1603990 | learner | draft | **new** | Editorial review |
| 575 | [真っ直ぐ](entries/1580/1580600-massugu.org) | まっすぐ | massugu | 1580600 | learner | draft | **new** | Editorial review |
| 576 | [マッチ](entries/2784/2784220-matchi.org) | マッチ | matchi | 2784220 | learner | draft | **new** | Editorial review |
| 577 | [燐寸](entries/1128/1128430-matchi.org) | マッチ | matchi | 1128430 | learner | draft | **new** | Editorial review |
| 578 | [待つ](entries/1410/1410590-matsu.org) | まつ | matsu | 1410590 | learner | draft | **new** | Editorial review |
| 579 | [窓](entries/1401/1401400-mado.org) | まど | mado | 1401400 | learner | draft | **new** | Editorial review |
| 580 | [丸い](entries/1604/1604230-marui.org) | まるい | marui | 1604230 | learner | draft | **new** | Editorial review |
| 581 | [万](entries/1584/1584460-man.org) | まん | man | 1584460 | learner | draft | **new** | Editorial review |
| 582 | [万年筆](entries/1526/1526360-mannenhitsu.org) | まんねんひつ | mannenhitsu | 1526360 | learner | draft | **new** | Editorial review |
| 583 | [磨く](entries/1523/1523940-migaku.org) | みがく | migaku | 1523940 | learner | draft | **new** | Editorial review |
| 584 | [右](entries/1171/1171010-migi.org) | みぎ | migi | 1171010 | learner | draft | **new** | Editorial review |
| 585 | [短い](entries/1418/1418620-mijikai.org) | みじかい | mijikai | 1418620 | learner | draft | **new** | Editorial review |
| 586 | [水](entries/1371/1371260-mizu.org) | みず | mizu | 1371260 | learner | draft | **new** | Editorial review |
| 587 | [店](entries/1582/1582120-mise.org) | みせ | mise | 1582120 | learner | draft | **new** | Editorial review |
| 588 | [見せる](entries/1259/1259210-miseru.org) | みせる | miseru | 1259210 | learner | draft | **new** | Editorial review |
| 589 | [道](entries/1454/1454080-michi.org) | みち | michi | 1454080 | learner | draft | **new** | Editorial review |
| 590 | [３日](entries/1301/1301330-mikka.org) | みっか | mikka | 1301330 | learner | draft | **new** | Editorial review |
| 591 | [三つ](entries/1299/1299740-mittsu.org) | みっつ | mittsu | 1299740 | learner | draft | **new** | Editorial review |
| 592 | [緑](entries/1555/1555300-midori.org) | みどり | midori | 1555300 | learner | draft | **new** | Editorial review |
| 593 | [皆さん](entries/1202/1202170-minasan.org) | みなさん | minasan | 1202170 | learner | draft | **new** | Editorial review |
| 594 | [南](entries/1459/1459870-minami.org) | みなみ | minami | 1459870 | learner | draft | **new** | Editorial review |
| 595 | [耳](entries/1317/1317170-mimi.org) | みみ | mimi | 1317170 | learner | draft | **new** | Editorial review |
| 596 | [見る](entries/1259/1259290-miru.org) | みる | miru | 1259290 | learner | draft | **new** | Editorial review |
| 597 | [皆](entries/1202/1202150-minna.org) | みんな | minna | 1202150 | learner | draft | **new** | Editorial review |
| 598 | [６日](entries/1561/1561470-muika.org) | むいか | muika | 1561470 | learner | draft | **new** | Editorial review |
| 599 | [向こう](entries/1277/1277140-mukoo.org) | むこう | mukō | 1277140 | learner | draft | **new** | Editorial review |
| 600 | [難しい](entries/1460/1460850-muzukashii.org) | むずかしい | muzukashii | 1460850 | learner | draft | **new** | Editorial review |
| 601 | [六つ](entries/1585/1585315-muttsu.org) | むっつ | muttsu | 1585315 | learner | draft | **new** | Editorial review |
| 602 | [村](entries/1406/1406820-mura.org) | むら | mura | 1406820 | learner | draft | **new** | Editorial review |
| 603 | [目](entries/1604/1604890-me.org) | め | me | 1604890 | learner | draft | **new** | Editorial review |
| 604 | [眼](entries/1604/1604890-me.org) | め | me | 1604890 | learner | draft | **new** | Editorial review |
| 605 | [メガネ](entries/1577/1577670-megane.org) | メガネ | megane | 1577670 | learner | draft | **new** | Editorial review |
| 606 | [眼鏡](entries/1577/1577670-megane.org) | めがね | megane | 1577670 | learner | draft | **new** | Editorial review |
| 607 | [米](entries/1132/1132570-meetoru.org) | メートル | meetoru | 1132570 | learner | draft | **new** | Editorial review |
| 608 | [もう](entries/1012/1012480-mou.org) | もう | mou | 1012480 | learner | draft | **new** | Editorial review |
| 609 | [もう一度](entries/2005/2005860-mouichido.org) | もういちど | mouichido | 2005860 | learner | draft | **new** | Editorial review |
| 610 | [木曜日](entries/1534/1534890-mokuyoubi.org) | もくようび | mokuyoubi | 1534890 | learner | draft | **new** | Editorial review |
| 611 | [もっと](entries/1012/1012620-motto.org) | もっと | motto | 1012620 | learner | draft | **new** | Editorial review |
| 612 | [持つ](entries/1315/1315720-motsu.org) | もつ | motsu | 1315720 | learner | draft | **new** | Editorial review |
| 613 | [物](entries/1502/1502390-mono.org) | もの | mono | 1502390 | learner | draft | **new** | Editorial review |
| 614 | [門](entries/1584/1584800-mon.org) | もん | mon | 1584800 | learner | draft | **new** | Editorial review |
| 615 | [問題](entries/1536/1536010-mondai.org) | もんだい | mondai | 1536010 | learner | draft | **new** | Editorial review |
| 616 | [八百屋](entries/1476/1476960-yaoya.org) | やおや | yaoya | 1476960 | learner | draft | **new** | Editorial review |
| 617 | [野菜](entries/1537/1537370-yasai.org) | やさい | yasai | 1537370 | learner | draft | **new** | Editorial review |
| 618 | [易しい](entries/1157/1157000-yasashii.org) | やさしい | yasashii | 1157000 | learner | draft | **new** | Editorial review |
| 619 | [安い](entries/1153/1153670-yasui.org) | やすい | yasui | 1153670 | learner | draft | **new** | Editorial review |
| 620 | [休み](entries/1227/1227500-yasumi.org) | やすみ | yasumi | 1227500 | learner | draft | **new** | Editorial review |
| 621 | [休む](entries/1227/1227560-yasumu.org) | やすむ | yasumu | 1227560 | learner | draft | **new** | Editorial review |
| 622 | [八つ](entries/1583/1583095-yattsu.org) | やっつ | yattsu | 1583095 | learner | draft | **new** | Editorial review |
| 623 | [山](entries/1302/1302680-yama.org) | やま | yama | 1302680 | learner | draft | **new** | Editorial review |
| 624 | [夕方](entries/1542/1542790-yuugata.org) | ゆうがた | yuugata | 1542790 | learner | draft | **new** | Editorial review |
| 625 | [夕飯](entries/1584/1584910-yuuhan.org) | ゆうはん | yuuhan | 1584910 | learner | draft | **new** | Editorial review |
| 626 | [郵便局](entries/1542/1542430-yuubinkyoku.org) | ゆうびんきょく | yuubinkyoku | 1542430 | learner | draft | **new** | Editorial review |
| 627 | [昨夜](entries/1542/1542640-yuube.org) | ゆうべ | yuube | 1542640 | learner | draft | **new** | Editorial review |
| 628 | [有名](entries/1541/1541620-yuumei.org) | ゆうめい | yuumei | 1541620 | learner | draft | **new** | Editorial review |
| 629 | [雪](entries/1386/1386500-yuki.org) | ゆき | yuki | 1386500 | learner | draft | **new** | Editorial review |
| 630 | [ゆっくり](entries/1013/1013050-yukkuri.org) | ゆっくり | yukkuri | 1013050 | learner | draft | **new** | Editorial review |
| 631 | [良い](entries/1605/1605820-yoi.org) | よい | yoi | 1605820 | learner | draft | **new** | Editorial review |
| 632 | [８日](entries/1476/1476920-youka.org) | ようか | youka | 1476920 | learner | draft | **new** | Editorial review |
| 633 | [洋服](entries/1546/1546020-youfuku.org) | ようふく | youfuku | 1546020 | learner | draft | **new** | Editorial review |
| 634 | [良く](entries/1605/1605870-yoku.org) | よく | yoku | 1605870 | learner | draft | **new** | Editorial review |
| 635 | [横](entries/1180/1180570-yoko.org) | よこ | yoko | 1180570 | learner | draft | **new** | Editorial review |
| 636 | [４日](entries/1307/1307320-yokka.org) | よっか | yokka | 1307320 | learner | draft | **new** | Editorial review |
| 637 | [四つ](entries/1307/1307040-yottsu.org) | よっつ | yottsu | 1307040 | learner | draft | **new** | Editorial review |
| 638 | [呼ぶ](entries/1266/1266440-yobu.org) | よぶ | yobu | 1266440 | learner | draft | **new** | Editorial review |
| 639 | [読む](entries/1456/1456360-yomu.org) | よむ | yomu | 1456360 | learner | draft | **new** | Editorial review |
| 640 | [より](entries/1013/1013190-yori.org) | より | yori | 1013190 | learner | draft | **new** | Editorial review |
| 641 | [夜](entries/1536/1536350-yoru.org) | よる | yoru | 1536350 | learner | draft | **new** | Editorial review |
| 642 | [弱い](entries/1324/1324520-yowai.org) | よわい | yowai | 1324520 | learner | draft | **new** | Editorial review |
| 643 | [来月](entries/1547/1547900-raigetsu.org) | らいげつ | raigetsu | 1547900 | learner | draft | **new** | Editorial review |
| 644 | [来週](entries/1548/1548010-raishuu.org) | らいしゅう | raishū | 1548010 | learner | draft | **new** | Editorial review |
| 645 | [来年](entries/1548/1548220-rainen.org) | らいねん | rainen | 1548220 | learner | draft | **new** | Editorial review |
| 646 | [ラジオ](entries/1138/1138860-rajio.org) | ラジオ | rajio | 1138860 | learner | draft | **new** | Editorial review |
| 647 | [ラジカセ](entries/1138/1138960-rajikase.org) | ラジカセ | rajikase | 1138960 | learner | draft | **new** | Editorial review |
| 648 | [立派](entries/1551/1551790-rippa.org) | りっぱ | rippa | 1551790 | learner | draft | **new** | Editorial review |
| 649 | [留学生](entries/1552/1552750-ryuugakusei.org) | りゅうがくせい | ryūgakusei | 1552750 | learner | draft | **new** | Editorial review |
| 650 | [両親](entries/1602/1602710-ryooshin.org) | りょうしん | ryōshin | 1602710 | learner | draft | **new** | Editorial review |
| 651 | [料理](entries/1554/1554310-ryoori.org) | りょうり | ryōri | 1554310 | learner | draft | **new** | Editorial review |
| 652 | [旅行](entries/1553/1553170-ryokoo.org) | りょこう | ryokō | 1553170 | learner | draft | **new** | Editorial review |
| 653 | [零](entries/1557/1557630-rei.org) | れい | rei | 1557630 | learner | draft | **new** | Editorial review |
| 654 | [冷蔵庫](entries/1557/1557110-reizooko.org) | れいぞうこ | reizōko | 1557110 | learner | draft | **new** | Editorial review |
| 655 | [レコード](entries/1144/1144940-rekoodo.org) | レコード | rekoodo | 1144940 | learner | draft | **new** | Editorial review |
| 656 | [レストラン](entries/1145/1145310-resutoran.org) | レストラン | resutoran | 1145310 | learner | draft | **new** | Editorial review |
| 657 | [練習](entries/1559/1559160-renshuu.org) | れんしゅう | renshū | 1559160 | learner | draft | **new** | Editorial review |
| 658 | [廊下](entries/1560/1560670-rooka.org) | ろうか | rōka | 1560670 | learner | draft | **new** | Editorial review |
| 659 | [六](entries/1585/1585310-roku.org) | ろく | roku | 1585310 | learner | draft | **new** | Editorial review |
| 660 | [Ｙシャツ](entries/1148/1148640-waishatsu.org) | ワイシャツ | waishatsu | 1148640 | learner | draft | **new** | Editorial review |
| 661 | [若い](entries/1324/1324300-wakai.org) | わかい | wakai | 1324300 | learner | draft | **new** | Editorial review |
| 662 | [分かる](entries/1606/1606560-wakaru.org) | わかる | wakaru | 1606560 | learner | draft | **new** | Editorial review |
| 663 | [忘れる](entries/1519/1519210-wasureru.org) | わすれる | wasureru | 1519210 | learner | draft | **new** | Editorial review |
| 664 | [私](entries/1311/1311110-watashi.org) | わたし | watashi | 1311110 | learner | draft | **new** | Editorial review |
| 665 | [渡す](entries/1444/1444610-watasu.org) | わたす | watasu | 1444610 | learner | draft | **new** | Editorial review |
| 666 | [渡る](entries/1444/1444680-wataru.org) | わたる | wataru | 1444680 | learner | draft | **new** | Editorial review |
| 667 | [悪い](entries/1151/1151260-warui.org) | わるい | warui | 1151260 | learner | draft | **new** | Editorial review |
| seed | [日本語](entries/1464/1464530-nihongo.org) | にほんご | nihongo | 1464530 | enriched | draft | **new** | Editorial review |

### N4 entry inventory

Queue orders 72–91 were excluded from this checkpoint because they remained
un-authored scaffolds. The retained N4 entries below contain authored learner
content and remain at `new` until editorial review.

| Queue order | Entry | Reading | Romaji | JMdict ID | Profile | Entry state | Maturity | Next gate |
| ---: | --- | --- | --- | ---: | --- | --- | --- | --- |
| N4-001 | [間](entries/1215/1215230-aida.org) | あいだ | aida | 1215230 | learner | draft | **new** | Editorial review |
| N4-002 | [合う](entries/1284/1284430-au.org) | あう | au | 1284430 | learner | draft | **new** | Editorial review |
| N4-003 | [赤ちゃん](entries/1383/1383260-akachan.org) | あかちゃん | akachan | 1383260 | learner | draft | **new** | Editorial review |
| N4-004 | [赤ん坊](entries/1383/1383310-akanbou.org) | あかんぼう | akanbou | 1383310 | learner | draft | **new** | Editorial review |
| N4-005 | [上がる](entries/1352/1352290-agaru.org) | あがる | agaru | 1352290 | learner | draft | **new** | Editorial review |
| N4-006 | [浅い](entries/1390/1390800-asai.org) | あさい | asai | 1390800 | learner | draft | **new** | Editorial review |
| N4-007 | [味](entries/1526/1526960-aji.org) | あじ | aji | 1526960 | learner | draft | **new** | Editorial review |
| N4-008 | [遊び](entries/1542/1542070-asobi.org) | あそび | asobi | 1542070 | learner | draft | **new** | Editorial review |
| N4-009 | [集まる](entries/1333/1333550-atsumaru.org) | あつまる | atsumaru | 1333550 | learner | draft | **new** | Editorial review |
| N4-010 | [集める](entries/1333/1333560-atsumeru.org) | あつめる | atsumeru | 1333560 | learner | draft | **new** | Editorial review |
| N4-011 | [謝る](entries/1323/1323010-ayamaru.org) | あやまる | ayamaru | 1323010 | learner | draft | **new** | Editorial review |
| N4-012 | [安心](entries/1153/1153890-anshin.org) | あんしん | anshin | 1153890 | learner | draft | **new** | Editorial review |
| N4-013 | [安全](entries/1153/1153930-anzen.org) | あんぜん | anzen | 1153930 | learner | draft | **new** | Editorial review |
| N4-014 | [以下](entries/1155/1155060-ika.org) | いか | ika | 1155060 | learner | draft | **new** | Editorial review |
| N4-015 | [以外](entries/1155/1155090-igai.org) | いがい | igai | 1155090 | learner | draft | **new** | Editorial review |
| N4-016 | [医学](entries/1159/1159810-igaku.org) | いがく | igaku | 1159810 | learner | draft | **new** | Editorial review |
| N4-017 | [生きる](entries/1378/1378520-ikiru.org) | いきる | ikiru | 1378520 | learner | draft | **new** | Editorial review |
| N4-018 | [意見](entries/1156/1156530-iken.org) | いけん | iken | 1156530 | learner | draft | **new** | Editorial review |
| N4-019 | [石](entries/1382/1382440-ishi.org) | いし | ishi | 1382440 | learner | draft | **new** | Editorial review |
| N4-020 | [苛める](entries/1195/1195140-ijimeru.org) | いじめる | ijimeru | 1195140 | learner | draft | **new** | Editorial review |
| N4-021 | [以上](entries/1155/1155120-ijou.org) | いじょう | ijou | 1155120 | learner | draft | **new** | Editorial review |
| N4-022 | [急ぐ](entries/1228/1228650-isogu.org) | いそぐ | isogu | 1228650 | learner | draft | **new** | Editorial review |
| N4-023 | [致す](entries/1421/1421900-itasu.org) | いたす | itasu | 1421900 | learner | draft | **new** | Editorial review |
| N4-024 | [一度](entries/1576/1576250-ichido.org) | いちど | ichido | 1576250 | learner | draft | **new** | Editorial review |
| N4-025 | [一生懸命](entries/1164/1164010-isshoukenmei.org) | いっしょうけんめい | isshoukenmei | 1164010 | learner | draft | **new** | Editorial review |
| N4-026 | [糸](entries/1311/1311450-ito.org) | いと | ito | 1311450 | learner | draft | **new** | Editorial review |
| N4-027 | [以内](entries/1155/1155180-inai.org) | いない | inai | 1155180 | learner | draft | **new** | Editorial review |
| N4-028 | [田舎](entries/1442/1442750-inaka.org) | いなか | inaka | 1442750 | learner | draft | **new** | Editorial review |
| N4-029 | [祈る](entries/1222/1222770-inoru.org) | いのる | inoru | 1222770 | learner | draft | **new** | Editorial review |
| N4-030 | [植える](entries/1357/1357250-ueru.org) | うえる | ueru | 1357250 | learner | draft | **new** | Editorial review |
| N4-031 | [受付](entries/1588/1588060-uketsuke.org) | うけつけ | uketsuke | 1588060 | learner | draft | **new** | Editorial review |
| N4-032 | [受ける](entries/1329/1329590-ukeru.org) | うける | ukeru | 1329590 | learner | draft | **new** | Editorial review |
| N4-033 | [動く](entries/1451/1451210-ugoku.org) | うごく | ugoku | 1451210 | learner | draft | **new** | Editorial review |
| N4-034 | [内](entries/1457/1457730-uchi.org) | うち | uchi | 1457730 | learner | draft | **new** | Editorial review |
| N4-035 | [打つ](entries/1408/1408810-utsu.org) | うつ | utsu | 1408810 | learner | draft | **new** | Editorial review |
| N4-036 | [美しい](entries/1486/1486360-utsukushii.org) | うつくしい | utsukushii | 1486360 | learner | draft | **new** | Editorial review |
| N4-037 | [写す](entries/1588/1588320-utsusu.org) | うつす | utsusu | 1588320 | learner | draft | **new** | Editorial review |
| N4-038 | [移る](entries/1158/1158210-utsuru.org) | うつる | utsuru | 1158210 | learner | draft | **new** | Editorial review |
| N4-039 | [腕](entries/1562/1562850-ude.org) | うで | ude | 1562850 | learner | draft | **new** | Editorial review |
| N4-040 | [売り場](entries/1588/1588550-uriba.org) | うりば | uriba | 1588550 | learner | draft | **new** | Editorial review |
| N4-041 | [運転手](entries/1172/1172870-untenshu.org) | うんてんしゅ | untenshu | 1172870 | learner | draft | **new** | Editorial review |
| N4-042 | [枝](entries/1310/1310530-eda.org) | えだ | eda | 1310530 | learner | draft | **new** | Editorial review |
| N4-043 | [選ぶ](entries/1588/1588730-erabu.org) | えらぶ | erabu | 1588730 | learner | draft | **new** | Editorial review |
| N4-044 | [遠慮](entries/1178/1178450-enryo.org) | えんりょ | enryo | 1178450 | learner | draft | **new** | Editorial review |
| N4-045 | [お出でになる](entries/1001/1001180-oideninaru.org) | おいでになる | oideninaru | 1001180 | learner | draft | **new** | Editorial review |
| N4-046 | [お祝い](entries/1612/1612770-oiwai.org) | おいわい | oiwai | 1612770 | learner | draft | **new** | Editorial review |
| N4-047 | [お陰](entries/1001/1001640-okage.org) | おかげ | okage | 1001640 | learner | draft | **new** | Editorial review |
| N4-048 | [可笑しい](entries/1190/1190860-okashii.org) | おかしい | okashii | 1190860 | learner | draft | **new** | Editorial review |
| N4-049 | [億](entries/1182/1182620-oku.org) | おく | oku | 1182620 | learner | draft | **new** | Editorial review |
| N4-050 | [屋上](entries/1182/1182710-okujou.org) | おくじょう | okujou | 1182710 | learner | draft | **new** | Editorial review |
| N4-051 | [送る](entries/1402/1402730-okuru.org) | おくる | okuru | 1402730 | learner | draft | **new** | Editorial review |
| N4-052 | [遅れる](entries/1589/1589040-okureru.org) | おくれる | okureru | 1589040 | learner | draft | **new** | Editorial review |
| N4-053 | [起こす](entries/1223/1223660-okosu.org) | おこす | okosu | 1223660 | learner | draft | **new** | Editorial review |
| N4-054 | [行う](entries/1589/1589060-okonau.org) | おこなう | okonau | 1589060 | learner | draft | **new** | Editorial review |
| N4-055 | [怒る](entries/1445/1445690-okoru.org) | おこる | okoru | 1445690 | learner | draft | **new** | Editorial review |
| N4-056 | [押入れ](entries/1589/1589110-oshiire.org) | おしいれ | oshiire | 1589110 | learner | draft | **new** | Editorial review |
| N4-057 | [お嬢さん](entries/1002/1002170-ojousan.org) | おじょうさん | ojousan | 1002170 | learner | draft | **new** | Editorial review |
| N4-058 | [お宅](entries/1002/1002400-otaku.org) | おたく | otaku | 1002400 | learner | draft | **new** | Editorial review |
| N4-059 | [落ちる](entries/1548/1548550-ochiru.org) | おちる | ochiru | 1548550 | learner | draft | **new** | Editorial review |
| N4-060 | [仰る](entries/1238/1238840-ossharu.org) | おっしゃる | ossharu | 1238840 | learner | draft | **new** | Editorial review |
| N4-061 | [夫](entries/1496/1496480-otto.org) | おっと | otto | 1496480 | learner | draft | **new** | Editorial review |
| N4-062 | [お釣り](entries/1270/1270550-otsuri.org) | おつり | otsuri | 1270550 | learner | draft | **new** | Editorial review |
| N4-063 | [音](entries/1576/1576900-oto.org) | おと | oto | 1576900 | learner | draft | **new** | Editorial review |
| N4-064 | [落とす](entries/1589/1589260-otosu.org) | おとす | otosu | 1589260 | learner | draft | **new** | Editorial review |
| N4-065 | [踊り](entries/1546/1546880-odori.org) | おどり | odori | 1546880 | learner | draft | **new** | Editorial review |
| N4-066 | [踊る](entries/1538/1538440-odoru.org) | おどる | odoru | 1538440 | learner | draft | **new** | Editorial review |
| N4-067 | [驚く](entries/1238/1238680-odoroku.org) | おどろく | odoroku | 1238680 | learner | draft | **new** | Editorial review |
| N4-068 | [お祭り](entries/1604/1604135-omatsuri.org) | おまつり | omatsuri | 1604135 | learner | draft | **new** | Editorial review |
| N4-069 | [お見舞い](entries/1001/1001870-omimai.org) | おみまい | omimai | 1001870 | learner | draft | **new** | Editorial review |
| N4-070 | [お土産](entries/1002/1002500-omiyage.org) | おみやげ | omiyage | 1002500 | learner | draft | **new** | Editorial review |
| N4-071 | [思い出す](entries/1309/1309260-omoidasu.org) | おもいだす | omoidasu | 1309260 | learner | draft | **new** | Editorial review |
| N4-088 | [鏡](entries/1238/1238550-kagami.org) | かがみ | kagami | 1238550 | learner | draft | **new** | Editorial review |
| N4-092 | [形](entries/1250/1250220-katachi.org) | かたち | katachi | 1250220 | learner | draft | **new** | Editorial review |
| N4-093 | [片付ける](entries/1511/1511790-katazukeru.org) | かたづける | katazukeru | 1511790 | learner | draft | **new** | Editorial review |
| N4-094 | [課長](entries/1195/1195840-kachou.org) | かちょう | kachou | 1195840 | learner | draft | **new** | Editorial review |
| N4-095 | [勝つ](entries/1346/1346150-katsu.org) | かつ | katsu | 1346150 | learner | draft | **new** | Editorial review |
| N4-096 | [家内](entries/1192/1192420-kanai.org) | かない | kanai | 1192420 | learner | draft | **new** | Editorial review |
| N4-097 | [悲しい](entries/1483/1483190-kanashii.org) | かなしい | kanashii | 1483190 | learner | draft | **new** | Editorial review |
| N4-098 | [必ず](entries/1487/1487400-kanarazu.org) | かならず | kanarazu | 1487400 | learner | draft | **new** | Editorial review |
| N4-099 | [彼女](entries/1483/1483150-kanojo.org) | かのじょ | kanojo | 1483150 | learner | draft | **new** | Editorial review |
| N4-100 | [壁](entries/1509/1509290-kabe.org) | かべ | kabe | 1509290 | learner | draft | **new** | Editorial review |
| N4-101 | [髪](entries/1477/1477950-kami.org) | かみ | kami | 1477950 | learner | draft | **new** | Editorial review |
| N4-102 | [噛む](entries/1209/1209240-kamu.org) | かむ | kamu | 1209240 | learner | draft | **new** | Editorial review |
| N4-103 | [通う](entries/1432/1432850-kayou.org) | かよう | kayou | 1432850 | learner | draft | **new** | Editorial review |
| N4-104 | [乾く](entries/1209/1209650-kawaku.org) | かわく | kawaku | 1209650 | learner | draft | **new** | Editorial review |
| N4-105 | [代わり](entries/1590/1590770-kawari.org) | かわり | kawari | 1590770 | learner | draft | **new** | Editorial review |
| N4-106 | [変わる](entries/1510/1510790-kawaru.org) | かわる | kawaru | 1510790 | learner | draft | **new** | Editorial review |
| N4-107 | [考える](entries/1281/1281020-kangaeru.org) | かんがえる | kangaeru | 1281020 | learner | draft | **new** | Editorial review |
| N4-108 | [関係](entries/1215/1215810-kankei.org) | かんけい | kankei | 1215810 | learner | draft | **new** | Editorial review |
| N4-109 | [簡単](entries/1214/1214330-kantan.org) | かんたん | kantan | 1214330 | learner | draft | **new** | Editorial review |
| N4-110 | [気](entries/1221/1221520-ki.org) | き | ki | 1221520 | learner | draft | **new** | Editorial review |
| N4-111 | [機会](entries/1220/1220800-kikai.org) | きかい | kikai | 1220800 | learner | draft | **new** | Editorial review |
| N4-305 | [妻](entries/1294/1294330-tsuma.org) | つま | tsuma | 1294330 | learner | draft | **new** | Editorial review |
| N4-413 | [参る](entries/1302/1302070-mairu.org) | まいる | mairu | 1302070 | learner | draft | **new** | Editorial review |
| N4-414 | [負ける](entries/1497/1497980-makeru.org) | まける | makeru | 1497980 | learner | draft | **new** | Editorial review |
| N4-415 | [又は](entries/1524/1524990-mataha.org) | または | mataha | 1524990 | learner | draft | **new** | Editorial review |
| N4-416 | [間違える](entries/1215/1215330-machigaeru.org) | まちがえる | machigaeru | 1215330 | learner | draft | **new** | Editorial review |
| N4-417 | [間に合う](entries/1215/1215260-maniau.org) | まにあう | maniau | 1215260 | learner | draft | **new** | Editorial review |
| N4-418 | [周り](entries/1604/1604290-mawari.org) | まわり | mawari | 1604290 | learner | draft | **new** | Editorial review |
| N4-419 | [漫画](entries/1526/1526920-manga.org) | まんが | manga | 1526920 | learner | draft | **new** | Editorial review |
| N4-420 | [見える](entries/1259/1259140-mieru.org) | みえる | mieru | 1259140 | learner | draft | **new** | Editorial review |
| N4-421 | [湖](entries/1267/1267280-mizuumi.org) | みずうみ | mizuumi | 1267280 | learner | draft | **new** | Editorial review |
| N4-422 | [味噌](entries/1527/1527040-miso.org) | みそ | miso | 1527040 | learner | draft | **new** | Editorial review |
| N4-423 | [見つかる](entries/1604/1604550-mitsukaru.org) | みつかる | mitsukaru | 1604550 | learner | draft | **new** | Editorial review |
| N4-424 | [見つける](entries/1604/1604570-mitsukeru.org) | みつける | mitsukeru | 1604570 | learner | draft | **new** | Editorial review |
| N4-425 | [港](entries/1279/1279990-minato.org) | みなと | minato | 1279990 | learner | draft | **new** | Editorial review |
| N4-426 | [向かう](entries/1604/1604800-mukau.org) | むかう | mukau | 1604800 | learner | draft | **new** | Editorial review |
| N4-427 | [迎える](entries/1253/1253190-mukaeru.org) | むかえる | mukaeru | 1253190 | learner | draft | **new** | Editorial review |
| N4-428 | [昔](entries/1382/1382370-mukashi.org) | むかし | mukashi | 1382370 | learner | draft | **new** | Editorial review |
| N4-429 | [虫](entries/1426/1426680-mushi.org) | むし | mushi | 1426680 | learner | draft | **new** | Editorial review |
| N4-430 | [息子](entries/1404/1404390-musuko.org) | むすこ | musuko | 1404390 | learner | draft | **new** | Editorial review |
| N4-431 | [無理](entries/1530/1530970-muri.org) | むり | muri | 1530970 | learner | draft | **new** | Editorial review |
| N4-432 | [召し上がる](entries/1346/1346370-meshiagaru.org) | めしあがる | meshiagaru | 1346370 | learner | draft | **new** | Editorial review |
| N4-433 | [珍しい](entries/1431/1431850-mezurashii.org) | めずらしい | mezurashii | 1431850 | learner | draft | **new** | Editorial review |
| N4-434 | [申し上げる](entries/1362/1362950-moushiageru.org) | もうしあげる | moushiageru | 1362950 | learner | draft | **new** | Editorial review |
| N4-435 | [申す](entries/1363/1363090-mousu.org) | もうす | mousu | 1363090 | learner | draft | **new** | Editorial review |
| N4-436 | [もう直ぐ](entries/2015/2015610-mousugu.org) | もうすぐ | mousugu | 2015610 | learner | draft | **new** | Editorial review |
| N4-437 | [若し](entries/1012/1012500-moshi.org) | もし | moshi | 1012500 | learner | draft | **new** | Editorial review |
| N4-438 | [戻る](entries/1535/1535880-modoru.org) | もどる | modoru | 1535880 | learner | draft | **new** | Editorial review |
| N4-439 | [木綿](entries/1534/1534870-momen.org) | もめん | momen | 1534870 | learner | draft | **new** | Editorial review |
| N4-440 | [森](entries/1362/1362490-mori.org) | もり | mori | 1362490 | learner | draft | **new** | Editorial review |
| N4-441 | [焼く](entries/1350/1350600-yaku.org) | やく | yaku | 1350600 | learner | draft | **new** | Editorial review |
| N4-442 | [約束](entries/1538/1538130-yakusoku.org) | やくそく | yakusoku | 1538130 | learner | draft | **new** | Editorial review |
| N4-443 | [役に立つ](entries/1537/1537980-yakunitatsu.org) | やくにたつ | yakunitatsu | 1537980 | learner | draft | **new** | Editorial review |
| N4-444 | [焼ける](entries/1350/1350610-yakeru.org) | やける | yakeru | 1350610 | learner | draft | **new** | Editorial review |
| N4-445 | [優しい](entries/1539/1539040-yasashii.org) | やさしい | yasashii | 1539040 | learner | draft | **new** | Editorial review |
| N4-446 | [痩せる](entries/1605/1605510-yaseru.org) | やせる | yaseru | 1605510 | learner | draft | **new** | Editorial review |
| N4-447 | [漸と](entries/1012/1012800-yatto.org) | やっと | yatto | 1012800 | learner | draft | **new** | Editorial review |
| N4-448 | [止む](entries/1310/1310640-yamu.org) | やむ | yamu | 1310640 | learner | draft | **new** | Editorial review |
| N4-449 | [柔らかい](entries/1605/1605630-yawarakai.org) | やわらかい | yawarakai | 1605630 | learner | draft | **new** | Editorial review |
| N4-450 | [湯](entries/1448/1448580-yu.org) | ゆ | yu | 1448580 | learner | draft | **new** | Editorial review |
| N4-451 | [指](entries/1309/1309650-yubi.org) | ゆび | yubi | 1309650 | learner | draft | **new** | Editorial review |
| N4-452 | [指輪](entries/1310/1310050-yubiwa.org) | ゆびわ | yubiwa | 1310050 | learner | draft | **new** | Editorial review |
| N4-453 | [夢](entries/1529/1529410-yume.org) | ゆめ | yume | 1529410 | learner | draft | **new** | Editorial review |
| N4-454 | [揺れる](entries/1545/1545710-yureru.org) | ゆれる | yureru | 1545710 | learner | draft | **new** | Editorial review |
| N4-455 | [用](entries/1546/1546200-you.org) | よう | you | 1546200 | learner | draft | **new** | Editorial review |
| N4-456 | [用意](entries/1546/1546220-youi.org) | ようい | youi | 1546220 | learner | draft | **new** | Editorial review |
| N4-457 | [用事](entries/1546/1546300-youji.org) | ようじ | youji | 1546300 | learner | draft | **new** | Editorial review |
| N4-458 | [予習](entries/1543/1543070-yoshuu.org) | よしゅう | yoshuu | 1543070 | learner | draft | **new** | Editorial review |
| N4-459 | [予定](entries/1543/1543240-yotei.org) | よてい | yotei | 1543240 | learner | draft | **new** | Editorial review |
| N4-460 | [予約](entries/1543/1543750-yoyaku.org) | よやく | yoyaku | 1543750 | learner | draft | **new** | Editorial review |
| N4-461 | [寄る](entries/1219/1219680-yoru.org) | よる | yoru | 1219680 | learner | draft | **new** | Editorial review |
| N4-462 | [喜ぶ](entries/1218/1218760-yorokobu.org) | よろこぶ | yorokobu | 1218760 | learner | draft | **new** | Editorial review |
| N4-463 | [理由](entries/1550/1550140-riyuu.org) | りゆう | riyuu | 1550140 | learner | draft | **new** | Editorial review |
| N4-464 | [両方](entries/1554/1554010-ryouhou.org) | りょうほう | ryouhou | 1554010 | learner | draft | **new** | Editorial review |
| N4-465 | [旅館](entries/1553/1553130-ryokan.org) | りょかん | ryokan | 1553130 | learner | draft | **new** | Editorial review |
| N4-466 | [利用](entries/1549/1549660-riyou.org) | りよう | riyou | 1549660 | learner | draft | **new** | Editorial review |
| N4-467 | [留守](entries/1552/1552760-rusu.org) | るす | rusu | 1552760 | learner | draft | **new** | Editorial review |
| N4-468 | [冷房](entries/1557/1557290-reibou.org) | れいぼう | reibou | 1557290 | learner | draft | **new** | Editorial review |
| N4-469 | [歴史](entries/1558/1558050-rekishi.org) | れきし | rekishi | 1558050 | learner | draft | **new** | Editorial review |
| N4-470 | [連絡](entries/1559/1559900-renraku.org) | れんらく | renraku | 1559900 | learner | draft | **new** | Editorial review |
| N4-471 | [沸かす](entries/1501/1501660-wakasu.org) | わかす | wakasu | 1501660 | learner | draft | **new** | Editorial review |
| N4-472 | [別れる](entries/1606/1606590-wakareru.org) | わかれる | wakareru | 1606590 | learner | draft | **new** | Editorial review |
| N4-473 | [沸く](entries/1606/1606680-waku.org) | わく | waku | 1606680 | learner | draft | **new** | Editorial review |
| N4-474 | [訳](entries/1538/1538330-wake.org) | わけ | wake | 1538330 | learner | draft | **new** | Editorial review |
| N4-475 | [忘れ物](entries/1519/1519230-wasuremono.org) | わすれもの | wasuremono | 1519230 | learner | draft | **new** | Editorial review |
| N4-476 | [笑う](entries/1351/1351360-warau.org) | わらう | warau | 1351360 | learner | draft | **new** | Editorial review |
| N4-477 | [割合](entries/1606/1606810-wariai.org) | わりあい | wariai | 1606810 | learner | draft | **new** | Editorial review |
| N4-478 | [割れる](entries/1208/1208020-wareru.org) | われる | wareru | 1208020 | learner | draft | **new** | Editorial review |
| N4-479 | [亜細亜](entries/1015/1015840-ajia.org) | アジア | ajia | 1015840 | learner | draft | **new** | Editorial review |
| N4-480 | [阿弗利加](entries/1929/1929050-afurika.org) | アフリカ | afurika | 1929050 | learner | draft | **new** | Editorial review |
| N4-481 | [亜米利加](entries/1149/1149830-amerika.org) | アメリカ | amerika | 1149830 | learner | draft | **new** | Editorial review |
| N4-482 | [瓦斯](entries/1040/1040060-gasu.org) | ガス | gasu | 1040060 | learner | draft | **new** | Editorial review |
| N4-483 | [硝子](entries/1040/1040380-garasu.org) | ガラス | garasu | 1040380 | learner | draft | **new** | Editorial review |
| N4-484 | [ＦＡＸ](entries/1108/1108180-fakkusu.org) | ファックス | fakkusu | 1108180 | learner | draft | **new** | Editorial review |
| N4-485 | [あんな](entries/1000/1000590-anna.org) | あんな | anna | 1000590 | learner | draft | **new** | Editorial review |
| N4-486 | [一杯](entries/1165/1165670-ippai.org) | いっぱい | ippai | 1165670 | learner | draft | **new** | Editorial review |
| N4-487 | [居らっしゃる](entries/1000/1000940-irassharu.org) | いらっしゃる | irassharu | 1000940 | learner | draft | **new** | Editorial review |
| N4-488 | [裏](entries/1550/1550190-ura.org) | うら | ura | 1550190 | learner | draft | **new** | Editorial review |
| N4-489 | [うん](entries/1001/1001090-un.org) | うん | un | 1001090 | learner | draft | **new** | Editorial review |
| N4-490 | [贈り物](entries/1589/1589030-okurimono.org) | おくりもの | okurimono | 1589030 | learner | draft | **new** | Editorial review |
| N4-491 | [彼](entries/1483/1483070-kare.org) | かれ | kare | 1483070 | learner | draft | **new** | Editorial review |
| N4-492 | [君](entries/1247/1247260-kun.org) | くん | kun | 1247260 | learner | draft | **new** | Editorial review |
| N4-493 | [米](entries/1508/1508750-kome.org) | こめ | kome | 1508750 | learner | draft | **new** | Editorial review |
| N4-494 | [市](entries/1308/1308090-shi.org) | し | shi | 1308090 | learner | draft | **new** | Editorial review |
| N4-495 | [字](entries/1315/1315130-ji.org) | じ | ji | 1315130 | learner | draft | **new** | Editorial review |
| N4-496 | [十分](entries/1335/1335080-juubun.org) | じゅうぶん | juubun | 1335080 | learner | draft | **new** | Editorial review |
| N4-497 | [すっかり](entries/1006/1006110-sukkari.org) | すっかり | sukkari | 1006110 | learner | draft | **new** | Editorial review |
| N4-498 | [すっと](entries/1006/1006140-sutto.org) | すっと | sutto | 1006140 | learner | draft | **new** | Editorial review |
| N4-499 | [すると](entries/1006/1006280-suruto.org) | すると | suruto | 1006280 | learner | draft | **new** | Editorial review |
| N4-500 | [そろそろ](entries/1345/1345605-sorosoro.org) | そろそろ | sorosoro | 1345605 | learner | draft | **new** | Editorial review |
| N4-501 | [そんな](entries/1007/1007130-sonna.org) | そんな | sonna | 1007130 | learner | draft | **new** | Editorial review |
| N4-502 | [そんなに](entries/2008/2008740-sonnani.org) | そんなに | sonnani | 2008740 | learner | draft | **new** | Editorial review |
| N4-503 | [畳](entries/1356/1356750-tatami.org) | たたみ | tatami | 1356750 | learner | draft | **new** | Editorial review |
| N4-504 | [だから](entries/1007/1007310-dakara.org) | だから | dakara | 1007310 | learner | draft | **new** | Editorial review |
| N4-505 | [ちゃん](entries/1007/1007660-chan.org) | ちゃん | chan | 1007660 | learner | draft | **new** | Editorial review |
| N4-506 | [点](entries/1441/1441390-ten.org) | てん | ten | 1441390 | learner | draft | **new** | Editorial review |
| N4-507 | [都](entries/1621/1621470-to.org) | と | to | 1621470 | learner | draft | **new** | Editorial review |
| N4-508 | [到頭](entries/1449/1449890-toutou.org) | とうとう | toutou | 1449890 | learner | draft | **new** | Editorial review |
| N4-509 | [どんどん](entries/1009/1009320-dondon.org) | どんどん | dondon | 1009320 | learner | draft | **new** | Editorial review |
| N4-510 | [直す](entries/1599/1599390-naosu.org) | なおす | naosu | 1599390 | learner | draft | **new** | Editorial review |
| N4-511 | [はっきり](entries/1010/1010150-hakkiri.org) | はっきり | hakkiri | 1010150 | learner | draft | **new** | Editorial review |
| N4-512 | [火](entries/1193/1193610-hi.org) | ひ | hi | 1193610 | learner | draft | **new** | Editorial review |
| N4-513 | [日](entries/1463/1463770-hi.org) | ひ | hi | 1463770 | learner | draft | **new** | Editorial review |
| N4-514 | [酷い](entries/1602/1602060-hidoi.org) | ひどい | hidoi | 1602060 | learner | draft | **new** | Editorial review |
| N4-515 | [僕](entries/1521/1521400-boku.org) | ぼく | boku | 1521400 | learner | draft | **new** | Editorial review |
| N4-516 | [回る](entries/1604/1604300-mawaru.org) | まわる | mawaru | 1604300 | learner | draft | **new** | Editorial review |
| N4-517 | [娘](entries/1531/1531190-musume.org) | むすめ | musume | 1531190 | learner | draft | **new** | Editorial review |
| N4-518 | [止める](entries/1310/1310680-yameru.org) | やめる | yameru | 1310680 | learner | draft | **new** | Editorial review |
| N4-519 | [汚れる](entries/1179/1179005-yogoreru.org) | よごれる | yogoreru | 1179005 | learner | draft | **new** | Editorial review |
| N4-520 | [アクセサリー](entries/1015/1015220-akusesarii.org) | アクセサリー | akusesarii | 1015220 | learner | draft | **new** | Editorial review |
| N4-521 | [アナウンサー](entries/1017/1017330-anaunsaa.org) | アナウンサー | anaunsaa | 1017330 | learner | draft | **new** | Editorial review |
| N4-522 | [アルコール](entries/1019/1019280-arukooru.org) | アルコール | arukooru | 1019280 | learner | draft | **new** | Editorial review |
| N4-523 | [アルバイト](entries/1019/1019420-arubaito.org) | アルバイト | arubaito | 1019420 | learner | draft | **new** | Editorial review |
| N4-524 | [エスカレーター](entries/1028/1028580-esukareetaa.org) | エスカレーター | esukareetaa | 1028580 | learner | draft | **new** | Editorial review |
| N4-525 | [オートバイ](entries/1032/1032030-ootobai.org) | オートバイ | ootobai | 1032030 | learner | draft | **new** | Editorial review |
| N4-526 | [カーテン](entries/1036/1036290-kaaten.org) | カーテン | kaaten | 1036290 | learner | draft | **new** | Editorial review |
| N4-527 | [ガソリン](entries/1040/1040250-gasorin.org) | ガソリン | gasorin | 1040250 | learner | draft | **new** | Editorial review |
| N4-528 | [ガソリンスタンド](entries/1040/1040260-gasorinsutando.org) | ガソリンスタンド | gasorinsutando | 1040260 | learner | draft | **new** | Editorial review |
| N4-529 | [ケーキ](entries/1047/1047860-keeki.org) | ケーキ | keeki | 1047860 | learner | draft | **new** | Editorial review |
| N4-530 | [コンサート](entries/1051/1051970-konsaato.org) | コンサート | konsaato | 1051970 | learner | draft | **new** | Editorial review |
| N4-531 | [コンピュータ](entries/1053/1053350-konpyuuta.org) | コンピュータ | konpyuuta | 1053350 | learner | draft | **new** | Editorial review |
| N4-532 | [サラダ](entries/1057/1057850-sarada.org) | サラダ | sarada | 1057850 | learner | draft | **new** | Editorial review |
| N4-533 | [サンダル](entries/1058/1058480-sandaru.org) | サンダル | sandaru | 1058480 | learner | draft | **new** | Editorial review |
| N4-534 | [サンドイッチ](entries/1058/1058580-sandoitchi.org) | サンドイッチ | sandoitchi | 1058580 | learner | draft | **new** | Editorial review |
| N4-535 | [ジャム](entries/1065/1065680-jamu.org) | ジャム | jamu | 1065680 | learner | draft | **new** | Editorial review |
| N4-536 | [スクリーン](entries/1068/1068550-sukuriin.org) | スクリーン | sukuriin | 1068550 | learner | draft | **new** | Editorial review |
| N4-537 | [ステレオ](entries/1070/1070650-sutereo.org) | ステレオ | sutereo | 1070650 | learner | draft | **new** | Editorial review |
| N4-538 | [ステーキ](entries/1070/1070280-suteeki.org) | ステーキ | suteeki | 1070280 | learner | draft | **new** | Editorial review |
| N4-539 | [スーツ](entries/1066/1066680-suutsu.org) | スーツ | suutsu | 1066680 | learner | draft | **new** | Editorial review |
| N4-540 | [スーツケース](entries/1066/1066690-suutsukeesu.org) | スーツケース | suutsukeesu | 1066690 | learner | draft | **new** | Editorial review |
| N4-541 | [ソフト](entries/1075/1075500-sofuto.org) | ソフト | sofuto | 1075500 | learner | draft | **new** | Editorial review |
| N4-542 | [タイプ](entries/1075/1075940-taipu.org) | タイプ | taipu | 1075940 | learner | draft | **new** | Editorial review |
| N4-543 | [チェック](entries/1077/1077550-chekku.org) | チェック | chekku | 1077550 | learner | draft | **new** | Editorial review |
| N4-544 | [テキスト](entries/1079/1079290-tekisuto.org) | テキスト | tekisuto | 1079290 | learner | draft | **new** | Editorial review |
| N4-545 | [テニス](entries/1080/1080000-tenisu.org) | テニス | tenisu | 1080000 | learner | draft | **new** | Editorial review |
| N4-546 | [パソコン](entries/1101/1101570-pasokon.org) | パソコン | pasokon | 1101570 | learner | draft | **new** | Editorial review |
| N4-547 | [パート](entries/1100/1100810-paato.org) | パート | paato | 1100810 | learner | draft | **new** | Editorial review |
| N4-548 | [ビル](entries/1106/1106010-biru.org) | ビル | biru | 1106010 | learner | draft | **new** | Editorial review |
| N4-549 | [ピアノ](entries/1106/1106400-piano.org) | ピアノ | piano | 1106400 | learner | draft | **new** | Editorial review |
| N4-550 | [プレゼント](entries/1116/1116840-purezento.org) | プレゼント | purezento | 1116840 | learner | draft | **new** | Editorial review |
| N4-551 | [ベル](entries/1120/1120010-beru.org) | ベル | beru | 1120010 | learner | draft | **new** | Editorial review |
| N4-552 | [レジ](entries/1145/1145130-reji.org) | レジ | reji | 1145130 | learner | draft | **new** | Editorial review |
| N4-553 | [レポート](entries/1145/1145990-repooto.org) | レポート | repooto | 1145990 | learner | draft | **new** | Editorial review |
| N4-554 | [ワープロ](entries/1148/1148520-waapuro.org) | ワープロ | waapuro | 1148520 | learner | draft | **new** | Editorial review |
| N4-555 | [挨拶](entries/1151/1151120-aisatsu.org) | 挨拶 | aisatsu | 1151120 | learner | draft | **new** | Editorial review |
| N4-559 | [案内](entries/1154/1154860-annai.org) | 案内 | annai | 1154860 | learner | draft | **new** | Editorial review |
| N4-560 | [頂く](entries/1587/1587290-itadaku.org) | 頂く | itadaku | 1587290 | learner | draft | **new** | Editorial review |
| N4-561 | [員](entries/1168/1168610-in.org) | いん | in | 1168610 | learner | draft | **new** | Editorial review |
| N4-562 | [伺う](entries/1305/1305700-ukagau.org) | うかがう | ukagau | 1305700 | learner | draft | **new** | Editorial review |
| N4-563 | [嘘](entries/1172/1172400-uso.org) | うそ | uso | 1172400 | learner | draft | **new** | Editorial review |
| N4-564 | [上手い](entries/1310/1310460-umai.org) | うまい | umai | 1310460 | learner | draft | **new** | Editorial review |
| N4-565 | [嬉しい](entries/1219/1219510-ureshii.org) | うれしい | ureshii | 1219510 | learner | draft | **new** | Editorial review |
| N4-566 | [運転](entries/1172/1172830-unten.org) | うんてん | unten | 1172830 | learner | draft | **new** | Editorial review |
| N4-567 | [運動](entries/1172/1172910-undou.org) | うんどう | undou | 1172910 | learner | draft | **new** | Editorial review |
| N4-568 | [お子さん](entries/1002/1002000-okosan.org) | おこさん | okosan | 1002000 | learner | draft | **new** | Editorial review |
| N4-569 | [泳ぎ方](entries/2005/2005990-oyogikata.org) | およぎかた | oyogikata | 2005990 | learner | draft | **new** | Editorial review |
| N4-571 | [家](entries/2220/2220280-ka.org) | か | ka | 2220280 | learner | draft | **new** | Editorial review |
| N4-572 | [会](entries/1198/1198170-kai.org) | かい | kai | 1198170 | learner | draft | **new** | Editorial review |
| N4-573 | [構う](entries/1279/1279680-kamau.org) | かまう | kamau | 1279680 | learner | draft | **new** | Editorial review |
| N4-574 | [彼ら](entries/1483/1483090-karera.org) | かれら | karera | 1483090 | learner | draft | **new** | Editorial review |
| N4-575 | [看護師](entries/1928/1928100-kangoshi.org) | かんごし | kangoshi | 1928100 | learner | draft | **new** | Editorial review |
| N4-576 | [看護婦](entries/1213/1213870-kangofu.org) | かんごふ | kangofu | 1213870 | learner | draft | **new** | Editorial review |
| N4-577 | [学部](entries/1207/1207080-gakubu.org) | がくぶ | gakubu | 1207080 | learner | draft | **new** | Editorial review |
| N4-578 | [頑張る](entries/1217/1217700-ganbaru.org) | がんばる | ganbaru | 1217700 | learner | draft | **new** | Editorial review |
| N4-579 | [規則](entries/1223/1223021-kisoku.org) | きそく | kisoku | 1223021 | learner | draft | **new** | Editorial review |
| N4-580 | [区](entries/1244/1244080-ku.org) | く | ku | 1244080 | learner | draft | **new** | Editorial review |
| N4-581 | [下さる](entries/1184/1184280-kudasaru.org) | くださる | kudasaru | 1184280 | learner | draft | **new** | Editorial review |
| N4-582 | [計画](entries/1252/1252090-keikaku.org) | けいかく | keikaku | 1252090 | learner | draft | **new** | Editorial review |
| N4-583 | [経験](entries/1251/1251270-keiken.org) | けいけん | keiken | 1251270 | learner | draft | **new** | Editorial review |
| N4-584 | [怪我](entries/1200/1200220-kega.org) | けが | kega | 1200220 | learner | draft | **new** | Editorial review |
| N4-585 | [軒](entries/2078/2078590-ken.org) | けん | ken | 2078590 | learner | draft | **new** | Editorial review |
| N4-586 | [高等学校](entries/1283/1283860-koutougakkou.org) | こうとうがっこう | koutougakkou | 1283860 | learner | draft | **new** | Editorial review |
| N4-587 | [事](entries/1313/1313580-koto.org) | こと | koto | 1313580 | learner | draft | **new** | Editorial review |
| N4-588 | [御座います](entries/1612/1612690-gozaimasu.org) | ございます | gozaimasu | 1612690 | learner | draft | **new** | Editorial review |
| N4-589 | [様](entries/1545/1545790-sama.org) | さま | sama | 1545790 | learner | draft | **new** | Editorial review |
| N4-590 | [叱る](entries/1319/1319580-shikaru.org) | しかる | shikaru | 1319580 | learner | draft | **new** | Editorial review |
| N4-591 | [式](entries/1319/1319060-shiki.org) | しき | shiki | 1319060 | learner | draft | **new** | Editorial review |
| N4-592 | [支度](entries/1310/1310260-shitaku.org) | したく | shitaku | 1310260 | learner | draft | **new** | Editorial review |
| N4-593 | [失礼](entries/1320/1320230-shitsurei.org) | しつれい | shitsurei | 1320230 | learner | draft | **new** | Editorial review |
| N4-594 | [仕舞う](entries/1305/1305380-shimau.org) | しまう | shimau | 1305380 | learner | draft | **new** | Editorial review |
| N4-595 | [出席](entries/1339/1339460-shusseki.org) | しゅっせき | shusseki | 1339460 | learner | draft | **new** | Editorial review |
| N4-596 | [出発](entries/1340/1340000-shuppatsu.org) | しゅっぱつ | shuppatsu | 1340000 | learner | draft | **new** | Editorial review |
| N4-597 | [正月](entries/1377/1377030-shougatsu.org) | しょうがつ | shougatsu | 1377030 | learner | draft | **new** | Editorial review |
| N4-598 | [招待](entries/1349/1349610-shoutai.org) | しょうたい | shoutai | 1349610 | learner | draft | **new** | Editorial review |
| N4-599 | [承知](entries/1349/1349480-shouchi.org) | しょうち | shouchi | 1349480 | learner | draft | **new** | Editorial review |
| N4-600 | [食事](entries/1358/1358490-shokuji.org) | しょくじ | shokuji | 1358490 | learner | draft | **new** | Editorial review |
| N4-601 | [心配](entries/1360/1360930-shinpai.org) | しんぱい | shinpai | 1360930 | learner | draft | **new** | Editorial review |
| N4-602 | [邪魔](entries/1323/1323500-jama.org) | じゃま | jama | 1323500 | learner | draft | **new** | Editorial review |
| N4-603 | [準備](entries/1341/1341670-junbi.org) | じゅんび | junbi | 1341670 | learner | draft | **new** | Editorial review |
| N4-604 | [空く](entries/1586/1586265-suku.org) | すく | suku | 1586265 | learner | draft | **new** | Editorial review |
| N4-605 | [素晴らしい](entries/1397/1397300-subarashii.org) | すばらしい | subarashii | 1397300 | learner | draft | **new** | Editorial review |
| N4-606 | [掏摸](entries/1567/1567450-suri.org) | すり | suri | 1567450 | learner | draft | **new** | Editorial review |
| N4-607 | [随分](entries/1372/1372800-zuibun.org) | ずいぶん | zuibun | 1372800 | learner | draft | **new** | Editorial review |
| N4-608 | [製](entries/1380/1380580-sei.org) | せい | sei | 1380580 | learner | draft | **new** | Editorial review |
| N4-609 | [世話](entries/1374/1374300-sewa.org) | せわ | sewa | 1374300 | learner | draft | **new** | Editorial review |
| N4-610 | [専門](entries/1389/1389880-senmon.org) | せんもん | senmon | 1389880 | learner | draft | **new** | Editorial review |
| N4-611 | [是非](entries/1374/1374530-zehi.org) | ぜひ | zehi | 1374530 | learner | draft | **new** | Editorial review |
| N4-612 | [全然](entries/1395/1395620-zenzen.org) | ぜんぜん | zenzen | 1395620 | learner | draft | **new** | Editorial review |
| N4-613 | [そう](entries/1006/1006610-sou.org) | そう | sou | 1006610 | learner | draft | **new** | Editorial review |
| N4-614 | [相談](entries/1401/1401210-soudan.org) | そうだん | soudan | 1401210 | learner | draft | **new** | Editorial review |
| N4-615 | [代](entries/1982/1982860-dai.org) | だい | dai | 1982860 | learner | draft | **new** | Editorial review |
| N4-616 | [駄目](entries/1409/1409110-dame.org) | だめ | dame | 1409110 | learner | draft | **new** | Editorial review |
| N4-617 | [月](entries/1255/1255430-tsuki.org) | つき | tsuki | 1255430 | learner | draft | **new** | Editorial review |
| N4-618 | [点く](entries/1441/1441400-tsuku.org) | つく | tsuku | 1441400 | learner | draft | **new** | Editorial review |
| N4-619 | [連れる](entries/1559/1559290-tsureru.org) | つれる | tsureru | 1559290 | learner | draft | **new** | Editorial review |
| N4-620 | [出来るだけ](entries/1340/1340460-dekirudake.org) | できるだけ | dekirudake | 1340460 | learner | draft | **new** | Editorial review |
| N4-621 | [通り](entries/1432/1432920-toori.org) | とおり | toori | 1432920 | learner | draft | **new** | Editorial review |
| N4-622 | [中々](entries/1599/1599420-nakanaka.org) | なかなか | nakanaka | 1599420 | learner | draft | **new** | Editorial review |
| N4-623 | [匂い](entries/1599/1599760-nioi.org) | におい | nioi | 1599760 | learner | draft | **new** | Editorial review |
| N4-624 | [二階建て](entries/1599/1599800-nikaidate.org) | にかいだて | nikaidate | 1599800 | learner | draft | **new** | Editorial review |
| N4-625 | [熱心](entries/1467/1467910-nesshin.org) | ねっしん | nesshin | 1467910 | learner | draft | **new** | Editorial review |
| N4-626 | [喉](entries/1600/1600280-nodo.org) | のど | nodo | 1600280 | learner | draft | **new** | Editorial review |
| N4-627 | [許り](entries/1010/1010240-bakari.org) | ばかり | bakari | 1010240 | learner | draft | **new** | Editorial review |
| N4-628 | [引き出す](entries/1601/1601660-hikidasu.org) | ひきだす | hikidasu | 1601660 | learner | draft | **new** | Editorial review |
| N4-629 | [髭](entries/1601/1601810-hige.org) | ひげ | hige | 1601810 | learner | draft | **new** | Editorial review |
| N4-630 | [吃驚](entries/1226/1226360-bikkuri.org) | びっくり | bikkuri | 1226360 | learner | draft | **new** | Editorial review |
| N4-631 | [降り出す](entries/1282/1282770-furidasu.org) | ふりだす | furidasu | 1282770 | learner | draft | **new** | Editorial review |
| N4-632 | [葡萄](entries/1499/1499230-budou.org) | ぶどう | budou | 1499230 | learner | draft | **new** | Editorial review |
| N4-633 | [放送](entries/1516/1516750-housou.org) | ほうそう | housou | 1516750 | learner | draft | **new** | Editorial review |
| N4-634 | [程](entries/1436/1436510-hodo.org) | ほど | hodo | 1436510 | learner | draft | **new** | Editorial review |
| N4-635 | [真面目](entries/1364/1364360-majime.org) | まじめ | majime | 1364360 | learner | draft | **new** | Editorial review |
| N4-636 | [先ず](entries/1387/1387240-mazu.org) | まず | mazu | 1387240 | learner | draft | **new** | Editorial review |
| N4-637 | [儘](entries/1585/1585410-mama.org) | まま | mama | 1585410 | learner | draft | **new** | Editorial review |
| N4-638 | [真ん中](entries/1604/1604350-mannaka.org) | まんなか | mannaka | 1604350 | learner | draft | **new** | Editorial review |
| N4-640 | [勿論](entries/1535/1535780-mochiron.org) | もちろん | mochiron | 1535780 | learner | draft | **new** | Editorial review |
| N4-641 | [最も](entries/1293/1293700-mottomo.org) | もっとも | mottomo | 1293700 | learner | draft | **new** | Editorial review |
| N4-642 | [貰う](entries/1535/1535910-morau.org) | もらう | morau | 1535910 | learner | draft | **new** | Editorial review |
| N4-643 | [輸出](entries/1538/1538820-yushutsu.org) | ゆしゅつ | yushutsu | 1538820 | learner | draft | **new** | Editorial review |
| N4-644 | [輸入](entries/1538/1538870-yunyuu.org) | ゆにゅう | yunyuu | 1538870 | learner | draft | **new** | Editorial review |
| N4-645 | [様](entries/1605/1605840-you.org) | よう | you | 1605840 | learner | draft | **new** | Editorial review |
| N4-646 | [宜しい](entries/1224/1224880-yoroshii.org) | よろしい | yoroshii | 1224880 | learner | draft | **new** | Editorial review |
| N4-647 | [オーバー](entries/1032/1032390-oobaa.org) | オーバー | oobaa | 1032390 | learner | draft | **new** | Editorial review |
| N4-648 | [塵](entries/1369/1369900-gomi.org) | ごみ | gomi | 1369900 | learner | draft | **new** | Editorial review |
| N4-649 | [スーパー](entries/1066/1066710-suupaa.org) | スーパー | suupaa | 1066710 | learner | draft | **new** | Editorial review |
| N4-650 | [ハンバーグ](entries/1096/1096870-hanbaagu.org) | ハンバーグ | hanbaagu | 1096870 | learner | draft | **new** | Editorial review |
| N4-651 | [パパ](entries/1102/1102140-papa.org) | パパ | papa | 1102140 | learner | draft | **new** | Editorial review |
| N4-652 | [あっ](entries/2394/2394370-a.org) | あっ | a | 2394370 | learner | draft | **new** | Editorial review |
| N4-653 | [窺う](entries/1172/1172230-ukagau.org) | うかがう | ukagau | 1172230 | learner | draft | **new** | Editorial review |
| N4-654 | [お金持ち](entries/2429/2429350-okanemochi.org) | おかねもち | okanemochi | 2429350 | learner | draft | **new** | Editorial review |
| N4-655 | [沖](entries/1182/1182500-oki.org) | おき | oki | 1182500 | learner | draft | **new** | Editorial review |
| N4-656 | [唖](entries/1149/1149990-oshi.org) | おし | oshi | 1149990 | learner | draft | **new** | Editorial review |
| N4-657 | [織る](entries/1357/1357420-oru.org) | おる | oru | 1357420 | learner | draft | **new** | Editorial review |
| N4-659 | [格好](entries/1590/1590480-kakkou.org) | かっこう | kakkou | 1590480 | learner | draft | **new** | Editorial review |
| N4-660 | [けど](entries/1004/1004200-kedo.org) | けど | kedo | 1004200 | learner | draft | **new** | Editorial review |
| N4-661 | [けれど](entries/2853/2853889-keredo.org) | けれど | keredo | 2853889 | learner | draft | **new** | Editorial review |
| N4-662 | [御](entries/1270/1270190-go.org) | ご | go | 1270190 | learner | draft | **new** | Editorial review |
| N4-663 | [修理](entries/1332/1332400-shuuri.org) | しゅうり | shuuri | 1332400 | learner | draft | **new** | Editorial review |
| N4-665 | [建て](entries/2609/2609780-date.org) | だて | date | 2609780 | learner | draft | **new** | Editorial review |
| N4-666 | [町](entries/2853/2853569-chou.org) | ちょう | chou | 2853569 | learner | draft | **new** | Editorial review |
| N4-667 | [付く](entries/1495/1495740-tsuku.org) | つく | tsuku | 1495740 | learner | draft | **new** | Editorial review |
| N4-668 | [直る](entries/2846/2846390-naoru.org) | なおる | naoru | 2846390 | learner | draft | **new** | Editorial review |
| N4-669 | [憎い](entries/1403/1403390-nikui.org) | にくい | nikui | 1403390 | learner | draft | **new** | Editorial review |
| N4-670 | [卑下](entries/1482/1482700-hige.org) | ひげ | hige | 1482700 | learner | draft | **new** | Editorial review |
| N4-671 | [武道](entries/1498/1498880-budou.org) | ぶどう | budou | 1498880 | learner | draft | **new** | Editorial review |
| N4-672 | [真中](entries/2838/2838012-manaka.org) | まなか | manaka | 2838012 | learner | draft | **new** | Editorial review |
| N4-675 | [矢張り](entries/2772/2772770-yahari.org) | やはり | yahari | 2772770 | learner | draft | **new** | Editorial review |
| N4-676 | [ハンドバッグ](entries/1096/1096770-handobaggu.org) | ハンドバッグ | handobaggu | 1096770 | learner | draft | **new** | Editorial review |
| N4-677 | [嗚呼](entries/1565/1565440-aa.org) | ああ | aa | 1565440 | learner | draft | **new** | Editorial review |
| N4-678 | [ああ](entries/2085/2085080-aa.org) | ああ | aa | 2085080 | learner | draft | **new** | Editorial review |
| N4-679 | [字](entries/1315/1315120-aza.org) | あざ | aza | 1315120 | learner | draft | **new** | Editorial review |
| N4-681 | [幾らでも](entries/1858/1858120-ikurademo.org) | いくらでも | ikurademo | 1858120 | learner | draft | **new** | Editorial review |
| N4-682 | [行けません](entries/1612/1612750-ikemasen.org) | いけません | ikemasen | 1612750 | learner | draft | **new** | Editorial review |
| N4-683 | [市](entries/1308/1308080-ichi.org) | いち | ichi | 1308080 | learner | draft | **new** | Editorial review |
| N4-684 | [行ってまいります](entries/2149/2149180-ittemairimasu.org) | いってまいります | ittemairimasu | 2149180 | learner | draft | **new** | Editorial review |
| N4-685 | [行ってらっしゃい](entries/2088/2088750-itterasshai.org) | いってらっしゃい | itterasshai | 2088750 | learner | draft | **new** | Editorial review |
| N4-686 | [一敗](entries/1165/1165660-ippai.org) | いっぱい | ippai | 1165660 | learner | draft | **new** | Editorial review |
| N4-687 | [お帰りなさい](entries/1001/1001740-okaerinasai.org) | おかえりなさい | okaerinasai | 1001740 | learner | draft | **new** | Editorial review |
| N4-688 | [お陰様で](entries/1270/1270220-okagesamade.org) | おかげさまで | okagesamade | 1270220 | learner | draft | **new** | Editorial review |
| N4-689 | [お大事に](entries/1002/1002390-odaijini.org) | おだいじに | odaijini | 1002390 | learner | draft | **new** | Editorial review |
| N4-690 | [お待たせしました](entries/2149/2149640-omataseshimashita.org) | おまたせしました | omataseshimashita | 2149640 | learner | draft | **new** | Editorial review |
| N4-691 | [おめでとう御座います](entries/1001/1001540-omedetougozaimasu.org) | おめでとうございます | omedetougozaimasu | 1001540 | learner | draft | **new** | Editorial review |
| N4-692 | [居る](entries/1577/1577985-oru.org) | おる | oru | 1577985 | learner | draft | **new** | Editorial review |
| N4-693 | [各校](entries/1204/1204960-kakukou.org) | かくこう | kakukou | 1204960 | learner | draft | **new** | Editorial review |
| N4-695 | [畏まりました](entries/1002/1002790-kashikomarimashita.org) | かしこまりました | kashikomarimashita | 1002790 | learner | draft | **new** | Editorial review |
| N4-696 | [難い](entries/1582/1582640-katai.org) | かたい | katai | 1582640 | learner | draft | **new** | Editorial review |
| N4-697 | [金持ち](entries/1242/1242970-kanemochi.org) | かねもち | kanemochi | 1242970 | learner | draft | **new** | Editorial review |
| N4-698 | [汚れる](entries/1179/1179000-kegareru.org) | けがれる | kegareru | 1179000 | learner | draft | **new** | Editorial review |
| N4-699 | [死](entries/1310/1310720-shi.org) | し | shi | 1310720 | learner | draft | **new** | Editorial review |
| N4-700 | [し](entries/2086/2086640-shi.org) | し | shi | 2086640 | learner | draft | **new** | Editorial review |
| N4-701 | [僕](entries/1521/1521390-shimobe.org) | しもべ | shimobe | 1521390 | learner | draft | **new** | Editorial review |
| N4-702 | [１０分](entries/1335/1335070-jippun.org) | じっぷん | jippun | 1335070 | learner | draft | **new** | Editorial review |
| N4-703 | [中](entries/2083/2083570-juu.org) | じゅう | juu | 2083570 | learner | draft | **new** | Editorial review |
| N4-704 | [嬢](entries/1355/1355930-jou.org) | じょう | jou | 1355930 | learner | draft | **new** | Editorial review |
| N4-705 | [畳](entries/1356/1356740-jou.org) | じょう | jou | 1356740 | learner | draft | **new** | Editorial review |
| N4-706 | [ずっと](entries/1006/1006380-zutto.org) | ずっと | zutto | 1006380 | learner | draft | **new** | Editorial review |
| N4-707 | [然う](entries/2137/2137720-sou.org) | そう | sou | 2137720 | learner | draft | **new** | Editorial review |
| N4-708 | [只今](entries/1538/1538960-tadaima.org) | ただいま | tadaima | 1538960 | learner | draft | **new** | Editorial review |
| N4-709 | [点](entries/1007/1007860-chobo.org) | ちょぼ | chobo | 1007860 | learner | draft | **new** | Editorial review |
| N4-710 | [端](entries/2746/2746070-tsuma.org) | つま | tsuma | 2746070 | learner | draft | **new** | Editorial review |
| N4-711 | [店](entries/1582/1582125-ten.org) | てん | ten | 1582125 | learner | draft | **new** | Editorial review |
| N4-712 | [治す](entries/2856/2856318-naosu.org) | なおす | naosu | 2856318 | learner | draft | **new** | Editorial review |
| N4-713 | [杯](entries/2019/2019640-hai.org) | はい | hai | 2019640 | learner | draft | **new** | Editorial review |
| N4-714 | [端](entries/1581/1581610-hashi.org) | はし | hashi | 1581610 | learner | draft | **new** | Editorial review |
| N4-716 | [都](entries/1444/1444950-miyako.org) | みやこ | miyako | 1444950 | learner | draft | **new** | Editorial review |
| N4-717 | [惨い](entries/1303/1303270-mugoi.org) | むごい | mugoi | 1303270 | learner | draft | **new** | Editorial review |
| N4-718 | [巡る](entries/1342/1342050-meguru.org) | めぐる | meguru | 1342050 | learner | draft | **new** | Editorial review |
| N4-719 | [や](entries/2028/2028960-ya.org) | や | ya | 2028960 | learner | draft | **new** | Editorial review |
| N4-720 | [易い](entries/1156/1156990-yasui.org) | やすい | yasui | 1156990 | learner | draft | **new** | Editorial review |
| N4-721 | [矢っ張り](entries/1012/1012810-yappari.org) | やっぱり | yappari | 1012810 | learner | draft | **new** | Editorial review |
| N4-722 | [陽](entries/1605/1605845-you.org) | よう | you | 1605845 | learner | draft | **new** | Editorial review |
| N4-723 | [クラブ](entries/1044/1044310-kurabu.org) | クラブ | kurabu | 1044310 | learner | draft | **new** | Editorial review |
| N3-1 | [愛](entries/1150/1150410-ai.org) | あい | ai | 1150410 | learner | draft | **new** | Editorial review |
| N3-2 | [愛情](entries/1150/1150860-aijou.org) | あいじょう | aijou | 1150860 | learner | draft | **new** | Editorial review |
| N3-3 | [アイスクリーム](entries/1013/1013980-aisukuriimu.org) | アイスクリーム | aisukuriimu | 1013980 | learner | draft | **new** | Editorial review |
| N3-4 | [愛する](entries/1150/1150450-aisuru.org) | あいする | aisuru | 1150450 | learner | draft | **new** | Editorial review |
| N3-5 | [合図](entries/1284/1284930-aizu.org) | あいず | aizu | 1284930 | learner | draft | **new** | Editorial review |
| N3-6 | [相手](entries/1401/1401000-aite.org) | あいて | aite | 1401000 | learner | draft | **new** | Editorial review |
| N3-7 | [生憎](entries/1379/1379210-ainiku.org) | あいにく | ainiku | 1379210 | learner | draft | **new** | Editorial review |
| N3-8 | [アイロン](entries/1014/1014590-airon.org) | アイロン | airon | 1014590 | learner | draft | **new** | Editorial review |
| N3-9 | [ＯＵＴ](entries/1014/1014680-auto.org) | アウト | auto | 1014680 | learner | draft | **new** | Editorial review |
| N3-10 | [明かり](entries/1586/1586210-akari.org) | あかり | akari | 1586210 | learner | draft | **new** | Editorial review |
| N3-11 | [空き](entries/1609/1609010-aki.org) | あき | aki | 1609010 | learner | draft | **new** | Editorial review |
| N3-12 | [明らか](entries/1532/1532310-akiraka.org) | あきらか | akiraka | 1532310 | learner | draft | **new** | Editorial review |
| N3-13 | [諦める](entries/1436/1436730-akirameru.org) | あきらめる | akirameru | 1436730 | learner | draft | **new** | Editorial review |
| N3-14 | [飽きる](entries/1586/1586250-akiru.org) | あきる | akiru | 1586250 | learner | draft | **new** | Editorial review |
| N3-15 | [握手](entries/1152/1152730-akushu.org) | あくしゅ | akushu | 1152730 | learner | draft | **new** | Editorial review |
| N3-16 | [悪魔](entries/1152/1152510-akuma.org) | あくま | akuma | 1152510 | learner | draft | **new** | Editorial review |
| N3-17 | [預ける](entries/1544/1544990-azukeru.org) | あずける | azukeru | 1544990 | learner | draft | **new** | Editorial review |
| N3-18 | [汗](entries/1213/1213060-ase.org) | あせ | ase | 1213060 | learner | draft | **new** | Editorial review |
| N3-19 | [値](entries/1581/1581630-atai.org) | あたい | atai | 1581630 | learner | draft | **new** | Editorial review |
| N3-20 | [与える](entries/1544/1544730-ataeru.org) | あたえる | ataeru | 1544730 | learner | draft | **new** | Editorial review |
| N3-21 | [辺り](entries/1512/1512080-atari.org) | あたり | atari | 1512080 | learner | draft | **new** | Editorial review |
| N3-22 | [当たる](entries/1448/1448810-ataru.org) | あたる | ataru | 1448810 | learner | draft | **new** | Editorial review |
| N3-23 | [彼方此方](entries/1612/1612620-achikochi.org) | あちこち | achikochi | 1612620 | learner | draft | **new** | Editorial review |
| N3-24 | [扱う](entries/1153/1153440-atsukau.org) | あつかう | atsukau | 1153440 | learner | draft | **new** | Editorial review |
| N3-25 | [集まり](entries/1609/1609050-atsumari.org) | あつまり | atsumari | 1609050 | learner | draft | **new** | Editorial review |
| N3-26 | [当てる](entries/1448/1448860-ateru.org) | あてる | ateru | 1448860 | learner | draft | **new** | Editorial review |
| N3-27 | [跡](entries/1383/1383680-ato.org) | あと | ato | 1383680 | learner | draft | **new** | Editorial review |
| N3-28 | [穴](entries/1254/1254480-ana.org) | あな | ana | 1254480 | learner | draft | **new** | Editorial review |
| N3-29 | [油](entries/1538/1538590-abura.org) | あぶら | abura | 1538590 | learner | draft | **new** | Editorial review |
| N3-30 | [誤り](entries/1271/1271290-ayamari.org) | あやまり | ayamari | 1271290 | learner | draft | **new** | Editorial review |
| N3-31 | [粗い](entries/1396/1396910-arai.org) | あらい | arai | 1396910 | learner | draft | **new** | Editorial review |
| N3-32 | [嵐](entries/1549/1549340-arashi.org) | あらし | arashi | 1549340 | learner | draft | **new** | Editorial review |
| N3-33 | [新た](entries/1361/1361510-arata.org) | あらた | arata | 1361510 | learner | draft | **new** | Editorial review |
| N3-34 | [凡ゆる](entries/1586/1586780-arayuru.org) | あらゆる | arayuru | 1586780 | learner | draft | **new** | Editorial review |
| N3-35 | [表わす](entries/1263/1263490-arawasu.org) | あらわす | arawasu | 1263490 | learner | draft | **new** | Editorial review |
| N3-36 | [表す](entries/1263/1263490-arawasu.org) | あらわす | arawasu | 1263490 | learner | draft | **new** | Editorial review |
| N3-37 | [現れ](entries/1610/1610550-araware.org) | あらわれ | araware | 1610550 | learner | draft | **new** | Editorial review |
| N3-38 | [現れる](entries/1263/1263510-arawareru.org) | あらわれる | arawareru | 1263510 | learner | draft | **new** | Editorial review |
| N3-39 | [有難う](entries/1586/1586820-arigatou.org) | ありがとう | arigatou | 1586820 | learner | draft | **new** | Editorial review |
| N3-40 | [或る](entries/1586/1586840-aru.org) | ある | aru | 1586840 | learner | draft | **new** | Editorial review |
| N3-41 | [或いは](entries/1586/1586850-aruiwa.org) | あるいは | aruiwa | 1586850 | learner | draft | **new** | Editorial review |
| N3-42 | [アルバム](entries/1019/1019450-arubamu.org) | アルバム | arubamu | 1019450 | learner | draft | **new** | Editorial review |
| N3-43 | [泡](entries/1517/1517510-awa.org) | あわ | awa | 1517510 | learner | draft | **new** | Editorial review |
| N3-44 | [合わせる](entries/1284/1284480-awaseru.org) | あわせる | awaseru | 1284480 | learner | draft | **new** | Editorial review |
| N3-45 | [哀れ](entries/1150/1150110-aware.org) | あわれ | aware | 1150110 | learner | draft | **new** | Editorial review |
| N3-46 | [案](entries/1154/1154770-an.org) | あん | an | 1154770 | learner | draft | **new** | Editorial review |
| N3-47 | [暗記](entries/1586/1586910-anki.org) | あんき | anki | 1586910 | learner | draft | **new** | Editorial review |
| N3-48 | [安定](entries/1154/1154120-antei.org) | あんてい | antei | 1154120 | learner | draft | **new** | Editorial review |
| N3-49 | [案内](entries/1154/1154860-annai.org) | あんない | annai | 1154860 | learner | draft | **new** | Editorial review |
| N3-50 | [あんなに](entries/1981/1981450-annani.org) | あんなに | annani | 1981450 | learner | draft | **new** | Editorial review |
| N3-51 | [胃](entries/1158/1158500-i.org) | い | i | 1158500 | learner | draft | **new** | Editorial review |
| N3-52 | [委員](entries/1156/1156100-iin.org) | いいん | iin | 1156100 | learner | draft | **new** | Editorial review |
| N3-53 | [意外](entries/1156/1156410-igai.org) | いがい | igai | 1156410 | learner | draft | **new** | Editorial review |
| N3-54 | [息](entries/1404/1404320-iki.org) | いき | iki | 1404320 | learner | draft | **new** | Editorial review |
| N3-55 | [行き](entries/1578/1578790-iki.org) | いき | iki | 1578790 | learner | draft | **new** | Editorial review |
| N3-56 | [勢い](entries/1375/1375040-ikioi.org) | いきおい | ikioi | 1375040 | learner | draft | **new** | Editorial review |
| N3-57 | [生き物](entries/1378/1378590-ikimono.org) | いきもの | ikimono | 1378590 | learner | draft | **new** | Editorial review |
| N3-58 | [行けない](entries/1000/1000730-ikenai.org) | いけない | ikenai | 1000730 | learner | draft | **new** | Editorial review |
| N3-59 | [医師](entries/1159/1159930-ishi.org) | いし | ishi | 1159930 | learner | draft | **new** | Editorial review |
| N3-60 | [意志](entries/1156/1156560-ishi.org) | いし | ishi | 1156560 | learner | draft | **new** | Editorial review |
| N3-61 | [意思](entries/1156/1156610-ishi.org) | いし | ishi | 1156610 | learner | draft | **new** | Editorial review |
| N3-62 | [意識](entries/1156/1156640-ishiki.org) | いしき | ishiki | 1156640 | learner | draft | **new** | Editorial review |
| N3-63 | [維持](entries/1158/1158450-iji.org) | いじ | iji | 1158450 | learner | draft | **new** | Editorial review |
| N3-64 | [異常](entries/1157/1157760-ijou.org) | いじょう | ijou | 1157760 | learner | draft | **new** | Editorial review |
| N3-65 | [泉](entries/1390/1390780-izumi.org) | いずみ | izumi | 1390780 | learner | draft | **new** | Editorial review |
| N3-66 | [何れ](entries/1566/1566210-izure.org) | いずれ | izure | 1566210 | learner | draft | **new** | Editorial review |
| N3-67 | [以前](entries/1155/1155150-izen.org) | いぜん | izen | 1155150 | learner | draft | **new** | Editorial review |
| N3-68 | [板](entries/1481/1481350-ita.org) | いた | ita | 1481350 | learner | draft | **new** | Editorial review |
| N3-69 | [悪戯](entries/1151/1151580-itazura.org) | いたずら | itazura | 1151580 | learner | draft | **new** | Editorial review |
| N3-70 | [頂きます](entries/1410/1410800-itadakimasu.org) | いただきます | itadakimasu | 1410800 | learner | draft | **new** | Editorial review |
| N3-71 | [頂く](entries/1587/1587290-itadaku.org) | いただく | itadaku | 1587290 | learner | draft | **new** | Editorial review |
| N3-72 | [痛み](entries/1587/1587300-itami.org) | いたみ | itami | 1587300 | learner | draft | **new** | Editorial review |
| N3-73 | [至る](entries/1311/1311870-itaru.org) | いたる | itaru | 1311870 | learner | draft | **new** | Editorial review |
| N3-74 | [偉大](entries/1155/1155920-idai.org) | いだい | idai | 1155920 | learner | draft | **new** | Editorial review |
| N3-75 | [抱く](entries/1584/1584090-idaku.org) | いだく | idaku | 1584090 | learner | draft | **new** | Editorial review |
| N3-76 | [位置](entries/1587/1587310-ichi.org) | いち | ichi | 1587310 | learner | draft | **new** | Editorial review |
| N3-77 | [市](entries/1308/1308080-ichi.org) | いち | ichi | 1308080 | learner | draft | **new** | Editorial review |
| N3-78 | [一時](entries/1576/1576100-ichiji.org) | いちじ | ichiji | 1576100 | learner | draft | **new** | Editorial review |
| N3-79 | [一度に](entries/1609/1609210-ichidoni.org) | いちどに | ichidoni | 1609210 | learner | draft | **new** | Editorial review |
| N3-80 | [市場](entries/1308/1308300-ichiba.org) | いちば | ichiba | 1308300 | learner | draft | **new** | Editorial review |
| N3-81 | [一家](entries/1575/1575940-ikka.org) | いっか | ikka | 1575940 | learner | draft | **new** | Editorial review |
| N3-82 | [一種](entries/1163/1163170-isshu.org) | いっしゅ | isshu | 1163170 | learner | draft | **new** | Editorial review |
| N3-83 | [一瞬](entries/1163/1163340-isshun.org) | いっしゅん | isshun | 1163340 | learner | draft | **new** | Editorial review |
| N3-84 | [一生](entries/1576/1576200-isshou.org) | いっしょう | isshou | 1576200 | learner | draft | **new** | Editorial review |
| N3-85 | [一層](entries/1164/1164340-issou.org) | いっそう | issou | 1164340 | learner | draft | **new** | Editorial review |
| N3-86 | [一体](entries/1164/1164510-ittai.org) | いったい | ittai | 1164510 | learner | draft | **new** | Editorial review |
| N3-87 | [一致](entries/1164/1164740-itchi.org) | いっち | itchi | 1164740 | learner | draft | **new** | Editorial review |
| N3-88 | [一般](entries/1165/1165790-ippan.org) | いっぱん | ippan | 1165790 | learner | draft | **new** | Editorial review |
| N3-89 | [一方](entries/1166/1166510-ippou.org) | いっぽう | ippou | 1166510 | learner | draft | **new** | Editorial review |
| N3-90 | [何時か](entries/1188/1188790-itsuka.org) | いつか | itsuka | 1188790 | learner | draft | **new** | Editorial review |
| N3-91 | [何時でも](entries/1577/1577130-itsudemo.org) | いつでも | itsudemo | 1577130 | learner | draft | **new** | Editorial review |
| N3-92 | [何時までも](entries/1188/1188880-itsumademo.org) | いつまでも | itsumademo | 1188880 | learner | draft | **new** | Editorial review |
| N3-93 | [従兄弟](entries/1335/1335290-itoko.org) | いとこ | itoko | 1335290 | learner | draft | **new** | Editorial review |
| N3-94 | [移動](entries/1158/1158400-idou.org) | いどう | idou | 1158400 | learner | draft | **new** | Editorial review |
| N3-95 | [稲](entries/1167/1167820-ine.org) | いね | ine | 1167820 | learner | draft | **new** | Editorial review |
| N3-96 | [居眠り](entries/1231/1231890-inemuri.org) | いねむり | inemuri | 1231890 | learner | draft | **new** | Editorial review |
| N3-97 | [命](entries/1531/1531940-inochi.org) | いのち | inochi | 1531940 | learner | draft | **new** | Editorial review |
| N3-98 | [違反](entries/1158/1158950-ihan.org) | いはん | ihan | 1158950 | learner | draft | **new** | Editorial review |
| N3-99 | [衣服](entries/1158/1158810-ifuku.org) | いふく | ifuku | 1158810 | learner | draft | **new** | Editorial review |
| N3-100 | [居間](entries/1231/1231720-ima.org) | いま | ima | 1231720 | learner | draft | **new** | Editorial review |
| N3-101 | [今に](entries/1288/1288940-imani.org) | いまに | imani | 1288940 | learner | draft | **new** | Editorial review |
| N3-102 | [今にも](entries/1288/1288950-imanimo.org) | いまにも | imanimo | 1288950 | learner | draft | **new** | Editorial review |
| N3-103 | [以来](entries/1155/1155210-irai.org) | いらい | irai | 1155210 | learner | draft | **new** | Editorial review |
| N3-104 | [依頼](entries/1155/1155710-irai.org) | いらい | irai | 1155710 | learner | draft | **new** | Editorial review |
| N3-105 | [苛々](entries/1587/1587700-iraira.org) | いらいら | iraira | 1587700 | learner | draft | **new** | Editorial review |
| N3-106 | [いらっしゃい](entries/1000/1000920-irasshai.org) | いらっしゃい | irasshai | 1000920 | learner | draft | **new** | Editorial review |
| N3-107 | [医療](entries/1160/1160140-iryou.org) | いりょう | iryou | 1160140 | learner | draft | **new** | Editorial review |
| N3-108 | [岩](entries/1217/1217270-iwa.org) | いわ | iwa | 1217270 | learner | draft | **new** | Editorial review |
| N3-109 | [祝い](entries/1337/1337370-iwai.org) | いわい | iwai | 1337370 | learner | draft | **new** | Editorial review |
| N3-110 | [祝う](entries/1337/1337390-iwau.org) | いわう | iwau | 1337390 | learner | draft | **new** | Editorial review |
| N3-111 | [言わば](entries/1264/1264380-iwaba.org) | いわば | iwaba | 1264380 | learner | draft | **new** | Editorial review |
| N3-112 | [所謂](entries/1343/1343150-iwayuru.org) | いわゆる | iwayuru | 1343150 | learner | draft | **new** | Editorial review |
| N3-113 | [インク](entries/1022/1022210-inku.org) | インク | inku | 1022210 | learner | draft | **new** | Editorial review |
| N3-114 | [印刷](entries/1168/1168190-insatsu.org) | いんさつ | insatsu | 1168190 | learner | draft | **new** | Editorial review |
| N3-115 | [印象](entries/1168/1168390-inshou.org) | いんしょう | inshou | 1168390 | learner | draft | **new** | Editorial review |
| N3-116 | [引退](entries/1169/1169610-intai.org) | いんたい | intai | 1169610 | learner | draft | **new** | Editorial review |
| N3-117 | [引用](entries/1169/1169660-inyou.org) | いんよう | inyou | 1169660 | learner | draft | **new** | Editorial review |
| N3-118 | [ウイスキー](entries/1025/1025140-uisukii.org) | ウイスキー | uisukii | 1025140 | learner | draft | **new** | Editorial review |
| N3-119 | [伺う](entries/1305/1305700-ukagau.org) | うかがう | ukagau | 1305700 | learner | draft | **new** | Editorial review |
| N3-120 | [嗽](entries/1577/1577660-ugai.org) | うがい | ugai | 1577660 | learner | draft | **new** | Editorial review |
| N3-121 | [受け取る](entries/1329/1329650-uketoru.org) | うけとる | uketoru | 1329650 | learner | draft | **new** | Editorial review |
| N3-122 | [動かす](entries/1451/1451170-ugokasu.org) | うごかす | ugokasu | 1451170 | learner | draft | **new** | Editorial review |
| N3-123 | [兎](entries/1443/1443970-usagi.org) | うさぎ | usagi | 1443970 | learner | draft | **new** | Editorial review |
| N3-124 | [牛](entries/1231/1231490-ushi.org) | うし | ushi | 1231490 | learner | draft | **new** | Editorial review |
| N3-125 | [失う](entries/1319/1319750-ushinau.org) | うしなう | ushinau | 1319750 | learner | draft | **new** | Editorial review |
| N3-126 | [嘘](entries/1172/1172400-uso.org) | うそ | uso | 1172400 | learner | draft | **new** | Editorial review |
| N3-127 | [疑う](entries/1225/1225510-utagau.org) | うたがう | utagau | 1225510 | learner | draft | **new** | Editorial review |
| N3-128 | [宇宙](entries/1171/1171300-uchuu.org) | うちゅう | uchuu | 1171300 | learner | draft | **new** | Editorial review |
| N3-129 | [訴える](entries/1397/1397720-uttaeru.org) | うったえる | uttaeru | 1397720 | learner | draft | **new** | Editorial review |
| N3-130 | [撃つ](entries/1253/1253570-utsu.org) | うつ | utsu | 1253570 | learner | draft | **new** | Editorial review |
| N3-131 | [移す](entries/1158/1158160-utsusu.org) | うつす | utsusu | 1158160 | learner | draft | **new** | Editorial review |
| N3-132 | [唸る](entries/1565/1565300-unaru.org) | うなる | unaru | 1565300 | learner | draft | **new** | Editorial review |
| N3-133 | [奪う](entries/1416/1416340-ubau.org) | うばう | ubau | 1416340 | learner | draft | **new** | Editorial review |
| N3-134 | [馬](entries/1471/1471560-uma.org) | うま | uma | 1471560 | learner | draft | **new** | Editorial review |
| N3-135 | [上手い](entries/1310/1310460-umai.org) | うまい | umai | 1310460 | learner | draft | **new** | Editorial review |
| N3-136 | [生まれ](entries/1609/1609350-umare.org) | うまれ | umare | 1609350 | learner | draft | **new** | Editorial review |
| N3-137 | [梅](entries/1473/1473460-ume.org) | うめ | ume | 1473460 | learner | draft | **new** | Editorial review |
| N3-138 | [裏切る](entries/1550/1550380-uragiru.org) | うらぎる | uragiru | 1550380 | learner | draft | **new** | Editorial review |
| N3-139 | [得る](entries/1454/1454500-uru.org) | うる | uru | 1454500 | learner | draft | **new** | Editorial review |
| N3-140 | [嬉しい](entries/1219/1219510-ureshii.org) | うれしい | ureshii | 1219510 | learner | draft | **new** | Editorial review |
| N3-141 | [売れる](entries/1473/1473960-ureru.org) | うれる | ureru | 1473960 | learner | draft | **new** | Editorial review |
| N3-142 | [噂](entries/1172/1172590-uwasa.org) | うわさ | uwasa | 1172590 | learner | draft | **new** | Editorial review |
| N3-143 | [運](entries/1172/1172610-un.org) | うん | un | 1172610 | learner | draft | **new** | Editorial review |
| N3-144 | [運転](entries/1172/1172830-unten.org) | うんてん | unten | 1172830 | learner | draft | **new** | Editorial review |
| N3-145 | [運動](entries/1172/1172910-undou.org) | うんどう | undou | 1172910 | learner | draft | **new** | Editorial review |
| N3-146 | [柄](entries/1508/1508290-e.org) | え | e | 1508290 | learner | draft | **new** | Editorial review |
| N3-147 | [永遠](entries/1174/1174070-eien.org) | えいえん | eien | 1174070 | learner | draft | **new** | Editorial review |
| N3-148 | [永久](entries/1576/1576520-eikyuu.org) | えいきゅう | eikyuu | 1576520 | learner | draft | **new** | Editorial review |
| N3-149 | [影響](entries/1173/1173660-eikyou.org) | えいきょう | eikyou | 1173660 | learner | draft | **new** | Editorial review |
| N3-150 | [営業](entries/1173/1173430-eigyou.org) | えいぎょう | eigyou | 1173430 | learner | draft | **new** | Editorial review |
| N3-151 | [衛星](entries/1174/1174760-eisei.org) | えいせい | eisei | 1174760 | learner | draft | **new** | Editorial review |
| N3-152 | [栄養](entries/1173/1173990-eiyou.org) | えいよう | eiyou | 1173990 | learner | draft | **new** | Editorial review |
| N3-153 | [笑顔](entries/1351/1351400-egao.org) | えがお | egao | 1351400 | learner | draft | **new** | Editorial review |
| N3-154 | [描く](entries/1583/1583460-egaku.org) | えがく | egaku | 1583460 | learner | draft | **new** | Editorial review |
| N3-155 | [餌](entries/1173/1173340-esa.org) | えさ | esa | 1173340 | learner | draft | **new** | Editorial review |
| N3-156 | [エネルギー](entries/1029/1029430-enerugii.org) | エネルギー | enerugii | 1029430 | learner | draft | **new** | Editorial review |
| N3-157 | [得る](entries/1588/1588760-eru.org) | える | eru | 1588760 | learner | draft | **new** | Editorial review |
| N3-158 | [縁](entries/1177/1177490-en.org) | えん | en | 1177490 | learner | draft | **new** | Editorial review |
| N3-159 | [円](entries/1175/1175570-en.org) | えん | en | 1175570 | learner | draft | **new** | Editorial review |
| N3-160 | [演技](entries/1176/1176820-engi.org) | えんぎ | engi | 1176820 | learner | draft | **new** | Editorial review |
| N3-161 | [援助](entries/1176/1176660-enjo.org) | えんじょ | enjo | 1176660 | learner | draft | **new** | Editorial review |
| N3-162 | [エンジン](entries/1030/1030950-enjin.org) | エンジン | enjin | 1030950 | learner | draft | **new** | Editorial review |
| N3-163 | [演説](entries/1176/1176960-enzetsu.org) | えんぜつ | enzetsu | 1176960 | learner | draft | **new** | Editorial review |
| N3-164 | [演奏](entries/1607/1607520-ensou.org) | えんそう | ensou | 1607520 | learner | draft | **new** | Editorial review |
| N3-165 | [老い](entries/1643/1643510-oi.org) | おい | oi | 1643510 | learner | draft | **new** | Editorial review |
| N3-166 | [追いつく](entries/1588/1588810-oitsuku.org) | おいつく | oitsuku | 1588810 | learner | draft | **new** | Editorial review |
| N3-167 | [追う](entries/1432/1432410-ou.org) | おう | ou | 1432410 | learner | draft | **new** | Editorial review |
| N3-168 | [王](entries/1629/1629200-ou.org) | おう | ou | 1629200 | learner | draft | **new** | Editorial review |
| N3-169 | [王様](entries/1181/1181700-ousama.org) | おうさま | ousama | 1181700 | learner | draft | **new** | Editorial review |
| N3-170 | [王子](entries/1181/1181500-ouji.org) | おうじ | ouji | 1181500 | learner | draft | **new** | Editorial review |
| N3-171 | [応じる](entries/1179/1179830-oujiru.org) | おうじる | oujiru | 1179830 | learner | draft | **new** | Editorial review |
| N3-172 | [横断](entries/1180/1180900-oudan.org) | おうだん | oudan | 1180900 | learner | draft | **new** | Editorial review |
| N3-173 | [終える](entries/1332/1332760-oeru.org) | おえる | oeru | 1332760 | learner | draft | **new** | Editorial review |
| N3-174 | [大いに](entries/1412/1412880-ooini.org) | おおいに | ooini | 1412880 | learner | draft | **new** | Editorial review |
| N3-175 | [覆う](entries/1588/1588840-oou.org) | おおう | oou | 1588840 | learner | draft | **new** | Editorial review |
| N3-176 | [大家](entries/1413/1413140-ooya.org) | おおや | ooya | 1413140 | learner | draft | **new** | Editorial review |
| N3-177 | [丘](entries/1588/1588920-oka.org) | おか | oka | 1588920 | learner | draft | **new** | Editorial review |
| N3-178 | [沖](entries/1182/1182500-oki.org) | おき | oki | 1182500 | learner | draft | **new** | Editorial review |
| N3-179 | [奥](entries/1179/1179320-oku.org) | おく | oku | 1179320 | learner | draft | **new** | Editorial review |
| N3-180 | [贈る](entries/1403/1403550-okuru.org) | おくる | okuru | 1403550 | learner | draft | **new** | Editorial review |
| N3-181 | [起こる](entries/1223/1223680-okoru.org) | おこる | okoru | 1223680 | learner | draft | **new** | Editorial review |
| N3-182 | [幼い](entries/1545/1545110-osanai.org) | おさない | osanai | 1545110 | learner | draft | **new** | Editorial review |
| N3-183 | [収める](entries/1589/1589090-osameru.org) | おさめる | osameru | 1589090 | learner | draft | **new** | Editorial review |
| N3-184 | [お喋り](entries/1002/1002450-oshaberi.org) | おしゃべり | oshaberi | 1002450 | learner | draft | **new** | Editorial review |
| N3-185 | [汚染](entries/1179/1179040-osen.org) | おせん | osen | 1179040 | learner | draft | **new** | Editorial review |
| N3-186 | [恐らく](entries/1236/1236650-osoraku.org) | おそらく | osoraku | 1236650 | learner | draft | **new** | Editorial review |
| N3-187 | [恐れる](entries/1589/1589200-osoreru.org) | おそれる | osoreru | 1589200 | learner | draft | **new** | Editorial review |
| N3-188 | [恐ろしい](entries/1236/1236690-osoroshii.org) | おそろしい | osoroshii | 1236690 | learner | draft | **new** | Editorial review |
| N3-189 | [お互い](entries/1979/1979930-otagai.org) | おたがい | otagai | 1979930 | learner | draft | **new** | Editorial review |
| N3-190 | [穏やか](entries/1183/1183590-odayaka.org) | おだやか | odayaka | 1183590 | learner | draft | **new** | Editorial review |
| N3-191 | [男の人](entries/1420/1420020-otokonohito.org) | おとこのひと | otokonohito | 1420020 | learner | draft | **new** | Editorial review |
| N3-192 | [劣る](entries/1558/1558400-otoru.org) | おとる | otoru | 1558400 | learner | draft | **new** | Editorial review |
| N3-193 | [鬼](entries/1224/1224190-oni.org) | おに | oni | 1224190 | learner | draft | **new** | Editorial review |
| N3-194 | [お昼](entries/1660/1660100-ohiru.org) | おひる | ohiru | 1660100 | learner | draft | **new** | Editorial review |
| N3-195 | [帯](entries/1410/1410410-obi.org) | おび | obi | 1410410 | learner | draft | **new** | Editorial review |
| N3-196 | [オフィス](entries/1034/1034660-ofisu.org) | オフィス | ofisu | 1034660 | learner | draft | **new** | Editorial review |
| N3-197 | [溺れる](entries/1437/1437560-oboreru.org) | おぼれる | oboreru | 1437560 | learner | draft | **new** | Editorial review |
| N3-198 | [お前](entries/1002/1002290-omae.org) | おまえ | omae | 1002290 | learner | draft | **new** | Editorial review |
| N3-199 | [御目出度う](entries/1270/1270700-omedetou.org) | おめでとう | omedetou | 1270700 | learner | draft | **new** | Editorial review |
| N3-200 | [思い出](entries/1589/1589340-omoide.org) | おもいで | omoide | 1589340 | learner | draft | **new** | Editorial review |
| N3-201 | [主に](entries/1324/1324990-omoni.org) | おもに | omoni | 1324990 | learner | draft | **new** | Editorial review |
| N3-202 | [思わず](entries/1309/1309460-omowazu.org) | おもわず | omowazu | 1309460 | learner | draft | **new** | Editorial review |
| N3-203 | [泳ぎ](entries/1613/1613570-oyogi.org) | およぎ | oyogi | 1613570 | learner | draft | **new** | Editorial review |
| N3-204 | [凡そ](entries/1523/1523450-oyoso.org) | およそ | oyoso | 1523450 | learner | draft | **new** | Editorial review |
| N3-205 | [及ぼす](entries/1228/1228180-oyobosu.org) | およぼす | oyobosu | 1228180 | learner | draft | **new** | Editorial review |
| N3-206 | [居る](entries/1577/1577985-oru.org) | おる | oru | 1577985 | learner | draft | **new** | Editorial review |
| N3-207 | [下ろす](entries/1589/1589580-orosu.org) | おろす | orosu | 1589580 | learner | draft | **new** | Editorial review |
| N3-208 | [恩](entries/1183/1183090-on.org) | おん | on | 1183090 | learner | draft | **new** | Editorial review |
| N3-209 | [温暖](entries/1183/1183480-ondan.org) | おんだん | ondan | 1183480 | learner | draft | **new** | Editorial review |
| N3-210 | [温度](entries/1183/1183510-ondo.org) | おんど | ondo | 1183510 | learner | draft | **new** | Editorial review |
| N3-211 | [オーバー](entries/1032/1032390-oobaa.org) | オーバー | oobaa | 1032390 | learner | draft | **new** | Editorial review |
| N3-212 | [可](entries/1190/1190710-ka.org) | か | ka | 1190710 | learner | draft | **new** | Editorial review |
| N3-213 | [課](entries/1195/1195710-ka.org) | か | ka | 1195710 | learner | draft | **new** | Editorial review |
| N3-214 | [会](entries/1198/1198170-kai.org) | かい | kai | 1198170 | learner | draft | **new** | Editorial review |
| N3-215 | [回](entries/1199/1199330-kai.org) | かい | kai | 1199330 | learner | draft | **new** | Editorial review |
| N3-216 | [会員](entries/1198/1198230-kaiin.org) | かいいん | kaiin | 1198230 | learner | draft | **new** | Editorial review |
| N3-217 | [絵画](entries/1202/1202300-kaiga.org) | かいが | kaiga | 1202300 | learner | draft | **new** | Editorial review |
| N3-218 | [海外](entries/1201/1201260-kaigai.org) | かいがい | kaigai | 1201260 | learner | draft | **new** | Editorial review |
| N3-219 | [会計](entries/1198/1198430-kaikei.org) | かいけい | kaikei | 1198430 | learner | draft | **new** | Editorial review |
| N3-220 | [解決](entries/1198/1198960-kaiketsu.org) | かいけつ | kaiketsu | 1198960 | learner | draft | **new** | Editorial review |
| N3-221 | [会合](entries/1198/1198530-kaigou.org) | かいごう | kaigou | 1198530 | learner | draft | **new** | Editorial review |
| N3-222 | [開始](entries/1202/1202760-kaishi.org) | かいし | kaishi | 1202760 | learner | draft | **new** | Editorial review |
| N3-223 | [解釈](entries/1199/1199010-kaishaku.org) | かいしゃく | kaishaku | 1199010 | learner | draft | **new** | Editorial review |
| N3-224 | [改善](entries/1200/1200960-kaizen.org) | かいぜん | kaizen | 1200960 | learner | draft | **new** | Editorial review |
| N3-225 | [快適](entries/1200/1200120-kaiteki.org) | かいてき | kaiteki | 1200120 | learner | draft | **new** | Editorial review |
| N3-226 | [回復](entries/1199/1199720-kaifuku.org) | かいふく | kaifuku | 1199720 | learner | draft | **new** | Editorial review |
| N3-227 | [飼う](entries/1312/1312970-kau.org) | かう | kau | 1312970 | learner | draft | **new** | Editorial review |
| N3-228 | [替える](entries/1589/1589780-kaeru.org) | かえる | kaeru | 1589780 | learner | draft | **new** | Editorial review |
| N3-229 | [香り](entries/1589/1589820-kaori.org) | かおり | kaori | 1589820 | learner | draft | **new** | Editorial review |
| N3-230 | [抱える](entries/1516/1516310-kakaeru.org) | かかえる | kakaeru | 1516310 | learner | draft | **new** | Editorial review |
| N3-231 | [価格](entries/1189/1189500-kakaku.org) | かかく | kakaku | 1189500 | learner | draft | **new** | Editorial review |
| N3-232 | [係](entries/1589/1589840-kakari.org) | かかり | kakari | 1589840 | learner | draft | **new** | Editorial review |
| N3-233 | [罹る](entries/1609/1609500-kakaru.org) | かかる | kakaru | 1609500 | learner | draft | **new** | Editorial review |
| N3-234 | [化学](entries/1186/1186760-kagaku.org) | かがく | kagaku | 1186760 | learner | draft | **new** | Editorial review |
| N3-235 | [輝く](entries/1224/1224020-kagayaku.org) | かがやく | kagayaku | 1224020 | learner | draft | **new** | Editorial review |
| N3-236 | [限る](entries/1264/1264640-kagiru.org) | かぎる | kagiru | 1264640 | learner | draft | **new** | Editorial review |
| N3-237 | [覚悟](entries/1206/1206080-kakugo.org) | かくご | kakugo | 1206080 | learner | draft | **new** | Editorial review |
| N3-238 | [確実](entries/1205/1205830-kakujitsu.org) | かくじつ | kakujitsu | 1205830 | learner | draft | **new** | Editorial review |
| N3-239 | [隠す](entries/1170/1170650-kakusu.org) | かくす | kakusu | 1170650 | learner | draft | **new** | Editorial review |
| N3-240 | [拡大](entries/1205/1205200-kakudai.org) | かくだい | kakudai | 1205200 | learner | draft | **new** | Editorial review |
| N3-241 | [確認](entries/1205/1205900-kakunin.org) | かくにん | kakunin | 1205900 | learner | draft | **new** | Editorial review |
| N3-242 | [隠れる](entries/1170/1170660-kakureru.org) | かくれる | kakureru | 1170660 | learner | draft | **new** | Editorial review |
| N3-243 | [家具](entries/1191/1191870-kagu.org) | かぐ | kagu | 1191870 | learner | draft | **new** | Editorial review |
| N3-244 | [欠ける](entries/1253/1253920-kakeru.org) | かける | kakeru | 1253920 | learner | draft | **new** | Editorial review |
| N3-245 | [影](entries/1590/1590145-kage.org) | かげ | kage | 1590145 | learner | draft | **new** | Editorial review |
| N3-246 | [陰](entries/1590/1590150-kage.org) | かげ | kage | 1590150 | learner | draft | **new** | Editorial review |
| N3-247 | [加減](entries/1190/1190080-kagen.org) | かげん | kagen | 1190080 | learner | draft | **new** | Editorial review |
| N3-248 | [過去](entries/1196/1196030-kako.org) | かこ | kako | 1196030 | learner | draft | **new** | Editorial review |
| N3-249 | [囲む](entries/1155/1155980-kakomu.org) | かこむ | kakomu | 1155980 | learner | draft | **new** | Editorial review |
| N3-250 | [籠](entries/1590/1590200-kago.org) | かご | kago | 1590200 | learner | draft | **new** | Editorial review |
| N3-251 | [菓子](entries/1195/1195670-kashi.org) | かし | kashi | 1195670 | learner | draft | **new** | Editorial review |
| N3-252 | [賢い](entries/1260/1260260-kashikoi.org) | かしこい | kashikoi | 1260260 | learner | draft | **new** | Editorial review |
| N3-253 | [歌手](entries/1193/1193290-kashu.org) | かしゅ | kashu | 1193290 | learner | draft | **new** | Editorial review |
| N3-254 | [家事](entries/1191/1191980-kaji.org) | かじ | kaji | 1191980 | learner | draft | **new** | Editorial review |
| N3-255 | [数](entries/1580/1580820-kazu.org) | かず | kazu | 1580820 | learner | draft | **new** | Editorial review |
| N3-256 | [稼ぐ](entries/1194/1194450-kasegu.org) | かせぐ | kasegu | 1194450 | learner | draft | **new** | Editorial review |
| N3-257 | [数える](entries/1372/1372900-kazoeru.org) | かぞえる | kazoeru | 1372900 | learner | draft | **new** | Editorial review |
| N3-258 | [肩](entries/1258/1258950-kata.org) | かた | kata | 1258950 | learner | draft | **new** | Editorial review |
| N3-259 | [型](entries/1250/1250090-kata.org) | かた | kata | 1250090 | learner | draft | **new** | Editorial review |
| N3-260 | [方々](entries/1584/1584100-katagata.org) | かたがた | katagata | 1584100 | learner | draft | **new** | Editorial review |
| N3-261 | [刀](entries/1446/1446420-katana.org) | かたな | katana | 1446420 | learner | draft | **new** | Editorial review |
| N3-262 | [語る](entries/1270/1270990-kataru.org) | かたる | kataru | 1270990 | learner | draft | **new** | Editorial review |
| N3-263 | [価値](entries/1189/1189600-kachi.org) | かち | kachi | 1189600 | learner | draft | **new** | Editorial review |
| N3-264 | [勝ち](entries/1609/1609560-kachi.org) | かち | kachi | 1609560 | learner | draft | **new** | Editorial review |
| N3-265 | [活気](entries/1208/1208270-kakki.org) | かっき | kakki | 1208270 | learner | draft | **new** | Editorial review |
| N3-266 | [格好](entries/1590/1590480-kakkou.org) | かっこう | kakkou | 1590480 | learner | draft | **new** | Editorial review |
| N3-267 | [活動](entries/1208/1208360-katsudou.org) | かつどう | katsudou | 1208360 | learner | draft | **new** | Editorial review |
| N3-268 | [活用](entries/1208/1208460-katsuyou.org) | かつよう | katsuyou | 1208460 | learner | draft | **new** | Editorial review |
| N3-269 | [悲しむ](entries/1483/1483200-kanashimu.org) | かなしむ | kanashimu | 1483200 | learner | draft | **new** | Editorial review |
| N3-270 | [必ずしも](entries/1487/1487410-kanarazushimo.org) | かならずしも | kanarazushimo | 1487410 | learner | draft | **new** | Editorial review |
| N3-271 | [可也](entries/1590/1590560-kanari.org) | かなり | kanari | 1590560 | learner | draft | **new** | Editorial review |
| N3-272 | [金](entries/1242/1242590-kane.org) | かね | kane | 1242590 | learner | draft | **new** | Editorial review |
| N3-273 | [可能](entries/1191/1191060-kanou.org) | かのう | kanou | 1191060 | learner | draft | **new** | Editorial review |
| N3-274 | [株](entries/1208/1208920-kabu.org) | かぶ | kabu | 1208920 | learner | draft | **new** | Editorial review |
| N3-275 | [被る](entries/1484/1484330-kaburu.org) | かぶる | kaburu | 1484330 | learner | draft | **new** | Editorial review |
| N3-276 | [構う](entries/1279/1279680-kamau.org) | かまう | kamau | 1279680 | learner | draft | **new** | Editorial review |
| N3-277 | [神](entries/1364/1364440-kami.org) | かみ | kami | 1364440 | learner | draft | **new** | Editorial review |
| N3-278 | [上](entries/1352/1352150-kami.org) | かみ | kami | 1352150 | learner | draft | **new** | Editorial review |
| N3-279 | [雷](entries/1585/1585060-kaminari.org) | かみなり | kaminari | 1585060 | learner | draft | **new** | Editorial review |
| N3-280 | [髪の毛](entries/1477/1477960-kaminoke.org) | かみのけ | kaminoke | 1477960 | learner | draft | **new** | Editorial review |
| N3-281 | [科目](entries/1590/1590600-kamoku.org) | かもく | kamoku | 1590600 | learner | draft | **new** | Editorial review |
| N3-282 | [かも知れない](entries/1002/1002970-kamoshirenai.org) | かもしれない | kamoshirenai | 1002970 | learner | draft | **new** | Editorial review |
| N3-283 | [火曜](entries/1194/1194280-kayou.org) | かよう | kayou | 1194280 | learner | draft | **new** | Editorial review |
| N3-284 | [空](entries/1245/1245280-kara.org) | から | kara | 1245280 | learner | draft | **new** | Editorial review |
| N3-285 | [刈る](entries/1209/1209540-karu.org) | かる | karu | 1209540 | learner | draft | **new** | Editorial review |
| N3-286 | [彼ら](entries/1483/1483090-karera.org) | かれら | karera | 1483090 | learner | draft | **new** | Editorial review |
| N3-287 | [皮](entries/1483/1483800-kawa.org) | かわ | kawa | 1483800 | learner | draft | **new** | Editorial review |
| N3-288 | [革](entries/1483/1483805-kawa.org) | かわ | kawa | 1483805 | learner | draft | **new** | Editorial review |
| N3-289 | [可哀想](entries/1590/1590740-kawaisou.org) | かわいそう | kawaisou | 1590740 | learner | draft | **new** | Editorial review |
| N3-290 | [可愛らしい](entries/1190/1190740-kawairashii.org) | かわいらしい | kawairashii | 1190740 | learner | draft | **new** | Editorial review |
| N3-291 | [缶](entries/1214/1214540-kan.org) | かん | kan | 1214540 | learner | draft | **new** | Editorial review |
| N3-292 | [勘](entries/1210/1210590-kan.org) | かん | kan | 1210590 | learner | draft | **new** | Editorial review |
| N3-293 | [管](entries/1577/1577650-kan.org) | かん | kan | 1577650 | learner | draft | **new** | Editorial review |
| N3-294 | [感覚](entries/1212/1212330-kankaku.org) | かんかく | kankaku | 1212330 | learner | draft | **new** | Editorial review |
| N3-295 | [考え](entries/1281/1281000-kangae.org) | かんがえ | kangae | 1281000 | learner | draft | **new** | Editorial review |
| N3-296 | [観客](entries/1214/1214810-kankyaku.org) | かんきゃく | kankyaku | 1214810 | learner | draft | **new** | Editorial review |
| N3-297 | [環境](entries/1213/1213280-kankyou.org) | かんきょう | kankyou | 1213280 | learner | draft | **new** | Editorial review |
| N3-298 | [歓迎](entries/1212/1212960-kangei.org) | かんげい | kangei | 1212960 | learner | draft | **new** | Editorial review |
| N3-299 | [観光](entries/1214/1214840-kankou.org) | かんこう | kankou | 1214840 | learner | draft | **new** | Editorial review |
| N3-300 | [観察](entries/1214/1214900-kansatsu.org) | かんさつ | kansatsu | 1214900 | learner | draft | **new** | Editorial review |
| N3-301 | [感謝](entries/1212/1212380-kansha.org) | かんしゃ | kansha | 1212380 | learner | draft | **new** | Editorial review |
| N3-302 | [関心](entries/1215/1215870-kanshin.org) | かんしん | kanshin | 1215870 | learner | draft | **new** | Editorial review |
| N3-303 | [感心](entries/1212/1212450-kanshin.org) | かんしん | kanshin | 1212450 | learner | draft | **new** | Editorial review |
| N3-304 | [感じ](entries/1212/1212250-kanji.org) | かんじ | kanji | 1212250 | learner | draft | **new** | Editorial review |
| N3-305 | [患者](entries/1212/1212210-kanja.org) | かんじゃ | kanja | 1212210 | learner | draft | **new** | Editorial review |
| N3-306 | [感情](entries/1212/1212410-kanjou.org) | かんじょう | kanjou | 1212410 | learner | draft | **new** | Editorial review |
| N3-307 | [勘定](entries/1210/1210750-kanjou.org) | かんじょう | kanjou | 1210750 | learner | draft | **new** | Editorial review |
| N3-308 | [感じる](entries/1212/1212260-kanjiru.org) | かんじる | kanjiru | 1212260 | learner | draft | **new** | Editorial review |
| N3-309 | [関する](entries/1215/1215790-kansuru.org) | かんする | kansuru | 1215790 | learner | draft | **new** | Editorial review |
| N3-310 | [完成](entries/1211/1211490-kansei.org) | かんせい | kansei | 1211490 | learner | draft | **new** | Editorial review |
| N3-311 | [完全](entries/1211/1211510-kanzen.org) | かんぜん | kanzen | 1211510 | learner | draft | **new** | Editorial review |
| N3-312 | [監督](entries/1213/1213720-kantoku.org) | かんとく | kantoku | 1213720 | learner | draft | **new** | Editorial review |
| N3-313 | [感動](entries/1212/1212570-kandou.org) | かんどう | kandou | 1212570 | learner | draft | **new** | Editorial review |
| N3-314 | [管理](entries/1214/1214200-kanri.org) | かんり | kanri | 1214200 | learner | draft | **new** | Editorial review |
| N3-315 | [完了](entries/1211/1211630-kanryou.org) | かんりょう | kanryou | 1211630 | learner | draft | **new** | Editorial review |
| N3-316 | [関連](entries/1216/1216060-kanren.org) | かんれん | kanren | 1216060 | learner | draft | **new** | Editorial review |
| N3-317 | [カー](entries/1036/1036170-kaa.org) | カー | kaa | 1036170 | learner | draft | **new** | Editorial review |
| N3-318 | [カード](entries/1036/1036400-kaado.org) | カード | kaado | 1036400 | learner | draft | **new** | Editorial review |
| N3-319 | [害](entries/1204/1204330-gai.org) | がい | gai | 1204330 | learner | draft | **new** | Editorial review |
| N3-320 | [外交](entries/1203/1203540-gaikou.org) | がいこう | gaikou | 1203540 | learner | draft | **new** | Editorial review |
| N3-321 | [外出](entries/1203/1203800-gaishutsu.org) | がいしゅつ | gaishutsu | 1203800 | learner | draft | **new** | Editorial review |
| N3-322 | [画家](entries/1197/1197120-gaka.org) | がか | gaka | 1197120 | learner | draft | **new** | Editorial review |
| N3-323 | [額](entries/1207/1207500-gaku.org) | がく | gaku | 1207500 | learner | draft | **new** | Editorial review |
| N3-324 | [学](entries/1955/1955900-gaku.org) | がく | gaku | 1955900 | learner | draft | **new** | Editorial review |
| N3-325 | [学者](entries/1206/1206800-gakusha.org) | がくしゃ | gakusha | 1206800 | learner | draft | **new** | Editorial review |
| N3-326 | [学習](entries/1206/1206820-gakushuu.org) | がくしゅう | gakushuu | 1206820 | learner | draft | **new** | Editorial review |
| N3-327 | [学問](entries/1207/1207130-gakumon.org) | がくもん | gakumon | 1207130 | learner | draft | **new** | Editorial review |
| N3-328 | [がっかり](entries/1003/1003170-gakkari.org) | がっかり | gakkari | 1003170 | learner | draft | **new** | Editorial review |
| N3-329 | [学期](entries/1206/1206650-gakki.org) | がっき | gakki | 1206650 | learner | draft | **new** | Editorial review |
| N3-330 | [我慢](entries/1196/1196970-gaman.org) | がまん | gaman | 1196970 | learner | draft | **new** | Editorial review |
| N3-331 | [柄](entries/1508/1508300-gara.org) | がら | gara | 1508300 | learner | draft | **new** | Editorial review |
| N3-332 | [記憶](entries/1223/1223150-kioku.org) | きおく | kioku | 1223150 | learner | draft | **new** | Editorial review |
| N3-333 | [気温](entries/1221/1221950-kion.org) | きおん | kion | 1221950 | learner | draft | **new** | Editorial review |
| N3-334 | [機械](entries/1220/1220810-kikai.org) | きかい | kikai | 1220810 | learner | draft | **new** | Editorial review |
| N3-335 | [期間](entries/1220/1220550-kikan.org) | きかん | kikan | 1220550 | learner | draft | **new** | Editorial review |
| N3-336 | [機関](entries/1220/1220870-kikan.org) | きかん | kikan | 1220870 | learner | draft | **new** | Editorial review |
| N3-337 | [企業](entries/1218/1218190-kigyou.org) | きぎょう | kigyou | 1218190 | learner | draft | **new** | Editorial review |
| N3-338 | [利く](entries/1591/1591100-kiku.org) | きく | kiku | 1591100 | learner | draft | **new** | Editorial review |
| N3-339 | [効く](entries/1591/1591100-kiku.org) | きく | kiku | 1591100 | learner | draft | **new** | Editorial review |
| N3-340 | [機嫌](entries/1220/1220930-kigen.org) | きげん | kigen | 1220930 | learner | draft | **new** | Editorial review |
| N3-341 | [気候](entries/1222/1222170-kikou.org) | きこう | kikou | 1222170 | learner | draft | **new** | Editorial review |
| N3-342 | [岸](entries/1217/1217040-kishi.org) | きし | kishi | 1217040 | learner | draft | **new** | Editorial review |
| N3-343 | [記者](entries/1223/1223250-kisha.org) | きしゃ | kisha | 1223250 | learner | draft | **new** | Editorial review |
| N3-344 | [記事](entries/1223/1223240-kiji.org) | きじ | kiji | 1223240 | learner | draft | **new** | Editorial review |
| N3-345 | [生地](entries/1379/1379330-kiji.org) | きじ | kiji | 1379330 | learner | draft | **new** | Editorial review |
| N3-346 | [傷](entries/1580/1580260-kizu.org) | きず | kizu | 1580260 | learner | draft | **new** | Editorial review |
| N3-347 | [期待](entries/1220/1220570-kitai.org) | きたい | kitai | 1220570 | learner | draft | **new** | Editorial review |
| N3-348 | [帰宅](entries/1221/1221430-kitaku.org) | きたく | kitaku | 1221430 | learner | draft | **new** | Editorial review |
| N3-349 | [貴重](entries/1223/1223520-kichou.org) | きちょう | kichou | 1223520 | learner | draft | **new** | Editorial review |
| N3-350 | [きちんと](entries/1003/1003400-kichinto.org) | きちんと | kichinto | 1003400 | learner | draft | **new** | Editorial review |
| N3-351 | [きつい](entries/1003/1003450-kitsui.org) | きつい | kitsui | 1003450 | learner | draft | **new** | Editorial review |
| N3-352 | [気づく](entries/1591/1591330-kizuku.org) | きづく | kizuku | 1591330 | learner | draft | **new** | Editorial review |
| N3-353 | [気に入る](entries/1221/1221740-kiniiru.org) | きにいる | kiniiru | 1221740 | learner | draft | **new** | Editorial review |
| N3-354 | [記入](entries/1223/1223330-kinyuu.org) | きにゅう | kinyuu | 1223330 | learner | draft | **new** | Editorial review |
| N3-355 | [記念](entries/1223/1223340-kinen.org) | きねん | kinen | 1223340 | learner | draft | **new** | Editorial review |
| N3-356 | [機能](entries/1221/1221130-kinou.org) | きのう | kinou | 1221130 | learner | draft | **new** | Editorial review |
| N3-357 | [気の毒](entries/1221/1221770-kinodoku.org) | きのどく | kinodoku | 1221770 | learner | draft | **new** | Editorial review |
| N3-358 | [寄付](entries/1591/1591400-kifu.org) | きふ | kifu | 1591400 | learner | draft | **new** | Editorial review |
| N3-359 | [基本](entries/1219/1219190-kihon.org) | きほん | kihon | 1219190 | learner | draft | **new** | Editorial review |
| N3-360 | [希望](entries/1219/1219910-kibou.org) | きぼう | kibou | 1219910 | learner | draft | **new** | Editorial review |
| N3-361 | [決まり](entries/1609/1609660-kimari.org) | きまり | kimari | 1609660 | learner | draft | **new** | Editorial review |
| N3-362 | [気味](entries/1222/1222640-kimi.org) | きみ | kimi | 1222640 | learner | draft | **new** | Editorial review |
| N3-363 | [奇妙](entries/1219/1219490-kimyou.org) | きみょう | kimyou | 1219490 | learner | draft | **new** | Editorial review |
| N3-364 | [キャプテン](entries/1041/1041850-kyaputen.org) | キャプテン | kyaputen | 1041850 | learner | draft | **new** | Editorial review |
| N3-365 | [キャンプ](entries/1042/1042200-kyanpu.org) | キャンプ | kyanpu | 1042200 | learner | draft | **new** | Editorial review |
| N3-366 | [九](entries/1578/1578150-kyuu.org) | きゅう | kyuu | 1578150 | learner | draft | **new** | Editorial review |
| N3-367 | [旧](entries/1230/1230380-kyuu.org) | きゅう | kyuu | 1230380 | learner | draft | **new** | Editorial review |
| N3-368 | [級](entries/1919/1919590-kyuu.org) | きゅう | kyuu | 1919590 | learner | draft | **new** | Editorial review |
| N3-369 | [球](entries/1229/1229880-kyuu.org) | きゅう | kyuu | 1229880 | learner | draft | **new** | Editorial review |
| N3-370 | [休憩](entries/1227/1227720-kyuukei.org) | きゅうけい | kyuukei | 1227720 | learner | draft | **new** | Editorial review |
| N3-371 | [急激](entries/1228/1228680-kyuugeki.org) | きゅうげき | kyuugeki | 1228680 | learner | draft | **new** | Editorial review |
| N3-372 | [吸収](entries/1228/1228330-kyuushuu.org) | きゅうしゅう | kyuushuu | 1228330 | learner | draft | **new** | Editorial review |
| N3-373 | [救助](entries/1229/1229200-kyuujo.org) | きゅうじょ | kyuujo | 1229200 | learner | draft | **new** | Editorial review |
| N3-374 | [急速](entries/1228/1228890-kyuusoku.org) | きゅうそく | kyuusoku | 1228890 | learner | draft | **new** | Editorial review |
| N3-375 | [急に](entries/2269/2269050-kyuuni.org) | きゅうに | kyuuni | 2269050 | learner | draft | **new** | Editorial review |
| N3-376 | [給料](entries/1230/1230360-kyuuryou.org) | きゅうりょう | kyuuryou | 1230360 | learner | draft | **new** | Editorial review |
| N3-377 | [教科書](entries/1237/1237020-kyoukasho.org) | きょうかしょ | kyoukasho | 1237020 | learner | draft | **new** | Editorial review |
| N3-378 | [供給](entries/1233/1233630-kyoukyuu.org) | きょうきゅう | kyoukyuu | 1233630 | learner | draft | **new** | Editorial review |
| N3-379 | [競技](entries/1234/1234080-kyougi.org) | きょうぎ | kyougi | 1234080 | learner | draft | **new** | Editorial review |
| N3-380 | [教師](entries/1237/1237130-kyoushi.org) | きょうし | kyoushi | 1237130 | learner | draft | **new** | Editorial review |
| N3-381 | [教授](entries/1237/1237160-kyouju.org) | きょうじゅ | kyouju | 1237160 | learner | draft | **new** | Editorial review |
| N3-382 | [強調](entries/1236/1236470-kyouchou.org) | きょうちょう | kyouchou | 1236470 | learner | draft | **new** | Editorial review |
| N3-383 | [共通](entries/1234/1234700-kyoutsuu.org) | きょうつう | kyoutsuu | 1234700 | learner | draft | **new** | Editorial review |
| N3-384 | [共同](entries/1591/1591660-kyoudou.org) | きょうどう | kyoudou | 1591660 | learner | draft | **new** | Editorial review |
| N3-385 | [恐怖](entries/1236/1236750-kyoufu.org) | きょうふ | kyoufu | 1236750 | learner | draft | **new** | Editorial review |
| N3-386 | [協力](entries/1591/1591720-kyouryoku.org) | きょうりょく | kyouryoku | 1591720 | learner | draft | **new** | Editorial review |
| N3-387 | [強力](entries/1236/1236600-kyouryoku.org) | きょうりょく | kyouryoku | 1236600 | learner | draft | **new** | Editorial review |
| N3-388 | [許可](entries/1232/1232880-kyoka.org) | きょか | kyoka | 1232880 | learner | draft | **new** | Editorial review |
| N3-389 | [局](entries/1239/1239560-kyoku.org) | きょく | kyoku | 1239560 | learner | draft | **new** | Editorial review |
| N3-390 | [極](entries/1956/1956100-kyoku.org) | きょく | kyoku | 1956100 | learner | draft | **new** | Editorial review |
| N3-391 | [巨大](entries/1232/1232180-kyodai.org) | きょだい | kyodai | 1232180 | learner | draft | **new** | Editorial review |
| N3-392 | [器用](entries/1218/1218960-kiyou.org) | きよう | kiyou | 1218960 | learner | draft | **new** | Editorial review |
| N3-393 | [嫌う](entries/1257/1257250-kirau.org) | きらう | kirau | 1257250 | learner | draft | **new** | Editorial review |
| N3-394 | [霧](entries/1531/1531110-kiri.org) | きり | kiri | 1531110 | learner | draft | **new** | Editorial review |
| N3-395 | [切れ](entries/1384/1384840-kire.org) | きれ | kire | 1384840 | learner | draft | **new** | Editorial review |
| N3-396 | [切れる](entries/1384/1384860-kireru.org) | きれる | kireru | 1384860 | learner | draft | **new** | Editorial review |
| N3-397 | [記録](entries/1223/1223440-kiroku.org) | きろく | kiroku | 1223440 | learner | draft | **new** | Editorial review |
| N3-398 | [金](entries/1242/1242600-kin.org) | きん | kin | 1242600 | learner | draft | **new** | Editorial review |
| N3-399 | [禁煙](entries/1241/1241490-kinen.org) | きんえん | kinen | 1241490 | learner | draft | **new** | Editorial review |
| N3-400 | [金額](entries/1242/1242700-kingaku.org) | きんがく | kingaku | 1242700 | learner | draft | **new** | Editorial review |
| N3-401 | [金庫](entries/1242/1242850-kinko.org) | きんこ | kinko | 1242850 | learner | draft | **new** | Editorial review |
| N3-402 | [禁止](entries/1241/1241550-kinshi.org) | きんし | kinshi | 1241550 | learner | draft | **new** | Editorial review |
| N3-403 | [金銭](entries/1243/1243020-kinsen.org) | きんせん | kinsen | 1243020 | learner | draft | **new** | Editorial review |
| N3-404 | [金属](entries/1243/1243040-kinzoku.org) | きんぞく | kinzoku | 1243040 | learner | draft | **new** | Editorial review |
| N3-405 | [近代](entries/1242/1242420-kindai.org) | きんだい | kindai | 1242420 | learner | draft | **new** | Editorial review |
| N3-406 | [緊張](entries/1241/1241880-kinchou.org) | きんちょう | kinchou | 1241880 | learner | draft | **new** | Editorial review |
| N3-407 | [筋肉](entries/1241/1241810-kinniku.org) | きんにく | kinniku | 1241810 | learner | draft | **new** | Editorial review |
| N3-408 | [金融](entries/1243/1243290-kinyuu.org) | きんゆう | kinyuu | 1243290 | learner | draft | **new** | Editorial review |
| N3-409 | [金曜](entries/1243/1243310-kinyou.org) | きんよう | kinyou | 1243310 | learner | draft | **new** | Editorial review |
| N3-410 | [議員](entries/1226/1226020-giin.org) | ぎいん | giin | 1226020 | learner | draft | **new** | Editorial review |
| N3-411 | [議会](entries/1226/1226040-gikai.org) | ぎかい | gikai | 1226040 | learner | draft | **new** | Editorial review |
| N3-412 | [技師](entries/1225/1225110-gishi.org) | ぎし | gishi | 1225110 | learner | draft | **new** | Editorial review |
| N3-413 | [義務](entries/1225/1225900-gimu.org) | ぎむ | gimu | 1225900 | learner | draft | **new** | Editorial review |
| N3-414 | [疑問](entries/1225/1225630-gimon.org) | ぎもん | gimon | 1225630 | learner | draft | **new** | Editorial review |
| N3-415 | [逆](entries/1226/1226960-gyaku.org) | ぎゃく | gyaku | 1226960 | learner | draft | **new** | Editorial review |
| N3-416 | [行儀](entries/1281/1281890-gyougi.org) | ぎょうぎ | gyougi | 1281890 | learner | draft | **new** | Editorial review |
| N3-417 | [議論](entries/1226/1226160-giron.org) | ぎろん | giron | 1226160 | learner | draft | **new** | Editorial review |
| N3-418 | [銀](entries/1595/1595090-gin.org) | ぎん | gin | 1595090 | learner | draft | **new** | Editorial review |
| N3-419 | [句](entries/1243/1243940-ku.org) | く | ku | 1243940 | learner | draft | **new** | Editorial review |
| N3-420 | [食う](entries/1592/1592100-kuu.org) | くう | kuu | 1592100 | learner | draft | **new** | Editorial review |
| N3-421 | [臭い](entries/1333/1333150-kusai.org) | くさい | kusai | 1333150 | learner | draft | **new** | Editorial review |
| N3-422 | [鎖](entries/1291/1291730-kusari.org) | くさり | kusari | 1291730 | learner | draft | **new** | Editorial review |
| N3-423 | [腐る](entries/1497/1497800-kusaru.org) | くさる | kusaru | 1497800 | learner | draft | **new** | Editorial review |
| N3-424 | [癖](entries/1509/1509350-kuse.org) | くせ | kuse | 1509350 | learner | draft | **new** | Editorial review |
| N3-425 | [下さる](entries/1184/1184280-kudasaru.org) | くださる | kudasaru | 1184280 | learner | draft | **new** | Editorial review |
| N3-426 | [下り](entries/1184/1184370-kudari.org) | くだり | kudari | 1184370 | learner | draft | **new** | Editorial review |
| N3-427 | [苦痛](entries/1244/1244560-kutsuu.org) | くつう | kutsuu | 1244560 | learner | draft | **new** | Editorial review |
| N3-428 | [区別](entries/1244/1244250-kubetsu.org) | くべつ | kubetsu | 1244250 | learner | draft | **new** | Editorial review |
| N3-429 | [組](entries/1397/1397450-kumi.org) | くみ | kumi | 1397450 | learner | draft | **new** | Editorial review |
| N3-430 | [組合](entries/1397/1397620-kumiai.org) | くみあい | kumiai | 1397620 | learner | draft | **new** | Editorial review |
| N3-431 | [組む](entries/1397/1397590-kumu.org) | くむ | kumu | 1397590 | learner | draft | **new** | Editorial review |
| N3-432 | [位](entries/1155/1155400-kurai.org) | くらい | kurai | 1155400 | learner | draft | **new** | Editorial review |
| N3-433 | [暮らし](entries/1514/1514930-kurashi.org) | くらし | kurashi | 1514930 | learner | draft | **new** | Editorial review |
| N3-434 | [クラシック](entries/1044/1044020-kurashikku.org) | クラシック | kurashikku | 1044020 | learner | draft | **new** | Editorial review |
| N3-435 | [暮らす](entries/1514/1514940-kurasu.org) | くらす | kurasu | 1514940 | learner | draft | **new** | Editorial review |
| N3-436 | [繰り返す](entries/1247/1247030-kurikaesu.org) | くりかえす | kurikaesu | 1247030 | learner | draft | **new** | Editorial review |
| N3-437 | [クリスマス](entries/1044/1044830-kurisumasu.org) | クリスマス | kurisumasu | 1044830 | learner | draft | **new** | Editorial review |
| N3-438 | [クリーム](entries/1044/1044480-kuriimu.org) | クリーム | kuriimu | 1044480 | learner | draft | **new** | Editorial review |
| N3-439 | [狂う](entries/1237/1237510-kuruu.org) | くるう | kuruu | 1237510 | learner | draft | **new** | Editorial review |
| N3-440 | [苦しい](entries/1244/1244320-kurushii.org) | くるしい | kurushii | 1244320 | learner | draft | **new** | Editorial review |
| N3-441 | [苦しむ](entries/1244/1244350-kurushimu.org) | くるしむ | kurushimu | 1244350 | learner | draft | **new** | Editorial review |
| N3-442 | [暮れ](entries/1514/1514950-kure.org) | くれ | kure | 1514950 | learner | draft | **new** | Editorial review |
| N3-443 | [苦労](entries/1244/1244680-kurou.org) | くろう | kurou | 1244680 | learner | draft | **new** | Editorial review |
| N3-444 | [加える](entries/1189/1189960-kuwaeru.org) | くわえる | kuwaeru | 1189960 | learner | draft | **new** | Editorial review |
| N3-445 | [詳しい](entries/1351/1351730-kuwashii.org) | くわしい | kuwashii | 1351730 | learner | draft | **new** | Editorial review |
| N3-446 | [加わる](entries/1189/1189980-kuwawaru.org) | くわわる | kuwawaru | 1189980 | learner | draft | **new** | Editorial review |
| N3-447 | [訓](entries/1956/1956150-kun.org) | くん | kun | 1956150 | learner | draft | **new** | Editorial review |
| N3-448 | [訓練](entries/1247/1247470-kunren.org) | くんれん | kunren | 1247470 | learner | draft | **new** | Editorial review |
| N3-449 | [偶然](entries/1246/1246270-guuzen.org) | ぐうぜん | guuzen | 1246270 | learner | draft | **new** | Editorial review |
| N3-450 | [具体](entries/1245/1245020-gutai.org) | ぐたい | gutai | 1245020 | learner | draft | **new** | Editorial review |
| N3-451 | [ぐっすり](entries/1004/1004060-gussuri.org) | ぐっすり | gussuri | 1004060 | learner | draft | **new** | Editorial review |
| N3-452 | [グラス](entries/1046/1046430-gurasu.org) | グラス | gurasu | 1046430 | learner | draft | **new** | Editorial review |
| N3-453 | [グランド](entries/1046/1046840-gurando.org) | グランド | gurando | 1046840 | learner | draft | **new** | Editorial review |
| N3-454 | [グループ](entries/1047/1047300-guruupu.org) | グループ | guruupu | 1047300 | learner | draft | **new** | Editorial review |
| N3-455 | [軍](entries/1247/1247660-gun.org) | ぐん | gun | 1247660 | learner | draft | **new** | Editorial review |
| N3-456 | [軍隊](entries/1248/1248710-guntai.org) | ぐんたい | guntai | 1248710 | learner | draft | **new** | Editorial review |
| N3-457 | [敬意](entries/1250/1250720-keii.org) | けいい | keii | 1250720 | learner | draft | **new** | Editorial review |
| N3-458 | [経営](entries/1251/1251130-keiei.org) | けいえい | keiei | 1251130 | learner | draft | **new** | Editorial review |
| N3-459 | [計画](entries/1252/1252090-keikaku.org) | けいかく | keikaku | 1252090 | learner | draft | **new** | Editorial review |
| N3-460 | [景気](entries/1250/1250830-keiki.org) | けいき | keiki | 1250830 | learner | draft | **new** | Editorial review |
| N3-461 | [経験](entries/1251/1251270-keiken.org) | けいけん | keiken | 1251270 | learner | draft | **new** | Editorial review |
| N3-462 | [傾向](entries/1249/1249470-keikou.org) | けいこう | keikou | 1249470 | learner | draft | **new** | Editorial review |
| N3-463 | [警告](entries/1252/1252360-keikoku.org) | けいこく | keikoku | 1252360 | learner | draft | **new** | Editorial review |
| N3-464 | [計算](entries/1252/1252140-keisan.org) | けいさん | keisan | 1252140 | learner | draft | **new** | Editorial review |
| N3-465 | [掲示](entries/1250/1250620-keiji.org) | けいじ | keiji | 1250620 | learner | draft | **new** | Editorial review |
| N3-466 | [刑事](entries/1249/1249660-keiji.org) | けいじ | keiji | 1249660 | learner | draft | **new** | Editorial review |
| N3-467 | [契約](entries/1250/1250190-keiyaku.org) | けいやく | keiyaku | 1250190 | learner | draft | **new** | Editorial review |
| N3-468 | [経由](entries/1251/1251670-keiyu.org) | けいゆ | keiyu | 1251670 | learner | draft | **new** | Editorial review |
| N3-469 | [怪我](entries/1200/1200220-kega.org) | けが | kega | 1200220 | learner | draft | **new** | Editorial review |
| N3-470 | [化粧](entries/1577/1577040-keshou.org) | けしょう | keshou | 1577040 | learner | draft | **new** | Editorial review |
| N3-471 | [ケチ](entries/2234/2234080-kechi.org) | ケチ | kechi | 2234080 | learner | draft | **new** | Editorial review |
| N3-472 | [結果](entries/1254/1254690-kekka.org) | けっか | kekka | 1254690 | learner | draft | **new** | Editorial review |
| N3-473 | [結局](entries/1254/1254730-kekkyoku.org) | けっきょく | kekkyoku | 1254730 | learner | draft | **new** | Editorial review |
| N3-474 | [決心](entries/1254/1254340-kesshin.org) | けっしん | kesshin | 1254340 | learner | draft | **new** | Editorial review |
| N3-475 | [決定](entries/1254/1254380-kettei.org) | けってい | kettei | 1254380 | learner | draft | **new** | Editorial review |
| N3-476 | [欠点](entries/1254/1254050-ketten.org) | けってん | ketten | 1254050 | learner | draft | **new** | Editorial review |
| N3-477 | [結論](entries/1255/1255020-ketsuron.org) | けつろん | ketsuron | 1255020 | learner | draft | **new** | Editorial review |
| N3-478 | [煙](entries/1177/1177180-kemuri.org) | けむり | kemuri | 1177180 | learner | draft | **new** | Editorial review |
| N3-479 | [県](entries/1258/1258810-ken.org) | けん | ken | 1258810 | learner | draft | **new** | Editorial review |
| N3-480 | [券](entries/1256/1256730-ken.org) | けん | ken | 1256730 | learner | draft | **new** | Editorial review |
| N3-481 | [軒](entries/2078/2078590-ken.org) | けん | ken | 2078590 | learner | draft | **new** | Editorial review |
| N3-482 | [見解](entries/1259/1259390-kenkai.org) | けんかい | kenkai | 1259390 | learner | draft | **new** | Editorial review |
| N3-483 | [健康](entries/1256/1256170-kenkou.org) | けんこう | kenkou | 1256170 | learner | draft | **new** | Editorial review |
| N3-484 | [検査](entries/1257/1257890-kensa.org) | けんさ | kensa | 1257890 | learner | draft | **new** | Editorial review |
| N3-485 | [建設](entries/1257/1257420-kensetsu.org) | けんせつ | kensetsu | 1257420 | learner | draft | **new** | Editorial review |
| N3-486 | [建築](entries/1257/1257500-kenchiku.org) | けんちく | kenchiku | 1257500 | learner | draft | **new** | Editorial review |
| N3-487 | [検討](entries/1258/1258000-kentou.org) | けんとう | kentou | 1258000 | learner | draft | **new** | Editorial review |
| N3-488 | [見当](entries/1259/1259930-kentou.org) | けんとう | kentou | 1259930 | learner | draft | **new** | Editorial review |
| N3-489 | [憲法](entries/1257/1257590-kenpou.org) | けんぽう | kenpou | 1257590 | learner | draft | **new** | Editorial review |
| N3-490 | [権利](entries/1258/1258200-kenri.org) | けんり | kenri | 1258200 | learner | draft | **new** | Editorial review |
| N3-491 | [ケース](entries/1047/1047880-ke-su.org) | ケース | ke-su | 1047880 | learner | draft | **new** | Editorial review |
| N3-492 | [下](entries/2080/2080200-ge.org) | げ | ge | 2080200 | learner | draft | **new** | Editorial review |
| N3-493 | [芸術](entries/1253/1253060-geijutsu.org) | げいじゅつ | geijutsu | 1253060 | learner | draft | **new** | Editorial review |
| N3-494 | [劇](entries/1253/1253310-geki.org) | げき | geki | 1253310 | learner | draft | **new** | Editorial review |
| N3-495 | [劇場](entries/1253/1253410-gekijou.org) | げきじょう | gekijou | 1253410 | learner | draft | **new** | Editorial review |
| N3-496 | [月](entries/2153/2153740-getsu.org) | げつ | getsu | 2153740 | learner | draft | **new** | Editorial review |
| N3-497 | [月曜](entries/1255/1255880-getsuyou.org) | げつよう | getsuyou | 1255880 | learner | draft | **new** | Editorial review |
| N3-498 | [限界](entries/1264/1264650-genkai.org) | げんかい | genkai | 1264650 | learner | draft | **new** | Editorial review |
| N3-499 | [現金](entries/1263/1263550-genkin.org) | げんきん | genkin | 1263550 | learner | draft | **new** | Editorial review |
| N3-500 | [言語](entries/1264/1264420-gengo.org) | げんご | gengo | 1264420 | learner | draft | **new** | Editorial review |
| N3-501 | [現在](entries/1263/1263650-genzai.org) | げんざい | genzai | 1263650 | learner | draft | **new** | Editorial review |
| N3-502 | [現象](entries/1263/1263750-genshou.org) | げんしょう | genshou | 1263750 | learner | draft | **new** | Editorial review |
| N3-503 | [現実](entries/1263/1263710-genjitsu.org) | げんじつ | genjitsu | 1263710 | learner | draft | **new** | Editorial review |
| N3-504 | [現状](entries/1263/1263770-genjou.org) | げんじょう | genjou | 1263770 | learner | draft | **new** | Editorial review |
| N3-505 | [現代](entries/1263/1263810-gendai.org) | げんだい | gendai | 1263810 | learner | draft | **new** | Editorial review |
| N3-506 | [現場](entries/1263/1263760-genba.org) | げんば | genba | 1263760 | learner | draft | **new** | Editorial review |
| N3-507 | [ゲーム](entries/1048/1048400-ge-mu.org) | ゲーム | ge-mu | 1048400 | learner | draft | **new** | Editorial review |
| N3-508 | [恋](entries/1558/1558670-koi.org) | こい | koi | 1558670 | learner | draft | **new** | Editorial review |
| N3-509 | [濃い](entries/1469/1469890-koi.org) | こい | koi | 1469890 | learner | draft | **new** | Editorial review |
| N3-510 | [恋人](entries/1558/1558920-koibito.org) | こいびと | koibito | 1558920 | learner | draft | **new** | Editorial review |
| N3-511 | [幸運](entries/1592/1592930-kouun.org) | こううん | kouun | 1592930 | learner | draft | **new** | Editorial review |
| N3-512 | [講演](entries/1282/1282240-kouen.org) | こうえん | kouen | 1282240 | learner | draft | **new** | Editorial review |
| N3-513 | [効果](entries/1275/1275130-kouka.org) | こうか | kouka | 1275130 | learner | draft | **new** | Editorial review |
| N3-514 | [硬貨](entries/1280/1280530-kouka.org) | こうか | kouka | 1280530 | learner | draft | **new** | Editorial review |
| N3-515 | [高価](entries/1283/1283300-kouka.org) | こうか | kouka | 1283300 | learner | draft | **new** | Editorial review |
| N3-516 | [交換](entries/1271/1271750-koukan.org) | こうかん | koukan | 1271750 | learner | draft | **new** | Editorial review |
| N3-517 | [航空](entries/1281/1281270-koukuu.org) | こうくう | koukuu | 1281270 | learner | draft | **new** | Editorial review |
| N3-518 | [光景](entries/1272/1272950-koukei.org) | こうけい | koukei | 1272950 | learner | draft | **new** | Editorial review |
| N3-519 | [貢献](entries/1282/1282410-kouken.org) | こうけん | kouken | 1282410 | learner | draft | **new** | Editorial review |
| N3-520 | [攻撃](entries/1279/1279170-kougeki.org) | こうげき | kougeki | 1279170 | learner | draft | **new** | Editorial review |
| N3-521 | [広告](entries/1278/1278510-koukoku.org) | こうこく | koukoku | 1278510 | learner | draft | **new** | Editorial review |
| N3-522 | [後者](entries/1269/1269720-kousha.org) | こうしゃ | kousha | 1269720 | learner | draft | **new** | Editorial review |
| N3-523 | [構成](entries/1279/1279730-kousei.org) | こうせい | kousei | 1279730 | learner | draft | **new** | Editorial review |
| N3-524 | [高速](entries/1283/1283700-kousoku.org) | こうそく | kousoku | 1283700 | learner | draft | **new** | Editorial review |
| N3-525 | [行動](entries/1282/1282100-koudou.org) | こうどう | koudou | 1282100 | learner | draft | **new** | Editorial review |
| N3-526 | [幸福](entries/1278/1278400-koufuku.org) | こうふく | koufuku | 1278400 | learner | draft | **new** | Editorial review |
| N3-527 | [公平](entries/1274/1274640-kouhei.org) | こうへい | kouhei | 1274640 | learner | draft | **new** | Editorial review |
| N3-528 | [候補](entries/1272/1272730-kouho.org) | こうほ | kouho | 1272730 | learner | draft | **new** | Editorial review |
| N3-529 | [考慮](entries/1281/1281170-kouryo.org) | こうりょ | kouryo | 1281170 | learner | draft | **new** | Editorial review |
| N3-530 | [越える](entries/1593/1593070-koeru.org) | こえる | koeru | 1593070 | learner | draft | **new** | Editorial review |
| N3-531 | [氷](entries/1488/1488840-koori.org) | こおり | koori | 1488840 | learner | draft | **new** | Editorial review |
| N3-532 | [凍る](entries/1593/1593100-kooru.org) | こおる | kooru | 1593100 | learner | draft | **new** | Editorial review |
| N3-533 | [呼吸](entries/1266/1266470-kokyuu.org) | こきゅう | kokyuu | 1266470 | learner | draft | **new** | Editorial review |
| N3-534 | [国語](entries/1286/1286370-kokugo.org) | こくご | kokugo | 1286370 | learner | draft | **new** | Editorial review |
| N3-535 | [黒板](entries/1288/1288080-kokuban.org) | こくばん | kokuban | 1288080 | learner | draft | **new** | Editorial review |
| N3-536 | [克服](entries/1285/1285790-kokufuku.org) | こくふく | kokufuku | 1285790 | learner | draft | **new** | Editorial review |
| N3-537 | [国民](entries/1287/1287070-kokumin.org) | こくみん | kokumin | 1287070 | learner | draft | **new** | Editorial review |
| N3-538 | [穀物](entries/1287/1287280-kokumotsu.org) | こくもつ | kokumotsu | 1287280 | learner | draft | **new** | Editorial review |
| N3-539 | [腰](entries/1288/1288340-koshi.org) | こし | koshi | 1288340 | learner | draft | **new** | Editorial review |
| N3-540 | [個人](entries/1264/1264770-kojin.org) | こじん | kojin | 1264770 | learner | draft | **new** | Editorial review |
| N3-541 | [越す](entries/1175/1175300-kosu.org) | こす | kosu | 1175300 | learner | draft | **new** | Editorial review |
| N3-542 | [国家](entries/1286/1286170-kokka.org) | こっか | kokka | 1286170 | learner | draft | **new** | Editorial review |
| N3-543 | [国会](entries/1286/1286240-kokkai.org) | こっかい | kokkai | 1286240 | learner | draft | **new** | Editorial review |
| N3-544 | [国境](entries/1286/1286320-kokkyou.org) | こっきょう | kokkyou | 1286320 | learner | draft | **new** | Editorial review |
| N3-545 | [骨折](entries/1288/1288640-kossetsu.org) | こっせつ | kossetsu | 1288640 | learner | draft | **new** | Editorial review |
| N3-546 | [小包](entries/1593/1593290-kozutsumi.org) | こづつみ | kozutsumi | 1593290 | learner | draft | **new** | Editorial review |
| N3-547 | [事](entries/1313/1313580-koto.org) | こと | koto | 1313580 | learner | draft | **new** | Editorial review |
| N3-548 | [異なる](entries/1157/1157510-kotonaru.org) | ことなる | kotonaru | 1157510 | learner | draft | **new** | Editorial review |
| N3-549 | [諺](entries/1264/1264600-kotowaza.org) | ことわざ | kotowaza | 1264600 | learner | draft | **new** | Editorial review |
| N3-550 | [断る](entries/1419/1419570-kotowaru.org) | ことわる | kotowaru | 1419570 | learner | draft | **new** | Editorial review |
| N3-551 | [粉](entries/1504/1504770-kona.org) | こな | kona | 1504770 | learner | draft | **new** | Editorial review |
| N3-552 | [好み](entries/1277/1277500-konomi.org) | このみ | konomi | 1277500 | learner | draft | **new** | Editorial review |
| N3-553 | [好む](entries/1277/1277520-konomu.org) | このむ | konomu | 1277520 | learner | draft | **new** | Editorial review |
| N3-554 | [小麦](entries/1348/1348630-komugi.org) | こむぎ | komugi | 1348630 | learner | draft | **new** | Editorial review |
| N3-555 | [小屋](entries/1347/1347830-koya.org) | こや | koya | 1347830 | learner | draft | **new** | Editorial review |
| N3-556 | [これ等](entries/1004/1004830-korera.org) | これら | korera | 1004830 | learner | draft | **new** | Editorial review |
| N3-557 | [頃](entries/1579/1579080-koro.org) | ころ | koro | 1579080 | learner | draft | **new** | Editorial review |
| N3-558 | [殺す](entries/1299/1299030-korosu.org) | ころす | korosu | 1299030 | learner | draft | **new** | Editorial review |
| N3-559 | [転ぶ](entries/1582/1582130-korobu.org) | ころぶ | korobu | 1582130 | learner | draft | **new** | Editorial review |
| N3-560 | [今回](entries/1289/1289070-konkai.org) | こんかい | konkai | 1289070 | learner | draft | **new** | Editorial review |
| N3-561 | [今後](entries/1289/1289140-kongo.org) | こんご | kongo | 1289140 | learner | draft | **new** | Editorial review |
| N3-562 | [混雑](entries/1290/1290390-konzatsu.org) | こんざつ | konzatsu | 1290390 | learner | draft | **new** | Editorial review |
| N3-563 | [こんなに](entries/1004/1004890-konnani.org) | こんなに | konnani | 1004890 | learner | draft | **new** | Editorial review |
| N3-564 | [困難](entries/1289/1289620-konnan.org) | こんなん | konnan | 1289620 | learner | draft | **new** | Editorial review |
| N3-565 | [今日は](entries/1289/1289400-konnichiha.org) | こんにちは | konnichiha | 1289400 | learner | draft | **new** | Editorial review |
| N3-566 | [婚約](entries/1289/1289710-konyaku.org) | こんやく | konyaku | 1289710 | learner | draft | **new** | Editorial review |
| N3-567 | [混乱](entries/1290/1290560-konran.org) | こんらん | konran | 1290560 | learner | draft | **new** | Editorial review |
| N3-568 | [コーチ](entries/1048/1048910-koochi.org) | コーチ | koochi | 1048910 | learner | draft | **new** | Editorial review |
| N3-569 | [コード](entries/1049/1049010-koodo.org) | コード | koodo | 1049010 | learner | draft | **new** | Editorial review |
| N3-570 | [後](entries/2147/2147630-go.org) | ご | go | 2147630 | learner | draft | **new** | Editorial review |
| N3-571 | [御](entries/1270/1270190-go.org) | ご | go | 1270190 | learner | draft | **new** | Editorial review |
| N3-572 | [語](entries/1270/1270910-go.org) | ご | go | 1270910 | learner | draft | **new** | Editorial review |
| N3-573 | [豪華](entries/1285/1285520-gouka.org) | ごうか | gouka | 1285520 | learner | draft | **new** | Editorial review |
| N3-574 | [合格](entries/1284/1284600-goukaku.org) | ごうかく | goukaku | 1284600 | learner | draft | **new** | Editorial review |
| N3-575 | [合計](entries/1284/1284740-goukei.org) | ごうけい | goukei | 1284740 | learner | draft | **new** | Editorial review |
| N3-576 | [強盗](entries/1236/1236500-goutou.org) | ごうとう | goutou | 1236500 | learner | draft | **new** | Editorial review |
| N3-577 | [誤解](entries/1271/1271310-gokai.org) | ごかい | gokai | 1271310 | learner | draft | **new** | Editorial review |
| N3-578 | [語学](entries/1271/1271010-gogaku.org) | ごがく | gogaku | 1271010 | learner | draft | **new** | Editorial review |
| N3-579 | [ゴミ](entries/1369/1369900-gomi.org) | ごみ | gomi | 1369900 | learner | draft | **new** | Editorial review |
| N3-580 | [御免なさい](entries/1270/1270680-gomennasai.org) | ごめんなさい | gomennasai | 1270680 | learner | draft | **new** | Editorial review |
| N3-581 | [ゴール](entries/1054/1054230-gooru.org) | ゴール | gooru | 1054230 | learner | draft | **new** | Editorial review |
| N3-582 | [差](entries/1291/1291070-sa.org) | さ | sa | 1291070 | learner | draft | **new** | Editorial review |
| N3-583 | [際](entries/1296/1296300-sai.org) | さい | sai | 1296300 | learner | draft | **new** | Editorial review |
| N3-584 | [最高](entries/1293/1293850-saikou.org) | さいこう | saikou | 1293850 | learner | draft | **new** | Editorial review |
| N3-585 | [最終](entries/1293/1293940-saishuu.org) | さいしゅう | saishuu | 1293940 | learner | draft | **new** | Editorial review |
| N3-586 | [最中](entries/1579/1579210-saichuu.org) | さいちゅう | saichuu | 1579210 | learner | draft | **new** | Editorial review |
| N3-587 | [最低](entries/1294/1294220-saitei.org) | さいてい | saitei | 1294220 | learner | draft | **new** | Editorial review |
| N3-588 | [才能](entries/1294/1294630-sainou.org) | さいのう | sainou | 1294630 | learner | draft | **new** | Editorial review |
| N3-589 | [裁判](entries/1296/1296120-saiban.org) | さいばん | saiban | 1296120 | learner | draft | **new** | Editorial review |
| N3-590 | [幸い](entries/1278/1278380-saiwai.org) | さいわい | saiwai | 1278380 | learner | draft | **new** | Editorial review |
| N3-591 | [サイン](entries/1056/1056230-sain.org) | サイン | sain | 1056230 | learner | draft | **new** | Editorial review |
| N3-592 | [境](entries/1235/1235950-sakai.org) | さかい | sakai | 1235950 | learner | draft | **new** | Editorial review |
| N3-593 | [逆らう](entries/1226/1226990-sakarau.org) | さからう | sakarau | 1226990 | learner | draft | **new** | Editorial review |
| N3-594 | [盛り](entries/1379/1379640-sakari.org) | さかり | sakari | 1379640 | learner | draft | **new** | Editorial review |
| N3-595 | [作業](entries/1297/1297540-sagyou.org) | さぎょう | sagyou | 1297540 | learner | draft | **new** | Editorial review |
| N3-596 | [作品](entries/1297/1297910-sakuhin.org) | さくひん | sakuhin | 1297910 | learner | draft | **new** | Editorial review |
| N3-597 | [作物](entries/1297/1297950-sakumotsu.org) | さくもつ | sakumotsu | 1297950 | learner | draft | **new** | Editorial review |
| N3-598 | [桜](entries/1593/1593710-sakura.org) | さくら | sakura | 1593710 | learner | draft | **new** | Editorial review |
| N3-599 | [酒](entries/1329/1329010-sake.org) | さけ | sake | 1329010 | learner | draft | **new** | Editorial review |
| N3-600 | [叫ぶ](entries/1235/1235910-sakebu.org) | さけぶ | sakebu | 1235910 | learner | draft | **new** | Editorial review |
| N3-601 | [避ける](entries/1583/1583260-sakeru.org) | さける | sakeru | 1583260 | learner | draft | **new** | Editorial review |
| N3-602 | [支える](entries/1310/1310090-sasaeru.org) | ささえる | sasaeru | 1310090 | learner | draft | **new** | Editorial review |
| N3-603 | [指す](entries/1309/1309670-sasu.org) | さす | sasu | 1309670 | learner | draft | **new** | Editorial review |
| N3-604 | [誘う](entries/1541/1541900-sasou.org) | さそう | sasou | 1541900 | learner | draft | **new** | Editorial review |
| N3-605 | [作家](entries/1297/1297510-sakka.org) | さっか | sakka | 1297510 | learner | draft | **new** | Editorial review |
| N3-606 | [作曲](entries/1297/1297650-sakkyoku.org) | さっきょく | sakkyoku | 1297650 | learner | draft | **new** | Editorial review |
| N3-607 | [さっぱり](entries/1005/1005210-sappari.org) | さっぱり | sappari | 1005210 | learner | draft | **new** | Editorial review |
| N3-608 | [札](entries/1298/1298960-satsu.org) | さつ | satsu | 1298960 | learner | draft | **new** | Editorial review |
| N3-609 | [偖](entries/1585/1585460-sate.org) | さて | sate | 1585460 | learner | draft | **new** | Editorial review |
| N3-610 | [砂漠](entries/1593/1593800-sabaku.org) | さばく | sabaku | 1593800 | learner | draft | **new** | Editorial review |
| N3-611 | [差別](entries/1291/1291410-sabetsu.org) | さべつ | sabetsu | 1291410 | learner | draft | **new** | Editorial review |
| N3-612 | [作法](entries/1297/1297980-sahou.org) | さほう | sahou | 1297980 | learner | draft | **new** | Editorial review |
| N3-613 | [様々](entries/1593/1593830-samazama.org) | さまざま | samazama | 1593830 | learner | draft | **new** | Editorial review |
| N3-614 | [覚ます](entries/1206/1206060-samasu.org) | さます | samasu | 1206060 | learner | draft | **new** | Editorial review |
| N3-615 | [覚める](entries/1206/1206070-sameru.org) | さめる | sameru | 1206070 | learner | draft | **new** | Editorial review |
| N3-616 | [左右](entries/1290/1290810-sayuu.org) | さゆう | sayuu | 1290810 | learner | draft | **new** | Editorial review |
| N3-617 | [皿](entries/1299/1299680-sara.org) | さら | sara | 1299680 | learner | draft | **new** | Editorial review |
| N3-618 | [更に](entries/1279/1279310-sarani.org) | さらに | sarani | 1279310 | learner | draft | **new** | Editorial review |
| N3-619 | [去る](entries/1231/1231650-saru.org) | さる | saru | 1231650 | learner | draft | **new** | Editorial review |
| N3-620 | [猿](entries/1177/1177390-saru.org) | さる | saru | 1177390 | learner | draft | **new** | Editorial review |
| N3-621 | [騒ぎ](entries/1403/1403020-sawagi.org) | さわぎ | sawagi | 1403020 | learner | draft | **new** | Editorial review |
| N3-622 | [参加](entries/1302/1302090-sanka.org) | さんか | sanka | 1302090 | learner | draft | **new** | Editorial review |
| N3-623 | [参考](entries/1302/1302280-sankou.org) | さんこう | sankou | 1302280 | learner | draft | **new** | Editorial review |
| N3-624 | [賛成](entries/1304/1304200-sansei.org) | さんせい | sansei | 1304200 | learner | draft | **new** | Editorial review |
| N3-625 | [酸素](entries/1304/1304350-sanso.org) | さんそ | sanso | 1304350 | learner | draft | **new** | Editorial review |
| N3-626 | [サービス](entries/1055/1055000-saabisu.org) | さーびす | saabisu | 1055000 | learner | draft | **new** | Editorial review |
| N3-627 | [財産](entries/1296/1296820-zaisan.org) | ざいさん | zaisan | 1296820 | learner | draft | **new** | Editorial review |
| N3-628 | [材料](entries/1296/1296670-zairyou.org) | ざいりょう | zairyou | 1296670 | learner | draft | **new** | Editorial review |
| N3-629 | [座席](entries/1291/1291880-zaseki.org) | ざせき | zaseki | 1291880 | learner | draft | **new** | Editorial review |
| N3-630 | [ざっと](entries/1005/1005390-zatto.org) | ざっと | zatto | 1005390 | learner | draft | **new** | Editorial review |
| N3-631 | [氏](entries/2101/2101130-shi.org) | し | shi | 2101130 | learner | draft | **new** | Editorial review |
| N3-632 | [詩](entries/1929/1929950-shi.org) | し | shi | 1929950 | learner | draft | **new** | Editorial review |
| N3-633 | [幸せ](entries/1594/1594060-shiawase.org) | しあわせ | shiawase | 1594060 | learner | draft | **new** | Editorial review |
| N3-634 | [然も](entries/1506/1506050-shikamo.org) | しかも | shikamo | 1506050 | learner | draft | **new** | Editorial review |
| N3-635 | [叱る](entries/1319/1319580-shikaru.org) | しかる | shikaru | 1319580 | learner | draft | **new** | Editorial review |
| N3-636 | [式](entries/1319/1319060-shiki.org) | しき | shiki | 1319060 | learner | draft | **new** | Editorial review |
| N3-637 | [支給](entries/1310/1310130-shikyuu.org) | しきゅう | shikyuu | 1310130 | learner | draft | **new** | Editorial review |
| N3-638 | [頻りに](entries/1005/1005480-shikirini.org) | しきりに | shikirini | 1005480 | learner | draft | **new** | Editorial review |
| N3-639 | [刺激](entries/1594/1594190-shigeki.org) | しげき | shigeki | 1594190 | learner | draft | **new** | Editorial review |
| N3-640 | [資源](entries/1312/1312720-shigen.org) | しげん | shigen | 1312720 | learner | draft | **new** | Editorial review |
| N3-641 | [支出](entries/1310/1310180-shishutsu.org) | ししゅつ | shishutsu | 1310180 | learner | draft | **new** | Editorial review |
| N3-642 | [詩人](entries/1312/1312220-shijin.org) | しじん | shijin | 1312220 | learner | draft | **new** | Editorial review |
| N3-643 | [沈む](entries/1431/1431670-shizumu.org) | しずむ | shizumu | 1431670 | learner | draft | **new** | Editorial review |
| N3-644 | [自然](entries/1318/1318090-shizen.org) | しぜん | shizen | 1318090 | learner | draft | **new** | Editorial review |
| N3-645 | [思想](entries/1309/1309560-shisou.org) | しそう | shisou | 1309560 | learner | draft | **new** | Editorial review |
| N3-646 | [舌](entries/1387/1387010-shita.org) | した | shita | 1387010 | learner | draft | **new** | Editorial review |
| N3-647 | [従う](entries/1335/1335210-shitagau.org) | したがう | shitagau | 1335210 | learner | draft | **new** | Editorial review |
| N3-648 | [従って](entries/1335/1335230-shitagatte.org) | したがって | shitagatte | 1335230 | learner | draft | **new** | Editorial review |
| N3-649 | [支度](entries/1310/1310260-shitaku.org) | したく | shitaku | 1310260 | learner | draft | **new** | Editorial review |
| N3-650 | [親しい](entries/1365/1365050-shitashii.org) | したしい | shitashii | 1365050 | learner | draft | **new** | Editorial review |
| N3-651 | [次第](entries/1316/1316680-shidai.org) | しだい | shidai | 1316680 | learner | draft | **new** | Editorial review |
| N3-652 | [質](entries/1320/1320640-shitsu.org) | しつ | shitsu | 1320640 | learner | draft | **new** | Editorial review |
| N3-653 | [失業](entries/1319/1319860-shitsugyou.org) | しつぎょう | shitsugyou | 1319860 | learner | draft | **new** | Editorial review |
| N3-654 | [失望](entries/1320/1320170-shitsubou.org) | しつぼう | shitsubou | 1320170 | learner | draft | **new** | Editorial review |
| N3-655 | [支店](entries/1310/1310230-shiten.org) | してん | shiten | 1310230 | learner | draft | **new** | Editorial review |
| N3-656 | [指導](entries/1309/1309950-shidou.org) | しどう | shidou | 1309950 | learner | draft | **new** | Editorial review |
| N3-657 | [品](entries/1583/1583470-shina.org) | しな | shina | 1583470 | learner | draft | **new** | Editorial review |
| N3-658 | [支配](entries/1310/1310270-shihai.org) | しはい | shihai | 1310270 | learner | draft | **new** | Editorial review |
| N3-659 | [支払い](entries/1594/1594480-shiharai.org) | しはらい | shiharai | 1594480 | learner | draft | **new** | Editorial review |
| N3-660 | [支払う](entries/1310/1310300-shiharau.org) | しはらう | shiharau | 1310300 | learner | draft | **new** | Editorial review |
| N3-661 | [芝居](entries/1321/1321630-shibai.org) | しばい | shibai | 1321630 | learner | draft | **new** | Editorial review |
| N3-662 | [屡々](entries/1005/1005580-shibashiba.org) | しばしば | shibashiba | 1005580 | learner | draft | **new** | Editorial review |
| N3-663 | [芝生](entries/1321/1321650-shibafu.org) | しばふ | shibafu | 1321650 | learner | draft | **new** | Editorial review |
| N3-664 | [資本](entries/1312/1312780-shihon.org) | しほん | shihon | 1312780 | learner | draft | **new** | Editorial review |
| N3-665 | [死亡](entries/1310/1310950-shibou.org) | しぼう | shibou | 1310950 | learner | draft | **new** | Editorial review |
| N3-666 | [姉妹](entries/1579/1579490-shimai.org) | しまい | shimai | 1579490 | learner | draft | **new** | Editorial review |
| N3-667 | [仕舞う](entries/1305/1305380-shimau.org) | しまう | shimau | 1305380 | learner | draft | **new** | Editorial review |
| N3-668 | [仕舞った](entries/1005/1005600-shimatta.org) | しまった | shimatta | 1005600 | learner | draft | **new** | Editorial review |
| N3-669 | [示す](entries/1317/1317110-shimesu.org) | しめす | shimesu | 1317110 | learner | draft | **new** | Editorial review |
| N3-670 | [占める](entries/1389/1389460-shimeru.org) | しめる | shimeru | 1389460 | learner | draft | **new** | Editorial review |
| N3-671 | [下](entries/2080/2080210-shimo.org) | しも | shimo | 2080210 | learner | draft | **new** | Editorial review |
| N3-672 | [霜](entries/1402/1402930-shimo.org) | しも | shimo | 1402930 | learner | draft | **new** | Editorial review |
| N3-673 | [借金](entries/1323/1323940-shakkin.org) | しゃっきん | shakkin | 1323940 | learner | draft | **new** | Editorial review |
| N3-674 | [喋る](entries/1427/1427510-shaberu.org) | しゃべる | shaberu | 1427510 | learner | draft | **new** | Editorial review |
| N3-675 | [週](entries/1333/1333450-shuu.org) | しゅう | shuu | 1333450 | learner | draft | **new** | Editorial review |
| N3-676 | [州](entries/1331/1331840-shuu.org) | しゅう | shuu | 1331840 | learner | draft | **new** | Editorial review |
| N3-677 | [周囲](entries/1331/1331030-shuui.org) | しゅうい | shuui | 1331030 | learner | draft | **new** | Editorial review |
| N3-678 | [収穫](entries/1330/1330510-shuukaku.org) | しゅうかく | shuukaku | 1330510 | learner | draft | **new** | Editorial review |
| N3-679 | [週間](entries/1333/1333500-shuukan.org) | しゅうかん | shuukan | 1333500 | learner | draft | **new** | Editorial review |
| N3-680 | [宗教](entries/1331/1331400-shuukyou.org) | しゅうきょう | shuukyou | 1331400 | learner | draft | **new** | Editorial review |
| N3-681 | [就職](entries/1331/1331670-shuushoku.org) | しゅうしょく | shuushoku | 1331670 | learner | draft | **new** | Editorial review |
| N3-682 | [修正](entries/1332/1332130-shuusei.org) | しゅうせい | shuusei | 1332130 | learner | draft | **new** | Editorial review |
| N3-683 | [集団](entries/1333/1333730-shuudan.org) | しゅうだん | shuudan | 1333730 | learner | draft | **new** | Editorial review |
| N3-684 | [集中](entries/1333/1333750-shuuchuu.org) | しゅうちゅう | shuuchuu | 1333750 | learner | draft | **new** | Editorial review |
| N3-685 | [収入](entries/1330/1330790-shuunyuu.org) | しゅうにゅう | shuunyuu | 1330790 | learner | draft | **new** | Editorial review |
| N3-686 | [修理](entries/1332/1332400-shuuri.org) | しゅうり | shuuri | 1332400 | learner | draft | **new** | Editorial review |
| N3-687 | [主義](entries/1325/1325260-shugi.org) | しゅぎ | shugi | 1325260 | learner | draft | **new** | Editorial review |
| N3-688 | [宿泊](entries/1337/1337300-shukuhaku.org) | しゅくはく | shukuhaku | 1337300 | learner | draft | **new** | Editorial review |
| N3-689 | [首相](entries/1329/1329300-shushou.org) | しゅしょう | shushou | 1329300 | learner | draft | **new** | Editorial review |
| N3-690 | [手術](entries/1327/1327790-shujutsu.org) | しゅじゅつ | shujutsu | 1327790 | learner | draft | **new** | Editorial review |
| N3-691 | [手段](entries/1328/1328110-shudan.org) | しゅだん | shudan | 1328110 | learner | draft | **new** | Editorial review |
| N3-692 | [主張](entries/1325/1325910-shuchou.org) | しゅちょう | shuchou | 1325910 | learner | draft | **new** | Editorial review |
| N3-693 | [出身](entries/1339/1339260-shusshin.org) | しゅっしん | shusshin | 1339260 | learner | draft | **new** | Editorial review |
| N3-694 | [出席](entries/1339/1339460-shusseki.org) | しゅっせき | shusseki | 1339460 | learner | draft | **new** | Editorial review |
| N3-695 | [出発](entries/1340/1340000-shuppatsu.org) | しゅっぱつ | shuppatsu | 1340000 | learner | draft | **new** | Editorial review |
| N3-696 | [出版](entries/1340/1340030-shuppan.org) | しゅっぱん | shuppan | 1340030 | learner | draft | **new** | Editorial review |
| N3-697 | [首都](entries/1329/1329340-shuto.org) | しゅと | shuto | 1329340 | learner | draft | **new** | Editorial review |
| N3-698 | [主婦](entries/1326/1326160-shufu.org) | しゅふ | shufu | 1326160 | learner | draft | **new** | Editorial review |
| N3-699 | [主要](entries/1326/1326320-shuyou.org) | しゅよう | shuyou | 1326320 | learner | draft | **new** | Editorial review |
| N3-700 | [種類](entries/1328/1328890-shurui.org) | しゅるい | shurui | 1328890 | learner | draft | **new** | Editorial review |
| N3-701 | [瞬間](entries/1341/1341210-shunkan.org) | しゅんかん | shunkan | 1341210 | learner | draft | **new** | Editorial review |
| N3-702 | [小](entries/2083/2083540-shou.org) | しょう | shou | 2083540 | learner | draft | **new** | Editorial review |
| N3-703 | [章](entries/1351/1351270-shou.org) | しょう | shou | 1351270 | learner | draft | **new** | Editorial review |
| N3-704 | [賞](entries/1351/1351910-shou.org) | しょう | shou | 1351910 | learner | draft | **new** | Editorial review |
| N3-705 | [障害](entries/1352/1352060-shougai.org) | しょうがい | shougai | 1352060 | learner | draft | **new** | Editorial review |
| N3-706 | [奨学金](entries/1347/1347530-shougakukin.org) | しょうがくきん | shougakukin | 1347530 | learner | draft | **new** | Editorial review |
| N3-707 | [正午](entries/1377/1377080-shougo.org) | しょうご | shougo | 1377080 | learner | draft | **new** | Editorial review |
| N3-708 | [少々](entries/1594/1594930-shoushou.org) | しょうしょう | shoushou | 1594930 | learner | draft | **new** | Editorial review |
| N3-709 | [正直](entries/1377/1377590-shoujiki.org) | しょうじき | shoujiki | 1377590 | learner | draft | **new** | Editorial review |
| N3-710 | [少女](entries/1580/1580290-shoujo.org) | しょうじょ | shoujo | 1580290 | learner | draft | **new** | Editorial review |
| N3-711 | [症状](entries/1351/1351030-shoujou.org) | しょうじょう | shoujou | 1351030 | learner | draft | **new** | Editorial review |
| N3-712 | [生じる](entries/1378/1378650-shoujiru.org) | しょうじる | shoujiru | 1378650 | learner | draft | **new** | Editorial review |
| N3-713 | [招待](entries/1349/1349610-shoutai.org) | しょうたい | shoutai | 1349610 | learner | draft | **new** | Editorial review |
| N3-714 | [承知](entries/1349/1349480-shouchi.org) | しょうち | shouchi | 1349480 | learner | draft | **new** | Editorial review |
| N3-715 | [衝突](entries/1351/1351560-shoutotsu.org) | しょうとつ | shoutotsu | 1351560 | learner | draft | **new** | Editorial review |
| N3-716 | [商人](entries/1580/1580270-shounin.org) | しょうにん | shounin | 1580270 | learner | draft | **new** | Editorial review |
| N3-717 | [承認](entries/1349/1349520-shounin.org) | しょうにん | shounin | 1349520 | learner | draft | **new** | Editorial review |
| N3-718 | [少年](entries/1349/1349170-shounen.org) | しょうねん | shounen | 1349170 | learner | draft | **new** | Editorial review |
| N3-719 | [商売](entries/1347/1347200-shoubai.org) | しょうばい | shoubai | 1347200 | learner | draft | **new** | Editorial review |
| N3-720 | [消費](entries/1350/1350290-shouhi.org) | しょうひ | shouhi | 1350290 | learner | draft | **new** | Editorial review |
| N3-721 | [商品](entries/1347/1347310-shouhin.org) | しょうひん | shouhin | 1347310 | learner | draft | **new** | Editorial review |
| N3-722 | [消防](entries/1350/1350340-shoubou.org) | しょうぼう | shoubou | 1350340 | learner | draft | **new** | Editorial review |
| N3-723 | [証明](entries/1351/1351680-shoumei.org) | しょうめい | shoumei | 1351680 | learner | draft | **new** | Editorial review |
| N3-724 | [職](entries/1357/1357480-shoku.org) | しょく | shoku | 1357480 | learner | draft | **new** | Editorial review |
| N3-725 | [職業](entries/1357/1357510-shokugyou.org) | しょくぎょう | shokugyou | 1357510 | learner | draft | **new** | Editorial review |
| N3-726 | [食事](entries/1358/1358490-shokuji.org) | しょくじ | shokuji | 1358490 | learner | draft | **new** | Editorial review |
| N3-727 | [食卓](entries/1358/1358530-shokutaku.org) | しょくたく | shokutaku | 1358530 | learner | draft | **new** | Editorial review |
| N3-728 | [食品](entries/1358/1358600-shokuhin.org) | しょくひん | shokuhin | 1358600 | learner | draft | **new** | Editorial review |
| N3-729 | [植物](entries/1357/1357300-shokubutsu.org) | しょくぶつ | shokubutsu | 1357300 | learner | draft | **new** | Editorial review |
| N3-730 | [食物](entries/1358/1358620-shokumotsu.org) | しょくもつ | shokumotsu | 1358620 | learner | draft | **new** | Editorial review |
| N3-731 | [食欲](entries/1358/1358660-shokuyoku.org) | しょくよく | shokuyoku | 1358660 | learner | draft | **new** | Editorial review |
| N3-732 | [食料](entries/1358/1358670-shokuryou.org) | しょくりょう | shokuryou | 1358670 | learner | draft | **new** | Editorial review |
| N3-733 | [食糧](entries/1358/1358690-shokuryou.org) | しょくりょう | shokuryou | 1358690 | learner | draft | **new** | Editorial review |
| N3-734 | [書斎](entries/1344/1344030-shosai.org) | しょさい | shosai | 1344030 | learner | draft | **new** | Editorial review |
| N3-735 | [署名](entries/1343/1343640-shomei.org) | しょめい | shomei | 1343640 | learner | draft | **new** | Editorial review |
| N3-736 | [書物](entries/1344/1344150-shomotsu.org) | しょもつ | shomotsu | 1344150 | learner | draft | **new** | Editorial review |
| N3-737 | [処理](entries/1342/1342510-shori.org) | しょり | shori | 1342510 | learner | draft | **new** | Editorial review |
| N3-738 | [書類](entries/1344/1344200-shorui.org) | しょるい | shorui | 1344200 | learner | draft | **new** | Editorial review |
| N3-739 | [使用](entries/1306/1306200-shiyou.org) | しよう | shiyou | 1306200 | learner | draft | **new** | Editorial review |
| N3-740 | [知らせ](entries/1420/1420400-shirase.org) | しらせ | shirase | 1420400 | learner | draft | **new** | Editorial review |
| N3-741 | [尻](entries/1358/1358760-shiri.org) | しり | shiri | 1358760 | learner | draft | **new** | Editorial review |
| N3-742 | [印](entries/1168/1168060-shirushi.org) | しるし | shirushi | 1168060 | learner | draft | **new** | Editorial review |
| N3-743 | [城](entries/1355/1355710-shiro.org) | しろ | shiro | 1355710 | learner | draft | **new** | Editorial review |
| N3-744 | [進学](entries/1366/1366010-shingaku.org) | しんがく | shingaku | 1366010 | learner | draft | **new** | Editorial review |
| N3-745 | [神経](entries/1364/1364520-shinkei.org) | しんけい | shinkei | 1364520 | learner | draft | **new** | Editorial review |
| N3-746 | [真剣](entries/1363/1363650-shinken.org) | しんけん | shinken | 1363650 | learner | draft | **new** | Editorial review |
| N3-747 | [信仰](entries/1359/1359150-shinkou.org) | しんこう | shinkou | 1359150 | learner | draft | **new** | Editorial review |
| N3-748 | [深刻](entries/1362/1362730-shinkoku.org) | しんこく | shinkoku | 1362730 | learner | draft | **new** | Editorial review |
| N3-749 | [信号](entries/1359/1359240-shingou.org) | しんごう | shingou | 1359240 | learner | draft | **new** | Editorial review |
| N3-750 | [診察](entries/1365/1365460-shinsatsu.org) | しんさつ | shinsatsu | 1365460 | learner | draft | **new** | Editorial review |
| N3-751 | [信じる](entries/1359/1359040-shinjiru.org) | しんじる | shinjiru | 1359040 | learner | draft | **new** | Editorial review |
| N3-752 | [親戚](entries/1365/1365230-shinseki.org) | しんせき | shinseki | 1365230 | learner | draft | **new** | Editorial review |
| N3-753 | [新鮮](entries/1362/1362100-shinsen.org) | しんせん | shinsen | 1362100 | learner | draft | **new** | Editorial review |
| N3-754 | [心臓](entries/1360/1360770-shinzou.org) | しんぞう | shinzou | 1360770 | learner | draft | **new** | Editorial review |
| N3-755 | [身長](entries/1365/1365770-shinchou.org) | しんちょう | shinchou | 1365770 | learner | draft | **new** | Editorial review |
| N3-756 | [慎重](entries/1361/1361110-shinchou.org) | しんちょう | shinchou | 1361110 | learner | draft | **new** | Editorial review |
| N3-757 | [心配](entries/1360/1360420-shinpai.org) | しんぱい | shinpai | 1360420 | learner | draft | **new** | Editorial review |
| N3-758 | [審判](entries/1360/1360410-shinpan.org) | しんぱん | shinpan | 1360410 | learner | draft | **new** | Editorial review |
| N3-759 | [進歩](entries/1366/1366190-shinpo.org) | しんぽ | shinpo | 1366190 | learner | draft | **new** | Editorial review |
| N3-760 | [親友](entries/1365/1365410-shinyuu.org) | しんゆう | shinyuu | 1365410 | learner | draft | **new** | Editorial review |
| N3-761 | [信用](entries/1359/1359620-shinyou.org) | しんよう | shinyou | 1359620 | learner | draft | **new** | Editorial review |
| N3-762 | [信頼](entries/1359/1359730-shinrai.org) | しんらい | shinrai | 1359730 | learner | draft | **new** | Editorial review |
| N3-763 | [心理](entries/1361/1361000-shinri.org) | しんり | shinri | 1361000 | learner | draft | **new** | Editorial review |
| N3-764 | [ジェット機](entries/1064/1064250-jettoki.org) | ジェットき | jettoki | 1064250 | learner | draft | **new** | Editorial review |
| N3-765 | [直に](entries/1430/1430690-jikani.org) | じかに | jikani | 1430690 | learner | draft | **new** | Editorial review |
| N3-766 | [時期](entries/1316/1316040-jiki.org) | じき | jiki | 1316040 | learner | draft | **new** | Editorial review |
| N3-767 | [事件](entries/1313/1313830-jiken.org) | じけん | jiken | 1313830 | learner | draft | **new** | Editorial review |
| N3-768 | [時刻](entries/1316/1316220-jikoku.org) | じこく | jikoku | 1316220 | learner | draft | **new** | Editorial review |
| N3-769 | [自殺](entries/1317/1317770-jisatsu.org) | じさつ | jisatsu | 1317770 | learner | draft | **new** | Editorial review |
| N3-770 | [自身](entries/1318/1318000-jishin.org) | じしん | jishin | 1318000 | learner | draft | **new** | Editorial review |
| N3-771 | [事実](entries/1313/1313960-jijitsu.org) | じじつ | jijitsu | 1313960 | learner | draft | **new** | Editorial review |
| N3-772 | [事情](entries/1314/1314010-jijou.org) | じじょう | jijou | 1314010 | learner | draft | **new** | Editorial review |
| N3-773 | [事態](entries/1595/1595240-jitai.org) | じたい | jitai | 1595240 | learner | draft | **new** | Editorial review |
| N3-774 | [実験](entries/1320/1320970-jikken.org) | じっけん | jikken | 1320970 | learner | draft | **new** | Editorial review |
| N3-775 | [実行](entries/1321/1321040-jikkou.org) | じっこう | jikkou | 1321040 | learner | draft | **new** | Editorial review |
| N3-776 | [実際](entries/1321/1321110-jissai.org) | じっさい | jissai | 1321110 | learner | draft | **new** | Editorial review |
| N3-777 | [実施](entries/1321/1321140-jisshi.org) | じっし | jisshi | 1321140 | learner | draft | **new** | Editorial review |
| N3-778 | [凝乎と](entries/1005/1005870-jitto.org) | じっと | jitto | 1005870 | learner | draft | **new** | Editorial review |
| N3-779 | [実現](entries/1321/1321020-jitsugen.org) | じつげん | jitsugen | 1321020 | learner | draft | **new** | Editorial review |
| N3-780 | [実は](entries/1320/1320830-jitsuha.org) | じつは | jitsuha | 1320830 | learner | draft | **new** | Editorial review |
| N3-781 | [自動](entries/1318/1318340-jidou.org) | じどう | jidou | 1318340 | learner | draft | **new** | Editorial review |
| N3-782 | [自慢](entries/1318/1318680-jiman.org) | じまん | jiman | 1318680 | learner | draft | **new** | Editorial review |
| N3-783 | [事務](entries/1314/1314270-jimu.org) | じむ | jimu | 1314270 | learner | draft | **new** | Editorial review |
| N3-784 | [邪魔](entries/1323/1323500-jama.org) | じゃま | jama | 1323500 | learner | draft | **new** | Editorial review |
| N3-785 | [銃](entries/1337/1337000-juu.org) | じゅう | juu | 1337000 | learner | draft | **new** | Editorial review |
| N3-786 | [重視](entries/1336/1336260-juushi.org) | じゅうし | juushi | 1336260 | learner | draft | **new** | Editorial review |
| N3-787 | [渋滞](entries/1335/1335570-juutai.org) | じゅうたい | juutai | 1335570 | learner | draft | **new** | Editorial review |
| N3-788 | [住宅](entries/1334/1334150-juutaku.org) | じゅうたく | juutaku | 1334150 | learner | draft | **new** | Editorial review |
| N3-789 | [重大](entries/1336/1336500-juudai.org) | じゅうだい | juudai | 1336500 | learner | draft | **new** | Editorial review |
| N3-790 | [住民](entries/1334/1334210-juumin.org) | じゅうみん | juumin | 1334210 | learner | draft | **new** | Editorial review |
| N3-791 | [重要](entries/1336/1336820-juuyou.org) | じゅうよう | juuyou | 1336820 | learner | draft | **new** | Editorial review |
| N3-792 | [需要](entries/1330/1330450-juyou.org) | じゅよう | juyou | 1330450 | learner | draft | **new** | Editorial review |
| N3-793 | [順](entries/1342/1342220-jun.org) | じゅん | jun | 1342220 | learner | draft | **new** | Editorial review |
| N3-794 | [順調](entries/1342/1342380-junchou.org) | じゅんちょう | junchou | 1342380 | learner | draft | **new** | Editorial review |
| N3-795 | [順番](entries/1342/1342390-junban.org) | じゅんばん | junban | 1342390 | learner | draft | **new** | Editorial review |
| N3-796 | [準備](entries/1341/1341670-junbi.org) | じゅんび | junbi | 1341670 | learner | draft | **new** | Editorial review |
| N3-797 | [ジュース](entries/1065/1065950-juusu.org) | じゅーす | juusu | 1065950 | learner | draft | **new** | Editorial review |
| N3-798 | [上](entries/1352/1352170-jou.org) | じょう | jou | 1352170 | learner | draft | **new** | Editorial review |
| N3-799 | [乗客](entries/1580/1580490-joukyaku.org) | じょうきゃく | joukyaku | 1580490 | learner | draft | **new** | Editorial review |
| N3-800 | [状況](entries/1356/1356700-joukyou.org) | じょうきょう | joukyou | 1356700 | learner | draft | **new** | Editorial review |
| N3-801 | [上京](entries/1352/1352980-joukyou.org) | じょうきょう | joukyou | 1352980 | learner | draft | **new** | Editorial review |
| N3-802 | [条件](entries/1356/1356510-jouken.org) | じょうけん | jouken | 1356510 | learner | draft | **new** | Editorial review |
| N3-803 | [常識](entries/1356/1356000-joushiki.org) | じょうしき | joushiki | 1356000 | learner | draft | **new** | Editorial review |
| N3-804 | [状態](entries/1356/1356730-joutai.org) | じょうたい | joutai | 1356730 | learner | draft | **new** | Editorial review |
| N3-805 | [上達](entries/1353/1353850-joutatsu.org) | じょうたつ | joutatsu | 1353850 | learner | draft | **new** | Editorial review |
| N3-806 | [冗談](entries/1355/1355540-joudan.org) | じょうだん | joudan | 1355540 | learner | draft | **new** | Editorial review |
| N3-807 | [上等](entries/1354/1354030-joutou.org) | じょうとう | joutou | 1354030 | learner | draft | **new** | Editorial review |
| N3-808 | [情報](entries/1356/1356370-jouhou.org) | じょうほう | jouhou | 1356370 | learner | draft | **new** | Editorial review |
| N3-809 | [女王](entries/1345/1345020-joou.org) | じょおう | joou | 1345020 | learner | draft | **new** | Editorial review |
| N3-810 | [助手](entries/1344/1344650-joshu.org) | じょしゅ | joshu | 1344650 | learner | draft | **new** | Editorial review |
| N3-811 | [徐々](entries/1345/1345600-jojo.org) | じょじょ | jojo | 1345600 | learner | draft | **new** | Editorial review |
| N3-812 | [女優](entries/1345/1345430-joyuu.org) | じょゆう | joyuu | 1345430 | learner | draft | **new** | Editorial review |
| N3-813 | [人工](entries/1367/1367380-jinkou.org) | じんこう | jinkou | 1367380 | learner | draft | **new** | Editorial review |
| N3-814 | [人種](entries/1368/1368020-jinshu.org) | じんしゅ | jinshu | 1368020 | learner | draft | **new** | Editorial review |
| N3-815 | [人生](entries/1368/1368370-jinsei.org) | じんせい | jinsei | 1368370 | learner | draft | **new** | Editorial review |
| N3-816 | [人物](entries/1369/1369070-jinbutsu.org) | じんぶつ | jinbutsu | 1369070 | learner | draft | **new** | Editorial review |
| N3-817 | [人類](entries/1369/1369530-jinrui.org) | じんるい | jinrui | 1369530 | learner | draft | **new** | Editorial review |
| N3-818 | [ジーンズ](entries/1064/1064120-jiinzu.org) | じーんず | jiinzu | 1064120 | learner | draft | **new** | Editorial review |
| N3-819 | [州](entries/1331/1331850-su.org) | す | su | 1331850 | learner | draft | **new** | Editorial review |
| N3-820 | [巣](entries/1400/1400390-su.org) | す | su | 1400390 | learner | draft | **new** | Editorial review |
| N3-821 | [水準](entries/1371/1371610-suijun.org) | すいじゅん | suijun | 1371610 | learner | draft | **new** | Editorial review |
| N3-822 | [推薦](entries/1371/1371170-suisen.org) | すいせん | suisen | 1371170 | learner | draft | **new** | Editorial review |
| N3-823 | [スイッチ](entries/1067/1067210-suitchi.org) | すいっち | suitchi | 1067210 | learner | draft | **new** | Editorial review |
| N3-824 | [睡眠](entries/1372/1372370-suimin.org) | すいみん | suimin | 1372370 | learner | draft | **new** | Editorial review |
| N3-825 | [数](entries/1580/1580825-suu.org) | すう | suu | 1580825 | learner | draft | **new** | Editorial review |
| N3-826 | [数字](entries/1373/1373060-suuji.org) | すうじ | suuji | 1373060 | learner | draft | **new** | Editorial review |
| N3-827 | [末](entries/1525/1525250-sue.org) | すえ | sue | 1525250 | learner | draft | **new** | Editorial review |
| N3-828 | [姿](entries/1307/1307710-sugata.org) | すがた | sugata | 1307710 | learner | draft | **new** | Editorial review |
| N3-829 | [スキー](entries/1067/1067770-sukii.org) | すきー | sukii | 1067770 | learner | draft | **new** | Editorial review |
| N3-830 | [空く](entries/1586/1586265-suku.org) | すく | suku | 1586265 | learner | draft | **new** | Editorial review |
| N3-831 | [救う](entries/1229/1229060-sukuu.org) | すくう | sukuu | 1229060 | learner | draft | **new** | Editorial review |
| N3-832 | [優れる](entries/1539/1539080-sugureru.org) | すぐれる | sugureru | 1539080 | learner | draft | **new** | Editorial review |
| N3-833 | [スケート](entries/1068/1068770-sukeeto.org) | すけーと | sukeeto | 1068770 | learner | draft | **new** | Editorial review |
| N3-834 | [少しも](entries/1348/1348900-sukoshimo.org) | すこしも | sukoshimo | 1348900 | learner | draft | **new** | Editorial review |
| N3-835 | [過ごす](entries/1196/1196000-sugosu.org) | すごす | sugosu | 1196000 | learner | draft | **new** | Editorial review |
| N3-836 | [筋](entries/1241/1241750-suji.org) | すじ | suji | 1241750 | learner | draft | **new** | Editorial review |
| N3-837 | [進める](entries/1365/1365990-susumeru.org) | すすめる | susumeru | 1365990 | learner | draft | **new** | Editorial review |
| N3-838 | [勧める](entries/1595/1595680-susumeru.org) | すすめる | susumeru | 1595680 | learner | draft | **new** | Editorial review |
| N3-839 | [スタイル](entries/1069/1069520-sutairu.org) | すたいる | sutairu | 1069520 | learner | draft | **new** | Editorial review |
| N3-840 | [スタンド](entries/1069/1069930-sutando.org) | すたんど | sutando | 1069930 | learner | draft | **new** | Editorial review |
| N3-841 | [スター](entries/1069/1069210-sutaa.org) | すたー | sutaa | 1069210 | learner | draft | **new** | Editorial review |
| N3-842 | [素敵](entries/1397/1397350-suteki.org) | すてき | suteki | 1397350 | learner | draft | **new** | Editorial review |
| N3-843 | [既に](entries/1220/1220310-sudeni.org) | すでに | sudeni | 1220310 | learner | draft | **new** | Editorial review |
| N3-844 | [即ち](entries/1404/1404100-sunawachi.org) | すなわち | sunawachi | 1404100 | learner | draft | **new** | Editorial review |
| N3-845 | [素晴らしい](entries/1397/1397300-subarashii.org) | すばらしい | subarashii | 1397300 | learner | draft | **new** | Editorial review |
| N3-846 | [スピーチ](entries/1072/1072260-supiichi.org) | すぴーち | supiichi | 1072260 | learner | draft | **new** | Editorial review |
| N3-847 | [全て](entries/1595/1595730-subete.org) | すべて | subete | 1595730 | learner | draft | **new** | Editorial review |
| N3-848 | [済ませる](entries/1295/1295040-sumaseru.org) | すませる | sumaseru | 1295040 | learner | draft | **new** | Editorial review |
| N3-849 | [済みません](entries/1295/1295060-sumimasen.org) | すみません | sumimasen | 1295060 | learner | draft | **new** | Editorial review |
| N3-850 | [鋭い](entries/1174/1174890-surudoi.org) | するどい | surudoi | 1174890 | learner | draft | **new** | Editorial review |
| N3-851 | [スープ](entries/1067/1067040-suupu.org) | すーぷ | suupu | 1067040 | learner | draft | **new** | Editorial review |
| N3-852 | [図](entries/1370/1370320-zu.org) | ず | zu | 1370320 | learner | draft | **new** | Editorial review |
| N3-853 | [随分](entries/1372/1372800-zuibun.org) | ずいぶん | zuibun | 1372800 | learner | draft | **new** | Editorial review |
| N3-854 | [ずっと](entries/1006/1006380-zutto.org) | ずっと | zutto | 1006380 | learner | draft | **new** | Editorial review |
| N3-855 | [頭痛](entries/1450/1450890-zutsuu.org) | ずつう | zutsuu | 1450890 | learner | draft | **new** | Editorial review |
| N3-856 | [正](entries/1376/1376590-sei.org) | せい | sei | 1376590 | learner | draft | **new** | Editorial review |
| N3-857 | [背](entries/1472/1472650-sei.org) | せい | sei | 1472650 | learner | draft | **new** | Editorial review |
| N3-858 | [所為](entries/1610/1610040-sei.org) | せい | sei | 1610040 | learner | draft | **new** | Editorial review |
| N3-859 | [性](entries/1375/1375260-sei.org) | せい | sei | 1375260 | learner | draft | **new** | Editorial review |
| N3-860 | [性格](entries/1375/1375290-seikaku.org) | せいかく | seikaku | 1375290 | learner | draft | **new** | Editorial review |
| N3-861 | [正確](entries/1376/1376760-seikaku.org) | せいかく | seikaku | 1376760 | learner | draft | **new** | Editorial review |
| N3-862 | [世紀](entries/1373/1373990-seiki.org) | せいき | seiki | 1373990 | learner | draft | **new** | Editorial review |
| N3-863 | [請求](entries/1381/1381320-seikyuu.org) | せいきゅう | seikyuu | 1381320 | learner | draft | **new** | Editorial review |
| N3-864 | [清潔](entries/1378/1378200-seiketsu.org) | せいけつ | seiketsu | 1378200 | learner | draft | **new** | Editorial review |
| N3-865 | [制限](entries/1374/1374700-seigen.org) | せいげん | seigen | 1374700 | learner | draft | **new** | Editorial review |
| N3-866 | [成功](entries/1375/1375690-seikou.org) | せいこう | seikou | 1375690 | learner | draft | **new** | Editorial review |
| N3-867 | [正式](entries/1377/1377290-seishiki.org) | せいしき | seishiki | 1377290 | learner | draft | **new** | Editorial review |
| N3-868 | [精神](entries/1379/1379950-seishin.org) | せいしん | seishin | 1379950 | learner | draft | **new** | Editorial review |
| N3-869 | [成人](entries/1375/1375740-seijin.org) | せいじん | seijin | 1375740 | learner | draft | **new** | Editorial review |
| N3-870 | [成績](entries/1375/1375760-seiseki.org) | せいせき | seiseki | 1375760 | learner | draft | **new** | Editorial review |
| N3-871 | [精々](entries/1596/1596050-seizei.org) | せいぜい | seizei | 1596050 | learner | draft | **new** | Editorial review |
| N3-872 | [製造](entries/1380/1380690-seizou.org) | せいぞう | seizou | 1380690 | learner | draft | **new** | Editorial review |
| N3-873 | [成長](entries/1375/1375790-seichou.org) | せいちょう | seichou | 1375790 | learner | draft | **new** | Editorial review |
| N3-874 | [制度](entries/1374/1374880-seido.org) | せいど | seido | 1374880 | learner | draft | **new** | Editorial review |
| N3-875 | [青年](entries/1381/1381750-seinen.org) | せいねん | seinen | 1381750 | learner | draft | **new** | Editorial review |
| N3-876 | [製品](entries/1380/1380760-seihin.org) | せいひん | seihin | 1380760 | learner | draft | **new** | Editorial review |
| N3-877 | [政府](entries/1376/1376070-seifu.org) | せいふ | seifu | 1376070 | learner | draft | **new** | Editorial review |
| N3-878 | [生物](entries/1379/1379430-seibutsu.org) | せいぶつ | seibutsu | 1379430 | learner | draft | **new** | Editorial review |
| N3-879 | [生命](entries/1379/1379530-seimei.org) | せいめい | seimei | 1379530 | learner | draft | **new** | Editorial review |
| N3-880 | [整理](entries/1376/1376250-seiri.org) | せいり | seiri | 1376250 | learner | draft | **new** | Editorial review |
| N3-881 | [咳](entries/1204/1204300-seki.org) | せき | seki | 1204300 | learner | draft | **new** | Editorial review |
| N3-882 | [石炭](entries/1382/1382700-sekitan.org) | せきたん | sekitan | 1382700 | learner | draft | **new** | Editorial review |
| N3-883 | [責任](entries/1383/1383180-sekinin.org) | せきにん | sekinin | 1383180 | learner | draft | **new** | Editorial review |
| N3-884 | [石油](entries/1382/1382830-sekiyu.org) | せきゆ | sekiyu | 1382830 | learner | draft | **new** | Editorial review |
| N3-885 | [世間](entries/1373/1373970-seken.org) | せけん | seken | 1373970 | learner | draft | **new** | Editorial review |
| N3-886 | [積極的](entries/1383/1383030-sekkyokuteki.org) | せっきょくてき | sekkyokuteki | 1383030 | learner | draft | **new** | Editorial review |
| N3-887 | [設計](entries/1386/1386020-sekkei.org) | せっけい | sekkei | 1386020 | learner | draft | **new** | Editorial review |
| N3-888 | [セット](entries/1074/1074600-setto.org) | セット | setto | 1074600 | learner | draft | **new** | Editorial review |
| N3-889 | [説](entries/1386/1386370-setsu.org) | せつ | setsu | 1386370 | learner | draft | **new** | Editorial review |
| N3-890 | [設備](entries/1386/1386070-setsubi.org) | せつび | setsubi | 1386070 | learner | draft | **new** | Editorial review |
| N3-891 | [節約](entries/1386/1386350-setsuyaku.org) | せつやく | setsuyaku | 1386350 | learner | draft | **new** | Editorial review |
| N3-892 | [責める](entries/1383/1383160-semeru.org) | せめる | semeru | 1383160 | learner | draft | **new** | Editorial review |
| N3-893 | [世話](entries/1374/1374300-sewa.org) | せわ | sewa | 1374300 | learner | draft | **new** | Editorial review |
| N3-894 | [専攻](entries/1389/1389780-senkou.org) | せんこう | senkou | 1389780 | learner | draft | **new** | Editorial review |
| N3-895 | [選手](entries/1392/1392250-senshu.org) | せんしゅ | senshu | 1392250 | learner | draft | **new** | Editorial review |
| N3-896 | [先日](entries/1388/1388300-senjitsu.org) | せんじつ | senjitsu | 1388300 | learner | draft | **new** | Editorial review |
| N3-897 | [選択](entries/1392/1392290-sentaku.org) | せんたく | sentaku | 1392290 | learner | draft | **new** | Editorial review |
| N3-898 | [センター](entries/1075/1075040-sentaa.org) | センター | sentaa | 1075040 | learner | draft | **new** | Editorial review |
| N3-899 | [税](entries/2081/2081570-zei.org) | ぜい | zei | 2081570 | learner | draft | **new** | Editorial review |
| N3-900 | [税金](entries/1382/1382100-zeikin.org) | ぜいきん | zeikin | 1382100 | learner | draft | **new** | Editorial review |
| N3-901 | [贅沢](entries/1573/1573150-zeitaku.org) | ぜいたく | zeitaku | 1573150 | learner | draft | **new** | Editorial review |
| N3-902 | [絶対](entries/1386/1386840-zettai.org) | ぜったい | zettai | 1386840 | learner | draft | **new** | Editorial review |
| N3-903 | [是非](entries/1374/1374530-zehi.org) | ぜひ | zehi | 1374530 | learner | draft | **new** | Editorial review |
| N3-904 | [善](entries/1394/1394250-zen.org) | ぜん | zen | 1394250 | learner | draft | **new** | Editorial review |
| N3-905 | [全員](entries/1394/1394840-zenin.org) | ぜんいん | zenin | 1394840 | learner | draft | **new** | Editorial review |
| N3-906 | [全国](entries/1581/1581180-zenkoku.org) | ぜんこく | zenkoku | 1581180 | learner | draft | **new** | Editorial review |
| N3-907 | [前者](entries/1393/1393090-zensha.org) | ぜんしゃ | zensha | 1393090 | learner | draft | **new** | Editorial review |
| N3-908 | [前進](entries/1393/1393350-zenshin.org) | ぜんしん | zenshin | 1393350 | learner | draft | **new** | Editorial review |
| N3-909 | [全然](entries/1395/1395620-zenzen.org) | ぜんぜん | zenzen | 1395620 | learner | draft | **new** | Editorial review |
| N3-910 | [全体](entries/1395/1395660-zentai.org) | ぜんたい | zentai | 1395660 | learner | draft | **new** | Editorial review |
| N3-911 | [騒音](entries/1403/1403060-souon.org) | そうおん | souon | 1403060 | learner | draft | **new** | Editorial review |
| N3-912 | [操作](entries/1400/1400050-sousa.org) | そうさ | sousa | 1400050 | learner | draft | **new** | Editorial review |
| N3-913 | [想像](entries/1399/1399610-souzou.org) | そうぞう | souzou | 1399610 | learner | draft | **new** | Editorial review |
| N3-914 | [相続](entries/1401/1401090-souzoku.org) | そうぞく | souzoku | 1401090 | learner | draft | **new** | Editorial review |
| N3-915 | [相談](entries/1401/1401210-soudan.org) | そうだん | soudan | 1401210 | learner | draft | **new** | Editorial review |
| N3-916 | [装置](entries/1402/1402360-souchi.org) | そうち | souchi | 1402360 | learner | draft | **new** | Editorial review |
| N3-917 | [相当](entries/1401/1401240-soutou.org) | そうとう | soutou | 1401240 | learner | draft | **new** | Editorial review |
| N3-918 | [速度](entries/1405/1405050-sokudo.org) | そくど | sokudo | 1405050 | learner | draft | **new** | Editorial review |
| N3-919 | [底](entries/1436/1436050-soko.org) | そこ | soko | 1436050 | learner | draft | **new** | Editorial review |
| N3-920 | [其処で](entries/1406/1406090-sokode.org) | そこで | sokode | 1406090 | learner | draft | **new** | Editorial review |
| N3-921 | [組織](entries/1397/1397630-soshiki.org) | そしき | soshiki | 1397630 | learner | draft | **new** | Editorial review |
| N3-922 | [注ぐ](entries/1581/1581730-sosogu.org) | そそぐ | sosogu | 1581730 | learner | draft | **new** | Editorial review |
| N3-923 | [育つ](entries/1160/1160540-sodatsu.org) | そだつ | sodatsu | 1160540 | learner | draft | **new** | Editorial review |
| N3-924 | [そっくり](entries/1006/1006790-sokkuri.org) | そっくり | sokkuri | 1006790 | learner | draft | **new** | Editorial review |
| N3-925 | [率土](entries/1551/1551230-sotto.org) | そっと | sotto | 1551230 | learner | draft | **new** | Editorial review |
| N3-926 | [袖](entries/1406/1406000-sode.org) | そで | sode | 1406000 | learner | draft | **new** | Editorial review |
| N3-927 | [備える](entries/1244/1244960-sonaeru.org) | そなえる | sonaeru | 1244960 | learner | draft | **new** | Editorial review |
| N3-928 | [その内](entries/1006/1006930-sonouchi.org) | そのうち | sonouchi | 1006930 | learner | draft | **new** | Editorial review |
| N3-929 | [其のまま](entries/1406/1406030-sonomama.org) | そのまま | sonomama | 1406030 | learner | draft | **new** | Editorial review |
| N3-930 | [ソファ](entries/1075/1075480-sofa.org) | ソファ | sofa | 1075480 | learner | draft | **new** | Editorial review |
| N3-931 | [粗末](entries/1397/1397100-somatsu.org) | そまつ | somatsu | 1397100 | learner | draft | **new** | Editorial review |
| N3-932 | [其れ其れ](entries/1596/1596690-sorezore.org) | それぞれ | sorezore | 1596690 | learner | draft | **new** | Editorial review |
| N3-933 | [其れでも](entries/1406/1406060-soredemo.org) | それでも | soredemo | 1406060 | learner | draft | **new** | Editorial review |
| N3-934 | [其れとも](entries/1007/1007010-soretomo.org) | それとも | soretomo | 1007010 | learner | draft | **new** | Editorial review |
| N3-935 | [損](entries/1406/1406660-son.org) | そん | son | 1406660 | learner | draft | **new** | Editorial review |
| N3-936 | [損害](entries/1406/1406710-songai.org) | そんがい | songai | 1406710 | learner | draft | **new** | Editorial review |
| N3-937 | [尊敬](entries/1406/1406400-sonkei.org) | そんけい | sonkei | 1406400 | learner | draft | **new** | Editorial review |
| N3-938 | [存在](entries/1406/1406150-sonzai.org) | そんざい | sonzai | 1406150 | learner | draft | **new** | Editorial review |
| N3-939 | [尊重](entries/1406/1406460-sonchou.org) | そんちょう | sonchou | 1406460 | learner | draft | **new** | Editorial review |
| N3-940 | [象](entries/1351/1351830-zou.org) | ぞう | zou | 1351830 | learner | draft | **new** | Editorial review |
| N3-941 | [増加](entries/1403/1403160-zouka.org) | ぞうか | zouka | 1403160 | learner | draft | **new** | Editorial review |
| N3-942 | [田](entries/1442/1442730-ta.org) | た | ta | 1442730 | learner | draft | **new** | Editorial review |
| N3-943 | [他](entries/1949/1949190-ta.org) | た | ta | 1949190 | learner | draft | **new** | Editorial review |
| N3-944 | [体育](entries/1409/1409200-taiiku.org) | たいいく | taiiku | 1409200 | learner | draft | **new** | Editorial review |
| N3-945 | [体温](entries/1409/1409250-taion.org) | たいおん | taion | 1409250 | learner | draft | **new** | Editorial review |
| N3-946 | [大会](entries/1413/1413180-taikai.org) | たいかい | taikai | 1413180 | learner | draft | **new** | Editorial review |
| N3-947 | [退屈](entries/1596/1596750-taikutsu.org) | たいくつ | taikutsu | 1596750 | learner | draft | **new** | Editorial review |
| N3-948 | [滞在](entries/1410/1410930-taizai.org) | たいざい | taizai | 1410930 | learner | draft | **new** | Editorial review |
| N3-949 | [大使](entries/1413/1413880-taishi.org) | たいし | taishi | 1413880 | learner | draft | **new** | Editorial review |
| N3-950 | [大した](entries/1412/1412960-taishita.org) | たいした | taishita | 1412960 | learner | draft | **new** | Editorial review |
| N3-951 | [対象](entries/1410/1410120-taishou.org) | たいしょう | taishou | 1410120 | learner | draft | **new** | Editorial review |
| N3-952 | [対する](entries/1610/1610160-taisuru.org) | たいする | taisuru | 1610160 | learner | draft | **new** | Editorial review |
| N3-953 | [大戦](entries/1414/1414360-taisen.org) | たいせん | taisen | 1414360 | learner | draft | **new** | Editorial review |
| N3-954 | [態度](entries/1410/1410780-taido.org) | たいど | taido | 1410780 | learner | draft | **new** | Editorial review |
| N3-955 | [大半](entries/1414/1414790-taihan.org) | たいはん | taihan | 1414790 | learner | draft | **new** | Editorial review |
| N3-956 | [タイプライター](entries/1075/1075960-taipuraitaa.org) | タイプライター | taipuraitaa | 1075960 | learner | draft | **new** | Editorial review |
| N3-957 | [逮捕](entries/1411/1411470-taiho.org) | たいほ | taiho | 1411470 | learner | draft | **new** | Editorial review |
| N3-958 | [太陽](entries/1408/1408370-taiyou.org) | たいよう | taiyou | 1408370 | learner | draft | **new** | Editorial review |
| N3-959 | [平ら](entries/1506/1506930-taira.org) | たいら | taira | 1506930 | learner | draft | **new** | Editorial review |
| N3-960 | [大陸](entries/1415/1415150-tairiku.org) | たいりく | tairiku | 1415150 | learner | draft | **new** | Editorial review |
| N3-961 | [倒す](entries/1445/1445770-taosu.org) | たおす | taosu | 1445770 | learner | draft | **new** | Editorial review |
| N3-962 | [タオル](entries/1076/1076170-taoru.org) | タオル | taoru | 1076170 | learner | draft | **new** | Editorial review |
| N3-963 | [宝](entries/1516/1516160-takara.org) | たから | takara | 1516160 | learner | draft | **new** | Editorial review |
| N3-964 | [互い](entries/1268/1268770-tagai.org) | たがい | tagai | 1268770 | learner | draft | **new** | Editorial review |
| N3-965 | [宅](entries/1415/1415750-taku.org) | たく | taku | 1415750 | learner | draft | **new** | Editorial review |
| N3-966 | [確かめる](entries/1205/1205780-tashikameru.org) | たしかめる | tashikameru | 1205780 | learner | draft | **new** | Editorial review |
| N3-967 | [多少](entries/1407/1407810-tashou.org) | たしょう | tashou | 1407810 | learner | draft | **new** | Editorial review |
| N3-968 | [助ける](entries/1344/1344410-tasukeru.org) | たすける | tasukeru | 1344410 | learner | draft | **new** | Editorial review |
| N3-969 | [戦い](entries/1596/1596950-tatakai.org) | たたかい | tatakai | 1596950 | learner | draft | **new** | Editorial review |
| N3-970 | [戦う](entries/1596/1596960-tatakau.org) | たたかう | tatakau | 1596960 | learner | draft | **new** | Editorial review |
| N3-971 | [叩く](entries/1416/1416170-tataku.org) | たたく | tataku | 1416170 | learner | draft | **new** | Editorial review |
| N3-972 | [只](entries/1538/1538900-tada.org) | ただ | tada | 1538900 | learner | draft | **new** | Editorial review |
| N3-973 | [直ちに](entries/1430/1430670-tadachini.org) | ただちに | tadachini | 1430670 | learner | draft | **new** | Editorial review |
| N3-974 | [立ち上がる](entries/1551/1551370-tachiagaru.org) | たちあがる | tachiagaru | 1551370 | learner | draft | **new** | Editorial review |
| N3-975 | [立場](entries/1551/1551710-tachiba.org) | たちば | tachiba | 1551710 | learner | draft | **new** | Editorial review |
| N3-976 | [達する](entries/1416/1416230-tassuru.org) | たっする | tassuru | 1416230 | learner | draft | **new** | Editorial review |
| N3-977 | [たった](entries/1007/1007230-tatta.org) | たった | tatta | 1007230 | learner | draft | **new** | Editorial review |
| N3-978 | [たっぷり](entries/1007/1007240-tappuri.org) | たっぷり | tappuri | 1007240 | learner | draft | **new** | Editorial review |
| N3-979 | [経つ](entries/1251/1251100-tatsu.org) | たつ | tatsu | 1251100 | learner | draft | **new** | Editorial review |
| N3-980 | [例え](entries/1597/1597120-tatoe.org) | たとえ | tatoe | 1597120 | learner | draft | **new** | Editorial review |
| N3-981 | [谷](entries/1581/1581590-tani.org) | たに | tani | 1581590 | learner | draft | **new** | Editorial review |
| N3-982 | [他人](entries/1581/1581400-tanin.org) | たにん | tanin | 1581400 | learner | draft | **new** | Editorial review |
| N3-983 | [種](entries/1328/1328820-tane.org) | たね | tane | 1328820 | learner | draft | **new** | Editorial review |
| N3-984 | [束](entries/1404/1404450-taba.org) | たば | taba | 1404450 | learner | draft | **new** | Editorial review |
| N3-985 | [度](entries/1445/1445150-tabi.org) | たび | tabi | 1445150 | learner | draft | **new** | Editorial review |
| N3-986 | [旅](entries/1553/1553120-tabi.org) | たび | tabi | 1553120 | learner | draft | **new** | Editorial review |
| N3-987 | [度々](entries/1597/1597160-tabitabi.org) | たびたび | tabitabi | 1597160 | learner | draft | **new** | Editorial review |
| N3-988 | [玉](entries/1240/1240530-tama.org) | たま | tama | 1240530 | learner | draft | **new** | Editorial review |
| N3-989 | [偶々](entries/1597/1597180-tamatama.org) | たまたま | tamatama | 1597180 | learner | draft | **new** | Editorial review |
| N3-990 | [堪らない](entries/1211/1211340-tamaranai.org) | たまらない | tamaranai | 1211340 | learner | draft | **new** | Editorial review |
| N3-991 | [試し](entries/1312/1312250-tameshi.org) | ためし | tameshi | 1312250 | learner | draft | **new** | Editorial review |
| N3-992 | [試す](entries/1312/1312260-tamesu.org) | ためす | tamesu | 1312260 | learner | draft | **new** | Editorial review |
| N3-993 | [便り](entries/1512/1512410-tayori.org) | たより | tayori | 1512410 | learner | draft | **new** | Editorial review |
| N3-994 | [頼る](entries/1597/1597200-tayoru.org) | たよる | tayoru | 1597200 | learner | draft | **new** | Editorial review |
| N3-995 | [単位](entries/1417/1417040-tani.org) | たんい | tani | 1417040 | learner | draft | **new** | Editorial review |
| N3-996 | [単語](entries/1417/1417330-tango.org) | たんご | tango | 1417330 | learner | draft | **new** | Editorial review |
| N3-997 | [単純](entries/1417/1417550-tanjun.org) | たんじゅん | tanjun | 1417550 | learner | draft | **new** | Editorial review |
| N3-998 | [誕生](entries/1419/1419080-tanjou.org) | たんじょう | tanjou | 1419080 | learner | draft | **new** | Editorial review |
| N3-999 | [担当](entries/1418/1418160-tantou.org) | たんとう | tantou | 1418160 | learner | draft | **new** | Editorial review |
| N3-1000 | [単なる](entries/1417/1417020-tannaru.org) | たんなる | tannaru | 1417020 | learner | draft | **new** | Editorial review |
| N3-1001 | [単に](entries/1417/1417030-tanni.org) | たんに | tanni | 1417030 | learner | draft | **new** | Editorial review |
| N3-1002 | [題](entries/1415/1415470-dai.org) | だい | dai | 1415470 | learner | draft | **new** | Editorial review |
| N3-1003 | [台](entries/1412/1412560-dai.org) | だい | dai | 1412560 | learner | draft | **new** | Editorial review |
| N3-1004 | [代金](entries/1411/1411790-daikin.org) | だいきん | daikin | 1411790 | learner | draft | **new** | Editorial review |
| N3-1005 | [大臣](entries/1414/1414160-daijin.org) | だいじん | daijin | 1414160 | learner | draft | **new** | Editorial review |
| N3-1006 | [大統領](entries/1414/1414650-daitouryou.org) | だいとうりょう | daitouryou | 1414650 | learner | draft | **new** | Editorial review |
| N3-1007 | [代表](entries/1412/1412170-daihyou.org) | だいひょう | daihyou | 1412170 | learner | draft | **new** | Editorial review |
| N3-1008 | [大部分](entries/1414/1414850-daibubun.org) | だいぶぶん | daibubun | 1414850 | learner | draft | **new** | Editorial review |
| N3-1009 | [ダイヤ](entries/1076/1076860-daiya.org) | ダイヤ | daiya | 1076860 | learner | draft | **new** | Editorial review |
| N3-1010 | [代理](entries/1412/1412400-dairi.org) | だいり | dairi | 1412400 | learner | draft | **new** | Editorial review |
| N3-1011 | [だが](entries/2055/2055530-daga.org) | だが | daga | 2055530 | learner | draft | **new** | Editorial review |
| N3-1012 | [だけど](entries/1007/1007370-dakedo.org) | だけど | dakedo | 1007370 | learner | draft | **new** | Editorial review |
| N3-1013 | [だって](entries/2643/2643970-datte.org) | だって | datte | 2643970 | learner | draft | **new** | Editorial review |
| N3-1014 | [黙る](entries/1534/1534930-damaru.org) | だまる | damaru | 1534930 | learner | draft | **new** | Editorial review |
| N3-1015 | [駄目](entries/1409/1409110-dame.org) | だめ | dame | 1409110 | learner | draft | **new** | Editorial review |
| N3-1016 | [段](entries/1633/1633690-dan.org) | だん | dan | 1633690 | learner | draft | **new** | Editorial review |
| N3-1017 | [男子](entries/1420/1420070-danshi.org) | だんし | danshi | 1420070 | learner | draft | **new** | Editorial review |
| N3-1018 | [ダンス](entries/1077/1077250-dansu.org) | ダンス | dansu | 1077250 | learner | draft | **new** | Editorial review |
| N3-1019 | [団体](entries/1419/1419270-dantai.org) | だんたい | dantai | 1419270 | learner | draft | **new** | Editorial review |
| N3-1020 | [地](entries/1420/1420730-chi.org) | ち | chi | 1420730 | learner | draft | **new** | Editorial review |
| N3-1021 | [地位](entries/1420/1420780-chii.org) | ちい | chii | 1420780 | learner | draft | **new** | Editorial review |
| N3-1022 | [地域](entries/1420/1420800-chiiki.org) | ちいき | chiiki | 1420800 | learner | draft | **new** | Editorial review |
| N3-1023 | [知恵](entries/1420/1420530-chie.org) | ちえ | chie | 1420530 | learner | draft | **new** | Editorial review |
| N3-1024 | [地下](entries/1420/1420840-chika.org) | ちか | chika | 1420840 | learner | draft | **new** | Editorial review |
| N3-1025 | [近頃](entries/1242/1242300-chikagoro.org) | ちかごろ | chikagoro | 1242300 | learner | draft | **new** | Editorial review |
| N3-1026 | [違い](entries/1158/1158870-chigai.org) | ちがい | chigai | 1158870 | learner | draft | **new** | Editorial review |
| N3-1027 | [違いない](entries/1610/1610740-chigainai.org) | ちがいない | chigainai | 1610740 | learner | draft | **new** | Editorial review |
| N3-1028 | [地球](entries/1420/1420970-chikyuu.org) | ちきゅう | chikyuu | 1420970 | learner | draft | **new** | Editorial review |
| N3-1029 | [地区](entries/1421/1421020-chiku.org) | ちく | chiku | 1421020 | learner | draft | **new** | Editorial review |
| N3-1030 | [遅刻](entries/1422/1422050-chikoku.org) | ちこく | chikoku | 1422050 | learner | draft | **new** | Editorial review |
| N3-1031 | [知識](entries/1420/1420590-chishiki.org) | ちしき | chishiki | 1420590 | learner | draft | **new** | Editorial review |
| N3-1032 | [知事](entries/1420/1420580-chiji.org) | ちじ | chiji | 1420580 | learner | draft | **new** | Editorial review |
| N3-1033 | [父親](entries/1497/1497680-chichioya.org) | ちちおや | chichioya | 1497680 | learner | draft | **new** | Editorial review |
| N3-1034 | [知能](entries/1420/1420680-chinou.org) | ちのう | chinou | 1420680 | learner | draft | **new** | Editorial review |
| N3-1035 | [地平線](entries/1421/1421440-chiheisen.org) | ちへいせん | chiheisen | 1421440 | learner | draft | **new** | Editorial review |
| N3-1036 | [地方](entries/1421/1421450-chihou.org) | ちほう | chihou | 1421450 | learner | draft | **new** | Editorial review |
| N3-1037 | [茶](entries/1422/1422570-cha.org) | ちゃ | cha | 1422570 | learner | draft | **new** | Editorial review |
| N3-1038 | [チャンス](entries/1078/1078040-chansu.org) | チャンス | chansu | 1078040 | learner | draft | **new** | Editorial review |
| N3-1039 | [ちゃんと](entries/1007/1007720-chanto.org) | ちゃんと | chanto | 1007720 | learner | draft | **new** | Editorial review |
| N3-1040 | [注](entries/1426/1426520-chuu.org) | ちゅう | chuu | 1426520 | learner | draft | **new** | Editorial review |
| N3-1041 | [中](entries/1620/1620400-chuu.org) | ちゅう | chuu | 1620400 | learner | draft | **new** | Editorial review |
| N3-1042 | [中央](entries/1423/1423430-chuuou.org) | ちゅうおう | chuuou | 1423430 | learner | draft | **new** | Editorial review |
| N3-1043 | [中学](entries/1423/1423640-chuugaku.org) | ちゅうがく | chuugaku | 1423640 | learner | draft | **new** | Editorial review |
| N3-1044 | [中古](entries/1424/1424150-chuuko.org) | ちゅうこ | chuuko | 1424150 | learner | draft | **new** | Editorial review |
| N3-1045 | [中止](entries/1424/1424410-chuushi.org) | ちゅうし | chuushi | 1424410 | learner | draft | **new** | Editorial review |
| N3-1046 | [駐車](entries/1426/1426910-chuusha.org) | ちゅうしゃ | chuusha | 1426910 | learner | draft | **new** | Editorial review |
| N3-1047 | [昼食](entries/1602/1602330-chuushoku.org) | ちゅうしょく | chuushoku | 1602330 | learner | draft | **new** | Editorial review |
| N3-1048 | [中心](entries/1424/1424550-chuushin.org) | ちゅうしん | chuushin | 1424550 | learner | draft | **new** | Editorial review |
| N3-1049 | [注目](entries/1426/1426670-chuumoku.org) | ちゅうもく | chuumoku | 1426670 | learner | draft | **new** | Editorial review |
| N3-1050 | [注文](entries/1426/1426650-chuumon.org) | ちゅうもん | chuumon | 1426650 | learner | draft | **new** | Editorial review |
| N3-1051 | [長期](entries/1429/1429850-chouki.org) | ちょうき | chouki | 1429850 | learner | draft | **new** | Editorial review |
| N3-1052 | [調査](entries/1429/1429120-chousa.org) | ちょうさ | chousa | 1429120 | learner | draft | **new** | Editorial review |
| N3-1053 | [調子](entries/1429/1429170-choushi.org) | ちょうし | choushi | 1429170 | learner | draft | **new** | Editorial review |
| N3-1054 | [頂上](entries/1430/1430220-choujou.org) | ちょうじょう | choujou | 1430220 | learner | draft | **new** | Editorial review |
| N3-1055 | [頂戴](entries/1430/1430230-choudai.org) | ちょうだい | choudai | 1430230 | learner | draft | **new** | Editorial review |
| N3-1056 | [貯金](entries/1427/1427170-chokin.org) | ちょきん | chokin | 1427170 | learner | draft | **new** | Editorial review |
| N3-1057 | [直接](entries/1431/1431110-chokusetsu.org) | ちょくせつ | chokusetsu | 1431110 | learner | draft | **new** | Editorial review |
| N3-1058 | [著者](entries/1427/1427110-chosha.org) | ちょしゃ | chosha | 1427110 | learner | draft | **new** | Editorial review |
| N3-1059 | [チーズ](entries/1077/1077330-chi-zu.org) | チーズ | chi-zu | 1077330 | learner | draft | **new** | Editorial review |
| N3-1060 | [チーム](entries/1077/1077360-chi-mu.org) | チーム | chi-mu | 1077360 | learner | draft | **new** | Editorial review |
| N3-1061 | [対](entries/1409/1409810-tsui.org) | つい | tsui | 1409810 | learner | draft | **new** | Editorial review |
| N3-1062 | [遂に](entries/1372/1372630-tsuini.org) | ついに | tsuini | 1372630 | learner | draft | **new** | Editorial review |
| N3-1063 | [通過](entries/1433/1433070-tsuuka.org) | つうか | tsuuka | 1433070 | learner | draft | **new** | Editorial review |
| N3-1064 | [通行](entries/1433/1433180-tsuukou.org) | つうこう | tsuukou | 1433180 | learner | draft | **new** | Editorial review |
| N3-1065 | [通信](entries/1433/1433330-tsuushin.org) | つうしん | tsuushin | 1433330 | learner | draft | **new** | Editorial review |
| N3-1066 | [通じる](entries/1432/1432880-tsuujiru.org) | つうじる | tsuujiru | 1432880 | learner | draft | **new** | Editorial review |
| N3-1067 | [捕まる](entries/1514/1514110-tsukamaru.org) | つかまる | tsukamaru | 1514110 | learner | draft | **new** | Editorial review |
| N3-1068 | [掴む](entries/1433/1433650-tsukamu.org) | つかむ | tsukamu | 1433650 | learner | draft | **new** | Editorial review |
| N3-1069 | [疲れ](entries/1483/1483730-tsukare.org) | つかれ | tsukare | 1483730 | learner | draft | **new** | Editorial review |
| N3-1070 | [月](entries/1255/1255430-tsuki.org) | つき | tsuki | 1255430 | learner | draft | **new** | Editorial review |
| N3-1071 | [付き合い](entries/1495/1495640-tsukiai.org) | つきあい | tsukiai | 1495640 | learner | draft | **new** | Editorial review |
| N3-1072 | [次々](entries/1597/1597850-tsugitsugi.org) | つぎつぎ | tsugitsugi | 1597850 | learner | draft | **new** | Editorial review |
| N3-1073 | [就く](entries/1331/1331530-tsuku.org) | つく | tsuku | 1331530 | learner | draft | **new** | Editorial review |
| N3-1074 | [注ぐ](entries/2145/2145240-tsugu.org) | つぐ | tsugu | 2145240 | learner | draft | **new** | Editorial review |
| N3-1075 | [土](entries/1445/1445270-tsuchi.org) | つち | tsuchi | 1445270 | learner | draft | **new** | Editorial review |
| N3-1076 | [包み](entries/1515/1515340-tsutsumi.org) | つつみ | tsutsumi | 1515340 | learner | draft | **new** | Editorial review |
| N3-1077 | [続き](entries/1894/1894690-tsuzuki.org) | つづき | tsuzuki | 1894690 | learner | draft | **new** | Editorial review |
| N3-1078 | [勤め](entries/1240/1240810-tsutome.org) | つとめ | tsutome | 1240810 | learner | draft | **new** | Editorial review |
| N3-1079 | [繋ぐ](entries/1251/1251900-tsunagu.org) | つなぐ | tsunagu | 1251900 | learner | draft | **new** | Editorial review |
| N3-1080 | [常に](entries/1355/1355970-tsuneni.org) | つねに | tsuneni | 1355970 | learner | draft | **new** | Editorial review |
| N3-1081 | [角](entries/1206/1206120-tsuno.org) | つの | tsuno | 1206120 | learner | draft | **new** | Editorial review |
| N3-1082 | [翼](entries/1547/1547530-tsubasa.org) | つばさ | tsubasa | 1547530 | learner | draft | **new** | Editorial review |
| N3-1083 | [詰まり](entries/1610/1610430-tsumari.org) | つまり | tsumari | 1610430 | learner | draft | **new** | Editorial review |
| N3-1085 | [詰める](entries/1226/1226510-tsumeru.org) | つめる | tsumeru | 1226510 | learner | draft | **new** | Editorial review |
| N3-1086 | [梅雨](entries/1582/1582960-tsuyu.org) | つゆ | tsuyu | 1582960 | learner | draft | **new** | Editorial review |
| N3-1087 | [辛い](entries/1365/1365860-tsurai.org) | つらい | tsurai | 1365860 | learner | draft | **new** | Editorial review |
| N3-1088 | [釣り](entries/1434/1434040-tsuri.org) | つり | tsuri | 1434040 | learner | draft | **new** | Editorial review |
| N3-1089 | [連れ](entries/1559/1559260-tsure.org) | つれ | tsure | 1559260 | learner | draft | **new** | Editorial review |
| N3-1090 | [提案](entries/1436/1436320-teian.org) | ていあん | teian | 1436320 | learner | draft | **new** | Editorial review |
| N3-1091 | [定期](entries/1435/1435490-teiki.org) | ていき | teiki | 1435490 | learner | draft | **new** | Editorial review |
| N3-1092 | [抵抗](entries/1436/1436260-teikou.org) | ていこう | teikou | 1436260 | learner | draft | **new** | Editorial review |
| N3-1093 | [提出](entries/1436/1436410-teishutsu.org) | ていしゅつ | teishutsu | 1436410 | learner | draft | **new** | Editorial review |
| N3-1094 | [程度](entries/1436/1436540-teido.org) | ていど | teido | 1436540 | learner | draft | **new** | Editorial review |
| N3-1095 | [停留所](entries/1435/1435080-teiryuujo.org) | ていりゅうじょ | teiryuujo | 1435080 | learner | draft | **new** | Editorial review |
| N3-1096 | [敵](entries/1582/1582000-teki.org) | てき | teki | 1582000 | learner | draft | **new** | Editorial review |
| N3-1097 | [適する](entries/1437/1437340-tekisuru.org) | てきする | tekisuru | 1437340 | learner | draft | **new** | Editorial review |
| N3-1098 | [適切](entries/1437/1437430-tekisetsu.org) | てきせつ | tekisetsu | 1437430 | learner | draft | **new** | Editorial review |
| N3-1099 | [適度](entries/1437/1437440-tekido.org) | てきど | tekido | 1437440 | learner | draft | **new** | Editorial review |
| N3-1100 | [適用](entries/1437/1437500-tekiyou.org) | てきよう | tekiyou | 1437500 | learner | draft | **new** | Editorial review |
| N3-1101 | [手品](entries/1328/1328310-tejina.org) | てじな | tejina | 1328310 | learner | draft | **new** | Editorial review |
| N3-1102 | [徹底](entries/1437/1437670-tettei.org) | てってい | tettei | 1437670 | learner | draft | **new** | Editorial review |
| N3-1103 | [鉄](entries/1437/1437780-tetsu.org) | てつ | tetsu | 1437780 | learner | draft | **new** | Editorial review |
| N3-1104 | [哲学](entries/1437/1437610-tetsugaku.org) | てつがく | tetsugaku | 1437610 | learner | draft | **new** | Editorial review |
| N3-1105 | [手伝い](entries/1328/1328170-tetsudai.org) | てつだい | tetsudai | 1328170 | learner | draft | **new** | Editorial review |
| N3-1106 | [鉄道](entries/1437/1437960-tetsudou.org) | てつどう | tetsudou | 1437960 | learner | draft | **new** | Editorial review |
| N3-1107 | [徹夜](entries/1437/1437700-tetsuya.org) | てつや | tetsuya | 1437700 | learner | draft | **new** | Editorial review |
| N3-1108 | [手間](entries/1327/1327410-tema.org) | てま | tema | 1327410 | learner | draft | **new** | Editorial review |
| N3-1109 | [典型](entries/1438/1438080-tenkei.org) | てんけい | tenkei | 1438080 | learner | draft | **new** | Editorial review |
| N3-1110 | [天候](entries/1438/1438970-tenkou.org) | てんこう | tenkou | 1438970 | learner | draft | **new** | Editorial review |
| N3-1111 | [テント](entries/1081/1081040-tento.org) | テント | tento | 1081040 | learner | draft | **new** | Editorial review |
| N3-1112 | [天然](entries/1439/1439580-tennen.org) | てんねん | tennen | 1439580 | learner | draft | **new** | Editorial review |
| N3-1113 | [出会い](entries/1338/1338400-deai.org) | であい | deai | 1338400 | learner | draft | **new** | Editorial review |
| N3-1114 | [出会う](entries/1598/1598530-deau.org) | であう | deau | 1598530 | learner | draft | **new** | Editorial review |
| N3-1115 | [出来事](entries/1340/1340570-dekigoto.org) | できごと | dekigoto | 1340570 | learner | draft | **new** | Editorial review |
| N3-1116 | [出来るだけ](entries/1340/1340460-dekirudake.org) | できるだけ | dekirudake | 1340460 | learner | draft | **new** | Editorial review |
| N3-1117 | [ですから](entries/1008/1008430-desukara.org) | ですから | desukara | 1008430 | learner | draft | **new** | Editorial review |
| N3-1118 | [デモ](entries/1084/1084000-demo.org) | デモ | demo | 1084000 | learner | draft | **new** | Editorial review |
| N3-1119 | [電子](entries/1443/1443320-denshi.org) | でんし | denshi | 1443320 | learner | draft | **new** | Editorial review |
| N3-1120 | [伝統](entries/1442/1442260-dentou.org) | でんとう | dentou | 1442260 | learner | draft | **new** | Editorial review |
| N3-1121 | [デート](entries/1081/1081430-deeto.org) | デート | deeto | 1081430 | learner | draft | **new** | Editorial review |
| N3-1122 | [と](entries/1008/1008490-to.org) | と | to | 1008490 | learner | draft | **new** | Editorial review |
| N3-1123 | [ト](entries/2029/2029780-to.org) | ト | to | 2029780 | learner | draft | **new** | Editorial review |
| N3-1124 | [問い](entries/1535/1535930-toi.org) | とい | toi | 1535930 | learner | draft | **new** | Editorial review |
| N3-1125 | [党](entries/1445/1445980-tou.org) | とう | tou | 1445980 | learner | draft | **new** | Editorial review |
| N3-1126 | [塔](entries/1446/1446740-tou.org) | とう | tou | 1446740 | learner | draft | **new** | Editorial review |
| N3-1127 | [答案](entries/1449/1449550-touan.org) | とうあん | touan | 1449550 | learner | draft | **new** | Editorial review |
| N3-1128 | [当時](entries/1449/1449090-touji.org) | とうじ | touji | 1449090 | learner | draft | **new** | Editorial review |
| N3-1129 | [到着](entries/1449/1449870-touchaku.org) | とうちゃく | touchaku | 1449870 | learner | draft | **new** | Editorial review |
| N3-1130 | [投票](entries/1447/1447320-touhyou.org) | とうひょう | touhyou | 1447320 | learner | draft | **new** | Editorial review |
| N3-1131 | [通す](entries/1432/1432900-toosu.org) | とおす | toosu | 1432900 | learner | draft | **new** | Editorial review |
| N3-1132 | [通り](entries/1432/1432920-toori.org) | とおり | toori | 1432920 | learner | draft | **new** | Editorial review |
| N3-1133 | [通り過ぎる](entries/1432/1432980-toorisugiru.org) | とおりすぎる | toorisugiru | 1432980 | learner | draft | **new** | Editorial review |
| N3-1134 | [都会](entries/1444/1444970-tokai.org) | とかい | tokai | 1444970 | learner | draft | **new** | Editorial review |
| N3-1135 | [時](entries/1315/1315840-toki.org) | とき | toki | 1315840 | learner | draft | **new** | Editorial review |
| N3-1136 | [解く](entries/1198/1198890-toku.org) | とく | toku | 1198890 | learner | draft | **new** | Editorial review |
| N3-1137 | [得意](entries/1454/1454510-tokui.org) | とくい | tokui | 1454510 | learner | draft | **new** | Editorial review |
| N3-1138 | [特徴](entries/1455/1455170-tokuchou.org) | とくちょう | tokuchou | 1455170 | learner | draft | **new** | Editorial review |
| N3-1139 | [解ける](entries/1198/1198910-tokeru.org) | とける | tokeru | 1198910 | learner | draft | **new** | Editorial review |
| N3-1140 | [所が](entries/1008/1008570-tokoroga.org) | ところが | tokoroga | 1008570 | learner | draft | **new** | Editorial review |
| N3-1141 | [所で](entries/1343/1343110-tokorode.org) | ところで | tokorode | 1343110 | learner | draft | **new** | Editorial review |
| N3-1142 | [登山](entries/1444/1444780-tozan.org) | とざん | tozan | 1444780 | learner | draft | **new** | Editorial review |
| N3-1143 | [都市](entries/1444/1444990-toshi.org) | とし | toshi | 1444990 | learner | draft | **new** | Editorial review |
| N3-1144 | [年月](entries/1582/1582870-toshitsuki.org) | としつき | toshitsuki | 1582870 | learner | draft | **new** | Editorial review |
| N3-1145 | [図書](entries/1370/1370410-tosho.org) | としょ | tosho | 1370410 | learner | draft | **new** | Editorial review |
| N3-1146 | [年寄り](entries/1598/1598750-toshiyori.org) | としより | toshiyori | 1598750 | learner | draft | **new** | Editorial review |
| N3-1147 | [閉じる](entries/1508/1508550-tojiru.org) | とじる | tojiru | 1508550 | learner | draft | **new** | Editorial review |
| N3-1148 | [途端](entries/1610/1610870-totan.org) | とたん | totan | 1610870 | learner | draft | **new** | Editorial review |
| N3-1149 | [土地](entries/1445/1445470-tochi.org) | とち | tochi | 1445470 | learner | draft | **new** | Editorial review |
| N3-1150 | [トップ](entries/1085/1085030-toppu.org) | トップ | toppu | 1085030 | learner | draft | **new** | Editorial review |
| N3-1151 | [突然](entries/1457/1457040-totsuzen.org) | とつぜん | totsuzen | 1457040 | learner | draft | **new** | Editorial review |
| N3-1152 | [届く](entries/1457/1457200-todoku.org) | とどく | todoku | 1457200 | learner | draft | **new** | Editorial review |
| N3-1153 | [兎に角](entries/1443/1443990-tonikaku.org) | とにかく | tonikaku | 1443990 | learner | draft | **new** | Editorial review |
| N3-1154 | [飛ばす](entries/1485/1485230-tobasu.org) | とばす | tobasu | 1485230 | learner | draft | **new** | Editorial review |
| N3-1155 | [飛び出す](entries/1485/1485350-tobidasu.org) | とびだす | tobidasu | 1485350 | learner | draft | **new** | Editorial review |
| N3-1156 | [友](entries/1539/1539980-tomo.org) | とも | tomo | 1539980 | learner | draft | **new** | Editorial review |
| N3-1157 | [共に](entries/1234/1234260-tomoni.org) | ともに | tomoni | 1234260 | learner | draft | **new** | Editorial review |
| N3-1158 | [トラック](entries/1085/1085760-torakku.org) | トラック | torakku | 1085760 | learner | draft | **new** | Editorial review |
| N3-1159 | [トランプ](entries/1086/1086410-toranpu.org) | トランプ | toranpu | 1086410 | learner | draft | **new** | Editorial review |
| N3-1160 | [取り上げる](entries/1326/1326800-toriageru.org) | とりあげる | toriageru | 1326800 | learner | draft | **new** | Editorial review |
| N3-1161 | [取れる](entries/1326/1326990-toreru.org) | とれる | toreru | 1326990 | learner | draft | **new** | Editorial review |
| N3-1162 | [屯](entries/1457/1457320-ton.org) | トン | ton | 1457320 | learner | draft | **new** | Editorial review |
| N3-1163 | [とんでも無い](entries/1008/1008790-tondemonai.org) | とんでもない | tondemonai | 1008790 | learner | draft | **new** | Editorial review |
| N3-1164 | [トンネル](entries/1087/1087630-tonneru.org) | トンネル | tonneru | 1087630 | learner | draft | **new** | Editorial review |
| N3-1165 | [度](entries/1445/1445160-do.org) | ど | do | 1445160 | learner | draft | **new** | Editorial review |
| N3-1166 | [度](entries/2252/2252690-do.org) | ど | do | 2252690 | learner | draft | **new** | Editorial review |
| N3-1167 | [同一](entries/1451/1451900-douitsu.org) | どういつ | douitsu | 1451900 | learner | draft | **new** | Editorial review |
| N3-1168 | [銅貨](entries/1454/1454350-douka.org) | どうか | douka | 1454350 | learner | draft | **new** | Editorial review |
| N3-1169 | [動詞](entries/1451/1451380-doushi.org) | どうし | doushi | 1451380 | learner | draft | **new** | Editorial review |
| N3-1170 | [如何しても](entries/1466/1466950-doushitemo.org) | どうしても | doushitemo | 1466950 | learner | draft | **new** | Editorial review |
| N3-1171 | [同時](entries/1452/1452500-douji.org) | どうじ | douji | 1452500 | learner | draft | **new** | Editorial review |
| N3-1172 | [道徳](entries/1454/1454240-doutoku.org) | どうとく | doutoku | 1454240 | learner | draft | **new** | Editorial review |
| N3-1173 | [同様](entries/1453/1453550-douyou.org) | どうよう | douyou | 1453550 | learner | draft | **new** | Editorial review |
| N3-1174 | [同僚](entries/1453/1453580-douryou.org) | どうりょう | douryou | 1453580 | learner | draft | **new** | Editorial review |
| N3-1175 | [道路](entries/1454/1454290-douro.org) | どうろ | douro | 1454290 | learner | draft | **new** | Editorial review |
| N3-1176 | [毒](entries/1455/1455500-doku.org) | どく | doku | 1455500 | learner | draft | **new** | Editorial review |
| N3-1177 | [読書](entries/1456/1456420-dokusho.org) | どくしょ | dokusho | 1456420 | learner | draft | **new** | Editorial review |
| N3-1178 | [独身](entries/1455/1455850-dokushin.org) | どくしん | dokushin | 1455850 | learner | draft | **new** | Editorial review |
| N3-1179 | [独特](entries/1456/1456010-dokutoku.org) | どくとく | dokutoku | 1456010 | learner | draft | **new** | Editorial review |
| N3-1180 | [独立](entries/1456/1456040-dokuritsu.org) | どくりつ | dokuritsu | 1456040 | learner | draft | **new** | Editorial review |
| N3-1181 | [何処か](entries/1189/1189000-dokoka.org) | どこか | dokoka | 1189000 | learner | draft | **new** | Editorial review |
| N3-1182 | [ドライブ](entries/1088/1088580-doraibu.org) | ドライブ | doraibu | 1088580 | learner | draft | **new** | Editorial review |
| N3-1183 | [ドラマ](entries/1088/1088830-dorama.org) | ドラマ | dorama | 1088830 | learner | draft | **new** | Editorial review |
| N3-1184 | [努力](entries/1445/1445130-doryoku.org) | どりょく | doryoku | 1445130 | learner | draft | **new** | Editorial review |
| N3-1185 | [ドレス](entries/1089/1089280-doresu.org) | ドレス | doresu | 1089280 | learner | draft | **new** | Editorial review |
| N3-1186 | [泥](entries/1436/1436900-doro.org) | どろ | doro | 1436900 | learner | draft | **new** | Editorial review |
| N3-1187 | [どんな](entries/1009/1009330-donna.org) | どんな | donna | 1009330 | learner | draft | **new** | Editorial review |
| N3-1188 | [どんなに](entries/1009/1009340-donnani.org) | どんなに | donnani | 1009340 | learner | draft | **new** | Editorial review |
| N3-1189 | [名](entries/1531/1531330-na.org) | な | na | 1531330 | learner | draft | **new** | Editorial review |
| N3-1190 | [内容](entries/1459/1459400-naiyou.org) | ないよう | naiyou | 1459400 | learner | draft | **new** | Editorial review |
| N3-1192 | [仲](entries/1425/1425710-naka.org) | なか | naka | 1425710 | learner | draft | **new** | Editorial review |
| N3-1193 | [中々](entries/1599/1599420-nakanaka.org) | なかなか | nakanaka | 1599420 | learner | draft | **new** | Editorial review |
| N3-1194 | [半ば](entries/1478/1478780-nakaba.org) | なかば | nakaba | 1478780 | learner | draft | **new** | Editorial review |
| N3-1195 | [仲間](entries/1425/1425790-nakama.org) | なかま | nakama | 1425790 | learner | draft | **new** | Editorial review |
| N3-1196 | [流す](entries/1552/1552120-nagasu.org) | ながす | nagasu | 1552120 | learner | draft | **new** | Editorial review |
| N3-1197 | [眺め](entries/1610/1610960-nagame.org) | ながめ | nagame | 1610960 | learner | draft | **new** | Editorial review |
| N3-1198 | [眺める](entries/1428/1428830-nagameru.org) | ながめる | nagameru | 1428830 | learner | draft | **new** | Editorial review |
| N3-1199 | [流れ](entries/1552/1552130-nagare.org) | ながれ | nagare | 1552130 | learner | draft | **new** | Editorial review |
| N3-1200 | [流れる](entries/1552/1552140-nagareru.org) | ながれる | nagareru | 1552140 | learner | draft | **new** | Editorial review |
| N3-1201 | [無し](entries/1529/1529560-nashi.org) | なし | nashi | 1529560 | learner | draft | **new** | Editorial review |
| N3-1202 | [何故なら](entries/1009/1009410-nazenara.org) | なぜなら | nazenara | 1009410 | learner | draft | **new** | Editorial review |
| N3-1203 | [謎](entries/1459/1459690-nazo.org) | なぞ | nazo | 1459690 | learner | draft | **new** | Editorial review |
| N3-1204 | [納得](entries/1470/1470080-nattoku.org) | なっとく | nattoku | 1470080 | learner | draft | **new** | Editorial review |
| N3-1205 | [何か](entries/1188/1188270-nanika.org) | なにか | nanika | 1188270 | learner | draft | **new** | Editorial review |
| N3-1206 | [何も](entries/1188/1188490-nanimo.org) | なにも | nanimo | 1188490 | learner | draft | **new** | Editorial review |
| N3-1207 | [鍋](entries/1459/1459720-nabe.org) | なべ | nabe | 1459720 | learner | draft | **new** | Editorial review |
| N3-1208 | [生](entries/1378/1378450-nama.org) | なま | nama | 1378450 | learner | draft | **new** | Editorial review |
| N3-1209 | [怠ける](entries/1410/1410660-namakeru.org) | なまける | namakeru | 1410660 | learner | draft | **new** | Editorial review |
| N3-1210 | [波](entries/1470/1470970-nami.org) | なみ | nami | 1470970 | learner | draft | **new** | Editorial review |
| N3-1211 | [涙](entries/1555/1555930-namida.org) | なみだ | namida | 1555930 | learner | draft | **new** | Editorial review |
| N3-1212 | [悩む](entries/1469/1469870-nayamu.org) | なやむ | nayamu | 1469870 | learner | draft | **new** | Editorial review |
| N3-1213 | [何で](entries/1611/1611020-nande.org) | なんで | nande | 1611020 | learner | draft | **new** | Editorial review |
| N3-1214 | [何でも](entries/1611/1611030-nandemo.org) | なんでも | nandemo | 1611030 | learner | draft | **new** | Editorial review |
| N3-1215 | [何とか](entries/1188/1188420-nantoka.org) | なんとか | nantoka | 1188420 | learner | draft | **new** | Editorial review |
| N3-1216 | [似合う](entries/1314/1314680-niau.org) | にあう | niau | 1314680 | learner | draft | **new** | Editorial review |
| N3-1217 | [匂い](entries/1599/1599760-nioi.org) | におい | nioi | 1599760 | learner | draft | **new** | Editorial review |
| N3-1218 | [苦手](entries/1244/1244470-nigate.org) | にがて | nigate | 1244470 | learner | draft | **new** | Editorial review |
| N3-1219 | [握る](entries/1152/1152720-nigiru.org) | にぎる | nigiru | 1152720 | learner | draft | **new** | Editorial review |
| N3-1220 | [日](entries/2083/2083100-nichi.org) | にち | nichi | 2083100 | learner | draft | **new** | Editorial review |
| N3-1221 | [日常](entries/1464/1464180-nichijou.org) | にちじょう | nichijou | 1464180 | learner | draft | **new** | Editorial review |
| N3-1222 | [日曜](entries/1464/1464880-nichiyou.org) | にちよう | nichiyou | 1464880 | learner | draft | **new** | Editorial review |
| N3-1223 | [日光](entries/1464/1464030-nikkou.org) | にっこう | nikkou | 1464030 | learner | draft | **new** | Editorial review |
| N3-1224 | [にっこり](entries/1632/1632320-nikkori.org) | にっこり | nikkori | 1632320 | learner | draft | **new** | Editorial review |
| N3-1225 | [日中](entries/1464/1464250-nitchuu.org) | にっちゅう | nitchuu | 1464250 | learner | draft | **new** | Editorial review |
| N3-1226 | [日本](entries/1582/1582710-nihon.org) | にほん | nihon | 1582710 | learner | draft | **new** | Editorial review |
| N3-1227 | [入場](entries/1466/1466360-nyuujou.org) | にゅうじょう | nyuujou | 1466360 | learner | draft | **new** | Editorial review |
| N3-1228 | [人気](entries/1367/1367010-ninki.org) | にんき | ninki | 1367010 | learner | draft | **new** | Editorial review |
| N3-1229 | [人間](entries/1366/1366770-ningen.org) | にんげん | ningen | 1366770 | learner | draft | **new** | Editorial review |
| N3-1230 | [抜く](entries/1478/1478190-nuku.org) | ぬく | nuku | 1478190 | learner | draft | **new** | Editorial review |
| N3-1231 | [抜ける](entries/1478/1478200-nukeru.org) | ぬける | nukeru | 1478200 | learner | draft | **new** | Editorial review |
| N3-1232 | [布](entries/1496/1496840-nuno.org) | ぬの | nuno | 1496840 | learner | draft | **new** | Editorial review |
| N3-1233 | [根](entries/1290/1290020-ne.org) | ね | ne | 1290020 | learner | draft | **new** | Editorial review |
| N3-1234 | [願い](entries/1217/1217900-negai.org) | ねがい | negai | 1217900 | learner | draft | **new** | Editorial review |
| N3-1235 | [願う](entries/1217/1217950-negau.org) | ねがう | negau | 1217950 | learner | draft | **new** | Editorial review |
| N3-1236 | [鼠](entries/1397/1397840-nezumi.org) | ねずみ | nezumi | 1397840 | learner | draft | **new** | Editorial review |
| N3-1237 | [熱心](entries/1467/1467910-nesshin.org) | ねっしん | nesshin | 1467910 | learner | draft | **new** | Editorial review |
| N3-1238 | [熱帯](entries/1467/1467930-nettai.org) | ねったい | nettai | 1467930 | learner | draft | **new** | Editorial review |
| N3-1239 | [熱中](entries/1467/1467950-netchuu.org) | ねっちゅう | netchuu | 1467950 | learner | draft | **new** | Editorial review |
| N3-1240 | [年間](entries/1468/1468380-nenkan.org) | ねんかん | nenkan | 1468380 | learner | draft | **new** | Editorial review |
| N3-1241 | [年中](entries/1469/1469000-nenjuu.org) | ねんじゅう | nenjuu | 1469000 | learner | draft | **new** | Editorial review |
| N3-1242 | [年代](entries/1468/1468950-nendai.org) | ねんだい | nendai | 1468950 | learner | draft | **new** | Editorial review |
| N3-1243 | [年齢](entries/1600/1600240-nenrei.org) | ねんれい | nenrei | 1600240 | learner | draft | **new** | Editorial review |
| N3-1244 | [野](entries/1537/1537250-no.org) | の | no | 1537250 | learner | draft | **new** | Editorial review |
| N3-1245 | [能](entries/1470/1470120-nou.org) | のう | nou | 1470120 | learner | draft | **new** | Editorial review |
| N3-1246 | [農家](entries/1470/1470620-nouka.org) | のうか | nouka | 1470620 | learner | draft | **new** | Editorial review |
| N3-1247 | [農業](entries/1470/1470660-nougyou.org) | のうぎょう | nougyou | 1470660 | learner | draft | **new** | Editorial review |
| N3-1248 | [農民](entries/1470/1470770-noumin.org) | のうみん | noumin | 1470770 | learner | draft | **new** | Editorial review |
| N3-1249 | [能力](entries/1470/1470370-nouryoku.org) | のうりょく | nouryoku | 1470370 | learner | draft | **new** | Editorial review |
| N3-1250 | [軒](entries/1260/1260330-noki.org) | のき | noki | 1260330 | learner | draft | **new** | Editorial review |
| N3-1251 | [残す](entries/1600/1600260-nokosu.org) | のこす | nokosu | 1600260 | learner | draft | **new** | Editorial review |
| N3-1252 | [残り](entries/1304/1304480-nokori.org) | のこり | nokori | 1304480 | learner | draft | **new** | Editorial review |
| N3-1253 | [乗せる](entries/1600/1600270-noseru.org) | のせる | noseru | 1600270 | learner | draft | **new** | Editorial review |
| N3-1254 | [除く](entries/1345/1345640-nozoku.org) | のぞく | nozoku | 1345640 | learner | draft | **new** | Editorial review |
| N3-1255 | [望み](entries/1519/1519620-nozomi.org) | のぞみ | nozomi | 1519620 | learner | draft | **new** | Editorial review |
| N3-1256 | [望む](entries/1519/1519630-nozomu.org) | のぞむ | nozomu | 1519630 | learner | draft | **new** | Editorial review |
| N3-1257 | [後](entries/1269/1269330-nochi.org) | のち | nochi | 1269330 | learner | draft | **new** | Editorial review |
| N3-1258 | [ノック](entries/1093/1093920-nokku.org) | ノック | nokku | 1093920 | learner | draft | **new** | Editorial review |
| N3-1259 | [喉](entries/1600/1600280-nodo.org) | のど | nodo | 1600280 | learner | draft | **new** | Editorial review |
| N3-1260 | [伸ばす](entries/1600/1600290-nobasu.org) | のばす | nobasu | 1600290 | learner | draft | **new** | Editorial review |
| N3-1261 | [伸びる](entries/1358/1358870-nobiru.org) | のびる | nobiru | 1358870 | learner | draft | **new** | Editorial review |
| N3-1262 | [述べる](entries/1340/1340820-noberu.org) | のべる | noberu | 1340820 | learner | draft | **new** | Editorial review |
| N3-1263 | [のんびり](entries/1010/1010050-nonbiri.org) | のんびり | nonbiri | 1010050 | learner | draft | **new** | Editorial review |
| N3-1264 | [ノー](entries/2080/2080530-noo.org) | ノー | noo | 2080530 | learner | draft | **new** | Editorial review |
| N3-1265 | [はあ](entries/2069/2069620-haa.org) | はあ | haa | 2069620 | learner | draft | **new** | Editorial review |
| N3-1266 | [灰](entries/1201/1201860-hai.org) | はい | hai | 1201860 | learner | draft | **new** | Editorial review |
| N3-1267 | [ハイキング](entries/1095/1095040-haikingu.org) | ハイキング | haikingu | 1095040 | learner | draft | **new** | Editorial review |
| N3-1268 | [配達](entries/1473/1473140-haitatsu.org) | はいたつ | haitatsu | 1473140 | learner | draft | **new** | Editorial review |
| N3-1269 | [俳優](entries/1471/1471970-haiyuu.org) | はいゆう | haiyuu | 1471970 | learner | draft | **new** | Editorial review |
| N3-1270 | [墓](entries/1514/1514840-haka.org) | はか | haka | 1514840 | learner | draft | **new** | Editorial review |
| N3-1271 | [博士](entries/1474/1474620-hakase.org) | はかせ | hakase | 1474620 | learner | draft | **new** | Editorial review |
| N3-1272 | [計る](entries/1600/1600650-hakaru.org) | はかる | hakaru | 1600650 | learner | draft | **new** | Editorial review |
| N3-1273 | [計る](entries/1600/1600650-hakaru.org) | はかる | hakaru | 1600650 | learner | draft | **new** | Editorial review |
| N3-1274 | [吐く](entries/2646/2646460-haku.org) | はく | haku | 2646460 | learner | draft | **new** | Editorial review |
| N3-1275 | [履く](entries/1607/1607260-haku.org) | はく | haku | 1607260 | learner | draft | **new** | Editorial review |
| N3-1276 | [拍手](entries/1474/1474820-hakushu.org) | はくしゅ | hakushu | 1474820 | learner | draft | **new** | Editorial review |
| N3-1277 | [博物館](entries/1474/1474720-hakubutsukan.org) | はくぶつかん | hakubutsukan | 1474720 | learner | draft | **new** | Editorial review |
| N3-1278 | [激しい](entries/1600/1600720-hageshii.org) | はげしい | hageshii | 1600720 | learner | draft | **new** | Editorial review |
| N3-1279 | [鋏](entries/1573/1573820-hasami.org) | はさみ | hasami | 1573820 | learner | draft | **new** | Editorial review |
| N3-1280 | [破産](entries/1471/1471330-hasan.org) | はさん | hasan | 1471330 | learner | draft | **new** | Editorial review |
| N3-1281 | [端](entries/1581/1581610-hashi.org) | はし | hashi | 1581610 | learner | draft | **new** | Editorial review |
| N3-1282 | [始まり](entries/1611/1611200-hajimari.org) | はじまり | hajimari | 1611200 | learner | draft | **new** | Editorial review |
| N3-1283 | [外す](entries/1203/1203270-hazusu.org) | はずす | hazusu | 1203270 | learner | draft | **new** | Editorial review |
| N3-1284 | [旗](entries/1220/1220240-hata.org) | はた | hata | 1220240 | learner | draft | **new** | Editorial review |
| N3-1285 | [畑](entries/1476/1476520-hatake.org) | はたけ | hatake | 1476520 | learner | draft | **new** | Editorial review |
| N3-1286 | [働き](entries/1451/1451040-hataraki.org) | はたらき | hataraki | 1451040 | learner | draft | **new** | Editorial review |
| N3-1287 | [肌](entries/1476/1476450-hada.org) | はだ | hada | 1476450 | learner | draft | **new** | Editorial review |
| N3-1288 | [裸](entries/1547/1547600-hadaka.org) | はだか | hadaka | 1547600 | learner | draft | **new** | Editorial review |
| N3-1289 | [発見](entries/1477/1477310-hakken.org) | はっけん | hakken | 1477310 | learner | draft | **new** | Editorial review |
| N3-1290 | [発行](entries/1477/1477390-hakkou.org) | はっこう | hakkou | 1477390 | learner | draft | **new** | Editorial review |
| N3-1291 | [発車](entries/1477/1477500-hassha.org) | はっしゃ | hassha | 1477500 | learner | draft | **new** | Editorial review |
| N3-1292 | [発達](entries/1477/1477680-hattatsu.org) | はったつ | hattatsu | 1477680 | learner | draft | **new** | Editorial review |
| N3-1293 | [発展](entries/1477/1477720-hatten.org) | はってん | hatten | 1477720 | learner | draft | **new** | Editorial review |
| N3-1294 | [発表](entries/1477/1477840-happyou.org) | はっぴょう | happyou | 1477840 | learner | draft | **new** | Editorial review |
| N3-1295 | [発明](entries/1477/1477910-hatsumei.org) | はつめい | hatsumei | 1477910 | learner | draft | **new** | Editorial review |
| N3-1296 | [話し合う](entries/1562/1562310-hanashiau.org) | はなしあう | hanashiau | 1562310 | learner | draft | **new** | Editorial review |
| N3-1297 | [放す](entries/1516/1516460-hanasu.org) | はなす | hanasu | 1516460 | learner | draft | **new** | Editorial review |
| N3-1298 | [離す](entries/1550/1550830-hanasu.org) | はなす | hanasu | 1550830 | learner | draft | **new** | Editorial review |
| N3-1299 | [離れる](entries/1550/1550840-hanareru.org) | はなれる | hanareru | 1550840 | learner | draft | **new** | Editorial review |
| N3-1300 | [羽](entries/1171/1171680-hane.org) | はね | hane | 1171680 | learner | draft | **new** | Editorial review |
| N3-1301 | [母親](entries/1515/1515120-hahaoya.org) | ははおや | hahaoya | 1515120 | learner | draft | **new** | Editorial review |
| N3-1302 | [幅](entries/1500/1500880-haba.org) | はば | haba | 1500880 | learner | draft | **new** | Editorial review |
| N3-1303 | [省く](entries/1351/1351040-habuku.org) | はぶく | habuku | 1351040 | learner | draft | **new** | Editorial review |
| N3-1304 | [腹](entries/1501/1501110-hara.org) | はら | hara | 1501110 | learner | draft | **new** | Editorial review |
| N3-1305 | [原](entries/1261/1261140-hara.org) | はら | hara | 1261140 | learner | draft | **new** | Editorial review |
| N3-1306 | [針](entries/1366/1366210-hari.org) | はり | hari | 1366210 | learner | draft | **new** | Editorial review |
| N3-1307 | [範囲](entries/1481/1481890-hani.org) | はんい | hani | 1481890 | learner | draft | **new** | Editorial review |
| N3-1308 | [反抗](entries/1480/1480380-hankou.org) | はんこう | hankou | 1480380 | learner | draft | **new** | Editorial review |
| N3-1309 | [ハンサム](entries/1096/1096560-hansamu.org) | ハンサム | hansamu | 1096560 | learner | draft | **new** | Editorial review |
| N3-1310 | [犯罪](entries/1481/1481590-hanzai.org) | はんざい | hanzai | 1481590 | learner | draft | **new** | Editorial review |
| N3-1311 | [判断](entries/1478/1478620-handan.org) | はんだん | handan | 1478620 | learner | draft | **new** | Editorial review |
| N3-1312 | [犯人](entries/1481/1481630-hannin.org) | はんにん | hannin | 1481630 | learner | draft | **new** | Editorial review |
| N3-1313 | [販売](entries/1481/1481800-hanbai.org) | はんばい | hanbai | 1481800 | learner | draft | **new** | Editorial review |
| N3-1314 | [場](entries/1355/1355790-ba.org) | ば | ba | 1355790 | learner | draft | **new** | Editorial review |
| N3-1315 | [バイオリン](entries/1097/1097740-baiorin.org) | バイオリン | baiorin | 1097740 | learner | draft | **new** | Editorial review |
| N3-1316 | [馬鹿](entries/1601/1601260-baka.org) | ばか | baka | 1601260 | learner | draft | **new** | Editorial review |
| N3-1317 | [麦酒](entries/1104/1104550-bakushu.org) | ばくしゅ | bakushu | 1104550 | learner | draft | **new** | Editorial review |
| N3-1318 | [莫大](entries/1476/1476060-bakudai.org) | ばくだい | bakudai | 1476060 | learner | draft | **new** | Editorial review |
| N3-1319 | [爆発](entries/1475/1475910-bakuhatsu.org) | ばくはつ | bakuhatsu | 1475910 | learner | draft | **new** | Editorial review |
| N3-1320 | [バッグ](entries/1099/1099100-baggu.org) | バッグ | baggu | 1099100 | learner | draft | **new** | Editorial review |
| N3-1321 | [罰する](entries/1478/1478080-bassuru.org) | ばっする | bassuru | 1478080 | learner | draft | **new** | Editorial review |
| N3-1322 | [ばったり](entries/1632/1632430-battari.org) | ばったり | battari | 1632430 | learner | draft | **new** | Editorial review |
| N3-1323 | [場面](entries/1355/1355910-bamen.org) | ばめん | bamen | 1355910 | learner | draft | **new** | Editorial review |
| N3-1324 | [バン](entries/1100/1100090-ban.org) | バン | ban | 1100090 | learner | draft | **new** | Editorial review |
| N3-1325 | [番](entries/2022/2022640-ban.org) | ばん | ban | 2022640 | learner | draft | **new** | Editorial review |
| N3-1326 | [パイプ](entries/1101/1101120-paipu.org) | パイプ | paipu | 1101120 | learner | draft | **new** | Editorial review |
| N3-1327 | [パイロット](entries/1101/1101260-pairotto.org) | パイロット | pairotto | 1101260 | learner | draft | **new** | Editorial review |
| N3-1328 | [パス](entries/1101/1101440-pasu.org) | パス | pasu | 1101440 | learner | draft | **new** | Editorial review |
| N3-1329 | [パスポート](entries/1101/1101510-pasupooto.org) | パスポート | pasupooto | 1101510 | learner | draft | **new** | Editorial review |
| N3-1330 | [パーセント](entries/1100/1100610-paasento.org) | パーセント | paasento | 1100610 | learner | draft | **new** | Editorial review |
| N3-1331 | [灯](entries/1582/1582290-hi.org) | ひ | hi | 1582290 | learner | draft | **new** | Editorial review |
| N3-1332 | [比較](entries/1483/1483560-hikaku.org) | ひかく | hikaku | 1483560 | learner | draft | **new** | Editorial review |
| N3-1333 | [被害](entries/1484/1484350-higai.org) | ひがい | higai | 1484350 | learner | draft | **new** | Editorial review |
| N3-1334 | [轢く](entries/1612/1612920-hiku.org) | ひく | hiku | 1612920 | learner | draft | **new** | Editorial review |
| N3-1335 | [悲劇](entries/1483/1483280-higeki.org) | ひげき | higeki | 1483280 | learner | draft | **new** | Editorial review |
| N3-1336 | [飛行](entries/1485/1485450-hikou.org) | ひこう | hikou | 1485450 | learner | draft | **new** | Editorial review |
| N3-1337 | [膝](entries/1487/1487320-hiza.org) | ひざ | hiza | 1487320 | learner | draft | **new** | Editorial review |
| N3-1338 | [非常](entries/1484/1484920-hijou.org) | ひじょう | hijou | 1484920 | learner | draft | **new** | Editorial review |
| N3-1339 | [額](entries/1207/1207510-hitai.org) | ひたい | hitai | 1207510 | learner | draft | **new** | Editorial review |
| N3-1340 | [必死](entries/1601/1601890-hisshi.org) | ひっし | hisshi | 1601890 | learner | draft | **new** | Editorial review |
| N3-1341 | [引っ張る](entries/1601/1601900-hipparu.org) | ひっぱる | hipparu | 1601900 | learner | draft | **new** | Editorial review |
| N3-1342 | [日付](entries/1464/1464340-hizuke.org) | ひづけ | hizuke | 1464340 | learner | draft | **new** | Editorial review |
| N3-1343 | [否定](entries/1482/1482990-hitei.org) | ひてい | hitei | 1482990 | learner | draft | **new** | Editorial review |
| N3-1344 | [一言](entries/1575/1575990-hitokoto.org) | ひとこと | hitokoto | 1575990 | learner | draft | **new** | Editorial review |
| N3-1345 | [人ごみ](entries/1367/1367680-hitogomi.org) | ひとごみ | hitogomi | 1367680 | learner | draft | **new** | Editorial review |
| N3-1346 | [等しい](entries/1449/1449330-hitoshii.org) | ひとしい | hitoshii | 1449330 | learner | draft | **new** | Editorial review |
| N3-1347 | [一人一人](entries/1612/1612530-hitorihitori.org) | ひとりひとり | hitorihitori | 1612530 | learner | draft | **new** | Editorial review |
| N3-1348 | [批判](entries/1483/1483420-hihan.org) | ひはん | hihan | 1483420 | learner | draft | **new** | Editorial review |
| N3-1349 | [批評](entries/1483/1483440-hihyou.org) | ひひょう | hihyou | 1483440 | learner | draft | **new** | Editorial review |
| N3-1350 | [秘密](entries/1484/1484150-himitsu.org) | ひみつ | himitsu | 1484150 | learner | draft | **new** | Editorial review |
| N3-1351 | [紐](entries/1487/1487970-himo.org) | ひも | himo | 1487970 | learner | draft | **new** | Editorial review |
| N3-1352 | [表](entries/1489/1489350-hyou.org) | ひょう | hyou | 1489350 | learner | draft | **new** | Editorial review |
| N3-1353 | [評価](entries/1490/1490010-hyouka.org) | ひょうか | hyouka | 1490010 | learner | draft | **new** | Editorial review |
| N3-1354 | [表現](entries/1489/1489510-hyougen.org) | ひょうげん | hyougen | 1489510 | learner | draft | **new** | Editorial review |
| N3-1355 | [表情](entries/1489/1489700-hyoujou.org) | ひょうじょう | hyoujou | 1489700 | learner | draft | **new** | Editorial review |
| N3-1356 | [評判](entries/1490/1490070-hyouban.org) | ひょうばん | hyouban | 1490070 | learner | draft | **new** | Editorial review |
| N3-1357 | [表面](entries/1489/1489880-hyoumen.org) | ひょうめん | hyoumen | 1489880 | learner | draft | **new** | Editorial review |
| N3-1358 | [費用](entries/1484/1484620-hiyou.org) | ひよう | hiyou | 1484620 | learner | draft | **new** | Editorial review |
| N3-1359 | [広がる](entries/1602/1602360-hirogaru.org) | ひろがる | hirogaru | 1602360 | learner | draft | **new** | Editorial review |
| N3-1360 | [品](entries/2648/2648780-hin.org) | ひん | hin | 2648780 | learner | draft | **new** | Editorial review |
| N3-1361 | [美人](entries/1486/1486530-bijin.org) | びじん | bijin | 1486530 | learner | draft | **new** | Editorial review |
| N3-1362 | [吃驚](entries/1226/1226360-bikkuri.org) | びっくり | bikkuri | 1226360 | learner | draft | **new** | Editorial review |
| N3-1363 | [ビデオ](entries/1105/1105360-bideo.org) | ビデオ | bideo | 1105360 | learner | draft | **new** | Editorial review |
| N3-1364 | [微妙](entries/1486/1486170-bimyou.org) | びみょう | bimyou | 1486170 | learner | draft | **new** | Editorial review |
| N3-1365 | [秒](entries/1490/1490430-byou.org) | びょう | byou | 1490430 | learner | draft | **new** | Editorial review |
| N3-1366 | [平等](entries/1507/1507670-byoudou.org) | びょうどう | byoudou | 1507670 | learner | draft | **new** | Editorial review |
| N3-1367 | [便](entries/1512/1512360-bin.org) | びん | bin | 1512360 | learner | draft | **new** | Editorial review |
| N3-1368 | [瓶](entries/1491/1491120-bin.org) | びん | bin | 1491120 | learner | draft | **new** | Editorial review |
| N3-1369 | [ビール](entries/2796/2796520-biiru.org) | ビール | biiru | 2796520 | learner | draft | **new** | Editorial review |
| N3-1370 | [ピクニック](entries/1106/1106530-pikunikku.org) | ピクニック | pikunikku | 1106530 | learner | draft | **new** | Editorial review |
| N3-1371 | [ぴったり](entries/1010/1010900-pittari.org) | ぴったり | pittari | 1010900 | learner | draft | **new** | Editorial review |
| N3-1372 | [ピン](entries/1107/1107060-pin.org) | ピン | pin | 1107060 | learner | draft | **new** | Editorial review |
| N3-1373 | [不](entries/1922/1922780-fu.org) | ふ | fu | 1922780 | learner | draft | **new** | Editorial review |
| N3-1374 | [不安](entries/1491/1491150-fuan.org) | ふあん | fuan | 1491150 | learner | draft | **new** | Editorial review |
| N3-1375 | [風景](entries/1499/1499830-fuukei.org) | ふうけい | fuukei | 1499830 | learner | draft | **new** | Editorial review |
| N3-1376 | [夫婦](entries/1583/1583640-fuufu.org) | ふうふ | fuufu | 1583640 | learner | draft | **new** | Editorial review |
| N3-1377 | [笛](entries/1437/1437310-fue.org) | ふえ | fue | 1437310 | learner | draft | **new** | Editorial review |
| N3-1378 | [不可](entries/1491/1491370-fuka.org) | ふか | fuka | 1491370 | learner | draft | **new** | Editorial review |
| N3-1379 | [服装](entries/1500/1500970-fukusou.org) | ふくそう | fukusou | 1500970 | learner | draft | **new** | Editorial review |
| N3-1380 | [含む](entries/1216/1216880-fukumu.org) | ふくむ | fukumu | 1216880 | learner | draft | **new** | Editorial review |
| N3-1381 | [袋](entries/1411/1411070-fukuro.org) | ふくろ | fukuro | 1411070 | learner | draft | **new** | Editorial review |
| N3-1382 | [不幸](entries/1492/1492350-fukou.org) | ふこう | fukou | 1492350 | learner | draft | **new** | Editorial review |
| N3-1383 | [節](entries/1386/1386160-fushi.org) | ふし | fushi | 1386160 | learner | draft | **new** | Editorial review |
| N3-1384 | [不思議](entries/1492/1492570-fushigi.org) | ふしぎ | fushigi | 1492570 | learner | draft | **new** | Editorial review |
| N3-1385 | [不自由](entries/1492/1492680-fujiyuu.org) | ふじゆう | fujiyuu | 1492680 | learner | draft | **new** | Editorial review |
| N3-1386 | [夫人](entries/1496/1496540-fujin.org) | ふじん | fujin | 1496540 | learner | draft | **new** | Editorial review |
| N3-1387 | [婦人](entries/1496/1496670-fujin.org) | ふじん | fujin | 1496670 | learner | draft | **new** | Editorial review |
| N3-1388 | [不正](entries/1493/1493370-fusei.org) | ふせい | fusei | 1493370 | learner | draft | **new** | Editorial review |
| N3-1389 | [防ぐ](entries/1520/1520190-fusegu.org) | ふせぐ | fusegu | 1520190 | learner | draft | **new** | Editorial review |
| N3-1390 | [不足](entries/1493/1493700-fusoku.org) | ふそく | fusoku | 1493700 | learner | draft | **new** | Editorial review |
| N3-1391 | [双子](entries/1398/1398750-futago.org) | ふたご | futago | 1398750 | learner | draft | **new** | Editorial review |
| N3-1392 | [再び](entries/1292/1292300-futatabi.org) | ふたたび | futatabi | 1292300 | learner | draft | **new** | Editorial review |
| N3-1393 | [普段](entries/1497/1497180-fudan.org) | ふだん | fudan | 1497180 | learner | draft | **new** | Editorial review |
| N3-1394 | [縁](entries/1177/1177500-fuchi.org) | ふち | fuchi | 1177500 | learner | draft | **new** | Editorial review |
| N3-1395 | [筆](entries/1487/1487770-fude.org) | ふで | fude | 1487770 | learner | draft | **new** | Editorial review |
| N3-1396 | [不図](entries/1493/1493240-futo.org) | ふと | futo | 1493240 | learner | draft | **new** | Editorial review |
| N3-1397 | [不平](entries/1494/1494790-fuhei.org) | ふへい | fuhei | 1494790 | learner | draft | **new** | Editorial review |
| N3-1398 | [不満](entries/1494/1494970-fuman.org) | ふまん | fuman | 1494970 | learner | draft | **new** | Editorial review |
| N3-1399 | [不利](entries/1495/1495220-furi.org) | ふり | furi | 1495220 | learner | draft | **new** | Editorial review |
| N3-1400 | [振る](entries/1361/1361330-furu.org) | ふる | furu | 1361330 | learner | draft | **new** | Editorial review |
| N3-1401 | [震える](entries/1366/1366310-furueru.org) | ふるえる | furueru | 1366310 | learner | draft | **new** | Editorial review |
| N3-1402 | [故郷](entries/1603/1603050-furusato.org) | ふるさと | furusato | 1603050 | learner | draft | **new** | Editorial review |
| N3-1403 | [触れる](entries/1357/1357990-fureru.org) | ふれる | fureru | 1357990 | learner | draft | **new** | Editorial review |
| N3-1404 | [雰囲気](entries/1505/1505070-funiki.org) | ふんいき | funiki | 1505070 | learner | draft | **new** | Editorial review |
| N3-1405 | [分](entries/1502/1502850-bu.org) | ぶ | bu | 1502850 | learner | draft | **new** | Editorial review |
| N3-1406 | [無](entries/2423/2423740-bu.org) | ぶ | bu | 2423740 | learner | draft | **new** | Editorial review |
| N3-1407 | [武器](entries/1498/1498460-buki.org) | ぶき | buki | 1498460 | learner | draft | **new** | Editorial review |
| N3-1408 | [無事](entries/1530/1530030-buji.org) | ぶじ | buji | 1530030 | learner | draft | **new** | Editorial review |
| N3-1409 | [舞台](entries/1499/1499150-butai.org) | ぶたい | butai | 1499150 | learner | draft | **new** | Editorial review |
| N3-1410 | [物価](entries/1502/1502430-bukka.org) | ぶっか | bukka | 1502430 | learner | draft | **new** | Editorial review |
| N3-1411 | [物質](entries/1502/1502560-busshitsu.org) | ぶっしつ | busshitsu | 1502560 | learner | draft | **new** | Editorial review |
| N3-1412 | [打つ](entries/1408/1408815-butsu.org) | ぶつ | butsu | 1408815 | learner | draft | **new** | Editorial review |
| N3-1413 | [部分](entries/1499/1499490-bubun.org) | ぶぶん | bubun | 1499490 | learner | draft | **new** | Editorial review |
| N3-1414 | [ブレーキ](entries/1114/1114640-bureeki.org) | ブレーキ | bureeki | 1114640 | learner | draft | **new** | Editorial review |
| N3-1415 | [分](entries/1502/1502860-bun.org) | ぶん | bun | 1502860 | learner | draft | **new** | Editorial review |
| N3-1416 | [文](entries/1505/1505090-bun.org) | ぶん | bun | 1505090 | learner | draft | **new** | Editorial review |
| N3-1417 | [分析](entries/1503/1503870-bunseki.org) | ぶんせき | bunseki | 1503870 | learner | draft | **new** | Editorial review |
| N3-1418 | [文明](entries/1505/1505650-bunmei.org) | ぶんめい | bunmei | 1505650 | learner | draft | **new** | Editorial review |
| N3-1419 | [分野](entries/1504/1504330-bunya.org) | ぶんや | bunya | 1504330 | learner | draft | **new** | Editorial review |
| N3-1420 | [プラス](entries/1115/1115630-purasu.org) | プラス | purasu | 1115630 | learner | draft | **new** | Editorial review |
| N3-1421 | [プラン](entries/1115/1115900-puran.org) | プラン | puran | 1115900 | learner | draft | **new** | Editorial review |
| N3-1422 | [プロ](entries/1117/1117030-puro.org) | プロ | puro | 1117030 | learner | draft | **new** | Editorial review |
| N3-1423 | [塀](entries/1506/1506870-hei.org) | へい | hei | 1506870 | learner | draft | **new** | Editorial review |
| N3-1424 | [平均](entries/1583/1583870-heikin.org) | へいきん | heikin | 1583870 | learner | draft | **new** | Editorial review |
| N3-1425 | [平和](entries/1508/1508070-heiwa.org) | へいわ | heiwa | 1508070 | learner | draft | **new** | Editorial review |
| N3-1426 | [減らす](entries/1263/1263110-herasu.org) | へらす | herasu | 1263110 | learner | draft | **new** | Editorial review |
| N3-1427 | [減る](entries/1263/1263120-heru.org) | へる | heru | 1263120 | learner | draft | **new** | Editorial review |
| N3-1428 | [変化](entries/1510/1510890-henka.org) | へんか | henka | 1510890 | learner | draft | **new** | Editorial review |
| N3-1429 | [変更](entries/1511/1511040-henkou.org) | へんこう | henkou | 1511040 | learner | draft | **new** | Editorial review |
| N3-1430 | [別に](entries/1509/1509480-betsuni.org) | べつに | betsuni | 1509480 | learner | draft | **new** | Editorial review |
| N3-1431 | [ベルト](entries/1120/1120070-beruto.org) | ベルト | beruto | 1120070 | learner | draft | **new** | Editorial review |
| N3-1432 | [ベンチ](entries/1120/1120280-benchi.org) | ベンチ | benchi | 1120280 | learner | draft | **new** | Editorial review |
| N3-1433 | [弁当](entries/1513/1513060-bentou.org) | べんとう | bentou | 1513060 | learner | draft | **new** | Editorial review |
| N3-1434 | [番瀝青](entries/1121/1121390-penki.org) | ペンキ | penki | 1121390 | learner | draft | **new** | Editorial review |
| N3-1435 | [方](entries/1516/1516930-hou.org) | ほう | hou | 1516930 | learner | draft | **new** | Editorial review |
| N3-1436 | [法](entries/1517/1517150-hou.org) | ほう | hou | 1517150 | learner | draft | **new** | Editorial review |
| N3-1437 | [方向](entries/1516/1516990-houkou.org) | ほうこう | houkou | 1516990 | learner | draft | **new** | Editorial review |
| N3-1438 | [報告](entries/1515/1515670-houkoku.org) | ほうこく | houkoku | 1515670 | learner | draft | **new** | Editorial review |
| N3-1439 | [宝石](entries/1516/1516220-houseki.org) | ほうせき | houseki | 1516220 | learner | draft | **new** | Editorial review |
| N3-1440 | [放送](entries/1516/1516750-housou.org) | ほうそう | housou | 1516750 | learner | draft | **new** | Editorial review |
| N3-1441 | [豊富](entries/1518/1518180-houfu.org) | ほうふ | houfu | 1518180 | learner | draft | **new** | Editorial review |
| N3-1442 | [方法](entries/1517/1517090-houhou.org) | ほうほう | houhou | 1517090 | learner | draft | **new** | Editorial review |
| N3-1443 | [方々](entries/1584/1584105-houbou.org) | ほうぼう | houbou | 1584105 | learner | draft | **new** | Editorial review |
| N3-1444 | [訪問](entries/1518/1518120-houmon.org) | ほうもん | houmon | 1518120 | learner | draft | **new** | Editorial review |
| N3-1445 | [吠える](entries/1603/1603420-hoeru.org) | ほえる | hoeru | 1603420 | learner | draft | **new** | Editorial review |
| N3-1446 | [頬](entries/1584/1584160-hoo.org) | ほお | hoo | 1584160 | learner | draft | **new** | Editorial review |
| N3-1447 | [誇り](entries/1267/1267740-hokori.org) | ほこり | hokori | 1267740 | learner | draft | **new** | Editorial review |
| N3-1448 | [埃](entries/1565/1565750-hokori.org) | ほこり | hokori | 1565750 | learner | draft | **new** | Editorial review |
| N3-1449 | [保証](entries/1603/1603500-hoshou.org) | ほしょう | hoshou | 1603500 | learner | draft | **new** | Editorial review |
| N3-1450 | [保証](entries/1603/1603500-hoshou.org) | ほしょう | hoshou | 1603500 | learner | draft | **new** | Editorial review |
| N3-1451 | [保存](entries/1513/1513940-hozon.org) | ほぞん | hozon | 1513940 | learner | draft | **new** | Editorial review |
| N3-1452 | [仏](entries/1501/1501760-hotoke.org) | ほとけ | hotoke | 1501760 | learner | draft | **new** | Editorial review |
| N3-1453 | [程](entries/1436/1436510-hodo.org) | ほど | hodo | 1436510 | learner | draft | **new** | Editorial review |
| N3-1454 | [歩道](entries/1514/1514420-hodou.org) | ほどう | hodou | 1514420 | learner | draft | **new** | Editorial review |
| N3-1455 | [骨](entries/1288/1288550-hone.org) | ほね | hone | 1288550 | learner | draft | **new** | Editorial review |
| N3-1456 | [炎](entries/1177/1177070-honoo.org) | ほのお | honoo | 1177070 | learner | draft | **new** | Editorial review |
| N3-1457 | [微笑む](entries/1486/1486030-hohoemu.org) | ほほえむ | hohoemu | 1486030 | learner | draft | **new** | Editorial review |
| N3-1458 | [略](entries/1551/1551940-hobo.org) | ほぼ | hobo | 1551940 | learner | draft | **new** | Editorial review |
| N3-1459 | [堀](entries/1522/1522060-hori.org) | ほり | hori | 1522060 | learner | draft | **new** | Editorial review |
| N3-1460 | [本人](entries/1522/1522750-honnin.org) | ほんにん | honnin | 1522750 | learner | draft | **new** | Editorial review |
| N3-1461 | [本物](entries/1523/1523180-honmono.org) | ほんもの | honmono | 1523180 | learner | draft | **new** | Editorial review |
| N3-1462 | [ホーム](entries/1121/1121740-hoomu.org) | ホーム | hoomu | 1121740 | learner | draft | **new** | Editorial review |
| N3-1463 | [棒](entries/1519/1519750-bou.org) | ぼう | bou | 1519750 | learner | draft | **new** | Editorial review |
| N3-1464 | [冒険](entries/1519/1519830-bouken.org) | ぼうけん | bouken | 1519830 | learner | draft | **new** | Editorial review |
| N3-1465 | [呆んやり](entries/1011/1011920-bonyari.org) | ぼんやり | bonyari | 1011920 | learner | draft | **new** | Editorial review |
| N3-1466 | [ボーイ](entries/1123/1123230-booi.org) | ボーイ | booi | 1123230 | learner | draft | **new** | Editorial review |
| N3-1467 | [ボート](entries/1123/1123440-booto.org) | ボート | booto | 1123440 | learner | draft | **new** | Editorial review |
| N3-1468 | [ボール](entries/1123/1123550-booru.org) | ボール | booru | 1123550 | learner | draft | **new** | Editorial review |
| N3-1469 | [間](entries/1215/1215240-ma.org) | ま | ma | 1215240 | learner | draft | **new** | Editorial review |
| N3-1470 | [まあ](entries/1012/1012050-maa.org) | まあ | maa | 1012050 | learner | draft | **new** | Editorial review |
| N3-1471 | [マイク](entries/1126/1126590-maiku.org) | マイク | maiku | 1126590 | learner | draft | **new** | Editorial review |
| N3-1472 | [迷子](entries/1532/1532750-maigo.org) | まいご | maigo | 1532750 | learner | draft | **new** | Editorial review |
| N3-1473 | [任せる](entries/1467/1467150-makaseru.org) | まかせる | makaseru | 1467150 | learner | draft | **new** | Editorial review |
| N3-1474 | [幕](entries/1524/1524750-maku.org) | まく | maku | 1524750 | learner | draft | **new** | Editorial review |
| N3-1475 | [負け](entries/1497/1497960-make.org) | まけ | make | 1497960 | learner | draft | **new** | Editorial review |
| N3-1476 | [誠に](entries/1381/1381160-makotoni.org) | まことに | makotoni | 1381160 | learner | draft | **new** | Editorial review |
| N3-1477 | [孫](entries/1406/1406230-mago.org) | まご | mago | 1406230 | learner | draft | **new** | Editorial review |
| N3-1478 | [真逆](entries/1363/1363540-masaka.org) | まさか | masaka | 1363540 | learner | draft | **new** | Editorial review |
| N3-1479 | [正に](entries/1376/1376640-masani.org) | まさに | masani | 1376640 | learner | draft | **new** | Editorial review |
| N3-1480 | [真面目](entries/1364/1364360-majime.org) | まじめ | majime | 1364360 | learner | draft | **new** | Editorial review |
| N3-1481 | [増す](entries/1403/1403120-masu.org) | ます | masu | 1403120 | learner | draft | **new** | Editorial review |
| N3-1482 | [マスター](entries/1127/1127970-masutaa.org) | マスター | masutaa | 1127970 | learner | draft | **new** | Editorial review |
| N3-1483 | [益々](entries/1603/1603950-masumasu.org) | ますます | masumasu | 1603950 | learner | draft | **new** | Editorial review |
| N3-1484 | [先ず](entries/1387/1387240-mazu.org) | まず | mazu | 1387240 | learner | draft | **new** | Editorial review |
| N3-1485 | [貧しい](entries/1490/1490740-mazushii.org) | まずしい | mazushii | 1490740 | learner | draft | **new** | Editorial review |
| N3-1486 | [間違い](entries/1215/1215320-machigai.org) | まちがい | machigai | 1215320 | learner | draft | **new** | Editorial review |
| N3-1487 | [真っ赤](entries/1363/1363250-makka.org) | まっか | makka | 1363250 | learner | draft | **new** | Editorial review |
| N3-1488 | [全く](entries/1394/1394800-mattaku.org) | まったく | mattaku | 1394800 | learner | draft | **new** | Editorial review |
| N3-1489 | [松](entries/1349/1349860-matsu.org) | まつ | matsu | 1349860 | learner | draft | **new** | Editorial review |
| N3-1490 | [祭り](entries/1604/1604130-matsuri.org) | まつり | matsuri | 1604130 | learner | draft | **new** | Editorial review |
| N3-1491 | [学ぶ](entries/1206/1206530-manabu.org) | まなぶ | manabu | 1206530 | learner | draft | **new** | Editorial review |
| N3-1492 | [真似](entries/1363/1363740-mane.org) | まね | mane | 1363740 | learner | draft | **new** | Editorial review |
| N3-1493 | [招く](entries/1349/1349590-maneku.org) | まねく | maneku | 1349590 | learner | draft | **new** | Editorial review |
| N3-1494 | [ママ](entries/1129/1129240-mama.org) | ママ | mama | 1129240 | learner | draft | **new** | Editorial review |
| N3-1495 | [豆](entries/1450/1450030-mame.org) | まめ | mame | 1450030 | learner | draft | **new** | Editorial review |
| N3-1496 | [守る](entries/1327/1327120-mamoru.org) | まもる | mamoru | 1327120 | learner | draft | **new** | Editorial review |
| N3-1497 | [丸](entries/1216/1216250-maru.org) | まる | maru | 1216250 | learner | draft | **new** | Editorial review |
| N3-1498 | [丸で](entries/1216/1216280-marude.org) | まるで | marude | 1216280 | learner | draft | **new** | Editorial review |
| N3-1499 | [回す](entries/1199/1199350-mawasu.org) | まわす | mawasu | 1199350 | learner | draft | **new** | Editorial review |
| N3-1500 | [回り](entries/2800/2800530-mawari.org) | まわり | mawari | 2800530 | learner | draft | **new** | Editorial review |
| N3-1501 | [万一](entries/1525/1525780-manichi.org) | まんいち | manichi | 1525780 | learner | draft | **new** | Editorial review |
| N3-1502 | [満足](entries/1526/1526860-manzoku.org) | まんぞく | manzoku | 1526860 | learner | draft | **new** | Editorial review |
| N3-1503 | [マーケット](entries/1126/1126190-maaketto.org) | マーケット | maaketto | 1126190 | learner | draft | **new** | Editorial review |
| N3-1504 | [身](entries/1365/1365520-mi.org) | み | mi | 1365520 | learner | draft | **new** | Editorial review |
| N3-1505 | [実](entries/1320/1320810-mi.org) | み | mi | 1320810 | learner | draft | **new** | Editorial review |
| N3-1506 | [見送り](entries/1259/1259820-miokuri.org) | みおくり | miokuri | 1259820 | learner | draft | **new** | Editorial review |
| N3-1507 | [味方](entries/1527/1527070-mikata.org) | みかた | mikata | 1527070 | learner | draft | **new** | Editorial review |
| N3-1508 | [見事](entries/1259/1259620-migoto.org) | みごと | migoto | 1259620 | learner | draft | **new** | Editorial review |
| N3-1509 | [ミス](entries/1130/1130650-misu.org) | ミス | misu | 1130650 | learner | draft | **new** | Editorial review |
| N3-1510 | [満ちる](entries/1604/1604540-michiru.org) | みちる | michiru | 1604540 | learner | draft | **new** | Editorial review |
| N3-1511 | [密](entries/2014/2014380-mitsu.org) | みつ | mitsu | 2014380 | learner | draft | **new** | Editorial review |
| N3-1512 | [認める](entries/1467/1467530-mitomeru.org) | みとめる | mitomeru | 1467530 | learner | draft | **new** | Editorial review |
| N3-1513 | [見舞い](entries/1604/1604690-mimai.org) | みまい | mimai | 1604690 | learner | draft | **new** | Editorial review |
| N3-1514 | [土産](entries/1445/1445360-miyage.org) | みやげ | miyage | 1445360 | learner | draft | **new** | Editorial review |
| N3-1515 | [都](entries/1444/1444950-miyako.org) | みやこ | miyako | 1444950 | learner | draft | **new** | Editorial review |
| N3-1516 | [妙](entries/1528/1528490-myou.org) | みょう | myou | 1528490 | learner | draft | **new** | Editorial review |
| N3-1517 | [未来](entries/1528/1528060-mirai.org) | みらい | mirai | 1528060 | learner | draft | **new** | Editorial review |
| N3-1518 | [魅力](entries/1528/1528150-miryoku.org) | みりょく | miryoku | 1528150 | learner | draft | **new** | Editorial review |
| N3-1519 | [ミルク](entries/1131/1131990-miruku.org) | ミルク | miruku | 1131990 | learner | draft | **new** | Editorial review |
| N3-1520 | [無](entries/1956/1956960-mu.org) | む | mu | 1956960 | learner | draft | **new** | Editorial review |
| N3-1521 | [向かい](entries/1604/1604750-mukai.org) | むかい | mukai | 1604750 | learner | draft | **new** | Editorial review |
| N3-1522 | [迎え](entries/1253/1253180-mukae.org) | むかえ | mukae | 1253180 | learner | draft | **new** | Editorial review |
| N3-1523 | [向く](entries/1277/1277080-muku.org) | むく | muku | 1277080 | learner | draft | **new** | Editorial review |
| N3-1524 | [向ける](entries/1277/1277100-mukeru.org) | むける | mukeru | 1277100 | learner | draft | **new** | Editorial review |
| N3-1525 | [無視](entries/1530/1530020-mushi.org) | むし | mushi | 1530020 | learner | draft | **new** | Editorial review |
| N3-1526 | [虫歯](entries/1604/1604850-mushiba.org) | むしば | mushiba | 1604850 | learner | draft | **new** | Editorial review |
| N3-1527 | [寧ろ](entries/1604/1604870-mushiro.org) | むしろ | mushiro | 1604870 | learner | draft | **new** | Editorial review |
| N3-1528 | [結ぶ](entries/1254/1254670-musubu.org) | むすぶ | musubu | 1254670 | learner | draft | **new** | Editorial review |
| N3-1529 | [無駄](entries/1530/1530510-muda.org) | むだ | muda | 1530510 | learner | draft | **new** | Editorial review |
| N3-1530 | [夢中](entries/1529/1529500-muchuu.org) | むちゅう | muchuu | 1529500 | learner | draft | **new** | Editorial review |
| N3-1531 | [胸](entries/1237/1237820-mune.org) | むね | mune | 1237820 | learner | draft | **new** | Editorial review |
| N3-1532 | [無料](entries/1531/1531040-muryou.org) | むりょう | muryou | 1531040 | learner | draft | **new** | Editorial review |
| N3-1533 | [芽](entries/1197/1197710-me.org) | め | me | 1197710 | learner | draft | **new** | Editorial review |
| N3-1534 | [明確](entries/1532/1532410-meikaku.org) | めいかく | meikaku | 1532410 | learner | draft | **new** | Editorial review |
| N3-1535 | [命じる](entries/1531/1531950-meijiru.org) | めいじる | meijiru | 1531950 | learner | draft | **new** | Editorial review |
| N3-1536 | [名人](entries/1531/1531680-meijin.org) | めいじん | meijin | 1531680 | learner | draft | **new** | Editorial review |
| N3-1537 | [命令](entries/1532/1532160-meirei.org) | めいれい | meirei | 1532160 | learner | draft | **new** | Editorial review |
| N3-1538 | [迷惑](entries/1532/1532800-meiwaku.org) | めいわく | meiwaku | 1532800 | learner | draft | **new** | Editorial review |
| N3-1539 | [飯](entries/1482/1482010-meshi.org) | めし | meshi | 1482010 | learner | draft | **new** | Editorial review |
| N3-1540 | [滅多に](entries/1612/1612000-mettani.org) | めったに | mettani | 1612000 | learner | draft | **new** | Editorial review |
| N3-1541 | [メモ](entries/1133/1133830-memo.org) | メモ | memo | 1133830 | learner | draft | **new** | Editorial review |
| N3-1542 | [面](entries/1584/1584695-men.org) | めん | men | 1584695 | learner | draft | **new** | Editorial review |
| N3-1543 | [綿](entries/1533/1533330-men.org) | めん | men | 1533330 | learner | draft | **new** | Editorial review |
| N3-1544 | [免許](entries/1533/1533130-menkyo.org) | めんきょ | menkyo | 1533130 | learner | draft | **new** | Editorial review |
| N3-1545 | [面倒](entries/1533/1533550-mendou.org) | めんどう | mendou | 1533550 | learner | draft | **new** | Editorial review |
| N3-1546 | [メンバー](entries/1134/1134370-menbaa.org) | メンバー | menbaa | 1134370 | learner | draft | **new** | Editorial review |
| N3-1547 | [申し込む](entries/1362/1362890-moushikomu.org) | もうしこむ | moushikomu | 1362890 | learner | draft | **new** | Editorial review |
| N3-1548 | [申し訳](entries/1363/1363050-moushiwake.org) | もうしわけ | moushiwake | 1363050 | learner | draft | **new** | Editorial review |
| N3-1549 | [毛布](entries/1533/1533950-moufu.org) | もうふ | moufu | 1533950 | learner | draft | **new** | Editorial review |
| N3-1550 | [燃える](entries/1469/1469570-moeru.org) | もえる | moeru | 1469570 | learner | draft | **new** | Editorial review |
| N3-1551 | [目的](entries/1535/1535560-mokuteki.org) | もくてき | mokuteki | 1535560 | learner | draft | **new** | Editorial review |
| N3-1552 | [目標](entries/1535/1535650-mokuhyou.org) | もくひょう | mokuhyou | 1535650 | learner | draft | **new** | Editorial review |
| N3-1553 | [木曜](entries/1534/1534880-mokuyou.org) | もくよう | mokuyou | 1534880 | learner | draft | **new** | Editorial review |
| N3-1554 | [若しも](entries/1612/1612050-moshimo.org) | もしも | moshimo | 1612050 | learner | draft | **new** | Editorial review |
| N3-1555 | [文字](entries/1505/1505390-moji.org) | もじ | moji | 1505390 | learner | draft | **new** | Editorial review |
| N3-1556 | [持ち上げる](entries/1315/1315610-mochiageru.org) | もちあげる | mochiageru | 1315610 | learner | draft | **new** | Editorial review |
| N3-1557 | [用いる](entries/1546/1546210-mochiiru.org) | もちいる | mochiiru | 1546210 | learner | draft | **new** | Editorial review |
| N3-1558 | [勿論](entries/1535/1535780-mochiron.org) | もちろん | mochiron | 1535780 | learner | draft | **new** | Editorial review |
| N3-1559 | [尤も](entries/1535/1535810-mottomo.org) | もっとも | mottomo | 1535810 | learner | draft | **new** | Editorial review |
| N3-1560 | [最も](entries/1293/1293700-mottomo.org) | もっとも | mottomo | 1293700 | learner | draft | **new** | Editorial review |
| N3-1561 | [元](entries/1260/1260670-moto.org) | もと | moto | 1260670 | learner | draft | **new** | Editorial review |
| N3-1562 | [元](entries/2219/2219590-moto.org) | もと | moto | 2219590 | learner | draft | **new** | Editorial review |
| N3-1563 | [基づく](entries/1605/1605270-motozuku.org) | もとづく | motozuku | 1605270 | learner | draft | **new** | Editorial review |
| N3-1564 | [求める](entries/1229/1229350-motomeru.org) | もとめる | motomeru | 1229350 | learner | draft | **new** | Editorial review |
| N3-1565 | [戻す](entries/1535/1535850-modosu.org) | もどす | modosu | 1535850 | learner | draft | **new** | Editorial review |
| N3-1566 | [者](entries/1322/1322990-mono.org) | もの | mono | 1322990 | learner | draft | **new** | Editorial review |
| N3-1567 | [物音](entries/1502/1502420-monooto.org) | ものおと | monooto | 1502420 | learner | draft | **new** | Editorial review |
| N3-1568 | [物語](entries/1502/1502480-monogatari.org) | ものがたり | monogatari | 1502480 | learner | draft | **new** | Editorial review |
| N3-1569 | [物事](entries/1502/1502550-monogoto.org) | ものごと | monogoto | 1502550 | learner | draft | **new** | Editorial review |
| N3-1570 | [模様](entries/1533/1533720-moyou.org) | もよう | moyou | 1533720 | learner | draft | **new** | Editorial review |
| N3-1571 | [貰う](entries/1535/1535910-morau.org) | もらう | morau | 1535910 | learner | draft | **new** | Editorial review |
| N3-1572 | [文句](entries/1505/1505260-monku.org) | もんく | monku | 1505260 | learner | draft | **new** | Editorial review |
| N3-1573 | [軈て](entries/1012/1012730-yagate.org) | やがて | yagate | 1012730 | learner | draft | **new** | Editorial review |
| N3-1574 | [役](entries/1537/1537970-yaku.org) | やく | yaku | 1537970 | learner | draft | **new** | Editorial review |
| N3-1575 | [約](entries/1538/1538100-yaku.org) | やく | yaku | 1538100 | learner | draft | **new** | Editorial review |
| N3-1576 | [訳](entries/2057/2057030-yaku.org) | やく | yaku | 2057030 | learner | draft | **new** | Editorial review |
| N3-1577 | [役割](entries/1538/1538000-yakuwari.org) | やくわり | yakuwari | 1538000 | learner | draft | **new** | Editorial review |
| N3-1578 | [家賃](entries/1192/1192270-yachin.org) | やちん | yachin | 1192270 | learner | draft | **new** | Editorial review |
| N3-1579 | [厄介](entries/1537/1537820-yakkai.org) | やっかい | yakkai | 1537820 | learner | draft | **new** | Editorial review |
| N3-1580 | [雇う](entries/1605/1605570-yatou.org) | やとう | yatou | 1605570 | learner | draft | **new** | Editorial review |
| N3-1581 | [宿](entries/1337/1337190-yado.org) | やど | yado | 1337190 | learner | draft | **new** | Editorial review |
| N3-1582 | [屋根](entries/1182/1182700-yane.org) | やね | yane | 1182700 | learner | draft | **new** | Editorial review |
| N3-1583 | [矢張り](entries/2772/2772770-yahari.org) | やはり | yahari | 2772770 | learner | draft | **new** | Editorial review |
| N3-1584 | [破る](entries/1471/1471200-yaburu.org) | やぶる | yaburu | 1471200 | learner | draft | **new** | Editorial review |
| N3-1585 | [辞める](entries/1318/1318950-yameru.org) | やめる | yameru | 1318950 | learner | draft | **new** | Editorial review |
| N3-1586 | [稍](entries/1570/1570120-yaya.org) | やや | yaya | 1570120 | learner | draft | **new** | Editorial review |
| N3-1587 | [唯一](entries/1538/1538920-yuiitsu.org) | ゆいいつ | yuiitsu | 1538920 | learner | draft | **new** | Editorial review |
| N3-1588 | [勇気](entries/1539/1539740-yuuki.org) | ゆうき | yuuki | 1539740 | learner | draft | **new** | Editorial review |
| N3-1589 | [有効](entries/1541/1541290-yuukou.org) | ゆうこう | yuukou | 1541290 | learner | draft | **new** | Editorial review |
| N3-1590 | [優秀](entries/1539/1539230-yuushuu.org) | ゆうしゅう | yuushuu | 1539230 | learner | draft | **new** | Editorial review |
| N3-1591 | [優勝](entries/1539/1539280-yuushou.org) | ゆうしょう | yuushou | 1539280 | learner | draft | **new** | Editorial review |
| N3-1592 | [友情](entries/1540/1540130-yuujou.org) | ゆうじょう | yuujou | 1540130 | learner | draft | **new** | Editorial review |
| N3-1593 | [友人](entries/1540/1540150-yuujin.org) | ゆうじん | yuujin | 1540150 | learner | draft | **new** | Editorial review |
| N3-1594 | [有能](entries/1541/1541570-yuunou.org) | ゆうのう | yuunou | 1541570 | learner | draft | **new** | Editorial review |
| N3-1595 | [郵便](entries/1605/1605680-yuubin.org) | ゆうびん | yuubin | 1605680 | learner | draft | **new** | Editorial review |
| N3-1596 | [有利](entries/1605/1605720-yuuri.org) | ゆうり | yuuri | 1605720 | learner | draft | **new** | Editorial review |
| N3-1597 | [床](entries/1349/1349380-yuka.org) | ゆか | yuka | 1349380 | learner | draft | **new** | Editorial review |
| N3-1598 | [愉快](entries/1538/1538560-yukai.org) | ゆかい | yukai | 1538560 | learner | draft | **new** | Editorial review |
| N3-1599 | [輸出](entries/1538/1538820-yushutsu.org) | ゆしゅつ | yushutsu | 1538820 | learner | draft | **new** | Editorial review |
| N3-1600 | [譲る](entries/1357/1357030-yuzuru.org) | ゆずる | yuzuru | 1357030 | learner | draft | **new** | Editorial review |
| N3-1601 | [豊か](entries/1518/1518130-yutaka.org) | ゆたか | yutaka | 1518130 | learner | draft | **new** | Editorial review |
| N3-1602 | [輸入](entries/1538/1538870-yunyuu.org) | ゆにゅう | yunyuu | 1538870 | learner | draft | **new** | Editorial review |
| N3-1603 | [許す](entries/1232/1232870-yurusu.org) | ゆるす | yurusu | 1232870 | learner | draft | **new** | Editorial review |
| N3-1604 | [ユーモア](entries/1136/1136850-yuumoa.org) | ユーモア | yuumoa | 1136850 | learner | draft | **new** | Editorial review |
| N3-1605 | [夜明け](entries/1537/1537150-yoake.org) | よあけ | yoake | 1537150 | learner | draft | **new** | Editorial review |
| N3-1606 | [様](entries/1605/1605840-you.org) | よう | you | 1605840 | learner | draft | **new** | Editorial review |
| N3-1607 | [酔う](entries/1372/1372650-you.org) | よう | you | 1372650 | learner | draft | **new** | Editorial review |
| N3-1608 | [容易](entries/1545/1545350-youi.org) | ようい | youi | 1545350 | learner | draft | **new** | Editorial review |
| N3-1609 | [陽気](entries/1546/1546990-youki.org) | ようき | youki | 1546990 | learner | draft | **new** | Editorial review |
| N3-1610 | [要求](entries/1546/1546680-youkyuu.org) | ようきゅう | youkyuu | 1546680 | learner | draft | **new** | Editorial review |
| N3-1611 | [用心](entries/1546/1546310-youjin.org) | ようじん | youjin | 1546310 | learner | draft | **new** | Editorial review |
| N3-1612 | [様子](entries/1545/1545820-yousu.org) | ようす | yousu | 1545820 | learner | draft | **new** | Editorial review |
| N3-1613 | [要するに](entries/1546/1546620-yousuruni.org) | ようするに | yousuruni | 1546620 | learner | draft | **new** | Editorial review |
| N3-1614 | [要素](entries/1546/1546800-youso.org) | ようそ | youso | 1546800 | learner | draft | **new** | Editorial review |
| N3-1615 | [要点](entries/1546/1546820-youten.org) | ようてん | youten | 1546820 | learner | draft | **new** | Editorial review |
| N3-1616 | [曜日](entries/1545/1545770-youbi.org) | ようび | youbi | 1545770 | learner | draft | **new** | Editorial review |
| N3-1617 | [予期](entries/1542/1542920-yoki.org) | よき | yoki | 1542920 | learner | draft | **new** | Editorial review |
| N3-1618 | [横切る](entries/1180/1180860-yokogiru.org) | よこぎる | yokogiru | 1180860 | learner | draft | **new** | Editorial review |
| N3-1619 | [予算](entries/1543/1543000-yosan.org) | よさん | yosan | 1543000 | learner | draft | **new** | Editorial review |
| N3-1620 | [止す](entries/1310/1310600-yosu.org) | よす | yosu | 1310600 | learner | draft | **new** | Editorial review |
| N3-1621 | [予測](entries/1543/1543200-yosoku.org) | よそく | yosoku | 1543200 | learner | draft | **new** | Editorial review |
| N3-1622 | [ヨット](entries/1137/1137620-yotto.org) | ヨット | yotto | 1137620 | learner | draft | **new** | Editorial review |
| N3-1623 | [夜中](entries/1536/1536930-yonaka.org) | よなか | yonaka | 1536930 | learner | draft | **new** | Editorial review |
| N3-1624 | [世の中](entries/1373/1373850-yononaka.org) | よのなか | yononaka | 1373850 | learner | draft | **new** | Editorial review |
| N3-1625 | [余分](entries/1544/1544520-yobun.org) | よぶん | yobun | 1544520 | learner | draft | **new** | Editorial review |
| N3-1626 | [予報](entries/1543/1543630-yohou.org) | よほう | yohou | 1543630 | learner | draft | **new** | Editorial review |
| N3-1627 | [予防](entries/1543/1543660-yobou.org) | よぼう | yobou | 1543660 | learner | draft | **new** | Editorial review |
| N3-1628 | [読み](entries/1456/1456130-yomi.org) | よみ | yomi | 1456130 | learner | draft | **new** | Editorial review |
| N3-1629 | [嫁](entries/1191/1191680-yome.org) | よめ | yome | 1191680 | learner | draft | **new** | Editorial review |
| N3-1630 | [余裕](entries/1544/1544590-yoyuu.org) | よゆう | yoyuu | 1544590 | learner | draft | **new** | Editorial review |
| N3-1631 | [喜び](entries/1606/1606140-yorokobi.org) | よろこび | yorokobi | 1606140 | learner | draft | **new** | Editorial review |
| N3-1632 | [宜しい](entries/1224/1224880-yoroshii.org) | よろしい | yoroshii | 1224880 | learner | draft | **new** | Editorial review |
| N3-1633 | [宜しく](entries/1224/1224890-yoroshiku.org) | よろしく | yoroshiku | 1224890 | learner | draft | **new** | Editorial review |
| N3-1634 | [欧羅巴](entries/1137/1137570-yooroppa.org) | ヨーロッパ | yooroppa | 1137570 | learner | draft | **new** | Editorial review |
| N3-1635 | [ライター](entries/1137/1137880-raitaa.org) | ライター | raitaa | 1137880 | learner | draft | **new** | Editorial review |
| N3-1636 | [楽](entries/1207/1207230-raku.org) | らく | raku | 1207230 | learner | draft | **new** | Editorial review |
| N3-1637 | [ラケット](entries/1138/1138710-raketto.org) | ラケット | raketto | 1138710 | learner | draft | **new** | Editorial review |
| N3-1638 | [利益](entries/1549/1549470-rieki.org) | りえき | rieki | 1549470 | learner | draft | **new** | Editorial review |
| N3-1639 | [理解](entries/1549/1549910-rikai.org) | りかい | rikai | 1549910 | learner | draft | **new** | Editorial review |
| N3-1640 | [陸](entries/1550/1550980-riku.org) | りく | riku | 1550980 | learner | draft | **new** | Editorial review |
| N3-1641 | [利口](entries/1549/1549550-rikou.org) | りこう | rikou | 1549550 | learner | draft | **new** | Editorial review |
| N3-1642 | [離婚](entries/1550/1550880-rikon.org) | りこん | rikon | 1550880 | learner | draft | **new** | Editorial review |
| N3-1643 | [理想](entries/1550/1550020-risou.org) | りそう | risou | 1550020 | learner | draft | **new** | Editorial review |
| N3-1644 | [率](entries/1551/1551200-ritsu.org) | りつ | ritsu | 1551200 | learner | draft | **new** | Editorial review |
| N3-1645 | [留学](entries/1552/1552740-ryuugaku.org) | りゅうがく | ryuugaku | 1552740 | learner | draft | **new** | Editorial review |
| N3-1646 | [流行](entries/1585/1585110-ryuukou.org) | りゅうこう | ryuukou | 1585110 | learner | draft | **new** | Editorial review |
| N3-1647 | [量](entries/1554/1554640-ryou.org) | りょう | ryou | 1554640 | learner | draft | **new** | Editorial review |
| N3-1648 | [両替](entries/1553/1553820-ryougae.org) | りょうがえ | ryougae | 1553820 | learner | draft | **new** | Editorial review |
| N3-1649 | [料金](entries/1554/1554280-ryoukin.org) | りょうきん | ryoukin | 1554280 | learner | draft | **new** | Editorial review |
| N3-1650 | [例](entries/1585/1585230-rei.org) | れい | rei | 1585230 | learner | draft | **new** | Editorial review |
| N3-1651 | [礼](entries/1557/1557450-rei.org) | れい | rei | 1557450 | learner | draft | **new** | Editorial review |
| N3-1652 | [冷静](entries/1557/1557050-reisei.org) | れいせい | reisei | 1557050 | learner | draft | **new** | Editorial review |
| N3-1653 | [列車](entries/1558/1558370-ressha.org) | れっしゃ | ressha | 1558370 | learner | draft | **new** | Editorial review |
| N3-1654 | [列](entries/1558/1558330-retsu.org) | れつ | retsu | 1558330 | learner | draft | **new** | Editorial review |
| N3-1655 | [連想](entries/1559/1559600-rensou.org) | れんそう | rensou | 1559600 | learner | draft | **new** | Editorial review |
| N3-1656 | [連続](entries/1559/1559610-renzoku.org) | れんぞく | renzoku | 1559610 | learner | draft | **new** | Editorial review |
| N3-1657 | [老人](entries/1561/1561090-roujin.org) | ろうじん | roujin | 1561090 | learner | draft | **new** | Editorial review |
| N3-1658 | [労働](entries/1606/1606450-roudou.org) | ろうどう | roudou | 1606450 | learner | draft | **new** | Editorial review |
| N3-1659 | [ロケット](entries/1147/1147220-roketto.org) | ロケット | roketto | 1147220 | learner | draft | **new** | Editorial review |
| N3-1660 | [論じる](entries/1561/1561620-ronjiru.org) | ろんじる | ronjiru | 1561620 | learner | draft | **new** | Editorial review |
| N3-1661 | [論争](entries/1561/1561760-ronsou.org) | ろんそう | ronsou | 1561760 | learner | draft | **new** | Editorial review |
| N3-1662 | [論文](entries/1561/1561840-ronbun.org) | ろんぶん | ronbun | 1561840 | learner | draft | **new** | Editorial review |
| N3-1663 | [輪](entries/1555/1555710-wa.org) | わ | wa | 1555710 | learner | draft | **new** | Editorial review |
| N3-1664 | [ワイン](entries/1148/1148850-wain.org) | ワイン | wain | 1148850 | learner | draft | **new** | Editorial review |
| N3-1665 | [別れ](entries/1509/1509490-wakare.org) | わかれ | wakare | 1509490 | learner | draft | **new** | Editorial review |
| N3-1666 | [我儘](entries/1197/1197020-wagamama.org) | わがまま | wagamama | 1197020 | learner | draft | **new** | Editorial review |
| N3-1667 | [脇](entries/1562/1562530-waki.org) | わき | waki | 1562530 | learner | draft | **new** | Editorial review |
| N3-1668 | [分ける](entries/1503/1503000-wakeru.org) | わける | wakeru | 1503000 | learner | draft | **new** | Editorial review |
| N3-1669 | [態と](entries/1410/1410760-wazato.org) | わざと | wazato | 1410760 | learner | draft | **new** | Editorial review |
| N3-1670 | [僅か](entries/1240/1240750-wazuka.org) | わずか | wazuka | 1240750 | learner | draft | **new** | Editorial review |
| N3-1671 | [綿](entries/1533/1533340-wata.org) | わた | wata | 1533340 | learner | draft | **new** | Editorial review |
| N3-1672 | [話題](entries/1562/1562400-wadai.org) | わだい | wadai | 1562400 | learner | draft | **new** | Editorial review |
| N3-1673 | [笑い](entries/1351/1351280-warai.org) | わらい | warai | 1351280 | learner | draft | **new** | Editorial review |
| N3-1674 | [割る](entries/1208/1208000-waru.org) | わる | waru | 1208000 | learner | draft | **new** | Editorial review |
| N3-1675 | [悪口](entries/1575/1575730-waruguchi.org) | わるぐち | waruguchi | 1575730 | learner | draft | **new** | Editorial review |
| N3-1676 | [我々](entries/1607/1607050-wareware.org) | われわれ | wareware | 1607050 | learner | draft | **new** | Editorial review |
| N3-1677 | [湾](entries/1562/1562800-wan.org) | わん | wan | 1562800 | learner | draft | **new** | Editorial review |
| N2-1 | [相変わらず](entries/1401/1401310-aikawarazu.org) | あいかわらず | aikawarazu | 1401310 | learner | draft | **new** | Editorial review |
| N2-2 | [アイデア](entries/1014/1014210-aidea.org) | アイデア | aidea | 1014210 | learner | draft | **new** | Editorial review |
| N2-3 | [曖昧](entries/1567/1567920-aimai.org) | あいまい | aimai | 1567920 | learner | draft | **new** | Editorial review |
| N2-4 | [扇ぐ](entries/1609/1609000-aogu.org) | あおぐ | aogu | 1609000 | learner | draft | **new** | Editorial review |
| N2-5 | [青白い](entries/1381/1381760-aojiroi.org) | あおじろい | aojiroi | 1381760 | learner | draft | **new** | Editorial review |
| N2-6 | [呆れる](entries/1515/1515580-akireru.org) | あきれる | akireru | 1515580 | learner | draft | **new** | Editorial review |
| N2-7 | [アクセント](entries/1015/1015310-akusento.org) | アクセント | akusento | 1015310 | learner | draft | **new** | Editorial review |
| N2-8 | [欠伸](entries/1254/1254010-akubi.org) | あくび | akubi | 1254010 | learner | draft | **new** | Editorial review |
| N2-9 | [飽くまで](entries/1518/1518320-akumade.org) | あくまで | akumade | 1518320 | learner | draft | **new** | Editorial review |
| N2-10 | [明け方](entries/1532/1532300-akegata.org) | あけがた | akegata | 1532300 | learner | draft | **new** | Editorial review |
| N2-11 | [憧れる](entries/1453/1453810-akogareru.org) | あこがれる | akogareru | 1453810 | learner | draft | **new** | Editorial review |
| N2-12 | [足跡](entries/1581/1581330-ashiato.org) | あしあと | ashiato | 1581330 | learner | draft | **new** | Editorial review |
| N2-13 | [味わう](entries/1527/1527010-ajiwau.org) | あじわう | ajiwau | 1527010 | learner | draft | **new** | Editorial review |
| N2-14 | [預かる](entries/1544/1544970-azukaru.org) | あずかる | azukaru | 1544970 | learner | draft | **new** | Editorial review |
| N2-15 | [温める](entries/1586/1586440-atatameru.org) | あたためる | atatameru | 1586440 | learner | draft | **new** | Editorial review |
| N2-16 | [当たり前](entries/1448/1448800-atarimae.org) | あたりまえ | atarimae | 1448800 | learner | draft | **new** | Editorial review |
| N2-17 | [圧縮](entries/1153/1153080-asshuku.org) | あっしゅく | asshuku | 1153080 | learner | draft | **new** | Editorial review |
| N2-18 | [厚かましい](entries/1275/1275330-atsukamashii.org) | あつかましい | atsukamashii | 1275330 | learner | draft | **new** | Editorial review |
| N2-19 | [当てはまる](entries/1448/1448930-atehamaru.org) | あてはまる | atehamaru | 1448930 | learner | draft | **new** | Editorial review |
| N2-20 | [当てはめる](entries/1586/1586530-atehameru.org) | あてはめる | atehameru | 1586530 | learner | draft | **new** | Editorial review |
| N2-21 | [暴れる](entries/1519/1519340-abareru.org) | あばれる | abareru | 1519340 | learner | draft | **new** | Editorial review |
| N2-22 | [溢れる](entries/1167/1167610-afureru.org) | あふれる | afureru | 1167610 | learner | draft | **new** | Editorial review |
| N2-23 | [脂](entries/1311/1311750-abura.org) | あぶら | abura | 1311750 | learner | draft | **new** | Editorial review |
| N2-24 | [炙る](entries/1568/1568910-aburu.org) | あぶる | aburu | 1568910 | learner | draft | **new** | Editorial review |
| N2-25 | [雨戸](entries/1171/1171970-amado.org) | あまど | amado | 1171970 | learner | draft | **new** | Editorial review |
| N2-26 | [甘やかす](entries/1213/1213470-amayakasu.org) | あまやかす | amayakasu | 1213470 | learner | draft | **new** | Editorial review |
| N2-27 | [余る](entries/1543/1543910-amaru.org) | あまる | amaru | 1543910 | learner | draft | **new** | Editorial review |
| N2-28 | [編み物](entries/1586/1586670-amimono.org) | あみもの | amimono | 1586670 | learner | draft | **new** | Editorial review |
| N2-29 | [編む](entries/1511/1511950-amu.org) | あむ | amu | 1511950 | learner | draft | **new** | Editorial review |
| N2-30 | [危うい](entries/1218/1218360-ayaui.org) | あやうい | ayaui | 1218360 | learner | draft | **new** | Editorial review |
| N2-31 | [怪しい](entries/1586/1586700-ayashii.org) | あやしい | ayashii | 1586700 | learner | draft | **new** | Editorial review |
| N2-32 | [荒い](entries/1281/1281450-arai.org) | あらい | arai | 1281450 | learner | draft | **new** | Editorial review |
| N2-33 | [粗筋](entries/1396/1396970-arasuji.org) | あらすじ | arasuji | 1396970 | learner | draft | **new** | Editorial review |
| N2-34 | [争う](entries/1400/1400620-arasou.org) | あらそう | arasou | 1400620 | learner | draft | **new** | Editorial review |
| N2-35 | [改めて](entries/1200/1200740-aratamete.org) | あらためて | aratamete | 1200740 | learner | draft | **new** | Editorial review |
| N2-36 | [改める](entries/1200/1200750-aratameru.org) | あらためる | aratameru | 1200750 | learner | draft | **new** | Editorial review |
| N2-37 | [著す](entries/1427/1427080-arawasu.org) | あらわす | arawasu | 1427080 | learner | draft | **new** | Editorial review |
| N2-38 | [有難い](entries/1541/1541560-arigatai.org) | ありがたい | arigatai | 1541560 | learner | draft | **new** | Editorial review |
| N2-39 | [彼是](entries/1612/1612650-arekore.org) | あれこれ | arekore | 1612650 | learner | draft | **new** | Editorial review |
| N2-40 | [慌ただしい](entries/1278/1278810-awatadashii.org) | あわただしい | awatadashii | 1278810 | learner | draft | **new** | Editorial review |
| N2-41 | [慌てる](entries/1278/1278830-awateru.org) | あわてる | awateru | 1278830 | learner | draft | **new** | Editorial review |
| N2-42 | [安易](entries/1153/1153720-ani.org) | あんい | ani | 1153720 | learner | draft | **new** | Editorial review |
| N2-43 | [案外](entries/1154/1154820-angai.org) | あんがい | angai | 1154820 | learner | draft | **new** | Editorial review |
| N2-44 | [アンテナ](entries/1020/1020410-antena.org) | アンテナ | antena | 1020410 | learner | draft | **new** | Editorial review |
| N2-45 | [言い出す](entries/1264/1264080-iidasu.org) | いいだす | iidasu | 1264080 | learner | draft | **new** | Editorial review |
| N2-46 | [言いつける](entries/1264/1264230-iitsukeru.org) | いいつける | iitsukeru | 1264230 | learner | draft | **new** | Editorial review |
| N2-47 | [生き生き](entries/1609/1609130-ikiiki.org) | いきいき | ikiiki | 1609130 | learner | draft | **new** | Editorial review |
| N2-48 | [行き成り](entries/1282/1282000-ikinari.org) | いきなり | ikinari | 1282000 | learner | draft | **new** | Editorial review |
| N2-49 | [意義](entries/1156/1156520-igi.org) | いぎ | igi | 1156520 | learner | draft | **new** | Editorial review |
| N2-50 | [育児](entries/1160/1160630-ikuji.org) | いくじ | ikuji | 1160630 | learner | draft | **new** | Editorial review |
| N2-51 | [幾分](entries/1220/1220060-ikubun.org) | いくぶん | ikubun | 1220060 | learner | draft | **new** | Editorial review |
| N2-52 | [生け花](entries/1587/1587180-ikebana.org) | いけばな | ikebana | 1587180 | learner | draft | **new** | Editorial review |
| N2-53 | [以降](entries/1155/1155110-ikou.org) | いこう | ikou | 1155110 | learner | draft | **new** | Editorial review |
| N2-54 | [イコール](entries/1021/1021220-ikooru.org) | イコール | ikooru | 1021220 | learner | draft | **new** | Editorial review |
| N2-55 | [以後](entries/1155/1155100-igo.org) | いご | igo | 1155100 | learner | draft | **new** | Editorial review |
| N2-56 | [勇ましい](entries/1539/1539660-isamashii.org) | いさましい | isamashii | 1539660 | learner | draft | **new** | Editorial review |
| N2-57 | [衣食住](entries/1158/1158780-ishokujuu.org) | いしょくじゅう | ishokujuu | 1158780 | learner | draft | **new** | Editorial review |
| N2-58 | [意地悪](entries/1156/1156740-ijiwaru.org) | いじわる | ijiwaru | 1156740 | learner | draft | **new** | Editorial review |
| N2-59 | [一々](entries/1587/1587320-ichiichi.org) | いちいち | ichiichi | 1587320 | learner | draft | **new** | Editorial review |
| N2-60 | [一応](entries/1161/1161170-ichiou.org) | いちおう | ichiou | 1161170 | learner | draft | **new** | Editorial review |
| N2-61 | [一段](entries/1164/1164690-ichidan.org) | いちだん | ichidan | 1164690 | learner | draft | **new** | Editorial review |
| N2-62 | [一流](entries/1167/1167270-ichiryuu.org) | いちりゅう | ichiryuu | 1167270 | learner | draft | **new** | Editorial review |
| N2-63 | [一昨昨日](entries/1576/1576030-issakusakujitsu.org) | いっさくさくじつ | issakusakujitsu | 1576030 | learner | draft | **new** | Editorial review |
| N2-64 | [一斉](entries/1164/1164040-issei.org) | いっせい | issei | 1164040 | learner | draft | **new** | Editorial review |
| N2-65 | [一旦](entries/1164/1164650-ittan.org) | いったん | ittan | 1164650 | learner | draft | **new** | Editorial review |
| N2-66 | [一定](entries/1164/1164950-ittei.org) | いってい | ittei | 1164950 | learner | draft | **new** | Editorial review |
| N2-67 | [行ってまいります](entries/2149/2149180-ittemairimasu.org) | いってまいります | ittemairimasu | 2149180 | learner | draft | **existing** | Editorial review |
| N2-68 | [行ってらっしゃい](entries/2088/2088750-itterasshai.org) | いってらっしゃい | itterasshai | 2088750 | learner | draft | **existing** | Editorial review |
| N2-70 | [いつの間にか](entries/1188/1188850-itsunomanika.org) | いつのまにか | itsunomanika | 1188850 | learner | draft | **new** | Editorial review |
| N2-71 | [移転](entries/1158/1158390-iten.org) | いてん | iten | 1158390 | learner | draft | **new** | Editorial review |
| N2-72 | [従姉妹](entries/1335/1335310-itoko.org) | いとこ | itoko | 1335310 | learner | draft | **new** | Editorial review |
| N2-73 | [緯度](entries/1158/1158490-ido.org) | いど | ido | 1158490 | learner | draft | **new** | Editorial review |
| N2-74 | [井戸](entries/1160/1160330-ido.org) | いど | ido | 1160330 | learner | draft | **new** | Editorial review |
| N2-75 | [威張る](entries/1156/1156320-ibaru.org) | いばる | ibaru | 1156320 | learner | draft | **new** | Editorial review |
| N2-76 | [嫌がる](entries/1609/1609260-iyagaru.org) | いやがる | iyagaru | 1609260 | learner | draft | **new** | Editorial review |
| N2-77 | [愈](entries/1587/1587670-iyoiyo.org) | いよいよ | iyoiyo | 1587670 | learner | draft | **new** | Editorial review |
| N2-78 | [炒る](entries/1391/1391500-iru.org) | いる | iru | 1391500 | learner | draft | **new** | Editorial review |
| N2-79 | [入れ物](entries/1587/1587840-iremono.org) | いれもの | iremono | 1587840 | learner | draft | **new** | Editorial review |
| N2-80 | [インタビュー](entries/1023/1023100-intabyuu.org) | インタビュー | intabyuu | 1023100 | learner | draft | **new** | Editorial review |
| N2-81 | [引力](entries/1169/1169720-inryoku.org) | いんりょく | inryoku | 1169720 | learner | draft | **new** | Editorial review |
| N2-82 | [ウェイトレス](entries/1025/1025690-weitoresu.org) | ウェイトレス | weitoresu | 1025690 | learner | draft | **new** | Editorial review |
| N2-83 | [植木](entries/1587/1587970-ueki.org) | うえき | ueki | 1587970 | learner | draft | **new** | Editorial review |
| N2-84 | [飢える](entries/1224/1224080-ueru.org) | うえる | ueru | 1224080 | learner | draft | **new** | Editorial review |
| N2-85 | [浮かぶ](entries/1497/1497430-ukabu.org) | うかぶ | ukabu | 1497430 | learner | draft | **new** | Editorial review |
| N2-86 | [浮かべる](entries/1497/1497360-ukaberu.org) | うかべる | ukaberu | 1497360 | learner | draft | **new** | Editorial review |
| N2-87 | [浮く](entries/1497/1497420-uku.org) | うく | uku | 1497420 | learner | draft | **new** | Editorial review |
| N2-88 | [承る](entries/1349/1349440-uketamawaru.org) | うけたまわる | uketamawaru | 1349440 | learner | draft | **new** | Editorial review |
| N2-89 | [受け取り](entries/1329/1329770-uketori.org) | うけとり | uketori | 1329770 | learner | draft | **new** | Editorial review |
| N2-90 | [受け持つ](entries/1329/1329640-ukemotsu.org) | うけもつ | ukemotsu | 1329640 | learner | draft | **new** | Editorial review |
| N2-91 | [薄暗い](entries/1475/1475530-usugurai.org) | うすぐらい | usugurai | 1475530 | learner | draft | **new** | Editorial review |
| N2-92 | [薄める](entries/1475/1475500-usumeru.org) | うすめる | usumeru | 1475500 | learner | draft | **new** | Editorial review |
| N2-93 | [打ち合わせ](entries/1588/1588140-uchiawase.org) | うちあわせ | uchiawase | 1588140 | learner | draft | **new** | Editorial review |
| N2-94 | [打ち消す](entries/1609/1609310-uchikesu.org) | うちけす | uchikesu | 1609310 | learner | draft | **new** | Editorial review |
| N2-95 | [うっかり](entries/1001/1001010-ukkari.org) | うっかり | ukkari | 1001010 | learner | draft | **new** | Editorial review |
| N2-96 | [映す](entries/1588/1588330-utsusu.org) | うつす | utsusu | 1588330 | learner | draft | **new** | Editorial review |
| N2-97 | [映る](entries/1173/1173710-utsuru.org) | うつる | utsuru | 1173710 | learner | draft | **new** | Editorial review |
| N2-98 | [写る](entries/1321/1321820-utsuru.org) | うつる | utsuru | 1321820 | learner | draft | **new** | Editorial review |
| N2-99 | [饂飩](entries/1574/1574470-udon.org) | うどん | udon | 1574470 | learner | draft | **new** | Editorial review |
| N2-100 | [有無](entries/1541/1541610-umu.org) | うむ | umu | 1541610 | learner | draft | **new** | Editorial review |
| N2-101 | [埋める](entries/1524/1524500-umeru.org) | うめる | umeru | 1524500 | learner | draft | **new** | Editorial review |
| N2-102 | [敬う](entries/1250/1250700-uyamau.org) | うやまう | uyamau | 1250700 | learner | draft | **new** | Editorial review |
| N2-103 | [裏返す](entries/1550/1550630-uragaesu.org) | うらがえす | uragaesu | 1550630 | learner | draft | **new** | Editorial review |
| N2-104 | [裏口](entries/1550/1550270-uraguchi.org) | うらぐち | uraguchi | 1550270 | learner | draft | **new** | Editorial review |
| N2-105 | [占う](entries/1389/1389430-uranau.org) | うらなう | uranau | 1389430 | learner | draft | **new** | Editorial review |
| N2-106 | [恨み](entries/1289/1289740-urami.org) | うらみ | urami | 1289740 | learner | draft | **new** | Editorial review |
| N2-107 | [恨む](entries/1289/1289780-uramu.org) | うらむ | uramu | 1289780 | learner | draft | **new** | Editorial review |
| N2-108 | [羨ましい](entries/1391/1391940-urayamashii.org) | うらやましい | urayamashii | 1391940 | learner | draft | **new** | Editorial review |
| N2-109 | [羨む](entries/1391/1391950-urayamu.org) | うらやむ | urayamu | 1391950 | learner | draft | **new** | Editorial review |
| N2-110 | [売り上げ](entries/1588/1588500-uriage.org) | うりあげ | uriage | 1588500 | learner | draft | **new** | Editorial review |
| N2-111 | [売り切れ](entries/1473/1473870-urikire.org) | うりきれ | urikire | 1473870 | learner | draft | **new** | Editorial review |
| N2-112 | [売り切れる](entries/1473/1473880-urikireru.org) | うりきれる | urikireru | 1473880 | learner | draft | **new** | Editorial review |
| N2-113 | [売れ行き](entries/1588/1588590-ureyuki.org) | うれゆき | ureyuki | 1588590 | learner | draft | **new** | Editorial review |
| N2-114 | [うろうろ](entries/1001/1001060-urouro.org) | うろうろ | urouro | 1001060 | learner | draft | **new** | Editorial review |
| N2-115 | [運河](entries/1172/1172710-unga.org) | うんが | unga | 1172710 | learner | draft | **new** | Editorial review |
| N2-116 | [うんと](entries/2007/2007420-unto.org) | うんと | unto | 2007420 | learner | draft | **new** | Editorial review |
| N2-117 | [ウーマン](entries/1024/1024950-uuman.org) | ウーマン | uuman | 1024950 | learner | draft | **new** | Editorial review |
| N2-118 | [ウール](entries/1025/1025010-uuru.org) | ウール | uuru | 1025010 | learner | draft | **new** | Editorial review |
| N2-119 | [英文](entries/1174/1174620-eibun.org) | えいぶん | eibun | 1174620 | learner | draft | **new** | Editorial review |
| N2-120 | [英和](entries/1174/1174720-eiwa.org) | えいわ | eiwa | 1174720 | learner | draft | **new** | Editorial review |
| N2-121 | [液体](entries/1175/1175030-ekitai.org) | えきたい | ekitai | 1175030 | learner | draft | **new** | Editorial review |
| N2-122 | [エチケット](entries/1028/1028990-echiketto.org) | エチケット | echiketto | 1028990 | learner | draft | **new** | Editorial review |
| N2-123 | [えっと](entries/1001/1001150-etto.org) | えっと | etto | 1001150 | learner | draft | **new** | Editorial review |
| N2-124 | [エプロン](entries/1029/1029760-epuron.org) | エプロン | epuron | 1029760 | learner | draft | **new** | Editorial review |
| N2-125 | [偉い](entries/1155/1155780-erai.org) | えらい | erai | 1155780 | learner | draft | **new** | Editorial review |
| N2-126 | [宴会](entries/1176/1176320-enkai.org) | えんかい | enkai | 1176320 | learner | draft | **new** | Editorial review |
| N2-127 | [園芸](entries/1176/1176260-engei.org) | えんげい | engei | 1176260 | learner | draft | **new** | Editorial review |
| N2-128 | [演劇](entries/1176/1176860-engeki.org) | えんげき | engeki | 1176860 | learner | draft | **new** | Editorial review |
| N2-129 | [円周](entries/1175/1175860-enshuu.org) | えんしゅう | enshuu | 1175860 | learner | draft | **new** | Editorial review |
| N2-130 | [遠足](entries/1178/1178260-ensoku.org) | えんそく | ensoku | 1178260 | learner | draft | **new** | Editorial review |
| N2-131 | [延長](entries/1176/1176510-enchou.org) | えんちょう | enchou | 1176510 | learner | draft | **new** | Editorial review |
| N2-132 | [煙突](entries/1177/1177320-entotsu.org) | えんとつ | entotsu | 1177320 | learner | draft | **new** | Editorial review |
| N2-133 | [追いかける](entries/1608/1608720-oikakeru.org) | おいかける | oikakeru | 1608720 | learner | draft | **new** | Editorial review |
| N2-134 | [追い越す](entries/1432/1432280-oikosu.org) | おいこす | oikosu | 1432280 | learner | draft | **new** | Editorial review |
| N2-135 | [オイル](entries/1033/1033900-oiru.org) | オイル | oiru | 1033900 | learner | draft | **new** | Editorial review |
| N2-136 | [応援](entries/1179/1179840-ouen.org) | おうえん | ouen | 1179840 | learner | draft | **new** | Editorial review |
| N2-137 | [王女](entries/1181/1181560-oujo.org) | おうじょ | oujo | 1181560 | learner | draft | **new** | Editorial review |
| N2-138 | [応ずる](entries/1609/1609380-ouzuru.org) | おうずる | ouzuru | 1609380 | learner | draft | **new** | Editorial review |
| N2-139 | [応接](entries/1179/1179930-ousetsu.org) | おうせつ | ousetsu | 1179930 | learner | draft | **new** | Editorial review |
| N2-140 | [応対](entries/1179/1179980-outai.org) | おうたい | outai | 1179980 | learner | draft | **new** | Editorial review |
| N2-141 | [往復](entries/1179/1179760-oufuku.org) | おうふく | oufuku | 1179760 | learner | draft | **new** | Editorial review |
| N2-142 | [欧米](entries/1609/1609390-oubei.org) | おうべい | oubei | 1609390 | learner | draft | **new** | Editorial review |
| N2-143 | [応用](entries/1180/1180060-ouyou.org) | おうよう | ouyou | 1180060 | learner | draft | **new** | Editorial review |
| N2-144 | [大雑把](entries/1412/1412950-oozappa.org) | おおざっぱ | oozappa | 1412950 | learner | draft | **new** | Editorial review |
| N2-145 | [大通り](entries/1414/1414570-oodoori.org) | おおどおり | oodoori | 1414570 | learner | draft | **new** | Editorial review |
| N2-146 | [大凡](entries/1415/1415050-ooyoso.org) | おおよそ | ooyoso | 1415050 | learner | draft | **new** | Editorial review |
| N2-147 | [お帰り](entries/1612/1612780-okaeri.org) | おかえり | okaeri | 1612780 | learner | draft | **new** | Editorial review |
| N2-148 | [お掛け下さい](entries/2411/2411600-okakekudasai.org) | おかけください | okakekudasai | 2411600 | learner | draft | **new** | Editorial review |
| N2-149 | [お陰様で](entries/1270/1270220-okagesamade.org) | おかげさまで | okagesamade | 1270220 | learner | draft | **existing** | Editorial review |
| N2-150 | [お菜](entries/1588/1588930-okazu.org) | おかず | okazu | 1588930 | learner | draft | **new** | Editorial review |
| N2-151 | [お代わり](entries/1612/1612800-okawari.org) | おかわり | okawari | 1612800 | learner | draft | **new** | Editorial review |
| N2-152 | [拝む](entries/1472/1472230-ogamu.org) | おがむ | ogamu | 1472230 | learner | draft | **new** | Editorial review |
| N2-153 | [お気の毒に](entries/2167/2167510-okinodokuni.org) | おきのどくに | okinodokuni | 2167510 | learner | draft | **new** | Editorial review |
| N2-154 | [補う](entries/1514/1514460-oginau.org) | おぎなう | oginau | 1514460 | learner | draft | **new** | Editorial review |
| N2-155 | [屋外](entries/1182/1182680-okugai.org) | おくがい | okugai | 1182680 | learner | draft | **new** | Editorial review |
| N2-156 | [送り仮名](entries/1402/1402640-okurigana.org) | おくりがな | okurigana | 1402640 | learner | draft | **new** | Editorial review |
| N2-157 | [怠る](entries/1410/1410710-okotaru.org) | おこたる | okotaru | 1410710 | learner | draft | **new** | Editorial review |
| N2-158 | [押さえる](entries/1589/1589080-osaeru.org) | おさえる | osaeru | 1589080 | learner | draft | **new** | Editorial review |
| N2-159 | [お先に](entries/1002/1002280-osakini.org) | おさきに | osakini | 1002280 | learner | draft | **new** | Editorial review |
| N2-160 | [治める](entries/1316/1316830-osameru.org) | おさめる | osameru | 1316830 | learner | draft | **new** | Editorial review |
| N2-161 | [惜しい](entries/1382/1382280-oshii.org) | おしい | oshii | 1382280 | learner | draft | **new** | Editorial review |
| N2-162 | [お洒落](entries/1002/1002770-oshare.org) | おしゃれ | oshare | 1002770 | learner | draft | **new** | Editorial review |
| N2-163 | [お辞儀](entries/1002/1002030-ojigi.org) | おじぎ | ojigi | 1002030 | learner | draft | **new** | Editorial review |
| N2-164 | [伯父さん](entries/2261/2261490-ojisan.org) | おじさん | ojisan | 2261490 | learner | draft | **new** | Editorial review |
| N2-165 | [お邪魔します](entries/1002/1002050-ojamashimasu.org) | おじゃまします | ojamashimasu | 1002050 | learner | draft | **new** | Editorial review |
| N2-166 | [教わる](entries/1236/1236940-osowaru.org) | おそわる | osowaru | 1236940 | learner | draft | **new** | Editorial review |
| N2-167 | [お大事に](entries/1002/1002390-odaijini.org) | おだいじに | odaijini | 1002390 | learner | draft | **existing** | Editorial review |
| N2-168 | [落ち着く](entries/1589/1589220-ochitsuku.org) | おちつく | ochitsuku | 1589220 | learner | draft | **new** | Editorial review |
| N2-169 | [お手伝いさん](entries/1002/1002110-otetsudaisan.org) | おてつだいさん | otetsudaisan | 1002110 | learner | draft | **new** | Editorial review |
| N2-170 | [お出かけ](entries/1338/1338475-odekake.org) | おでかけ | odekake | 1338475 | learner | draft | **new** | Editorial review |
| N2-171 | [落し物](entries/1589/1589250-otoshimono.org) | おとしもの | otoshimono | 1589250 | learner | draft | **new** | Editorial review |
| N2-172 | [大人しい](entries/1414/1414190-otonashii.org) | おとなしい | otonashii | 1414190 | learner | draft | **new** | Editorial review |
| N2-173 | [脅かす](entries/1578/1578070-odokasu.org) | おどかす | odokasu | 1578070 | learner | draft | **new** | Editorial review |
| N2-174 | [驚かす](entries/1238/1238650-odorokasu.org) | おどろかす | odorokasu | 1238650 | learner | draft | **new** | Editorial review |
| N2-175 | [お願いします](entries/1001/1001720-onegaishimasu.org) | おねがいします | onegaishimasu | 1001720 | learner | draft | **new** | Editorial review |
| N2-176 | [お早う](entries/1612/1612820-ohayou.org) | おはよう | ohayou | 1612820 | learner | draft | **new** | Editorial review |
| N2-177 | [お参り](entries/1001/1001950-omairi.org) | おまいり | omairi | 1001950 | learner | draft | **new** | Editorial review |
| N2-178 | [お待たせしました](entries/2149/2149640-omataseshimashita.org) | おまたせしました | omataseshimashita | 2149640 | learner | draft | **existing** | Editorial review |
| N2-179 | [お待ちどおさま](entries/1002/1002360-omachidoosama.org) | おまちどおさま | omachidoosama | 1002360 | learner | draft | **new** | Editorial review |
| N2-180 | [お目出度い](entries/1647/1647360-omedetai.org) | おめでたい | omedetai | 1647360 | learner | draft | **new** | Editorial review |
| N2-181 | [思いがけない](entries/1610/1610630-omoigakenai.org) | おもいがけない | omoigakenai | 1610630 | learner | draft | **new** | Editorial review |
| N2-182 | [思い込む](entries/1309/1309230-omoikomu.org) | おもいこむ | omoikomu | 1309230 | learner | draft | **new** | Editorial review |
| N2-183 | [思いっきり](entries/1309/1309310-omoikkiri.org) | おもいっきり | omoikkiri | 1309310 | learner | draft | **new** | Editorial review |
| N2-184 | [思いつく](entries/1589/1589330-omoitsuku.org) | おもいつく | omoitsuku | 1589330 | learner | draft | **new** | Editorial review |
| N2-185 | [お休み](entries/1612/1612680-oyasumi.org) | おやすみ | oyasumi | 1612680 | learner | draft | **new** | Editorial review |
| N2-186 | [お八つ](entries/1589/1589430-oyatsu.org) | おやつ | oyatsu | 1589430 | learner | draft | **new** | Editorial review |
| N2-187 | [親指](entries/1365/1365190-oyayubi.org) | おやゆび | oyayubi | 1365190 | learner | draft | **new** | Editorial review |
| N2-188 | [オルガン](entries/1035/1035780-orugan.org) | オルガン | orugan | 1035780 | learner | draft | **new** | Editorial review |
| N2-189 | [卸す](entries/1183/1183050-orosu.org) | おろす | orosu | 1183050 | learner | draft | **new** | Editorial review |
| N2-190 | [恩恵](entries/1183/1183140-onkei.org) | おんけい | onkei | 1183140 | learner | draft | **new** | Editorial review |
| N2-191 | [温室](entries/1183/1183390-onshitsu.org) | おんしつ | onshitsu | 1183390 | learner | draft | **new** | Editorial review |
| N2-192 | [温泉](entries/1183/1183450-onsen.org) | おんせん | onsen | 1183450 | learner | draft | **new** | Editorial review |
| N2-193 | [温帯](entries/1183/1183470-ontai.org) | おんたい | ontai | 1183470 | learner | draft | **new** | Editorial review |
| N2-194 | [女の人](entries/1344/1344980-onnanohito.org) | おんなのひと | onnanohito | 1344980 | learner | draft | **new** | Editorial review |
| N2-195 | [オーケストラ](entries/1031/1031610-ookesutora.org) | オーケストラ | ookesutora | 1031610 | learner | draft | **new** | Editorial review |
| N2-196 | [オートメーション](entries/1032/1032180-ootomeeshon.org) | オートメーション | ootomeeshon | 1032180 | learner | draft | **new** | Editorial review |
| N2-197 | [オーバーコート](entries/1032/1032880-oobaakooto.org) | オーバーコート | oobaakooto | 1032880 | learner | draft | **new** | Editorial review |
| N2-198 | [蚊](entries/1196/1196540-ka.org) | か | ka | 1196540 | learner | draft | **new** | Editorial review |
| N2-199 | [開会](entries/1202/1202560-kaikai.org) | かいかい | kaikai | 1202560 | learner | draft | **new** | Editorial review |
| N2-200 | [会館](entries/1589/1589660-kaikan.org) | かいかん | kaikan | 1589660 | learner | draft | **new** | Editorial review |
| N2-201 | [解散](entries/1199/1199000-kaisan.org) | かいさん | kaisan | 1199000 | learner | draft | **new** | Editorial review |
| N2-202 | [海水浴](entries/1201/1201520-kaisuiyoku.org) | かいすいよく | kaisuiyoku | 1201520 | learner | draft | **new** | Editorial review |
| N2-203 | [回数](entries/1199/1199510-kaisuu.org) | かいすう | kaisuu | 1199510 | learner | draft | **new** | Editorial review |
| N2-204 | [回数券](entries/1199/1199520-kaisuuken.org) | かいすうけん | kaisuuken | 1199520 | learner | draft | **new** | Editorial review |
| N2-205 | [改正](entries/1200/1200930-kaisei.org) | かいせい | kaisei | 1200930 | learner | draft | **new** | Editorial review |
| N2-206 | [快晴](entries/1200/1200060-kaisei.org) | かいせい | kaisei | 1200060 | learner | draft | **new** | Editorial review |
| N2-207 | [解説](entries/1199/1199080-kaisetsu.org) | かいせつ | kaisetsu | 1199080 | learner | draft | **new** | Editorial review |
| N2-208 | [改造](entries/1201/1201000-kaizou.org) | かいぞう | kaizou | 1201000 | learner | draft | **new** | Editorial review |
| N2-209 | [開通](entries/1202/1202850-kaitsuu.org) | かいつう | kaitsuu | 1202850 | learner | draft | **new** | Editorial review |
| N2-210 | [回転](entries/1199/1199640-kaiten.org) | かいてん | kaiten | 1199640 | learner | draft | **new** | Editorial review |
| N2-211 | [回答](entries/1199/1199680-kaitou.org) | かいとう | kaitou | 1199680 | learner | draft | **new** | Editorial review |
| N2-212 | [解答](entries/1199/1199160-kaitou.org) | かいとう | kaitou | 1199160 | learner | draft | **new** | Editorial review |
| N2-213 | [開放](entries/1202/1202950-kaihou.org) | かいほう | kaihou | 1202950 | learner | draft | **new** | Editorial review |
| N2-214 | [解放](entries/1199/1199250-kaihou.org) | かいほう | kaihou | 1199250 | learner | draft | **new** | Editorial review |
| N2-215 | [海洋](entries/1201/1201790-kaiyou.org) | かいよう | kaiyou | 1201790 | learner | draft | **new** | Editorial review |
| N2-216 | [帰す](entries/1221/1221240-kaesu.org) | かえす | kaesu | 1221240 | learner | draft | **new** | Editorial review |
| N2-217 | [却って](entries/1226/1226610-kaette.org) | かえって | kaette | 1226610 | learner | draft | **new** | Editorial review |
| N2-218 | [返る](entries/1512/1512150-kaeru.org) | かえる | kaeru | 1512150 | learner | draft | **new** | Editorial review |
| N2-219 | [家屋](entries/1191/1191780-kaoku.org) | かおく | kaoku | 1191780 | learner | draft | **new** | Editorial review |
| N2-220 | [関わる](entries/1589/1589880-kakawaru.org) | かかわる | kakawaru | 1589880 | learner | draft | **new** | Editorial review |
| N2-221 | [書き取り](entries/1589/1589970-kakitori.org) | かきとり | kakitori | 1589970 | learner | draft | **new** | Editorial review |
| N2-222 | [垣根](entries/1204/1204800-kakine.org) | かきね | kakine | 1204800 | learner | draft | **new** | Editorial review |
| N2-223 | [掻く](entries/1399/1399970-kaku.org) | かく | kaku | 1399970 | learner | draft | **new** | Editorial review |
| N2-224 | [架空](entries/1193/1193130-kakuu.org) | かくう | kakuu | 1193130 | learner | draft | **new** | Editorial review |
| N2-225 | [各自](entries/1205/1205010-kakuji.org) | かくじ | kakuji | 1205010 | learner | draft | **new** | Editorial review |
| N2-226 | [拡充](entries/1205/1205190-kakujuu.org) | かくじゅう | kakujuu | 1205190 | learner | draft | **new** | Editorial review |
| N2-227 | [各地](entries/1205/1205100-kakuchi.org) | かくち | kakuchi | 1205100 | learner | draft | **new** | Editorial review |
| N2-228 | [角度](entries/1206/1206190-kakudo.org) | かくど | kakudo | 1206190 | learner | draft | **new** | Editorial review |
| N2-229 | [格別](entries/1205/1205490-kakubetsu.org) | かくべつ | kakubetsu | 1205490 | learner | draft | **new** | Editorial review |
| N2-230 | [確率](entries/1205/1205950-kakuritsu.org) | かくりつ | kakuritsu | 1205950 | learner | draft | **new** | Editorial review |
| N2-231 | [嗅ぐ](entries/1565/1565480-kagu.org) | かぐ | kagu | 1565480 | learner | draft | **new** | Editorial review |
| N2-232 | [掛け算](entries/1590/1590080-kakezan.org) | かけざん | kakezan | 1590080 | learner | draft | **new** | Editorial review |
| N2-233 | [可決](entries/1190/1190810-kaketsu.org) | かけつ | kaketsu | 1190810 | learner | draft | **new** | Editorial review |
| N2-234 | [ｘ](entries/2197/2197150-batsu.org) | ばつ | batsu | 2197150 | learner | draft | **new** | Editorial review |
| N2-235 | [火口](entries/1193/1193860-kakou.org) | かこう | kakou | 1193860 | learner | draft | **new** | Editorial review |
| N2-236 | [下降](entries/1184/1184940-kakou.org) | かこう | kakou | 1184940 | learner | draft | **new** | Editorial review |
| N2-237 | [重なる](entries/1335/1335800-kasanaru.org) | かさなる | kasanaru | 1335800 | learner | draft | **new** | Editorial review |
| N2-238 | [重ねる](entries/1335/1335830-kasaneru.org) | かさねる | kasaneru | 1335830 | learner | draft | **new** | Editorial review |
| N2-239 | [飾り](entries/1357/1357160-kazari.org) | かざり | kazari | 1357160 | learner | draft | **new** | Editorial review |
| N2-240 | [火山](entries/1193/1193910-kazan.org) | かざん | kazan | 1193910 | learner | draft | **new** | Editorial review |
| N2-241 | [畏まりました](entries/1002/1002790-kashikomarimashita.org) | かしこまりました | kashikomarimashita | 1002790 | learner | draft | **existing** | Editorial review |
| N2-242 | [過失](entries/1196/1196120-kashitsu.org) | かしつ | kashitsu | 1196120 | learner | draft | **new** | Editorial review |
| N2-243 | [貸間](entries/1609/1609530-kashima.org) | かしま | kashima | 1609530 | learner | draft | **new** | Editorial review |
| N2-244 | [貸家](entries/1411/1411170-kashiya.org) | かしや | kashiya | 1411170 | learner | draft | **new** | Editorial review |
| N2-245 | [果実](entries/1192/1192940-kajitsu.org) | かじつ | kajitsu | 1192940 | learner | draft | **new** | Editorial review |
| N2-246 | [過剰](entries/1196/1196170-kajou.org) | かじょう | kajou | 1196170 | learner | draft | **new** | Editorial review |
| N2-247 | [齧る](entries/1610/1610640-kajiru.org) | かじる | kajiru | 1610640 | learner | draft | **new** | Editorial review |
| N2-248 | [カセット](entries/1037/1037400-kasetto.org) | カセット | kasetto | 1037400 | learner | draft | **new** | Editorial review |
| N2-249 | [下線](entries/1185/1185640-kasen.org) | かせん | kasen | 1185640 | learner | draft | **new** | Editorial review |
| N2-250 | [課税](entries/1195/1195790-kazei.org) | かぜい | kazei | 1195790 | learner | draft | **new** | Editorial review |
| N2-251 | [加速](entries/1190/1190370-kasoku.org) | かそく | kasoku | 1190370 | learner | draft | **new** | Editorial review |
| N2-252 | [加速度](entries/1190/1190390-kasokudo.org) | かそくど | kasokudo | 1190390 | learner | draft | **new** | Editorial review |
| N2-253 | [片仮名](entries/1511/1511600-katakana.org) | カタカナ | katakana | 1511600 | learner | draft | **new** | Editorial review |
| N2-254 | [片付く](entries/1511/1511770-katazuku.org) | かたづく | katazuku | 1511770 | learner | draft | **new** | Editorial review |
| N2-255 | [塊](entries/1590/1590410-katamari.org) | かたまり | katamari | 1590410 | learner | draft | **new** | Editorial review |
| N2-256 | [固まる](entries/1266/1266550-katamaru.org) | かたまる | katamaru | 1266550 | learner | draft | **new** | Editorial review |
| N2-257 | [片道](entries/1511/1511760-katamichi.org) | かたみち | katamichi | 1511760 | learner | draft | **new** | Editorial review |
| N2-258 | [傾く](entries/1578/1578210-katamuku.org) | かたむく | katamuku | 1578210 | learner | draft | **new** | Editorial review |
| N2-259 | [偏る](entries/1590/1590420-katayoru.org) | かたよる | katayoru | 1590420 | learner | draft | **new** | Editorial review |
| N2-260 | [括弧](entries/1208/1208240-kakko.org) | かっこ | kakko | 1208240 | learner | draft | **new** | Editorial review |
| N2-261 | [担ぐ](entries/1418/1418140-katsugu.org) | かつぐ | katsugu | 1418140 | learner | draft | **new** | Editorial review |
| N2-262 | [活字](entries/1208/1208300-katsuji.org) | かつじ | katsuji | 1208300 | learner | draft | **new** | Editorial review |
| N2-263 | [活躍](entries/1208/1208450-katsuyaku.org) | かつやく | katsuyaku | 1208450 | learner | draft | **new** | Editorial review |
| N2-264 | [活力](entries/1208/1208480-katsuryoku.org) | かつりょく | katsuryoku | 1208480 | learner | draft | **new** | Editorial review |
| N2-265 | [過程](entries/1196/1196270-katei.org) | かてい | katei | 1196270 | learner | draft | **new** | Editorial review |
| N2-266 | [課程](entries/1195/1195850-katei.org) | かてい | katei | 1195850 | learner | draft | **new** | Editorial review |
| N2-267 | [仮定](entries/1187/1187870-katei.org) | かてい | katei | 1187870 | learner | draft | **new** | Editorial review |
| N2-268 | [仮名](entries/1590/1590540-kana.org) | かな | kana | 1590540 | learner | draft | **new** | Editorial review |
| N2-269 | [仮名遣い](entries/1188/1188100-kanazukai.org) | かなづかい | kanazukai | 1188100 | learner | draft | **new** | Editorial review |
| N2-270 | [鐘](entries/1352/1352030-kane.org) | かね | kane | 1352030 | learner | draft | **new** | Editorial review |
| N2-271 | [加熱](entries/1190/1190470-kanetsu.org) | かねつ | kanetsu | 1190470 | learner | draft | **new** | Editorial review |
| N2-272 | [兼ねる](entries/1256/1256520-kaneru.org) | かねる | kaneru | 1256520 | learner | draft | **new** | Editorial review |
| N2-273 | [過半数](entries/1196/1196380-kahansuu.org) | かはんすう | kahansuu | 1196380 | learner | draft | **new** | Editorial review |
| N2-274 | [カバー](entries/1037/1037960-kabaa.org) | カバー | kabaa | 1037960 | learner | draft | **new** | Editorial review |
| N2-275 | [被せる](entries/1484/1484320-kabuseru.org) | かぶせる | kabuseru | 1484320 | learner | draft | **new** | Editorial review |
| N2-276 | [釜](entries/1209/1209080-kama.org) | かま | kama | 1209080 | learner | draft | **new** | Editorial review |
| N2-277 | [紙くず](entries/1609/1609610-kamikuzu.org) | かみくず | kamikuzu | 1609610 | learner | draft | **new** | Editorial review |
| N2-278 | [神様](entries/1364/1364920-kamisama.org) | かみさま | kamisama | 1364920 | learner | draft | **new** | Editorial review |
| N2-279 | [剃刀](entries/1435/1435180-kamisori.org) | かみそり | kamisori | 1435180 | learner | draft | **new** | Editorial review |
| N2-280 | [貨物](entries/1195/1195890-kamotsu.org) | かもつ | kamotsu | 1195890 | learner | draft | **new** | Editorial review |
| N2-281 | [痒い](entries/1569/1569570-kayui.org) | かゆい | kayui | 1569570 | learner | draft | **new** | Editorial review |
| N2-282 | [歌謡](entries/1193/1193450-kayou.org) | かよう | kayou | 1193450 | learner | draft | **new** | Editorial review |
| N2-283 | [殻](entries/1205/1205740-kara.org) | から | kara | 1205740 | learner | draft | **new** | Editorial review |
| N2-284 | [揶揄う](entries/1567/1567650-karakau.org) | からかう | karakau | 1567650 | learner | draft | **new** | Editorial review |
| N2-285 | [空っぽ](entries/1245/1245380-karappo.org) | からっぽ | karappo | 1245380 | learner | draft | **new** | Editorial review |
| N2-286 | [カラー](entries/1038/1038500-karaa.org) | カラー | karaa | 1038500 | learner | draft | **new** | Editorial review |
| N2-287 | [歌留多](entries/1590/1590710-karuta.org) | カルタ | karuta | 1590710 | learner | draft | **new** | Editorial review |
| N2-288 | [枯れる](entries/1267/1267220-kareru.org) | かれる | kareru | 1267220 | learner | draft | **new** | Editorial review |
| N2-289 | [カロリー](entries/1039/1039300-karorii.org) | カロリー | karorii | 1039300 | learner | draft | **new** | Editorial review |
| N2-290 | [可愛がる](entries/1190/1190730-kawaigaru.org) | かわいがる | kawaigaru | 1190730 | learner | draft | **new** | Editorial review |
| N2-291 | [乾かす](entries/1209/1209630-kawakasu.org) | かわかす | kawakasu | 1209630 | learner | draft | **new** | Editorial review |
| N2-292 | [渇く](entries/1208/1208520-kawaku.org) | かわく | kawaku | 1208520 | learner | draft | **new** | Editorial review |
| N2-293 | [為替](entries/1157/1157330-kawase.org) | かわせ | kawase | 1157330 | learner | draft | **new** | Editorial review |
| N2-294 | [瓦](entries/1209/1209580-kawara.org) | かわら | kawara | 1209580 | learner | draft | **new** | Editorial review |
| N2-295 | [替わる](entries/1590/1590820-kawaru.org) | かわる | kawaru | 1590820 | learner | draft | **new** | Editorial review |
| N2-296 | [間隔](entries/1215/1215380-kankaku.org) | かんかく | kankaku | 1215380 | learner | draft | **new** | Editorial review |
| N2-297 | [換気](entries/1212/1212780-kanki.org) | かんき | kanki | 1212780 | learner | draft | **new** | Editorial review |
| N2-298 | [感激](entries/1212/1212360-kangeki.org) | かんげき | kangeki | 1212360 | learner | draft | **new** | Editorial review |
| N2-299 | [関西](entries/1215/1215910-kansai.org) | かんさい | kansai | 1215910 | learner | draft | **new** | Editorial review |
| N2-300 | [鑑賞](entries/1215/1215200-kanshou.org) | かんしょう | kanshou | 1215200 | learner | draft | **new** | Editorial review |
| N2-301 | [間接](entries/1215/1215520-kansetsu.org) | かんせつ | kansetsu | 1215520 | learner | draft | **new** | Editorial review |
| N2-302 | [感想](entries/1212/1212480-kansou.org) | かんそう | kansou | 1212480 | learner | draft | **new** | Editorial review |
| N2-303 | [乾燥](entries/1209/1209920-kansou.org) | かんそう | kansou | 1209920 | learner | draft | **new** | Editorial review |
| N2-304 | [観測](entries/1214/1214980-kansoku.org) | かんそく | kansoku | 1214980 | learner | draft | **new** | Editorial review |
| N2-305 | [寒帯](entries/1210/1210460-kantai.org) | かんたい | kantai | 1210460 | learner | draft | **new** | Editorial review |
| N2-306 | [勘違い](entries/1210/1210620-kanchigai.org) | かんちがい | kanchigai | 1210620 | learner | draft | **new** | Editorial review |
| N2-307 | [官庁](entries/1211/1211730-kanchou.org) | かんちょう | kanchou | 1211730 | learner | draft | **new** | Editorial review |
| N2-308 | [缶詰](entries/1214/1214560-kanzume.org) | かんづめ | kanzume | 1214560 | learner | draft | **new** | Editorial review |
| N2-309 | [乾電池](entries/1210/1210100-kandenchi.org) | かんでんち | kandenchi | 1210100 | learner | draft | **new** | Editorial review |
| N2-310 | [関東](entries/1216/1216010-kantou.org) | かんとう | kantou | 1216010 | learner | draft | **new** | Editorial review |
| N2-311 | [観念](entries/1215/1215010-kannen.org) | かんねん | kannen | 1215010 | learner | draft | **new** | Editorial review |
| N2-312 | [看板](entries/1213/1213990-kanban.org) | かんばん | kanban | 1213990 | learner | draft | **new** | Editorial review |
| N2-313 | [看病](entries/1214/1214030-kanbyou.org) | かんびょう | kanbyou | 1214030 | learner | draft | **new** | Editorial review |
| N2-314 | [冠](entries/1577/1577620-kanmuri.org) | かんむり | kanmuri | 1577620 | learner | draft | **new** | Editorial review |
| N2-315 | [漢和](entries/1213/1213260-kanwa.org) | かんわ | kanwa | 1213260 | learner | draft | **new** | Editorial review |
| N2-316 | [カーブ](entries/1036/1036560-kaabu.org) | カーブ | kaabu | 1036560 | learner | draft | **new** | Editorial review |
| N2-317 | [外部](entries/1204/1204070-gaibu.org) | がいぶ | gaibu | 1204070 | learner | draft | **new** | Editorial review |
| N2-318 | [概論](entries/1204/1204520-gairon.org) | がいろん | gairon | 1204520 | learner | draft | **new** | Editorial review |
| N2-319 | [学術](entries/1206/1206870-gakujutsu.org) | がくじゅつ | gakujutsu | 1206870 | learner | draft | **new** | Editorial review |
| N2-320 | [学年](entries/1207/1207030-gakunen.org) | がくねん | gakunen | 1207030 | learner | draft | **new** | Editorial review |
| N2-321 | [学部](entries/1207/1207080-gakubu.org) | がくぶ | gakubu | 1207080 | learner | draft | **existing** | Editorial review |
| N2-322 | [学力](entries/1207/1207180-gakuryoku.org) | がくりょく | gakuryoku | 1207180 | learner | draft | **new** | Editorial review |
| N2-323 | [学科](entries/1206/1206590-gakka.org) | がっか | gakka | 1206590 | learner | draft | **new** | Editorial review |
| N2-324 | [学会](entries/1206/1206610-gakkai.org) | がっかい | gakkai | 1206610 | learner | draft | **new** | Editorial review |
| N2-325 | [楽器](entries/1207/1207340-gakki.org) | がっき | gakki | 1207340 | learner | draft | **new** | Editorial review |
| N2-326 | [学級](entries/1206/1206680-gakkyuu.org) | がっきゅう | gakkyuu | 1206680 | learner | draft | **new** | Editorial review |
| N2-327 | [ガム](entries/1040/1040350-gamu.org) | ガム | gamu | 1040350 | learner | draft | **new** | Editorial review |
| N2-328 | [気圧](entries/1221/1221880-kiatsu.org) | きあつ | kiatsu | 1221880 | learner | draft | **new** | Editorial review |
| N2-329 | [機関車](entries/1220/1220880-kikansha.org) | きかんしゃ | kikansha | 1220880 | learner | draft | **new** | Editorial review |
| N2-330 | [着替え](entries/1423/1423160-kigae.org) | きがえ | kigae | 1423160 | learner | draft | **new** | Editorial review |
| N2-331 | [飢饉](entries/1591/1591080-kikin.org) | ききん | kikin | 1591080 | learner | draft | **new** | Editorial review |
| N2-332 | [期限](entries/1220/1220560-kigen.org) | きげん | kigen | 1220560 | learner | draft | **new** | Editorial review |
| N2-333 | [記号](entries/1223/1223210-kigou.org) | きごう | kigou | 1223210 | learner | draft | **new** | Editorial review |
| N2-334 | [刻む](entries/1285/1285890-kizamu.org) | きざむ | kizamu | 1285890 | learner | draft | **new** | Editorial review |
| N2-335 | [起床](entries/1223/1223820-kishou.org) | きしょう | kishou | 1223820 | learner | draft | **new** | Editorial review |
| N2-336 | [基準](entries/1591/1591210-kijun.org) | きじゅん | kijun | 1591210 | learner | draft | **new** | Editorial review |
| N2-337 | [着せる](entries/1422/1422990-kiseru.org) | きせる | kiseru | 1422990 | learner | draft | **new** | Editorial review |
| N2-338 | [基礎](entries/1219/1219060-kiso.org) | きそ | kiso | 1219060 | learner | draft | **new** | Editorial review |
| N2-339 | [気体](entries/1222/1222460-kitai.org) | きたい | kitai | 1222460 | learner | draft | **new** | Editorial review |
| N2-340 | [基地](entries/1219/1219110-kichi.org) | きち | kichi | 1219110 | learner | draft | **new** | Editorial review |
| N2-341 | [切っ掛け](entries/1591/1591290-kikkake.org) | きっかけ | kikkake | 1591290 | learner | draft | **new** | Editorial review |
| N2-342 | [基盤](entries/1219/1219170-kiban.org) | きばん | kiban | 1219170 | learner | draft | **new** | Editorial review |
| N2-343 | [客席](entries/1226/1226760-kyakuseki.org) | きゃくせき | kyakuseki | 1226760 | learner | draft | **new** | Editorial review |
| N2-344 | [客間](entries/1226/1226710-kyakuma.org) | きゃくま | kyakuma | 1226710 | learner | draft | **new** | Editorial review |
| N2-345 | [キャンパス](entries/1042/1042150-kyanpasu.org) | キャンパス | kyanpasu | 1042150 | learner | draft | **new** | Editorial review |
| N2-346 | [休業](entries/1227/1227700-kyuugyou.org) | きゅうぎょう | kyuugyou | 1227700 | learner | draft | **new** | Editorial review |
| N2-347 | [休講](entries/1227/1227780-kyuukou.org) | きゅうこう | kyuukou | 1227780 | learner | draft | **new** | Editorial review |
| N2-348 | [休息](entries/1227/1227940-kyuusoku.org) | きゅうそく | kyuusoku | 1227940 | learner | draft | **new** | Editorial review |
| N2-349 | [給与](entries/1230/1230350-kyuuyo.org) | きゅうよ | kyuuyo | 1230350 | learner | draft | **new** | Editorial review |
| N2-350 | [強化](entries/1236/1236200-kyouka.org) | きょうか | kyouka | 1236200 | learner | draft | **new** | Editorial review |
| N2-351 | [境界](entries/1235/1235960-kyoukai.org) | きょうかい | kyoukai | 1235960 | learner | draft | **new** | Editorial review |
| N2-352 | [恐縮](entries/1236/1236740-kyoushuku.org) | きょうしゅく | kyoushuku | 1236740 | learner | draft | **new** | Editorial review |
| N2-353 | [教養](entries/1237/1237370-kyouyou.org) | きょうよう | kyouyou | 1237370 | learner | draft | **new** | Editorial review |
| N2-354 | [曲線](entries/1239/1239970-kyokusen.org) | きょくせん | kyokusen | 1239970 | learner | draft | **new** | Editorial review |
| N2-355 | [清い](entries/1378/1378140-kiyoi.org) | きよい | kiyoi | 1378140 | learner | draft | **new** | Editorial review |
| N2-356 | [規律](entries/1223/1223120-kiritsu.org) | きりつ | kiritsu | 1223120 | learner | draft | **new** | Editorial review |
| N2-357 | [斬る](entries/1304/1304400-kiru.org) | きる | kiru | 1304400 | learner | draft | **new** | Editorial review |
| N2-358 | [気をつける](entries/1591/1591990-kiwotsukeru.org) | きをつける | kiwotsukeru | 1591990 | learner | draft | **new** | Editorial review |
| N2-359 | [金魚](entries/1242/1242750-kingyo.org) | きんぎょ | kingyo | 1242750 | learner | draft | **new** | Editorial review |
| N2-360 | [儀式](entries/1224/1224700-gishiki.org) | ぎしき | gishiki | 1224700 | learner | draft | **new** | Editorial review |
| N2-361 | [ぎっしり](entries/1003/1003590-gisshiri.org) | ぎっしり | gisshiri | 1003590 | learner | draft | **new** | Editorial review |
| N2-362 | [ギャング](entries/1043/1043150-gyangu.org) | ギャング | gyangu | 1043150 | learner | draft | **new** | Editorial review |
| N2-363 | [行事](entries/1281/1281930-gyouji.org) | ぎょうじ | gyouji | 1281930 | learner | draft | **new** | Editorial review |
| N2-364 | [行列](entries/1282/1282220-gyouretsu.org) | ぎょうれつ | gyouretsu | 1282220 | learner | draft | **new** | Editorial review |
| N2-365 | [漁業](entries/1232/1232990-gyogyou.org) | ぎょぎょう | gyogyou | 1232990 | learner | draft | **new** | Editorial review |
| N2-366 | [区域](entries/1244/1244090-kuiki.org) | くいき | kuiki | 1244090 | learner | draft | **new** | Editorial review |
| N2-367 | [空想](entries/1245/1245730-kuusou.org) | くうそう | kuusou | 1245730 | learner | draft | **new** | Editorial review |
| N2-368 | [空中](entries/1245/1245790-kuuchuu.org) | くうちゅう | kuuchuu | 1245790 | learner | draft | **new** | Editorial review |
| N2-369 | [釘](entries/1436/1436840-kugi.org) | くぎ | kugi | 1436840 | learner | draft | **new** | Editorial review |
| N2-370 | [区切る](entries/1592/1592130-kugiru.org) | くぎる | kugiru | 1592130 | learner | draft | **new** | Editorial review |
| N2-371 | [櫛](entries/1246/1246490-kushi.org) | くし | kushi | 1246490 | learner | draft | **new** | Editorial review |
| N2-372 | [嚏](entries/1003/1003710-kushami.org) | くしゃみ | kushami | 1003710 | learner | draft | **new** | Editorial review |
| N2-373 | [苦情](entries/1244/1244520-kujou.org) | くじょう | kujou | 1244520 | learner | draft | **new** | Editorial review |
| N2-374 | [薬指](entries/1538/1538250-kusuriyubi.org) | くすりゆび | kusuriyubi | 1538250 | learner | draft | **new** | Editorial review |
| N2-375 | [屑](entries/1246/1246510-kuzu.org) | くず | kuzu | 1246510 | learner | draft | **new** | Editorial review |
| N2-376 | [崩す](entries/1516/1516260-kuzusu.org) | くずす | kuzusu | 1516260 | learner | draft | **new** | Editorial review |
| N2-377 | [崩れる](entries/1516/1516270-kuzureru.org) | くずれる | kuzureru | 1516270 | learner | draft | **new** | Editorial review |
| N2-378 | [草臥れる](entries/1003/1003810-kutabireru.org) | くたびれる | kutabireru | 1003810 | learner | draft | **new** | Editorial review |
| N2-379 | [砕ける](entries/1295/1295190-kudakeru.org) | くだける | kudakeru | 1295190 | learner | draft | **new** | Editorial review |
| N2-380 | [下らない](entries/1184/1184360-kudaranai.org) | くだらない | kudaranai | 1184360 | learner | draft | **new** | Editorial review |
| N2-381 | [下る](entries/1184/1184450-kudaru.org) | くだる | kudaru | 1184450 | learner | draft | **new** | Editorial review |
| N2-382 | [唇](entries/1359/1359940-kuchibiru.org) | くちびる | kuchibiru | 1359940 | learner | draft | **new** | Editorial review |
| N2-383 | [口紅](entries/1276/1276110-kuchibeni.org) | くちべに | kuchibeni | 1276110 | learner | draft | **new** | Editorial review |
| N2-384 | [くっ付く](entries/1003/1003860-kuttsuku.org) | くっつく | kuttsuku | 1003860 | learner | draft | **new** | Editorial review |
| N2-385 | [くっ付ける](entries/1003/1003870-kuttsukeru.org) | くっつける | kuttsukeru | 1003870 | learner | draft | **new** | Editorial review |
| N2-386 | [句読点](entries/1244/1244050-kutouten.org) | くとうてん | kutouten | 1244050 | learner | draft | **new** | Editorial review |
| N2-387 | [配る](entries/1472/1472990-kubaru.org) | くばる | kubaru | 1472990 | learner | draft | **new** | Editorial review |
| N2-388 | [工夫](entries/1278/1278220-kufuu.org) | くふう | kufuu | 1278220 | learner | draft | **new** | Editorial review |
| N2-389 | [区分](entries/1244/1244230-kubun.org) | くぶん | kubun | 1244230 | learner | draft | **new** | Editorial review |
| N2-390 | [組み合わせ](entries/1592/1592290-kumiawase.org) | くみあわせ | kumiawase | 1592290 | learner | draft | **new** | Editorial review |
| N2-391 | [組み立てる](entries/1397/1397580-kumitateru.org) | くみたてる | kumitateru | 1397580 | learner | draft | **new** | Editorial review |
| N2-392 | [汲む](entries/1229/1229610-kumu.org) | くむ | kumu | 1229610 | learner | draft | **new** | Editorial review |
| N2-393 | [酌む](entries/1324/1324210-kumu.org) | くむ | kumu | 1324210 | learner | draft | **new** | Editorial review |
| N2-394 | [悔しい](entries/1592/1592350-kuyashii.org) | くやしい | kuyashii | 1592350 | learner | draft | **new** | Editorial review |
| N2-395 | [悔やむ](entries/1200/1200450-kuyamu.org) | くやむ | kuyamu | 1200450 | learner | draft | **new** | Editorial review |
| N2-396 | [クリーニング](entries/1044/1044440-kuriiningu.org) | クリーニング | kuriiningu | 1044440 | learner | draft | **new** | Editorial review |
| N2-397 | [呉れ呉れも](entries/1269/1269140-kureguremo.org) | くれぐれも | kureguremo | 1269140 | learner | draft | **new** | Editorial review |
| N2-398 | [咥える](entries/1609/1609730-kuwaeru.org) | くわえる | kuwaeru | 1609730 | learner | draft | **new** | Editorial review |
| N2-399 | [クーラー](entries/1043/1043310-kuuraa.org) | クーラー | kuuraa | 1043310 | learner | draft | **new** | Editorial review |
| N2-400 | [偶数](entries/1246/1246250-guusuu.org) | ぐうすう | guusuu | 1246250 | learner | draft | **new** | Editorial review |
| N2-401 | [郡](entries/1249/1249230-gun.org) | ぐん | gun | 1249230 | learner | draft | **new** | Editorial review |
| N2-402 | [稽古](entries/1250/1250990-keiko.org) | けいこ | keiko | 1250990 | learner | draft | **new** | Editorial review |
| N2-403 | [蛍光灯](entries/1592/1592540-keikoutou.org) | けいこうとう | keikoutou | 1592540 | learner | draft | **new** | Editorial review |
| N2-404 | [敬語](entries/1250/1250750-keigo.org) | けいご | keigo | 1250750 | learner | draft | **new** | Editorial review |
| N2-405 | [形式](entries/1250/1250310-keishiki.org) | けいしき | keishiki | 1250310 | learner | draft | **new** | Editorial review |
| N2-406 | [継続](entries/1251/1251810-keizoku.org) | けいぞく | keizoku | 1251810 | learner | draft | **new** | Editorial review |
| N2-407 | [系統](entries/1251/1251030-keitou.org) | けいとう | keitou | 1251030 | learner | draft | **new** | Editorial review |
| N2-408 | [経度](entries/1251/1251630-keido.org) | けいど | keido | 1251630 | learner | draft | **new** | Editorial review |
| N2-409 | [競馬](entries/1234/1234210-keiba.org) | けいば | keiba | 1234210 | learner | draft | **new** | Editorial review |
| N2-410 | [警備](entries/1252/1252490-keibi.org) | けいび | keibi | 1252490 | learner | draft | **new** | Editorial review |
| N2-411 | [形容詞](entries/1250/1250430-keiyoushi.org) | けいようし | keiyoushi | 1250430 | learner | draft | **new** | Editorial review |
| N2-412 | [形容動詞](entries/1250/1250450-keiyoudoushi.org) | けいようどうし | keiyoudoushi | 1250450 | learner | draft | **new** | Editorial review |
| N2-413 | [毛皮](entries/1533/1533930-kegawa.org) | けがわ | kegawa | 1533930 | learner | draft | **new** | Editorial review |
| N2-414 | [削る](entries/1298/1298090-kezuru.org) | けずる | kezuru | 1298090 | learner | draft | **new** | Editorial review |
| N2-415 | [桁](entries/1253/1253800-keta.org) | けた | keta | 1253800 | learner | draft | **new** | Editorial review |
| N2-416 | [傑作](entries/1253/1253840-kessaku.org) | けっさく | kessaku | 1253840 | learner | draft | **new** | Editorial review |
| N2-417 | [血圧](entries/1255/1255110-ketsuatsu.org) | けつあつ | ketsuatsu | 1255110 | learner | draft | **new** | Editorial review |
| N2-418 | [血液](entries/1255/1255120-ketsueki.org) | けつえき | ketsueki | 1255120 | learner | draft | **new** | Editorial review |
| N2-419 | [蹴る](entries/1333/1333400-keru.org) | ける | keru | 1333400 | learner | draft | **new** | Editorial review |
| N2-420 | [険しい](entries/1260/1260530-kewashii.org) | けわしい | kewashii | 1260530 | learner | draft | **new** | Editorial review |
| N2-421 | [見学](entries/1259/1259440-kengaku.org) | けんがく | kengaku | 1259440 | learner | draft | **new** | Editorial review |
| N2-422 | [謙虚](entries/1260/1260190-kenkyo.org) | けんきょ | kenkyo | 1260190 | learner | draft | **new** | Editorial review |
| N2-423 | [研修](entries/1258/1258660-kenshuu.org) | けんしゅう | kenshuu | 1258660 | learner | draft | **new** | Editorial review |
| N2-424 | [県庁](entries/1258/1258880-kenchou.org) | けんちょう | kenchou | 1258880 | learner | draft | **new** | Editorial review |
| N2-425 | [顕微鏡](entries/1260/1260660-kenbikyou.org) | けんびきょう | kenbikyou | 1260660 | learner | draft | **new** | Editorial review |
| N2-426 | [芸能](entries/1253/1253130-geinou.org) | げいのう | geinou | 1253130 | learner | draft | **new** | Editorial review |
| N2-427 | [外科](entries/1203/1203380-geka.org) | げか | geka | 1203380 | learner | draft | **new** | Editorial review |
| N2-428 | [激増](entries/1253/1253690-gekizou.org) | げきぞう | gekizou | 1253690 | learner | draft | **new** | Editorial review |
| N2-429 | [下車](entries/1185/1185170-gesha.org) | げしゃ | gesha | 1185170 | learner | draft | **new** | Editorial review |
| N2-430 | [下水](entries/1185/1185510-gesui.org) | げすい | gesui | 1185510 | learner | draft | **new** | Editorial review |
| N2-431 | [下駄](entries/1185/1185780-geta.org) | げた | geta | 1185780 | learner | draft | **new** | Editorial review |
| N2-432 | [月給](entries/1255/1255560-gekkyuu.org) | げっきゅう | gekkyuu | 1255560 | learner | draft | **new** | Editorial review |
| N2-433 | [下品](entries/1186/1186230-gehin.org) | げひん | gehin | 1186230 | learner | draft | **new** | Editorial review |
| N2-434 | [原稿](entries/1261/1261340-genkou.org) | げんこう | genkou | 1261340 | learner | draft | **new** | Editorial review |
| N2-435 | [原産](entries/1261/1261470-gensan.org) | げんさん | gensan | 1261470 | learner | draft | **new** | Editorial review |
| N2-436 | [原始](entries/1261/1261500-genshi.org) | げんし | genshi | 1261500 | learner | draft | **new** | Editorial review |
| N2-437 | [現に](entries/1263/1263500-genni.org) | げんに | genni | 1263500 | learner | draft | **new** | Editorial review |
| N2-438 | [原理](entries/1262/1262460-genri.org) | げんり | genri | 1262460 | learner | draft | **new** | Editorial review |
| N2-439 | [原料](entries/1262/1262490-genryou.org) | げんりょう | genryou | 1262490 | learner | draft | **new** | Editorial review |
| N2-440 | [恋しい](entries/1558/1558760-koishii.org) | こいしい | koishii | 1558760 | learner | draft | **new** | Editorial review |
| N2-441 | [乞う](entries/1592/1592920-kou.org) | こう | kou | 1592920 | learner | draft | **new** | Editorial review |
| N2-442 | [斯うして](entries/2008/2008040-koushite.org) | こうして | koushite | 2008040 | learner | draft | **new** | Editorial review |
| N2-443 | [工員](entries/1277/1277980-kouin.org) | こういん | kouin | 1277980 | learner | draft | **new** | Editorial review |
| N2-444 | [公害](entries/1273/1273420-kougai.org) | こうがい | kougai | 1273420 | learner | draft | **new** | Editorial review |
| N2-445 | [高級](entries/1283/1283400-koukyuu.org) | こうきゅう | koukyuu | 1283400 | learner | draft | **new** | Editorial review |
| N2-446 | [公共](entries/1273/1273510-koukyou.org) | こうきょう | koukyou | 1273510 | learner | draft | **new** | Editorial review |
| N2-447 | [工芸](entries/1278/1278090-kougei.org) | こうげい | kougei | 1278090 | learner | draft | **new** | Editorial review |
| N2-448 | [孝行](entries/1277/1277880-koukou.org) | こうこう | koukou | 1277880 | learner | draft | **new** | Editorial review |
| N2-449 | [交差](entries/1271/1271970-kousa.org) | こうさ | kousa | 1271970 | learner | draft | **new** | Editorial review |
| N2-450 | [講師](entries/1282/1282280-koushi.org) | こうし | koushi | 1282280 | learner | draft | **new** | Editorial review |
| N2-451 | [公式](entries/1273/1273820-koushiki.org) | こうしき | koushiki | 1273820 | learner | draft | **new** | Editorial review |
| N2-452 | [校舎](entries/1279/1279540-kousha.org) | こうしゃ | kousha | 1279540 | learner | draft | **new** | Editorial review |
| N2-453 | [公衆](entries/1273/1273900-koushuu.org) | こうしゅう | koushuu | 1273900 | learner | draft | **new** | Editorial review |
| N2-454 | [工事](entries/1278/1278130-kouji.org) | こうじ | kouji | 1278130 | learner | draft | **new** | Editorial review |
| N2-455 | [香水](entries/1283/1283060-kousui.org) | こうすい | kousui | 1283060 | learner | draft | **new** | Editorial review |
| N2-456 | [公正](entries/1274/1274120-kousei.org) | こうせい | kousei | 1274120 | learner | draft | **new** | Editorial review |
| N2-457 | [光線](entries/1273/1273030-kousen.org) | こうせん | kousen | 1273030 | learner | draft | **new** | Editorial review |
| N2-458 | [高層](entries/1283/1283690-kousou.org) | こうそう | kousou | 1283690 | learner | draft | **new** | Editorial review |
| N2-459 | [構造](entries/1279/1279790-kouzou.org) | こうぞう | kouzou | 1279790 | learner | draft | **new** | Editorial review |
| N2-460 | [交代](entries/1592/1592990-koutai.org) | こうたい | koutai | 1592990 | learner | draft | **new** | Editorial review |
| N2-461 | [耕地](entries/1280/1280990-kouchi.org) | こうち | kouchi | 1280990 | learner | draft | **new** | Editorial review |
| N2-462 | [交通機関](entries/1272/1272320-koutsuukikan.org) | こうつうきかん | koutsuukikan | 1272320 | learner | draft | **new** | Editorial review |
| N2-463 | [校庭](entries/1279/1279600-koutei.org) | こうてい | koutei | 1279600 | learner | draft | **new** | Editorial review |
| N2-464 | [高等](entries/1283/1283850-koutou.org) | こうとう | koutou | 1283850 | learner | draft | **new** | Editorial review |
| N2-465 | [高度](entries/1283/1283830-koudo.org) | こうど | koudo | 1283830 | learner | draft | **new** | Editorial review |
| N2-466 | [後輩](entries/1270/1270010-kouhai.org) | こうはい | kouhai | 1270010 | learner | draft | **new** | Editorial review |
| N2-467 | [公表](entries/1274/1274550-kouhyou.org) | こうひょう | kouhyou | 1274550 | learner | draft | **new** | Editorial review |
| N2-468 | [鉱物](entries/1282/1282650-koubutsu.org) | こうぶつ | koubutsu | 1282650 | learner | draft | **new** | Editorial review |
| N2-469 | [公務](entries/1274/1274810-koumu.org) | こうむ | koumu | 1274810 | learner | draft | **new** | Editorial review |
| N2-470 | [項目](entries/1283/1283000-koumoku.org) | こうもく | koumoku | 1283000 | learner | draft | **new** | Editorial review |
| N2-471 | [紅葉](entries/1578/1578780-kouyou.org) | こうよう | kouyou | 1578780 | learner | draft | **new** | Editorial review |
| N2-472 | [交流](entries/1272/1272580-kouryuu.org) | こうりゅう | kouryuu | 1272580 | learner | draft | **new** | Editorial review |
| N2-473 | [効力](entries/1275/1275250-kouryoku.org) | こうりょく | kouryoku | 1275250 | learner | draft | **new** | Editorial review |
| N2-474 | [焦がす](entries/1350/1350710-kogasu.org) | こがす | kogasu | 1350710 | learner | draft | **new** | Editorial review |
| N2-475 | [国王](entries/1286/1286160-kokuou.org) | こくおう | kokuou | 1286160 | learner | draft | **new** | Editorial review |
| N2-476 | [国籍](entries/1286/1286780-kokuseki.org) | こくせき | kokuseki | 1286780 | learner | draft | **new** | Editorial review |
| N2-477 | [国立](entries/1287/1287180-kokuritsu.org) | こくりつ | kokuritsu | 1287180 | learner | draft | **new** | Editorial review |
| N2-478 | [心当たり](entries/1360/1360890-kokoroatari.org) | こころあたり | kokoroatari | 1360890 | learner | draft | **new** | Editorial review |
| N2-479 | [心得る](entries/1360/1360920-kokoroeru.org) | こころえる | kokoroeru | 1360920 | learner | draft | **new** | Editorial review |
| N2-480 | [腰掛け](entries/1288/1288370-koshikake.org) | こしかけ | koshikake | 1288370 | learner | draft | **new** | Editorial review |
| N2-481 | [腰掛ける](entries/1288/1288350-koshikakeru.org) | こしかける | koshikakeru | 1288350 | learner | draft | **new** | Editorial review |
| N2-482 | [胡椒](entries/1267/1267600-koshou.org) | こしょう | koshou | 1267600 | learner | draft | **new** | Editorial review |
| N2-483 | [拵える](entries/1567/1567390-koshiraeru.org) | こしらえる | koshiraeru | 1567390 | learner | draft | **new** | Editorial review |
| N2-484 | [擦る](entries/1298/1298910-kosuru.org) | こする | kosuru | 1298910 | learner | draft | **new** | Editorial review |
| N2-485 | [個体](entries/1264/1264980-kotai.org) | こたい | kotai | 1264980 | learner | draft | **new** | Editorial review |
| N2-486 | [此方こそ](entries/1004/1004510-kochirakoso.org) | こちらこそ | kochirakoso | 1004510 | learner | draft | **new** | Editorial review |
| N2-487 | [コック](entries/1050/1050310-kokku.org) | コック | kokku | 1050310 | learner | draft | **new** | Editorial review |
| N2-488 | [こっそり](entries/1004/1004520-kossori.org) | こっそり | kossori | 1004520 | learner | draft | **new** | Editorial review |
| N2-489 | [小遣い](entries/1348/1348030-kozukai.org) | こづかい | kozukai | 1348030 | learner | draft | **new** | Editorial review |
| N2-490 | [古典](entries/1265/1265860-koten.org) | こてん | koten | 1265860 | learner | draft | **new** | Editorial review |
| N2-491 | [琴](entries/1241/1241450-koto.org) | こと | koto | 1241450 | learner | draft | **new** | Editorial review |
| N2-492 | [言付ける](entries/1593/1593330-kotozukeru.org) | ことづける | kotozukeru | 1593330 | learner | draft | **new** | Editorial review |
| N2-493 | [此間](entries/1004/1004610-konaida.org) | こないだ | konaida | 1004610 | learner | draft | **new** | Editorial review |
| N2-494 | [零す](entries/1557/1557640-kobosu.org) | こぼす | kobosu | 1557640 | learner | draft | **new** | Editorial review |
| N2-495 | [零れる](entries/1557/1557650-koboreru.org) | こぼれる | koboreru | 1557650 | learner | draft | **new** | Editorial review |
| N2-496 | [小指](entries/1348/1348170-koyubi.org) | こゆび | koyubi | 1348170 | learner | draft | **new** | Editorial review |
| N2-497 | [コレクション](entries/1051/1051540-korekushon.org) | コレクション | korekushon | 1051540 | learner | draft | **new** | Editorial review |
| N2-498 | [転がす](entries/1440/1440980-korogasu.org) | ころがす | korogasu | 1440980 | learner | draft | **new** | Editorial review |
| N2-499 | [転がる](entries/1441/1441000-korogaru.org) | ころがる | korogaru | 1441000 | learner | draft | **new** | Editorial review |
| N2-500 | [紺](entries/1290/1290590-kon.org) | こん | kon | 1290590 | learner | draft | **new** | Editorial review |
| N2-501 | [混凝土](entries/1051/1051860-konkuriito.org) | コンクリート | konkuriito | 1051860 | learner | draft | **new** | Editorial review |
| N2-502 | [コンクール](entries/1051/1051840-konkuuru.org) | コンクール | konkuuru | 1051840 | learner | draft | **new** | Editorial review |
| N2-503 | [混合](entries/1290/1290360-kongou.org) | こんごう | kongou | 1290360 | learner | draft | **new** | Editorial review |
| N2-504 | [コンセント](entries/1052/1052330-konsento.org) | コンセント | konsento | 1052330 | learner | draft | **new** | Editorial review |
| N2-505 | [献立](entries/1258/1258500-kondate.org) | こんだて | kondate | 1258500 | learner | draft | **new** | Editorial review |
| N2-506 | [今晩は](entries/1289/1289480-konbanha.org) | こんばんは | konbanha | 1289480 | learner | draft | **new** | Editorial review |
| N2-507 | [コース](entries/1048/1048830-koosu.org) | コース | koosu | 1048830 | learner | draft | **new** | Editorial review |
| N2-508 | [コーラス](entries/1049/1049340-koorasu.org) | コーラス | koorasu | 1049340 | learner | draft | **new** | Editorial review |
| N2-509 | [碁](entries/1270/1270870-go.org) | ご | go | 1270870 | learner | draft | **new** | Editorial review |
| N2-510 | [強引](entries/1236/1236170-gouin.org) | ごういん | gouin | 1236170 | learner | draft | **new** | Editorial review |
| N2-511 | [合同](entries/1285/1285140-goudou.org) | ごうどう | goudou | 1285140 | learner | draft | **new** | Editorial review |
| N2-512 | [合理](entries/1285/1285330-gouri.org) | ごうり | gouri | 1285330 | learner | draft | **new** | Editorial review |
| N2-513 | [合流](entries/1285/1285390-gouryuu.org) | ごうりゅう | gouryuu | 1285390 | learner | draft | **new** | Editorial review |
| N2-514 | [ご苦労様](entries/1005/1005030-gokurousama.org) | ごくろうさま | gokurousama | 1005030 | learner | draft | **new** | Editorial review |
| N2-515 | [五十音](entries/1268/1268300-gojuuon.org) | ごじゅうおん | gojuuon | 1268300 | learner | draft | **new** | Editorial review |
| N2-516 | [ご馳走様](entries/1270/1270520-gochisousama.org) | ごちそうさま | gochisousama | 1270520 | learner | draft | **new** | Editorial review |
| N2-517 | [ご無沙汰](entries/1270/1270650-gobusata.org) | ごぶさた | gobusata | 1270650 | learner | draft | **new** | Editorial review |
| N2-518 | [護謨](entries/1054/1054570-gomu.org) | ゴム | gomu | 1054570 | learner | draft | **new** | Editorial review |
| N2-519 | [御免](entries/1270/1270670-gomen.org) | ごめん | gomen | 1270670 | learner | draft | **new** | Editorial review |
| N2-520 | [ごめん下さい](entries/1270/1270690-gomenkudasai.org) | ごめんください | gomenkudasai | 1270690 | learner | draft | **new** | Editorial review |
| N2-521 | [ご覧](entries/1270/1270760-goran.org) | ごらん | goran | 1270760 | learner | draft | **new** | Editorial review |
| N2-522 | [再三](entries/1292/1292760-saisan.org) | さいさん | saisan | 1292760 | learner | draft | **new** | Editorial review |
| N2-523 | [祭日](entries/1295/1295310-saijitsu.org) | さいじつ | saijitsu | 1295310 | learner | draft | **new** | Editorial review |
| N2-524 | [催促](entries/1292/1292200-saisoku.org) | さいそく | saisoku | 1292200 | learner | draft | **new** | Editorial review |
| N2-525 | [採点](entries/1294/1294850-saiten.org) | さいてん | saiten | 1294850 | learner | draft | **new** | Editorial review |
| N2-526 | [災難](entries/1295/1295110-sainan.org) | さいなん | sainan | 1295110 | learner | draft | **new** | Editorial review |
| N2-527 | [裁縫](entries/1296/1296200-saihou.org) | さいほう | saihou | 1296200 | learner | draft | **new** | Editorial review |
| N2-528 | [サイレン](entries/1056/1056150-sairen.org) | サイレン | sairen | 1056150 | learner | draft | **new** | Editorial review |
| N2-529 | [逆さま](entries/1593/1593650-sakasama.org) | さかさま | sakasama | 1593650 | learner | draft | **new** | Editorial review |
| N2-530 | [遡る](entries/1397/1397830-sakanoboru.org) | さかのぼる | sakanoboru | 1397830 | learner | draft | **new** | Editorial review |
| N2-531 | [酒場](entries/1329/1329110-sakaba.org) | さかば | sakaba | 1329110 | learner | draft | **new** | Editorial review |
| N2-532 | [先ほど](entries/1388/1388170-sakihodo.org) | さきほど | sakihodo | 1388170 | learner | draft | **new** | Editorial review |
| N2-533 | [裂く](entries/1207/1207730-saku.org) | さく | saku | 1207730 | learner | draft | **new** | Editorial review |
| N2-534 | [索引](entries/1298/1298320-sakuin.org) | さくいん | sakuin | 1298320 | learner | draft | **new** | Editorial review |
| N2-535 | [作者](entries/1297/1297710-sakusha.org) | さくしゃ | sakusha | 1297710 | learner | draft | **new** | Editorial review |
| N2-536 | [削除](entries/1298/1298120-sakujo.org) | さくじょ | sakujo | 1298120 | learner | draft | **new** | Editorial review |
| N2-537 | [作成](entries/1297/1297760-sakusei.org) | さくせい | sakusei | 1297760 | learner | draft | **new** | Editorial review |
| N2-538 | [作製](entries/1297/1297790-sakusei.org) | さくせい | sakusei | 1297790 | learner | draft | **new** | Editorial review |
| N2-539 | [探る](entries/1418/1418260-saguru.org) | さぐる | saguru | 1418260 | learner | draft | **new** | Editorial review |
| N2-540 | [囁く](entries/1565/1565670-sasayaku.org) | ささやく | sasayaku | 1565670 | learner | draft | **new** | Editorial review |
| N2-541 | [刺さる](entries/1306/1306390-sasaru.org) | ささる | sasaru | 1306390 | learner | draft | **new** | Editorial review |
| N2-542 | [差し支え](entries/1593/1593780-sashitsukae.org) | さしつかえ | sashitsukae | 1593780 | learner | draft | **new** | Editorial review |
| N2-543 | [差し引き](entries/1291/1291090-sashihiki.org) | さしひき | sashihiki | 1291090 | learner | draft | **new** | Editorial review |
| N2-544 | [刺身](entries/1306/1306570-sashimi.org) | さしみ | sashimi | 1306570 | learner | draft | **new** | Editorial review |
| N2-545 | [匙](entries/1585/1585630-saji.org) | さじ | saji | 1585630 | learner | draft | **new** | Editorial review |
| N2-546 | [射す](entries/1322/1322170-sasu.org) | さす | sasu | 1322170 | learner | draft | **new** | Editorial review |
| N2-547 | [刺す](entries/1306/1306470-sasu.org) | さす | sasu | 1306470 | learner | draft | **new** | Editorial review |
| N2-548 | [挿す](entries/1399/1399830-sasu.org) | さす | sasu | 1399830 | learner | draft | **new** | Editorial review |
| N2-549 | [流石](entries/1552/1552390-sasuga.org) | さすが | sasuga | 1552390 | learner | draft | **new** | Editorial review |
| N2-550 | [早速](entries/1400/1400300-sassoku.org) | さっそく | sassoku | 1400300 | learner | draft | **new** | Editorial review |
| N2-551 | [撮影](entries/1298/1298800-satsuei.org) | さつえい | satsuei | 1298800 | learner | draft | **new** | Editorial review |
| N2-552 | [錆](entries/1593/1593820-sabi.org) | さび | sabi | 1593820 | learner | draft | **new** | Editorial review |
| N2-553 | [錆びる](entries/1299/1299640-sabiru.org) | さびる | sabiru | 1299640 | learner | draft | **new** | Editorial review |
| N2-554 | [冷ます](entries/1556/1556740-samasu.org) | さます | samasu | 1556740 | learner | draft | **new** | Editorial review |
| N2-555 | [妨げる](entries/1519/1519120-samatageru.org) | さまたげる | samatageru | 1519120 | learner | draft | **new** | Editorial review |
| N2-556 | [冷める](entries/1556/1556750-sameru.org) | さめる | sameru | 1556750 | learner | draft | **new** | Editorial review |
| N2-557 | [左様なら](entries/1291/1291050-sayounara.org) | さようなら | sayounara | 1291050 | learner | draft | **new** | Editorial review |
| N2-558 | [サラリーマン](entries/1057/1057960-sarariiman.org) | サラリーマン | sarariiman | 1057960 | learner | draft | **new** | Editorial review |
| N2-559 | [騒がしい](entries/1403/1403000-sawagashii.org) | さわがしい | sawagashii | 1403000 | learner | draft | **new** | Editorial review |
| N2-560 | [爽やか](entries/1399/1399520-sawayaka.org) | さわやか | sawayaka | 1399520 | learner | draft | **new** | Editorial review |
| N2-561 | [三角](entries/1299/1299970-sankaku.org) | さんかく | sankaku | 1299970 | learner | draft | **new** | Editorial review |
| N2-562 | [算数](entries/1303/1303930-sansuu.org) | さんすう | sansuu | 1303930 | learner | draft | **new** | Editorial review |
| N2-563 | [酸性](entries/1304/1304330-sansei.org) | さんせい | sansei | 1304330 | learner | draft | **new** | Editorial review |
| N2-564 | [産地](entries/1303/1303820-sanchi.org) | さんち | sanchi | 1303820 | learner | draft | **new** | Editorial review |
| N2-565 | [サンプル](entries/1058/1058760-sanpuru.org) | サンプル | sanpuru | 1058760 | learner | draft | **new** | Editorial review |
| N2-566 | [山林](entries/1303/1303230-sanrin.org) | さんりん | sanrin | 1303230 | learner | draft | **new** | Editorial review |
| N2-567 | [サークル](entries/1054/1054850-saakuru.org) | サークル | saakuru | 1054850 | learner | draft | **new** | Editorial review |
| N2-568 | [材木](entries/1296/1296660-zaimoku.org) | ざいもく | zaimoku | 1296660 | learner | draft | **new** | Editorial review |
| N2-569 | [座敷](entries/1291/1291990-zashiki.org) | ざしき | zashiki | 1291990 | learner | draft | **new** | Editorial review |
| N2-570 | [雑音](entries/1299/1299280-zatsuon.org) | ざつおん | zatsuon | 1299280 | learner | draft | **new** | Editorial review |
| N2-571 | [座布団](entries/1291/1291980-zabuton.org) | ざぶとん | zabuton | 1291980 | learner | draft | **new** | Editorial review |
| N2-572 | [仕上がる](entries/1305/1305130-shiagaru.org) | しあがる | shiagaru | 1305130 | learner | draft | **new** | Editorial review |
| N2-573 | [明々後日](entries/1594/1594050-shiasatte.org) | しあさって | shiasatte | 1594050 | learner | draft | **new** | Editorial review |
| N2-574 | [塩辛い](entries/1609/1609860-shiokarai.org) | しおからい | shiokarai | 1609860 | learner | draft | **new** | Editorial review |
| N2-575 | [司会](entries/1306/1306640-shikai.org) | しかい | shikai | 1306640 | learner | draft | **new** | Editorial review |
| N2-576 | [四角](entries/1307/1307090-shikaku.org) | しかく | shikaku | 1307090 | learner | draft | **new** | Editorial review |
| N2-577 | [四角い](entries/1307/1307100-shikakui.org) | しかくい | shikakui | 1307100 | learner | draft | **new** | Editorial review |
| N2-578 | [四季](entries/1307/1307130-shiki.org) | しき | shiki | 1307130 | learner | draft | **new** | Editorial review |
| N2-579 | [敷地](entries/1497/1497060-shikichi.org) | しきち | shikichi | 1497060 | learner | draft | **new** | Editorial review |
| N2-580 | [至急](entries/1311/1311900-shikyuu.org) | しきゅう | shikyuu | 1311900 | learner | draft | **new** | Editorial review |
| N2-581 | [敷く](entries/1497/1497020-shiku.org) | しく | shiku | 1497020 | learner | draft | **new** | Editorial review |
| N2-582 | [茂る](entries/1533/1533740-shigeru.org) | しげる | shigeru | 1533740 | learner | draft | **new** | Editorial review |
| N2-583 | [四捨五入](entries/1307/1307250-shishagonyuu.org) | ししゃごにゅう | shishagonyuu | 1307250 | learner | draft | **new** | Editorial review |
| N2-584 | [始終](entries/1307/1307570-shijuu.org) | しじゅう | shijuu | 1307570 | learner | draft | **new** | Editorial review |
| N2-585 | [静まる](entries/1594/1594270-shizumaru.org) | しずまる | shizumaru | 1594270 | learner | draft | **new** | Editorial review |
| N2-586 | [姿勢](entries/1307/1307740-shisei.org) | しせい | shisei | 1307740 | learner | draft | **new** | Editorial review |
| N2-587 | [自然科学](entries/1318/1318110-shizenkagaku.org) | しぜんかがく | shizenkagaku | 1318110 | learner | draft | **new** | Editorial review |
| N2-588 | [子孫](entries/1307/1307990-shison.org) | しそん | shison | 1307990 | learner | draft | **new** | Editorial review |
| N2-589 | [死体](entries/1310/1310920-shitai.org) | したい | shitai | 1310920 | learner | draft | **new** | Editorial review |
| N2-590 | [下書き](entries/1185/1185370-shitagaki.org) | したがき | shitagaki | 1185370 | learner | draft | **new** | Editorial review |
| N2-591 | [下町](entries/1185/1185940-shitamachi.org) | したまち | shitamachi | 1185940 | learner | draft | **new** | Editorial review |
| N2-592 | [湿気](entries/1320/1320410-shikke.org) | しっけ | shikke | 1320410 | learner | draft | **new** | Editorial review |
| N2-593 | [執筆](entries/1319/1319710-shippitsu.org) | しっぴつ | shippitsu | 1319710 | learner | draft | **new** | Editorial review |
| N2-594 | [尻尾](entries/1358/1358800-shippo.org) | しっぽ | shippo | 1358800 | learner | draft | **new** | Editorial review |
| N2-595 | [執拗い](entries/1005/1005550-shitsukoi.org) | しつこい | shitsukoi | 1005550 | learner | draft | **new** | Editorial review |
| N2-596 | [湿度](entries/1320/1320490-shitsudo.org) | しつど | shitsudo | 1320490 | learner | draft | **new** | Editorial review |
| N2-597 | [失恋](entries/1320/1320250-shitsuren.org) | しつれん | shitsuren | 1320250 | learner | draft | **new** | Editorial review |
| N2-598 | [指定](entries/1309/1309910-shitei.org) | してい | shitei | 1309910 | learner | draft | **new** | Editorial review |
| N2-599 | [私鉄](entries/1311/1311340-shitetsu.org) | してつ | shitetsu | 1311340 | learner | draft | **new** | Editorial review |
| N2-600 | [縛る](entries/1476/1476050-shibaru.org) | しばる | shibaru | 1476050 | learner | draft | **new** | Editorial review |
| N2-601 | [痺れる](entries/1569/1569620-shibireru.org) | しびれる | shibireru | 1569620 | learner | draft | **new** | Editorial review |
| N2-602 | [紙幣](entries/1311/1311600-shihei.org) | しへい | shihei | 1311600 | learner | draft | **new** | Editorial review |
| N2-603 | [萎む](entries/1427/1427460-shibomu.org) | しぼむ | shibomu | 1427460 | learner | draft | **new** | Editorial review |
| N2-604 | [絞る](entries/1594/1594520-shiboru.org) | しぼる | shiboru | 1594520 | learner | draft | **new** | Editorial review |
| N2-605 | [縞](entries/1321/1321670-shima.org) | しま | shima | 1321670 | learner | draft | **new** | Editorial review |
| N2-606 | [沁み沁み](entries/1005/1005610-shimijimi.org) | しみじみ | shimijimi | 1005610 | learner | draft | **new** | Editorial review |
| N2-607 | [氏名](entries/1311/1311060-shimei.org) | しめい | shimei | 1311060 | learner | draft | **new** | Editorial review |
| N2-608 | [締め切る](entries/1594/1594600-shimekiru.org) | しめきる | shimekiru | 1594600 | learner | draft | **new** | Editorial review |
| N2-609 | [社会科学](entries/1322/1322720-shakaikagaku.org) | しゃかいかがく | shakaikagaku | 1322720 | learner | draft | **new** | Editorial review |
| N2-610 | [しゃがむ](entries/1005/1005630-shagamu.org) | しゃがむ | shagamu | 1005630 | learner | draft | **new** | Editorial review |
| N2-611 | [車庫](entries/1323/1323120-shako.org) | しゃこ | shako | 1323120 | learner | draft | **new** | Editorial review |
| N2-612 | [車掌](entries/1323/1323170-shashou.org) | しゃしょう | shashou | 1323170 | learner | draft | **new** | Editorial review |
| N2-613 | [写生](entries/1322/1322120-shasei.org) | しゃせい | shasei | 1322120 | learner | draft | **new** | Editorial review |
| N2-614 | [シャッター](entries/1061/1061440-shattaa.org) | シャッター | shattaa | 1061440 | learner | draft | **new** | Editorial review |
| N2-615 | [しゃぶる](entries/1005/1005670-shaburu.org) | しゃぶる | shaburu | 1005670 | learner | draft | **new** | Editorial review |
| N2-616 | [車輪](entries/1323/1323280-sharin.org) | しゃりん | sharin | 1323280 | learner | draft | **new** | Editorial review |
| N2-617 | [洒落](entries/1568/1568640-share.org) | しゃれ | share | 1568640 | learner | draft | **new** | Editorial review |
| N2-618 | [集会](entries/1333/1333600-shuukai.org) | しゅうかい | shuukai | 1333600 | learner | draft | **new** | Editorial review |
| N2-619 | [集金](entries/1333/1333620-shuukin.org) | しゅうきん | shuukin | 1333620 | learner | draft | **new** | Editorial review |
| N2-620 | [集合](entries/1333/1333680-shuugou.org) | しゅうごう | shuugou | 1333680 | learner | draft | **new** | Editorial review |
| N2-621 | [習字](entries/1333/1333110-shuuji.org) | しゅうじ | shuuji | 1333110 | learner | draft | **new** | Editorial review |
| N2-622 | [修繕](entries/1332/1332170-shuuzen.org) | しゅうぜん | shuuzen | 1332170 | learner | draft | **new** | Editorial review |
| N2-623 | [終点](entries/1332/1332950-shuuten.org) | しゅうてん | shuuten | 1332950 | learner | draft | **new** | Editorial review |
| N2-624 | [就任](entries/1331/1331780-shuunin.org) | しゅうにん | shuunin | 1331780 | learner | draft | **new** | Editorial review |
| N2-625 | [周辺](entries/1331/1331300-shuuhen.org) | しゅうへん | shuuhen | 1331300 | learner | draft | **new** | Editorial review |
| N2-626 | [終了](entries/1333/1333040-shuuryou.org) | しゅうりょう | shuuryou | 1333040 | learner | draft | **new** | Editorial review |
| N2-627 | [縮小](entries/1337/1337630-shukushou.org) | しゅくしょう | shukushou | 1337630 | learner | draft | **new** | Editorial review |
| N2-628 | [祝日](entries/1337/1337500-shukujitsu.org) | しゅくじつ | shukujitsu | 1337500 | learner | draft | **new** | Editorial review |
| N2-629 | [主語](entries/1325/1325420-shugo.org) | しゅご | shugo | 1325420 | learner | draft | **new** | Editorial review |
| N2-630 | [出勤](entries/1338/1338600-shukkin.org) | しゅっきん | shukkin | 1338600 | learner | draft | **new** | Editorial review |
| N2-631 | [出張](entries/1339/1339660-shutchou.org) | しゅっちょう | shutchou | 1339660 | learner | draft | **new** | Editorial review |
| N2-632 | [主役](entries/1326/1326290-shuyaku.org) | しゅやく | shuyaku | 1326290 | learner | draft | **new** | Editorial review |
| N2-633 | [消化](entries/1350/1350140-shouka.org) | しょうか | shouka | 1350140 | learner | draft | **new** | Editorial review |
| N2-634 | [小学生](entries/1347/1347880-shougakusei.org) | しょうがくせい | shougakusei | 1347880 | learner | draft | **new** | Editorial review |
| N2-635 | [仕様がない](entries/1305/1305510-shouganai.org) | しょうがない | shouganai | 1305510 | learner | draft | **new** | Editorial review |
| N2-636 | [消極的](entries/1350/1350220-shoukyokuteki.org) | しょうきょくてき | shoukyokuteki | 1350220 | learner | draft | **new** | Editorial review |
| N2-637 | [賞金](entries/1351/1351930-shoukin.org) | しょうきん | shoukin | 1351930 | learner | draft | **new** | Editorial review |
| N2-638 | [将棋](entries/1347/1347640-shougi.org) | しょうぎ | shougi | 1347640 | learner | draft | **new** | Editorial review |
| N2-639 | [商業](entries/1346/1346740-shougyou.org) | しょうぎょう | shougyou | 1346740 | learner | draft | **new** | Editorial review |
| N2-640 | [商社](entries/1347/1347080-shousha.org) | しょうしゃ | shousha | 1347080 | learner | draft | **new** | Editorial review |
| N2-641 | [障子](entries/1352/1352090-shouji.org) | しょうじ | shouji | 1352090 | learner | draft | **new** | Editorial review |
| N2-642 | [小数](entries/1348/1348370-shousuu.org) | しょうすう | shousuu | 1348370 | learner | draft | **new** | Editorial review |
| N2-643 | [生ずる](entries/1378/1378660-shouzuru.org) | しょうずる | shouzuru | 1378660 | learner | draft | **new** | Editorial review |
| N2-644 | [商店](entries/1347/1347180-shouten.org) | しょうてん | shouten | 1347180 | learner | draft | **new** | Editorial review |
| N2-645 | [焦点](entries/1350/1350810-shouten.org) | しょうてん | shouten | 1350810 | learner | draft | **new** | Editorial review |
| N2-646 | [消毒](entries/1350/1350270-shoudoku.org) | しょうどく | shoudoku | 1350270 | learner | draft | **new** | Editorial review |
| N2-647 | [勝敗](entries/1346/1346220-shouhai.org) | しょうはい | shouhai | 1346220 | learner | draft | **new** | Editorial review |
| N2-648 | [賞品](entries/1351/1351960-shouhin.org) | しょうひん | shouhin | 1351960 | learner | draft | **new** | Editorial review |
| N2-649 | [勝負](entries/1346/1346230-shoubu.org) | しょうぶ | shoubu | 1346230 | learner | draft | **new** | Editorial review |
| N2-650 | [小便](entries/1580/1580280-shouben.org) | しょうべん | shouben | 1580280 | learner | draft | **new** | Editorial review |
| N2-651 | [消防署](entries/1350/1350370-shoubousho.org) | しょうぼうしょ | shoubousho | 1350370 | learner | draft | **new** | Editorial review |
| N2-652 | [正味](entries/1377/1377980-shoumi.org) | しょうみ | shoumi | 1377980 | learner | draft | **new** | Editorial review |
| N2-653 | [正面](entries/1378/1378030-shoumen.org) | しょうめん | shoumen | 1378030 | learner | draft | **new** | Editorial review |
| N2-654 | [省略](entries/1351/1351120-shouryaku.org) | しょうりゃく | shouryaku | 1351120 | learner | draft | **new** | Editorial review |
| N2-655 | [初級](entries/1342/1342710-shokyuu.org) | しょきゅう | shokyuu | 1342710 | learner | draft | **new** | Editorial review |
| N2-656 | [食塩](entries/1358/1358410-shokuen.org) | しょくえん | shokuen | 1358410 | learner | draft | **new** | Editorial review |
| N2-657 | [職人](entries/1357/1357550-shokunin.org) | しょくにん | shokunin | 1357550 | learner | draft | **new** | Editorial review |
| N2-658 | [初旬](entries/1342/1342820-shojun.org) | しょじゅん | shojun | 1342820 | learner | draft | **new** | Editorial review |
| N2-659 | [食器](entries/1358/1358430-shokki.org) | しょっき | shokki | 1358430 | learner | draft | **new** | Editorial review |
| N2-660 | [ショップ](entries/1062/1062820-shoppu.org) | ショップ | shoppu | 1062820 | learner | draft | **new** | Editorial review |
| N2-661 | [書店](entries/1344/1344120-shoten.org) | しょてん | shoten | 1344120 | learner | draft | **new** | Editorial review |
| N2-662 | [白髪](entries/1583/1583050-shiraga.org) | しらが | shiraga | 1583050 | learner | draft | **new** | Editorial review |
| N2-663 | [知り合い](entries/1595/1595070-shiriai.org) | しりあい | shiriai | 1595070 | learner | draft | **new** | Editorial review |
| N2-664 | [私立](entries/1311/1311420-shiritsu.org) | しりつ | shiritsu | 1311420 | learner | draft | **new** | Editorial review |
| N2-665 | [資料](entries/1312/1312820-shiryou.org) | しりょう | shiryou | 1312820 | learner | draft | **new** | Editorial review |
| N2-666 | [シリーズ](entries/1062/1062910-shiriizu.org) | シリーズ | shiriizu | 1062910 | learner | draft | **new** | Editorial review |
| N2-667 | [素人](entries/1397/1397270-shirouto.org) | しろうと | shirouto | 1397270 | learner | draft | **new** | Editorial review |
| N2-668 | [芯](entries/1595/1595120-shin.org) | しん | shin | 1595120 | learner | draft | **new** | Editorial review |
| N2-669 | [新幹線](entries/1361/1361590-shinkansen.org) | しんかんせん | shinkansen | 1361590 | learner | draft | **new** | Editorial review |
| N2-670 | [真空](entries/1363/1363600-shinkuu.org) | しんくう | shinkuu | 1363600 | learner | draft | **new** | Editorial review |
| N2-671 | [心身](entries/1360/1360750-shinshin.org) | しんしん | shinshin | 1360750 | learner | draft | **new** | Editorial review |
| N2-672 | [信ずる](entries/1359/1359070-shinzuru.org) | しんずる | shinzuru | 1359070 | learner | draft | **new** | Editorial review |
| N2-673 | [申請](entries/1363/1363130-shinsei.org) | しんせい | shinsei | 1363130 | learner | draft | **new** | Editorial review |
| N2-674 | [寝台](entries/1580/1580570-shindai.org) | しんだい | shindai | 1580570 | learner | draft | **new** | Editorial review |
| N2-675 | [診断](entries/1365/1365480-shindan.org) | しんだん | shindan | 1365480 | learner | draft | **new** | Editorial review |
| N2-676 | [侵入](entries/1359/1359850-shinnyuu.org) | しんにゅう | shinnyuu | 1359850 | learner | draft | **new** | Editorial review |
| N2-677 | [深夜](entries/1362/1362810-shinya.org) | しんや | shinya | 1362810 | learner | draft | **new** | Editorial review |
| N2-678 | [森林](entries/1362/1362530-shinrin.org) | しんりん | shinrin | 1362530 | learner | draft | **new** | Editorial review |
| N2-679 | [親類](entries/1365/1365420-shinrui.org) | しんるい | shinrui | 1365420 | learner | draft | **new** | Editorial review |
| N2-680 | [針路](entries/1366/1366280-shinro.org) | しんろ | shinro | 1366280 | learner | draft | **new** | Editorial review |
| N2-681 | [神話](entries/1364/1364940-shinwa.org) | しんわ | shinwa | 1364940 | learner | draft | **new** | Editorial review |
| N2-682 | [シーズン](entries/1059/1059300-shiizun.org) | シーズン | shiizun | 1059300 | learner | draft | **new** | Editorial review |
| N2-683 | [シーツ](entries/1059/1059400-shiitsu.org) | シーツ | shiitsu | 1059400 | learner | draft | **new** | Editorial review |
| N2-684 | [しーん](entries/1631/1631970-shiin.org) | しーん | shiin | 1631970 | learner | draft | **new** | Editorial review |
| N2-685 | [自衛](entries/1317/1317400-jiei.org) | じえい | jiei | 1317400 | learner | draft | **new** | Editorial review |
| N2-686 | [時間割](entries/1315/1315960-jikanwari.org) | じかんわり | jikanwari | 1315960 | learner | draft | **new** | Editorial review |
| N2-687 | [持参](entries/1315/1315790-jisan.org) | じさん | jisan | 1315790 | learner | draft | **new** | Editorial review |
| N2-688 | [磁石](entries/1317/1317080-jishaku.org) | じしゃく | jishaku | 1317080 | learner | draft | **new** | Editorial review |
| N2-689 | [自習](entries/1317/1317900-jishuu.org) | じしゅう | jishuu | 1317900 | learner | draft | **new** | Editorial review |
| N2-690 | [時速](entries/1316/1316290-jisoku.org) | じそく | jisoku | 1316290 | learner | draft | **new** | Editorial review |
| N2-691 | [自治](entries/1317/1317810-jichi.org) | じち | jichi | 1317810 | learner | draft | **new** | Editorial review |
| N2-692 | [実感](entries/1320/1320920-jikkan.org) | じっかん | jikkan | 1320920 | learner | draft | **new** | Editorial review |
| N2-693 | [実習](entries/1321/1321200-jisshuu.org) | じっしゅう | jisshuu | 1321200 | learner | draft | **new** | Editorial review |
| N2-694 | [実績](entries/1321/1321240-jisseki.org) | じっせき | jisseki | 1321240 | learner | draft | **new** | Editorial review |
| N2-695 | [実物](entries/1321/1321430-jitsubutsu.org) | じつぶつ | jitsubutsu | 1321430 | learner | draft | **new** | Editorial review |
| N2-696 | [実用](entries/1321/1321480-jitsuyou.org) | じつよう | jitsuyou | 1321480 | learner | draft | **new** | Editorial review |
| N2-697 | [実力](entries/1321/1321530-jitsuryoku.org) | じつりょく | jitsuryoku | 1321530 | learner | draft | **new** | Editorial review |
| N2-698 | [実例](entries/1321/1321560-jitsurei.org) | じつれい | jitsurei | 1321560 | learner | draft | **new** | Editorial review |
| N2-699 | [児童](entries/1315/1315060-jidou.org) | じどう | jidou | 1315060 | learner | draft | **new** | Editorial review |
| N2-700 | [地盤](entries/1421/1421420-jiban.org) | じばん | jiban | 1421420 | learner | draft | **new** | Editorial review |
| N2-701 | [地味](entries/1421/1421490-jimi.org) | じみ | jimi | 1421490 | learner | draft | **new** | Editorial review |
| N2-702 | [弱点](entries/1324/1324870-jakuten.org) | じゃくてん | jakuten | 1324870 | learner | draft | **new** | Editorial review |
| N2-703 | [蛇口](entries/1323/1323370-jaguchi.org) | じゃぐち | jaguchi | 1323370 | learner | draft | **new** | Editorial review |
| N2-704 | [じゃん拳](entries/1005/1005970-janken.org) | じゃんけん | janken | 1005970 | learner | draft | **new** | Editorial review |
| N2-705 | [ジャーナリスト](entries/1064/1064980-jaanarisuto.org) | ジャーナリスト | jaanarisuto | 1064980 | learner | draft | **new** | Editorial review |
| N2-706 | [重体](entries/1595/1595360-juutai.org) | じゅうたい | juutai | 1595360 | learner | draft | **new** | Editorial review |
| N2-707 | [絨毯](entries/1595/1595370-juutan.org) | じゅうたん | juutan | 1595370 | learner | draft | **new** | Editorial review |
| N2-708 | [重点](entries/1336/1336570-juuten.org) | じゅうてん | juuten | 1336570 | learner | draft | **new** | Editorial review |
| N2-709 | [重役](entries/1336/1336770-juuyaku.org) | じゅうやく | juuyaku | 1336770 | learner | draft | **new** | Editorial review |
| N2-710 | [重量](entries/1336/1336900-juuryou.org) | じゅうりょう | juuryou | 1336900 | learner | draft | **new** | Editorial review |
| N2-711 | [重力](entries/1336/1336980-juuryoku.org) | じゅうりょく | juuryoku | 1336980 | learner | draft | **new** | Editorial review |
| N2-712 | [熟語](entries/1337/1337830-jukugo.org) | じゅくご | jukugo | 1337830 | learner | draft | **new** | Editorial review |
| N2-713 | [受験](entries/1329/1329740-juken.org) | じゅけん | juken | 1329740 | learner | draft | **new** | Editorial review |
| N2-714 | [述語](entries/1340/1340840-jutsugo.org) | じゅつご | jutsugo | 1340840 | learner | draft | **new** | Editorial review |
| N2-715 | [寿命](entries/1330/1330240-jumyou.org) | じゅみょう | jumyou | 1330240 | learner | draft | **new** | Editorial review |
| N2-716 | [受話器](entries/1330/1330090-juwaki.org) | じゅわき | juwaki | 1330090 | learner | draft | **new** | Editorial review |
| N2-717 | [循環](entries/1341/1341340-junkan.org) | じゅんかん | junkan | 1341340 | learner | draft | **new** | Editorial review |
| N2-718 | [巡査](entries/1342/1342110-junsa.org) | じゅんさ | junsa | 1342110 | learner | draft | **new** | Editorial review |
| N2-719 | [順々](entries/1342/1342230-junjun.org) | じゅんじゅん | junjun | 1342230 | learner | draft | **new** | Editorial review |
| N2-720 | [順序](entries/1342/1342340-junjo.org) | じゅんじょ | junjo | 1342340 | learner | draft | **new** | Editorial review |
| N2-721 | [純情](entries/1341/1341910-junjou.org) | じゅんじょう | junjou | 1341910 | learner | draft | **new** | Editorial review |
| N2-722 | [純粋](entries/1341/1341930-junsui.org) | じゅんすい | junsui | 1341930 | learner | draft | **new** | Editorial review |
| N2-723 | [蒸気](entries/1356/1356930-jouki.org) | じょうき | jouki | 1356930 | learner | draft | **new** | Editorial review |
| N2-724 | [上級](entries/1352/1352930-joukyuu.org) | じょうきゅう | joukyuu | 1352930 | learner | draft | **new** | Editorial review |
| N2-725 | [定規](entries/1435/1435520-jougi.org) | じょうぎ | jougi | 1435520 | learner | draft | **new** | Editorial review |
| N2-726 | [上下](entries/1352/1352710-jouge.org) | じょうげ | jouge | 1352710 | learner | draft | **new** | Editorial review |
| N2-727 | [乗車](entries/1355/1355270-jousha.org) | じょうしゃ | jousha | 1355270 | learner | draft | **new** | Editorial review |
| N2-728 | [蒸発](entries/1356/1356960-jouhatsu.org) | じょうはつ | jouhatsu | 1356960 | learner | draft | **new** | Editorial review |
| N2-729 | [助教授](entries/1344/1344550-jokyouju.org) | じょきょうじゅ | jokyouju | 1344550 | learner | draft | **new** | Editorial review |
| N2-730 | [人造](entries/1368/1368580-jinzou.org) | じんぞう | jinzou | 1368580 | learner | draft | **new** | Editorial review |
| N2-731 | [人文科学](entries/1369/1369140-jinbunkagaku.org) | じんぶんかがく | jinbunkagaku | 1369140 | learner | draft | **new** | Editorial review |
| N2-732 | [人命](entries/1369/1369400-jinmei.org) | じんめい | jinmei | 1369400 | learner | draft | **new** | Editorial review |
| N2-733 | [酢](entries/1370/1370270-su.org) | す | su | 1370270 | learner | draft | **new** | Editorial review |
| N2-734 | [水産](entries/1609/1609990-suisan.org) | すいさん | suisan | 1609990 | learner | draft | **new** | Editorial review |
| N2-735 | [水蒸気](entries/1371/1371660-suijouki.org) | すいじょうき | suijouki | 1371660 | learner | draft | **new** | Editorial review |
| N2-736 | [水素](entries/1371/1371780-suiso.org) | すいそ | suiso | 1371780 | learner | draft | **new** | Editorial review |
| N2-737 | [垂直](entries/1370/1370980-suichoku.org) | すいちょく | suichoku | 1370980 | learner | draft | **new** | Editorial review |
| N2-738 | [推定](entries/1371/1371210-suitei.org) | すいてい | suitei | 1371210 | learner | draft | **new** | Editorial review |
| N2-739 | [水滴](entries/1371/1371880-suiteki.org) | すいてき | suiteki | 1371880 | learner | draft | **new** | Editorial review |
| N2-740 | [水筒](entries/1371/1371910-suitou.org) | すいとう | suitou | 1371910 | learner | draft | **new** | Editorial review |
| N2-741 | [水分](entries/1372/1372010-suibun.org) | すいぶん | suibun | 1372010 | learner | draft | **new** | Editorial review |
| N2-742 | [水平](entries/1372/1372040-suihei.org) | すいへい | suihei | 1372040 | learner | draft | **new** | Editorial review |
| N2-743 | [水平線](entries/1372/1372060-suiheisen.org) | すいへいせん | suiheisen | 1372060 | learner | draft | **new** | Editorial review |
| N2-744 | [水曜](entries/1372/1372180-suiyou.org) | すいよう | suiyou | 1372180 | learner | draft | **new** | Editorial review |
| N2-745 | [末っ子](entries/1584/1584380-suekko.org) | すえっこ | suekko | 1584380 | learner | draft | **new** | Editorial review |
| N2-746 | [スカーフ](entries/1067/1067480-sukaafu.org) | スカーフ | sukaafu | 1067480 | learner | draft | **new** | Editorial review |
| N2-747 | [好き嫌い](entries/1277/1277460-sukikirai.org) | すききらい | sukikirai | 1277460 | learner | draft | **new** | Editorial review |
| N2-748 | [好き好き](entries/1595/1595570-sukizuki.org) | すきずき | sukizuki | 1595570 | learner | draft | **new** | Editorial review |
| N2-749 | [透き通る](entries/1450/1450510-sukitooru.org) | すきとおる | sukitooru | 1450510 | learner | draft | **new** | Editorial review |
| N2-750 | [隙間](entries/1253/1253790-sukima.org) | すきま | sukima | 1253790 | learner | draft | **new** | Editorial review |
| N2-751 | [杉](entries/1373/1373520-sugi.org) | すぎ | sugi | 1373520 | learner | draft | **new** | Editorial review |
| N2-752 | [少なくとも](entries/1595/1595610-sukunakutomo.org) | すくなくとも | sukunakutomo | 1595610 | learner | draft | **new** | Editorial review |
| N2-753 | [スクール](entries/1068/1068230-sukuuru.org) | スクール | sukuuru | 1068230 | learner | draft | **new** | Editorial review |
| N2-754 | [スケジュール](entries/1068/1068870-sukejuuru.org) | スケジュール | sukejuuru | 1068870 | learner | draft | **new** | Editorial review |
| N2-755 | [鈴](entries/1557/1557580-suzu.org) | すず | suzu | 1557580 | learner | draft | **new** | Editorial review |
| N2-756 | [スタート](entries/1069/1069370-sutaato.org) | スタート | sutaato | 1069370 | learner | draft | **new** | Editorial review |
| N2-757 | [スチュワーデス](entries/1070/1070220-suchuwaadesu.org) | スチュワーデス | suchuwaadesu | 1070220 | learner | draft | **new** | Editorial review |
| N2-758 | [すっきり](entries/1006/1006120-sukkiri.org) | すっきり | sukkiri | 1006120 | learner | draft | **new** | Editorial review |
| N2-759 | [酸っぱい](entries/1304/1304280-suppai.org) | すっぱい | suppai | 1304280 | learner | draft | **new** | Editorial review |
| N2-760 | [ステージ](entries/1070/1070320-suteeji.org) | ステージ | suteeji | 1070320 | learner | draft | **new** | Editorial review |
| N2-761 | [ストッキング](entries/1071/1071000-sutokkingu.org) | ストッキング | sutokkingu | 1071000 | learner | draft | **new** | Editorial review |
| N2-762 | [ストップ](entries/1071/1071100-sutoppu.org) | ストップ | sutoppu | 1071100 | learner | draft | **new** | Editorial review |
| N2-763 | [素直](entries/1397/1397340-sunao.org) | すなお | sunao | 1397340 | learner | draft | **new** | Editorial review |
| N2-764 | [スピーカー](entries/1072/1072240-supiikaa.org) | スピーカー | supiikaa | 1072240 | learner | draft | **new** | Editorial review |
| N2-765 | [住まい](entries/1595/1595750-sumai.org) | すまい | sumai | 1595750 | learner | draft | **new** | Editorial review |
| N2-766 | [済まない](entries/1610/1610020-sumanai.org) | すまない | sumanai | 1610020 | learner | draft | **new** | Editorial review |
| N2-767 | [スマート](entries/1073/1073570-sumaato.org) | スマート | sumaato | 1073570 | learner | draft | **new** | Editorial review |
| N2-768 | [墨](entries/1521/1521510-sumi.org) | すみ | sumi | 1521510 | learner | draft | **new** | Editorial review |
| N2-769 | [澄む](entries/1373/1373680-sumu.org) | すむ | sumu | 1373680 | learner | draft | **new** | Editorial review |
| N2-770 | [相撲](entries/1401/1401360-sumou.org) | すもう | sumou | 1401360 | learner | draft | **new** | Editorial review |
| N2-771 | [スライド](entries/1073/1073760-suraido.org) | スライド | suraido | 1073760 | learner | draft | **new** | Editorial review |
| N2-772 | [刷る](entries/1298/1298670-suru.org) | する | suru | 1298670 | learner | draft | **new** | Editorial review |
| N2-773 | [すれ違う](entries/1595/1595920-surechigau.org) | すれちがう | surechigau | 1595920 | learner | draft | **new** | Editorial review |
| N2-774 | [寸法](entries/1373/1373810-sunpou.org) | すんぽう | sunpou | 1373810 | learner | draft | **new** | Editorial review |
| N2-775 | [随筆](entries/1372/1372790-zuihitsu.org) | ずいひつ | zuihitsu | 1372790 | learner | draft | **new** | Editorial review |
| N2-776 | [図々しい](entries/1595/1595940-zuuzuushii.org) | ずうずうしい | zuuzuushii | 1595940 | learner | draft | **new** | Editorial review |
| N2-777 | [図鑑](entries/1370/1370370-zukan.org) | ずかん | zukan | 1370370 | learner | draft | **new** | Editorial review |
| N2-778 | [図形](entries/1370/1370380-zukei.org) | ずけい | zukei | 1370380 | learner | draft | **new** | Editorial review |
| N2-779 | [頭脳](entries/1450/1450900-zunou.org) | ずのう | zunou | 1450900 | learner | draft | **new** | Editorial review |
| N2-780 | [図表](entries/1370/1370490-zuhyou.org) | ずひょう | zuhyou | 1370490 | learner | draft | **new** | Editorial review |
| N2-781 | [ずらす](entries/1006/1006420-zurasu.org) | ずらす | zurasu | 1006420 | learner | draft | **new** | Editorial review |
| N2-782 | [ずらり](entries/2008/2008600-zurari.org) | ずらり | zurari | 2008600 | learner | draft | **new** | Editorial review |
| N2-783 | [狡い](entries/1569/1569240-zurui.org) | ずるい | zurui | 1569240 | learner | draft | **new** | Editorial review |
| N2-784 | [姓](entries/1375/1375190-sei.org) | せい | sei | 1375190 | learner | draft | **new** | Editorial review |
| N2-785 | [制作](entries/1374/1374810-seisaku.org) | せいさく | seisaku | 1374810 | learner | draft | **new** | Editorial review |
| N2-786 | [製作](entries/1380/1380650-seisaku.org) | せいさく | seisaku | 1380650 | learner | draft | **new** | Editorial review |
| N2-787 | [性質](entries/1375/1375390-seishitsu.org) | せいしつ | seishitsu | 1375390 | learner | draft | **new** | Editorial review |
| N2-788 | [清書](entries/1378/1378240-seisho.org) | せいしょ | seisho | 1378240 | learner | draft | **new** | Editorial review |
| N2-789 | [青少年](entries/1381/1381570-seishounen.org) | せいしょうねん | seishounen | 1381570 | learner | draft | **new** | Editorial review |
| N2-790 | [整数](entries/1376/1376190-seisuu.org) | せいすう | seisuu | 1376190 | learner | draft | **new** | Editorial review |
| N2-791 | [清掃](entries/1378/1378320-seisou.org) | せいそう | seisou | 1378320 | learner | draft | **new** | Editorial review |
| N2-792 | [生存](entries/1379/1379230-seizon.org) | せいぞん | seizon | 1379230 | learner | draft | **new** | Editorial review |
| N2-793 | [生長](entries/1379/1379370-seichou.org) | せいちょう | seichou | 1379370 | learner | draft | **new** | Editorial review |
| N2-794 | [政党](entries/1376/1376060-seitou.org) | せいとう | seitou | 1376060 | learner | draft | **new** | Editorial review |
| N2-795 | [生年月日](entries/1379/1379410-seinengappi.org) | せいねんがっぴ | seinengappi | 1379410 | learner | draft | **new** | Editorial review |
| N2-796 | [性能](entries/1375/1375470-seinou.org) | せいのう | seinou | 1375470 | learner | draft | **new** | Editorial review |
| N2-797 | [整備](entries/1376/1376240-seibi.org) | せいび | seibi | 1376240 | learner | draft | **new** | Editorial review |
| N2-798 | [成分](entries/1375/1375860-seibun.org) | せいぶん | seibun | 1375860 | learner | draft | **new** | Editorial review |
| N2-799 | [性別](entries/1375/1375520-seibetsu.org) | せいべつ | seibetsu | 1375520 | learner | draft | **new** | Editorial review |
| N2-800 | [正方形](entries/1377/1377920-seihoukei.org) | せいほうけい | seihoukei | 1377920 | learner | draft | **new** | Editorial review |
| N2-801 | [正門](entries/1378/1378100-seimon.org) | せいもん | seimon | 1378100 | learner | draft | **new** | Editorial review |
| N2-802 | [成立](entries/1375/1375880-seiritsu.org) | せいりつ | seiritsu | 1375880 | learner | draft | **new** | Editorial review |
| N2-803 | [西暦](entries/1381/1381140-seireki.org) | せいれき | seireki | 1381140 | learner | draft | **new** | Editorial review |
| N2-804 | [背負う](entries/1472/1472860-seou.org) | せおう | seou | 1472860 | learner | draft | **new** | Editorial review |
| N2-805 | [赤道](entries/1383/1383560-sekidou.org) | せきどう | sekidou | 1383560 | learner | draft | **new** | Editorial review |
| N2-806 | [折角](entries/1596/1596090-sekkaku.org) | せっかく | sekkaku | 1596090 | learner | draft | **new** | Editorial review |
| N2-807 | [接近](entries/1385/1385370-sekkin.org) | せっきん | sekkin | 1385370 | learner | draft | **new** | Editorial review |
| N2-808 | [接する](entries/1385/1385350-sessuru.org) | せっする | sessuru | 1385350 | learner | draft | **new** | Editorial review |
| N2-809 | [せっせと](entries/2008/2008620-sesseto.org) | せっせと | sesseto | 2008620 | learner | draft | **new** | Editorial review |
| N2-810 | [接続](entries/1385/1385480-setsuzoku.org) | せつぞく | setsuzoku | 1385480 | learner | draft | **new** | Editorial review |
| N2-811 | [瀬戸物](entries/1374/1374400-setomono.org) | せともの | setomono | 1374400 | learner | draft | **new** | Editorial review |
| N2-812 | [迫る](entries/1475/1475720-semaru.org) | せまる | semaru | 1475720 | learner | draft | **new** | Editorial review |
| N2-813 | [攻め手](entries/1675/1675160-semete.org) | せめて | semete | 1675160 | learner | draft | **new** | Editorial review |
| N2-814 | [攻める](entries/1279/1279130-semeru.org) | せめる | semeru | 1279130 | learner | draft | **new** | Editorial review |
| N2-815 | [セメント](entries/1074/1074740-semento.org) | セメント | semento | 1074740 | learner | draft | **new** | Editorial review |
| N2-816 | [栓](entries/1956/1956550-sen.org) | せん | sen | 1956550 | learner | draft | **new** | Editorial review |
| N2-817 | [洗剤](entries/1390/1390950-senzai.org) | せんざい | senzai | 1390950 | learner | draft | **new** | Editorial review |
| N2-818 | [扇子](entries/1390/1390730-sensu.org) | せんす | sensu | 1390730 | learner | draft | **new** | Editorial review |
| N2-819 | [専制](entries/1389/1389810-sensei.org) | せんせい | sensei | 1389810 | learner | draft | **new** | Editorial review |
| N2-820 | [先々月](entries/1596/1596200-sensengetsu.org) | せんせんげつ | sensengetsu | 1596200 | learner | draft | **new** | Editorial review |
| N2-821 | [先々週](entries/1888/1888910-sensenshuu.org) | せんせんしゅう | sensenshuu | 1888910 | learner | draft | **new** | Editorial review |
| N2-822 | [先祖](entries/1388/1388030-senzo.org) | せんぞ | senzo | 1388030 | learner | draft | **new** | Editorial review |
| N2-823 | [先端](entries/1388/1388110-sentan.org) | せんたん | sentan | 1388110 | learner | draft | **new** | Editorial review |
| N2-824 | [センチ](entries/1075/1075060-senchi.org) | センチ | senchi | 1075060 | learner | draft | **new** | Editorial review |
| N2-825 | [宣伝](entries/1389/1389730-senden.org) | せんでん | senden | 1389730 | learner | draft | **new** | Editorial review |
| N2-826 | [先頭](entries/1596/1596210-sentou.org) | せんとう | sentou | 1596210 | learner | draft | **new** | Editorial review |
| N2-827 | [扇風機](entries/1390/1390760-senpuuki.org) | せんぷうき | senpuuki | 1390760 | learner | draft | **new** | Editorial review |
| N2-828 | [線路](entries/1391/1391880-senro.org) | せんろ | senro | 1391880 | learner | draft | **new** | Editorial review |
| N2-829 | [税関](entries/1382/1382090-zeikan.org) | ぜいかん | zeikan | 1382090 | learner | draft | **new** | Editorial review |
| N2-830 | [是非とも](entries/1610/1610700-zehitomo.org) | ぜひとも | zehitomo | 1610700 | learner | draft | **new** | Editorial review |
| N2-831 | [ゼミ](entries/1075/1075160-zemi.org) | ゼミ | zemi | 1075160 | learner | draft | **new** | Editorial review |
| N2-832 | [前後](entries/1392/1392910-zengo.org) | ぜんご | zengo | 1392910 | learner | draft | **new** | Editorial review |
| N2-833 | [全身](entries/1395/1395410-zenshin.org) | ぜんしん | zenshin | 1395410 | learner | draft | **new** | Editorial review |
| N2-834 | [全般](entries/1396/1396020-zenpan.org) | ぜんぱん | zenpan | 1396020 | learner | draft | **new** | Editorial review |
| N2-835 | [相違](entries/1400/1400820-soui.org) | そうい | soui | 1400820 | learner | draft | **new** | Editorial review |
| N2-836 | [そう言えば](entries/1982/1982210-souieba.org) | そういえば | souieba | 1982210 | learner | draft | **new** | Editorial review |
| N2-837 | [倉庫](entries/1399/1399120-souko.org) | そうこ | souko | 1399120 | learner | draft | **new** | Editorial review |
| N2-838 | [相互](entries/1596/1596370-sougo.org) | そうご | sougo | 1596370 | learner | draft | **new** | Editorial review |
| N2-839 | [創作](entries/1398/1398420-sousaku.org) | そうさく | sousaku | 1398420 | learner | draft | **new** | Editorial review |
| N2-840 | [葬式](entries/1402/1402160-soushiki.org) | そうしき | soushiki | 1402160 | learner | draft | **new** | Editorial review |
| N2-841 | [騒々しい](entries/1596/1596440-souzoushii.org) | そうぞうしい | souzoushii | 1596440 | learner | draft | **new** | Editorial review |
| N2-842 | [送別](entries/1402/1402850-soubetsu.org) | そうべつ | soubetsu | 1402850 | learner | draft | **new** | Editorial review |
| N2-843 | [総理大臣](entries/1401/1401820-souridaijin.org) | そうりだいじん | souridaijin | 1401820 | learner | draft | **new** | Editorial review |
| N2-844 | [速達](entries/1405/1405030-sokutatsu.org) | そくたつ | sokutatsu | 1405030 | learner | draft | **new** | Editorial review |
| N2-845 | [測定](entries/1404/1404570-sokutei.org) | そくてい | sokutei | 1404570 | learner | draft | **new** | Editorial review |
| N2-846 | [速力](entries/1405/1405080-sokuryoku.org) | そくりょく | sokuryoku | 1405080 | learner | draft | **new** | Editorial review |
| N2-847 | [素質](entries/1397/1397240-soshitsu.org) | そしつ | soshitsu | 1397240 | learner | draft | **new** | Editorial review |
| N2-848 | [祖先](entries/1396/1396820-sosen.org) | そせん | sosen | 1396820 | learner | draft | **new** | Editorial review |
| N2-849 | [そそっかしい](entries/1006/1006740-sosokkashii.org) | そそっかしい | sosokkashii | 1006740 | learner | draft | **new** | Editorial review |
| N2-850 | [率直](entries/1596/1596570-sotchoku.org) | そっちょく | sotchoku | 1596570 | learner | draft | **new** | Editorial review |
| N2-851 | [そっと](entries/1006/1006810-sotto.org) | そっと | sotto | 1006810 | learner | draft | **new** | Editorial review |
| N2-852 | [その上](entries/1006/1006880-sonoue.org) | そのうえ | sonoue | 1006880 | learner | draft | **new** | Editorial review |
| N2-853 | [その頃](entries/2547/2547920-sonokoro.org) | そのころ | sonokoro | 2547920 | learner | draft | **new** | Editorial review |
| N2-854 | [その為](entries/1006/1006850-sonotame.org) | そのため | sonotame | 1006850 | learner | draft | **new** | Editorial review |
| N2-855 | [その他](entries/1006/1006900-sonohoka.org) | そのほか | sonohoka | 1006900 | learner | draft | **new** | Editorial review |
| N2-856 | [蕎麦](entries/1238/1238460-soba.org) | そば | soba | 1238460 | learner | draft | **new** | Editorial review |
| N2-857 | [剃る](entries/1581/1581900-soru.org) | そる | soru | 1581900 | learner | draft | **new** | Editorial review |
| N2-858 | [それなのに](entries/2055/2055520-sorenanoni.org) | それなのに | sorenanoni | 2055520 | learner | draft | **new** | Editorial review |
| N2-859 | [逸れる](entries/1576/1576360-soreru.org) | それる | soreru | 1576360 | learner | draft | **new** | Editorial review |
| N2-860 | [揃う](entries/1406/1406110-sorou.org) | そろう | sorou | 1406110 | learner | draft | **new** | Editorial review |
| N2-861 | [揃える](entries/1406/1406120-soroeru.org) | そろえる | soroeru | 1406120 | learner | draft | **new** | Editorial review |
| N2-862 | [算盤](entries/1596/1596700-soroban.org) | そろばん | soroban | 1596700 | learner | draft | **new** | Editorial review |
| N2-863 | [損得](entries/1406/1406770-sontoku.org) | そんとく | sontoku | 1406770 | learner | draft | **new** | Editorial review |
| N2-864 | [雑巾](entries/1299/1299370-zoukin.org) | ぞうきん | zoukin | 1299370 | learner | draft | **new** | Editorial review |
| N2-865 | [増減](entries/1403/1403200-zougen.org) | ぞうげん | zougen | 1403200 | learner | draft | **new** | Editorial review |
| N2-866 | [造船](entries/1403/1403720-zousen.org) | ぞうせん | zousen | 1403720 | learner | draft | **new** | Editorial review |
| N2-867 | [増大](entries/1403/1403310-zoudai.org) | ぞうだい | zoudai | 1403310 | learner | draft | **new** | Editorial review |
| N2-868 | [草履](entries/1402/1402060-zouri.org) | ぞうり | zouri | 1402060 | learner | draft | **new** | Editorial review |
| N2-869 | [属する](entries/1405/1405710-zokusuru.org) | ぞくする | zokusuru | 1405710 | learner | draft | **new** | Editorial review |
| N2-870 | [続々](entries/1596/1596730-zokuzoku.org) | ぞくぞく | zokuzoku | 1596730 | learner | draft | **new** | Editorial review |
| N2-871 | [存じる](entries/1406/1406140-zonjiru.org) | ぞんじる | zonjiru | 1406140 | learner | draft | **new** | Editorial review |
| N2-872 | [存ずる](entries/1983/1983710-zonzuru.org) | ぞんずる | zonzuru | 1983710 | learner | draft | **new** | Editorial review |
| N2-873 | [タイア](entries/1076/1076120-taia.org) | タイア | taia | 1076120 | learner | draft | **new** | Editorial review |
| N2-874 | [体系](entries/1409/1409390-taikei.org) | たいけい | taikei | 1409390 | learner | draft | **new** | Editorial review |
| N2-875 | [太鼓](entries/1408/1408280-taiko.org) | たいこ | taiko | 1408280 | learner | draft | **new** | Editorial review |
| N2-876 | [対策](entries/1410/1410050-taisaku.org) | たいさく | taisaku | 1410050 | learner | draft | **new** | Editorial review |
| N2-877 | [大して](entries/1412/1412970-taishite.org) | たいして | taishite | 1412970 | learner | draft | **new** | Editorial review |
| N2-878 | [対照](entries/1410/1410080-taishou.org) | たいしょう | taishou | 1410080 | learner | draft | **new** | Editorial review |
| N2-879 | [体制](entries/1409/1409550-taisei.org) | たいせい | taisei | 1409550 | learner | draft | **new** | Editorial review |
| N2-880 | [体積](entries/1409/1409560-taiseki.org) | たいせき | taiseki | 1409560 | learner | draft | **new** | Editorial review |
| N2-881 | [大層](entries/1414/1414380-taisou.org) | たいそう | taisou | 1414380 | learner | draft | **new** | Editorial review |
| N2-882 | [体操](entries/1409/1409580-taisou.org) | たいそう | taisou | 1409580 | learner | draft | **new** | Editorial review |
| N2-883 | [大木](entries/1415/1415090-taiboku.org) | たいぼく | taiboku | 1415090 | learner | draft | **new** | Editorial review |
| N2-884 | [対立](entries/1410/1410290-tairitsu.org) | たいりつ | tairitsu | 1410290 | learner | draft | **new** | Editorial review |
| N2-885 | [田植え](entries/1442/1442810-taue.org) | たうえ | taue | 1442810 | learner | draft | **new** | Editorial review |
| N2-886 | [絶えず](entries/1386/1386700-taezu.org) | たえず | taezu | 1386700 | learner | draft | **new** | Editorial review |
| N2-887 | [耐える](entries/1211/1211310-taeru.org) | たえる | taeru | 1211310 | learner | draft | **new** | Editorial review |
| N2-888 | [高める](entries/1283/1283240-takameru.org) | たかめる | takameru | 1283240 | learner | draft | **new** | Editorial review |
| N2-889 | [耕す](entries/1280/1280950-tagayasu.org) | たがやす | tagayasu | 1280950 | learner | draft | **new** | Editorial review |
| N2-890 | [滝](entries/1415/1415520-taki.org) | たき | taki | 1415520 | learner | draft | **new** | Editorial review |
| N2-891 | [炊く](entries/1596/1596830-taku.org) | たく | taku | 1596830 | learner | draft | **new** | Editorial review |
| N2-892 | [焚く](entries/1596/1596840-taku.org) | たく | taku | 1596840 | learner | draft | **new** | Editorial review |
| N2-893 | [蓄える](entries/1596/1596860-takuwaeru.org) | たくわえる | takuwaeru | 1596860 | learner | draft | **new** | Editorial review |
| N2-894 | [竹](entries/1422/1422230-take.org) | たけ | take | 1422230 | learner | draft | **new** | Editorial review |
| N2-895 | [助かる](entries/1344/1344380-tasukaru.org) | たすかる | tasukaru | 1344380 | learner | draft | **new** | Editorial review |
| N2-896 | [畳む](entries/1356/1356780-tatamu.org) | たたむ | tatamu | 1356780 | learner | draft | **new** | Editorial review |
| N2-897 | [但し](entries/1416/1416190-tadashi.org) | ただし | tadashi | 1416190 | learner | draft | **new** | Editorial review |
| N2-898 | [立ち止まる](entries/1551/1551350-tachidomaru.org) | たちどまる | tachidomaru | 1551350 | learner | draft | **new** | Editorial review |
| N2-899 | [忽ち](entries/1288/1288480-tachimachi.org) | たちまち | tachimachi | 1288480 | learner | draft | **new** | Editorial review |
| N2-900 | [建つ](entries/1597/1597045-tatsu.org) | たつ | tatsu | 1597045 | learner | draft | **new** | Editorial review |
| N2-901 | [例える](entries/1597/1597130-tatoeru.org) | たとえる | tatoeru | 1597130 | learner | draft | **new** | Editorial review |
| N2-902 | [頼もしい](entries/1548/1548380-tanomoshii.org) | たのもしい | tanomoshii | 1548380 | learner | draft | **new** | Editorial review |
| N2-903 | [足袋](entries/1404/1404920-tabi.org) | たび | tabi | 1404920 | learner | draft | **new** | Editorial review |
| N2-904 | [溜まる](entries/1552/1552650-tamaru.org) | たまる | tamaru | 1552650 | learner | draft | **new** | Editorial review |
| N2-905 | [ため息](entries/1597/1597190-tameiki.org) | ためいき | tameiki | 1597190 | learner | draft | **new** | Editorial review |
| N2-906 | [躊躇う](entries/1573/1573390-tamerau.org) | ためらう | tamerau | 1573390 | learner | draft | **new** | Editorial review |
| N2-907 | [溜める](entries/1552/1552630-tameru.org) | ためる | tameru | 1552630 | learner | draft | **new** | Editorial review |
| N2-908 | [足る](entries/1404/1404750-taru.org) | たる | taru | 1404750 | learner | draft | **new** | Editorial review |
| N2-909 | [短期](entries/1418/1418640-tanki.org) | たんき | tanki | 1418640 | learner | draft | **new** | Editorial review |
| N2-910 | [炭鉱](entries/1597/1597260-tankou.org) | たんこう | tankou | 1597260 | learner | draft | **new** | Editorial review |
| N2-911 | [短所](entries/1418/1418760-tansho.org) | たんしょ | tansho | 1418760 | learner | draft | **new** | Editorial review |
| N2-912 | [箪笥](entries/1418/1418990-tansu.org) | たんす | tansu | 1418990 | learner | draft | **new** | Editorial review |
| N2-913 | [淡水](entries/1418/1418460-tansui.org) | たんすい | tansui | 1418460 | learner | draft | **new** | Editorial review |
| N2-914 | [単数](entries/1417/1417670-tansuu.org) | たんすう | tansuu | 1417670 | learner | draft | **new** | Editorial review |
| N2-915 | [短編](entries/1597/1597300-tanpen.org) | たんぺん | tanpen | 1597300 | learner | draft | **new** | Editorial review |
| N2-916 | [田んぼ](entries/1442/1442840-tanbo.org) | たんぼ | tanbo | 1442840 | learner | draft | **new** | Editorial review |
| N2-917 | [ダイアグラム](entries/1076/1076680-daiaguramu.org) | ダイアグラム | daiaguramu | 1076680 | learner | draft | **new** | Editorial review |
| N2-918 | [大工](entries/1413/1413690-daiku.org) | だいく | daiku | 1413690 | learner | draft | **new** | Editorial review |
| N2-919 | [大小](entries/1414/1414110-daishou.org) | だいしょう | daishou | 1414110 | learner | draft | **new** | Editorial review |
| N2-920 | [題名](entries/1415/1415490-daimei.org) | だいめい | daimei | 1415490 | learner | draft | **new** | Editorial review |
| N2-921 | [代名詞](entries/1412/1412340-daimeishi.org) | だいめいし | daimeishi | 1412340 | learner | draft | **new** | Editorial review |
| N2-922 | [ダイヤモンド](entries/1076/1076890-daiyamondo.org) | ダイヤモンド | daiyamondo | 1076890 | learner | draft | **new** | Editorial review |
| N2-923 | [ダイヤル](entries/1076/1076900-daiyaru.org) | ダイヤル | daiyaru | 1076900 | learner | draft | **new** | Editorial review |
| N2-924 | [楕円](entries/1409/1409000-daen.org) | だえん | daen | 1409000 | learner | draft | **new** | Editorial review |
| N2-925 | [脱線](entries/1416/1416560-dassen.org) | だっせん | dassen | 1416560 | learner | draft | **new** | Editorial review |
| N2-926 | [妥当](entries/1408/1408540-datou.org) | だとう | datou | 1408540 | learner | draft | **new** | Editorial review |
| N2-927 | [ダブル](entries/1077/1077110-daburu.org) | ダブル | daburu | 1077110 | learner | draft | **new** | Editorial review |
| N2-928 | [騙す](entries/1574/1574550-damasu.org) | だます | damasu | 1574550 | learner | draft | **new** | Editorial review |
| N2-929 | [ダム](entries/1077/1077140-damu.org) | ダム | damu | 1077140 | learner | draft | **new** | Editorial review |
| N2-930 | [だらし無い](entries/1007/1007500-darashinai.org) | だらしない | darashinai | 1007500 | learner | draft | **new** | Editorial review |
| N2-931 | [段階](entries/1419/1419950-dankai.org) | だんかい | dankai | 1419950 | learner | draft | **new** | Editorial review |
| N2-932 | [断水](entries/1419/1419660-dansui.org) | だんすい | dansui | 1419660 | learner | draft | **new** | Editorial review |
| N2-933 | [団地](entries/1419/1419300-danchi.org) | だんち | danchi | 1419300 | learner | draft | **new** | Editorial review |
| N2-934 | [誓う](entries/1381/1381210-chikau.org) | ちかう | chikau | 1381210 | learner | draft | **new** | Editorial review |
| N2-935 | [地下水](entries/1622/1622630-chikasui.org) | ちかすい | chikasui | 1622630 | learner | draft | **new** | Editorial review |
| N2-936 | [近づける](entries/1242/1242520-chikazukeru.org) | ちかづける | chikazukeru | 1242520 | learner | draft | **new** | Editorial review |
| N2-937 | [近寄る](entries/1242/1242230-chikayoru.org) | ちかよる | chikayoru | 1242230 | learner | draft | **new** | Editorial review |
| N2-938 | [力強い](entries/1554/1554940-chikarazuyoi.org) | ちからづよい | chikarazuyoi | 1554940 | learner | draft | **new** | Editorial review |
| N2-939 | [千切る](entries/1389/1389020-chigiru.org) | ちぎる | chigiru | 1389020 | learner | draft | **new** | Editorial review |
| N2-940 | [地質](entries/1421/1421130-chishitsu.org) | ちしつ | chishitsu | 1421130 | learner | draft | **new** | Editorial review |
| N2-941 | [知人](entries/1420/1420620-chijin.org) | ちじん | chijin | 1420620 | learner | draft | **new** | Editorial review |
| N2-942 | [地帯](entries/1421/1421360-chitai.org) | ちたい | chitai | 1421360 | learner | draft | **new** | Editorial review |
| N2-943 | [縮む](entries/1337/1337560-chijimu.org) | ちぢむ | chijimu | 1337560 | learner | draft | **new** | Editorial review |
| N2-944 | [縮める](entries/1337/1337570-chijimeru.org) | ちぢめる | chijimeru | 1337570 | learner | draft | **new** | Editorial review |
| N2-945 | [縮れる](entries/1337/1337590-chijireru.org) | ちぢれる | chijireru | 1337590 | learner | draft | **new** | Editorial review |
| N2-946 | [チップ](entries/1077/1077740-chippu.org) | チップ | chippu | 1077740 | learner | draft | **new** | Editorial review |
| N2-947 | [地点](entries/1421/1421380-chiten.org) | ちてん | chiten | 1421380 | learner | draft | **new** | Editorial review |
| N2-948 | [地名](entries/1421/1421500-chimei.org) | ちめい | chimei | 1421500 | learner | draft | **new** | Editorial review |
| N2-949 | [茶色い](entries/1983/1983730-chairoi.org) | ちゃいろい | chairoi | 1983730 | learner | draft | **new** | Editorial review |
| N2-950 | [着々](entries/1597/1597480-chakuchaku.org) | ちゃくちゃく | chakuchaku | 1597480 | learner | draft | **new** | Editorial review |
| N2-951 | [中間](entries/1423/1423680-chuukan.org) | ちゅうかん | chuukan | 1423680 | learner | draft | **new** | Editorial review |
| N2-952 | [抽象](entries/1426/1426190-chuushou.org) | ちゅうしょう | chuushou | 1426190 | learner | draft | **new** | Editorial review |
| N2-953 | [中旬](entries/1424/1424490-chuujun.org) | ちゅうじゅん | chuujun | 1424490 | learner | draft | **new** | Editorial review |
| N2-954 | [中性](entries/1424/1424710-chuusei.org) | ちゅうせい | chuusei | 1424710 | learner | draft | **new** | Editorial review |
| N2-955 | [中世](entries/1424/1424690-chuusei.org) | ちゅうせい | chuusei | 1424690 | learner | draft | **new** | Editorial review |
| N2-956 | [中途](entries/1425/1425030-chuuto.org) | ちゅうと | chuuto | 1425030 | learner | draft | **new** | Editorial review |
| N2-957 | [中年](entries/1425/1425240-chuunen.org) | ちゅうねん | chuunen | 1425240 | learner | draft | **new** | Editorial review |
| N2-958 | [超過](entries/1429/1429410-chouka.org) | ちょうか | chouka | 1429410 | learner | draft | **new** | Editorial review |
| N2-959 | [彫刻](entries/1427/1427980-choukoku.org) | ちょうこく | choukoku | 1427980 | learner | draft | **new** | Editorial review |
| N2-960 | [長所](entries/1430/1430030-chousho.org) | ちょうしょ | chousho | 1430030 | learner | draft | **new** | Editorial review |
| N2-961 | [長女](entries/1430/1430040-choujo.org) | ちょうじょ | choujo | 1430040 | learner | draft | **new** | Editorial review |
| N2-962 | [調整](entries/1429/1429200-chousei.org) | ちょうせい | chousei | 1429200 | learner | draft | **new** | Editorial review |
| N2-963 | [調節](entries/1429/1429240-chousetsu.org) | ちょうせつ | chousetsu | 1429240 | learner | draft | **new** | Editorial review |
| N2-964 | [長短](entries/1430/1430070-choutan.org) | ちょうたん | choutan | 1430070 | learner | draft | **new** | Editorial review |
| N2-965 | [頂点](entries/1430/1430240-chouten.org) | ちょうてん | chouten | 1430240 | learner | draft | **new** | Editorial review |
| N2-966 | [長男](entries/1430/1430080-chounan.org) | ちょうなん | chounan | 1430080 | learner | draft | **new** | Editorial review |
| N2-967 | [長方形](entries/1430/1430130-chouhoukei.org) | ちょうほうけい | chouhoukei | 1430130 | learner | draft | **new** | Editorial review |
| N2-968 | [調味料](entries/1429/1429290-choumiryou.org) | ちょうみりょう | choumiryou | 1429290 | learner | draft | **new** | Editorial review |
| N2-969 | [直後](entries/1430/1430930-chokugo.org) | ちょくご | chokugo | 1430930 | learner | draft | **new** | Editorial review |
| N2-970 | [直線](entries/1431/1431310-chokusen.org) | ちょくせん | chokusen | 1431310 | learner | draft | **new** | Editorial review |
| N2-971 | [直前](entries/1431/1431330-chokuzen.org) | ちょくぜん | chokuzen | 1431330 | learner | draft | **new** | Editorial review |
| N2-972 | [直流](entries/1431/1431600-chokuryuu.org) | ちょくりゅう | chokuryuu | 1431600 | learner | draft | **new** | Editorial review |
| N2-973 | [貯蔵](entries/1427/1427220-chozou.org) | ちょぞう | chozou | 1427220 | learner | draft | **new** | Editorial review |
| N2-974 | [直角](entries/1430/1430800-chokkaku.org) | ちょっかく | chokkaku | 1430800 | learner | draft | **new** | Editorial review |
| N2-975 | [直径](entries/1597/1597720-chokkei.org) | ちょっけい | chokkei | 1597720 | learner | draft | **new** | Editorial review |
| N2-976 | [チョーク](entries/1078/1078240-chooku.org) | チョーク | chooku | 1078240 | learner | draft | **new** | Editorial review |
| N2-977 | [散らかす](entries/1303/1303420-chirakasu.org) | ちらかす | chirakasu | 1303420 | learner | draft | **new** | Editorial review |
| N2-978 | [散らかる](entries/1303/1303430-chirakaru.org) | ちらかる | chirakaru | 1303430 | learner | draft | **new** | Editorial review |
| N2-979 | [散らす](entries/1303/1303460-chirasu.org) | ちらす | chirasu | 1303460 | learner | draft | **new** | Editorial review |
| N2-980 | [ちり紙](entries/1612/1612710-chirigami.org) | ちりがみ | chirigami | 1612710 | learner | draft | **new** | Editorial review |
| N2-981 | [散る](entries/1303/1303490-chiru.org) | ちる | chiru | 1303490 | learner | draft | **new** | Editorial review |
| N2-982 | [追加](entries/1432/1432460-tsuika.org) | ついか | tsuika | 1432460 | learner | draft | **new** | Editorial review |
| N2-983 | [序で](entries/1345/1345470-tsuide.org) | ついで | tsuide | 1345470 | learner | draft | **new** | Editorial review |
| N2-984 | [通貨](entries/1433/1433050-tsuuka.org) | つうか | tsuuka | 1433050 | learner | draft | **new** | Editorial review |
| N2-985 | [通勤](entries/1433/1433140-tsuukin.org) | つうきん | tsuukin | 1433140 | learner | draft | **new** | Editorial review |
| N2-986 | [通ずる](entries/1983/1983740-tsuuzuru.org) | つうずる | tsuuzuru | 1983740 | learner | draft | **new** | Editorial review |
| N2-987 | [通知](entries/1433/1433470-tsuuchi.org) | つうち | tsuuchi | 1433470 | learner | draft | **new** | Editorial review |
| N2-988 | [通帳](entries/1433/1433490-tsuuchou.org) | つうちょう | tsuuchou | 1433490 | learner | draft | **new** | Editorial review |
| N2-989 | [通訳](entries/1433/1433560-tsuuyaku.org) | つうやく | tsuuyaku | 1433560 | learner | draft | **new** | Editorial review |
| N2-990 | [通用](entries/1433/1433570-tsuuyou.org) | つうよう | tsuuyou | 1433570 | learner | draft | **new** | Editorial review |
| N2-991 | [通路](entries/1433/1433600-tsuuro.org) | つうろ | tsuuro | 1433600 | learner | draft | **new** | Editorial review |
| N2-992 | [付き合う](entries/1597/1597790-tsukiau.org) | つきあう | tsukiau | 1597790 | learner | draft | **new** | Editorial review |
| N2-993 | [突き当たり](entries/1456/1456770-tsukiatari.org) | つきあたり | tsukiatari | 1456770 | learner | draft | **new** | Editorial review |
| N2-994 | [突き当たる](entries/1456/1456780-tsukiataru.org) | つきあたる | tsukiataru | 1456780 | learner | draft | **new** | Editorial review |
| N2-995 | [点く](entries/1441/1441400-tsuku.org) | つく | tsuku | 1441400 | learner | draft | **existing** | Editorial review |
| N2-996 | [突く](entries/1456/1456890-tsuku.org) | つく | tsuku | 1456890 | learner | draft | **new** | Editorial review |
| N2-997 | [次ぐ](entries/1316/1316400-tsugu.org) | つぐ | tsugu | 1316400 | learner | draft | **new** | Editorial review |
| N2-998 | [点ける](entries/1610/1610400-tsukeru.org) | つける | tsukeru | 1610400 | learner | draft | **new** | Editorial review |
| N2-999 | [伝わる](entries/1441/1441900-tsutawaru.org) | つたわる | tsutawaru | 1441900 | learner | draft | **new** | Editorial review |
| N2-1000 | [突っ込む](entries/1456/1456940-tsukkomu.org) | つっこむ | tsukkomu | 1456940 | learner | draft | **new** | Editorial review |
| N2-1001 | [努める](entries/1240/1240820-tsutomeru.org) | つとめる | tsutomeru | 1240820 | learner | draft | **new** | Editorial review |
| N2-1002 | [綱](entries/1280/1280880-tsuna.org) | つな | tsuna | 1280880 | learner | draft | **new** | Editorial review |
| N2-1003 | [繋がり](entries/1251/1251870-tsunagari.org) | つながり | tsunagari | 1251870 | learner | draft | **new** | Editorial review |
| N2-1004 | [繋がる](entries/1251/1251880-tsunagaru.org) | つながる | tsunagaru | 1251880 | learner | draft | **new** | Editorial review |
| N2-1005 | [繋げる](entries/1251/1251910-tsunageru.org) | つなげる | tsunageru | 1251910 | learner | draft | **new** | Editorial review |
| N2-1006 | [粒](entries/1552/1552890-tsubu.org) | つぶ | tsubu | 1552890 | learner | draft | **new** | Editorial review |
| N2-1007 | [潰す](entries/1433/1433820-tsubusu.org) | つぶす | tsubusu | 1433820 | learner | draft | **new** | Editorial review |
| N2-1008 | [潰れる](entries/1433/1433830-tsubureru.org) | つぶれる | tsubureru | 1433830 | learner | draft | **new** | Editorial review |
| N2-1009 | [躓く](entries/1573/1573400-tsumazuku.org) | つまずく | tsumazuku | 1573400 | learner | draft | **new** | Editorial review |
| N2-1010 | [詰まる](entries/1226/1226480-tsumaru.org) | つまる | tsumaru | 1226480 | learner | draft | **new** | Editorial review |
| N2-1011 | [積む](entries/1382/1382970-tsumu.org) | つむ | tsumu | 1382970 | learner | draft | **new** | Editorial review |
| N2-1012 | [爪](entries/1433/1433880-tsume.org) | つめ | tsume | 1433880 | learner | draft | **new** | Editorial review |
| N2-1013 | [艶](entries/1177/1177680-tsuya.org) | つや | tsuya | 1177680 | learner | draft | **new** | Editorial review |
| N2-1014 | [強気](entries/1236/1236230-tsuyoki.org) | つよき | tsuyoki | 1236230 | learner | draft | **new** | Editorial review |
| N2-1015 | [釣り合う](entries/1434/1434050-tsuriau.org) | つりあう | tsuriau | 1434050 | learner | draft | **new** | Editorial review |
| N2-1016 | [吊る](entries/1434/1434020-tsuru.org) | つる | tsuru | 1434020 | learner | draft | **new** | Editorial review |
| N2-1017 | [吊るす](entries/1433/1433980-tsurusu.org) | つるす | tsurusu | 1433980 | learner | draft | **new** | Editorial review |
| N2-1018 | [手洗い](entries/1328/1328020-tearai.org) | てあらい | tearai | 1328020 | learner | draft | **new** | Editorial review |
| N2-1019 | [定員](entries/1435/1435400-teiin.org) | ていいん | teiin | 1435400 | learner | draft | **new** | Editorial review |
| N2-1020 | [低下](entries/1434/1434250-teika.org) | ていか | teika | 1434250 | learner | draft | **new** | Editorial review |
| N2-1021 | [定価](entries/1435/1435410-teika.org) | ていか | teika | 1435410 | learner | draft | **new** | Editorial review |
| N2-1022 | [定期券](entries/1435/1435510-teikiken.org) | ていきけん | teikiken | 1435510 | learner | draft | **new** | Editorial review |
| N2-1023 | [停止](entries/1434/1434920-teishi.org) | ていし | teishi | 1434920 | learner | draft | **new** | Editorial review |
| N2-1024 | [停車](entries/1434/1434960-teisha.org) | ていしゃ | teisha | 1434960 | learner | draft | **new** | Editorial review |
| N2-1025 | [手入れ](entries/1328/1328250-teire.org) | ていれ | teire | 1328250 | learner | draft | **new** | Editorial review |
| N2-1026 | [的確](entries/1437/1437290-tekikaku.org) | てきかく | tekikaku | 1437290 | learner | draft | **new** | Editorial review |
| N2-1027 | [手首](entries/1327/1327770-tekubi.org) | てくび | tekubi | 1327770 | learner | draft | **new** | Editorial review |
| N2-1028 | [手ごろ](entries/1327/1327660-tegoro.org) | てごろ | tegoro | 1327660 | learner | draft | **new** | Editorial review |
| N2-1029 | [手帳](entries/1598/1598330-techou.org) | てちょう | techou | 1598330 | learner | draft | **new** | Editorial review |
| N2-1030 | [鉄橋](entries/1437/1437820-tekkyou.org) | てっきょう | tekkyou | 1437820 | learner | draft | **new** | Editorial review |
| N2-1031 | [鉄砲](entries/1438/1438010-teppou.org) | てっぽう | teppou | 1438010 | learner | draft | **new** | Editorial review |
| N2-1032 | [手続き](entries/1598/1598350-tetsuzuki.org) | てつづき | tetsuzuki | 1598350 | learner | draft | **new** | Editorial review |
| N2-1033 | [テニスコート](entries/1080/1080030-tenisukooto.org) | テニスコート | tenisukooto | 1080030 | learner | draft | **new** | Editorial review |
| N2-1034 | [手ぬぐい](entries/1598/1598400-tenugui.org) | てぬぐい | tenugui | 1598400 | learner | draft | **new** | Editorial review |
| N2-1035 | [手前](entries/1328/1328030-temae.org) | てまえ | temae | 1328030 | learner | draft | **new** | Editorial review |
| N2-1036 | [照らす](entries/1350/1350840-terasu.org) | てらす | terasu | 1350840 | learner | draft | **new** | Editorial review |
| N2-1037 | [照る](entries/1350/1350860-teru.org) | てる | teru | 1350860 | learner | draft | **new** | Editorial review |
| N2-1038 | [展開](entries/1440/1440600-tenkai.org) | てんかい | tenkai | 1440600 | learner | draft | **new** | Editorial review |
| N2-1039 | [点数](entries/1441/1441660-tensuu.org) | てんすう | tensuu | 1441660 | learner | draft | **new** | Editorial review |
| N2-1040 | [点々](entries/1598/1598460-tenten.org) | てんてん | tenten | 1598460 | learner | draft | **new** | Editorial review |
| N2-1041 | [転々](entries/1704/1704220-tenten.org) | てんてん | tenten | 1704220 | learner | draft | **new** | Editorial review |
| N2-1042 | [天皇](entries/1582/1582030-tennou.org) | てんのう | tennou | 1582030 | learner | draft | **new** | Editorial review |
| N2-1043 | [テンポ](entries/1081/1081120-tenpo.org) | テンポ | tenpo | 1081120 | learner | draft | **new** | Editorial review |
| N2-1044 | [テーマ](entries/1078/1078830-teema.org) | テーマ | teema | 1078830 | learner | draft | **new** | Editorial review |
| N2-1045 | [出入り](entries/1339/1339910-deiri.org) | でいり | deiri | 1339910 | learner | draft | **new** | Editorial review |
| N2-1046 | [出入り口](entries/1598/1598540-deiriguchi.org) | でいりぐち | deiriguchi | 1598540 | learner | draft | **new** | Editorial review |
| N2-1047 | [出来上がり](entries/1340/1340600-dekiagari.org) | できあがり | dekiagari | 1340600 | learner | draft | **new** | Editorial review |
| N2-1048 | [出来上がる](entries/1340/1340610-dekiagaru.org) | できあがる | dekiagaru | 1340610 | learner | draft | **new** | Editorial review |
| N2-1049 | [出鱈目](entries/1339/1339630-detarame.org) | でたらめ | detarame | 1339630 | learner | draft | **new** | Editorial review |
| N2-1050 | [出迎え](entries/1338/1338710-demukae.org) | でむかえ | demukae | 1338710 | learner | draft | **new** | Editorial review |
| N2-1051 | [出迎える](entries/1338/1338720-demukaeru.org) | でむかえる | demukaeru | 1338720 | learner | draft | **new** | Editorial review |
| N2-1052 | [伝記](entries/1441/1441960-denki.org) | でんき | denki | 1441960 | learner | draft | **new** | Editorial review |
| N2-1053 | [電球](entries/1443/1443170-denkyuu.org) | でんきゅう | denkyuu | 1443170 | learner | draft | **new** | Editorial review |
| N2-1054 | [電池](entries/1443/1443620-denchi.org) | でんち | denchi | 1443620 | learner | draft | **new** | Editorial review |
| N2-1055 | [電柱](entries/1443/1443630-denchuu.org) | でんちゅう | denchuu | 1443630 | learner | draft | **new** | Editorial review |
| N2-1056 | [電波](entries/1443/1443720-denpa.org) | でんぱ | denpa | 1443720 | learner | draft | **new** | Editorial review |
| N2-1057 | [電流](entries/1443/1443790-denryuu.org) | でんりゅう | denryuu | 1443790 | learner | draft | **new** | Editorial review |
| N2-1058 | [電力](entries/1443/1443810-denryoku.org) | でんりょく | denryoku | 1443810 | learner | draft | **new** | Editorial review |
| N2-1059 | [問い合わせ](entries/1598/1598590-toiawase.org) | といあわせ | toiawase | 1598590 | learner | draft | **new** | Editorial review |
| N2-1060 | [統一](entries/1449/1449670-touitsu.org) | とういつ | touitsu | 1449670 | learner | draft | **new** | Editorial review |
| N2-1061 | [統計](entries/1449/1449710-toukei.org) | とうけい | toukei | 1449710 | learner | draft | **new** | Editorial review |
| N2-1062 | [峠](entries/1454/1454420-touge.org) | とうげ | touge | 1454420 | learner | draft | **new** | Editorial review |
| N2-1063 | [東西](entries/1447/1447910-touzai.org) | とうざい | touzai | 1447910 | learner | draft | **new** | Editorial review |
| N2-1064 | [投書](entries/1447/1447270-tousho.org) | とうしょ | tousho | 1447270 | learner | draft | **new** | Editorial review |
| N2-1065 | [当日](entries/1449/1449210-toujitsu.org) | とうじつ | toujitsu | 1449210 | learner | draft | **new** | Editorial review |
| N2-1066 | [登場](entries/1444/1444800-toujou.org) | とうじょう | toujou | 1444800 | learner | draft | **new** | Editorial review |
| N2-1067 | [灯台](entries/1448/1448730-toudai.org) | とうだい | toudai | 1448730 | learner | draft | **new** | Editorial review |
| N2-1068 | [盗難](entries/1448/1448500-tounan.org) | とうなん | tounan | 1448500 | learner | draft | **new** | Editorial review |
| N2-1069 | [当番](entries/1449/1449220-touban.org) | とうばん | touban | 1449220 | learner | draft | **new** | Editorial review |
| N2-1070 | [等分](entries/1449/1449510-toubun.org) | とうぶん | toubun | 1449510 | learner | draft | **new** | Editorial review |
| N2-1071 | [透明](entries/1450/1450590-toumei.org) | とうめい | toumei | 1450590 | learner | draft | **new** | Editorial review |
| N2-1072 | [灯油](entries/1448/1448760-touyu.org) | とうゆ | touyu | 1448760 | learner | draft | **new** | Editorial review |
| N2-1073 | [東洋](entries/1448/1448230-touyou.org) | とうよう | touyou | 1448230 | learner | draft | **new** | Editorial review |
| N2-1074 | [通りかかる](entries/1432/1432940-toorikakaru.org) | とおりかかる | toorikakaru | 1432940 | learner | draft | **new** | Editorial review |
| N2-1075 | [溶かす](entries/1546/1546040-tokasu.org) | とかす | tokasu | 1546040 | learner | draft | **new** | Editorial review |
| N2-1076 | [尖る](entries/1389/1389970-togaru.org) | とがる | togaru | 1389970 | learner | draft | **new** | Editorial review |
| N2-1077 | [溶く](entries/1546/1546050-toku.org) | とく | toku | 1546050 | learner | draft | **new** | Editorial review |
| N2-1078 | [特殊](entries/1454/1454970-tokushu.org) | とくしゅ | tokushu | 1454970 | learner | draft | **new** | Editorial review |
| N2-1079 | [特色](entries/1455/1455080-tokushoku.org) | とくしょく | tokushoku | 1455080 | learner | draft | **new** | Editorial review |
| N2-1080 | [特長](entries/1455/1455200-tokuchou.org) | とくちょう | tokuchou | 1455200 | learner | draft | **new** | Editorial review |
| N2-1081 | [特定](entries/1455/1455210-tokutei.org) | とくてい | tokutei | 1455210 | learner | draft | **new** | Editorial review |
| N2-1082 | [特売](entries/1455/1455250-tokubai.org) | とくばい | tokubai | 1455250 | learner | draft | **new** | Editorial review |
| N2-1083 | [溶け込む](entries/1546/1546090-tokekomu.org) | とけこむ | tokekomu | 1546090 | learner | draft | **new** | Editorial review |
| N2-1084 | [溶ける](entries/1546/1546070-tokeru.org) | とける | tokeru | 1546070 | learner | draft | **new** | Editorial review |
| N2-1085 | [床の間](entries/1349/1349400-tokonoma.org) | とこのま | tokonoma | 1349400 | learner | draft | **new** | Editorial review |
| N2-1086 | [所々](entries/1598/1598730-tokorodokoro.org) | ところどころ | tokorodokoro | 1598730 | learner | draft | **new** | Editorial review |
| N2-1087 | [都心](entries/1445/1445000-toshin.org) | としん | toshin | 1445000 | learner | draft | **new** | Editorial review |
| N2-1088 | [戸棚](entries/1267/1267050-todana.org) | とだな | todana | 1267050 | learner | draft | **new** | Editorial review |
| N2-1089 | [疾っくに](entries/1320/1320570-tokkuni.org) | とっくに | tokkuni | 1320570 | learner | draft | **new** | Editorial review |
| N2-1090 | [整う](entries/1598/1598800-totonou.org) | ととのう | totonou | 1598800 | learner | draft | **new** | Editorial review |
| N2-1091 | [止まる](entries/2657/2657130-todomaru.org) | とどまる | todomaru | 2657130 | learner | draft | **new** | Editorial review |
| N2-1092 | [止まる](entries/2657/2657130-todomaru.org) | とどまる | todomaru | 2657130 | learner | draft | **existing** | Editorial review |
| N2-1093 | [飛び込む](entries/1598/1598890-tobikomu.org) | とびこむ | tobikomu | 1598890 | learner | draft | **new** | Editorial review |
| N2-1094 | [泊める](entries/1474/1474860-tomeru.org) | とめる | tomeru | 1474860 | learner | draft | **new** | Editorial review |
| N2-1095 | [兎も角](entries/1444/1444010-tomokaku.org) | ともかく | tomokaku | 1444010 | learner | draft | **new** | Editorial review |
| N2-1096 | [捉える](entries/1598/1598960-toraeru.org) | とらえる | toraeru | 1598960 | learner | draft | **new** | Editorial review |
| N2-1097 | [取り入れる](entries/1326/1326880-toriireru.org) | とりいれる | toriireru | 1326880 | learner | draft | **new** | Editorial review |
| N2-1098 | [取り消す](entries/1326/1326790-torikesu.org) | とりけす | torikesu | 1326790 | learner | draft | **new** | Editorial review |
| N2-1099 | [取り出す](entries/1326/1326770-toridasu.org) | とりだす | toridasu | 1326770 | learner | draft | **new** | Editorial review |
| N2-1100 | [捕る](entries/1514/1514140-toru.org) | とる | toru | 1514140 | learner | draft | **new** | Editorial review |
| N2-1101 | [トレーニング](entries/1087/1087100-toreeningu.org) | トレーニング | toreeningu | 1087100 | learner | draft | **new** | Editorial review |
| N2-1102 | [銅](entries/1582/1582390-dou.org) | どう | dou | 1582390 | learner | draft | **new** | Editorial review |
| N2-1103 | [同格](entries/1452/1452000-doukaku.org) | どうかく | doukaku | 1452000 | learner | draft | **new** | Editorial review |
| N2-1104 | [動作](entries/1451/1451350-dousa.org) | どうさ | dousa | 1451350 | learner | draft | **new** | Editorial review |
| N2-1105 | [どうせ](entries/1008/1008950-douse.org) | どうせ | douse | 1008950 | learner | draft | **new** | Editorial review |
| N2-1106 | [どうぞ宜しく](entries/1008/1008960-douzoyoroshiku.org) | どうぞよろしく | douzoyoroshiku | 1008960 | learner | draft | **new** | Editorial review |
| N2-1107 | [童話](entries/1454/1454000-douwa.org) | どうわ | douwa | 1454000 | learner | draft | **new** | Editorial review |
| N2-1108 | [ドキドキ](entries/1009/1009050-dokidoki.org) | ドキドキ | dokidoki | 1009050 | learner | draft | **new** | Editorial review |
| N2-1109 | [退く](entries/1595/1595080-doku.org) | どく | doku | 1595080 | learner | draft | **new** | Editorial review |
| N2-1110 | [どっと](entries/1009/1009210-dotto.org) | どっと | dotto | 1009210 | learner | draft | **new** | Editorial review |
| N2-1111 | [怒鳴る](entries/1445/1445740-donaru.org) | どなる | donaru | 1445740 | learner | draft | **new** | Editorial review |
| N2-1112 | [丼](entries/1562/1562970-donburi.org) | どんぶり | donburi | 1562970 | learner | draft | **new** | Editorial review |
| N2-1113 | [内科](entries/1457/1457830-naika.org) | ないか | naika | 1457830 | learner | draft | **new** | Editorial review |
| N2-1114 | [内線](entries/1458/1458650-naisen.org) | ないせん | naisen | 1458650 | learner | draft | **new** | Editorial review |
| N2-1115 | [ナイロン](entries/1089/1089930-nairon.org) | ナイロン | nairon | 1089930 | learner | draft | **new** | Editorial review |
| N2-1116 | [仲直り](entries/1426/1426000-nakanaori.org) | なかなおり | nakanaori | 1426000 | learner | draft | **new** | Editorial review |
| N2-1117 | [中身](entries/1599/1599430-nakami.org) | なかみ | nakami | 1599430 | learner | draft | **new** | Editorial review |
| N2-1118 | [中指](entries/1581/1581690-nakayubi.org) | なかゆび | nakayubi | 1581690 | learner | draft | **new** | Editorial review |
| N2-1119 | [仲良し](entries/1426/1426100-nakayoshi.org) | なかよし | nakayoshi | 1426100 | learner | draft | **new** | Editorial review |
| N2-1120 | [慰める](entries/1156/1156890-nagusameru.org) | なぐさめる | nagusameru | 1156890 | learner | draft | **new** | Editorial review |
| N2-1121 | [殴る](entries/1181/1181390-naguru.org) | なぐる | naguru | 1181390 | learner | draft | **new** | Editorial review |
| N2-1122 | [成す](entries/1157/1157130-nasu.org) | なす | nasu | 1157130 | learner | draft | **new** | Editorial review |
| N2-1123 | [謎々](entries/1599/1599500-nazonazo.org) | なぞなぞ | nazonazo | 1599500 | learner | draft | **new** | Editorial review |
| N2-1124 | [なだらか](entries/1632/1632290-nadaraka.org) | なだらか | nadaraka | 1632290 | learner | draft | **new** | Editorial review |
| N2-1125 | [懐かしい](entries/1200/1200490-natsukashii.org) | なつかしい | natsukashii | 1200490 | learner | draft | **new** | Editorial review |
| N2-1126 | [撫でる](entries/1498/1498290-naderu.org) | なでる | naderu | 1498290 | learner | draft | **new** | Editorial review |
| N2-1127 | [斜め](entries/1322/1322400-naname.org) | ななめ | naname | 1322400 | learner | draft | **new** | Editorial review |
| N2-1128 | [何しろ](entries/1188/1188330-nanishiro.org) | なにしろ | nanishiro | 1188330 | learner | draft | **new** | Editorial review |
| N2-1129 | [何々](entries/1599/1599580-naninani.org) | なになに | naninani | 1599580 | learner | draft | **new** | Editorial review |
| N2-1130 | [何分](entries/1189/1189310-nanibun.org) | なにぶん | nanibun | 1189310 | learner | draft | **new** | Editorial review |
| N2-1131 | [生意気](entries/1378/1378790-namaiki.org) | なまいき | namaiki | 1378790 | learner | draft | **new** | Editorial review |
| N2-1132 | [倣う](entries/1599/1599680-narau.org) | ならう | narau | 1599680 | learner | draft | **new** | Editorial review |
| N2-1133 | [鳴らす](entries/1532/1532880-narasu.org) | ならす | narasu | 1532880 | learner | draft | **new** | Editorial review |
| N2-1134 | [生る](entries/1611/1611000-naru.org) | なる | naru | 1611000 | learner | draft | **new** | Editorial review |
| N2-1135 | [南極](entries/1460/1460180-nankyoku.org) | なんきょく | nankyoku | 1460180 | learner | draft | **new** | Editorial review |
| N2-1136 | [何となく](entries/1599/1599730-nantonaku.org) | なんとなく | nantonaku | 1599730 | learner | draft | **new** | Editorial review |
| N2-1137 | [何とも](entries/1188/1188690-nantomo.org) | なんとも | nantomo | 1188690 | learner | draft | **new** | Editorial review |
| N2-1138 | [ナンバー](entries/1090/1090860-nanbaa.org) | ナンバー | nanbaa | 1090860 | learner | draft | **new** | Editorial review |
| N2-1139 | [南米](entries/1460/1460570-nanbei.org) | なんべい | nanbei | 1460570 | learner | draft | **new** | Editorial review |
| N2-1140 | [南北](entries/1460/1460600-nanboku.org) | なんぼく | nanboku | 1460600 | learner | draft | **new** | Editorial review |
| N2-1141 | [煮える](entries/1322/1322490-nieru.org) | にえる | nieru | 1322490 | learner | draft | **new** | Editorial review |
| N2-1142 | [匂う](entries/1599/1599780-niou.org) | におう | niou | 1599780 | learner | draft | **new** | Editorial review |
| N2-1143 | [逃がす](entries/1450/1450320-nigasu.org) | にがす | nigasu | 1450320 | learner | draft | **new** | Editorial review |
| N2-1144 | [憎い](entries/1403/1403390-nikui.org) | にくい | nikui | 1403390 | learner | draft | **existing** | Editorial review |
| N2-1145 | [憎む](entries/1403/1403440-nikumu.org) | にくむ | nikumu | 1403440 | learner | draft | **new** | Editorial review |
| N2-1146 | [憎らしい](entries/1403/1403450-nikurashii.org) | にくらしい | nikurashii | 1403450 | learner | draft | **new** | Editorial review |
| N2-1147 | [ニコニコ](entries/1091/1091130-nikoniko.org) | ニコニコ | nikoniko | 1091130 | learner | draft | **new** | Editorial review |
| N2-1148 | [虹](entries/1463/1463740-niji.org) | にじ | niji | 1463740 | learner | draft | **new** | Editorial review |
| N2-1149 | [日時](entries/1464/1464110-nichiji.org) | にちじ | nichiji | 1464110 | learner | draft | **new** | Editorial review |
| N2-1150 | [日用品](entries/1464/1464910-nichiyouhin.org) | にちようひん | nichiyouhin | 1464910 | learner | draft | **new** | Editorial review |
| N2-1151 | [日課](entries/1463/1463860-nikka.org) | にっか | nikka | 1463860 | learner | draft | **new** | Editorial review |
| N2-1152 | [日程](entries/1464/1464300-nittei.org) | にってい | nittei | 1464300 | learner | draft | **new** | Editorial review |
| N2-1153 | [鈍い](entries/1582/1582430-nibui.org) | にぶい | nibui | 1582430 | learner | draft | **new** | Editorial review |
| N2-1154 | [入社](entries/1466/1466260-nyuusha.org) | にゅうしゃ | nyuusha | 1466260 | learner | draft | **new** | Editorial review |
| N2-1155 | [女房](entries/1345/1345420-nyoubou.org) | にょうぼう | nyoubou | 1345420 | learner | draft | **new** | Editorial review |
| N2-1156 | [睨む](entries/1569/1569880-niramu.org) | にらむ | niramu | 1569880 | learner | draft | **new** | Editorial review |
| N2-1157 | [煮る](entries/1322/1322540-niru.org) | にる | niru | 1322540 | learner | draft | **new** | Editorial review |
| N2-1158 | [俄](entries/1599/1599920-niwaka.org) | にわか | niwaka | 1599920 | learner | draft | **new** | Editorial review |
| N2-1159 | [縫う](entries/1517/1517700-nuu.org) | ぬう | nuu | 1517700 | learner | draft | **new** | Editorial review |
| N2-1160 | [滑る](entries/2016/2016150-numeru.org) | ぬめる | numeru | 2016150 | learner | draft | **new** | Editorial review |
| N2-1161 | [濡らす](entries/1467/1467610-nurasu.org) | ぬらす | nurasu | 1467610 | learner | draft | **new** | Editorial review |
| N2-1162 | [螺子](entries/1585/1585010-neji.org) | ネジ | neji | 1585010 | learner | draft | **new** | Editorial review |
| N2-1163 | [捩る](entries/1611/1611090-nejiru.org) | ねじる | nejiru | 1611090 | learner | draft | **new** | Editorial review |
| N2-1164 | [ネックレス](entries/1093/1093000-nekkuresu.org) | ネックレス | nekkuresu | 1093000 | learner | draft | **new** | Editorial review |
| N2-1165 | [熱する](entries/1467/1467730-nessuru.org) | ねっする | nessuru | 1467730 | learner | draft | **new** | Editorial review |
| N2-1166 | [寝巻き](entries/1360/1360040-nemaki.org) | ねまき | nemaki | 1360040 | learner | draft | **new** | Editorial review |
| N2-1167 | [狙い](entries/1396/1396550-nerai.org) | ねらい | nerai | 1396550 | learner | draft | **new** | Editorial review |
| N2-1168 | [狙う](entries/1396/1396590-nerau.org) | ねらう | nerau | 1396590 | learner | draft | **new** | Editorial review |
| N2-1169 | [年度](entries/1469/1469050-nendo.org) | ねんど | nendo | 1469050 | learner | draft | **new** | Editorial review |
| N2-1170 | [農産物](entries/1470/1470710-nousanbutsu.org) | のうさんぶつ | nousanbutsu | 1470710 | learner | draft | **new** | Editorial review |
| N2-1171 | [農村](entries/1470/1470730-nouson.org) | のうそん | nouson | 1470730 | learner | draft | **new** | Editorial review |
| N2-1172 | [濃度](entries/1469/1469970-noudo.org) | のうど | noudo | 1469970 | learner | draft | **new** | Editorial review |
| N2-1173 | [農薬](entries/1470/1470780-nouyaku.org) | のうやく | nouyaku | 1470780 | learner | draft | **new** | Editorial review |
| N2-1174 | [能率](entries/1470/1470330-nouritsu.org) | のうりつ | nouritsu | 1470330 | learner | draft | **new** | Editorial review |
| N2-1175 | [退ける](entries/1411/1411270-nokeru.org) | のける | nokeru | 1411270 | learner | draft | **new** | Editorial review |
| N2-1176 | [鋸](entries/1232/1232930-nokogiri.org) | のこぎり | nokogiri | 1232930 | learner | draft | **new** | Editorial review |
| N2-1177 | [残らず](entries/1611/1611130-nokorazu.org) | のこらず | nokorazu | 1611130 | learner | draft | **new** | Editorial review |
| N2-1178 | [覗く](entries/1470/1470840-nozoku.org) | のぞく | nozoku | 1470840 | learner | draft | **new** | Editorial review |
| N2-1179 | [上り](entries/1352/1352510-nobori.org) | のぼり | nobori | 1352510 | learner | draft | **new** | Editorial review |
| N2-1180 | [乗り換え](entries/1600/1600460-norikae.org) | のりかえ | norikae | 1600460 | learner | draft | **new** | Editorial review |
| N2-1181 | [載る](entries/2649/2649690-noru.org) | のる | noru | 2649690 | learner | draft | **new** | Editorial review |
| N2-1182 | [のろのろ](entries/1010/1010040-noronoro.org) | のろのろ | noronoro | 1010040 | learner | draft | **new** | Editorial review |
| N2-1183 | [呑気](entries/1600/1600560-nonki.org) | のんき | nonki | 1600560 | learner | draft | **new** | Editorial review |
| N2-1184 | [灰色](entries/1201/1201970-haiiro.org) | はいいろ | haiiro | 1201970 | learner | draft | **new** | Editorial review |
| N2-1185 | [俳句](entries/1471/1471900-haiku.org) | はいく | haiku | 1471900 | learner | draft | **new** | Editorial review |
| N2-1186 | [這う](entries/1474/1474200-hau.org) | はう | hau | 1474200 | learner | draft | **new** | Editorial review |
| N2-1187 | [生える](entries/1378/1378490-haeru.org) | はえる | haeru | 1378490 | learner | draft | **new** | Editorial review |
| N2-1188 | [秤](entries/1474/1474220-hakari.org) | はかり | hakari | 1474220 | learner | draft | **new** | Editorial review |
| N2-1189 | [剥がす](entries/1600/1600670-hagasu.org) | はがす | hagasu | 1600670 | learner | draft | **new** | Editorial review |
| N2-1190 | [はきはき](entries/1010/1010090-hakihaki.org) | はきはき | hakihaki | 1010090 | learner | draft | **new** | Editorial review |
| N2-1191 | [掃く](entries/1399/1399760-haku.org) | はく | haku | 1399760 | learner | draft | **new** | Editorial review |
| N2-1192 | [歯車](entries/1313/1313350-haguruma.org) | はぐるま | haguruma | 1313350 | learner | draft | **new** | Editorial review |
| N2-1193 | [挟まる](entries/1236/1236840-hasamaru.org) | はさまる | hasamaru | 1236840 | learner | draft | **new** | Editorial review |
| N2-1194 | [挟む](entries/1600/1600740-hasamu.org) | はさむ | hasamu | 1600740 | learner | draft | **new** | Editorial review |
| N2-1195 | [梯子](entries/1436/1436480-hashigo.org) | はしご | hashigo | 1436480 | learner | draft | **new** | Editorial review |
| N2-1196 | [初めに](entries/1307/1307520-hajimeni.org) | はじめに | hajimeni | 1307520 | learner | draft | **new** | Editorial review |
| N2-1197 | [初めまして](entries/1625/1625780-hajimemashite.org) | はじめまして | hajimemashite | 1625780 | learner | draft | **new** | Editorial review |
| N2-1198 | [斜](entries/2085/2085880-hasu.org) | はす | hasu | 2085880 | learner | draft | **new** | Editorial review |
| N2-1199 | [外れる](entries/1203/1203310-hazureru.org) | はずれる | hazureru | 1203310 | learner | draft | **new** | Editorial review |
| N2-1200 | [果たして](entries/1600/1600780-hatashite.org) | はたして | hatashite | 1600780 | learner | draft | **new** | Editorial review |
| N2-1201 | [肌着](entries/1476/1476500-hadagi.org) | はだぎ | hadagi | 1476500 | learner | draft | **new** | Editorial review |
| N2-1202 | [鉢](entries/1477/1477090-hachi.org) | はち | hachi | 1477090 | learner | draft | **new** | Editorial review |
| N2-1203 | [発揮](entries/1477/1477250-hakki.org) | はっき | hakki | 1477250 | learner | draft | **new** | Editorial review |
| N2-1204 | [発射](entries/1477/1477490-hassha.org) | はっしゃ | hassha | 1477490 | learner | draft | **new** | Editorial review |
| N2-1205 | [発想](entries/1477/1477660-hassou.org) | はっそう | hassou | 1477660 | learner | draft | **new** | Editorial review |
| N2-1206 | [発電](entries/1477/1477750-hatsuden.org) | はつでん | hatsuden | 1477750 | learner | draft | **new** | Editorial review |
| N2-1207 | [発売](entries/1477/1477810-hatsubai.org) | はつばい | hatsubai | 1477810 | learner | draft | **new** | Editorial review |
| N2-1208 | [派手](entries/1471/1471140-hade.org) | はで | hade | 1471140 | learner | draft | **new** | Editorial review |
| N2-1209 | [話し合い](entries/1600/1600910-hanashiai.org) | はなしあい | hanashiai | 1600910 | learner | draft | **new** | Editorial review |
| N2-1210 | [話しかける](entries/1562/1562300-hanashikakeru.org) | はなしかける | hanashikakeru | 1562300 | learner | draft | **new** | Editorial review |
| N2-1211 | [話し中](entries/1600/1600920-hanashichuu.org) | はなしちゅう | hanashichuu | 1600920 | learner | draft | **new** | Editorial review |
| N2-1212 | [花火](entries/1194/1194580-hanabi.org) | はなび | hanabi | 1194580 | learner | draft | **new** | Editorial review |
| N2-1213 | [花嫁](entries/1194/1194570-hanayome.org) | はなよめ | hanayome | 1194570 | learner | draft | **new** | Editorial review |
| N2-1214 | [放れる](entries/1516/1516540-hanareru.org) | はなれる | hanareru | 1516540 | learner | draft | **new** | Editorial review |
| N2-1215 | [破片](entries/1471/1471420-hahen.org) | はへん | hahen | 1471420 | learner | draft | **new** | Editorial review |
| N2-1216 | [歯磨き](entries/1601/1601040-hamigaki.org) | はみがき | hamigaki | 1601040 | learner | draft | **new** | Editorial review |
| N2-1217 | [嵌める](entries/1566/1566420-hameru.org) | はめる | hameru | 1566420 | learner | draft | **new** | Editorial review |
| N2-1218 | [流行る](entries/1552/1552310-hayaru.org) | はやる | hayaru | 1552310 | learner | draft | **new** | Editorial review |
| N2-1219 | [払い込む](entries/1501/1501580-haraikomu.org) | はらいこむ | haraikomu | 1501580 | learner | draft | **new** | Editorial review |
| N2-1220 | [払い戻す](entries/1501/1501610-haraimodosu.org) | はらいもどす | haraimodosu | 1501610 | learner | draft | **new** | Editorial review |
| N2-1221 | [針金](entries/1366/1366250-harigane.org) | はりがね | harigane | 1366250 | learner | draft | **new** | Editorial review |
| N2-1222 | [張り切る](entries/1427/1427870-harikiru.org) | はりきる | harikiru | 1427870 | learner | draft | **new** | Editorial review |
| N2-1223 | [反映](entries/1601/1601160-hanei.org) | はんえい | hanei | 1601160 | learner | draft | **new** | Editorial review |
| N2-1224 | [半径](entries/1479/1479230-hankei.org) | はんけい | hankei | 1479230 | learner | draft | **new** | Editorial review |
| N2-1225 | [判子](entries/1478/1478550-hanko.org) | はんこ | hanko | 1478550 | learner | draft | **new** | Editorial review |
| N2-1226 | [判事](entries/1478/1478560-hanji.org) | はんじ | hanji | 1478560 | learner | draft | **new** | Editorial review |
| N2-1227 | [反省](entries/1480/1480540-hansei.org) | はんせい | hansei | 1480540 | learner | draft | **new** | Editorial review |
| N2-1228 | [ハンドル](entries/1096/1096830-handoru.org) | ハンドル | handoru | 1096830 | learner | draft | **new** | Editorial review |
| N2-1229 | [バイバイ](entries/1983/1983760-baibai.org) | バイバイ | baibai | 1983760 | learner | draft | **new** | Editorial review |
| N2-1230 | [売買](entries/1474/1474050-baibai.org) | ばいばい | baibai | 1474050 | learner | draft | **new** | Editorial review |
| N2-1231 | [馬鹿らしい](entries/1612/1612910-bakarashii.org) | ばからしい | bakarashii | 1612910 | learner | draft | **new** | Editorial review |
| N2-1232 | [馬穴](entries/1098/1098340-baketsu.org) | バケツ | baketsu | 1098340 | learner | draft | **new** | Editorial review |
| N2-1233 | [バッグ](entries/1099/1099100-baggu.org) | バック | baggu | 1099100 | learner | draft | **existing** | Editorial review |
| N2-1234 | [発条](entries/1099/1099490-bane.org) | ばね | bane | 1099490 | learner | draft | **new** | Editorial review |
| N2-1235 | [バランス](entries/1099/1099690-baransu.org) | バランス | baransu | 1099690 | learner | draft | **new** | Editorial review |
| N2-1236 | [万歳](entries/1601/1601350-banzai.org) | ばんざい | banzai | 1601350 | learner | draft | **new** | Editorial review |
| N2-1237 | [番地](entries/1482/1482360-banchi.org) | ばんち | banchi | 1482360 | learner | draft | **new** | Editorial review |
| N2-1238 | [バンド](entries/1100/1100240-bando.org) | バンド | bando | 1100240 | learner | draft | **new** | Editorial review |
| N2-1239 | [パターン](entries/1101/1101600-pataan.org) | パターン | pataan | 1101600 | learner | draft | **new** | Editorial review |
| N2-1240 | [パンツ](entries/1103/1103270-pantsu.org) | パンツ | pantsu | 1103270 | learner | draft | **new** | Editorial review |
| N2-1241 | [日当たり](entries/1601/1601420-hiatari.org) | ひあたり | hiatari | 1601420 | learner | draft | **new** | Editorial review |
| N2-1242 | [比較的](entries/1483/1483600-hikakuteki.org) | ひかくてき | hikakuteki | 1483600 | learner | draft | **new** | Editorial review |
| N2-1243 | [日陰](entries/1463/1463840-hikage.org) | ひかげ | hikage | 1463840 | learner | draft | **new** | Editorial review |
| N2-1244 | [引き受ける](entries/1601/1601520-hikiukeru.org) | ひきうける | hikiukeru | 1601520 | learner | draft | **new** | Editorial review |
| N2-1245 | [引き返す](entries/1169/1169140-hikikaesu.org) | ひきかえす | hikikaesu | 1169140 | learner | draft | **new** | Editorial review |
| N2-1246 | [引き算](entries/1601/1601610-hikizan.org) | ひきざん | hikizan | 1601610 | learner | draft | **new** | Editorial review |
| N2-1247 | [引き止める](entries/1601/1601750-hikitomeru.org) | ひきとめる | hikitomeru | 1601750 | learner | draft | **new** | Editorial review |
| N2-1248 | [引き分け](entries/1169/1169120-hikiwake.org) | ひきわけ | hikiwake | 1169120 | learner | draft | **new** | Editorial review |
| N2-1249 | [日差し](entries/1601/1601830-hizashi.org) | ひざし | hizashi | 1601830 | learner | draft | **new** | Editorial review |
| N2-1250 | [肘](entries/1487/1487380-hiji.org) | ひじ | hiji | 1487380 | learner | draft | **new** | Editorial review |
| N2-1251 | [引っかかる](entries/1169/1169350-hikkakaru.org) | ひっかかる | hikkakaru | 1169350 | learner | draft | **new** | Editorial review |
| N2-1252 | [ひっくり返す](entries/1601/1601870-hikkurikaesu.org) | ひっくりかえす | hikkurikaesu | 1601870 | learner | draft | **new** | Editorial review |
| N2-1253 | [ひっくり返る](entries/1169/1169320-hikkurikaeru.org) | ひっくりかえる | hikkurikaeru | 1169320 | learner | draft | **new** | Editorial review |
| N2-1254 | [引っ越し](entries/1601/1601880-hikkoshi.org) | ひっこし | hikkoshi | 1601880 | learner | draft | **new** | Editorial review |
| N2-1255 | [引っ込む](entries/1169/1169390-hikkomu.org) | ひっこむ | hikkomu | 1169390 | learner | draft | **new** | Editorial review |
| N2-1256 | [筆者](entries/1487/1487830-hissha.org) | ひっしゃ | hissha | 1487830 | learner | draft | **new** | Editorial review |
| N2-1257 | [必需品](entries/1487/1487500-hitsujuhin.org) | ひつじゅひん | hitsujuhin | 1487500 | learner | draft | **new** | Editorial review |
| N2-1258 | [人差し指](entries/1601/1601940-hitosashiyubi.org) | ひとさしゆび | hitosashiyubi | 1601940 | learner | draft | **new** | Editorial review |
| N2-1259 | [一通り](entries/1164/1164910-hitotoori.org) | ひととおり | hitotoori | 1164910 | learner | draft | **new** | Editorial review |
| N2-1260 | [人通り](entries/1368/1368820-hitodoori.org) | ひとどおり | hitodoori | 1368820 | learner | draft | **new** | Editorial review |
| N2-1261 | [一先ず](entries/1601/1601990-hitomazu.org) | ひとまず | hitomazu | 1601990 | learner | draft | **new** | Editorial review |
| N2-1262 | [瞳](entries/1453/1453900-hitomi.org) | ひとみ | hitomi | 1453900 | learner | draft | **new** | Editorial review |
| N2-1263 | [一休み](entries/1161/1161830-hitoyasumi.org) | ひとやすみ | hitoyasumi | 1161830 | learner | draft | **new** | Editorial review |
| N2-1264 | [独り言](entries/1455/1455670-hitorigoto.org) | ひとりごと | hitorigoto | 1455670 | learner | draft | **new** | Editorial review |
| N2-1265 | [独りでに](entries/1455/1455660-hitorideni.org) | ひとりでに | hitorideni | 1455660 | learner | draft | **new** | Editorial review |
| N2-1266 | [皮肉](entries/1483/1483900-hiniku.org) | ひにく | hiniku | 1483900 | learner | draft | **new** | Editorial review |
| N2-1267 | [日にち](entries/1611/1611370-hinichi.org) | ひにち | hinichi | 1611370 | learner | draft | **new** | Editorial review |
| N2-1268 | [捻る](entries/1469/1469530-hineru.org) | ひねる | hineru | 1469530 | learner | draft | **new** | Editorial review |
| N2-1269 | [日の入り](entries/1463/1463800-hinoiri.org) | ひのいり | hinoiri | 1463800 | learner | draft | **new** | Editorial review |
| N2-1270 | [日の出](entries/1463/1463790-hinode.org) | ひので | hinode | 1463790 | learner | draft | **new** | Editorial review |
| N2-1271 | [響き](entries/1602/1602130-hibiki.org) | ひびき | hibiki | 1602130 | learner | draft | **new** | Editorial review |
| N2-1272 | [響く](entries/1238/1238610-hibiku.org) | ひびく | hibiku | 1238610 | learner | draft | **new** | Editorial review |
| N2-1273 | [皮膚](entries/1483/1483920-hifu.org) | ひふ | hifu | 1483920 | learner | draft | **new** | Editorial review |
| N2-1274 | [百科事典](entries/1602/1602190-hyakkajiten.org) | ひゃっかじてん | hyakkajiten | 1602190 | learner | draft | **new** | Editorial review |
| N2-1275 | [冷やす](entries/1556/1556770-hiyasu.org) | ひやす | hiyasu | 1556770 | learner | draft | **new** | Editorial review |
| N2-1276 | [表紙](entries/1489/1489600-hyoushi.org) | ひょうし | hyoushi | 1489600 | learner | draft | **new** | Editorial review |
| N2-1277 | [標識](entries/1488/1488700-hyoushiki.org) | ひょうしき | hyoushiki | 1488700 | learner | draft | **new** | Editorial review |
| N2-1278 | [標準](entries/1488/1488710-hyoujun.org) | ひょうじゅん | hyoujun | 1488710 | learner | draft | **new** | Editorial review |
| N2-1279 | [標本](entries/1488/1488820-hyouhon.org) | ひょうほん | hyouhon | 1488820 | learner | draft | **new** | Editorial review |
| N2-1280 | [評論](entries/1490/1490080-hyouron.org) | ひょうろん | hyouron | 1490080 | learner | draft | **new** | Editorial review |
| N2-1281 | [平仮名](entries/1507/1507090-hiragana.org) | ひらがな | hiragana | 1507090 | learner | draft | **new** | Editorial review |
| N2-1282 | [昼寝](entries/1426/1426370-hirune.org) | ひるね | hirune | 1426370 | learner | draft | **new** | Editorial review |
| N2-1283 | [広げる](entries/1602/1602370-hirogeru.org) | ひろげる | hirogeru | 1602370 | learner | draft | **new** | Editorial review |
| N2-1284 | [広さ](entries/1278/1278440-hirosa.org) | ひろさ | hirosa | 1278440 | learner | draft | **new** | Editorial review |
| N2-1285 | [広場](entries/1278/1278590-hiroba.org) | ひろば | hiroba | 1278590 | learner | draft | **new** | Editorial review |
| N2-1286 | [広々](entries/1602/1602380-hirobiro.org) | ひろびろ | hirobiro | 1602380 | learner | draft | **new** | Editorial review |
| N2-1287 | [広める](entries/1278/1278460-hiromeru.org) | ひろめる | hiromeru | 1278460 | learner | draft | **new** | Editorial review |
| N2-1288 | [ビタミン](entries/1105/1105160-bitamin.org) | ビタミン | bitamin | 1105160 | learner | draft | **new** | Editorial review |
| N2-1289 | [ビニール](entries/1105/1105580-bini-ru.org) | ビニール | bini-ru | 1105580 | learner | draft | **new** | Editorial review |
| N2-1290 | [美容](entries/1486/1486670-biyou.org) | びよう | biyou | 1486670 | learner | draft | **new** | Editorial review |
| N2-1291 | [ビルディング](entries/1106/1106040-birudingu.org) | ビルディング | birudingu | 1106040 | learner | draft | **new** | Editorial review |
| N2-1292 | [便箋](entries/1512/1512640-binsen.org) | びんせん | binsen | 1512640 | learner | draft | **new** | Editorial review |
| N2-1293 | [瓶詰め](entries/1491/1491130-binzume.org) | びんづめ | binzume | 1491130 | learner | draft | **new** | Editorial review |
| N2-1294 | [ピカピカ](entries/1010/1010830-pikapika.org) | ピカピカ | pikapika | 1010830 | learner | draft | **new** | Editorial review |
| N2-1295 | [ピストル](entries/1106/1106660-pisutoru.org) | ピストル | pisutoru | 1106660 | learner | draft | **new** | Editorial review |
| N2-1296 | [ピンク](entries/1107/1107140-pinku.org) | ピンク | pinku | 1107140 | learner | draft | **new** | Editorial review |
| N2-1297 | [ファスナー](entries/1108/1108160-fasunaa.org) | ファスナー | fasunaa | 1108160 | learner | draft | **new** | Editorial review |
| N2-1298 | [不運](entries/1491/1491290-fuun.org) | ふうん | fuun | 1491290 | learner | draft | **new** | Editorial review |
| N2-1299 | [深まる](entries/1362/1362660-fukamaru.org) | ふかまる | fukamaru | 1362660 | learner | draft | **new** | Editorial review |
| N2-1300 | [不規則](entries/1491/1491840-fukisoku.org) | ふきそく | fukisoku | 1491840 | learner | draft | **new** | Editorial review |
| N2-1301 | [普及](entries/1497/1497110-fukyuu.org) | ふきゅう | fukyuu | 1497110 | learner | draft | **new** | Editorial review |
| N2-1302 | [付近](entries/1496/1496240-fukin.org) | ふきん | fukin | 1496240 | learner | draft | **new** | Editorial review |
| N2-1303 | [拭く](entries/1357/1357240-fuku.org) | ふく | fuku | 1357240 | learner | draft | **new** | Editorial review |
| N2-1304 | [副詞](entries/1500/1500440-fukushi.org) | ふくし | fukushi | 1500440 | learner | draft | **new** | Editorial review |
| N2-1305 | [複写](entries/1501/1501390-fukusha.org) | ふくしゃ | fukusha | 1501390 | learner | draft | **new** | Editorial review |
| N2-1306 | [複数](entries/1501/1501400-fukusuu.org) | ふくすう | fukusuu | 1501400 | learner | draft | **new** | Editorial review |
| N2-1307 | [含める](entries/1216/1216890-fukumeru.org) | ふくめる | fukumeru | 1216890 | learner | draft | **new** | Editorial review |
| N2-1308 | [膨らます](entries/1519/1519970-fukuramasu.org) | ふくらます | fukuramasu | 1519970 | learner | draft | **new** | Editorial review |
| N2-1309 | [膨らむ](entries/1519/1519990-fukuramu.org) | ふくらむ | fukuramu | 1519990 | learner | draft | **new** | Editorial review |
| N2-1310 | [更ける](entries/1279/1279290-fukeru.org) | ふける | fukeru | 1279290 | learner | draft | **new** | Editorial review |
| N2-1311 | [符号](entries/1497/1497710-fugou.org) | ふごう | fugou | 1497710 | learner | draft | **new** | Editorial review |
| N2-1312 | [夫妻](entries/1496/1496520-fusai.org) | ふさい | fusai | 1496520 | learner | draft | **new** | Editorial review |
| N2-1313 | [塞がる](entries/1602/1602570-fusagaru.org) | ふさがる | fusagaru | 1602570 | learner | draft | **new** | Editorial review |
| N2-1314 | [塞ぐ](entries/1602/1602590-fusagu.org) | ふさぐ | fusagu | 1602590 | learner | draft | **new** | Editorial review |
| N2-1315 | [巫山戯る](entries/1566/1566450-fuzakeru.org) | ふざける | fuzakeru | 1566450 | learner | draft | **new** | Editorial review |
| N2-1316 | [襖](entries/1181/1181720-fusuma.org) | ふすま | fusuma | 1181720 | learner | draft | **new** | Editorial review |
| N2-1317 | [付属](entries/1602/1602700-fuzoku.org) | ふぞく | fuzoku | 1602700 | learner | draft | **new** | Editorial review |
| N2-1318 | [蓋](entries/1204/1204540-futa.org) | ふた | futa | 1204540 | learner | draft | **new** | Editorial review |
| N2-1319 | [不通](entries/1493/1493860-futsuu.org) | ふつう | futsuu | 1493860 | learner | draft | **new** | Editorial review |
| N2-1320 | [船便](entries/1392/1392100-funabin.org) | ふなびん | funabin | 1392100 | learner | draft | **new** | Editorial review |
| N2-1321 | [吹雪](entries/1370/1370780-fubuki.org) | ふぶき | fubuki | 1370780 | learner | draft | **new** | Editorial review |
| N2-1322 | [父母](entries/1497/1497690-fubo.org) | ふぼ | fubo | 1497690 | learner | draft | **new** | Editorial review |
| N2-1323 | [踏切](entries/1602/1602840-fumikiri.org) | ふみきり | fumikiri | 1602840 | learner | draft | **new** | Editorial review |
| N2-1324 | [麓](entries/1611/1611440-fumoto.org) | ふもと | fumoto | 1611440 | learner | draft | **new** | Editorial review |
| N2-1325 | [増やす](entries/1602/1602880-fuyasu.org) | ふやす | fuyasu | 1602880 | learner | draft | **new** | Editorial review |
| N2-1326 | [フライパン](entries/1111/1111160-furaipan.org) | フライパン | furaipan | 1111160 | learner | draft | **new** | Editorial review |
| N2-1327 | [振り仮名](entries/1361/1361150-furigana.org) | ふりがな | furigana | 1361150 | learner | draft | **new** | Editorial review |
| N2-1328 | [フリー](entries/1111/1111640-furi-.org) | フリー | furi- | 1111640 | learner | draft | **new** | Editorial review |
| N2-1329 | [振舞う](entries/1602/1603090-furumau.org) | ふるまう | furumau | 1603090 | learner | draft | **new** | Editorial review |
| N2-1330 | [風呂敷](entries/1500/1500150-furoshiki.org) | ふろしき | furoshiki | 1500150 | learner | draft | **new** | Editorial review |
| N2-1331 | [ふわふわ](entries/1113/1113060-fuwafuwa.org) | ふわふわ | fuwafuwa | 1113060 | learner | draft | **new** | Editorial review |
| N2-1332 | [噴火](entries/1504/1504560-funka.org) | ふんか | funka | 1504560 | learner | draft | **new** | Editorial review |
| N2-1333 | [噴水](entries/1504/1504610-funsui.org) | ふんすい | funsui | 1504610 | learner | draft | **new** | Editorial review |
| N2-1334 | [無沙汰](entries/1672/1672130-busata.org) | ぶさた | busata | 1672130 | learner | draft | **new** | Editorial review |
| N2-1335 | [武士](entries/1583/1583680-bushi.org) | ぶし | bushi | 1583680 | learner | draft | **new** | Editorial review |
| N2-1336 | [部首](entries/1499/1499400-bushu.org) | ぶしゅ | bushu | 1499400 | learner | draft | **new** | Editorial review |
| N2-1337 | [物騒](entries/1502/1502640-bussou.org) | ぶっそう | bussou | 1502640 | learner | draft | **new** | Editorial review |
| N2-1338 | [ぶつかる](entries/1011/1011180-butsukaru.org) | ぶつかる | butsukaru | 1011180 | learner | draft | **new** | Editorial review |
| N2-1339 | [打付ける](entries/2742/2742080-butsukeru.org) | ぶつける | butsukeru | 2742080 | learner | draft | **new** | Editorial review |
| N2-1340 | [ぶつぶつ](entries/1011/1011200-butsubutsu.org) | ぶつぶつ | butsubutsu | 1011200 | learner | draft | **new** | Editorial review |
| N2-1341 | [部品](entries/1499/1499480-buhin.org) | ぶひん | buhin | 1499480 | learner | draft | **new** | Editorial review |
| N2-1342 | [ブラウス](entries/1113/1113650-burausu.org) | ブラウス | burausu | 1113650 | learner | draft | **new** | Editorial review |
| N2-1343 | [ぶら下げる](entries/1011/1011250-burasageru.org) | ぶらさげる | burasageru | 1011250 | learner | draft | **new** | Editorial review |
| N2-1344 | [刷子](entries/1579/1579310-burashi.org) | ブラシ | burashi | 1579310 | learner | draft | **new** | Editorial review |
| N2-1345 | [ブローチ](entries/1114/1114910-buro-chi.org) | ブローチ | buro-chi | 1114910 | learner | draft | **new** | Editorial review |
| N2-1346 | [分解](entries/1503/1503210-bunkai.org) | ぶんかい | bunkai | 1503210 | learner | draft | **new** | Editorial review |
| N2-1347 | [文献](entries/1505/1505330-bunken.org) | ぶんけん | bunken | 1505330 | learner | draft | **new** | Editorial review |
| N2-1348 | [文芸](entries/1505/1505290-bungei.org) | ぶんげい | bungei | 1505290 | learner | draft | **new** | Editorial review |
| N2-1349 | [分数](entries/1503/1503860-bunsuu.org) | ぶんすう | bunsuu | 1503860 | learner | draft | **new** | Editorial review |
| N2-1350 | [文体](entries/1505/1505510-buntai.org) | ぶんたい | buntai | 1505510 | learner | draft | **new** | Editorial review |
| N2-1351 | [分布](entries/1504/1504160-bunpu.org) | ぶんぷ | bunpu | 1504160 | learner | draft | **new** | Editorial review |
| N2-1352 | [文房具](entries/1505/1505620-bunbougu.org) | ぶんぼうぐ | bunbougu | 1505620 | learner | draft | **new** | Editorial review |
| N2-1353 | [文脈](entries/1505/1505630-bunmyaku.org) | ぶんみゃく | bunmyaku | 1505630 | learner | draft | **new** | Editorial review |
| N2-1354 | [分量](entries/1504/1504430-bunryou.org) | ぶんりょう | bunryou | 1504430 | learner | draft | **new** | Editorial review |
| N2-1355 | [分類](entries/1504/1504460-bunrui.org) | ぶんるい | bunrui | 1504460 | learner | draft | **new** | Editorial review |
| N2-1356 | [プラスチック](entries/1115/1115670-purasuchikku.org) | プラスチック | purasuchikku | 1115670 | learner | draft | **new** | Editorial review |
| N2-1357 | [プラットホーム](entries/1115/1115820-purattoho-mu.org) | プラットホーム | purattoho-mu | 1115820 | learner | draft | **new** | Editorial review |
| N2-1358 | [プリント](entries/1116/1116300-purinto.org) | プリント | purinto | 1116300 | learner | draft | **new** | Editorial review |
| N2-1359 | [プログラム](entries/1117/1117080-puroguramu.org) | プログラム | puroguramu | 1117080 | learner | draft | **new** | Editorial review |
| N2-1360 | [閉会](entries/1508/1508600-heikai.org) | へいかい | heikai | 1508600 | learner | draft | **new** | Editorial review |
| N2-1361 | [平気](entries/1507/1507180-heiki.org) | へいき | heiki | 1507180 | learner | draft | **new** | Editorial review |
| N2-1362 | [並行](entries/1508/1508480-heikou.org) | へいこう | heikou | 1508480 | learner | draft | **new** | Editorial review |
| N2-1363 | [平日](entries/1507/1507720-heijitsu.org) | へいじつ | heijitsu | 1507720 | learner | draft | **new** | Editorial review |
| N2-1364 | [兵隊](entries/1506/1506590-heitai.org) | へいたい | heitai | 1506590 | learner | draft | **new** | Editorial review |
| N2-1365 | [平凡](entries/1507/1507910-heibon.org) | へいぼん | heibon | 1507910 | learner | draft | **new** | Editorial review |
| N2-1366 | [平野](entries/1508/1508030-heiya.org) | へいや | heiya | 1508030 | learner | draft | **new** | Editorial review |
| N2-1367 | [凹む](entries/1179/1179200-hekomu.org) | へこむ | hekomu | 1179200 | learner | draft | **new** | Editorial review |
| N2-1368 | [臍](entries/1571/1571170-heso.org) | へそ | heso | 1571170 | learner | draft | **new** | Editorial review |
| N2-1369 | [隔てる](entries/1206/1206360-hedateru.org) | へだてる | hedateru | 1206360 | learner | draft | **new** | Editorial review |
| N2-1370 | [ヘリコプター](entries/1118/1118780-herikoputa-.org) | ヘリコプター | herikoputa- | 1118780 | learner | draft | **new** | Editorial review |
| N2-1371 | [編集](entries/1603/1603240-henshuu.org) | へんしゅう | henshuu | 1603240 | learner | draft | **new** | Editorial review |
| N2-1372 | [別荘](entries/1509/1509970-bessou.org) | べっそう | bessou | 1509970 | learner | draft | **new** | Editorial review |
| N2-1373 | [別々](entries/1603/1603290-betsubetsu.org) | べつべつ | betsubetsu | 1603290 | learner | draft | **new** | Editorial review |
| N2-1374 | [ベテラン](entries/1119/1119700-beteran.org) | ベテラン | beteran | 1119700 | learner | draft | **new** | Editorial review |
| N2-1375 | [便所](entries/1512/1512520-benjo.org) | べんじょ | benjo | 1512520 | learner | draft | **new** | Editorial review |
| N2-1376 | [ペンチ](entries/1121/1121520-penchi.org) | ペンチ | penchi | 1121520 | learner | draft | **new** | Editorial review |
| N2-1377 | [方角](entries/1516/1516950-hougaku.org) | ほうがく | hougaku | 1516950 | learner | draft | **new** | Editorial review |
| N2-1378 | [箒](entries/1566/1566500-houki.org) | ほうき | houki | 1566500 | learner | draft | **new** | Editorial review |
| N2-1379 | [方言](entries/1516/1516980-hougen.org) | ほうげん | hougen | 1516980 | learner | draft | **new** | Editorial review |
| N2-1380 | [方針](entries/1517/1517040-houshin.org) | ほうしん | houshin | 1517040 | learner | draft | **new** | Editorial review |
| N2-1381 | [包装](entries/1515/1515510-housou.org) | ほうそう | housou | 1515510 | learner | draft | **new** | Editorial review |
| N2-1382 | [法則](entries/1517/1517380-housoku.org) | ほうそく | housoku | 1517380 | learner | draft | **new** | Editorial review |
| N2-1383 | [包帯](entries/1603/1603360-houtai.org) | ほうたい | houtai | 1603360 | learner | draft | **new** | Editorial review |
| N2-1384 | [包丁](entries/1515/1515530-houchou.org) | ほうちょう | houchou | 1515530 | learner | draft | **new** | Editorial review |
| N2-1385 | [方程式](entries/1517/1517060-houteishiki.org) | ほうていしき | houteishiki | 1517060 | learner | draft | **new** | Editorial review |
| N2-1386 | [方面](entries/1517/1517100-houmen.org) | ほうめん | houmen | 1517100 | learner | draft | **new** | Editorial review |
| N2-1387 | [放る](entries/1516/1516530-houru.org) | ほうる | houru | 1516530 | learner | draft | **new** | Editorial review |
| N2-1388 | [朗らか](entries/1560/1560710-hogaraka.org) | ほがらか | hogaraka | 1560710 | learner | draft | **new** | Editorial review |
| N2-1389 | [保健](entries/1513/1513410-hoken.org) | ほけん | hoken | 1513410 | learner | draft | **new** | Editorial review |
| N2-1390 | [干す](entries/1603/1603510-hosu.org) | ほす | hosu | 1603510 | learner | draft | **new** | Editorial review |
| N2-1391 | [北極](entries/1520/1520890-hokkyoku.org) | ほっきょく | hokkyoku | 1520890 | learner | draft | **new** | Editorial review |
| N2-1392 | [解く](entries/1198/1198900-hodoku.org) | ほどく | hodoku | 1198900 | learner | draft | **new** | Editorial review |
| N2-1393 | [彫る](entries/1427/1427950-horu.org) | ほる | horu | 1427950 | learner | draft | **new** | Editorial review |
| N2-1394 | [掘る](entries/1246/1246690-horu.org) | ほる | horu | 1246690 | learner | draft | **new** | Editorial review |
| N2-1395 | [本来](entries/1523/1523270-honrai.org) | ほんらい | honrai | 1523270 | learner | draft | **new** | Editorial review |
| N2-1396 | [望遠鏡](entries/1519/1519650-bouenkyou.org) | ぼうえんきょう | bouenkyou | 1519650 | learner | draft | **new** | Editorial review |
| N2-1397 | [坊さん](entries/1519/1519050-bousan.org) | ぼうさん | bousan | 1519050 | learner | draft | **new** | Editorial review |
| N2-1398 | [防止](entries/1520/1520380-boushi.org) | ぼうし | boushi | 1520380 | learner | draft | **new** | Editorial review |
| N2-1399 | [膨大](entries/1603/1603660-boudai.org) | ぼうだい | boudai | 1603660 | learner | draft | **new** | Editorial review |
| N2-1400 | [防犯](entries/1520/1520570-bouhan.org) | ぼうはん | bouhan | 1520570 | learner | draft | **new** | Editorial review |
| N2-1401 | [坊や](entries/1519/1519060-bouya.org) | ぼうや | bouya | 1519060 | learner | draft | **new** | Editorial review |
| N2-1402 | [牧場](entries/1584/1584250-bokujou.org) | ぼくじょう | bokujou | 1584250 | learner | draft | **new** | Editorial review |
| N2-1403 | [牧畜](entries/1521/1521820-bokuchiku.org) | ぼくちく | bokuchiku | 1521820 | learner | draft | **new** | Editorial review |
| N2-1404 | [募集](entries/1514/1514830-boshuu.org) | ぼしゅう | boshuu | 1514830 | learner | draft | **new** | Editorial review |
| N2-1405 | [襤褸](entries/1572/1572500-boro.org) | ぼろ | boro | 1572500 | learner | draft | **new** | Editorial review |
| N2-1406 | [盆地](entries/1523/1523760-bonchi.org) | ぼんち | bonchi | 1523760 | learner | draft | **new** | Editorial review |
| N2-1407 | [ボーナス](entries/1123/1123520-boonasu.org) | ボーナス | boonasu | 1123520 | learner | draft | **new** | Editorial review |
| N2-1408 | [ポスター](entries/1125/1125110-posutaa.org) | ポスター | posutaa | 1125110 | learner | draft | **new** | Editorial review |
| N2-1409 | [まあまあ](entries/1012/1012070-maamaa.org) | まあまあ | maamaa | 1012070 | learner | draft | **new** | Editorial review |
| N2-1410 | [枚数](entries/1524/1524630-maisuu.org) | まいすう | maisuu | 1524630 | learner | draft | **new** | Editorial review |
| N2-1411 | [毎度](entries/1524/1524710-maido.org) | まいど | maido | 1524710 | learner | draft | **new** | Editorial review |
| N2-1412 | [マイナス](entries/1126/1126980-mainasu.org) | マイナス | mainasu | 1126980 | learner | draft | **new** | Editorial review |
| N2-1413 | [巻く](entries/1211/1211200-maku.org) | まく | maku | 1211200 | learner | draft | **new** | Editorial review |
| N2-1414 | [撒く](entries/1303/1303400-maku.org) | まく | maku | 1303400 | learner | draft | **new** | Editorial review |
| N2-1415 | [枕](entries/1524/1524860-makura.org) | まくら | makura | 1524860 | learner | draft | **new** | Editorial review |
| N2-1416 | [曲げる](entries/1239/1239740-mageru.org) | まげる | mageru | 1239740 | learner | draft | **new** | Editorial review |
| N2-1417 | [まごまご](entries/1012/1012110-magomago.org) | まごまご | magomago | 1012110 | learner | draft | **new** | Editorial review |
| N2-1418 | [摩擦](entries/1523/1523830-masatsu.org) | まさつ | masatsu | 1523830 | learner | draft | **new** | Editorial review |
| N2-1419 | [混ざる](entries/1603/1603920-mazaru.org) | まざる | mazaru | 1603920 | learner | draft | **new** | Editorial review |
| N2-1420 | [混じる](entries/1603/1603930-majiru.org) | まじる | majiru | 1603930 | learner | draft | **new** | Editorial review |
| N2-1421 | [マスク](entries/1127/1127870-masuku.org) | マスク | masuku | 1127870 | learner | draft | **new** | Editorial review |
| N2-1422 | [交ぜる](entries/1290/1290310-mazeru.org) | まぜる | mazeru | 1290310 | learner | draft | **new** | Editorial review |
| N2-1424 | [跨ぐ](entries/1267/1267830-matagu.org) | またぐ | matagu | 1267830 | learner | draft | **new** | Editorial review |
| N2-1425 | [待合室](entries/1410/1410630-machiaishitsu.org) | まちあいしつ | machiaishitsu | 1410630 | learner | draft | **new** | Editorial review |
| N2-1426 | [待ち合わせる](entries/1410/1410520-machiawaseru.org) | まちあわせる | machiawaseru | 1410520 | learner | draft | **new** | Editorial review |
| N2-1427 | [街角](entries/1204/1204580-machikado.org) | まちかど | machikado | 1204580 | learner | draft | **new** | Editorial review |
| N2-1428 | [真っ暗](entries/1363/1363190-makkura.org) | まっくら | makkura | 1363190 | learner | draft | **new** | Editorial review |
| N2-1429 | [真っ黒](entries/1604/1604050-makkuro.org) | まっくろ | makkuro | 1604050 | learner | draft | **new** | Editorial review |
| N2-1430 | [真っ青](entries/1604/1604080-massao.org) | まっさお | massao | 1604080 | learner | draft | **new** | Editorial review |
| N2-1431 | [真っ先](entries/1363/1363260-massaki.org) | まっさき | massaki | 1363260 | learner | draft | **new** | Editorial review |
| N2-1432 | [真っ白](entries/1580/1580620-masshiro.org) | まっしろ | masshiro | 1580620 | learner | draft | **new** | Editorial review |
| N2-1433 | [祭る](entries/1295/1295250-matsuru.org) | まつる | matsuru | 1295250 | learner | draft | **new** | Editorial review |
| N2-1434 | [纏まる](entries/1611/1611640-matomaru.org) | まとまる | matomaru | 1611640 | learner | draft | **new** | Editorial review |
| N2-1435 | [纏める](entries/1440/1440930-matomeru.org) | まとめる | matomeru | 1440930 | learner | draft | **new** | Editorial review |
| N2-1436 | [窓口](entries/1401/1401420-madoguchi.org) | まどぐち | madoguchi | 1401420 | learner | draft | **new** | Editorial review |
| N2-1437 | [真似る](entries/1363/1363760-maneru.org) | まねる | maneru | 1363760 | learner | draft | **new** | Editorial review |
| N2-1438 | [マフラー](entries/1129/1129210-mafuraa.org) | マフラー | mafuraa | 1129210 | learner | draft | **new** | Editorial review |
| N2-1439 | [眩しい](entries/1569/1569790-mabushii.org) | まぶしい | mabushii | 1569790 | learner | draft | **new** | Editorial review |
| N2-1440 | [瞼](entries/1569/1569920-mabuta.org) | まぶた | mabuta | 1569920 | learner | draft | **new** | Editorial review |
| N2-1441 | [間もなく](entries/1215/1215290-mamonaku.org) | まもなく | mamonaku | 1215290 | learner | draft | **new** | Editorial review |
| N2-1442 | [マラソン](entries/1129/1129290-marason.org) | マラソン | marason | 1129290 | learner | draft | **new** | Editorial review |
| N2-1443 | [稀](entries/1604/1604280-mare.org) | まれ | mare | 1604280 | learner | draft | **new** | Editorial review |
| N2-1444 | [回り道](entries/1199/1199360-mawarimichi.org) | まわりみち | mawarimichi | 1199360 | learner | draft | **new** | Editorial review |
| N2-1445 | [満員](entries/1526/1526720-manin.org) | まんいん | manin | 1526720 | learner | draft | **new** | Editorial review |
| N2-1446 | [マンション](entries/1130/1130040-manshon.org) | マンション | manshon | 1130040 | learner | draft | **new** | Editorial review |
| N2-1447 | [満点](entries/1604/1604340-manten.org) | まんてん | manten | 1604340 | learner | draft | **new** | Editorial review |
| N2-1448 | [見送る](entries/1259/1259830-miokuru.org) | みおくる | miokuru | 1259830 | learner | draft | **new** | Editorial review |
| N2-1449 | [見下ろす](entries/1259/1259370-miorosu.org) | みおろす | miorosu | 1259370 | learner | draft | **new** | Editorial review |
| N2-1450 | [見かけ](entries/1604/1604420-mikake.org) | みかけ | mikake | 1604420 | learner | draft | **new** | Editorial review |
| N2-1451 | [ミシン](entries/1130/1130640-mishin.org) | ミシン | mishin | 1130640 | learner | draft | **new** | Editorial review |
| N2-1452 | [惨め](entries/1303/1303280-mijime.org) | みじめ | mijime | 1303280 | learner | draft | **new** | Editorial review |
| N2-1453 | [店屋](entries/1910/1910260-miseya.org) | みせや | miseya | 1910260 | learner | draft | **new** | Editorial review |
| N2-1454 | [見出し](entries/1259/1259710-midashi.org) | みだし | midashi | 1259710 | learner | draft | **new** | Editorial review |
| N2-1455 | [道順](entries/1611/1611770-michijun.org) | みちじゅん | michijun | 1611770 | learner | draft | **new** | Editorial review |
| N2-1456 | [見直す](entries/1259/1259900-minaosu.org) | みなおす | minaosu | 1259900 | learner | draft | **new** | Editorial review |
| N2-1457 | [見慣れる](entries/1604/1604650-minareru.org) | みなれる | minareru | 1604650 | learner | draft | **new** | Editorial review |
| N2-1458 | [醜い](entries/1333/1333810-minikui.org) | みにくい | minikui | 1333810 | learner | draft | **new** | Editorial review |
| N2-1459 | [実る](entries/1320/1320850-minoru.org) | みのる | minoru | 1320850 | learner | draft | **new** | Editorial review |
| N2-1460 | [身分](entries/1365/1365810-mibun.org) | みぶん | mibun | 1365810 | learner | draft | **new** | Editorial review |
| N2-1461 | [見本](entries/1260/1260100-mihon.org) | みほん | mihon | 1260100 | learner | draft | **new** | Editorial review |
| N2-1462 | [見舞う](entries/1259/1259990-mimau.org) | みまう | mimau | 1259990 | learner | draft | **new** | Editorial review |
| N2-1463 | [未満](entries/1528/1528040-miman.org) | みまん | miman | 1528040 | learner | draft | **new** | Editorial review |
| N2-1464 | [苗字](entries/1604/1604730-myouji.org) | みょうじ | myouji | 1604730 | learner | draft | **new** | Editorial review |
| N2-1465 | [ミリ](entries/1131/1131830-miri.org) | ミリ | miri | 1131830 | learner | draft | **new** | Editorial review |
| N2-1466 | [診る](entries/1365/1365450-miru.org) | みる | miru | 1365450 | learner | draft | **new** | Editorial review |
| N2-1467 | [民間](entries/1528/1528630-minkan.org) | みんかん | minkan | 1528630 | learner | draft | **new** | Editorial review |
| N2-1468 | [民謡](entries/1529/1529270-minyou.org) | みんよう | minyou | 1529270 | learner | draft | **new** | Editorial review |
| N2-1469 | [剥く](entries/1474/1474370-muku.org) | むく | muku | 1474370 | learner | draft | **new** | Editorial review |
| N2-1470 | [無限](entries/1529/1529880-mugen.org) | むげん | mugen | 1529880 | learner | draft | **new** | Editorial review |
| N2-1471 | [蒸し暑い](entries/1356/1356870-mushiatsui.org) | むしあつい | mushiatsui | 1356870 | learner | draft | **new** | Editorial review |
| N2-1472 | [無地](entries/1530/1530650-muji.org) | むじ | muji | 1530650 | learner | draft | **new** | Editorial review |
| N2-1473 | [矛盾](entries/1531/1531090-mujun.org) | むじゅん | mujun | 1531090 | learner | draft | **new** | Editorial review |
| N2-1474 | [蒸す](entries/1356/1356900-musu.org) | むす | musu | 1356900 | learner | draft | **new** | Editorial review |
| N2-1475 | [群れ](entries/1247/1247510-mure.org) | むれ | mure | 1247510 | learner | draft | **new** | Editorial review |
| N2-1476 | [姪](entries/1532/1532940-mei.org) | めい | mei | 1532940 | learner | draft | **new** | Editorial review |
| N2-1477 | [名作](entries/1531/1531500-meisaku.org) | めいさく | meisaku | 1531500 | learner | draft | **new** | Editorial review |
| N2-1478 | [名刺](entries/1531/1531550-meishi.org) | めいし | meishi | 1531550 | learner | draft | **new** | Editorial review |
| N2-1479 | [名詞](entries/1531/1531570-meishi.org) | めいし | meishi | 1531570 | learner | draft | **new** | Editorial review |
| N2-1480 | [名所](entries/1531/1531600-meisho.org) | めいしょ | meisho | 1531600 | learner | draft | **new** | Editorial review |
| N2-1481 | [迷信](entries/1532/1532760-meishin.org) | めいしん | meishin | 1532760 | learner | draft | **new** | Editorial review |
| N2-1482 | [命ずる](entries/1531/1531970-meizuru.org) | めいずる | meizuru | 1531970 | learner | draft | **new** | Editorial review |
| N2-1483 | [名物](entries/1531/1531810-meibutsu.org) | めいぶつ | meibutsu | 1531810 | learner | draft | **new** | Editorial review |
| N2-1484 | [銘々](entries/1532/1532810-meimei.org) | めいめい | meimei | 1532810 | learner | draft | **new** | Editorial review |
| N2-1485 | [目上](entries/1535/1535490-meue.org) | めうえ | meue | 1535490 | learner | draft | **new** | Editorial review |
| N2-1486 | [恵まれる](entries/1611/1611980-megumareru.org) | めぐまれる | megumareru | 1611980 | learner | draft | **new** | Editorial review |
| N2-1488 | [目指す](entries/1535/1535440-mezasu.org) | めざす | mezasu | 1535440 | learner | draft | **new** | Editorial review |
| N2-1489 | [目覚まし](entries/1535/1535340-mezamashi.org) | めざまし | mezamashi | 1535340 | learner | draft | **new** | Editorial review |
| N2-1490 | [目下](entries/1535/1535320-meshita.org) | めした | meshita | 1535320 | learner | draft | **new** | Editorial review |
| N2-1491 | [目印](entries/1535/1535300-mejirushi.org) | めじるし | mejirushi | 1535300 | learner | draft | **new** | Editorial review |
| N2-1492 | [目立つ](entries/1535/1535700-medatsu.org) | めだつ | medatsu | 1535700 | learner | draft | **new** | Editorial review |
| N2-1493 | [滅茶苦茶](entries/1533/1533000-mechakucha.org) | めちゃくちゃ | mechakucha | 1533000 | learner | draft | **new** | Editorial review |
| N2-1494 | [めっきり](entries/1012/1012470-mekkiri.org) | めっきり | mekkiri | 1012470 | learner | draft | **new** | Editorial review |
| N2-1495 | [目出度い](entries/1608/1608630-medetai.org) | めでたい | medetai | 1608630 | learner | draft | **new** | Editorial review |
| N2-1496 | [メニュー](entries/1133/1133790-menyuu.org) | メニュー | menyuu | 1133790 | learner | draft | **new** | Editorial review |
| N2-1497 | [眩暈](entries/1569/1569810-memai.org) | めまい | memai | 1569810 | learner | draft | **new** | Editorial review |
| N2-1498 | [目安](entries/1535/1535280-meyasu.org) | めやす | meyasu | 1535280 | learner | draft | **new** | Editorial review |
| N2-1499 | [面積](entries/1533/1533500-menseki.org) | めんせき | menseki | 1533500 | learner | draft | **new** | Editorial review |
| N2-1500 | [面接](entries/1533/1533510-mensetsu.org) | めんせつ | mensetsu | 1533510 | learner | draft | **new** | Editorial review |
| N2-1501 | [面倒くさい](entries/1533/1533560-mendokusai.org) | めんどくさい | mendokusai | 1533560 | learner | draft | **new** | Editorial review |
| N2-1502 | [メーター](entries/1132/1132530-meetaa.org) | メーター | meetaa | 1132530 | learner | draft | **new** | Editorial review |
| N2-1503 | [儲かる](entries/1534/1534490-moukaru.org) | もうかる | moukaru | 1534490 | learner | draft | **new** | Editorial review |
| N2-1504 | [儲ける](entries/1534/1534500-moukeru.org) | もうける | moukeru | 1534500 | learner | draft | **new** | Editorial review |
| N2-1505 | [申し訳ない](entries/1612/1612040-moushiwakenai.org) | もうしわけない | moushiwakenai | 1612040 | learner | draft | **new** | Editorial review |
