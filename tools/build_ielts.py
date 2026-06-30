#!/usr/bin/env python3
"""从 KyleBing/english-vocabulary IELTS_2/3 合并生成雅思词书。"""

from vocab_book_builder import BookSpec, build_book

IELTS_SPEC = BookSpec(
    book_id="IELTS",
    output_name="IELTS.json",
    source_files=("IELTS_2.json", "IELTS_3.json"),
    cache_prefix="ielts",
    book_name="雅思核心词汇",
    description=(
        "雅思词库（IELTS_2+3 合并去重；"
        "源数据 7002 条）| content-v1"
    ),
    category="ielts",
    difficulty="雅思",
    cover_color="#00796B",
    exam_label="雅思",
    exam_short="IELTS",
)


def main() -> None:
    build_book(IELTS_SPEC)


if __name__ == "__main__":
    main()