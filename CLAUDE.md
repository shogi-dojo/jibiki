# Project conventions

- Use Python 3.11 or newer and the standard library unless a dependency has a
  clear, documented benefit.
- Keep downloaded JMdict archives and generated catalogs out of Git.
- Store reviewed Ukrainian translations in deterministic JSONL files under
  `translations/`, keyed by JMdict `ent_seq` and one-based sense index.
- Preserve Russian and English source text exactly; translators edit only the
  Ukrainian target and workflow metadata.
- Run `python -m unittest discover -s tests -v` before every commit.
- Run `python -m scripts.validate translations` before publishing data.
- Keep pure parsing and validation logic independent of network and CLI code.
- New branchy behavior requires input/output-focused unit tests.

