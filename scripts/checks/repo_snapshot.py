#!/usr/bin/env python3
"""Sentinel AI — deterministic working-tree snapshot.

Usage:
    python scripts/checks/repo_snapshot.py capture [--repo PATH]
    python scripts/checks/repo_snapshot.py compare BEFORE.json AFTER.json

capture
    Writes a JSON snapshot to standard output. It never writes into the repository.

    File set: ``git ls-files -z --cached --others --exclude-standard`` (tracked files
    plus non-ignored untracked files; .gitignore exclusions apply). Ignored files are
    outside the snapshot boundary. There is no filesystem walk.

    Per-file entry hash: sha256(path_bytes + b"\\0" + content_bytes).
    working_tree_content_hash: sha256 over the entry hashes in byte-sorted path order.
    This is a working-tree hash; it is independent of any Git commit or tree object.

compare
    Reports added, removed, and changed paths, plus commit_count and remotes
    differences, as JSON on standard output.
    Exit codes: 0 = identical, 1 = differences found, 2 = usage or input error.

Standard library only.
"""

from __future__ import annotations

import datetime as _dt
import hashlib
import json
import os
import subprocess
import sys

SCHEMA = "sentinel-repo-snapshot/v1"


def _git(repo: str, *args: str, check: bool = True) -> subprocess.CompletedProcess:
    return subprocess.run(
        ["git", "-C", repo, *args],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=check,
    )


def _sha256(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def capture(repo: str | None) -> dict:
    start = repo or os.getcwd()
    top = _git(start, "rev-parse", "--show-toplevel").stdout.decode("utf-8").strip()

    listing = _git(top, "ls-files", "-z", "--cached", "--others", "--exclude-standard").stdout
    raw_paths = sorted({p for p in listing.split(b"\0") if p})

    files: dict[str, str] = {}
    entry_hashes: list[str] = []
    for raw in raw_paths:
        full = os.path.join(top, os.fsdecode(raw))
        try:
            with open(full, "rb") as handle:
                content = handle.read()
            entry = _sha256(raw + b"\0" + content)
        except FileNotFoundError:
            # Listed by Git (for example a deleted tracked file) but absent on disk.
            entry = "MISSING:" + _sha256(raw + b"\0")
        files[raw.decode("utf-8", "surrogateescape")] = entry
        entry_hashes.append(entry)

    aggregate = _sha256("\n".join(entry_hashes).encode("ascii", "surrogateescape"))

    count_proc = _git(top, "rev-list", "--all", "--count", check=False)
    commit_count = int(count_proc.stdout.decode().strip()) if count_proc.returncode == 0 else 0
    head_proc = _git(top, "rev-parse", "--verify", "-q", "HEAD", check=False)
    head = "present" if head_proc.returncode == 0 else "none"

    porcelain = _git(top, "status", "--porcelain=v1", "-z", "--untracked-files=all").stdout
    remotes = _git(top, "remote", "-v").stdout.decode("utf-8", "replace").strip().splitlines()

    return {
        "schema": SCHEMA,
        "timestamp_utc": _dt.datetime.now(_dt.timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "repo_root": top,
        "commit_count": commit_count,
        "head": head,
        "remotes": remotes,
        "porcelain_hash": _sha256(porcelain),
        "working_tree_content_hash": aggregate,
        "file_count": len(files),
        "files": files,
    }


def compare(before: dict, after: dict) -> dict:
    for snap in (before, after):
        if snap.get("schema") != SCHEMA or not isinstance(snap.get("files"), dict):
            raise ValueError("input is not a " + SCHEMA + " snapshot")
    b_files, a_files = before["files"], after["files"]
    added = sorted(set(a_files) - set(b_files))
    removed = sorted(set(b_files) - set(a_files))
    changed = sorted(p for p in set(a_files) & set(b_files) if a_files[p] != b_files[p])
    return {
        "added": added,
        "removed": removed,
        "changed": changed,
        "commit_count_before": before.get("commit_count"),
        "commit_count_after": after.get("commit_count"),
        "commit_count_equal": before.get("commit_count") == after.get("commit_count"),
        "remotes_equal": before.get("remotes") == after.get("remotes"),
        "identical": not (added or removed or changed)
        and before.get("commit_count") == after.get("commit_count")
        and before.get("remotes") == after.get("remotes"),
    }


def main(argv: list[str]) -> int:
    try:
        if len(argv) >= 1 and argv[0] == "capture":
            repo = None
            if len(argv) == 3 and argv[1] == "--repo":
                repo = argv[2]
            elif len(argv) != 1:
                raise ValueError("usage: capture [--repo PATH]")
            json.dump(capture(repo), sys.stdout, indent=2, sort_keys=True)
            sys.stdout.write("\n")
            return 0
        if len(argv) == 3 and argv[0] == "compare":
            with open(argv[1], encoding="utf-8") as handle:
                before = json.load(handle)
            with open(argv[2], encoding="utf-8") as handle:
                after = json.load(handle)
            result = compare(before, after)
            json.dump(result, sys.stdout, indent=2, sort_keys=True)
            sys.stdout.write("\n")
            return 0 if result["identical"] else 1
        raise ValueError(
            "usage: repo_snapshot.py capture [--repo PATH] | compare BEFORE.json AFTER.json"
        )
    except (ValueError, OSError, json.JSONDecodeError, subprocess.CalledProcessError) as exc:
        print(f"repo_snapshot: {exc}", file=sys.stderr)
        return 2


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
