#!/usr/bin/env python3
"""检测并修正词书中明显损坏的英文单词。"""

from __future__ import annotations

import re

CHINESE_RE = re.compile(r"[\u4e00-\u9fff]")
POS_PREFIX_RE = re.compile(r"^[anv]\.\s", re.IGNORECASE)
DIGIT_TYPO_RE = re.compile(r"^\d+[a-zA-Z]")

# 源数据已知 OCR 错字（小写 key → 正确拼写）
KNOWN_WORD_FIXES: dict[str, str] = {
    "2ussian": "Russia",
}


def word_issue(word: str) -> str | None:
    text = word.strip()
    if not text:
        return "empty"
    if text.lower() in KNOWN_WORD_FIXES:
        return "known_typo"
    if CHINESE_RE.search(text):
        return "chinese_in_word"
    if POS_PREFIX_RE.match(text):
        return "pos_in_word"
    if DIGIT_TYPO_RE.match(text):
        return "digit_typo"
    return None


def fix_word(word: str) -> str | None:
    text = word.strip()
    issue = word_issue(text)
    if issue is None:
        return text
    if issue == "known_typo":
        return KNOWN_WORD_FIXES[text.lower()]
    return None


def replace_word_in_entry(entry: dict, old_word: str, new_word: str) -> None:
    entry["word"] = new_word
    for key in ("phoneticUk", "phoneticUs"):
        value = str(entry.get(key, ""))
        if old_word in value:
            entry[key] = value.replace(old_word, new_word)

    for example in entry.get("examples") or []:
        if isinstance(example, dict):
            for field in ("en", "cn"):
                value = str(example.get(field, ""))
                if old_word in value:
                    example[field] = value.replace(f"«{old_word}»", f"«{new_word}»").replace(
                        f"「{old_word}」", f"「{new_word}」"
                    )

    for definition in (entry.get("definitions") or []) + (
        entry.get("englishDefinitions") or []
    ):
        if isinstance(definition, dict):
            meaning = str(definition.get("meaning", ""))
            if old_word in meaning:
                definition["meaning"] = meaning.replace(
                    f"«{old_word}»", f"«{new_word}»"
                )

    for collocation in entry.get("collocations") or []:
        if not isinstance(collocation, dict):
            continue
        phrase = str(collocation.get("phrase", ""))
        if phrase == old_word:
            collocation["phrase"] = new_word
        example = collocation.get("example") or {}
        if isinstance(example, dict):
            for field in ("en", "cn"):
                value = str(example.get(field, ""))
                if old_word in value:
                    example[field] = value.replace(f"«{old_word}»", f"«{new_word}»")

    tips = entry.get("memoryTips") or {}
    if isinstance(tips, dict):
        for field in ("mnemonic", "association"):
            value = str(tips.get(field, ""))
            if old_word in value:
                tips[field] = value.replace(old_word, new_word)