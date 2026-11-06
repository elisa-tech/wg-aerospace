# Hello Init Artifacts & Dockerfiles

<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

This directory contains the user-space sources (`ainit*.c`) and dedicated step Dockerfiles for reproducing the steps in the [Hello Init (Practice)](../HelloInit.md) walkthrough:

- `Dockerfile.step0-tinyconfig` — Step 0: Minimal `tinyconfig` baseline
- `Dockerfile.step1-net` — Step 1: Networking feature probe (`+NET +INET`)
- `Dockerfile.step2-kcov` — Step 2: Runtime coverage collection (`KCOV`)
- `Dockerfile.step3-defconfig` — Step 3: Monolithic `defconfig` baseline
- `Dockerfile.gdb-stub-tracing` — Workload discovery: QEMU GDB stub non-intrusive syscall tracing
- `ainit.c`, `ainit-net.c`, `ainit-net-kcov.c`, `ainit-kcov.c` — User-space PID 1 sources

For complete build, test, measurement instructions, and recorded observation tables, see **[Hello Init (Practice)](../HelloInit.md)**.
