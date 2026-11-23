<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->
<!-- markdownlint-disable MD013 -->

# Maximizing Kernel Coverage with Open-Source Test Suites

_stress-ng, Syzkaller & GCOV — a worked example of applying the
[kernel-minimization](../SoftwareMinimization.md) coverage concepts._

This is a worked example that extends the baseline practice walkthrough in
[Hello Init (Practice)](./HelloInit.md). Where that document measures the
reachability of individual syscalls, this one maximizes **whole-kernel**
structural coverage by driving complementary open-source test suites under a
GCOV-instrumented kernel and auditing what remains unreached. Read
[Hello Init (Practice)](./HelloInit.md) first for the build/boot/measure
mechanics this example relies on.

While individual probes (such as `read()` or `socket()`) measure the reachability
of isolated system calls, maximizing overall kernel coverage requires executing
complementary test suites across different execution layers and capturing
system-wide execution across boot paths, kernel daemon threads, interrupts, and
user processes.

## Table of Contents

- [1. Test Methodologies & Coverage Complementarity](#1-test-methodologies--coverage-complementarity)
- [2. Higher-Altitude Levers & Untried Coverage Extensions](#2-higher-altitude-levers--untried-coverage-extensions)
- [3. Kernel Profiling Configuration](#3-kernel-profiling-configuration)
- [4. Rootfs Assembly & Sequential Multi-Stage Execution Workflow](#4-rootfs-assembly--sequential-multi-stage-execution-workflow)
- [5. Host-Side Checkpoint Extraction & Differential Analysis](#5-host-side-checkpoint-extraction--differential-analysis)
- [6. Measured Multi-Stage Progression & Differential Table (tinyconfig)](#6-measured-multi-stage-progression--differential-table-tinyconfig)
- [7. Identifying Uncovered Built Areas & Pruning Candidates](#7-identifying-uncovered-built-areas--pruning-candidates)
  - [7.1 How `.gcda` Files and DWARF SLOC Complement Each Other](#71-how-gcda-files-and-dwarf-sloc-complement-each-other)
  - [7.2 Methods for Auditing Uncovered Code](#72-methods-for-auditing-uncovered-code)
  - [7.3 High-Impact Linked Unreached Targets (tinyconfig Audit)](#73-high-impact-linked-unreached-targets-tinyconfig-audit)
  - [7.4 Connecting Findings to Kconfig Pruning](#74-connecting-findings-to-kconfig-pruning)
  - [7.5 Can More Coverage Be Driven? (Gap → Tool Mapping)](#75-can-more-coverage-be-driven-gap--tool-mapping)
- [8. Iterative Kconfig Pruning & Post-Minimization Coverage Impact](#8-iterative-kconfig-pruning--post-minimization-coverage-impact)
  - [8.1 Post-Pruning Multi-Stage Coverage Progression](#81-post-pruning-multi-stage-coverage-progression)
  - [8.2 Next Iteration Targets for Further Minimization](#82-next-iteration-targets-for-further-minimization)
- [9. Cross-Reference with Research Configurations & Advanced Minimization Targets](#9-cross-reference-with-research-configurations--advanced-minimization-targets)
  - [9.1 Advanced Research-Backed Pruning Recipe](#91-advanced-research-backed-pruning-recipe)
  - [9.2 Macro Minimization & Coverage Progression Across Configurations](#92-macro-minimization--coverage-progression-across-configurations)
- [10. Measurement Environment, Core Count & Timing Record](#10-measurement-environment-core-count--timing-record)
- [11. References & Navigation](#11-references--navigation)

## Environment and Dockerized Walkthrough

Like [Hello Init](./HelloInit.md#2-environment), this example ships dedicated
step Dockerfiles that encapsulate the whole pipeline — toolchain, kernel
checkout, GCOV build, rootfs assembly (Alpine + stress-ng + real Syzkaller),
the single-core QEMU run, and the host-side checkpoint reconstruction and
differential coverage. They run the exploration end to end so a reviewer does
not have to wire the stages together by hand:

- `docs/minimal-linux/max-coverage/Dockerfile.step0-gcov-baseline` — Sections
  3–7: the GCOV `tinyconfig` baseline exploration.
- `docs/minimal-linux/max-coverage/Dockerfile.step1-gcov-pruned` — Section 8:
  the same harness after the deadweight prune.

```sh
# Build and run the baseline exploration (Sections 3-7).
docker build -f docs/minimal-linux/max-coverage/Dockerfile.step0-gcov-baseline \
    -t maxcov-step0 .
docker run --rm maxcov-step0                       # prints coverage progression + metrics
docker run --rm maxcov-step0 cat /workspace/unreached-ranking.txt

# Build and run the pruned exploration (Section 8), then compare.
docker build -f docs/minimal-linux/max-coverage/Dockerfile.step1-gcov-pruned \
    -t maxcov-step1 .
docker run --rm maxcov-step1
```

Each image builds its kernel inside its own layers, so separate `docker build`
runs never share kernel state.
The build **fails** if a GCOV prerequisite is dropped, a stage checkpoint is
missing or not a valid archive, the runtime unit inventory changes between
stages, or the coverage denominator is zero. It does **not** fail on stress-ng
stressor failures: those are expected on this minimal kernel and are recorded,
not gated (see [Section 6](#6-measured-multi-stage-progression--differential-table-tinyconfig)).

This image is much heavier than the Hello Init steps: it clones Syzkaller and
builds its Go host tool, downloads the Alpine rootfs and packages, and boots a
single-core QEMU guest for up to 20 minutes. Build it on a host with disk space
to spare and watch the filesystem that holds Docker's data root.

The detailed mechanics each Dockerfile automates are documented in
[Section 3](#3-kernel-profiling-configuration) (config),
[Section 4](#4-rootfs-assembly--sequential-multi-stage-execution-workflow)
(rootfs and boot), and
[Section 5](#5-host-side-checkpoint-extraction--differential-analysis)
(reconstruction). These sections explain the measurement design; use the
Dockerfiles as the canonical execution recipes.

## 1. Test Methodologies & Coverage Complementarity

Combining multiple test tools creates a unified, layered verification harness where
each tool activates distinct code paths:

- **In-Kernel Boot Self-Tests:** Internal API validation, locking primitives (mutexes,
  spinlocks, rwsems), data structures (xarray, maple tree, rhashtable), and atomic ops
  exercised automatically during kernel boot initcalls.
- **Pseudo-Filesystem (`/proc` & `/sys`) Traversal:** Recursive reads across
  all exported pseudo-files and kobject attributes, exercising thousands of `seq_file`
  show handlers and subsystem attribute callbacks.
- **stress-ng (Throughput & Concurrency):** High-load stressors exercising nominal
  execution paths, scheduling preemption, VM allocation, pipes, and memory mapping.
- **Syzkaller Corpus Playback (Combinatorial Sequences):** Replays mutated multi-syscall
  programs (`syz-execprog` or exported standalone C reproducers), exercising deep state
  transitions across interconnected kernel subsystems, including deliberate error paths
  (e.g. `execveat()` of a malformed binary).

## 2. Higher-Altitude Levers & Untried Coverage Extensions

The stages above explore coverage on the `tinyconfig` baseline. Several
techniques remain untried and are scoped for larger configurations
(`+ networking`, `+ block/ext4`, `defconfig`):

0. **LTP / Linux Test Project full syscall suite — deferred comparison:**
   - _Status in this walkthrough:_ Built earlier: 1,564 real cross-compiled
     syscall testcases, pinned LTP `20260930`, then removed from the harness.
   - _Earlier result, pending revalidation:_ LTP reportedly added 21 lines in
     `fs/exec.c`, `kernel/cred.c`, and `fs/binfmt_elf.c`. The malformed-exec
     reproducer reaches those paths, but the earlier pipeline lost coverage
     data and did not establish complete stress-ng execution. Re-measure the
     with-LTP and without-LTP runs before claiming subsumption.
   - _When to revisit:_ Larger configurations with networking or block/filesystem
     support. The earlier static LTP build adds ~2.7 GB to the initramfs and
     needs ~12 GiB guest RAM.
1. **Live Mutating Syzkaller Fuzzing (`syz-fuzzer` with `CONFIG_KCOV=y`):**
   - _Status in this walkthrough:_ Untried (only deterministic corpus replay was executed).
   - _Impact & Tradeoff:_ Live time-boxed random mutation (e.g. 10–30 minutes) discovers
     deep edge-case paths a static corpus cannot reach. In aerospace environments,
     this is best isolated into an offline exploration track so non-deterministic fuzzer
     failures do not fail deterministic verification gates.
2. **Filesystem Loop-Mount Matrix (`fsstress`, `fsx`, `xfstests`):**
   - _Status in this walkthrough:_ Untried on `tinyconfig` (requires `CONFIG_BLOCK=y`,
     `CONFIG_BLK_DEV_LOOP=y`, and filesystem drivers like `CONFIG_EXT4_FS=y` or `CONFIG_OVERLAY_FS=y`).
   - _Impact:_ Loop-mounting images and running `fsstress` exercises journaling, extent trees,
     directory caching, and truncation across filesystem implementations.
3. **Advanced Netlink, Traffic Control (`tc`), & Netfilter (`nft`):**
   - _Status in this walkthrough:_ Scoped for `+ networking` builds (requires `CONFIG_NET=y`,
     `CONFIG_NETFILTER=y`, `CONFIG_NET_SCHED=y`).
   - _Impact:_ Manipulating traffic-control qdiscs, packet classifiers, and firewall rulesets
     exercises extensive network stack control logic.
4. **`io_uring` Asynchronous Engine (`liburing` test suite):**
   - _Status in this walkthrough:_ Untried (requires `CONFIG_IO_URING=y`).
   - _Impact:_ Thoroughly exercises the kernel asynchronous submission and completion ring queues.
5. **eBPF Verifier, JIT, & Map Traversal (`bpftrace` / `libbpf`):**
   - _Status in this walkthrough:_ Untried (requires `CONFIG_BPF=y`, `CONFIG_BPF_SYSCALL=y`).
   - _Impact:_ Loading BPF programs, kprobes, and tracepoints exercises the bytecode verifier,
     in-kernel JIT compiler, and map storage engines.
6. **Performance & Tracing Subsystem (`perf` & `ftrace`):**
   - _Status in this walkthrough:_ Untried (requires `CONFIG_PERF_EVENTS=y`, `CONFIG_FTRACE=y`).
   - _Impact:_ Running `perf record` and enabling function graph tracing exercises event counters
     and PMU drivers.

## 3. Kernel Profiling Configuration

Start from the bootable `tinyconfig` baseline from [Section 3](./HelloInit.md#3-step-0-minimal-tinyconfig-baseline)
(`tinyconfig` + PL011 serial, printk, initrd, ELF, `-MODULES`), then enable
whole-kernel GCOV profiling, boot self-tests, and the workload prerequisites
on ARM64. The step Dockerfiles hold the exact Kconfig recipe and verify that
required symbols survive `olddefconfig`. The important dependencies are
`RUNTIME_TESTING_MENU` for the runtime tests, `KUNIT` for sort tests,
`POSIX_TIMERS` for bounded stress-ng runs, and `SHMEM`, `MEMFD_CREATE`, and
`ADVISE_SYSCALLS` for the Syzkaller corpus. DWARF debug information supports
the linked-SLOC audit in [Section 7](#7-identifying-uncovered-built-areas--pruning-candidates).
See [Hello Init](./HelloInit.md#2-environment) for tool-version recording.

The supported baseline is NET-less. Networking extensions listed in
[Section 2](#2-higher-altitude-levers--untried-coverage-extensions) change the
instrumented set and denominator and are not covered by the supplied images.

## 4. Rootfs Assembly & Sequential Multi-Stage Execution Workflow

To measure both total cumulative coverage and stage-by-stage differential gains,
the static `/init` launcher runs the workload stages sequentially as one complete
workload, emitting labeled checkpoints to the serial log between stages without
clearing in-memory GCOV counters. The active stages are **boot self-tests →
`/proc`/`/sys` traversal → stress-ng → Syzkaller**:

The class sweep includes optional APIs and networking stressors even with
`CONFIG_NET=n`. Record unsupported stressors and failures; checkpoint export
measures execution, not a suite pass. Traversal completion likewise does not
mean every pseudo-file read succeeded.

1. **Assemble the workload image.** The step Dockerfiles stage the pinned Alpine
     minirootfs, stress-ng and its shared libraries, and the static Syzkaller
     reproducer. The reproducible workload is maintained in
     [`corpus.syz`](./max-coverage/corpus.syz); its PID 1 stage runner is
     [`init-maxcoverage.c`](./max-coverage/init-maxcoverage.c). The Dockerfiles
     are the source of truth for versions, assembly commands, and dependency checks.

2. **Run the sequential workload.** The maintained PID 1 launcher mounts the
   guest filesystems, runs the four stages with watchdogs, and exports one GCOV
   checkpoint after each stage. See
   [`init-maxcoverage.c`](./max-coverage/init-maxcoverage.c) for the launcher.
   The Dockerfiles compile it, assemble the initramfs, and boot the single-core
   QEMU guest with a 1024 MiB memory limit and bounded runtime. Checkpoint
   integrity is a build gate; stress-ng failures are recorded as exploration
   results, not treated as a suite pass.

## 5. Host-Side Checkpoint Extraction & Differential Analysis

The Dockerfiles extract and validate the four labeled checkpoints, then call
[`reconstruct_stage.py`](./max-coverage/reconstruct_stage.py) to match each
runtime `.gcda` with its build-time `.gcno` and produce per-unit gcov JSON. They
call [`diff_gcov.py`](./max-coverage/diff_gcov.py) to report cumulative and
per-stage executed source-line coverage, and [`audit_unreached.py`](./max-coverage/audit_unreached.py)
to rank linked lines with no observed execution. The Dockerfiles and these
helpers are the canonical implementation; the build rejects invalid checkpoints,
changed runtime-unit inventories, and a zero coverage denominator.

Coverage percentages use the union of executable source lines across the gcov
JSON inventories. Retain the per-unit JSON: flattening text `.gcov` files can
overwrite shared-header output and lose partial counts. For subsystem tables,
partition normalized paths and count header lines once; the partitions should
sum to the whole-image totals.

## 6. Measured Multi-Stage Progression & Differential Table (tinyconfig)

The corrected Sections 3–5 were re-run on 2026-10-18 with the toolchain in
Hello Init Section 7.1. All four checkpoints exported with 609 unit inventories
per stage and no class watchdog termination. Each stress-ng class returned
failure for unsupported APIs or resource limits; the launcher reported
`HARNESS INCOMPLETE`. Syzkaller's memfd, mapping, and advice calls succeeded,
and malformed `execveat()` returned `ENOEXEC`.

These figures measure **coverage exploration with suite failures**, not a
passing test gate. The denominator is the union of executable source lines
across all unit inventories, including headers and generated sources.
Regenerate the table for each configuration and payload set.

> **Containerized reproduction (2026-10-31).** A fresh
> `docker build -f Dockerfile.step0-gcov-baseline` on the base image
> `ubuntu:24.04@sha256:fe81560990fa…` (GCC 13.3.0, QEMU 8.2.2) reproduced the
> **164,992** DWARF SLOC, **7,596,040 B** raw `Image`, and the **205,463**
> executable denominator exactly, with **609** gcov units per stage. The
> per-stage numerators landed at 67,081 / 74,800 / 93,042 / 93,104
> (32.65% → 45.31%): identical boot/traversal lines and the same shape, with the
> stress-ng and Syzkaller stages varying by well under 0.1% run to run, as this
> section warns. The harness again reported `HARNESS INCOMPLETE` (all five
> stress-ng classes failed, Syzkaller and the traversal succeeded).

| Subsystem / Execution Stage      | Total Exec SLOC | Stage 0: Boot & Self-Tests |     Stage 1: + `/proc`/`/sys` |         Stage 2: + `stress-ng` | Stage 3: + Syzkaller (incl. bad-exec) | Primary Paths Activated                               |
| :------------------------------- | --------------: | -------------------------: | ----------------------------: | -----------------------------: | ------------------------------------: | :---------------------------------------------------- |
| **Overall Kernel (Whole-Image)** |     **205,463** |       **67,087**<br>32.65% | **74,800**<br>[+7,713] 36.41% | **92,964**<br>[+18,164] 45.25% |            **93,025**<br>[+61] 45.28% | **Cumulative whole-system execution**                 |
| `kernel/` (Core OS & Sched)      |          47,822 |                     15,969 |                        17,688 |                         23,051 |                                23,056 | Locking, signals, timers, futexes, credentials        |
| `drivers/` (Built-in Drivers)    |          45,883 |                      7,511 |                         8,508 |                          9,939 |                                 9,939 | sysfs attrs, TTY, UART, OF                            |
| `fs/` (VFS & Filesystems)        |          31,742 |                      8,268 |                        11,692 |                         17,622 |                                17,642 | seq_file show, mounts, path walk, exec, binfmt        |
| `lib/` (Core Utilities)          |          29,154 |                     13,736 |                        14,105 |                         14,459 |                                14,459 | Bitmaps, string helpers, sort, xarray/maple tree      |
| `mm/` (Memory Management)        |          29,095 |                     10,202 |                        10,949 |                         14,675 |                                14,704 | Page faults, mmap, mprotect, mincore, memfd           |
| `include/` (Inlined Headers)     |          10,566 |                      6,532 |                         6,892 |                          7,711 |                                 7,718 | Inlined helpers deduplicated across units             |
| `arch/arm64/` (Architecture)     |           8,346 |                      3,791 |                         3,867 |                          4,348 |                                 4,348 | Traps, exceptions, syscall entry/exit, context switch |
| `init/` (Boot & Initialization)  |           1,244 |                        656 |                           656 |                            656 |                                   656 | Early boot, calibrate delay, mounts, initramfs        |
| `security/` (LSM)                |             413 |                         95 |                           116 |                            176 |                                   176 | Capability & LSM hook stubs                           |
| `scripts/` and `tools/`          |           1,198 |                        327 |                           327 |                            327 |                                   327 | Generated/shared sources linked into the kernel       |

Cells are cumulative executed lines. Source-path partitions, including the
`scripts/` and `tools/` row, sum to the whole-image totals; header lines are
counted once under their own paths.

## 7. Identifying Uncovered Built Areas & Pruning Candidates

Whole-kernel GCOV profiling directly records execution counts in `.gcda` files,
while DWARF SLOC (`linked.json`) estimates source lines represented in the final
`vmlinux`. Combining both ranks linked code with no observed execution.

### 7.1 How `.gcda` Files and DWARF SLOC Complement Each Other

- **`.gcda` Files (Runtime Execution Counters):** Each `.gcda` file exported
  through `/sys/kernel/debug/gcov` directly contains the execution counts for every
  basic block in that compilation unit. Running `aarch64-linux-gnu-gcov` flags
  unreached executable lines with `#####:`. A compilation unit whose executable
  lines all have zero counts is completely unreached (0% coverage).
- **DWARF SLOC (`linked.json` Ground Truth):** In kernel builds, some object files
  are compiled into intermediate archives (e.g. `lib/lib.a`), but the linker (`ld`)
  discards unreferenced objects or sections during the final link. Furthermore,
  header inlines (e.g. `include/linux/spinlock.h`) appear duplicated across hundreds
  of `.gcda` files. `linked.json` (from `scripts/kernel-sloc --report linked.json dwarf vmlinux`)
  estimates source lines linked into `vmlinux` and deduplicates inlines.

$$\text{Unreached Linked SLOC} = \text{Linked DWARF SLOC } (\texttt{linked.json}) \setminus \text{Executed GCOV Lines}$$

### 7.2 Methods for Auditing Uncovered Code

- **Per-unit scan for zero execution:** Use the retained final-stage JSON
  inventories, so missing counters cannot be mistaken for zero execution:

  ```python
  import gzip
  import json
  from pathlib import Path

  for report in sorted(Path("stage3_syzkaller").rglob("*.gcov.json.gz")):
      with gzip.open(report, "rt", encoding="utf-8") as stream:
          unit = json.load(stream)
      counts = [line["count"] for source in unit["files"]
                for line in source["lines"]]
      if counts and not any(count > 0 for count in counts):
          print(f"No observed execution: {report}")
  ```

- **DWARF-Filtered Priority Ranking:** Cross-reference `linked.json` against
  the final-stage gcov JSON union
  to rank source files by unreached lines physically present in `vmlinux`:

  ```python
  import json
  import os
  from collections import defaultdict
  from diff_gcov import load_stage_lines

  with open("linked.json", encoding="utf-8") as f:
      dwarf = json.load(f)
  dwarf_lines = defaultdict(set)
  for entry in dwarf.get("source_lines", []):
      fpath = os.path.relpath(os.path.realpath(entry["file"]))
      dwarf_lines[fpath].add(entry["line"])

  executed, executable = load_stage_lines("stage3_syzkaller")
  executed_lines = defaultdict(set)
  for source, line in executed:
      executed_lines[source].add(line)

  ranked = []
  for fpath, lines in dwarf_lines.items():
      unreached = lines - executed_lines.get(fpath, set())
      ranked.append((fpath, len(lines), len(unreached), len(unreached) / len(lines) * 100))
  ranked.sort(key=lambda x: x[2], reverse=True)

  print(f"{'Source File':<40} | {'Linked SLOC':<12} | {'Unreached':<10} | {'% Unreached':<12}")
  for fpath, total, unreached, pct in ranked[:10]:
      print(f"{fpath:<40} | {total:<12} | {unreached:<10} | {pct:5.1f}%")
  ```

  Run from the matching kernel tree and use only the final checkpoint for that
  build. Unioning earlier or pre-pruning directories into the final audit can
  conceal removals or change the workload scope.

### 7.3 High-Impact Linked Unreached Targets (tinyconfig Audit)

Cross-referencing `.gcda` data with `linked.json` on the `tinyconfig` build reveals
two fundamentally distinct categories of unreached code across testing tools:

1. **Active API & Edge-Case Units (reachable by the workload tools):** Units like
   `fs/select.c`, `mm/mincore.c`, and data structures in `lib/` are unexercised under
   simple throughput load, but activate once a syscall-boundary/validation payload (a
   Syzkaller corpus) invokes the relevant syscalls.
2. **Structural & Hardware Deadweight:** Drivers for non-existent hardware
   (GICv3 ITS, ALPS mouse) and unused decompressors (ZSTD) remain unreached in
   this workload. VT executes during console initialization and is only
   partially unreached.

The `Linked SLOC` and `%unreached` columns use the corrected baseline's final
checkpoint and matching `linked.json`. They describe the exploration run with
suite failures from Section 6.

| Subsystem      | Linked Source Unit                                                                          | Linked SLOC (measured)  | Multi-Suite %unreached (measured) | Classification & Pruning Action                                                         |
| :------------- | :------------------------------------------------------------------------------------------ | :---------------------- | :-------------------------------- | :-------------------------------------------------------------------------------------- |
| **`drivers/`** | `drivers/irqchip/irq-gic-v3-its.c`<br>`drivers/tty/vt/vt.c`<br>`drivers/input/mouse/alps.c` | 1,881<br>1,966<br>1,354 | 100%<br>87.2%<br>100%             | ITS and ALPS hardware are absent; VT runs during initialization. Re-test after pruning. |
| **`lib/`**     | `lib/zstd/decompress/*`<br>`lib/maple_tree.c`<br>`lib/xarray.c`                             | 2,232<br>2,145<br>662   | 100%<br>19.3%<br>27.8%            | Gzip leaves ZSTD unused; self-tests and the workload exercise the data structures.      |
| **`fs/`**      | `fs/select.c`<br>`fs/pnode.c`<br>`fs/fsopen.c`                                              | 387<br>276<br>195       | 28.4%<br>92.0%<br>100%            | Class exploration reaches select and some namespace paths; fsopen remains unobserved.   |
| **`mm/`**      | `mm/mincore.c`<br>`mm/dmapool.c`                                                            | 85<br>146               | 56.5%<br>100%                     | mincore now executes; DMA pool helpers remain unobserved.                               |
| **`kernel/`**  | `kernel/futex/pi.c`<br>`kernel/irq/msi.c`                                                   | 309<br>538              | 100%<br>100%                      | PI contention and MSI routing remain gaps in this baseline run.                         |

GICv3 ITS and PI futex remain linked after Section 8 pruning; the pruned
exploration touches one PI-futex line. Recompute each audit from its own final
checkpoint.

### 7.4 Connecting Findings to Kconfig Pruning

> **Pruning Decision Framework:**
>
> 1. **Hardware / Device deadweight:** Drivers for peripherals absent from the target (e.g. GICv3 ITS, ALPS mouse). _Action:_ Prune (`-d`) and re-test. Check console requirements separately before pruning VT.
> 2. **Redundant codecs & format parsers:** Extra codecs when all required inputs use gzip. _Action:_ Prune (`-d`) and re-test.
> 3. **Workload-scoped POSIX APIs:** Kernel abstractions (e.g. `epoll`, `io_uring`, `sysvipc`, `timerfd`) unused by your application binary. _Action:_ Prune cautiously after validating workload syscall traces.

Once high-impact unreached linked units are identified:

1. **Map Source Files to Kconfig Symbols:** Check the Makefile in the respective
   directory (e.g. `drivers/irqchip/Makefile`, `drivers/tty/vt/Makefile`, `lib/Makefile`)
   to locate the governing `CONFIG_*` option.
2. **Prune Configuration:** Disable unneeded options using `./scripts/config -d <SYMBOL>`.
3. **Rebuild & Measure Delta:** Run `make olddefconfig`, rebuild `vmlinux`, and re-run
   `scripts/kernel-sloc --report linked.json dwarf vmlinux` to quantify the reduction
   in linked image size and SLOC.

### 7.5 Can More Coverage Be Driven? (Gap → Tool Mapping)

The corrected run adds +18,164 lines from stress-ng and +61 from Syzkaller.
Further gains depend on the enabled APIs and workload payload. Match each category of unreached code to a tool or
configuration change that can exercise it. Build the
unreached list with the [Section 7.2](#72-methods-for-auditing-uncovered-code)
scripts, then map it:

| Unreached category (from the audit)        | Example units                                           | Can a test tool reach it?     | What actually moves it                                                                                                                                                 |
| :----------------------------------------- | :------------------------------------------------------ | :---------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Workload-reachable error/edge paths        | `fs/select.c`, `mm/mincore.c`, maple tree/xarray splits | **Yes**                       | Already mostly hit by self-tests; a **live `syz-fuzzer`** (KCOV-guided mutation, not static replay) reaches the deep residue. Static corpus replay (as here) does not. |
| Deeper multi-syscall state machines        | `kernel/futex/pi.c`, io_uring rings, epoll              | **Yes, with config**          | `syz-fuzzer` **plus** the governing `CONFIG_*` enabled (e.g. `FUTEX`/`RT_MUTEXES`, `IO_URING`, `EPOLL`); then fuzz time-boxed.                                         |
| Filesystem internals (journaling, extents) | ext4/overlayfs paths                                    | **Yes, with config + driver** | `CONFIG_BLOCK` + a filesystem driver + `fsstress`/`fsx` on a loop-mounted image (Section 2 lever 2).                                                                   |
| Networking stack                           | `net/*`                                                 | **Yes, with config**          | `CONFIG_NET` + the Netlink/`tc`/`nft` sweep and socket fuzzing (Section 2 lever 3). Out of scope for this NET-less baseline.                                           |
| Hardware/console candidates                | GICv3 ITS, ALPS mouse, VT console                       | **Target-dependent**          | Absent devices remain unreached here; VT still runs during initialization. Review target requirements, prune candidates, and re-test (Section 8).                      |
| Unused codecs/format parsers               | ZSTD/LZ4/LZO decompressors                              | **No**                        | The data format never occurs at runtime (initramfs is gzip). **Prune** (Section 8).                                                                                    |

The practical loop: (1) generate the unreached list; (2) split it into
_tool-reachable_ vs _structural deadweight_; (3) for tool-reachable gaps, add the
enabling `CONFIG_*` and the matching tool (foremost a **live `syz-fuzzer`** run,
Section 2 lever 1) in a separate, clearly labeled measurement; (4) for deadweight,
prune it (Section 8) so it stops diluting the denominator. On this minimal NET-less
kernel the largest single lever is live fuzzing; the second is pruning deadweight.

## 8. Iterative Kconfig Pruning & Post-Minimization Coverage Impact

By acting on the findings from the DWARF audit, we disable the unneeded terminal,
input, and decompression options:

The supported prune and repeat measurement are implemented by
`Dockerfile.step1-gcov-pruned`, which applies the Kconfig changes and reruns the
same four-stage workload. Its comments and assertions document the exact
symbols and checks; do not use a separate host-side recipe.

> With the corrected workload prerequisites, the prune reduces the GCOV build
> from **164,992 → 149,102 DWARF SLOC** and the raw `Image` from
> **7,596,040 → 6,901,768 bytes** (GCC 13.3.0, binutils 2.42). Always
> re-boot the pruned image and re-run the harness; pruning changes the denominator,
> so re-generate the coverage table rather than scaling the old one.
>
> **Containerized reproduction (2026-10-31).** A fresh
> `docker build -f Dockerfile.step1-gcov-pruned` reproduced the same direction
> and magnitude: **146,810** DWARF SLOC and a **6,756,360 B** raw `Image` (both
> about 1.5–2% below the 2026-10-18 figures above), a **183,582** executable
> denominator, and **49.97%** final cumulative coverage. The small drift is the
> expected toolchain/`olddefconfig` variance this guide warns about; the prune's
> effect — a smaller denominator and a higher coverage percentage than the
> baseline — reproduces. The pruned-config guard confirmed `VT`, `SERIO`,
> `INPUT_MOUSE`, `HID_SUPPORT`, and `RD_ZSTD` dropped to `n`; `POWER_SUPPLY`
> remained `y` because another enabled option selects it.

### 8.1 Post-Pruning Multi-Stage Coverage Progression

Use the same final-stage workload and gcov JSON source-line denominator before
and after pruning. The corrected Section 4 exploration gives:

| Subsystem / Metric               | Pre-Pruning Cumulative<br>(All Stages / Best Coverage) | Post-Pruning Cumulative<br>(All Stages / Best Coverage) | Net Coverage Gain (%)    | Deadweight Removed & Notes                                         |
| :------------------------------- | :----------------------------------------------------- | :------------------------------------------------------ | :----------------------- | :----------------------------------------------------------------- |
| **Overall Kernel (Whole-Image)** | 45.28% (93,025 / 205,463)                              | 49.16% (91,594 / 186,331)                               | +3.88 percentage points  | Source-line denominator falls by 19,132; numerator falls by 1,431. |
| `init/`                          | 52.73% (656 / 1,244)                                   | 52.73% (656 / 1,244)                                    | 0.00 percentage points   | No init code removed                                               |
| `mm/`                            | 50.54% (14,704 / 29,095)                               | 50.43% (14,671 / 29,095)                                | -0.11 percentage points  | No swap or compaction removed                                      |
| `kernel/`                        | 48.21% (23,056 / 47,822)                               | 48.17% (23,035 / 47,822)                                | -0.04 percentage points  | PI futex remains linked                                            |
| `arch/arm64/`                    | 52.10% (4,348 / 8,346)                                 | 51.99% (4,339 / 8,346)                                  | -0.11 percentage points  | No architecture code removed                                       |
| `fs/`                            | 55.58% (17,642 / 31,742)                               | 55.72% (17,543 / 31,485)                                | +0.14 percentage points  | Removed devpts interfaces                                          |
| `lib/`                           | 49.59% (14,459 / 29,154)                               | 60.27% (14,458 / 23,987)                                | +10.68 percentage points | Removed unused decompressors                                       |
| `drivers/`                       | 21.66% (9,939 / 45,883)                                | 26.93% (8,712 / 32,348)                                 | +5.27 percentage points  | Removed VT/input/HID infrastructure                                |

Both runs report failures in all five stress-ng classes with no class watchdog
termination. These are exploration measurements, not full-suite acceptance.
Pruning reduces the denominator; execution also varies with removed paths and
workload timing.

### 8.2 Next Iteration Targets for Further Minimization

Following this iterative cycle, the next audit identifies subsequent candidate
areas for investigation in the next pruning round:

1. **`fs/` (VFS Features & Pseudo-Filesystems):** Audit `CONFIG_PROC_PAGE_MONITOR`,
   `CONFIG_SYSCTL`, `CONFIG_COREDUMP`, and advanced mount APIs (`fsopen`, `pnode`).
2. **`kernel/` (Optional POSIX Mechanisms):** Inspect whether the workload requires
   `CONFIG_SYSVIPC`, `CONFIG_SIGNALFD`, `CONFIG_TIMERFD`, `CONFIG_EVENTFD`, or `CONFIG_AIO`.
3. **`drivers/of/` (Device Tree Subsystem):** Evaluate unneeded device tree parsing
   features (`CONFIG_OF_OVERLAY`, dynamic device tree nodes).
4. **`lib/` (CRC implementation):** On kernels that still offer the slice-by-8
   CRC32 choice, replace it with a minimal bit-at-a-time implementation. **Note:**
   v7.3-rc5 no longer exposes `CONFIG_CRC32_SLICEBY8`/`CONFIG_CRC32_BIT`
   (`lib/crc/Kconfig` defines only `CRC32` and `CRC32_ARCH`), so this item is a
   no-op there; confirm the symbols exist for your kernel before relying on it.
5. **`mm/` (Memory Subsystem Tuning):** Evaluate memory compaction and swap stubs
   (`CONFIG_COMPACTION=n`, `CONFIG_SWAP=n`, `CONFIG_SLUB_TINY=y`).

## 9. Cross-Reference with Research Configurations & Advanced Minimization Targets

_(For SLOC accounting definitions across baseline, instrumented, and research profiles, see [Measurement Denominators & SLOC Accounting](./HelloInit.md#measurement-denominators-and-sloc-accounting))._

To take the next leap in kernel minimization, we can cross-reference our Section 7 audit findings with the published minimal research profiles analyzed in
[Kernel Config Analysis](KernelConfigAnalysis.md) and the aerospace framing in
[Software Minimization](../SoftwareMinimization.md):

- **Boeing 5.x `minimal_defconfig`:** Prior aerospace research targeting DO-178C
  certification review ([Boeing/linux@f5d4b42](https://github.com/Boeing/linux/commit/f5d4b42051b045fb667d69eeb0272a89dde6ba20)),
  which achieved 167,469 DWARF SLOC by eliminating IPC, debug interfaces, and advanced VM layers.
- **ELISA LFSCS Minimal Trace Config:** Derived from the Linux for Safety Critical
  Systems WG ftrace study ([`min_prog_trace`](https://github.com/elisa-tech/wg-lfscs/tree/main/min_prog_trace)),
  identifying essential runtime syscalls for simple C applications.
- **Upstream Kernel Size Reduction Work:** Upstream tinification guidelines
  ([elinux.org/Kernel_Size_Reduction_Work](https://elinux.org/Kernel_Size_Reduction_Work))
  for eliminating unneeded core OS and memory subsystems.

### 9.1 Advanced Research-Backed Pruning Recipe

Synthesizing these research profiles with our audit targets allows disabling
remaining unexercised core OS, pseudo-filesystem, and memory management subsystems:

```sh
./scripts/config \
    -d PROC_PAGE_MONITOR -d SYSCTL -d COREDUMP \
    -d SYSVIPC -d AIO -d IO_URING \
    -d SIGNALFD -d TIMERFD -d EVENTFD -d EPOLL \
    -d COMPACTION -d SWAP -d SHMEM \
    -e SLUB_TINY \
    -d OF_OVERLAY
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- olddefconfig
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- clean
make -j"$(nproc)" ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image
```

This research recipe remains unmeasured. Disabling `SHMEM` changes memfd backing
and shared-memory behavior even if `MEMFD_CREATE` remains enabled. Re-test the
corpus and label changed results rather than assuming its success paths survive.
The CRC32 slice-by-8/bit swap from [Section 8.2](#82-next-iteration-targets-for-further-minimization)
is omitted here because v7.3-rc5 does not expose those symbols; add it only on a
kernel that still offers the CRC32 implementation choice.

### 9.2 Macro Minimization & Coverage Progression Across Configurations

Comparing across configurations illustrates how systematic pruning shrinks the
linked codebase while driving whole-kernel coverage percentages into the upper tiers.

> **Scope of this table.** The `defconfig`, `tinyconfig` Step 0, and initial-pruning
> rows were measured in this workspace (see [Section 6](#6-measured-multi-stage-progression--differential-table-tinyconfig)
> and [Section 8](#8-iterative-kconfig-pruning--post-minimization-coverage-impact)). The
> **Research Profile Synthesis** row uses the Section 9.1 recipe and is a **target for the
> next iteration — it was not booted/measured in this run** (its values are marked
> `~`). Coverage percentages use the gcov JSON source-line union defined in
> [Measurement Denominators & SLOC Accounting](./HelloInit.md#measurement-denominators-and-sloc-accounting);
> regenerate per row because each prune changes the denominator.

| Configuration Profile                         | Linked DWARF SLOC           | Raw Image Size            | Measured in this run?   | Aerospace / Verification Notes                                                                                                                                            |
| :-------------------------------------------- | :-------------------------- | :------------------------ | :---------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **`defconfig` Baseline**                      | 1,959,778 lines             | 101,362,176 B (96.67 MiB) | yes (build+boot)        | Uninstrumented monolithic baseline; no whole-kernel GCOV percentage measured for this row.                                                                                |
| **`tinyconfig` Step 0 Baseline (GCOV)**       | 164,992 lines               | 7,596,040 B (7.24 MiB)    | yes (build+exploration) | Corrected prerequisites; 32.65% → 45.28% execution coverage, with suite failures (Section 6).                                                                             |
| **`tinyconfig` Initial Pruning (Section 8)**  | 149,102 lines               | 6,901,768 B (6.58 MiB)    | yes (build+exploration) | Removed VT/input/HID infrastructure and extra codecs; 49.16% final execution coverage, with suite failures.                                                               |
| **`tinyconfig` + Research Profile Synthesis** | **~118,500 lines (target)** | **~2.1 MiB (target)**     | **no — next iteration** | **Ultra-minimal profile (Section 9.1):** replaces multi-table CRCs, disables unneeded POSIX IPC/APIs, removes compaction/swap. Build, boot, and re-measure before citing. |

_Note: the uninstrumented tinyconfig baseline is 124,938 DWARF SLOC
([Hello Init Section 7.2](./HelloInit.md#72-build-and-sizing-iteration-record-v73-rc5-arm64)).
GCOV, self-tests, and suite prerequisites increase it to 164,992.
Earlier [Kernel Config Analysis](KernelConfigAnalysis.md) figures use LTS v6.18._

This iterative cycle—combining bottom-up Kconfig construction, whole-kernel GCOV
profiling, DWARF deadweight auditing, and research-backed configuration pruning—provides
a repeatable engineering method for tailoring Linux images for safety-critical deployments.

## 10. Measurement Environment, Core Count & Timing Record

The coverage numbers in this appendix are sensitive to how many CPUs the guest
runs on and how long each stage is given. Record these alongside the coverage
tables so a reviewer can reproduce and compare runs.

**Guest is single-core (single-processor SMP).** The QEMU commands in this guide
pass **no `-smp` flag**, so the `virt` machine presents **one vCPU**. The kernel
confirms this at boot:

```text
smp: Bringing up secondary CPUs ...
smp: Brought up 1 node, 1 CPU
SMP: Total of 1 processors activated.
```

This is intentional for the baseline: a single core makes stage ordering
deterministic and keeps GCOV counters free of cross-CPU interleaving. To measure
multi-core behavior (e.g. scheduler, RCU, per-CPU paths), add `-smp <N>` to the
QEMU command and re-record — the coverage and especially the timing will change.

**Measured environment and timing (2026-10-18):**

| Item                                       | Value                                                                                                      |
| :----------------------------------------- | :--------------------------------------------------------------------------------------------------------- |
| Host cores (`nproc`)                       | 22                                                                                                         |
| Host RAM                                   | 31 GiB                                                                                                     |
| Guest vCPUs                                | **1** (no `-smp`; `SMP: Total of 1 processors activated`)                                                  |
| Toolchain                                  | GCC 13.3.0, binutils 2.42, QEMU 8.2.2, cloc 1.98, target glibc 2.39                                        |
| Guest RAM                                  | 1024 MiB; approximately 7.6 MB initramfs with stress-ng and Syzkaller                                      |
| Build: GCOV baseline `Image` (`make -j11`) | 94.91 s                                                                                                    |
| Build: GCOV pruned `Image` (`make -j11`)   | 90.16 s                                                                                                    |
| Corrected Section 4 exploration            | 539.64 s baseline / 484.94 s pruned; all checkpoints exported, no class watchdogs, suite failures recorded |
| Dominant corrected run cost                | stress-ng class sweep; unsupported stressors and resource failures remain                                  |

Independent builds and guests overlap on this host; these times are records,
not latency targets. Record job count, guest cores, stage durations, suite
results, and watchdog limits whenever regenerating the tables.

## 11. References & Navigation

- [Hello Init (Practice)](./HelloInit.md) — foundational practice walkthrough and single-syscall reachability baseline.
- [Hello cFS](./HelloCFS.md) — flight application scenario applying minimization to NASA cFS.
- [Software Minimization](../SoftwareMinimization.md) — parent framing document on aerospace kernel minimization and assurance boundaries.
- [Kernel Config Analysis](./KernelConfigAnalysis.md) — historical reference minimal configurations and SLOC comparisons.
- [Kernel Complexity](./KernelComplexity.md) — defining and measuring build-time and runtime complexity.
- [Certification Progression](./CertificationProgression.md) — assurance level progression (DO-178C, DO-297, AMC 20-193).
