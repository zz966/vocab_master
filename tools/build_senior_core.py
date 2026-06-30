#!/usr/bin/env python3
"""从 KyleBing/english-vocabulary 高中系列合并生成高中词书。"""

from vocab_book_builder import BookSpec, build_book

SENIOR_SOURCE_FILES = (
    "GaoZhong_2.json",
    "GaoZhong_3.json",
    *tuple(f"PEPGaoZhong_{i}.json" for i in range(1, 12)),
    *tuple(f"BeiShiGaoZhong_{i}.json" for i in range(1, 12)),
)

SENIOR_SPEC = BookSpec(
    book_id="SENIOR_CORE",
    output_name="senior_core.json",
    source_files=SENIOR_SOURCE_FILES,
    cache_prefix="senior",
    book_name="高中核心词汇",
    description=(
        "高中词库（GaoZhong+人教+北师大 合并去重；"
        "源数据 13178 条）| content-v1"
    ),
    category="senior",
    difficulty="高中",
    cover_color="#558B2F",
    exam_label="高中",
    exam_short="Senior",
)


def main() -> None:
    build_book(SENIOR_SPEC)


if __name__ == "__main__":
    main()