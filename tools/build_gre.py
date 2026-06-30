#!/usr/bin/env python3
"""从 KyleBing/english-vocabulary GRE_2/3 合并生成 GRE 词书。"""

from vocab_book_builder import BookSpec, build_book

GRE_SPEC = BookSpec(
    book_id="GRE",
    output_name="GRE.json",
    source_files=("GRE_2.json", "GRE_3.json"),
    cache_prefix="gre",
    book_name="GRE 核心词汇",
    description=(
        "GRE 词库（GRE_2+3 合并去重；"
        "源数据 13714 条）| content-v1"
    ),
    category="gre",
    difficulty="GRE",
    cover_color="#C62828",
    exam_label="GRE",
    exam_short="GRE",
)


def main() -> None:
    build_book(GRE_SPEC)


if __name__ == "__main__":
    main()