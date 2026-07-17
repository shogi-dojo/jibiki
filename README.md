# Jisho: JMdict Russian → Ukrainian

An open, collaborative Ukrainian translation layer for the Japanese
multilingual dictionary [JMdict][jmdict]. The project preserves the Japanese
headwords, readings, Russian glosses, and English context from JMdict while
contributors create reviewed Ukrainian glosses for each dictionary sense.

## Project goals

- Build a reusable Japanese–Ukrainian dataset, not an application-specific
  database.
- Keep every Ukrainian translation traceable to a JMdict entry and sense.
- Make ordinary GitHub pull requests pleasant to review and merge.
- Generate deterministic data suitable for Android, desktop, and web clients.
- Stay compatible with upstream JMdict updates.

## Planned workflow

1. Download the current `JMdict_e.gz` from EDRDG.
2. Extract entries containing Russian glosses into deterministic JSONL chunks.
3. Claim a small chunk and translate only its Ukrainian target fields.
4. Validate the records locally and submit a pull request.
5. Review linguistic accuracy separately from mechanical schema checks.

Raw JMdict archives and generated working catalogs are intentionally excluded
from Git. Only reviewed Ukrainian translation records belong in
`translations/`.

## Licensing

Translation data is available under **CC BY-SA 4.0**; tooling is available
under the **MIT License**. Read [DATA-LICENSE.md](DATA-LICENSE.md) and
[ATTRIBUTION.md](ATTRIBUTION.md) before contributing. Do not copy definitions
from Warodai or other sources whose licences prohibit derivatives.

[jmdict]: https://www.edrdg.org/wiki/index.php/JMdict-EDICT_Dictionary_Project

