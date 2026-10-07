# Open Anki JLPT candidate evidence

The [Open Anki JLPT decks](https://github.com/jamsinclair/open-anki-jlpt-decks)
provide public lexical CSV lists derived from earlier JLPT study decks. These
are study-list level assignments, not an official examination syllabus.

Retrieved 2026-10-05. Exact written forms and readings were reconciled against
pinned JMdict; ambiguous matches and all existing or reserved IDs were excluded.
The N2 CSV yielded zero additional distinct entries. The N1 CSV yielded 1,531;
the first 30 were selected for the 2,900 to 3,100 continuation, after the
remaining 170 JLPTLord N2 candidates. `selected.tsv` records all 30 lexical
labels, readings, page positions, source URLs and matched JMdict IDs.

Only lexical metadata is used. Source meanings and example sentences are not
copied or redistributed. Ukrainian glosses, nuanced usage notes and all graded
examples are independently authored.

| Retrieved source | SHA-256 |
| --- | --- |
| [N1 lexical CSV](https://raw.githubusercontent.com/jamsinclair/open-anki-jlpt-decks/main/src/n1.csv) | `120911636c019899552aa6d7bd64b036ecef4bedfe272a744f75735c46aae5cd` |
| [N2 lexical CSV](https://raw.githubusercontent.com/jamsinclair/open-anki-jlpt-decks/main/src/n2.csv) | `2d0f1ddd6222881cd9fc2ca701db74300af99b3f1f84d5ac3c18411c20f0c055` |

Completed 2026-10-07: all 630 selected N1 entries were authored and individually
committed in 63 batches of ten (3 on main, 60 on this continuation branch).
They supply 1,045 original Ukrainian usage notes and 2,310 examples (including 1,890
primary-sense graded examples), and passed validation, Org lint and doctor
100/100 with no errors or warnings. The reconciled pool retains 901 unused
N1 entries. These remain learner drafts awaiting independent linguistic review.
