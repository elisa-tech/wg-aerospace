# Hello cFS Artifacts & Dockerfiles

<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

This directory contains the user-space sources, OSAL feature probes, and dedicated step Dockerfiles for evaluating NASA Core Flight System (cFS) directly as PID 1 per [Hello cFS](../HelloCFS.md):

- `Dockerfile.step0-cfs-baseline` — Step 0: Initial cFS flight workload baseline (POSIX timers, mqueues, UDP socket)
- `Dockerfile.step1-cfs-prune` — Step 1: Iterative kernel pruning for cFS
- `core-cfs.c` — Minimal PID 1 cFS application loop

For complete build, test, measurement instructions, and recorded observation tables, see **[Hello cFS](../HelloCFS.md)**.
