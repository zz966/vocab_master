#!/usr/bin/env python3
"""从 KyleBing/english-vocabulary CET4_1/2/3 合并生成完整四级词书。"""

from vocab_book_builder import BookSpec, build_book

CET4_SPEC = BookSpec(
    book_id="CET4_CORE",
    output_name="cet4_core.json",
    source_files=("CET4_1.json", "CET4_2.json", "CET4_3.json"),
    cache_prefix="cet4",
    book_name="大学英语四级词汇",
    description=(
        "四级完整词库（CET4_1+2+3 合并，4544 个不重复单词；"
        "源数据 7508 条含重复拼写项）| content-v2"
    ),
    category="cet4",
    difficulty="四级",
    cover_color="#3F51B5",
    exam_label="四级",
    exam_short="CET-4",
)


def main() -> None:
    build_book(CET4_SPEC)


if __name__ == "__main__":
    main()