# Supplementary JLPT N2 candidate source

Pinned Open Anki JLPT Decks N2 CSV, used after the Wiktionary queue
was exhausted. This is a candidate classification, not an official JLPT syllabus.

- Repository: https://github.com/jamsinclair/open-anki-jlpt-decks
- Revision: `1ad66734417aca9dbcca6b2d5ee440cb13ab3ba0`
- Source: https://github.com/jamsinclair/open-anki-jlpt-decks/blob/1ad66734417aca9dbcca6b2d5ee440cb13ab3ba0/src/n2.csv
- Retrieved: 2026-10-04
- Data rows: 1906
- Raw upstream CSV SHA-256 (CRLF): `2d0f1ddd6222881cd9fc2ca701db74300af99b3f1f84d5ac3c18411c20f0c055`
- Tracked `n2.csv` SHA-256 (LF-normalized): `0b30af49ab94d8b33cfa90c74f47772eccb18ab5c4acc4c654e9315de7a54ff7`
- Only line endings were normalized; all 1906 data rows are preserved.
- Repository license: MIT; retained in `LICENSE`, copyright Jamie Sinclair.
- Upstream acknowledgement: chyyran/jlpt-anki-decks, based on tanos.co.uk.

Candidates are referenced as **N2-S<row>**, using one-based CSV data row
numbers (header excluded). `selected.tsv` records the 127 chosen candidates across two continuations
and their reconciled JMdict IDs. No English definitions from this CSV are
used as dictionary sense metadata: all senses and source fingerprints come
from the pinned local JMdict. Ukrainian translations, notes, and examples
are independently authored.

Selection excludes already authored JMdict IDs, unresolved homonyms,
malformed readings, and duplicates. Affix entries selected in the later
continuation explicitly explain their construction and register. Two otherwise
uncovered rows were rejected as unsuitable for this learning continuation:
row 517 琴/きん resolves to Chinese guqin, while the common Japanese koto
already exists; row 753 塩辛/しおから resolves to fermented seafood rather
than the expected adjective 塩辛い. These are not silently rewritten into
another lexeme. Their presence illustrates why candidate lists need review.
