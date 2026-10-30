#!/usr/bin/env python3
# SPDX-License-Identifier: CC-BY-SA-4.0
"""Audit unreached functions and lines across GCOV checkpoints."""
import gzip
import json
import os
import sys
from collections import defaultdict
from pathlib import Path


def load_stage_lines(
    stage_dir: str | Path,
) -> tuple[set[tuple[str, int]], set[tuple[str, int]]]:
    """Load executed and executable lines from GCOV JSON archives."""
    executed: set[tuple[str, int]] = set()
    executable: set[tuple[str, int]] = set()
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


def main() -> None:
    """Compare DWARF linked lines against runtime executed lines."""
    dwarf_report = sys.argv[1] if len(sys.argv) > 1 else "linked.json"
    stage_dir = sys.argv[2] if len(sys.argv) > 2 else "stage3_syzkaller"

    with open(dwarf_report, encoding="utf-8") as f:
        dwarf = json.load(f)
    dwarf_lines: dict[str, set[int]] = defaultdict(set)
    for entry in dwarf.get("source_lines", []):
        fpath = os.path.relpath(os.path.realpath(entry["file"]))
        dwarf_lines[fpath].add(entry["line"])

    executed, _ = load_stage_lines(stage_dir)
    executed_lines: dict[str, set[int]] = defaultdict(set)
    for src, lnum in executed:
        executed_lines[src].add(lnum)

    ranked = []
    for fpath, lset in dwarf_lines.items():
        unreached = lset - executed_lines.get(fpath, set())
        pct = len(unreached) / len(lset) * 100
        ranked.append((fpath, len(lset), len(unreached), pct))
    ranked.sort(key=lambda x: x[2], reverse=True)

    tbl_header = (f"{'Source File':<40} | {'Linked SLOC':<12} | "
                  f"{'Unreached':<10} | {'% Unreached':<12}")
    print(tbl_header)
    print("-" * 80)
    for fpath, total, unreached_cnt, pct in ranked[:15]:
        print(f"{fpath:<40} | {total:<12} | {unreached_cnt:<10} | {pct:5.1f}%")


if __name__ == "__main__":
    main()
