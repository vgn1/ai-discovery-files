#!/usr/bin/env python3
"""
check-dependency-map.py

First-pass validator for specs/dependency-map.yaml.

It currently enforces only:
- relationType: exact_match
- comparisonRule: literal

Other relation/comparison types are intentionally skipped for manual review.
"""

from __future__ import annotations

import json
import pathlib
import re
import sys
from typing import Any, Dict, List, Optional, Tuple


def emit(level: str, message: str) -> None:
    print(f"{level}\t{message}")


def parse_json_compatible_yaml(path: pathlib.Path) -> Tuple[Optional[Dict[str, Any]], Optional[str]]:
    try:
        text = path.read_text(encoding="utf-8")
    except OSError as exc:
        return None, f"Unable to read dependency map at {path}: {exc}"
    try:
        data = json.loads(text)
    except json.JSONDecodeError as exc:
        return None, (
            f"Dependency map is not JSON-compatible YAML ({path}): "
            f"{exc.msg} at line {exc.lineno}, column {exc.colno}"
        )
    if not isinstance(data, dict):
        return None, "Dependency map root must be an object."
    return data, None


def extract_from_line_prefix(text: str, prefix: str) -> Optional[str]:
    for line in text.splitlines():
        if line.startswith(prefix):
            return line[len(prefix) :].strip()
    return None


def parse_json_path(path_expr: str) -> List[Any]:
    # Supports dot paths with optional integer index syntax, e.g. a.b[0].c
    tokens: List[Any] = []
    for part in path_expr.split("."):
        if part == "":
            continue
        match = re.fullmatch(r"([A-Za-z0-9_-]+)(\[[0-9]+\])?", part)
        if not match:
            tokens.append(part)
            continue
        key = match.group(1)
        tokens.append(key)
        idx = match.group(2)
        if idx:
            tokens.append(int(idx[1:-1]))
    return tokens


def extract_from_json_path(data: Any, path_expr: str) -> Optional[Any]:
    current = data
    for token in parse_json_path(path_expr):
        if isinstance(token, int):
            if not isinstance(current, list):
                return None
            if token < 0 or token >= len(current):
                return None
            current = current[token]
            continue
        if not isinstance(current, dict):
            return None
        if token not in current:
            return None
        current = current[token]
    return current


def extract_selector_value(
    templates_dir: pathlib.Path,
    file_name: str,
    selector: Dict[str, Any],
) -> Tuple[Optional[str], Optional[str], str]:
    file_path = templates_dir / file_name
    if not file_path.exists():
        return None, f"{file_name} does not exist.", "missing_file"

    selector_type = selector.get("type")
    selector_value = selector.get("value")

    if selector_type == "line_prefix":
        try:
            text = file_path.read_text(encoding="utf-8")
        except OSError as exc:
            return None, f"Could not read {file_name}: {exc}", "read_error"
        value = extract_from_line_prefix(text, str(selector_value))
        if value is None:
            return None, f"{file_name} is missing line prefix '{selector_value}'.", "missing_selector"
        return value, None, "ok"

    if selector_type == "canonical_identity_key":
        try:
            data = json.loads(file_path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError) as exc:
            return None, f"Could not parse JSON file {file_name}: {exc}", "read_error"

        block = data.get("canonicalIdentityBlock")
        if not isinstance(block, str):
            return None, f"{file_name} has no string canonicalIdentityBlock.", "missing_selector"

        prefix = f"{selector_value}: "
        value = extract_from_line_prefix(block, prefix)
        if value is None:
            return None, f"{file_name} canonicalIdentityBlock is missing '{selector_value}:'.", "missing_selector"
        return value, None, "ok"

    if selector_type == "json_path":
        try:
            data = json.loads(file_path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError) as exc:
            return None, f"Could not parse JSON file {file_name}: {exc}", "read_error"
        value = extract_from_json_path(data, str(selector_value))
        if value is None:
            return None, f"{file_name} json_path '{selector_value}' not found.", "missing_selector"
        if isinstance(value, (dict, list)):
            return json.dumps(value, sort_keys=True), None, "ok"
        return str(value).strip(), None, "ok"

    return None, f"Unsupported selector type '{selector_type}' in {file_name}.", "unsupported_selector"


