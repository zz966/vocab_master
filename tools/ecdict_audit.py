#!/usr/bin/env python3
"""对 assets/books/*.json 做 ECDICT 事后审计，定位释义存疑 / 缺音标词条。

用法：
  python tools/ecdict_audit.py              # 审计全部词书
  python tools/ecdict_audit.py --book GRE.json
  python tools/ecdict_audit.py --book GRE.json --tsv   # 额外导出 TSV 便于 Excel 打开

报告输出：tools/reports/ecdict_audit_<bookId>.json
"""

from __future__ import annotations

import argparse
import json
import sys
from dataclasses import asdict, dataclass, field
from pathlib import Path

from ecdict_lookup import EcdictLookup

ROOT = Path(__file__).resolve().parents[1]
BOOKS_DIR = ROOT / "assets" / "books"
REPORTS_DIR = ROOT / "tools" / "reports"


@dataclass
class WordAuditItem:
    id: str
    word: str
    definition_cn: str
    phonetic_uk: str
    phonetic_us: str
    ecdict_translation: str = ""
    ecdict_phonetic: str = ""
    ecdict_definition: str = ""


@dataclass
class BookAuditReport:
    book_id: str
    book_file: str
    ecdict_source: str
    total_words: int
    verified: int = 0
    definition_mismatch: list[WordAuditItem] = field(default_factory=list)
    missing_phonetic: list[WordAuditItem] = field(default_factory=list)
    phonetic_fillable: list[WordAuditItem] = field(default_factory=list)
    not_in_ecdict: list[WordAuditItem] = field(default_factory=list)


def _has_phonetic(word: dict) -> bool:
    return bool(str(word.get("phoneticUk", "")).strip()) or bool(
        str(word.get("phoneticUs", "")).strip()
    )


def _audit_word(word: dict, lookup: EcdictLookup) -> tuple[str, ...]:
    """返回词条触发的审计标签（可多个）。"""
    text = str(word.get("word", "")).strip()
    definition_cn = str(word.get("definitionCn", "")).strip()
    ecdict = lookup.lookup(text) or {}
    ecdict_translation = ecdict.get("translation", "")
    ecdict_phonetic = ecdict.get("phonetic", "")
    ecdict_definition = ecdict.get("definition", "")

    tags: list[str] = []
    match = lookup.translation_matches(text, definition_cn)
    if match is True:
        tags.append("verified")
    elif match is False:
        tags.append("definition_mismatch")
    else:
        tags.append("not_in_ecdict")

    if not _has_phonetic(word):
        tags.append("missing_phonetic")
        if ecdict_phonetic:
            tags.append("phonetic_fillable")

    item = WordAuditItem(
        id=str(word.get("id", "")),
        word=text,
        definition_cn=definition_cn,
        phonetic_uk=str(word.get("phoneticUk", "")).strip(),
        phonetic_us=str(word.get("phoneticUs", "")).strip(),
        ecdict_translation=ecdict_translation,
        ecdict_phonetic=ecdict_phonetic,
        ecdict_definition=ecdict_definition,
    )
    return tuple(tags), item


def audit_book(path: Path, lookup: EcdictLookup) -> BookAuditReport:
    data = json.loads(path.read_text(encoding="utf-8"))
    book_id = str(data.get("bookId", path.stem))
    report = BookAuditReport(
        book_id=book_id,
        book_file=path.name,
        ecdict_source=lookup.source,
        total_words=len(data.get("words") or []),
    )

    seen_tags: dict[str, set[str]] = {
        "definition_mismatch": set(),
        "missing_phonetic": set(),
        "phonetic_fillable": set(),
        "not_in_ecdict": set(),
    }
    buckets: dict[str, list[WordAuditItem]] = {
        "definition_mismatch": [],
        "missing_phonetic": [],
        "phonetic_fillable": [],
        "not_in_ecdict": [],
    }

    for word in data.get("words") or []:
        if not isinstance(word, dict):
            continue
        tags, item = _audit_word(word, lookup)
        if "verified" in tags:
            report.verified += 1
        for tag in ("definition_mismatch", "missing_phonetic", "phonetic_fillable", "not_in_ecdict"):
            if tag not in tags:
                continue
            word_key = item.id or item.word
            if word_key in seen_tags[tag]:
                continue
            seen_tags[tag].add(word_key)
            buckets[tag].append(item)

    report.definition_mismatch = sorted(buckets["definition_mismatch"], key=lambda x: x.word.lower())
    report.missing_phonetic = sorted(buckets["missing_phonetic"], key=lambda x: x.word.lower())
    report.phonetic_fillable = sorted(buckets["phonetic_fillable"], key=lambda x: x.word.lower())
    report.not_in_ecdict = sorted(buckets["not_in_ecdict"], key=lambda x: x.word.lower())
    return report


