#!/usr/bin/env python3
"""从 KyleBing/english-vocabulary TOEFL_2/3 合并生成托福词书。"""

from vocab_book_builder import BookSpec, build_book

TOEFL_SPEC = BookSpec(
    book_id="TOEFL",
    output_name="TOEFL.json",
    source_files=("TOEFL_2.json", "TOEFL_3.json"),
    cache_prefix="toefl",
    book_name="托福核心词汇",
    description=(
        "托福词库（TOEFL_2+3 合并去重；"
        "源数据 13477 条）| content-v1"
    ),
    category="toefl",
    difficulty="托福",
    cover_color="#1565C0",
    exam_label="托福",
    exam_short="TOEFL",
)


def main() -> None:
    build_book(TOEFL_SPEC)


if __name__ == "__main__":
    main()