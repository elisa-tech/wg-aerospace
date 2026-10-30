# Max Coverage Multi-Suite Artifacts & Utilities

<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

This directory contains the user-space harness, test corpus, and host-side analysis scripts for the [Maximizing Kernel Coverage with Open-Source Test Suites](../MaxCoverageMultiSuite.md) walkthrough:

- `corpus.syz` — Pinned Syzkaller test corpus for Stage 3 targeted syscall execution
- `init-maxcoverage.c` — Multi-stage sequential execution PID 1 test harness and base64 GCOV snapshot emitter
- `reconstruct_stage.py` — Host-side utility to extract checkpoint archives and run `gcov --json-format`
- `diff_gcov.py` — Host-side differential analysis script to compute cumulative and per-stage coverage deltas
- `audit_unreached.py` — Static/dynamic auditing script to identify unreached functions and candidate pruning targets
- `run_maxcoverage.sh` — Automation runner script

For complete configuration, execution workflows, and differential coverage tables, see **[Maximizing Kernel Coverage with Open-Source Test Suites](../MaxCoverageMultiSuite.md)**.
