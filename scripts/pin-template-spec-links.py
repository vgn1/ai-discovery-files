#!/usr/bin/env python3
"""
Pin template/example spec links to a specific repository ref (tag/branch/SHA).

Updates links in templates/* and examples/* that match:
https://github.com/GenerellAI/ai-discovery-files/blob/<ref>/specs/<file>.md

where <ref> may be a branch name, release tag, or commit SHA.
"""

from __future__ import annotations

import argparse
import pathlib
import re
import subprocess
import sys


REPO_URL_PREFIX = "https://github.com/GenerellAI/ai-discovery-files/blob/"
LINK_PATTERN = re.compile(
    r"https://github\.com/GenerellAI/ai-discovery-files/blob/"
    r"([A-Za-z0-9._-]+)/specs/([A-Za-z0-9._-]+\.md)"
)


def get_head_sha() -> str:
    result = subprocess.run(
        ["git", "rev-parse", "HEAD"],
        check=True,
        capture_output=True,
        text=True,
    )
    return result.stdout.strip()


def iter_target_files(root: pathlib.Path):
    for folder_name in ("templates", "examples"):
        base = root / folder_name
        if not base.exists():
            continue
        for path in sorted(base.rglob("*")):
            if path.suffix.lower() in {".txt", ".html", ".json"} and path.is_file():
                yield path


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--ref",
        help="Repository ref to pin to (tag/branch/SHA). Defaults to current git HEAD SHA.",
    )
    parser.add_argument(
        "--sha",
        help="Deprecated alias for --ref (commit SHA).",
    )
    parser.add_argument(
        "--check",
        action="store_true",
        help="Do not write files; exit non-zero if any changes would be made.",
    )
    args = parser.parse_args()

    repo_root = pathlib.Path(__file__).resolve().parents[1]
    try:
        ref = (args.ref or args.sha or get_head_sha()).strip()
    except subprocess.CalledProcessError as exc:
        print(f"error: failed to resolve git HEAD SHA: {exc}", file=sys.stderr)
        return 2

    if not re.fullmatch(r"[A-Za-z0-9._-]+", ref):
        print(f"error: invalid ref '{ref}'", file=sys.stderr)
        return 2

    replacements_applied = 0
    links_matched = 0
    files_changed = 0

    def repl(match: re.Match[str]) -> str:
        nonlocal replacements_applied, links_matched
        links_matched += 1
        filename = match.group(2)
        replacement = f"{REPO_URL_PREFIX}{ref}/specs/{filename}"
        if match.group(0) != replacement:
            replacements_applied += 1
        return replacement

    for path in iter_target_files(repo_root):
        original = path.read_text(encoding="utf-8")
        updated = LINK_PATTERN.sub(repl, original)
        if updated != original:
            files_changed += 1
            if not args.check:
                path.write_text(updated, encoding="utf-8")
            print(f"{'WOULD UPDATE' if args.check else 'UPDATED'} {path.relative_to(repo_root)}")

    action = "Would update" if args.check else "Updated"
    print(
        f"{action} {files_changed} file(s), {replacements_applied} link(s) "
        f"(matched {links_matched}) to ref {ref}."
    )

    if args.check and files_changed:
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
