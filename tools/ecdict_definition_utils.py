#!/usr/bin/env python3
"""ECDICT 释义解析与严重不符判定（供构建/补丁脚本共用）。"""

from __future__ import annotations

import re

POS_PREFIX_RE = re.compile(
    r"^(?:[a-z]{1,4}\.&?\s*|[计医化]+\.\s*)+",
    re.IGNORECASE,
)
CN_TOKEN_RE = re.compile(r"[\u4e00-\u9fff]{2,}")
LINE_POS_RE = re.compile(r"^([a-z]{1,4}\.?)\s+(.+)$", re.IGNORECASE)

POS_MAP = {
    "n": "n.",
    "v": "v.",
    "vt": "v.",
    "vi": "v.",
    "adj": "adj.",
    "a": "adj.",
    "adv": "adv.",
    "prep": "prep.",
    "conj": "conj.",
    "pron": "pron.",
    "art": "art.",
    "num": "num.",
    "int": "int.",
}


def normalize_pos(pos: str) -> str:
    key = (pos or "").strip().lower().rstrip(".")
    return POS_MAP.get(key, f"{key}." if key else "")


def _normalize_cn_text(text: str) -> str:
    cleaned = POS_PREFIX_RE.sub("", text.strip())
    cleaned = re.sub(r"\s+", "", cleaned)
    return cleaned.lower()


def _meaning_tokens(text: str) -> set[str]:
    normalized = _normalize_cn_text(text)
    tokens: set[str] = set()
    for chunk in re.split(r"[；;，,/、\s\(\)（）\[\]【】]+", normalized):
        chunk = chunk.strip()
        if len(chunk) >= 2:
            tokens.add(chunk)
    for match in CN_TOKEN_RE.finditer(normalized):
        tokens.add(match.group())
    return {token for token in tokens if len(token) >= 2}


def has_meaning_overlap(book_cn: str, ecdict_cn: str) -> bool:
    book_tokens = _meaning_tokens(book_cn)
    ecdict_tokens = _meaning_tokens(ecdict_cn)
    if not book_tokens or not ecdict_tokens:
        return False

    ecdict_flat = _normalize_cn_text(ecdict_cn)
    book_flat = _normalize_cn_text(book_cn)

    for book_token in book_tokens:
        if book_token in ecdict_flat:
            return True
        for ecdict_token in ecdict_tokens:
            if book_token in ecdict_token or ecdict_token in book_token:
                return True
    for ecdict_token in ecdict_tokens:
        if ecdict_token in book_flat:
            return True
    return False


def is_severe_definition_mismatch(book_cn: str, ecdict_cn: str) -> bool:
    if not book_cn.strip() or not ecdict_cn.strip():
        return False
    return not has_meaning_overlap(book_cn, ecdict_cn)


def _split_meaning_clauses(text: str) -> list[str]:
    parts: list[str] = []
    for chunk in re.split(r"[；;，,]+", text):
        piece = chunk.strip()
        if piece:
            parts.append(piece)
    return parts or [text.strip()]


def parse_ecdict_translation(translation: str) -> list[dict[str, str]]:
    """将 ECDICT translation 解析为 definitions 列表。"""
    definitions: list[dict[str, str]] = []
    seen: set[tuple[str, str]] = set()

    raw = (translation or "").replace("\\n", "\n")
    for line in raw.splitlines():
        line = line.strip()
        if not line:
            continue
        for segment in re.split(r"\s*/\s*", line):
            segment = segment.strip()
            if not segment or segment.startswith("["):
                continue

            pos = ""
            meaning_body = segment
            match = LINE_POS_RE.match(segment)
            if match:
                pos = normalize_pos(match.group(1))
                meaning_body = match.group(2).strip()

            for clause in _split_meaning_clauses(meaning_body):
                key = (pos, clause)
                if key in seen:
                    continue
                seen.add(key)
                definitions.append(
                    {"partOfSpeech": pos, "meaning": clause},
                )
    return definitions


def build_definition_cn(definitions: list[dict[str, str]], *, max_items: int = 4) -> str:
    parts: list[str] = []
    for item in definitions[:max_items]:
        pos = item.get("partOfSpeech", "").strip()
        meaning = item.get("meaning", "").strip()
        if not meaning:
            continue
        parts.append(f"{pos} {meaning}" if pos else meaning)
    return "； ".join(parts)


def apply_ecdict_definitions_to_word(word: dict, ecdict_translation: str) -> bool:
    """用 ECDICT 释义覆盖词书词条，返回是否发生修改。"""
    definitions = parse_ecdict_translation(ecdict_translation)
    if not definitions:
        return False

    definition_cn = build_definition_cn(definitions)
    if not definition_cn:
        return False

    old_cn = str(word.get("definitionCn", "")).strip()
    if old_cn == definition_cn:
        return False

    word["definitionCn"] = definition_cn
    word["definitions"] = definitions
    primary_pos = definitions[0].get("partOfSpeech", "")
    if primary_pos:
        word["partOfSpeech"] = primary_pos
    return True