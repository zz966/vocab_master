#!/usr/bin/env python3
"""检测词书中的脚本模板/占位内容（与 vocab_book_builder 历史版本对齐）。"""

from __future__ import annotations

import re

TEMPLATE_EXAMPLE_EN = re.compile(
    r"appears often in .+ reading(?: passages)? \(\d+\)",
    re.IGNORECASE,
)
TEMPLATE_EXAMPLE_CN = re.compile(r"在.+阅读中经常出现（例句 \d+）")
PLACEHOLDER_SYNONYMS = frozenset({"related term", "common usage", "exam vocabulary"})
TEMPLATE_COLLOCATION_EN = re.compile(
    r"Students should know how to use .+ in context\.",
    re.IGNORECASE,
)
TEMPLATE_COLLOCATION_CN = re.compile(r"考生需要掌握短语「.+」")
TEMPLATE_COLLOCATION_FALLBACK_EN = re.compile(
    r"is a high-frequency .+ word\.$",
    re.IGNORECASE,
)
TEMPLATE_COLLOCATION_FALLBACK_CN = re.compile(r"是.+高频词。$")
TEMPLATE_ENGLISH_DEF = re.compile(r"^English word «.+»: ")
TEMPLATE_MEMORY_ETYMOLOGY = re.compile(r".+大纲词汇，常见于历年真题阅读与听力。$")
TEMPLATE_MEMORY_MNEMONIC = re.compile(r"^记住 .+：")
TEMPLATE_MEMORY_ASSOCIATION = re.compile(r"^联想：.+ → ")


def is_template_example(example: dict) -> bool:
    en = str(example.get("en", "")).strip()
    cn = str(example.get("cn", "")).strip()
    return bool(TEMPLATE_EXAMPLE_EN.search(en) or TEMPLATE_EXAMPLE_CN.search(cn))


def is_placeholder_synonym(entry: dict) -> bool:
    return str(entry.get("word", "")).strip().lower() in PLACEHOLDER_SYNONYMS


def is_template_collocation(collocation: dict) -> bool:
    example = collocation.get("example") or {}
    en = str(example.get("en", "")).strip()
    cn = str(example.get("cn", "")).strip()
    phrase = str(collocation.get("phrase", "")).strip()
    translation = str(collocation.get("translation", "")).strip()

    if TEMPLATE_COLLOCATION_EN.search(en) or TEMPLATE_COLLOCATION_CN.search(cn):
        return True
    return bool(
        phrase
        and translation == "单词本身"
        and TEMPLATE_COLLOCATION_FALLBACK_EN.search(en)
        and TEMPLATE_COLLOCATION_FALLBACK_CN.search(cn)
    )


def is_template_english_def(entry: dict) -> bool:
    return bool(TEMPLATE_ENGLISH_DEF.match(str(entry.get("meaning", "")).strip()))


def is_template_memory_tips(tips: dict) -> bool:
    etymology = str(tips.get("etymology", "")).strip()
    mnemonic = str(tips.get("mnemonic", "")).strip()
    association = str(tips.get("association", "")).strip()
    return bool(
        TEMPLATE_MEMORY_ETYMOLOGY.match(etymology)
        and TEMPLATE_MEMORY_MNEMONIC.match(mnemonic)
        and TEMPLATE_MEMORY_ASSOCIATION.match(association)
    )


def word_has_synthetic_content(word: dict) -> bool:
    for example in word.get("examples") or []:
        if is_template_example(example):
            return True

    for synonym in word.get("synonyms") or []:
        if is_placeholder_synonym(synonym):
            return True

    for collocation in word.get("collocations") or []:
        if is_template_collocation(collocation):
            return True

    for definition in word.get("englishDefinitions") or []:
        if is_template_english_def(definition):
            return True

    tips = word.get("memoryTips") or {}
    if isinstance(tips, dict) and is_template_memory_tips(tips):
        return True

    return False


def count_synthetic_words(words: list[dict]) -> int:
    return sum(1 for word in words if word_has_synthetic_content(word))