from __future__ import annotations

import gzip
import json
from pathlib import Path
import tempfile
import unittest

from jisho_catalog.catalog import write_catalog
from jisho_catalog.jmdict import calculate_source_fingerprint, iter_translation_units


FIXTURE = Path(__file__).parent / "fixtures" / "jmdict-sample.xml"


class JmdictExtractionTests(unittest.TestCase):
    def test_extracts_only_senses_with_russian_glosses(self) -> None:
        units = list(iter_translation_units(FIXTURE))

        self.assertEqual([unit.unit_id for unit in units], ["1000001-1", "1000002-1"])
        self.assertEqual(units[0].japanese.kanji, ("日本語",))
        self.assertEqual(units[0].japanese.readings, ("にほんご",))
        self.assertEqual(units[0].source.en, ("Japanese language",))
        self.assertEqual(units[0].source.ru, ("японский язык",))
        self.assertEqual(units[1].source.ru, ("приветствие", "привет"))
        self.assertEqual(units[1].source.fields, ("linguistics",))

    def test_reads_gzip_and_filters_to_priority_entries(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            compressed = Path(directory) / "sample.xml.gz"
            with FIXTURE.open("rb") as source, gzip.open(compressed, "wb") as target:
                target.write(source.read())

            units = list(iter_translation_units(compressed, priority_only=True))

        self.assertEqual([unit.unit_id for unit in units], ["1000001-1"])

    def test_fingerprint_changes_with_source_content(self) -> None:
        first = next(iter_translation_units(FIXTURE))
        original = first.source_fingerprint
        record = first.to_record()

        self.assertEqual(len(original), 64)
        self.assertEqual(record["source_fingerprint"], original)
        self.assertEqual(record["translation"]["status"], "untranslated")
        self.assertEqual(
            original,
            calculate_source_fingerprint(
                first.ent_seq, first.sense_index, first.japanese, first.source
            ),
        )


class CatalogTests(unittest.TestCase):
    def test_writes_deterministic_chunks_and_manifest(self) -> None:
        units = list(iter_translation_units(FIXTURE))
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "catalog"
            manifest = write_catalog(
                units,
                output,
                chunk_size=1,
                source_url="https://example.test/JMdict.gz",
                source_sha256="abc123",
            )

            first = json.loads((output / "catalog-0001.jsonl").read_text())
            second = json.loads((output / "catalog-0002.jsonl").read_text())

        self.assertEqual(manifest["records"], 2)
        self.assertEqual([item["records"] for item in manifest["files"]], [1, 1])
        self.assertEqual(first["id"], "1000001-1")
        self.assertEqual(second["id"], "1000002-1")

    def test_rejects_invalid_chunk_size(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            with self.assertRaisesRegex(ValueError, "at least 1"):
                write_catalog(
                    [],
                    directory,
                    chunk_size=0,
                    source_url="https://example.test/JMdict.gz",
                )


if __name__ == "__main__":
    unittest.main()
