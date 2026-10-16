<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Hello cFS

This document proposes applying the [kernel-minimization draft](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html)
to the NASA Core Flight System (cFS), following the same structure and
observation methodology established in [Hello Init (Practice)](./HelloInit.md).
It provides the execution sequence, verification checks, and baseline measurements
for evaluating cFS directly as PID 1 in a minimal Linux environment.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Environment](#environment)
- [Get the kernel sources](#get-the-kernel-sources)
- [Change: Kernel options & configuration](#change-kernel-options--configuration)
- [Build & Test: Workload execution & probing](#build--test-workload-execution--probing)
  - [1. PID 1 cFS Workload Boot](#1-pid-1-cfs-workload-boot)
  - [2. Feature Probing (OSAL & Subsystem Probes)](#2-feature-probing-osal--subsystem-probes)
- [Measure & Record: Gather findings](#measure--record-gather-findings)
  - [Metrics](#metrics)
  - [Runtime Coverage Collection (KCOV)](#runtime-coverage-collection-kcov)
    - [Calculating Kernel Coverage Percentage](#calculating-kernel-coverage-percentage)
- [Measure & Record: Observation tables](#measure--record-observation-tables)
  - [1. Experiment Artifacts & Provenance Anchor](#1-experiment-artifacts--provenance-anchor)
  - [2. Build & Sizing Iteration Record](#2-build--sizing-iteration-record)
  - [3. User Space Footprint (Static vs Deployed)](#3-user-space-footprint-static-vs-deployed)
  - [4. Runtime Coverage (KCOV) Symbolized Reachability](#4-runtime-coverage-kcov-symbolized-reachability)
- [References](#references)

## Prerequisites

Before evaluating cFS:

- **Practice walkthrough:** Complete or review [Hello Init (Practice)](./HelloInit.md)
  to understand the baseline PID 1 launch, feature probing, KCOV tracing, and
  SLOC collection workflow.
- **Upstream foundational guides:** Read the upstream
  [kernel-minimization draft](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html)
  and [workload-tracing draft](https://matthew-l-weber.github.io/linux/admin-guide/workload-tracing.html).
- **Aerospace context:** Review [Software Minimization](../SoftwareMinimization.md)
  for safety-critical framing and assurance boundaries.

## Environment

Run the walkthrough inside the **ELISA AeroWG devcontainer**:

- Reopen this repository in the VS Code devcontainer, or follow
  [Get a development shell](../../demos/docs/Development.md#get-a-development-shell)
  (`make prep` / `make dev` in `demos/copilot/src/monitors`).
- The container includes all necessary native build tools, the `aarch64-linux-gnu`
  cross-compiler toolchain (`gcc-aarch64-linux-gnu`), QEMU (`qemu-system-aarch64`),
  `cloc`, `cpio`, `file`, and Python utilities.

Set the cross-compilation architecture and toolchain prefix once for all
subsequent `make` commands:

```sh
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
```

## Get the kernel sources

Shallow clone the target longterm/LTS branch (or release tag noted in the [Experiment Artifacts & Provenance Anchor](#1-experiment-artifacts--provenance-anchor) below) from kernel.org (or use the meta-aerospace kernel source reference):

```sh
git clone --depth 1 --branch linux-6.18.y \
    https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git \
    linux
cd linux
```

## Change: Kernel options & configuration

cFS is the proposed flight workload for the same no-init, PID 1 launch model.
Its C library, OS Abstraction Layer (OSAL), and platform configuration determine
the actual syscall, threading, storage, and networking requirements. Header
usage alone does not establish the required kernel configuration.

Approach:

- Evaluate launching cFS directly as PID 1, without a service manager. Use
  `/init` or `rdinit=<path>` for an initramfs, or `init=<path>` for a mounted
  root filesystem, and validate the application's PID 1 responsibilities.
- Start from a measurement kernel config (e.g. the config the Nix work refined)
  and build a meta-aerospace cFS image against it.
- Iterate by removing kernel and user-space features cFS does not exercise,
  re-testing each step.
- Where a removal breaks cFS, investigate and record the failure and recovery
  before treating the option as a workload requirement.

## Build & Test: Workload execution & probing

Test and evaluate candidate builds under QEMU emulation following the
workload execution and probing discipline:

### 1. PID 1 cFS Workload Boot
Package the target cFS executable as `/init` (or target via `rdinit=`) inside
an initramfs or root filesystem image. Boot under QEMU:

```sh
qemu-system-aarch64 -machine virt -cpu cortex-a57 -nographic \
    -kernel arch/arm64/boot/Image \
    -initrd initramfs-cfs.cpio.gz \
    -append 'console=ttyAMA0'
```

*Pass criterion:* Kernel unpacks the rootfs, launches cFS directly as PID 1,
initializes OSAL and core applications (e.g., CFE Core, Executive Services,
Event Services), and enters the steady-state housekeeping loop without triggering
an init panic or unhandled exception.

### 2. Feature Probing (OSAL & Subsystem Probes)
Validate isolated OSAL and networking dependencies using focused probe binaries
before full application integration:
- Socket / UDP network telemetry probing (`cfs-probe-net`).
- POSIX message queue / shared memory probing (`cfs-probe-ipc`).
- Timer and clock monotonic precision probing (`cfs-probe-timer`).

## Measure & Record: Gather findings

Follow the upstream guides for measuring kernel image sizes, source lines of
code (SLOC), and runtime execution reachability:

### Metrics

Follow the upstream guides for measuring kernel image sizes, source lines of
code (SLOC), and user space footprints:

- **SLOC Counting:** Follow [Counting kernel SLOC](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html#counting-kernel-sloc):
  ```sh
  # DWARF-based line estimate from linked vmlinux
  CROSS_COMPILE=aarch64-linux-gnu- scripts/kernel-sloc --report linked.json dwarf vmlinux > sloc-dwarf.txt

  # Whole-file compiled source SLOC via compilation database
  python3 scripts/clang-tools/gen_compile_commands.py
  scripts/kernel-sloc --report compiled.json kernel . > sloc-compiled.txt
  ```

- **Image Sizing:** Follow [Measuring the image](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html#measuring-the-image):
  ```sh
  make Image.gz
  stat -c%s arch/arm64/boot/Image       # raw image byte size
  stat -c%s arch/arm64/boot/Image.gz    # compressed image byte size
  ```

- **User Space Footprints:** Follow [Measuring user space](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html#measuring-user-space):
  ```sh
  # Application and OSAL source SLOC
  cloc cfs/

  # Static binary size (unstripped and stripped)
  stat -c%s core-cfs
  aarch64-linux-gnu-strip -o core-cfs-stripped core-cfs && stat -c%s core-cfs-stripped

  # Archive size
  stat -c%s initramfs-cfs.cpio.gz
  ```

### Runtime Coverage Collection (KCOV)

KCOV measures task-scoped in-kernel reachability during cFS task execution and
message dispatching. Application-level coverage of cFS apps and OSAL is managed
as a separate user-space verification activity.

Follow the upstream kernel guide for collection and symbolization:

1. **Enable KCOV & debug info:** Configure `CONFIG_KCOV=y`, `CONFIG_DEBUG_FS=y`, and
   DWARF debug info following [Dumping kernel coverage (kcov)](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html#dumping-kernel-coverage-kcov).
2. **Collect trace:** Instrument cFS task dispatch loops or probe hooks, mount debugfs,
   and capture execution logs under QEMU with `nokaslr`.
3. **Symbolize PCs:** Extract and resolve addresses following [Symbolizing PCs](https://matthew-l-weber.github.io/linux/dev-tools/kcov.html#symbolizing-pcs):
   ```sh
   awk '{gsub(/\r/,""); if (NF == 1 && $1 ~ /^0x[0-9a-fA-F]+$/) print $1}' kcov-cfs.log > kcov-pcs.txt
   aarch64-linux-gnu-addr2line -f -i -e vmlinux < kcov-pcs.txt > kcov-symbols.txt
   ```

#### Calculating Kernel Coverage Percentage

Follow [Dumping kernel coverage (kcov)](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html#dumping-kernel-coverage-kcov)
to calculate the proportion of the linked kernel codebase exercised by the target cFS execution window:

1. Extract unique `file:line` locations from `kcov-symbols.txt`:
   ```sh
   grep -v '^[a-zA-Z_]' kcov-symbols.txt | sort -u > kcov-lines.txt
   wc -l kcov-lines.txt
   ```
2. Compare unique executed kernel source lines against total linked DWARF SLOC (`sloc-dwarf.txt`):
   $$\text{Kernel Call Coverage (\%)} = \left(\frac{\text{Unique KCOV Executed Lines}}{\text{Total DWARF Linked SLOC}}\right) \times 100\%$$

## Measure & Record: Observation tables

Log the findings across iterations in the following observation tables. In some cases the information is current state and others a trending log of test observations.

### 1. Experiment Artifacts & Provenance Anchor

Anchoring cFS experiment parameters ensures reviewable and reproducible metrics:

| Parameter | Recorded Value / Anchor |
| --- | --- |
| **Repository Source** | *Record repository URL (e.g. kernel.org or meta-aerospace kernel reference)* |
| **Release Tag / Commit** | *Record branch, tag, or commit SHA* |
| **Target Architecture** | `arm64` (`ARCH=arm64`, `CROSS_COMPILE=aarch64-linux-gnu-`) |
| **Compiler & Toolchain** | *Record toolchain version (GCC / Clang; ELISA AeroWG Devcontainer, `demos/env/Dockerfile`)* |
| **Emulator Environment** | *Record QEMU machine, CPU model, and emulator version (ELISA AeroWG Devcontainer, `demos/env/Dockerfile`)* |

### 2. Build & Sizing Iteration Record

| Configuration Step | Adjustment / Kconfig Delta | DWARF SLOC | Compiled Source SLOC | Raw Image | Compressed Image (`.gz`) | Workload Status |
| --- | --- | --- | --- | --- | --- | --- |
| `0. Initial cFS baseline` | Baseline meta-aerospace kernel config | *Record* | *Record* | *Record* | *Record* | *Pass / Fail* |
| `1. Prune unused drivers` | `-CONFIG_DRIVERS_UNUSED` | *Record* | *Record* | *Record* | *Record* | *Pass / Fail* |
| `2. Prune network protocols` | Disable unused socket families | *Record* | *Record* | *Record* | *Record* | *Pass / Fail* |

### 3. User Space Footprint (Static vs Deployed)

Record user space sizes across application and OSAL components. Measure source SLOC (`cloc`), static unstripped/stripped ELF binaries (`stat`), and packaged rootfs archive sizes:

| User Space Component | Purpose / Description | Source SLOC | Static ELF (unstripped) | Stripped Binary | `initramfs-cfs.cpio.gz` Archive |
| --- | --- | --- | --- | --- | --- |
| `core-cfs` | cFS Core & Apps | *Record* | *Record* | *Record* | *Record* |
| `cfs-probe-net` | OSAL network probe | *Record* | *Record* | *Record* | *Record* |
| `cfs-probe-ipc` | OSAL IPC probe | *Record* | *Record* | *Record* | *Record* |
| `cfs-probe-timer` | OSAL timer probe | *Record* | *Record* | *Record* | *Record* |

### 4. Runtime Coverage (KCOV) Symbolized Reachability

Symbolized reachability evaluating specific test scenarios by pairing a kernel configuration step (from [Section 2](#2-build--sizing-iteration-record)) with a target workload application (from [Section 3](#3-user-space-footprint-static-vs-deployed)). Populate these tables with unique executed line counts and coverage percentages as test runs are executed:

#### 4.0 Scenario 0: Initial cFS Baseline (`Step 0: Initial cFS baseline` + `core-cfs` / probes)

*Record reachability for the steady-state cFS execution window on the baseline kernel config:*

| Kernel Subsystem / File | Activated Functions | Sample Instruction Addresses | Unique Lines | Kernel Coverage Share (%) | Observation Scope |
| --- | --- | --- | --- | --- | --- |
| *Subsystem path* | *Function names* | *PC list* | *Line count* | *Percent* | Baseline cFS execution window |
| **Total Syscall Window** | *PCs* | — | **Lines** | **%** | **Baseline reachability** |

#### 4.1 Scenario 1: Pruning Drivers (`Step 1: Prune unused drivers` + `core-cfs`)

*Record reachability after eliminating unused driver groups:*

| Kernel Subsystem / File | Activated Functions | Sample Instruction Addresses | Unique Lines | Kernel Coverage Share (%) | Observation Scope |
| --- | --- | --- | --- | --- | --- |
| *Subsystem path* | *Function names* | *PC list* | *Line count* | *Percent* | Task-scoped execution window |
| **Total Syscall Window** | *PCs* | — | **Lines** | **%** | **Post-pruning reachability** |

#### 4.2 Scenario 2: Pruning Networking (`Step 2: Prune network protocols` + `core-cfs` / `cfs-probe-net`)

*Record reachability when evaluating socket and network protocol pruning:*

| Kernel Subsystem / File | Activated Functions | Sample Instruction Addresses | Unique Lines | Kernel Coverage Share (%) | Observation Scope |
| --- | --- | --- | --- | --- | --- |
| *Subsystem path* | *Function names* | *PC list* | *Line count* | *Percent* | Task-scoped execution window |
| **Total Syscall Window** | *PCs* | — | **Lines** | **%** | **Post-pruning reachability** |

## References

- [Kernel-minimization draft](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html)
  — base build, iterate, evaluate, and measurement method.
- [Workload-tracing draft](https://matthew-l-weber.github.io/linux/admin-guide/workload-tracing.html)
  — syscall and kernel-path discovery, including minimal user space.
- [Software Minimization](../SoftwareMinimization.md) — devcontainer setup,
  aerospace framing, and [general observations](../SoftwareMinimization.md#general-observations).
