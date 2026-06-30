#!/usr/bin/env python3
"""修正 assets/books/*.json 中损坏的单词词条。"""

from __future__ import annotations

import json
import sys
from pathlib import Path

from word_validation import fix_word, replace_word_in_entry, word_issue

ROOT = Path(__file__).resolve().parents[1]
BOOKS_DIR = ROOT / "assets" / "books"
SOURCE_CACHE_DIR = ROOT / "tools"


def clean_source_caches() -> list[str]:
    actions: list[str] = []
    for path in sorted(SOURCE_CACHE_DIR.glob("_*.json")):
        try:
            data = json.loads(path.read_text(encoding="utf-8"))
        except json.JSONDecodeError:
            continue
        if not isinstance(data, list):
            continue

        kept: list[dict] = []
        removed: list[str] = []
        for entry in data:
            word = str(entry.get("word", ""))
            if word_issue(word):
                removed.append(word)
                continue
            kept.append(entry)

        if not removed:
            continue

        path.write_text(
            json.dumps(kept, ensure_ascii=False) + "\n",
            encoding="utf-8",
        )
        actions.append(f"{path.name}: 删除 {removed}")
    return actions


def clean_book(path: Path) -> list[str]:
    data = json.loads(path.read_text(encoding="utf-8"))
    words: list[dict] = list(data.get("words") or [])
    actions: list[str] = []

    existing = {
        str(entry.get("word", "")).strip().lower()
        for entry in words
        if str(entry.get("word", "")).strip()
    }

    kept: list[dict] = []
    for entry in words:
        word = str(entry.get("word", "")).strip()
        issue = word_issue(word)
        if not issue:
            kept.append(entry)
            continue

        corrected = fix_word(word)
        if corrected and corrected.lower() not in existing:
            replace_word_in_entry(entry, word, corrected)
            existing.add(corrected.lower())
            kept.append(entry)
            actions.append(f"修正 {word!r} → {corrected!r}")
            continue

        actions.append(f"删除 {word!r} ({issue})")
        existing.discard(word.lower())

    if len(kept) == len(words):
        return actions

    data["words"] = kept
    data["totalWords"] = len(kept)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    actions.append(f"更新 totalWords={len(kept)}")
    return actions


def main() -> int:
    cache_actions = clean_source_caches()
    if cache_actions:
        print("源缓存清理：")
        for action in cache_actions:
            print(f"  · {action}")

    book_actions: list[str] = []
    for path in sorted(p for p in BOOKS_DIR.glob("*.json") if not p.name.startswith("_")):
        actions = clean_book(path)
        if actions:
            book_actions.append(path.name)
            print(f"{path.name}:")
            for action in actions:
                print(f"  · {action}")

    if not cache_actions and not book_actions:
        print("未发现需要修正的损坏词条")
        return 0

    print("\n完成。建议运行: python tools/validate_book_json.py")
    return 0


if __name__ == "__main__":
    sys.exit(main())