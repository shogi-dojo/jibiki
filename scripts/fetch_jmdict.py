"""Download a traceable JMdict snapshot into the ignored raw-data directory."""

from __future__ import annotations

import argparse
from datetime import datetime, timezone
from hashlib import sha256
import json
from pathlib import Path
import tempfile
from urllib.request import urlopen


DEFAULT_URL = "https://www.edrdg.org/pub/Nihongo/JMdict.gz"
DEFAULT_OUTPUT = Path("data/raw/JMdict.gz")


def download(url: str, output: Path) -> dict[str, object]:
    output.parent.mkdir(parents=True, exist_ok=True)
    digest = sha256()
    byte_count = 0
    with urlopen(url) as response, tempfile.NamedTemporaryFile(
        dir=output.parent, delete=False
    ) as temporary:
        temporary_path = Path(temporary.name)
        while chunk := response.read(1024 * 1024):
            temporary.write(chunk)
            digest.update(chunk)
            byte_count += len(chunk)
    temporary_path.replace(output)
    metadata: dict[str, object] = {
        "url": url,
        "retrieved_at": datetime.now(timezone.utc).isoformat(),
        "sha256": digest.hexdigest(),
        "bytes": byte_count,
    }
    output.with_suffix(output.suffix + ".source.json").write_text(
        json.dumps(metadata, indent=2) + "\n", encoding="utf-8"
    )
    return metadata


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--url", default=DEFAULT_URL)
    parser.add_argument("--output", type=Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args()
    metadata = download(args.url, args.output)
    print(json.dumps(metadata, indent=2))


if __name__ == "__main__":
    main()

