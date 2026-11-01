<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->
<!-- markdownlint-disable MD013 -->

# Hello Init (Practice)

This document demonstrates applying the [kernel-minimization draft](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html)
to a minimal static "hello world" PID 1 application. It serves as the foundational
practice walkthrough and template for complex workloads such as
[Hello cFS](./HelloCFS.md). This page provides the practical end-to-end
execution sequence, verification checks, and baseline measurements.

## Table of Contents

- [Hello Init (Practice)](#hello-init-practice)
  - [Table of Contents](#table-of-contents)
  - [1. Prerequisites](#1-prerequisites)
  - [2. Environment](#2-environment)
  - [3. Step 0: Minimal `tinyconfig` Baseline](#3-step-0-minimal-tinyconfig-baseline)
    - [3.1 Build](#31-build)
    - [3.2 Test](#32-test)
    - [3.3 Measure](#33-measure)
  - [4. Step 1: Networking Feature Probe (`+NET +INET`)](#4-step-1-networking-feature-probe-net-inet)
    - [4.1 Build](#41-build)
    - [4.2 Test](#42-test)
    - [4.3 Measure](#43-measure)
  - [5. Step 2: Runtime Coverage Collection (`KCOV`)](#5-step-2-runtime-coverage-collection-kcov)
    - [5.1 Build](#51-build)
    - [5.2 Test](#52-test)
    - [5.3 Measure](#53-measure)
  - [6. Step 3: Monolithic `defconfig` Baseline](#6-step-3-monolithic-defconfig-baseline)
    - [6.1 Build](#61-build)
    - [6.2 Test](#62-test)
    - [6.3 Measure](#63-measure)
  - [7. Measure and Record: Observation Tables](#7-measure-and-record-observation-tables)
    - [Measurement Denominators and SLOC Accounting](#measurement-denominators-and-sloc-accounting)
    - [7.1 Experiment Artifacts and Provenance Anchor](#71-experiment-artifacts-and-provenance-anchor)
    - [7.2 Build and Sizing Iteration Record (v7.3-rc5, arm64)](#72-build-and-sizing-iteration-record-v73-rc5-arm64)
    - [7.3 User Space Footprint (Static vs Deployed)](#73-user-space-footprint-static-vs-deployed)
    - [7.4 Runtime Coverage (KCOV) Symbolized Reachability](#74-runtime-coverage-kcov-symbolized-reachability)
      - [7.4.1 Scenario 1: Minimal Kernel Network Feature Probe](#741-scenario-1-minimal-kernel-network-feature-probe)
      - [7.4.2 Scenario 2: Monolithic Baseline Network Feature Probe](#742-scenario-2-monolithic-baseline-network-feature-probe)
  - [Appendix 1. References](#appendix-1-references)
  - [Appendix 2. Non-Intrusive Syscall Tracing via QEMU GDB Stub](#appendix-2-non-intrusive-syscall-tracing-via-qemu-gdb-stub)

## 1. Prerequisites

Before running this walkthrough:

- **Upstream foundational guides:** Read the upstream
  [Kernel Minimization Guide (Draft PR)](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html)
  (`Documentation/admin-guide/kernel-minimization.rst`)
  and [Workload Tracing Guide (Draft PR)](https://matthew-l-weber.github.io/linux/admin-guide/workload-tracing.html)
  (`Documentation/admin-guide/workload-tracing.rst`)
  for core principles, configuration theory, and discovery mechanisms.
- **Aerospace context:** Review [Software Minimization](../SoftwareMinimization.md)
  for safety-critical framing and assurance boundaries.

## 2. Environment

This walkthrough uses containerized builds executed from the repository root. Dedicated step-by-step Dockerfiles in [docs/minimal-linux/hello-init/](./hello-init/README.md) encapsulate the complete toolchain (`ubuntu:24.04`, `gcc-aarch64-linux-gnu`, `qemu-system-aarch64`), kernel source checkout, initramfs packing, sizing, and QEMU execution:

- `docs/minimal-linux/hello-init/Dockerfile.step0-tinyconfig`
- `docs/minimal-linux/hello-init/Dockerfile.step1-net`
- `docs/minimal-linux/hello-init/Dockerfile.step2-kcov`
- `docs/minimal-linux/hello-init/Dockerfile.step3-defconfig`

Detailed explanations of kernel configuration symbols, build mechanics, and measurement commands are documented in comments directly inside each Dockerfile.

> **Interactive Debugging Console & Bind-Mounting Local Sources:**
> Each container image includes `vim`, `kernel-sloc` on `PATH`, and all cross-compilation utilities. To launch an interactive debug shell inside any built image to inspect the kernel tree (`/workspace/linux`), generated `.config`, or staged `rootfs` instead of launching QEMU directly:
>
> ```sh
> docker run --rm -it --entrypoint bash helloinit-step0
> ```
>
> If you have an existing Linux clone on your host (e.g. `./linux`), you can bind-mount it directly over `/workspace/linux` to iterate, edit with `vim`, and run custom `make` builds inside the container environment without rebuilding the image. Pass `--user` so files created in the mounted tree stay owned by you rather than by `root`:
>
> ```sh
> docker run --rm -it \
>     --user "$(id -u):$(id -g)" \
>     -v "$(pwd)/linux:/workspace/linux" \
>     --entrypoint bash \
>     helloinit-step0
> ```
>
> The mounted tree replaces the image's `/workspace/linux` and its build outputs, so run `kernel-sloc` from `PATH` there. Do not point two containers at the same mounted tree at the same time; see [Testing Steering Notes](./TestingSteeringNotes.md#1-how-to-use-these-notes).

## 3. Step 0: Minimal `tinyconfig` Baseline

Demonstrates the baseline bottom-up configuration: the kernel launches a minimal static binary directly as PID 1 from an initramfs, with no service manager, no shell, and no background daemons.

### 3.1 Build

The build is executed using `Dockerfile.step0-tinyconfig`. The Dockerfile clones the kernel release, sets up the ARM64 cross-compiler, compiles `ainit.c` as `/init`, enables essential Kconfig options (`PRINTK`, `TTY`, `SERIAL_AMBA_PL011`, `BINFMT_ELF`, `BLK_DEV_INITRD`, `-d MODULES`), and builds the monolithic `Image`.

**Customizing Build Arguments:**
You can override default parameters by supplying `--build-arg`:

| Build Argument       | Default Value                                                                     | Description                                                        |
| :------------------- | :-------------------------------------------------------------------------------- | :----------------------------------------------------------------- |
| `BASE_IMAGE`         | `ubuntu:24.04`                                                                    | Host base image providing cross-compilation toolchain              |
| `KERNEL_REPO`        | `https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git`         | Upstream or custom kernel Git repository                           |
| `KERNEL_TAG`         | `v7.3-rc5`                                                                        | Pinned kernel release tag or longterm branch (e.g. `linux-6.18.y`) |
| `SLOC_HELPER_URL`    | Pinned `scripts/kernel-sloc` raw URL (see the Dockerfile)                         | Download location of the measurement helper                        |
| `SLOC_HELPER_SHA256` | SHA-256 recorded in [Section 7.1](#71-experiment-artifacts-and-provenance-anchor) | Expected helper checksum; the build fails on a mismatch            |

```sh
docker build -f docs/minimal-linux/hello-init/Dockerfile.step0-tinyconfig -t helloinit-step0 .
```

### 3.2 Test

Boot the kernel under QEMU emulation:

```sh
docker run --rm -it helloinit-step0
```

**Expected Console Output (abridged):**

```text
Booting Linux on physical CPU 0x0000000000 [0x411fd070]
Linux version 7.3.0-rc5 (...) (aarch64-linux-gnu-gcc ...) #1 SMP PREEMPT ...
Serial: AMBA PL011 UART driver
9000000.pl011: ttyAMA0 MMIO:0x0000000009000000 (irq = 13, base_baud = 0) is a PL011 rev1
printk: console [ttyAMA0] enabled
Unpacking initramfs...
Run /init as init process
hello world
```

_Pass criterion:_ The kernel unpacks the initramfs, executes `/init` as PID 1, prints `hello world`, and idles in `pause()` without triggering an `Attempted to kill init!` panic. (Press `Ctrl-a` then `x` to exit QEMU).

### 3.3 Measure

Display the consolidated metrics report:

```sh
docker run --rm helloinit-step0 cat /workspace/metrics.txt
```

_(Optional)_ Extract raw measurement files and JSON reports to your host:

```sh
docker run --rm helloinit-step0 cat /workspace/linux/sloc-dwarf.txt > sloc-dwarf-step0.txt
docker run --rm helloinit-step0 cat /workspace/linux/linked.json > linked-step0.json
```

Recorded values are documented in [Section 7.2](#72-build-and-sizing-iteration-record-v73-rc5-arm64) and [Section 7.3](#73-user-space-footprint-static-vs-deployed).

---

## 4. Step 1: Networking Feature Probe (`+NET +INET`)

Demonstrates incremental feature addition. Toggles kernel networking support and evaluates user-space probe handling.

### 4.1 Build

Uses `Dockerfile.step1-net` to enable `CONFIG_NET` and `CONFIG_INET` on top of the minimal `tinyconfig` baseline, and statically compiles `ainit-net.c` into the initramfs:

```sh
docker build -f docs/minimal-linux/hello-init/Dockerfile.step1-net -t helloinit-step1 .
```

### 4.2 Test

Boot the kernel in QEMU:

```sh
docker run --rm -it helloinit-step1
```

**Expected Console Output:**

```text
hello world
NET-PROBE: IPv4/UDP socket available
```

### 4.3 Measure

Display the consolidated networking step metrics:

```sh
docker run --rm helloinit-step1 cat /workspace/metrics.txt
```

_(Optional)_ Extract the SLOC measurement report to your host:

```sh
docker run --rm helloinit-step1 cat /workspace/linux/sloc-dwarf.txt > sloc-dwarf-step1.txt
```

Recorded SLOC and binary sizing deltas are logged in [Section 7.2](#72-build-and-sizing-iteration-record-v73-rc5-arm64).

---

## 5. Step 2: Runtime Coverage Collection (`KCOV`)

Measures task-scoped runtime kernel reachability bounded by target system call execution (`socket(AF_INET, SOCK_DGRAM, 0)`).

### 5.1 Build

Uses `Dockerfile.step2-kcov` to compile a KCOV-instrumented kernel (`CONFIG_KCOV=y`, `CONFIG_DEBUG_FS=y`, with the same DWARF debug info as Steps 0 and 1) and packages `ainit-net-kcov.c`:

```sh
docker build -f docs/minimal-linux/hello-init/Dockerfile.step2-kcov -t helloinit-step2 .
```

### 5.2 Test

The Dockerfile boots QEMU during the image build, passing `nokaslr` to prevent virtual address relocation, captures the raw program counter (PC) trace, and resolves addresses via `addr2line`. The build fails if the console does not show `NET-PROBE: IPv4/UDP socket available` and a non-zero `KCOV captured N PCs` line.

### 5.3 Measure

Display the consolidated reachability metrics:

```sh
docker run --rm helloinit-step2 cat /workspace/metrics.txt
```

Display normalized unique reached kernel lines:

```sh
docker run --rm helloinit-step2
```

Extract the normalized line list to host:

```sh
docker run --rm helloinit-step2 cat /workspace/kcov-lines.txt > kcov-lines.txt
```

> **Note on KCOV vs Whole-Kernel Coverage:** KCOV is task-scoped to the calling thread and measures only the syscall execution window (~276 lines for `socket()`). Whole-kernel structural coverage is measured across all processes, interrupts, and boot paths in [the Maximizing Kernel Coverage example](./MaxCoverageMultiSuite.md).

Detailed reachability breakdowns are recorded in [Section 7.4](#74-runtime-coverage-kcov-symbolized-reachability).

---

## 6. Step 3: Monolithic `defconfig` Baseline

Builds the default ARM64 `defconfig` without loadable modules (`-d MODULES`) and with `KCOV` enabled, establishing the unminimized reference baseline for comparing SLOC, image footprint, and single-syscall reachability. With module support disabled, Kconfig builds every `defconfig` module into the image instead of dropping it: the resolved configuration has no `=m` entries and 4,824 `=y` entries.

### 6.1 Build

```sh
docker build -f docs/minimal-linux/hello-init/Dockerfile.step3-defconfig -t helloinit-step3 .
```

### 6.2 Test

The Dockerfile boots QEMU during the image build, passing `-m 512M` and `nokaslr` to prevent virtual address relocation, captures the monolithic raw program counter (PC) trace, and resolves addresses via `addr2line`. As in Step 2, the build fails if the probe output or the KCOV PCs are missing, and it prints the end of the console log. On the recorded host, PID 1 starts about 4 seconds into the boot, well inside the 30-second QEMU window.

### 6.3 Measure

Display the consolidated monolithic reference metrics:

```sh
docker run --rm helloinit-step3 cat /workspace/metrics.txt
```

Display normalized unique reached kernel lines:

```sh
docker run --rm helloinit-step3
```

Extract the normalized line list to host:

```sh
docker run --rm helloinit-step3 cat /workspace/kcov-lines.txt > kcov-lines-step3.txt
```

Comparative observations and reachability breakdowns against the minimal kernel are recorded in [Section 7.2](#72-build-and-sizing-iteration-record-v73-rc5-arm64) and [Section 7.4.2](#742-scenario-2-monolithic-baseline-network-feature-probe).

---

## 7. Measure and Record: Observation Tables

### Measurement Denominators and SLOC Accounting

To ensure consistent comparison across tables, this walkthrough tracks three primary source line metrics:

- **Base Linked DWARF SLOC (Uninstrumented):** Total unique source lines linked into `vmlinux` for the target configuration (measured via `kernel-sloc dwarf vmlinux`).
- **Compiled Source SLOC:** Total lines across all source files compiled into the build, derived from `compile_commands.json` (measured via `kernel-sloc kernel .`).
- **KCOV-Instrumented Linked DWARF SLOC:** Total linked source lines with KCOV compiler trace callbacks enabled, providing the exact denominator for single-syscall reachability calculations.

> **Note on Whole-Kernel GCOV Metrics:** Whole-kernel profiling metrics (such as GCOV executable source line unions and `.gcno` basic-block graph counters) measure execution across boot, interrupts, and multi-process test suites. These are not part of this PID 1 practice baseline; see [Maximizing Kernel Coverage](./MaxCoverageMultiSuite.md#6-measured-multi-stage-progression--differential-table-tinyconfig) for GCOV denominators and multi-suite analysis.

Log the findings across iterations in the following observation tables. In some cases the information is current state and others a trending log of test observations.

### 7.1 Experiment Artifacts and Provenance Anchor

Anchoring the baseline experiment parameters ensures reviewable and reproducible metrics:

| Parameter                 | Recorded Value / Anchor                                                                                           |
| ------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| **Execution Environment** | Standalone containerized builds (`ubuntu:24.04`, `docs/minimal-linux/hello-init/Dockerfile.step*`)                |
| **Base Image Digest**     | `ubuntu:24.04@sha256:fe81560990fae86dc4743202b2cb4d3df98d0bcf949173cecef15ce1127ef852` (2026-10-31 rebuild)       |
| **Kernel Repository**     | `https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git` (`ARG KERNEL_REPO`)                     |
| **Release Tag / Commit**  | `v7.3-rc5` (`ARG KERNEL_TAG`, tag commit `72d3fcf802c4`)                                                          |
| **Target Architecture**   | `arm64` (`ARCH=arm64`, `CROSS_COMPILE=aarch64-linux-gnu-`)                                                        |
| **Compiler & Linker**     | GCC `13.3.0` (`aarch64-linux-gnu-gcc`), GNU ld `2.42` (`binutils-aarch64-linux-gnu`)                              |
| **Target C Library**      | glibc `2.39` (`libc6-dev-arm64-cross`)                                                                            |
| **SLOC Helper / Counter** | `scripts/kernel-sloc` (SHA-256 `4f83ebd27759f6bff2d696260e665849575d1b31a5940676a57140f8c94e4f40`); `cloc` `1.98` |
| **Emulator Environment**  | QEMU `8.2.2` (`qemu-system-aarch64`, `-machine virt -cpu cortex-a57`), one vCPU                                   |

> **Note on Customization & Provenance:** The step Dockerfiles default to `v7.3-rc5` from kernel.org and download the verified `kernel-sloc` measurement helper. The `ubuntu:24.04` tag and its packages move over time, so record the base image digest and package versions with each run. When building against other releases or longterm branches (e.g. `--build-arg KERNEL_TAG=linux-6.18.y`), record the target tag and regenerate the measurement tables for that environment.

### 7.2 Build and Sizing Iteration Record (v7.3-rc5, arm64)

| Configuration Step          | Adjustment / Kconfig Delta                           | DWARF SLOC | Compiled Source SLOC    | Raw Image                   | Compressed Image (`.gz`)  |
| --------------------------- | ---------------------------------------------------- | ---------- | ----------------------- | --------------------------- | ------------------------- |
| `0. tinyconfig baseline`    | `tinyconfig` + PL011 serial, printk, initrd, elf     | 124,938    | 352,672 (600 files)     | 3,223,560 B (~3.07 MiB)     | 1,140,052 B (~1.09 MiB)   |
| `1. + Networking`           | `+NET`, `+INET`                                      | 197,490    | 527,040 (784 files)     | 4,495,368 B (~4.3 MiB)      | 1,810,215 B (~1.7 MiB)    |
| `2. + Networking + KCOV`    | `+KCOV`, `+DEBUG_FS`                                 | 209,321    | 533,116 (789 files)     | 5,552,136 B (~5.29 MiB)     | —                         |
| `3. defconfig (monolithic)` | `defconfig`, `-MODULES` (all `=m` built in), `+KCOV` | 2,070,838  | 5,722,530 (9,158 files) | 110,991,872 B (~105.85 MiB) | 36,250,252 B (~34.57 MiB) |

All steps build with DWARF debug info so the DWARF SLOC column is comparable. Steps 2 and 3 are KCOV-instrumented, so their DWARF SLOC is the instrumented denominator used in [Section 7.4](#74-runtime-coverage-kcov-symbolized-reachability).

### 7.3 User Space Footprint (Static vs Deployed)

| Configuration Step          | User Space Component            | Purpose / Description                  | Source SLOC | Static ELF (unstripped) | Stripped Binary      | `initramfs-*.cpio.gz` Archive |
| --------------------------- | ------------------------------- | -------------------------------------- | ----------- | ----------------------- | -------------------- | ----------------------------- |
| `0. tinyconfig baseline`    | `ainit` (glibc static)          | Minimal PID 1 hello world              | 9 lines     | 634,000 B (~619 KiB)    | 532,408 B (~520 KiB) | 279,560 B (~273 KiB)          |
| `1. + Networking`           | `ainit-net` (glibc static)      | Socket feature probe                   | 21 lines    | 634,984 B (~620 KiB)    | 532,408 B (~520 KiB) | 280,377 B (~274 KiB)          |
| `2. + Networking + KCOV`    | `ainit-net-kcov` (glibc static) | Combined socket probe + KCOV collector | 81 lines    | 704,704 B (~688 KiB)    | 597,944 B (~584 KiB) | 295,530 B (~289 KiB)          |
| `3. defconfig (monolithic)` | `ainit-net-kcov` (glibc static) | Combined socket probe + KCOV (ref)     | 81 lines    | 704,704 B (~688 KiB)    | 597,944 B (~584 KiB) | 295,530 B (~289 KiB)          |

### 7.4 Runtime Coverage (KCOV) Symbolized Reachability

Comparing single-syscall reachability for `socket(AF_INET, SOCK_DGRAM, 0)` between the minimized kernel (Step 2) and the monolithic baseline (Step 3) using `ainit-net-kcov.c`:

#### 7.4.1 Scenario 1: Minimal Kernel Network Feature Probe

Target feature probe `socket(AF_INET, SOCK_DGRAM, 0)` on the instrumented `tinyconfig + NET + INET` build (209,321 instrumented linked DWARF SLOC):

| Kernel Source File / Subsystem   | Activated Functions                                                      | Sample Instruction Addresses               | Unique Lines  | Observation Scope                                        |
| :------------------------------- | :----------------------------------------------------------------------- | :----------------------------------------- | :------------ | :------------------------------------------------------- |
| `net/socket.c`                   | `__sys_socket_create`, `sock_alloc_file`, `__sock_create`, `sock_map_fd` | `0xffff8000802296d0`                       | 32 lines      | Socket abstraction & syscall entry                       |
| `net/ipv4/af_inet.c`             | `inet_create`                                                            | `0xffff80008031332c`                       | 20 lines      | IPv4 protocol family socket creation                     |
| `net/core/sock.c`                | `sk_alloc`, `sock_init_data`, `sk_prot_alloc`                            | `0xffff80008022dd3c`                       | 24 lines      | Core socket allocation and state initialization          |
| `fs/file_table.c` & `fs/file.c`  | `alloc_file_pseudo`, `alloc_file`, `fd_install`, `get_unused_fd_flags`   | `0xffff800080106d9c`, `0xffff8000801294d4` | 51 lines      | VFS file allocation & descriptor binding                 |
| `fs/dcache.c` & `fs/inode.c`     | `d_alloc_pseudo`, `new_inode_pseudo`                                     | `0xffff800080121ce8`, `0xffff800080126574` | 37 lines      | Socket pseudo filesystem dentry/inode creation           |
| `arch/arm64/kernel/syscall.c`    | `el0_svc_common`, `do_el0_svc`, `invoke_syscall`                         | `0xffff80008001e81c`                       | 10 lines      | ARM64 syscall entry, dispatch & return paths             |
| `net/ipv4/udp.c`                 | `udp_init_sock`                                                          | `0xffff800080302170`                       | 4 lines       | UDP protocol socket initialization                       |
| _Other VFS, headers & libraries_ | Namespace, per-CPU counters, atomic bitops, timer init                   | —                                          | 98 lines      | Inline helpers, reference counting, KCOV_DISABLE ioctl   |
| **Total Syscall Window**         | _276 normalized source lines; 268 captured / 252 distinct PCs_           | —                                          | **276 lines** | **In-kernel socket() reachability (incl. KCOV_DISABLE)** |

> **Note on repeatability:** On an idle host these counts repeat exactly from boot to boot. When the host is heavily loaded (for example, while Step 3 compiles in parallel), guest timer interrupts can land inside the window and add a few interrupt-exit PCs in `kernel/irq.c` and `kernel/time/sched_clock.c` (observed: 276 captured, 286 lines). Re-run the capture on a quiet host, or add `-icount shift=4` to QEMU, before comparing totals; see [Testing Steering Notes](./TestingSteeringNotes.md#2-validating-the-hello-init-body-sections).

#### 7.4.2 Scenario 2: Monolithic Baseline Network Feature Probe

Target feature probe `socket(AF_INET, SOCK_DGRAM, 0)` on the KCOV-instrumented monolithic `defconfig` build (2,070,838 instrumented linked DWARF SLOC):

| Kernel Source File / Subsystem                     | Activated Functions                                                      | Sample Instruction Addresses               | Unique Lines  | Observation Scope                                    |
| :------------------------------------------------- | :----------------------------------------------------------------------- | :----------------------------------------- | :------------ | :--------------------------------------------------- |
| `net/socket.c`                                     | `__sys_socket_create`, `sock_alloc_file`, `__sock_create`, `sock_map_fd` | `0xffff800082a0092c`                       | 31 lines      | Socket layer syscall entry & allocation              |
| `fs/file_table.c`, `dcache.c`, `file.c`, `inode.c` | `alloc_file_pseudo`, `d_alloc_pseudo`, `fd_install`, `new_inode_pseudo`  | `0xffff80008044ba10`, `0xffff8000804779e4` | 93 lines      | VFS file, dentry & pseudo inode creation             |
| `net/core/sock.c` & `net/ipv4/af_inet.c`           | `sk_alloc`, `sock_init_data`, `inet_create`                              | `0xffff800082a07f50`, `0xffff800082bd674c` | 48 lines      | Core sock layer & IPv4 protocol init                 |
| `kernel/user_namespace.c` & `security/security.c`  | `ns_capable_common`, `security_socket_create`, LSM hooks                 | `0xffff8000802018b4`, `0xffff8000808631b0` | 28 lines      | Namespace capability & LSM security checks           |
| `arch/arm64/kernel/syscall.c`                      | `el0_svc_common`, `do_el0_svc`, `invoke_syscall`                         | `0xffff800080030b10`                       | 9 lines       | ARM64 syscall entry & dispatch                       |
| `net/ipv4/udp.c`                                   | `udp_init_sock`                                                          | `0xffff800082bbf408`                       | 3 lines       | UDP protocol socket initialization                   |
| _Other VFS, headers & libraries_                   | Namespace, cgroup, per-CPU counters, atomic bitops, refcounts            | —                                          | 106 lines     | Inline helpers, utility routines, KCOV_DISABLE ioctl |
| **Total Syscall Window**                           | _318 normalized source lines; 278 captured / 259 distinct PCs_           | —                                          | **318 lines** | **In-kernel socket() monolithic reachability**       |

## Appendix 1. References

- [Kernel Minimization Guide (Draft PR)](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html)
  (`Documentation/admin-guide/kernel-minimization.rst`) — base build, iterate, evaluate, and measurement method.
- [Workload Tracing Guide (Draft PR)](https://matthew-l-weber.github.io/linux/admin-guide/workload-tracing.html)
  (`Documentation/admin-guide/workload-tracing.rst`) — syscall and kernel-path discovery, including minimal user space.
- [Software Minimization](../SoftwareMinimization.md) — aerospace framing,
  assurance boundaries, and the experiment discipline.
- [Maximizing Kernel Coverage](./MaxCoverageMultiSuite.md) — whole-kernel structural coverage and test suite profiling.
- [Kernel Config Analysis](./KernelConfigAnalysis.md) — historical reference configuration comparison.
- [Kernel Testing Guide](https://www.kernel.org/doc/html/latest/dev-tools/testing-overview.html)
  (`Documentation/dev-tools/testing-overview.rst`) — comparison of unit tests, functional suites, dynamic sanitizers, and coverage tools.
- [Linux Kernel GCOV Support](https://www.kernel.org/doc/html/latest/dev-tools/gcov.html)
  (`Documentation/dev-tools/gcov.rst`) — GCC/Clang basic-block kernel profiling and debugfs extraction.
- [Linux Kernel KCOV Support](https://www.kernel.org/doc/html/latest/dev-tools/kcov.html)
  (`Documentation/dev-tools/kcov.rst`) — task-scoped syscall tracing interface.
- [Kernel Self-Testing Framework (kselftest)](https://www.kernel.org/doc/html/latest/dev-tools/kselftest.html)
  (`Documentation/dev-tools/kselftest.rst`) & [KUnit](https://www.kernel.org/doc/html/latest/dev-tools/kunit/index.html) — in-kernel unit testing.

## Appendix 2. Non-Intrusive Syscall Tracing via QEMU GDB Stub

For minimal PID 1 environments lacking in-guest debugging tools (like `strace` or `trace-cmd`), you can discover system calls non-intrusively from the host using QEMU's GDB stub as documented in the upstream [Workload Tracing Guide (Draft PR)](https://matthew-l-weber.github.io/linux/admin-guide/workload-tracing.html#tracing-a-minimal-user-space) (`Documentation/admin-guide/workload-tracing.rst`).

### Containerized GDB Stub Execution

A dedicated Dockerfile ([Dockerfile.gdb-stub-tracing](./hello-init/Dockerfile.gdb-stub-tracing)) boots `ainit` under QEMU with `-S -gdb tcp:127.0.0.1:1234` and connects `gdb-multiarch` to trap syscall entries at `do_el0_svc`:

```sh
# Build and execute the GDB stub syscall capture
docker build -f docs/minimal-linux/hello-init/Dockerfile.gdb-stub-tracing -t helloinit-gdb .

# Display captured syscall entries
docker run --rm helloinit-gdb
```

### Expected Output (`pid1-syscalls.log`, annotated)

Comments are added here for explanation; the log contains only the `syscall=` lines. Heap and stack addresses change from boot to boot.

```text
Breakpoint 2 at 0xffff80008001b710: file arch/arm64/kernel/syscall.c, line 140.
syscall=214 arg0=0                  # brk (query the program break)
syscall=214 arg0=0xadeae8           # brk (static glibc: early TLS allocation)
syscall=96  arg0=0xade0d0           # set_tid_address
syscall=99  arg0=0xade0e0           # set_robust_list
syscall=293 arg0=0xade720           # rseq (restartable sequences)
syscall=261 arg0=0                  # prlimit64 (read RLIMIT_STACK)
syscall=78  arg0=0xffffffffffffff9c # readlinkat(AT_FDCWD, "/proc/self/exe", ...)
syscall=278 arg0=0x496690           # getrandom (malloc tcache key)
syscall=214 arg0=0                  # brk (malloc: query the break)
syscall=214 arg0=0xaffae8           # brk (malloc: grow the heap)
syscall=214 arg0=0xb00000           # brk (malloc: align the break)
syscall=226 arg0=0x48c000           # mprotect (RELRO: make relocated data read-only)
syscall=80  arg0=0x1                # fstat (stdout descriptor check)
syscall=29  arg0=0x1                # ioctl(1, TCGETS): isatty() check before line buffering
syscall=64  arg0=0x1                # write(1, "hello world\n", 12)
syscall=73  arg0=0                  # ppoll (glibc pause() on arm64; PID 1 idle loop)
```

The log ends with GDB's `Cannot execute this command while the target is running.` message. That is expected: the script stops while the guest is still running.

This non-intrusive trace discovers the exact system calls invoked by user space (e.g. `write`, `fstat`, `brk`) without modifying the guest rootfs or altering PID 1 timing. The image build fails if the trace does not contain the `write(1, ...)` entry.
