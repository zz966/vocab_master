#!/usr/bin/env python3
"""校验 assets/books/*.json 词书格式。

默认（publish）：真实内容标准 + 禁止模板占位。
--strict：旧版 test_40 富内容标准（3 条例句、近义词必填等）。
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

from synthetic_content import count_synthetic_words, word_has_synthetic_content
from word_validation import word_issue

ROOT = Path(__file__).resolve().parents[1]
BOOKS_DIR = ROOT / "assets" / "books"

REQUIRED_BOOK_KEYS = {
    "bookId",
    "bookName",
    "description",
    "totalWords",
    "category",
    "words",
}


def validate_word(
    word: dict,
    index: int,
    book_id: str,
    *,
    strict: bool,
) -> list[str]:
    errors: list[str] = []
    prefix = f"words[{index}]"

    for key in ("id", "word", "definitionCn"):
        if not str(word.get(key, "")).strip():
            errors.append(f"{prefix}: 缺少 {key}")

    word_text = str(word.get("word", "")).strip()
    corrupt = word_issue(word_text)
    if corrupt:
        errors.append(f"{prefix}: 损坏单词 {word_text!r} ({corrupt})")

    word_id = str(word.get("id", ""))
    if word_id and not word_id.startswith(f"{book_id}_"):
        errors.append(f"{prefix}: id 建议以 {book_id}_ 为前缀，当前为 {word_id}")

    examples = word.get("examples") or []
    if strict and len(examples) < 3:
        errors.append(f"{prefix}: examples 至少 3 条")

    phonetic_uk = str(word.get("phoneticUk", "")).strip()
    phonetic_us = str(word.get("phoneticUs", "")).strip()
    if strict:
        for field in ("phoneticUk", "phoneticUs"):
            if not str(word.get(field, "")).strip():
                errors.append(f"{prefix}: 缺少 {field}")
    elif not phonetic_uk and not phonetic_us:
        errors.append(f"{prefix}: phoneticUk / phoneticUs 至少填一项")

    definitions = word.get("definitions")
    if not definitions:
        errors.append(f"{prefix}: 缺少 definitions")

    if strict and word.get("englishDefinitions") is None:
        errors.append(f"{prefix}: 缺少 englishDefinitions")

    synonyms = word.get("synonyms") or []
    if strict and not synonyms:
        errors.append(f"{prefix}: 缺少 synonyms")
    else:
        for syn_index, entry in enumerate(synonyms):
            if isinstance(entry, dict) and not str(entry.get("meaning", "")).strip():
                errors.append(f"{prefix}.synonyms[{syn_index}]: 缺少 meaning")

    collocations = word.get("collocations") or []
    for col_index, phrase in enumerate(collocations):
        if not isinstance(phrase, dict):
            continue
        example = phrase.get("example") or {}
        if example and not str(example.get("en", "")).strip():
            errors.append(
                f"{prefix}.collocations[{col_index}]: example.en 不能为空"
            )

    if not strict and word_has_synthetic_content(word):
        errors.append(f"{prefix}: 含模板/占位合成内容")

    return errors


def validate_book(path: Path, *, strict: bool) -> list[str]:
    errors: list[str] = []
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        return [f"{path.name}: JSON 解析失败 — {exc}"]

    missing = REQUIRED_BOOK_KEYS - data.keys()
    if missing:
        errors.append(f"{path.name}: 缺少顶层字段 {sorted(missing)}")

    book_id = str(data.get("bookId", "")).strip()
    if not book_id:
        errors.append(f"{path.name}: bookId 不能为空")

    words = data.get("words") or []
    if not isinstance(words, list) or not words:
        errors.append(f"{path.name}: words 必须为非空数组")

    declared = data.get("totalWords")
    if isinstance(declared, int) and declared != len(words):
        errors.append(
            f"{path.name}: totalWords={declared} 与 words 实际数量 {len(words)} 不一致"
        )

    seen_ids: set[str] = set()
    for index, word in enumerate(words):
        if not isinstance(word, dict):
            errors.append(f"words[{index}]: 必须是对象")
            continue
        word_id = str(word.get("id", ""))
        if word_id in seen_ids:
            errors.append(f"words[{index}]: 重复 id {word_id}")
        seen_ids.add(word_id)
        errors.extend(validate_word(word, index, book_id, strict=strict))

    if not strict:
        synthetic_count = count_synthetic_words(words)
        if synthetic_count:
            errors.append(
                f"{path.name}: 含合成内容词条 {synthetic_count}/{len(words)}"
            )

    return errors


def main() -> int:
    parser = argparse.ArgumentParser(description="校验 assets/books 词书 JSON")
    parser.add_argument(
        "--strict",
        action="store_true",
        help="使用 test_40 旧版富内容标准（允许手工精修词书）",
    )
    args = parser.parse_args()

    paths = sorted(
        p for p in BOOKS_DIR.glob("*.json") if not p.name.startswith("_")
    )
    if not paths:
        print(f"未找到词书 JSON：{BOOKS_DIR}")
        return 1

    all_errors: list[str] = []
    for path in paths:
        strict = args.strict or path.name == "test_40.json"
        all_errors.extend(validate_book(path, strict=strict))

    mode = "strict" if args.strict else "publish"
    if all_errors:
        print(f"校验失败（{mode}）：")
        for error in all_errors:
            print(f"  - {error}")
        return 1

    print(f"✓ {len(paths)} 个词书文件全部通过校验（{mode}）")
    for path in paths:
        data = json.loads(path.read_text(encoding="utf-8"))
        print(f"  · {path.name}: {data.get('bookId')} — {len(data.get('words', []))} 词")
    return 0


if __name__ == "__main__":
    sys.exit(main())