#!/usr/bin/env python3
"""从 KyleBing/english-vocabulary SAT_2/3 合并生成 SAT 词书。"""

from vocab_book_builder import BookSpec, build_book

SAT_SPEC = BookSpec(
    book_id="SAT",
    output_name="SAT.json",
    source_files=("SAT_2.json", "SAT_3.json"),
    cache_prefix="sat",
    book_name="SAT 核心词汇",
    description=(
        "SAT 词库（SAT_2+3 合并去重；"
        "源数据 8887 条）| content-v1"
    ),
    category="sat",
    difficulty="SAT",
    cover_color="#5E35B1",
    exam_label="SAT",
    exam_short="SAT",
)


def main() -> None:
    build_book(SAT_SPEC)


if __name__ == "__main__":
    main()