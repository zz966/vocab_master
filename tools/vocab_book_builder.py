#!/usr/bin/env python3
"""从 KyleBing/english-vocabulary json-full 合并生成 vocab_master 富内容词书。"""

from __future__ import annotations

import json
import re
import urllib.request
from dataclasses import dataclass
from pathlib import Path

from ecdict_audit import audit_book as audit_book_json
from ecdict_definition_utils import (
    is_severe_definition_mismatch,
    parse_ecdict_translation,
)
from ecdict_lookup import EcdictLookup
from word_validation import fix_word, word_issue

ROOT = Path(__file__).resolve().parents[1]
SOURCE_BASE = (
    "https://raw.githubusercontent.com/KyleBing/english-vocabulary/"
    "master/json_original/json-full"
)
CONTENT_VERSION = "content-v3"

POS_MAP = {
    "n": "n.",
    "v": "v.",
    "adj": "adj.",
    "adv": "adv.",
    "prep": "prep.",
    "conj": "conj.",
    "pron": "pron.",
    "art": "art.",
    "num": "num.",
    "int": "int.",
    "vt": "v.",
    "vi": "v.",
}


@dataclass(frozen=True)
class BookSpec:
    book_id: str
    output_name: str
    source_files: tuple[str, ...]
    cache_prefix: str
    book_name: str
    description: str
    category: str
    difficulty: str
    cover_color: str
    exam_label: str
    exam_short: str


def format_phonetic(raw: str, *, fallback: str = "", word: str = "") -> str:
    text = (raw or fallback or "").strip()
    if not text and word:
        text = word
    if not text:
        return ""
    if text.startswith("/"):
        return text
    return f"/{text}/"


def normalize_pos(pos: str) -> str:
    key = (pos or "n").strip().lower().rstrip(".")
    return POS_MAP.get(key, f"{key}.")


def combine_definition(translations: list[dict]) -> str:
    parts: list[str] = []
    for item in translations:
        meaning = str(item.get("translation", "")).strip()
        if not meaning:
            continue
        pos = normalize_pos(str(item.get("type", "")))
        parts.append(f"{pos} {meaning}" if pos else meaning)
    return "； ".join(parts) if parts else ""


def build_definitions(translations: list[dict]) -> list[dict]:
    return [
        {
            "partOfSpeech": normalize_pos(str(entry.get("type", ""))),
            "meaning": str(entry.get("translation", "")).strip(),
        }
        for entry in translations
        if str(entry.get("translation", "")).strip()
    ]


def build_english_definitions(english_translations: list[dict]) -> list[dict]:
    return [
        {
            "partOfSpeech": normalize_pos(str(entry.get("type", ""))),
            "meaning": str(entry.get("meaning", "")).strip(),
        }
        for entry in english_translations
        if str(entry.get("meaning", "")).strip()
    ]


def collect_examples(inner: dict) -> list[dict]:
    examples: list[dict] = []
    seen: set[tuple[str, str]] = set()

    def add_example(en: str, cn: str) -> None:
        key = (en, cn)
        if not en or not cn or key in seen:
            return
        seen.add(key)
        examples.append({"en": en, "cn": cn})

    for item in (inner.get("sentence") or {}).get("sentences") or []:
        add_example(str(item.get("sContent", "")).strip(), str(item.get("sCn", "")).strip())

    for item in (inner.get("realExamSentence") or {}).get("sentences") or []:
        add_example(str(item.get("sContent", "")).strip(), str(item.get("sCn", "")).strip())

    return examples


def build_synonyms(word: str, syn_groups: list[dict]) -> list[dict]:
    synonyms: list[dict] = []
    seen: set[str] = set()
    head = word.lower()

    for group in syn_groups:
        meaning = str(group.get("tran", "")).strip()
        for item in group.get("hwds") or []:
            candidate = str(item.get("w", "")).strip()
            key = candidate.lower()
            if not candidate or key == head or key in seen:
                continue
            seen.add(key)
            synonyms.append({"word": candidate, "meaning": meaning})
            if len(synonyms) >= 4:
                return synonyms
    return synonyms


def build_collocations(phrases: list[dict], examples: list[dict]) -> list[dict]:
    collocations: list[dict] = []
    sentence_pairs = [
        (str(item.get("en", "")).strip(), str(item.get("cn", "")).strip())
        for item in examples
    ]

    for item in phrases[:5]:
        phrase = str(item.get("phrase", "")).strip()
        translation = str(item.get("translation", "")).strip()
        if not phrase:
            continue

        entry: dict = {
            "phrase": phrase,
            "translation": translation or phrase,
        }
        for en, cn in sentence_pairs:
            if phrase.lower() in en.lower():
                entry["example"] = {"en": en, "cn": cn}
                break
        collocations.append(entry)

    return collocations


