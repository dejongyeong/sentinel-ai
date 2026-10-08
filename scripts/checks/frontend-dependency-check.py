#!/usr/bin/env python3
"""Sentinel AI: frontend dependency restriction check (P1-S-15; Phase 1 task 1.8).

Fails if any package in scripts/checks/frontend-prohibited-packages.txt appears in
the apps/web dependency graph (canonical specification section 6):

- direct: apps/web/package.json (dependencies, devDependencies,
  optionalDependencies, peerDependencies) and the apps/web importer in
  pnpm-lock.yaml (dependencies, devDependencies, optionalDependencies);
- transitive: every snapshot reachable from the apps/web importer through
  dependencies and optionalDependencies, plus transitivePeerDependencies names.

Only the Python standard library is used. The check reads files; it never writes
and never uses the network. It fails closed: any input it cannot fully
understand is an error, never a clean result.

Exit codes:
  0  no prohibited package found
  1  one or more prohibited packages found
  2  the check could not be performed trustworthily

Usage: python scripts/checks/frontend-dependency-check.py [--repo PATH]
"""

import argparse
import json
import re
import sys
from collections import deque
from pathlib import Path

LIST_PATH = "scripts/checks/frontend-prohibited-packages.txt"
MANIFEST_PATH = "apps/web/package.json"
LOCKFILE_PATH = "pnpm-lock.yaml"
IMPORTER = "apps/web"
LOCKFILE_VERSION = "9.0"
MANIFEST_SECTIONS = ("dependencies", "devDependencies", "optionalDependencies", "peerDependencies")
IMPORTER_SECTIONS = ("dependencies", "devDependencies", "optionalDependencies")
IMPORTER_ENTRY_KEYS = {"specifier", "version"}
SNAPSHOT_EDGE_SECTIONS = ("dependencies", "optionalDependencies")
SNAPSHOT_KEYS = {"dependencies", "optionalDependencies", "transitivePeerDependencies", "optional"}
GRAPH_DOCUMENT_KEYS = {"lockfileVersion", "settings", "importers", "packages", "snapshots"}

NAME_RE = re.compile(r"^(@[a-z0-9][a-z0-9._~-]*/)?[a-z0-9][a-z0-9._~-]*$")
SCOPE_RE = re.compile(r"^@[a-z0-9][a-z0-9._~-]*/\*$")
KEY_RE = re.compile(r"^(?P<key>'(?:[^']|'')*'|[^\s'\"#{\[\-][^:]*):(?: (?P<value>.+))?$")


class CheckError(Exception):
    """The check cannot be performed trustworthily (exit 2)."""


# --- prohibited-package list -------------------------------------------------

def load_list(path):
    if not path.is_file():
        raise CheckError(f"prohibited-package list not found: {LIST_PATH}")
    exact, scopes, seen = set(), set(), set()
    for number, raw in enumerate(read_text(path, LIST_PATH).splitlines(), 1):
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        if line in seen:
            raise CheckError(f"{LIST_PATH}:{number}: duplicate entry {line!r}")
        seen.add(line)
        if SCOPE_RE.match(line):
            scopes.add(line[:-1])  # '@scope/'
        elif NAME_RE.match(line):
            exact.add(line)
        else:
            raise CheckError(f"{LIST_PATH}:{number}: invalid entry {line!r}")
    if not seen:
        raise CheckError(f"{LIST_PATH}: no entries")
    return exact, scopes


def is_prohibited(name, exact, scopes):
    return name in exact or any(name.startswith(scope) for scope in scopes)


# --- input helpers -----------------------------------------------------------

def read_text(path, label):
    if not path.is_file():
        raise CheckError(f"required file not found: {label}")
    try:
        return path.read_text(encoding="utf-8")
    except (OSError, UnicodeDecodeError) as exc:
        raise CheckError(f"cannot read {label}: {exc}") from exc


def unquote(token):
    if len(token) >= 2 and token[0] == token[-1] == "'":
        return token[1:-1].replace("''", "'")
    if len(token) >= 2 and token[0] == token[-1] == '"':
        return token[1:-1]
    return token


def parse_scalar(value, number):
    value = value.strip()
    if not value:
        raise CheckError(f"{LOCKFILE_PATH}:{number}: empty value")
    if value == "{}":
        return {}
    if value == "[]":
        return []
    if value[0] in "{[":
        return ("flow", value)  # opaque; never used as graph data
    if value[0] in "&*!|>%@`":
        raise CheckError(f"{LOCKFILE_PATH}:{number}: unsupported YAML value {value!r}")
    return unquote(value)


# --- minimal YAML-subset reader for pnpm lockfile v9 ----------------------------

def parse_document(lines):
    """Parse indentation-based mappings, block sequences and scalars; reject the rest."""
    if not lines:
        return {}
    if lines[0][1] != 0:
        raise CheckError(f"{LOCKFILE_PATH}:{lines[0][0]}: unexpected indentation")
    result, index = parse_block(lines, 0, 0)
    if index != len(lines):
        raise CheckError(f"{LOCKFILE_PATH}:{lines[index][0]}: unexpected indentation")
    return result


