<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->
<!-- markdownlint-disable MD013 -->

# Hello cFS (Flight Workload)

This document applies the kernel minimization discipline to the NASA Core Flight
System (cFS), following the methodology established in [Hello Init (Practice)](./HelloInit.md).
It provides the initial baseline, pruning workflow, and observation tables for
evaluating cFS directly as PID 1 in a minimal Linux environment.

## Table of Contents

- [Hello cFS (Flight Workload)](#hello-cfs-flight-workload)
  - [Table of Contents](#table-of-contents)
  - [1. Prerequisites](#1-prerequisites)
  - [2. Environment](#2-environment)
  - [3. Step 0: Initial cFS Flight Workload Baseline](#3-step-0-initial-cfs-flight-workload-baseline)
    - [3.1 Build](#31-build)
    - [3.2 Test](#32-test)
    - [3.3 Measure](#33-measure)
  - [4. Step 1: Iterative Pruning](#4-step-1-iterative-pruning)
    - [4.1 Build](#41-build)
    - [4.2 Test](#42-test)
    - [4.3 Measure](#43-measure)
  - [5. Measure and Record: Observation Tables](#5-measure-and-record-observation-tables)
    - [Measurement Denominators and SLOC Accounting](#measurement-denominators-and-sloc-accounting)
    - [5.1 Experiment Artifacts and Provenance Anchor](#51-experiment-artifacts-and-provenance-anchor)
    - [5.2 Build and Sizing Iteration Record](#52-build-and-sizing-iteration-record)
    - [5.3 User Space Footprint (Static vs Deployed)](#53-user-space-footprint-static-vs-deployed)
    - [5.4 Runtime Coverage (KCOV) Symbolized Reachability](#54-runtime-coverage-kcov-symbolized-reachability)
  - [Appendix 1. References](#appendix-1-references)

## 1. Prerequisites

Before evaluating cFS:

- **Practice walkthrough:** Review [Hello Init (Practice)](./HelloInit.md)
  for the baseline PID 1 launch, feature probing, and SLOC measurement mechanics.
- **Aerospace context:** Review [Software Minimization](../SoftwareMinimization.md)
  for safety-critical framing and assurance boundaries.
- **cFS Compilation Reference:** See [Rob Woolley's cFS Compilation Environment Recipe](https://gist.github.com/robwoolley/04ea0872a8ceb6cf7d3fa0ebab180b64#file-gistfile1-txt)
  for full cFS submodule provisioning (`cfe`, `osal`, `psp`) and CMake cross-compilation for ARM64 Linux.

## 2. Environment

This walkthrough uses containerized builds executed from the repository root. Dedicated step Dockerfiles in [docs/minimal-linux/hello-cfs/](./hello-cfs/README.md) encapsulate the complete cross-toolchain, kernel checkout, initramfs packing, sizing, and QEMU execution:

* `docs/minimal-linux/hello-cfs/Dockerfile.step0-cfs-baseline`
* `docs/minimal-linux/hello-cfs/Dockerfile.step1-cfs-prune`

> **Interactive Debugging Console & Bind-Mounting Local Sources:**
> Each container image includes `vim`, `kernel-sloc` on `PATH`, and all cross-compilation utilities. To launch an interactive debug shell inside any built image to inspect the kernel tree (`/workspace/linux`), generated `.config`, or staged `rootfs` instead of launching QEMU directly:
> ```sh
> docker run --rm -it --entrypoint bash hellocfs-step0
> ```
>
> To bind-mount a local Linux tree (e.g. `./linux`) over `/workspace/linux`:
> ```sh
> docker run --rm -it \
>     -v "$(pwd)/linux:/workspace/linux" \
>     --entrypoint bash \
>     hellocfs-step0
> ```

## 3. Step 0: Initial cFS Flight Workload Baseline

Evaluates cFS directly as PID 1 without a service manager. The baseline kernel establishes support for cFS OSAL primitives (POSIX timers, POSIX message queues, and IPv4/UDP socket telemetry).

### 3.1 Build

Build the initial baseline image using its dedicated Dockerfile:

```sh
docker build -f docs/minimal-linux/hello-cfs/Dockerfile.step0-cfs-baseline -t hellocfs-step0 .
```

### 3.2 Test

Boot the kernel under QEMU emulation:

```sh
docker run --rm -it hellocfs-step0
```

**Expected Console Output:**
```text
Booting Linux on physical CPU 0x0000000000 [0x411fd070]
Linux version 7.3.0-rc5+ (...) (aarch64-linux-gnu-gcc ...) #1 SMP PREEMPT ...
Serial: AMBA PL011 UART driver
printk: console [ttyAMA0] enabled
Unpacking initramfs...
Run /init as init process
========================================
NASA Core Flight System (cFS) PID 1 Boot
========================================
CFE Core Executive Services: Initializing...
CFE Event Services: Registered
CFE Table Services: Initialized
CFE Time Services: Synchronized
cFS Steady Housekeeping Loop: RUNNING
```

_Pass criterion:_ Kernel unpacks the rootfs, launches cFS directly as PID 1, initializes OSAL and core applications (CFE Core, Executive Services, Event Services), and enters the steady housekeeping loop without init panic. (Press `Ctrl-a` then `x` to exit QEMU).

### 3.3 Measure

Display the consolidated metrics report:

```sh
docker run --rm hellocfs-step0 cat /workspace/metrics.txt
```

*(Optional)* Extract raw measurement files to host:

```sh
docker run --rm hellocfs-step0 cat /workspace/linux/sloc-dwarf.txt > sloc-dwarf-cfs-step0.txt
docker run --rm hellocfs-step0 cat /workspace/linux/linked.json > linked-cfs-step0.json
```

---

## 4. Step 1: Iterative Pruning

Iterates by pruning unused driver classes, bus subsystems, and non-essential kernel layers from the baseline configuration.

### 4.1 Build

```sh
docker build -f docs/minimal-linux/hello-cfs/Dockerfile.step1-cfs-prune -t hellocfs-step1 .
```

### 4.2 Test

```sh
docker run --rm -it hellocfs-step1
```

### 4.3 Measure

Display the consolidated pruning metrics:

```sh
docker run --rm hellocfs-step1 cat /workspace/metrics.txt
```

---

## 5. Measure and Record: Observation Tables

### Measurement Denominators and SLOC Accounting

To ensure consistent comparison across tables, this walkthrough tracks three primary source line metrics:

- **Base Linked DWARF SLOC (Uninstrumented):** Total unique source lines linked into `vmlinux` for the target configuration (measured via `kernel-sloc dwarf vmlinux`).
- **Compiled Source SLOC:** Total lines across all source files compiled into the build, derived from `compile_commands.json` (measured via `kernel-sloc kernel .`).
- **KCOV-Instrumented Linked DWARF SLOC:** Total linked source lines with KCOV compiler trace callbacks enabled, providing the exact denominator for single-syscall reachability calculations.

### 5.1 Experiment Artifacts and Provenance Anchor

Anchoring cFS experiment parameters ensures reviewable and reproducible metrics:

| Parameter                 | Recorded Value / Anchor                                                                                           |
| ------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| **Execution Environment** | Standalone containerized builds (`ubuntu:24.04`, `docs/minimal-linux/hello-cfs/Dockerfile.step*`)                 |
| **Kernel Repository**     | `https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git` (`ARG KERNEL_REPO`)                     |
| **Release Tag / Commit**  | `v7.3-rc5` (`ARG KERNEL_TAG`, tag commit `72d3fcf802c4`)                                                          |
| **Target Architecture**   | `arm64` (`ARCH=arm64`, `CROSS_COMPILE=aarch64-linux-gnu-`)                                                        |
| **Compiler & Linker**     | GCC `13.3.0` (`aarch64-linux-gnu-gcc`), GNU ld `2.42` (`binutils-aarch64-linux-gnu`)                              |
| **Target C Library**      | glibc `2.39` (`libc6-dev-arm64-cross`)                                                                            |
| **SLOC Helper / Counter** | `scripts/kernel-sloc` (SHA-256 `4f83ebd27759f6bff2d696260e665849575d1b31a5940676a57140f8c94e4f40`); `cloc` `1.98` |
| **Emulator Environment**  | QEMU `8.2.2` (`qemu-system-aarch64`, `-machine virt -cpu cortex-a57`), one vCPU                                   |

### 5.2 Build and Sizing Iteration Record

| Configuration Step          | Adjustment / Kconfig Delta           | DWARF SLOC | Compiled Source SLOC | Raw Image | Compressed Image (`.gz`) |
| --------------------------- | ------------------------------------ | ---------- | -------------------- | --------- | ------------------------ |
| `0. Initial cFS baseline`   | Baseline POSIX timers + mqueue + NET | _Record_   | _Record_             | _Record_  | _Record_                 |
| `1. Driver & feature prune` | Prune unused driver subsystems       | _Record_   | _Record_             | _Record_  | _Record_                 |

### 5.3 User Space Footprint (Static vs Deployed)

| Configuration Step        | User Space Component | Purpose / Description | Source SLOC | Static ELF (unstripped) | Stripped Binary | `initramfs-cfs.cpio.gz` Archive |
| :------------------------ | :------------------- | :-------------------- | :---------- | :---------------------- | :-------------- | :------------------------------ |
| `0. Initial cFS baseline` | `core-cfs`           | cFS Core & Apps       | _Record_    | _Record_                | _Record_        | _Record_                        |

### 5.4 Runtime Coverage (KCOV) Symbolized Reachability

| Kernel Subsystem / File  | Activated Functions | Sample Instruction Addresses | Unique Lines | Observation Scope             |
| :----------------------- | :------------------ | :--------------------------- | :----------- | :---------------------------- |
| _Subsystem path_         | _Function names_    | _PC list_                    | _Line count_ | Baseline cFS execution window |
| **Total Syscall Window** | _PCs_               | —                            | **Lines**    | **Baseline reachability**     |

## Appendix 1. References

- [Kernel Minimization Guide (Draft PR)](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html)
  (`Documentation/admin-guide/kernel-minimization.rst`) — base build, iterate, evaluate, and measurement method.
- [Workload Tracing Guide (Draft PR)](https://matthew-l-weber.github.io/linux/admin-guide/workload-tracing.html)
  (`Documentation/admin-guide/workload-tracing.rst`) — syscall and kernel-path discovery, including minimal user space.
- [Software Minimization](../SoftwareMinimization.md) — devcontainer setup,
  aerospace framing, and observations.
- [Hello Init (Practice)](./HelloInit.md) — foundational PID 1 practice walkthrough and measurement baseline.
- [Maximizing Kernel Coverage](./MaxCoverageMultiSuite.md) — whole-kernel structural coverage and test suite profiling.
- [Kernel Config Analysis](./KernelConfigAnalysis.md) — historical reference configuration comparison.