def build_memory_tips(rel_groups: list[dict]) -> dict | None:
    parts: list[str] = []
    for group in rel_groups:
        for item in group.get("words") or []:
            hwd = str(item.get("hwd", "")).strip()
            tran = str(item.get("tran", "")).strip()
            if hwd and tran:
                parts.append(f"{hwd}（{tran.strip()}）")
    if not parts:
        return None
    return {
        "etymology": "；".join(parts[:4]),
        "mnemonic": "",
        "association": "",
    }


def parse_full_item(item: dict) -> dict | None:
    word = str(item.get("headWord", "")).strip()
    inner = (
        item.get("content", {})
        .get("word", {})
        .get("content", {})
    )
    if not word or not inner:
        return None

    translations: list[dict] = []
    english_translations: list[dict] = []
    for trans in inner.get("trans") or []:
        tran_cn = str(trans.get("tranCn", "")).strip()
        pos = str(trans.get("pos", "")).strip()
        if tran_cn:
            translations.append({"translation": tran_cn, "type": pos})
        tran_other = str(trans.get("tranOther", "")).strip()
        if tran_other:
            english_translations.append({"meaning": tran_other, "type": pos})

    phrases = [
        {
            "phrase": str(phrase.get("pContent", "")).strip(),
            "translation": str(phrase.get("pCn", "")).strip(),
        }
        for phrase in (inner.get("phrase") or {}).get("phrases") or []
        if str(phrase.get("pContent", "")).strip()
    ]

    return {
        "word": word,
        "uk": str(inner.get("ukphone", "")).strip(),
        "us": str(inner.get("usphone", "")).strip(),
        "translations": translations,
        "english_translations": english_translations,
        "examples": collect_examples(inner),
        "phrases": phrases,
        "syn_groups": (inner.get("syno") or {}).get("synos") or [],
        "rel_groups": (inner.get("relWord") or {}).get("rels") or [],
    }


def apply_ecdict(entry: dict, lookup: EcdictLookup, stats: dict[str, int]) -> None:
    word = str(entry.get("word", "")).strip()
    if not word:
        return

    definition_cn = combine_definition(entry.get("translations") or [])
    match = lookup.translation_matches(word, definition_cn)
    if match is True:
        stats["ecdict_verified"] += 1
    elif match is False:
        stats["ecdict_mismatch"] += 1

    ecdict = lookup.lookup(word)
    if not ecdict:
        return

    translation = str(ecdict.get("translation", "")).strip()
    if (
        translation
        and is_severe_definition_mismatch(definition_cn, translation)
    ):
        parsed = parse_ecdict_translation(translation)
        if parsed:
            entry["translations"] = [
                {
                    "translation": item["meaning"],
                    "type": item.get("partOfSpeech", "").rstrip("."),
                }
                for item in parsed
            ]
            stats["ecdict_definition_patched"] += 1

    if not str(entry.get("uk", "")).strip() and not str(entry.get("us", "")).strip():
        phonetic = ecdict.get("phonetic", "")
        if phonetic:
            formatted = format_phonetic(phonetic)
            entry["uk"] = formatted
            entry["us"] = formatted
            stats["ecdict_phonetic_filled"] += 1


def convert_word(
    index: int,
    entry: dict,
    spec: BookSpec,
    lookup: EcdictLookup,
    stats: dict[str, int],
) -> dict | None:
    word = str(entry.get("word", "")).strip()
    if not word:
        return None

    translations = entry.get("translations") or []
    definition_cn = combine_definition(translations)
    if not definition_cn:
        return None

    apply_ecdict(entry, lookup, stats)

    primary_pos = normalize_pos(
        str(translations[0].get("type", "")) if translations else "n"
    )
    examples = entry.get("examples") or []
    phrases = entry.get("phrases") or []
    english_definitions = build_english_definitions(
        entry.get("english_translations") or []
    )
    synonyms = build_synonyms(word, entry.get("syn_groups") or [])
    collocations = build_collocations(phrases, examples)
    memory_tips = build_memory_tips(entry.get("rel_groups") or [])

    phonetic_uk = format_phonetic(
        str(entry.get("uk", "")),
        fallback=str(entry.get("us", "")),
        word=word,
    )
    phonetic_us = format_phonetic(
        str(entry.get("us", "")),
        fallback=str(entry.get("uk", "")),
        word=word,
    )
    if not phonetic_uk and not phonetic_us:
        stats["missing_phonetic"] += 1
    if not examples:
        stats["missing_examples"] += 1

    result: dict = {
        "id": f"{spec.book_id}_{index}",
        "word": word,
        "phoneticUk": phonetic_uk,
        "phoneticUs": phonetic_us,
        "partOfSpeech": primary_pos,
        "definitionCn": definition_cn,
        "examples": examples,
        "synonyms": synonyms,
        "root": _extract_root(entry.get("rel_groups") or []),
        "definitions": build_definitions(translations),
        "collocations": collocations,
    }
    if english_definitions:
        result["englishDefinitions"] = english_definitions
    if memory_tips:
        result["memoryTips"] = memory_tips
    return result


