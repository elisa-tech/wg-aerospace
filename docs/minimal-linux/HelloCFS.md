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
- **cFS Compilation Reference:** See [Building cFS](../../demos/docs/Build-cFS.md) and [Rob Woolley's cFS Compilation Environment Recipe](https://gist.github.com/robwoolley/04ea0872a8ceb6cf7d3fa0ebab180b64#file-gistfile1-txt)
  for full cFS submodule provisioning (`cfe`, `osal`, `psp`), ARM64 CMake toolchain configuration (`aarch64-linux-gnu-gcc`), and staging `core-cpu1` with its `cf/` runtime directory into the initramfs.

## 2. Environment

This walkthrough uses containerized builds executed from the repository root. Dedicated step Dockerfiles in [docs/minimal-linux/hello-cfs/](./hello-cfs/README.md) encapsulate the complete cross-toolchain, kernel checkout, initramfs packing, sizing, and QEMU execution:

- `docs/minimal-linux/hello-cfs/Dockerfile.step0-cfs-baseline`
- `docs/minimal-linux/hello-cfs/Dockerfile.step1-cfs-prune`

> **Interactive Debugging Console & Bind-Mounting Local Sources:**
> Each container image includes `vim`, `kernel-sloc` on `PATH`, and all cross-compilation utilities. To launch an interactive debug shell inside any built image to inspect the kernel tree (`/workspace/linux`), generated `.config`, or staged `rootfs` instead of launching QEMU directly:
>
> ```sh
> docker run --rm -it --entrypoint bash hellocfs-step0
> ```
>
> To bind-mount a local Linux tree (e.g. `./linux`) over `/workspace/linux`:
>
> ```sh
> docker run --rm -it \
>     -v "$(pwd)/linux:/workspace/linux" \
>     --entrypoint bash \
>     hellocfs-step0
> ```

## 3. Step 0: Initial cFS Flight Workload Baseline

Evaluates full NASA cFS (`core-cpu1`) directly as PID 1 without a service manager. To avoid LGPL static-linking constraints and eliminate dynamic loader overhead in the minimal rootfs, cFS and its core applications (`cfe_assert`, `sample_lib`, `sch_lab`, `ci_lab`, `to_lab`, `sample_app`, `cf`, `hs`, `md`, `cs`, `fm`, `lc`, `sc`, `ds`, `hk`) are cross-compiled using the Bootlin `aarch64--musl` toolchain (`aarch64--musl--stable-2026.08-1` on `x86_64`, with fallback to the host cross-compiler on non-`x86_64` hosts) and linked into a single static ELF binary via OSAL's static loader (`OSAL_CONFIG_INCLUDE_STATIC_LOADER=TRUE`, `STATIC_APPLIST`, and `STATIC_SYMLIST`).

### Kernel Configuration Requirements Discovered for cFS PID 1

Starting from `make tinyconfig`, each kernel feature below was added in response to concrete runtime requirements during cFS initialization:

| Kconfig Options                                                   | cFS / OSAL / PSP Consumer                                      | Observed Failure When Omitted                                                              |
| ----------------------------------------------------------------- | -------------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| `PRINTK`, `TTY`, `SERIAL_AMBA_PL011`, `SERIAL_AMBA_PL011_CONSOLE` | Kernel & `OS_printf` console output                            | No serial console output on QEMU `virt` (`ttyAMA0`)                                        |
| `BINFMT_ELF`, `BLK_DEV_INITRD`                                    | Kernel initramfs unpack & ELF loader                           | Kernel cannot unpack `initramfs-cfs.cpio.gz` or execute `/init` (`core-cpu1`)              |
| `FUTEX`, `RT_MUTEXES` (selects `FUTEX_PI`)                        | `OS_Posix_TableMutex_Init()` (`PTHREAD_PRIO_INHERIT`)          | `OS_Posix_TableMutex_Init():233:Error: pthread_mutex_init failed: Operation not supported` |
| `POSIX_TIMERS`                                                    | `timebase_posix_clock` & OSAL timers (`clock_gettime`)         | POSIX clock / timer creation failure in `CFE_PSP` timebase initialization                  |
| `POSIX_MQUEUE`                                                    | `OS_QueueCreate_Impl()` (`mq_open`, `mq_unlink`)               | Software Bus message queue creation failure (`ENOSYS`)                                     |
| `SHMEM`, `TMPFS`, `SYSVIPC`                                       | `CFE_PSP` (`shmget` CDS/Reset/User segments) & `/tmp` RAM disk | `CFE_PSP - Cannot shmget CDS Shared memory Segment: Function not implemented`              |
| `NET`, `INET`                                                     | `CI_LAB` (UDP port 1234) & `TO_LAB` telemetry sockets          | Socket creation failure (`EAFNOSUPPORT`) in command ingest and telemetry apps              |

> **Rootfs Directory Note (`OS_FileSysStartVolume_Impl`):**
> In addition to kernel Kconfig options, `OS_FileSysStartVolume_Impl()` probes `/dev/shm`, `$TMPDIR`, `/var/tmp`, and `/tmp` for a writable directory to back cFS volatile (`RAM`) volumes. If none of those directories exist in the cpio archive, cFS aborts during early init with:
> `CFE_ES_InitializeFileSystems: Error Creating Volatile(RAM) Volume. EC = -106`.
> Creating `/tmp` and `/dev/shm` in the staged initramfs resolves this without mounting a separate filesystem.

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
Linux version 7.3.0-rc5 (...) (aarch64-linux-gnu-gcc ...) #1 SMP PREEMPT ...
Serial: AMBA PL011 UART driver
printk: console [ttyAMA0] enabled
Unpacking initramfs...
Run /init as init process
CFE_PSP: Default Reset SubType = 1
CFE_PSP: Default CPU ID = 1
CFE_PSP: Default Spacecraft ID = 66
CFE_PSP: Default CPU Name: cpu1
OS_Posix_GetSchedulerParams():208:Policy 1: available, min-max: 1-99
OS_Posix_GetSchedulerParams():208:Policy 2: available, min-max: 1-99
OS_Posix_TaskAPI_Impl_Init():401:Selected policy 2 for RT tasks, root task = 99
CFE_PSP: initializing module 'soft_timebase' with ID 0110ff00
CFE_PSP: Instantiated software timebase 'cFS-Master' running at 10000 usec
CFE_PSP: initializing module 'timebase_posix_clock' with ID 0110ff01
CFE_PSP: Using POSIX monotonic clock as CFE timebase
...
CFE_PSP: Starting the cFE with a POWER ON reset.
1980-001-00:00:01.32100 CFE_ES_SetupResetVariables: POWER ON RESET due to Power Cycle (Power Cycle).
1980-001-00:00:01.32275 CFE_ES_Main: CFE_ES_Main in EARLY_INIT state
1980-001-00:00:01.32401 CFE_ES_Main: CFE_ES_Main entering CORE_STARTUP state
EVS Port1 1980-012-14:03:20.06811 66/1/CFE_ES 1: cFE ES Initialized: CFE_ES v7.0.2-rc1-oss (Draco) DEV BUILD, based on v7.0.1, EDS disabled
...
1980-012-14:03:20.61639 CI_LAB listening on UDP port: 1234
EVS Port1 1980-012-14:03:20.61666 66/1/CI_LAB 3: CI Lab Initialized.CI Lab App v7.0.2-rc1-oss (Draco) DEV BUILD, based on v7.0.1, EDS disabled
EVS Port1 1980-012-14:03:20.61996 66/1/TO_LAB 1: TO Lab Initialized.TO Lab v7.0.2-rc1-oss (Draco) DEV BUILD, based on v7.0.1, EDS disabled, Awaiting enable command.
EVS Port1 1980-012-14:03:20.62147 66/1/SAMPLE_APP 1: Sample App Initialized.Sample App v7.0.2-rc1-oss (Draco) DEV BUILD, based on v7.0.1, EDS disabled
1980-012-14:03:20.65044 CFE_ES_Main: CFE_ES_Main entering APPS_INIT state
1980-012-14:03:20.65068 CFE_ES_Main: CFE_ES_Main entering OPERATIONAL state
EVS Port1 1980-012-14:03:20.67581 66/1/TO_LAB 19: L549 TO Lab subscribed to 31 messages from the table
EVS Port1 1980-012-14:03:22.00083 66/1/CFE_TIME 21: Stop FLYWHEEL
```

_Pass criterion:_ Kernel unpacks the rootfs, launches `core-cpu1` directly as PID 1 (`/init`), initializes OSAL (selecting `SCHED_RR` policy 2 for RT tasks) and CFE core services (`CFE_ES`, `CFE_EVS`, `CFE_SB`, `CFE_TBL`, `CFE_TIME`), loads the statically linked applications (`cfe_assert`, `sample_lib`, `sch_lab`, `ci_lab`, `to_lab`, `sample_app`) and tables from `/cf`, enters `OPERATIONAL` state, and transitions out of time flywheel mode (`Stop FLYWHEEL`) without panic. (Press `Ctrl-a` then `x` to exit QEMU).

### 3.3 Measure

Display the consolidated metrics report:

```sh
docker run --rm hellocfs-step0 cat /workspace/metrics.txt
```

_(Optional)_ Extract raw measurement files to host:

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
| **cFS Repository & Pin**  | `https://github.com/nasa/cFS.git` (`ARG CFS_COMMIT=1ca3a956d05348d2dce22447fa5eda74ddd89a55`, Draco `v7.0.2-rc1`) |
| **Target Architecture**   | `arm64` (`ARCH=arm64`, `CROSS_COMPILE=aarch64-linux-gnu-`)                                                        |
| **Kernel Toolchain**      | GCC `13.3.0` (`aarch64-linux-gnu-gcc`), GNU ld `2.42` (`binutils-aarch64-linux-gnu`)                              |
| **User Space Toolchain**  | Bootlin `aarch64--musl--stable-2026.08-1` (GCC `15.3.0`, musl libc; SHA-256 `b388c480a48e...`)                    |
| **SLOC Helper / Counter** | `scripts/kernel-sloc` (SHA-256 `4f83ebd27759f6bff2d696260e665849575d1b31a5940676a57140f8c94e4f40`); `cloc` `1.98` |
| **Emulator Environment**  | QEMU `8.2.2` (`qemu-system-aarch64`, `-machine virt -cpu cortex-a57`), one vCPU                                   |

### 5.2 Build and Sizing Iteration Record

| Configuration Step          | Adjustment / Kconfig Delta                                                                 | DWARF SLOC  | Compiled Source SLOC    | Raw Image             | Compressed Image (`.gz`) |
| --------------------------- | ------------------------------------------------------------------------------------------ | ----------- | ----------------------- | --------------------- | ------------------------ |
| `0. Initial cFS baseline`   | `tinyconfig` + UART + `INITRD` + `FUTEX_PI` + `POSIX_TIMERS`/`MQUEUE` + `SYSVIPC` + `INET` | **203,682** | **538,768** (801 files) | 4,562,952 B (4.56 MB) | 1,865,171 B (1.87 MB)    |
| `1. Driver & feature prune` | Prune unused driver subsystems                                                             | _Record_    | _Record_                | _Record_              | _Record_                 |

### 5.3 User Space Footprint (Static vs Deployed)

| Configuration Step        | User Space Component                | Purpose / Description                                              | cFS DWARF SLOC | cFS Compiled SLOC      | Static ELF (unstripped) | Stripped Binary      | `initramfs-cfs.cpio.gz` Archive |
| :------------------------ | :---------------------------------- | :----------------------------------------------------------------- | :------------- | :--------------------- | :---------------------- | :------------------- | :------------------------------ |
| `0. Initial cFS baseline` | `core-cpu1` (`/init` + `/cf/*.tbl`) | Statically linked NASA cFS (`cfe`, `osal`, `psp`, core & lab apps) | **31,342**     | **74,480** (434 files) | 2,696,256 B (2.70 MB)   | 911,232 B (911.2 KB) | 1,018,578 B (1.02 MB)           |

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
- [Kernel Config Analysis](./KernelConfigAnalysis.md) — historical reference configuration comparison.