def parse_block(lines, index, indent):
    is_list = lines[index][2].startswith("- ")
    result = [] if is_list else {}
    while index < len(lines) and lines[index][1] == indent:
        number, _, text = lines[index]
        if is_list:
            if not text.startswith("- "):
                raise CheckError(f"{LOCKFILE_PATH}:{number}: mixed sequence and mapping")
            result.append(parse_scalar(text[2:], number))
            index += 1
            continue
        match = KEY_RE.match(text)
        if not match:
            raise CheckError(f"{LOCKFILE_PATH}:{number}: unsupported line {text!r}")
        key = unquote(match.group("key").strip())
        if key in result:
            raise CheckError(f"{LOCKFILE_PATH}:{number}: duplicate key {key!r}")
        index += 1
        if match.group("value") is not None:
            result[key] = parse_scalar(match.group("value"), number)
        elif index < len(lines) and lines[index][1] > indent:
            result[key], index = parse_block(lines, index, lines[index][1])
        else:
            result[key] = None
    if index < len(lines) and lines[index][1] > indent:
        raise CheckError(f"{LOCKFILE_PATH}:{lines[index][0]}: unexpected indentation")
    return result, index


def load_lockfile(path):
    documents, current = [], []
    for number, raw in enumerate(read_text(path, LOCKFILE_PATH).splitlines(), 1):
        if raw == "---":
            if current:
                documents.append(current)
            current = []
            continue
        if not raw.strip():
            continue
        if "\t" in raw[: len(raw) - len(raw.lstrip())]:
            raise CheckError(f"{LOCKFILE_PATH}:{number}: tab indentation")
        stripped = raw.lstrip(" ")
        if stripped.startswith("#"):
            raise CheckError(f"{LOCKFILE_PATH}:{number}: comments are not supported")
        current.append((number, len(raw) - len(stripped), stripped.rstrip()))
    if current:
        documents.append(current)
    parsed = [parse_document(document) for document in documents]
    graph = [d for d in parsed if isinstance(d.get("importers"), dict) and IMPORTER in d["importers"]]
    if len(graph) != 1:
        raise CheckError(f"{LOCKFILE_PATH}: expected exactly one document with importer {IMPORTER!r}, found {len(graph)}")
    doc = graph[0]
    if doc.get("lockfileVersion") != LOCKFILE_VERSION:
        raise CheckError(f"{LOCKFILE_PATH}: unsupported lockfileVersion {doc.get('lockfileVersion')!r}")
    unknown = set(doc) - GRAPH_DOCUMENT_KEYS
    if unknown:
        raise CheckError(f"{LOCKFILE_PATH}: unsupported top-level keys {sorted(unknown)}")
    return doc


# --- graph ---------------------------------------------------------------------

def package_name(key):
    at = key.find("@", 1)
    if at <= 0:
        raise CheckError(f"{LOCKFILE_PATH}: cannot read package name from {key!r}")
    return key[:at]


def node_key(name, reference, where):
    """Return the snapshots key that a dependency reference resolves to.

    pnpm lockfile v9 writes a resolved reference in one of two forms:
    - "<version>[(<peer>@<version>)...]", for example "19.3.0(react@19.3.0)":
      the key is "<name>@<reference>", i.e. "react-dom@19.3.0(react@19.3.0)";
    - an alias, "<real-name>@<version>[(...)]", for example "string-width@4.2.3":
      the reference already is the key, and the package is checked under its
      real name.
    The two are told apart by the text before the first "(": a plain version
    contains no "@"; an alias contains "<real-name>@". Any other form ("link:",
    "file:", "workspace:", "npm:") is outside the supported policy and fails
    closed, because its dependencies are not represented in snapshots.
    """
    if not isinstance(reference, str) or not reference:
        raise CheckError(f"{LOCKFILE_PATH}: {where}: missing version for {name!r}")
    if reference.startswith(("link:", "file:", "workspace:", "npm:")):
        raise CheckError(f"{LOCKFILE_PATH}: {where}: unsupported reference {name}: {reference}")
    base = reference.split("(", 1)[0]
    if "@" in base[1:]:
        return reference  # alias: "<real-name>@<version>..."
    return f"{name}@{reference}"  # plain or peer-suffixed version


def mapping(value, where, allow_none=True):
    if value is None and allow_none:
        return {}
    if not isinstance(value, dict):
        raise CheckError(f"{LOCKFILE_PATH}: {where}: expected a mapping")
    return value


