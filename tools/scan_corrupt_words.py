#!/usr/bin/env python3
"""扫描词书中明显损坏的单词（OCR 错字、释义误入 word 字段等）。"""

from __future__ import annotations

import json
import sys
from pathlib import Path

from word_validation import fix_word, word_issue

ROOT = Path(__file__).resolve().parents[1]
BOOKS_DIR = ROOT / "assets" / "books"


def scan_book(path: Path) -> list[tuple[str, str, str, str]]:
    data = json.loads(path.read_text(encoding="utf-8"))
    issues: list[tuple[str, str, str, str]] = []
    for entry in data.get("words") or []:
        word = str(entry.get("word", ""))
        reason = word_issue(word)
        if reason:
            issues.append(
                (
                    str(entry.get("id", "")),
                    word,
                    reason,
                    str(entry.get("definitionCn", ""))[:60],
                )
            )
    return issues


def main() -> int:
    paths = sorted(p for p in BOOKS_DIR.glob("*.json") if not p.name.startswith("_"))
    total = 0
    for path in paths:
        issues = scan_book(path)
        if not issues:
            continue
        total += len(issues)
        print(f"=== {path.name} ({len(issues)}) ===")
        for word_id, word, reason, definition in issues:
            fix = fix_word(word) or ""
            suffix = f" -> {fix!r}" if fix else ""
            print(f"  {word_id}: {word!r} [{reason}]{suffix} {definition}")
    if total == 0:
        print("未发现明显损坏词条")
        return 0
    print(f"\n共 {total} 条")
    return 1


if __name__ == "__main__":
    sys.exit(main())