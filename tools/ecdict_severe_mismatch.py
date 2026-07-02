#!/usr/bin/env python3
"""从 ECDICT 审计结果中筛选「中文释义完全对不上」的词条并导出。

判定标准（比 ecdict_audit 的「释义存疑」更严格）：
  词书 definition_cn 与 ECDICT translation 之间，
  不存在长度≥2 的中文释义片段互为包含/重叠。

用法：
  python tools/ecdict_severe_mismatch.py
  python tools/ecdict_severe_mismatch.py --book GRE.json
"""

from __future__ import annotations

import argparse
import json
import sys
from dataclasses import asdict, dataclass
from pathlib import Path

from ecdict_audit import BookAuditReport, WordAuditItem, audit_book
from ecdict_definition_utils import is_severe_definition_mismatch
from ecdict_lookup import EcdictLookup

ROOT = Path(__file__).resolve().parents[1]
BOOKS_DIR = ROOT / "assets" / "books"
REPORTS_DIR = ROOT / "tools" / "reports"


def is_severe_mismatch(item: WordAuditItem) -> bool:
    if not item.ecdict_translation.strip():
        return False
    return is_severe_definition_mismatch(item.definition_cn, item.ecdict_translation)


@dataclass
class SevereMismatchReport:
    book_id: str
    book_file: str
    severe_mismatch_count: int
    items: list[WordAuditItem]


def collect_severe(report: BookAuditReport) -> SevereMismatchReport:
    severe = [item for item in report.definition_mismatch if is_severe_mismatch(item)]
    return SevereMismatchReport(
        book_id=report.book_id,
        book_file=report.book_file,
        severe_mismatch_count=len(severe),
        items=sorted(severe, key=lambda x: x.word.lower()),
    )


def write_outputs(reports: list[SevereMismatchReport]) -> tuple[Path, Path]:
    REPORTS_DIR.mkdir(parents=True, exist_ok=True)

    all_items: list[dict] = []
    for report in reports:
        for item in report.items:
            row = asdict(item)
            row["book_id"] = report.book_id
            row["book_file"] = report.book_file
            all_items.append(row)

        per_book_tsv = REPORTS_DIR / f"ecdict_severe_mismatch_{report.book_id}.tsv"
        _write_tsv(per_book_tsv, report.items, book_id=report.book_id)

    json_path = REPORTS_DIR / "ecdict_severe_mismatch_all.json"
    json_path.write_text(
        json.dumps(all_items, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )

    tsv_path = REPORTS_DIR / "ecdict_severe_mismatch_all.tsv"
    _write_tsv(tsv_path, all_items, include_book=True)

    summary_path = REPORTS_DIR / "ecdict_severe_mismatch_summary.json"
    summary_path.write_text(
        json.dumps(
            [
                {
                    "book_id": r.book_id,
                    "book_file": r.book_file,
                    "severe_mismatch_count": r.severe_mismatch_count,
                }
                for r in reports
            ],
            ensure_ascii=False,
            indent=2,
        )
        + "\n",
        encoding="utf-8",
    )
    return json_path, tsv_path


def _write_tsv(
    path: Path,
    rows: list,
    *,
    book_id: str = "",
    include_book: bool = False,
) -> None:
    headers = ["book_id", "id", "word", "definition_cn", "ecdict_translation", "ecdict_phonetic"]
    if not include_book:
        headers = [h for h in headers if h != "book_id"]

    lines = ["\t".join(headers)]
    for row in rows:
        if isinstance(row, dict):
            item = row
        else:
            item = asdict(row)
            if book_id:
                item = {"book_id": book_id, **item}

        def cell(key: str) -> str:
            return str(item.get(key, "")).replace("\t", " ").replace("\n", " / ")

        if include_book:
            lines.append(
                "\t".join(
                    [
                        cell("book_id"),
                        cell("id"),
                        cell("word"),
                        cell("definition_cn"),
                        cell("ecdict_translation"),
                        cell("ecdict_phonetic"),
                    ]
                )
            )
        else:
            lines.append(
                "\t".join(
                    [
                        cell("id"),
                        cell("word"),
                        cell("definition_cn"),
                        cell("ecdict_translation"),
                        cell("ecdict_phonetic"),
                    ]
                )
            )
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser(description="导出释义完全不符词条")
    parser.add_argument("--book", help="只处理指定词书，如 GRE.json")
    args = parser.parse_args()

    lookup = EcdictLookup()
    if not lookup.available:
        print("未找到 ECDICT 本地词库，请先放置 tools/ecdict/stardict.db", file=sys.stderr)
        return 1

    if args.book:
        paths = [BOOKS_DIR / args.book]
    else:
        paths = sorted(
            p
            for p in BOOKS_DIR.glob("*.json")
            if not p.name.startswith("_") and p.name != "test_40.json"
        )

    severe_reports: list[SevereMismatchReport] = []
    print(f"ECDICT 来源：{lookup.source}\n")
    for path in paths:
        audit = audit_book(path, lookup)
        severe = collect_severe(audit)
        severe_reports.append(severe)
        print(
            f"{severe.book_file}: 释义存疑 {len(audit.definition_mismatch)} → "
            f"完全不符 {severe.severe_mismatch_count}"
        )

    json_path, tsv_path = write_outputs(severe_reports)
    total = sum(r.severe_mismatch_count for r in severe_reports)
    print(f"\n共 {total} 条完全不符")
    print(f"汇总 JSON：{REPORTS_DIR / 'ecdict_severe_mismatch_summary.json'}")
    print(f"全部明细 JSON：{json_path}")
    print(f"全部明细 TSV：{tsv_path}")
    return 0


if __name__ == "__main__":
    sys.exit(main())