def collect(manifest, lock, exact, scopes):
    findings, direct_names = [], set()

    for section in MANIFEST_SECTIONS:
        declared = manifest.get(section, {})
        if not isinstance(declared, dict) or not all(isinstance(v, str) for v in declared.values()):
            raise CheckError(f"{MANIFEST_PATH}: {section} is not a name-to-version mapping")
        for name in declared:
            direct_names.add(name)
            if is_prohibited(name, exact, scopes):
                findings.append(("DIRECT", name, f"{MANIFEST_PATH} {section}"))

    importer = mapping(lock["importers"][IMPORTER], f"importers.{IMPORTER}")
    unknown = set(importer) - set(IMPORTER_SECTIONS)
    if unknown:
        raise CheckError(f"{LOCKFILE_PATH}: importers.{IMPORTER}: unsupported keys {sorted(unknown)}")
    snapshots = mapping(lock.get("snapshots"), "snapshots")
    parent, queue = {}, deque()
    for section in IMPORTER_SECTIONS:
        where = f"importers.{IMPORTER}.{section}"
        for name, entry in sorted(mapping(importer.get(section), where).items()):
            entry = mapping(entry, f"{where}.{name}", allow_none=False)
            if set(entry) != IMPORTER_ENTRY_KEYS:
                raise CheckError(f"{LOCKFILE_PATH}: {where}.{name}: expected keys {sorted(IMPORTER_ENTRY_KEYS)}")
            key = node_key(name, entry["version"], f"{where}.{name}")
            for direct in {name, package_name(key)}:
                direct_names.add(direct)
                if is_prohibited(direct, exact, scopes):
                    findings.append(("DIRECT", direct, f"{LOCKFILE_PATH} {where}"))
            if key not in parent:
                parent[key] = None
                queue.append(key)

    while queue:
        key = queue.popleft()
        if key not in snapshots:
            raise CheckError(f"{LOCKFILE_PATH}: snapshot {key!r} is referenced but missing")
        snapshot = mapping(snapshots[key], f"snapshots.{key}")
        unknown = set(snapshot) - SNAPSHOT_KEYS
        if unknown:
            raise CheckError(f"{LOCKFILE_PATH}: snapshots.{key}: unsupported keys {sorted(unknown)}")
        for section in SNAPSHOT_EDGE_SECTIONS:
            for name, reference in sorted(mapping(snapshot.get(section), f"snapshots.{key}.{section}").items()):
                child = node_key(name, reference, f"snapshots.{key}.{section}")
                if child not in parent:
                    parent[child] = key
                    queue.append(child)
        peers = snapshot.get("transitivePeerDependencies") or []
        if not isinstance(peers, list) or not all(isinstance(p, str) for p in peers):
            raise CheckError(f"{LOCKFILE_PATH}: snapshots.{key}.transitivePeerDependencies is not a list of names")
        for peer in peers:
            if is_prohibited(peer, exact, scopes) and peer not in direct_names:
                findings.append(("TRANSITIVE", peer, f"transitive peer of {chain(key, parent)}"))

    for key in parent:
        name = package_name(key)
        if is_prohibited(name, exact, scopes) and name not in direct_names:
            findings.append(("TRANSITIVE", key, f"via {chain(key, parent)}"))
    return sorted(set(findings)), len(parent)


def chain(key, parent):
    path = []
    while key is not None:
        path.append(key)
        key = parent[key]
    return " > ".join([IMPORTER] + path[::-1])


# --- main ----------------------------------------------------------------------

def main(argv):
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--repo", default=str(Path(__file__).resolve().parents[2]))
    args = parser.parse_args(argv)
    repo = Path(args.repo)
    print("Sentinel AI frontend dependency check (P1-S-15)")
    try:
        exact, scopes = load_list(repo / LIST_PATH)
        try:
            manifest = json.loads(read_text(repo / MANIFEST_PATH, MANIFEST_PATH))
        except json.JSONDecodeError as exc:
            raise CheckError(f"{MANIFEST_PATH}: invalid JSON: {exc}") from exc
        if not isinstance(manifest, dict):
            raise CheckError(f"{MANIFEST_PATH}: not a JSON object")
        lock = load_lockfile(repo / LOCKFILE_PATH)
        findings, reachable = collect(manifest, lock, exact, scopes)
    except CheckError as exc:
        print(f"ERROR: {exc}")
        print("RESULT: ERROR (exit 2): the check could not be performed")
        return 2
    except Exception as exc:  # any unexpected failure is "could not check", never "clean" or "found"
        print(f"ERROR: internal error: {type(exc).__name__}: {exc}")
        print("RESULT: ERROR (exit 2): the check could not be performed")
        return 2
    print(f"list: {len(exact)} names, {len(scopes)} scopes ({LIST_PATH})")
    print(f"graph: {reachable} packages reachable from importer {IMPORTER}")
    for kind, name, where in findings:
        print(f"{kind}  {name}  ({where})")
    if findings:
        print(f"RESULT: FAIL (exit 1): {len(findings)} prohibited package finding(s)")
        return 1
    print("RESULT: PASS (exit 0): no prohibited package found")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
