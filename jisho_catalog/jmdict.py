"""Streaming extraction of Russian translation units from JMdict XML."""

from __future__ import annotations

from dataclasses import asdict, dataclass
from hashlib import sha256
import json
from pathlib import Path
from typing import BinaryIO, Iterator
import gzip
import xml.etree.ElementTree as ET


XML_LANG = "{http://www.w3.org/XML/1998/namespace}lang"
PRIORITY_CODES = {"ichi1", "news1", "spec1", "gai1"}


@dataclass(frozen=True)
class JapaneseForms:
    kanji: tuple[str, ...]
    readings: tuple[str, ...]
    priority: tuple[str, ...]


@dataclass(frozen=True)
class SourceSense:
    ru: tuple[str, ...]
    en: tuple[str, ...]
    part_of_speech: tuple[str, ...]
    fields: tuple[str, ...]
    misc: tuple[str, ...]
    kanji_restrictions: tuple[str, ...]
    reading_restrictions: tuple[str, ...]


@dataclass(frozen=True)
class TranslationUnit:
    ent_seq: int
    sense_index: int
    japanese: JapaneseForms
    source: SourceSense

    @property
    def unit_id(self) -> str:
        return f"{self.ent_seq}-{self.sense_index}"

    @property
    def source_fingerprint(self) -> str:
        return calculate_source_fingerprint(
            self.ent_seq, self.sense_index, self.japanese, self.source
        )

    def to_record(self) -> dict[str, object]:
        return {
            "schema_version": 1,
            "id": self.unit_id,
            "ent_seq": self.ent_seq,
            "sense_index": self.sense_index,
            "japanese": {
                "kanji": list(self.japanese.kanji),
                "readings": list(self.japanese.readings),
                "priority": list(self.japanese.priority),
            },
            "source": {
                "ru": list(self.source.ru),
                "en": list(self.source.en),
                "part_of_speech": list(self.source.part_of_speech),
                "fields": list(self.source.fields),
                "misc": list(self.source.misc),
                "kanji_restrictions": list(self.source.kanji_restrictions),
                "reading_restrictions": list(self.source.reading_restrictions),
            },
            "source_fingerprint": self.source_fingerprint,
            "translation": {"uk": [], "status": "untranslated", "notes": ""},
        }


def calculate_source_fingerprint(
    ent_seq: int,
    sense_index: int,
    japanese: JapaneseForms,
    source: SourceSense,
) -> str:
    """Return the canonical fingerprint shared by extraction and validation."""

    payload = {
        "ent_seq": ent_seq,
        "sense_index": sense_index,
        "japanese": asdict(japanese),
        "source": asdict(source),
    }
    encoded = json.dumps(
        payload, ensure_ascii=False, sort_keys=True, separators=(",", ":")
    ).encode("utf-8")
    return sha256(encoded).hexdigest()


def _texts(parent: ET.Element, path: str) -> tuple[str, ...]:
    return tuple(
        text
        for node in parent.findall(path)
        if (text := (node.text or "").strip())
    )


def _unique(values: Iterator[str]) -> tuple[str, ...]:
    return tuple(dict.fromkeys(values))


def _priority(entry: ET.Element) -> tuple[str, ...]:
    values = (
        text
        for path in ("./k_ele/ke_pri", "./r_ele/re_pri")
        for text in _texts(entry, path)
    )
    return _unique(values)


def _glosses(sense: ET.Element, language: str) -> tuple[str, ...]:
    values: list[str] = []
    for gloss in sense.findall("./gloss"):
        gloss_language = gloss.get(XML_LANG, "eng")
        if gloss_language == language and (text := (gloss.text or "").strip()):
            values.append(text)
    return tuple(values)


def _open_source(path: Path) -> BinaryIO:
    if path.suffix == ".gz":
        return gzip.open(path, "rb")
    return path.open("rb")


def iter_translation_units(
    path: str | Path, *, priority_only: bool = False
) -> Iterator[TranslationUnit]:
    """Yield each JMdict sense that contains at least one Russian gloss."""

    source_path = Path(path)
    with _open_source(source_path) as source:
        for _event, entry in ET.iterparse(source, events=("end",)):
            if entry.tag != "entry":
                continue

            ent_seq_text = entry.findtext("./ent_seq")
            if ent_seq_text is None:
                entry.clear()
                continue

            priority = _priority(entry)
            is_priority = any(
                value in PRIORITY_CODES
                or (value.startswith("nf") and value[2:].isdigit() and int(value[2:]) <= 10)
                for value in priority
            )
            if priority_only and not is_priority:
                entry.clear()
                continue

            japanese = JapaneseForms(
                kanji=_texts(entry, "./k_ele/keb"),
                readings=_texts(entry, "./r_ele/reb"),
                priority=priority,
            )
            for sense_index, sense in enumerate(entry.findall("./sense"), start=1):
                russian = _glosses(sense, "rus")
                if not russian:
                    continue
                yield TranslationUnit(
                    ent_seq=int(ent_seq_text),
                    sense_index=sense_index,
                    japanese=japanese,
                    source=SourceSense(
                        ru=russian,
                        en=_glosses(sense, "eng"),
                        part_of_speech=_texts(sense, "./pos"),
                        fields=_texts(sense, "./field"),
                        misc=_texts(sense, "./misc"),
                        kanji_restrictions=_texts(sense, "./stagk"),
                        reading_restrictions=_texts(sense, "./stagr"),
                    ),
                )
            entry.clear()
