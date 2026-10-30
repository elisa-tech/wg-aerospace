#!/usr/bin/env python3
# SPDX-License-Identifier: CC-BY-SA-4.0
import os
import re
import sys

symbols_file = sys.argv[1] if len(sys.argv) > 1 else "kcov-symbols.txt"
output_file = sys.argv[2] if len(sys.argv) > 2 else "kcov-lines.txt"

lines = set()
with open(symbols_file, encoding="utf-8") as symbols:
    for row in symbols:
        match = re.fullmatch(
            r"(.+):([0-9]+)(?: \(discriminator [0-9]+\))?", row.strip()
        )
        if match and match[1] != "??" and int(match[2]) > 0:
            source = os.path.relpath(os.path.realpath(match[1]))
            lines.add((source, int(match[2])))

with open(output_file, "w", encoding="utf-8") as output:
    for source, number in sorted(lines):
        output.write(f"{source}:{number}\n")

print(f"Normalized unique executed lines: {len(lines)}")
