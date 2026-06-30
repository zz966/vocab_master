#!/usr/bin/env python3
"""从 KyleBing/english-vocabulary CET6_1/2/3 合并生成完整六级词书。"""

from vocab_book_builder import BookSpec, build_book

CET6_SPEC = BookSpec(
    book_id="CET6_CORE",
    output_name="cet6_core.json",
    source_files=("CET6_1.json", "CET6_2.json", "CET6_3.json"),
    cache_prefix="cet6",
    book_name="大学英语六级词汇",
    description=(
        "六级完整词库（CET6_1+2+3 合并，3991 个不重复单词；"
        "源数据 5651 条）| content-v1"
    ),
    category="cet6",
    difficulty="六级",
    cover_color="#9C27B0",
    exam_label="六级",
    exam_short="CET-6",
)


def main() -> None:
    build_book(CET6_SPEC)


if __name__ == "__main__":
    main()