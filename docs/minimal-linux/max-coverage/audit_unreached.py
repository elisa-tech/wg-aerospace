#!/usr/bin/env python3
# SPDX-License-Identifier: CC-BY-SA-4.0
import json
import os
import sys
from collections import defaultdict
from pathlib import Path


def load_stage_lines(stage_dir):
    executed = set()
    executable = set()
    reports = sorted(Path(stage_dir).rglob("*.gcov.json.gz"))
    if not reports:
        raise ValueError(f"no gcov inventories in {stage_dir}")
    for report in reports:
        with gzip.open(report, "rt", encoding="utf-8") as stream:
            unit = json.load(stream)
        for source in unit["files"]:
            path = os.path.relpath(os.path.realpath(source["file"]))
            for line in source["lines"]:
                key = (path, line["line_number"])
                executable.add(key)
                if line["count"] > 0:
                    executed.add(key)
    return executed, executable


if __name__ == "__main__":
    import gzip
    dwarf_report = sys.argv[1] if len(sys.argv) > 1 else "linked.json"
    stage_dir = sys.argv[2] if len(sys.argv) > 2 else "stage3_syzkaller"

    with open(dwarf_report, encoding="utf-8") as f:
        dwarf = json.load(f)
    dwarf_lines = defaultdict(set)
    for entry in dwarf.get("source_lines", []):
        fpath = os.path.relpath(os.path.realpath(entry["file"]))
        dwarf_lines[fpath].add(entry["line"])

    executed, executable = load_stage_lines(stage_dir)
    executed_lines = defaultdict(set)
    for source, line in executed:
        executed_lines[source].add(line)

    ranked = []
    for fpath, lines in dwarf_lines.items():
        unreached = lines - executed_lines.get(fpath, set())
        pct = len(unreached) / len(lines) * 100
        ranked.append((fpath, len(lines), len(unreached), pct))
    ranked.sort(key=lambda x: x[2], reverse=True)

    header = (f"{'Source File':<40} | {'Linked SLOC':<12} | "
              f"{'Unreached':<10} | {'% Unreached':<12}")
    print(header)
    print("-" * 80)
    for fpath, total, unreached, pct in ranked[:15]:
        print(f"{fpath:<40} | {total:<12} | {unreached:<10} | {pct:5.1f}%")
