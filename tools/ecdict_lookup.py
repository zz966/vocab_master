#!/usr/bin/env python3
"""可选 ECDICT 本地词库查询（构建时交叉校验，不打包进 App）。"""

from __future__ import annotations

import csv
import re
import sqlite3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TOOLS_DIR = ROOT / "tools"

CSV_CANDIDATES = (
    TOOLS_DIR / "ecdict.csv",
    TOOLS_DIR / "ecdict" / "ecdict.csv",
)
DB_CANDIDATES = (
    TOOLS_DIR / "ecdict.db",
    TOOLS_DIR / "ecdict" / "stardict.db",
)


def _split_translation(text: str) -> list[str]:
    parts: list[str] = []
    for line in (text or "").replace("\\n", "\n").splitlines():
        chunk = line.strip()
        if not chunk:
            continue
        chunk = re.sub(r"^[a-z]+\.\s*", "", chunk, flags=re.IGNORECASE)
        parts.append(chunk)
    return parts


class EcdictLookup:
    """懒加载 ECDICT；未放置本地文件时静默跳过。"""

    def __init__(self) -> None:
        self._loaded = False
        self._entries: dict[str, dict[str, str]] = {}
        self._source = ""

    @property
    def available(self) -> bool:
        self._ensure_loaded()
        return bool(self._entries)

    @property
    def source(self) -> str:
        self._ensure_loaded()
        return self._source

    def _ensure_loaded(self) -> None:
        if self._loaded:
            return
        self._loaded = True
        for path in DB_CANDIDATES:
            if path.exists():
                self._load_sqlite(path)
                if self._entries:
                    self._source = str(path)
                    return
        for path in CSV_CANDIDATES:
            if path.exists():
                self._load_csv(path)
                if self._entries:
                    self._source = str(path)
                    return

    def _load_sqlite(self, path: Path) -> None:
        try:
            conn = sqlite3.connect(f"file:{path}?mode=ro", uri=True)
            conn.row_factory = sqlite3.Row
            rows = conn.execute(
                "SELECT word, phonetic, translation, definition FROM stardict"
            ).fetchall()
            conn.close()
        except sqlite3.Error:
            return

        for row in rows:
            word = str(row["word"] or "").strip().lower()
            if not word:
                continue
            self._entries[word] = {
                "phonetic": str(row["phonetic"] or "").strip(),
                "translation": str(row["translation"] or "").strip(),
                "definition": str(row["definition"] or "").strip(),
            }

    def _load_csv(self, path: Path) -> None:
        try:
            with path.open(encoding="utf-8", newline="") as handle:
                reader = csv.DictReader(handle)
                for row in reader:
                    word = str(row.get("word", "")).strip().lower()
                    if not word:
                        continue
                    self._entries[word] = {
                        "phonetic": str(row.get("phonetic", "")).strip(),
                        "translation": str(row.get("translation", "")).strip(),
                        "definition": str(row.get("definition", "")).strip(),
                    }
        except (OSError, csv.Error):
            return

    def lookup(self, word: str) -> dict[str, str] | None:
        self._ensure_loaded()
        return self._entries.get(word.strip().lower())

    def translation_segments(self, word: str) -> list[str]:
        entry = self.lookup(word)
        if not entry:
            return []
        return _split_translation(entry.get("translation", ""))

    def translation_matches(self, word: str, definition_cn: str) -> bool | None:
        """返回 True/False 表示是否匹配；None 表示无本地 ECDICT 数据。"""
        segments = self.translation_segments(word)
        if not segments:
            return None

        normalized = definition_cn.lower()
        for segment in segments:
            piece = segment.strip().lower()
            if not piece:
                continue
            if piece in normalized or normalized in piece:
                return True
            for token in re.split(r"[；;，,/、\s]+", piece):
                token = token.strip()
                if len(token) >= 2 and token in normalized:
                    return True
        return False