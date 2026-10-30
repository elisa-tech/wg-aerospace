#!/usr/bin/env python3
# SPDX-License-Identifier: CC-BY-SA-4.0
import argparse
import shutil
import subprocess
import tarfile
import tempfile
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("archive", type=Path)
parser.add_argument("output", type=Path)
args = parser.parse_args()
tree = Path.cwd().resolve()
if not (tree / "vmlinux").is_file():
    parser.error("run from the matching isolated kernel build tree")
output = args.output.resolve()
output.mkdir(parents=True, exist_ok=False)

for previous in tree.rglob("*.gcda"):
    previous.unlink()
copied = []
try:
    with tempfile.TemporaryDirectory() as temporary:
        temporary = Path(temporary)
        with tarfile.open(args.archive) as archive:
            archive.extractall(temporary, filter="data")
        debug_root = temporary / "sys/kernel/debug/gcov"
        units = sorted(debug_root.rglob("*.gcda"))
        if not units:
            raise RuntimeError("checkpoint contains no gcda units")
        for counters in units:
            target = (Path("/") / counters.relative_to(debug_root)).resolve()
            if not target.is_relative_to(tree):
                raise RuntimeError(f"wrong checkpoint tree: {target}")
            if not target.with_suffix(".gcno").is_file():
                raise RuntimeError(f"missing matching gcno: {target}")
            shutil.copyfile(counters, target)
            copied.append(target)
            if list(tree.glob("*.gcov.json.gz")):
                raise RuntimeError("move existing gcov JSON outputs first")
            with (output / "gcov.log").open("a", encoding="utf-8") as log:
                subprocess.run(
                    ["aarch64-linux-gnu-gcov", "--json-format",
                     "-o", str(target.parent), str(target)],
                    cwd=tree, stdout=log, stderr=log, check=True,
                )
            generated = list(tree.glob("*.gcov.json.gz"))
            if len(generated) != 1:
                raise RuntimeError(f"expected one JSON file: {target}")
            destination = output / target.relative_to(tree).with_suffix(
                ".gcov.json.gz"
            )
            destination.parent.mkdir(parents=True, exist_ok=True)
            shutil.move(generated[0], destination)
finally:
    for target in copied:
        target.unlink(missing_ok=True)
print(f"{len(copied)} units reconstructed for {args.output}")
