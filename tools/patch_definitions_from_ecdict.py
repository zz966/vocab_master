#!/usr/bin/env python3
"""用 ECDICT 批量修正「释义完全不符」词条（最快修复路径）。

只处理 severe mismatch 词条，不动已通过校验的词。
默认先 dry-run 预览，确认后加 --apply 写回 assets/books/*.json。

用法：
  python tools/patch_definitions_from_ecdict.py              # 预览
  python tools/patch_definitions_from_ecdict.py --apply      # 写回词书
  python tools/patch_definitions_from_ecdict.py --book GRE.json --apply
"""

from __future__ import annotations

import argparse
import json
import sys
from dataclasses import asdict, dataclass
from datetime import datetime, timezone
from pathlib import Path

from ecdict_audit import audit_book
from ecdict_definition_utils import (
    apply_ecdict_definitions_to_word,
    is_severe_definition_mismatch,
)
from ecdict_lookup import EcdictLookup
from ecdict_severe_mismatch import collect_severe

ROOT = Path(__file__).resolve().parents[1]
BOOKS_DIR = ROOT / "assets" / "books"
REPORTS_DIR = ROOT / "tools" / "reports"


@dataclass
class PatchRecord:
    book_id: str
    id: str
    word: str
    old_definition_cn: str
    new_definition_cn: str


def patch_book_file(
    book_path: Path,
    lookup: EcdictLookup,
    *,
    apply: bool,
) -> tuple[int, list[PatchRecord]]:
    audit = audit_book(book_path, lookup)
    severe = collect_severe(audit)
    target_ids = {item.id for item in severe.items}
    if not target_ids:
        return 0, []

    data = json.loads(book_path.read_text(encoding="utf-8"))
    records: list[PatchRecord] = []
    patched = 0

    for word in data.get("words") or []:
        word_id = str(word.get("id", ""))
        if word_id not in target_ids:
            continue

        ecdict = lookup.lookup(str(word.get("word", "")))
        if not ecdict:
            continue

        translation = str(ecdict.get("translation", "")).strip()
        if not translation:
            continue

        old_cn = str(word.get("definitionCn", "")).strip()
        if not is_severe_definition_mismatch(old_cn, translation):
            continue

        preview = json.loads(json.dumps(word, ensure_ascii=False))
        if not apply_ecdict_definitions_to_word(preview, translation):
            continue

        records.append(
            PatchRecord(
                book_id=str(data.get("bookId", "")),
                id=word_id,
                word=str(word.get("word", "")),
                old_definition_cn=old_cn,
                new_definition_cn=str(preview.get("definitionCn", "")),
            )
        )

        if apply:
            word["definitionCn"] = preview["definitionCn"]
            word["definitions"] = preview["definitions"]
            if preview.get("partOfSpeech"):
                word["partOfSpeech"] = preview["partOfSpeech"]
            patched += 1

    if apply and patched:
        book_path.write_text(
            json.dumps(data, ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )

    return patched, records


def main() -> int:
    parser = argparse.ArgumentParser(description="用 ECDICT 批量修正严重释义不符")
    parser.add_argument("--apply", action="store_true", help="写回 assets/books（默认仅预览）")
    parser.add_argument("--book", help="只处理指定词书，如 GRE.json")
    args = parser.parse_args()

    lookup = EcdictLookup()
    if not lookup.available:
        print("未找到 ECDICT 本地词库", file=sys.stderr)
        return 1

    if args.book:
        paths = [BOOKS_DIR / args.book]
    else:
        paths = sorted(
            p
            for p in BOOKS_DIR.glob("*.json")
            if not p.name.startswith("_") and p.name != "test_40.json"
        )

    all_records: list[PatchRecord] = []
    total = 0
    mode = "APPLY" if args.apply else "DRY-RUN"
    print(f"模式：{mode}\n")

    for path in paths:
        count, records = patch_book_file(path, lookup, apply=args.apply)
        total += count
        all_records.extend(records)
        print(f"{path.name}: {'将修正' if not args.apply else '已修正'} {len(records)} 条")
        for record in records[:3]:
            print(f"  · {record.word}")
            print(f"    旧：{record.old_definition_cn}")
            print(f"    新：{record.new_definition_cn}")
        if len(records) > 3:
            print(f"  ... 另有 {len(records) - 3} 条")

    REPORTS_DIR.mkdir(parents=True, exist_ok=True)
    log_name = "patch_definitions_log.json" if args.apply else "patch_definitions_preview.json"
    log_path = REPORTS_DIR / log_name
    log_path.write_text(
        json.dumps(
            {
                "mode": mode,
                "timestamp": datetime.now(timezone.utc).isoformat(),
                "total": len(all_records),
                "records": [asdict(record) for record in all_records],
            },
            ensure_ascii=False,
            indent=2,
        )
        + "\n",
        encoding="utf-8",
    )

    print(f"\n合计：{len(all_records)} 条")
    print(f"日志：{log_path}")
    if not args.apply:
        print("\n确认后执行：python tools/patch_definitions_from_ecdict.py --apply")
    else:
        print("\n建议接着运行：")
        print("  python tools/validate_book_json.py")
        print("  python tools/ecdict_severe_mismatch.py")
    return 0


if __name__ == "__main__":
    sys.exit(main())