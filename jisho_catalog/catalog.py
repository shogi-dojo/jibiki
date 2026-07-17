"""Deterministic JSONL catalog output."""

from __future__ import annotations

from collections.abc import Iterable
from datetime import datetime, timezone
import json
from pathlib import Path
import shutil

from .jmdict import TranslationUnit


def write_catalog(
    units: Iterable[TranslationUnit],
    output_dir: str | Path,
    *,
    chunk_size: int = 500,
    source_url: str,
    source_sha256: str | None = None,
) -> dict[str, object]:
    if chunk_size < 1:
        raise ValueError("chunk_size must be at least 1")

    output = Path(output_dir)
    temporary = output.with_name(f".{output.name}.tmp")
    if temporary.exists():
        shutil.rmtree(temporary)
    temporary.mkdir(parents=True)

    files: list[dict[str, object]] = []
    current = None
    current_count = 0
    total = 0
    try:
        for unit in units:
            if current is None or current_count == chunk_size:
                if current is not None:
                    current.close()
                filename = f"catalog-{len(files) + 1:04d}.jsonl"
                current = (temporary / filename).open("w", encoding="utf-8", newline="\n")
                files.append({"path": filename, "records": 0})
                current_count = 0
            current.write(
                json.dumps(unit.to_record(), ensure_ascii=False, separators=(",", ":"))
                + "\n"
            )
            current_count += 1
            total += 1
            files[-1]["records"] = current_count
    finally:
        if current is not None:
            current.close()

    manifest: dict[str, object] = {
        "schema_version": 1,
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "source": {"url": source_url, "sha256": source_sha256},
        "records": total,
        "files": files,
    }
    (temporary / "manifest.json").write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
    )
    if output.exists():
        shutil.rmtree(output)
    temporary.replace(output)
    return manifest