def write_report(report: BookAuditReport, *, write_tsv: bool) -> Path:
    REPORTS_DIR.mkdir(parents=True, exist_ok=True)
    out_json = REPORTS_DIR / f"ecdict_audit_{report.book_id}.json"
    payload = asdict(report)
    out_json.write_text(
        json.dumps(payload, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )

    if write_tsv:
        for category in (
            "definition_mismatch",
            "missing_phonetic",
            "phonetic_fillable",
            "not_in_ecdict",
        ):
            rows = getattr(report, category)
            if not rows:
                continue
            out_tsv = REPORTS_DIR / f"ecdict_audit_{report.book_id}_{category}.tsv"
            lines = [
                "id\tword\tdefinition_cn\tphonetic_uk\tphonetic_us\t"
                "ecdict_translation\tecdict_phonetic\tecdict_definition"
            ]
            for row in rows:
                lines.append(
                    "\t".join(
                        [
                            row.id,
                            row.word,
                            row.definition_cn.replace("\t", " "),
                            row.phonetic_uk,
                            row.phonetic_us,
                            row.ecdict_translation.replace("\n", " / ").replace("\t", " "),
                            row.ecdict_phonetic,
                            row.ecdict_definition.replace("\n", " / ").replace("\t", " "),
                        ]
                    )
                )
            out_tsv.write_text("\n".join(lines) + "\n", encoding="utf-8")
    return out_json


def print_summary(report: BookAuditReport, report_path: Path) -> None:
    print(f"=== {report.book_file} ({report.book_id}) ===")
    print(f"  词数：{report.total_words}")
    print(f"  ECDICT 校验通过：{report.verified}")
    print(f"  释义存疑：{len(report.definition_mismatch)}")
    print(f"  缺少音标：{len(report.missing_phonetic)}")
    print(f"  可由 ECDICT 补音标：{len(report.phonetic_fillable)}")
    print(f"  ECDICT 未收录：{len(report.not_in_ecdict)}")
    print(f"  报告：{report_path}")
    if report.definition_mismatch[:3]:
        print("  释义存疑示例：")
        for item in report.definition_mismatch[:3]:
            print(f"    - {item.word}: 词书={item.definition_cn!r}")
            if item.ecdict_translation:
                preview = item.ecdict_translation.replace("\n", " / ")[:80]
                print(f"      ECDICT={preview!r}")
    if report.missing_phonetic[:3]:
        print("  缺音标示例：")
        for item in report.missing_phonetic[:3]:
            hint = f"（ECDICT: {item.ecdict_phonetic}）" if item.ecdict_phonetic else ""
            print(f"    - {item.word}{hint}")


def main() -> int:
    parser = argparse.ArgumentParser(description="ECDICT 词书事后审计")
    parser.add_argument(
        "--book",
        help="只审计指定文件名，如 GRE.json",
    )
    parser.add_argument(
        "--tsv",
        action="store_true",
        help="额外导出 TSV 分类清单",
    )
    args = parser.parse_args()

    lookup = EcdictLookup()
    if not lookup.available:
        print(
            "未找到 ECDICT 本地词库。请放置：\n"
            "  tools/ecdict.db  或  tools/ecdict/stardict.db\n"
            "  tools/ecdict.csv 或  tools/ecdict/ecdict.csv\n"
            "下载：https://github.com/skywind3000/ECDICT",
            file=sys.stderr,
        )
        return 1

    if args.book:
        paths = [BOOKS_DIR / args.book]
        if not paths[0].exists():
            print(f"文件不存在：{paths[0]}", file=sys.stderr)
            return 1
    else:
        paths = sorted(
            p for p in BOOKS_DIR.glob("*.json") if not p.name.startswith("_")
        )

    print(f"ECDICT 来源：{lookup.source}\n")
    for path in paths:
        if path.name == "test_40.json":
            continue
        report = audit_book(path, lookup)
        report_path = write_report(report, write_tsv=args.tsv)
        print_summary(report, report_path)
        print()

    return 0


if __name__ == "__main__":
    sys.exit(main())