def compare_literal(source_value: str, target_value: str) -> bool:
    return source_value == target_value


def severity_to_level(severity: str) -> str:
    if severity == "warning":
        return "WARN"
    return "FAIL"


def file_priority(files_map: Dict[str, Any], file_name: str) -> str:
    info = files_map.get(file_name, {})
    if isinstance(info, dict):
        return str(info.get("priority", "recommended"))
    return "recommended"


def is_required_priority(priority: str) -> bool:
    return priority == "required"


def run_first_pass(templates_dir: pathlib.Path, dep_map: Dict[str, Any]) -> None:
    files_map = dep_map.get("files", {})
    if not isinstance(files_map, dict):
        files_map = {}

    fields = dep_map.get("fieldDependencies", [])
    if not isinstance(fields, list):
        emit("FAIL", "dependency-map fieldDependencies must be an array.")
        return

    emit("INFO", f"Loaded dependency map with {len(fields)} field dependency entries.")

    exact_rules = 0
    for field in fields:
        if not isinstance(field, dict):
            continue

        relation = field.get("relationType")
        comparison = field.get("comparisonRule")
        if relation != "exact_match" or comparison != "literal":
            continue

        exact_rules += 1
        field_id = str(field.get("fieldId", "unknown_field"))
        severity = str(field.get("severity", "error"))
        source = field.get("source", {})
        targets = field.get("targets", [])
        if not isinstance(source, dict) or not isinstance(targets, list):
            emit("FAIL", f"{field_id}: invalid source or targets structure.")
            continue

        source_file = str(source.get("file", ""))
        source_selector = source.get("selector", {})
        if not source_file or not isinstance(source_selector, dict):
            emit("FAIL", f"{field_id}: missing source file or selector.")
            continue

        source_value, source_error, _source_code = extract_selector_value(
            templates_dir, source_file, source_selector
        )
        if source_error:
            level = severity_to_level(severity)
            emit(level, f"{field_id}: {source_error}")
            continue

        for target in targets:
            if not isinstance(target, dict):
                emit("FAIL", f"{field_id}: target entry is not an object.")
                continue
            target_file = str(target.get("file", ""))
            target_selector = target.get("selector", {})
            if not target_file or not isinstance(target_selector, dict):
                emit("FAIL", f"{field_id}: target missing file or selector.")
                continue

            target_value, target_error, target_code = extract_selector_value(
                templates_dir, target_file, target_selector
            )
            if target_error:
                priority = file_priority(files_map, target_file)
                if target_code == "missing_file" and not is_required_priority(priority):
                    emit(
                        "WARN",
                        f"{field_id}: skipped {target_file} (priority: {priority}, file not present).",
                    )
                else:
                    level = severity_to_level(severity)
                    emit(level, f"{field_id}: {target_error}")
                continue

            if compare_literal(source_value, target_value):
                emit("PASS", f"{field_id}: {target_file} matches {source_file}.")
            else:
                level = severity_to_level(severity)
                emit(
                    level,
                    (
                        f"{field_id}: {target_file} differs from {source_file} "
                        f"(source='{source_value}' target='{target_value}')."
                    ),
                )

    emit("INFO", f"First-pass exact-match rules evaluated: {exact_rules}.")


def main() -> int:
    if len(sys.argv) != 3:
        emit("FAIL", "Usage: check-dependency-map.py <templates_dir> <dependency_map_path>")
        return 0

    templates_dir = pathlib.Path(sys.argv[1]).resolve()
    dep_map_path = pathlib.Path(sys.argv[2]).resolve()

    if not templates_dir.exists():
        emit("FAIL", f"Templates directory does not exist: {templates_dir}")
        return 0

    dep_map, error = parse_json_compatible_yaml(dep_map_path)
    if error:
        emit("FAIL", error)
        return 0

    run_first_pass(templates_dir, dep_map)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
