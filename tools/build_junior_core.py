#!/usr/bin/env python3
"""从 KyleBing/english-vocabulary 初中系列合并生成初中词书。"""

from vocab_book_builder import BookSpec, build_book

JUNIOR_SOURCE_FILES = (
    "ChuZhong_2.json",
    "ChuZhong_3.json",
    "PEPChuZhong7_1.json",
    "PEPChuZhong7_2.json",
    "PEPChuZhong8_1.json",
    "PEPChuZhong8_2.json",
    "PEPChuZhong9_1.json",
    *tuple(f"WaiYanSheChuZhong_{i}.json" for i in range(1, 7)),
)

JUNIOR_SPEC = BookSpec(
    book_id="JUNIOR_CORE",
    output_name="junior_core.json",
    source_files=JUNIOR_SOURCE_FILES,
    cache_prefix="junior",
    book_name="初中核心词汇",
    description=(
        "初中词库（ChuZhong+人教+外研社 合并去重；"
        "源数据 7705 条）| content-v1"
    ),
    category="junior",
    difficulty="初中",
    cover_color="#F9A825",
    exam_label="初中",
    exam_short="Junior",
)


def main() -> None:
    build_book(JUNIOR_SPEC)


if __name__ == "__main__":
    main()