def _extract_root(rel_groups: list[dict]) -> str:
    for group in rel_groups:
        for item in group.get("words") or []:
            hwd = str(item.get("hwd", "")).strip()
            if hwd:
                return hwd
    return ""


def download_source(file_name: str, cache: Path) -> list[dict]:
    if cache.exists():
        return json.loads(cache.read_text(encoding="utf-8"))
    url = f"{SOURCE_BASE}/{file_name}"
    with urllib.request.urlopen(url, timeout=180) as response:
        data = json.loads(response.read().decode("utf-8"))
    cache.write_text(json.dumps(data, ensure_ascii=False), encoding="utf-8")
    return data


def merge_sources(spec: BookSpec) -> tuple[list[dict], dict[str, int]]:
    merged: list[dict] = []
    seen: set[str] = set()
    stats = {
        "raw": 0,
        "skipped_dup": 0,
        "skipped_invalid": 0,
        "skipped_corrupt": 0,
    }

    for file_name in spec.source_files:
        cache = ROOT / "tools" / f"_full_{spec.cache_prefix}_{file_name}"
        batch = download_source(file_name, cache)
        stats["raw"] += len(batch)
        for item in batch:
            parsed = parse_full_item(item)
            if not parsed:
                stats["skipped_invalid"] += 1
                continue

            word_raw = str(parsed.get("word", "")).strip()
            issue = word_issue(word_raw)
            if issue and issue != "known_typo":
                stats["skipped_corrupt"] += 1
                continue

            word = fix_word(word_raw) or word_raw
            word_key = word.lower()
            if not word_key or word_key in seen:
                if word_key:
                    stats["skipped_dup"] += 1
                continue
            seen.add(word_key)
            if word != word_raw:
                parsed = {**parsed, "word": word}
            merged.append(parsed)

    return merged, stats


def _stamp_description(description: str) -> str:
    base = description.split("|")[0].strip()
    return f"{base} | {CONTENT_VERSION}"


def _write_ecdict_build_report(book: dict, lookup: EcdictLookup) -> Path:
    from dataclasses import asdict

    reports_dir = ROOT / "tools" / "reports"
    reports_dir.mkdir(parents=True, exist_ok=True)
    temp_path = reports_dir / f"_audit_{book['bookId']}.json"
    temp_path.write_text(json.dumps(book, ensure_ascii=False), encoding="utf-8")
    try:
        report = audit_book_json(temp_path, lookup)
    finally:
        temp_path.unlink(missing_ok=True)

    out_path = reports_dir / f"ecdict_audit_{book['bookId']}.json"
    out_path.write_text(
        json.dumps(asdict(report), ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    return out_path


def build_book(spec: BookSpec) -> dict[str, int]:
    lookup = EcdictLookup()
    source, stats = merge_sources(spec)
    stats.update(
        {
            "ecdict_verified": 0,
            "ecdict_mismatch": 0,
            "ecdict_definition_patched": 0,
            "ecdict_phonetic_filled": 0,
            "missing_examples": 0,
            "missing_phonetic": 0,
        }
    )

    words: list[dict] = []
    for index, entry in enumerate(source, start=1):
        converted = convert_word(index, entry, spec, lookup, stats)
        if converted:
            words.append(converted)
        else:
            stats["skipped_invalid"] += 1

    book = {
        "bookId": spec.book_id,
        "bookName": spec.book_name,
        "description": _stamp_description(spec.description),
        "totalWords": len(words),
        "cover": "",
        "category": spec.category,
        "difficulty": spec.difficulty,
        "coverColor": spec.cover_color,
        "words": words,
    }

    output = ROOT / "assets" / "books" / spec.output_name
    output.write_text(
        json.dumps(book, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )

    print(f"✓ 已生成 {spec.output_name}：{len(words)} 词（{CONTENT_VERSION}）")
    print(f"  原始条目：{stats['raw']}，去重跳过：{stats['skipped_dup']}")
    if stats["skipped_invalid"]:
        print(f"  无效跳过：{stats['skipped_invalid']}")
    if stats["skipped_corrupt"]:
        print(f"  损坏跳过：{stats['skipped_corrupt']}")
    if stats["missing_examples"]:
        print(f"  无真实例句：{stats['missing_examples']}")
    if stats["missing_phonetic"]:
        print(f"  无音标：{stats['missing_phonetic']}")
    if lookup.available:
        print(
            "  ECDICT："
            f"校验通过 {stats['ecdict_verified']}，"
            f"释义存疑 {stats['ecdict_mismatch']}，"
            f"严重不符已用 ECDICT 修正 {stats['ecdict_definition_patched']}，"
            f"补音标 {stats['ecdict_phonetic_filled']}"
        )
        report_path = _write_ecdict_build_report(book, lookup)
        print(f"  ECDICT 明细报告：{report_path}")
    else:
        print("  ECDICT：未放置本地词库（tools/ecdict.csv 或 tools/ecdict.db），已跳过")
    print(f"  来源：KyleBing json-full {', '.join(spec.source_files)}")
    return stats