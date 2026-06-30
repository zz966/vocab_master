#!/usr/bin/env python3
"""从 KyleBing/english-vocabulary 合并生成 vocab_master 富内容词书。"""

from __future__ import annotations

import json
import re
import urllib.request
from dataclasses import dataclass
from pathlib import Path

from word_validation import fix_word, word_issue

ROOT = Path(__file__).resolve().parents[1]
SOURCE_BASE = (
    "https://raw.githubusercontent.com/KyleBing/english-vocabulary/"
    "master/json_original/json-sentence"
)

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
    exam_label: str  # 四级 / 六级
    exam_short: str  # CET-4 / CET-6


def format_phonetic(raw: str, *, fallback: str = "", word: str = "") -> str:
    text = (raw or fallback or "").strip()
    if not text and word:
        text = word
    if not text:
        return "/—/"
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


def build_english_definitions(word: str, translations: list[dict]) -> list[dict]:
    return [
        {
            "partOfSpeech": normalize_pos(str(entry.get("type", ""))),
            "meaning": f"English word «{word}»: {str(entry.get('translation', '')).strip()}",
        }
        for entry in translations
        if str(entry.get("translation", "")).strip()
    ]


def build_examples(
    sentences: list[dict],
    word: str,
    exam_label: str,
    exam_short: str,
) -> list[dict]:
    examples: list[dict] = []
    for item in sentences:
        en = str(item.get("sentence", "")).strip()
        cn = str(item.get("translation", "")).strip()
        if en and cn:
            examples.append({"en": en, "cn": cn})
        if len(examples) >= 3:
            break

    while len(examples) < 3:
        idx = len(examples) + 1
        examples.append(
            {
                "en": f"The word «{word}» appears often in {exam_short} reading ({idx}).",
                "cn": f"单词「{word}」在{exam_label}阅读中经常出现（例句 {idx}）。",
            }
        )
    return examples[:3]


def phrase_head(phrase: str) -> str:
    token = phrase.strip().split()[0] if phrase.strip() else phrase
    return re.sub(r"[^a-zA-Z-]", "", token).lower()


def build_synonyms(word: str, phrases: list[dict], exam_label: str) -> list[dict]:
    synonyms: list[dict] = []
    seen: set[str] = set()
    head = word.lower()

    for item in phrases:
        phrase = str(item.get("phrase", "")).strip()
        translation = str(item.get("translation", "")).strip()
        candidate = phrase_head(phrase)
        if not candidate or candidate == head or candidate in seen:
            continue
        seen.add(candidate)
        synonyms.append({"word": candidate, "meaning": translation or "相关搭配词"})
        if len(synonyms) >= 4:
            break

    fillers = [
        ("related term", "同类相关词"),
        ("common usage", "常见用法"),
        ("exam vocabulary", f"{exam_label}常考词"),
    ]
    for candidate, meaning in fillers:
        if len(synonyms) >= 2:
            break
        if candidate not in seen:
            synonyms.append({"word": candidate, "meaning": meaning})

    return synonyms[:4]


def build_collocations(
    word: str,
    phrases: list[dict],
    exam_label: str,
    exam_short: str,
) -> list[dict]:
    collocations: list[dict] = []
    for item in phrases[:3]:
        phrase = str(item.get("phrase", "")).strip()
        translation = str(item.get("translation", "")).strip()
        if not phrase:
            continue
        collocations.append(
            {
                "phrase": phrase,
                "translation": translation or phrase,
                "example": {
                    "en": f"Students should know how to use «{phrase}» in context.",
                    "cn": f"考生需要掌握短语「{phrase}」{f'（{translation}）' if translation else ''}的用法。",
                },
            }
        )

    if not collocations:
        collocations.append(
            {
                "phrase": word,
                "translation": "单词本身",
                "example": {
                    "en": f"«{word}» is a high-frequency {exam_short} word.",
                    "cn": f"«{word}» 是{exam_label}高频词。",
                },
            }
        )
    return collocations


def build_memory_tips(word: str, definition_cn: str, exam_label: str) -> dict:
    first = definition_cn.split("；")[0].split(";")[0].strip()
    return {
        "etymology": f"{exam_label}大纲词汇，常见于历年真题阅读与听力。",
        "mnemonic": f"记住 {word}：{first or f'{exam_label}释义'}",
        "association": f"联想：{word} → {first or f'{exam_label}释义'}",
    }


def convert_word(index: int, entry: dict, spec: BookSpec) -> dict | None:
    word = str(entry.get("word", "")).strip()
    if not word:
        return None

    translations = entry.get("translations") or []
    definition_cn = combine_definition(translations)
    if not definition_cn:
        return None

    primary_pos = normalize_pos(
        str(translations[0].get("type", "")) if translations else "n"
    )
    sentences = entry.get("sentences") or []
    phrases = entry.get("phrases") or []

    return {
        "id": f"{spec.book_id}_{index}",
        "word": word,
        "phoneticUk": format_phonetic(
            str(entry.get("uk", "")),
            fallback=str(entry.get("us", "")),
            word=word,
        ),
        "phoneticUs": format_phonetic(
            str(entry.get("us", "")),
            fallback=str(entry.get("uk", "")),
            word=word,
        ),
        "partOfSpeech": primary_pos,
        "definitionCn": definition_cn,
        "examples": build_examples(
            sentences, word, spec.exam_label, spec.exam_short
        ),
        "synonyms": build_synonyms(word, phrases, spec.exam_label),
        "root": "",
        "definitions": build_definitions(translations),
        "englishDefinitions": build_english_definitions(word, translations),
        "collocations": build_collocations(
            word, phrases, spec.exam_label, spec.exam_short
        ),
        "memoryTips": build_memory_tips(word, definition_cn, spec.exam_label),
    }


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
        cache = ROOT / "tools" / f"_{spec.cache_prefix}_{file_name}"
        batch = download_source(file_name, cache)
        stats["raw"] += len(batch)
        for entry in batch:
            word_raw = str(entry.get("word", "")).strip()
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
                entry = {**entry, "word": word}
            merged.append(entry)

    return merged, stats


def build_book(spec: BookSpec) -> dict[str, int]:
    source, stats = merge_sources(spec)

    words: list[dict] = []
    for index, entry in enumerate(source, start=1):
        converted = convert_word(index, entry, spec)
        if converted:
            words.append(converted)
        else:
            stats["skipped_invalid"] += 1

    book = {
        "bookId": spec.book_id,
        "bookName": spec.book_name,
        "description": spec.description,
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

    print(f"✓ 已生成 {spec.output_name}：{len(words)} 词")
    print(f"  原始条目：{stats['raw']}，去重跳过：{stats['skipped_dup']}")
    if stats["skipped_invalid"]:
        print(f"  无效跳过：{stats['skipped_invalid']}")
    if stats["skipped_corrupt"]:
        print(f"  损坏跳过：{stats['skipped_corrupt']}")
    print(f"  来源：KyleBing/english-vocabulary {', '.join(spec.source_files)}")
    return stats