#!/usr/bin/env python3
"""準備 MkDocs 的暫存文件樹，不改動原始 Markdown 筆記。"""

from __future__ import annotations

import re
import shutil
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DEST = ROOT / ".site-docs"
SKIP_PREFIXES = (
    ".github/",
    "docs-assets/",
    "overrides/",
    "scripts/",
    "site/",
    ".site-docs/",
)
SKIP_FILES = {"mkdocs.yml", "requirements-docs.txt"}
CONTENT_SUFFIXES = {
    ".md",
    ".png",
    ".jpg",
    ".jpeg",
    ".gif",
    ".webp",
    ".svg",
    ".pdf",
}


def tracked_files() -> list[Path]:
    output = subprocess.check_output(
        ["git", "ls-files", "-z"], cwd=ROOT
    ).decode("utf-8")
    return [Path(item) for item in output.split("\0") if item]


def site_path(source: Path) -> Path:
    if source.name.casefold() == "readme.md":
        return source.with_name("index.md")
    return source


def rewrite_markdown(content: str) -> str:
    # MkDocs 的 section index 使用 index.md；原始 repo 繼續維持 GitHub 慣用的 README.md。
    return re.sub(r"README\.md(?=([#?)\s]|$))", "index.md", content)


def main() -> None:
    if DEST.exists():
        shutil.rmtree(DEST)
    DEST.mkdir(parents=True)

    copied = 0
    for relative in tracked_files():
        posix = relative.as_posix()
        if (
            relative.name in SKIP_FILES
            or posix.startswith(SKIP_PREFIXES)
            or relative.suffix.casefold() not in CONTENT_SUFFIXES
        ):
            continue
        source = ROOT / relative
        if not source.is_file():
            continue

        target = DEST / site_path(relative)
        target.parent.mkdir(parents=True, exist_ok=True)
        if source.suffix.casefold() == ".md":
            content = source.read_text(encoding="utf-8")
            target.write_text(rewrite_markdown(content), encoding="utf-8")
        else:
            shutil.copy2(source, target)
        copied += 1

    print(f"Prepared {copied} tracked files in {DEST}")


if __name__ == "__main__":
    main()
