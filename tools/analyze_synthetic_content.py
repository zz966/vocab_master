#!/usr/bin/env python3
"""统计 assets/books/*.json 中脚本合成内容的占比。"""

from __future__ import annotations

import json
import re
import sys
from dataclasses import dataclass, field
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BOOKS_DIR = ROOT / "assets" / "books"

# 与 vocab_book_builder.py 生成逻辑对齐的检测规则
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


@dataclass
class BookStats:
    book_id: str
    file_name: str
    total_words: int = 0
    words_with_any_synthetic: int = 0
    template_examples: int = 0
    placeholder_synonyms: int = 0
    template_collocations: int = 0
    template_english_defs: int = 0
    template_memory_tips: int = 0
    total_examples: int = 0
    total_synonyms: int = 0
    total_collocations: int = 0
    total_english_defs: int = 0
    build_script: str = ""
    content_version: str = ""

    @property
    def synthetic_field_hits(self) -> int:
        return (
            self.template_examples
            + self.placeholder_synonyms
            + self.template_collocations
            + self.template_english_defs
            + self.template_memory_tips
        )

    def pct(self, part: int, whole: int) -> str:
        if whole == 0:
            return "—"
        return f"{part / whole * 100:.1f}%"


BUILD_SCRIPT_MAP = {
    "CET4_CORE": "build_cet4_core.py",
    "CET6_CORE": "build_cet6_core.py",
    "GRE": "build_gre.py",
    "IELTS": "build_ielts.py",
    "TOEFL": "build_toefl.py",
    "SAT": "build_sat.py",
    "KAOYAN_CORE": "build_kaoyan_core.py",
    "JUNIOR_CORE": "build_junior_core.py",
    "SENIOR_CORE": "build_senior_core.py",
    "TEST_40": "tool/enrich_test_40.py（手工精修）",
}


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
    if (
        phrase
        and translation == "单词本身"
        and TEMPLATE_COLLOCATION_FALLBACK_EN.search(en)
        and TEMPLATE_COLLOCATION_FALLBACK_CN.search(cn)
    ):
        return True
    return False


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


def analyze_word(word: dict, stats: BookStats) -> bool:
    has_synthetic = False

    examples = word.get("examples") or []
    stats.total_examples += len(examples)
    template_example_count = sum(1 for ex in examples if is_template_example(ex))
    if template_example_count:
        stats.template_examples += template_example_count
        has_synthetic = True

    synonyms = word.get("synonyms") or []
    stats.total_synonyms += len(synonyms)
    placeholder_count = sum(1 for syn in synonyms if is_placeholder_synonym(syn))
    if placeholder_count:
        stats.placeholder_synonyms += placeholder_count
        has_synthetic = True

    collocations = word.get("collocations") or []
    stats.total_collocations += len(collocations)
    template_col_count = sum(
        1 for col in collocations if is_template_collocation(col)
    )
    if template_col_count:
        stats.template_collocations += template_col_count
        has_synthetic = True

    english_defs = word.get("englishDefinitions") or []
    stats.total_english_defs += len(english_defs)
    template_def_count = sum(
        1 for definition in english_defs if is_template_english_def(definition)
    )
    if template_def_count:
        stats.template_english_defs += template_def_count
        has_synthetic = True

    tips = word.get("memoryTips") or {}
    if isinstance(tips, dict) and is_template_memory_tips(tips):
        stats.template_memory_tips += 1
        has_synthetic = True

    if has_synthetic:
        stats.words_with_any_synthetic += 1
    return has_synthetic


def extract_content_version(description: str) -> str:
    match = re.search(r"content-v\d+", description)
    return match.group(0) if match else "—"


def analyze_book(path: Path) -> BookStats:
    data = json.loads(path.read_text(encoding="utf-8"))
    book_id = str(data.get("bookId", path.stem))
    stats = BookStats(
        book_id=book_id,
        file_name=path.name,
        build_script=BUILD_SCRIPT_MAP.get(book_id, "未知"),
        content_version=extract_content_version(str(data.get("description", ""))),
    )
    words = data.get("words") or []
    stats.total_words = len(words)
    for word in words:
        analyze_word(word, stats)
    return stats


def print_report(all_stats: list[BookStats]) -> None:
    print("=" * 88)
    print("词书合成内容统计（基于 vocab_book_builder.py 模板规则）")
    print("=" * 88)
    print()

    header = (
        f"{'词书':<18} {'词数':>6} {'含合成词条':>10} {'词条占比':>8} "
        f"{'模板例句':>8} {'占位同义':>8} {'模板搭配':>8} {'模板英义':>8} {'模板记忆':>8}"
    )
    print(header)
    print("-" * len(header))

    for stats in all_stats:
        print(
            f"{stats.file_name:<18} "
            f"{stats.total_words:>6} "
            f"{stats.words_with_any_synthetic:>10} "
            f"{stats.pct(stats.words_with_any_synthetic, stats.total_words):>8} "
            f"{stats.pct(stats.template_examples, stats.total_examples):>8} "
            f"{stats.pct(stats.placeholder_synonyms, stats.total_synonyms):>8} "
            f"{stats.pct(stats.template_collocations, stats.total_collocations):>8} "
            f"{stats.pct(stats.template_english_defs, stats.total_english_defs):>8} "
            f"{stats.pct(stats.template_memory_tips, stats.total_words):>8}"
        )

    print()
    print("明细（生成脚本 / content 版本）：")
    for stats in all_stats:
        print(
            f"  · {stats.book_id}: {stats.build_script} | {stats.content_version} | "
            f"合成字段命中 {stats.synthetic_field_hits} 处"
        )

    print()
    print("字段说明：")
    print("  - 含合成词条：该词至少含 1 处模板/占位内容")
    print("  - 模板例句：appears often in ... reading (N)")
    print("  - 占位同义：related term / common usage / exam vocabulary")
    print("  - 模板搭配：Students should know... / «X» is a high-frequency...")
    print("  - 模板英义：English word «X»: {中文释义}")
    print("  - 模板记忆：大纲词汇 + 记住 X + 联想 X → 三段式")


def main() -> int:
    paths = sorted(
        p for p in BOOKS_DIR.glob("*.json") if not p.name.startswith("_")
    )
    if not paths:
        print(f"未找到词书：{BOOKS_DIR}")
        return 1

    all_stats = [analyze_book(path) for path in paths]
    print_report(all_stats)
    return 0


if __name__ == "__main__":
    sys.exit(main())