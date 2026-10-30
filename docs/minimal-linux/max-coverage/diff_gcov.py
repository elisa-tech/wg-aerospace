#!/usr/bin/env python3
# SPDX-License-Identifier: CC-BY-SA-4.0
import gzip
import json
import os
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
    if not executable:
        raise ValueError(f"zero executable denominator in {stage_dir}")
    return executed, executable


if __name__ == "__main__":
    previous = set()
    denominator = None
    inventory = None
    for stage in ("stage0_boot", "stage1_procsys",
                  "stage2_stressng", "stage3_syzkaller"):
        if not Path(stage).is_dir():
            continue
        units = {report.relative_to(stage)
                 for report in Path(stage).rglob("*.gcov.json.gz")}
        if inventory is not None and units != inventory:
            raise ValueError(f"runtime unit inventory changed at {stage}")
        executed, executable = load_stage_lines(stage)
        if denominator is not None and executable != denominator:
            raise ValueError(f"executable inventory changed at {stage}")
        if not previous <= executed:
            raise ValueError(f"executed lines disappeared at {stage}")
        print(
            f"{stage}: {len(executed)} / {len(executable)} "
            f"({100 * len(executed) / len(executable):.2f}%), "
            f"+{len(executed - previous)} new lines"
        )
        previous = executed
        denominator = executable
        inventory = units
