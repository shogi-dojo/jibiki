"""Build a working Russian-to-Ukrainian translation catalog from JMdict."""

from __future__ import annotations

import argparse
from hashlib import sha256
from itertools import islice
from pathlib import Path

from jisho_catalog.catalog import write_catalog
from jisho_catalog.jmdict import iter_translation_units
from scripts.fetch_jmdict import DEFAULT_URL


def file_sha256(path: Path) -> str:
    digest = sha256()
    with path.open("rb") as source:
        while chunk := source.read(1024 * 1024):
            digest.update(chunk)
    return digest.hexdigest()


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path)
    parser.add_argument("output", type=Path)
    parser.add_argument("--chunk-size", type=int, default=500)
    parser.add_argument("--limit", type=int)
    parser.add_argument("--priority-only", action="store_true")
    parser.add_argument("--source-url", default=DEFAULT_URL)
    args = parser.parse_args()

    units = iter_translation_units(args.source, priority_only=args.priority_only)
    if args.limit is not None:
        if args.limit < 0:
            parser.error("--limit must not be negative")
        units = islice(units, args.limit)
    manifest = write_catalog(
        units,
        args.output,
        chunk_size=args.chunk_size,
        source_url=args.source_url,
        source_sha256=file_sha256(args.source),
    )
    print(f"Wrote {manifest['records']} translation units to {args.output}")


if __name__ == "__main__":
    main()

