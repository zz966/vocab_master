#!/usr/bin/env python3
"""从 KyleBing/english-vocabulary KaoYan_1/2/3 合并生成考研词书。"""

from vocab_book_builder import BookSpec, build_book

KAOYAN_SPEC = BookSpec(
    book_id="KAOYAN_CORE",
    output_name="kaoyan_core.json",
    source_files=("KaoYan_1.json", "KaoYan_2.json", "KaoYan_3.json"),
    cache_prefix="kaoyan",
    book_name="考研英语词汇",
    description=(
        "考研词库（KaoYan_1+2+3 合并去重；"
        "源数据 9602 条）| content-v1"
    ),
    category="kaoyan",
    difficulty="考研",
    cover_color="#E65100",
    exam_label="考研",
    exam_short="KaoYan",
)


def main() -> None:
    build_book(KAOYAN_SPEC)


if __name__ == "__main__":
    main()