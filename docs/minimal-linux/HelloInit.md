<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

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
  - [3. Get the kernel sources](#3-get-the-kernel-sources)
  - [4. Change: Kernel options \& configuration](#4-change-kernel-options--configuration)
  - [5. Build \& Test: Workload execution \& probing](#5-build--test-workload-execution--probing)
    - [5.1 PID 1 Static Workload Boot](#51-pid-1-static-workload-boot)
    - [5.2 Example Feature Probing (`ainit-net.c`)](#52-example-feature-probing-ainit-netc)
    - [5.3 Combined Feature Probing \& Coverage Collector (`ainit-net-kcov.c`)](#53-combined-feature-probing--coverage-collector-ainit-net-kcovc)
  - [6. Measure \& Record: Gather findings](#6-measure--record-gather-findings)
    - [6.1 Metrics](#61-metrics)
    - [6.2 Runtime Coverage Collection (KCOV)](#62-runtime-coverage-collection-kcov)
      - [6.2.1 Calculating Kernel Coverage Percentage](#621-calculating-kernel-coverage-percentage)
  - [7. Measure \& Record: Observation tables](#7-measure--record-observation-tables)
    - [Measurement Denominators \& SLOC Accounting](#measurement-denominators--sloc-accounting)
    - [7.1 Experiment Artifacts \& Provenance Anchor](#71-experiment-artifacts--provenance-anchor)
    - [7.2 Build \& Sizing Iteration Record (v7.3-rc5, arm64)](#72-build--sizing-iteration-record-v73-rc5-arm64)
    - [7.3 User Space Footprint (Static vs Deployed)](#73-user-space-footprint-static-vs-deployed)
    - [7.4 Runtime Coverage (KCOV) Symbolized Reachability](#74-runtime-coverage-kcov-symbolized-reachability)
      - [7.4.0 Scenario 0: Minimal PID 1 (`Step 0: tinyconfig baseline` + `ainit-kcov`)](#740-scenario-0-minimal-pid-1-step-0-tinyconfig-baseline--ainit-kcov)
      - [7.4.1 Scenario 1: Network Feature Probe (`Step 1: + Networking` + `ainit-net-kcov`)](#741-scenario-1-network-feature-probe-step-1--networking--ainit-net-kcov)
      - [7.4.2 Scenario 2: Monolithic Baseline Network Feature Probe (`Step 2: defconfig (monolithic)` + `ainit-net-kcov`)](#742-scenario-2-monolithic-baseline-network-feature-probe-step-2-defconfig-monolithic--ainit-net-kcov)
  - [Appendix 1. References](#appendix-1-references)

## 1. Prerequisites

Before running this walkthrough:

- **Upstream foundational guides:** Read the upstream
  [kernel-minimization draft](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html)
  and [workload-tracing draft](https://matthew-l-weber.github.io/linux/admin-guide/workload-tracing.html)
  for core principles, configuration theory, and discovery mechanisms.
- **Aerospace context:** Review [Software Minimization](../SoftwareMinimization.md)
  for safety-critical framing and assurance boundaries.

## 2. Environment

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

> **Environment & Emulation Notes:**
> - **Toolchain variables:** Verify `export ARCH=arm64` and `export CROSS_COMPILE=aarch64-linux-gnu-` are set before invoking `make` or `./scripts/config`.
> - **QEMU exit command:** Press `Ctrl-a` then `x` to exit a running QEMU console.
> - **QEMU memory sizing:** While `tinyconfig` boots with default RAM (~128 MB), monolithic `defconfig` and all whole-kernel GCOV profiled images **require `-m 512M` or `-m 1024M`** to prevent early boot out-of-memory panics.
> - **Clean tree discipline:** Run `make clean` or `make mrproper` when switching between baseline, KCOV, and GCOV configurations so stale object files do not distort SLOC or image size measurements.

## 3. Get the kernel sources

Shallow clone the target longterm/LTS branch (or release tag noted in the [Experiment Artifacts & Provenance Anchor](#71-experiment-artifacts--provenance-anchor) below) from kernel.org:

```sh
# Shallow clone the target kernel release (e.g. v7.3-rc5)
git clone --depth 1 --branch v7.3-rc5 \
    https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git \
    linux
cd linux
```

## 4. Change: Kernel options & configuration

The practice workload uses the simplest possible launch model: the kernel
launches a static binary directly as PID 1 from an initramfs, with no service
manager, no shell, and no background daemons.

Approach:

- **Top-down baseline:** Start from `defconfig`, disable loadable module support
  (`CONFIG_MODULES=n`), and build a monolithic kernel:
  ```sh
  make defconfig
  ./scripts/config -d MODULES
  make olddefconfig
  make clean && make -j"$(nproc)" Image
  ```
- **Bottom-up minimal kernel:** Start from `tinyconfig` and enable only the
  options required for the QEMU `virt` platform, serial console, initramfs,
  and ELF execution:
  ```sh
  make tinyconfig
  ./scripts/config \
      -e PRINTK -e TTY -e SERIAL_AMBA_PL011 -e SERIAL_AMBA_PL011_CONSOLE \
      -e BINFMT_ELF -e BLK_DEV_INITRD -d MODULES
  make olddefconfig
  make clean && make -j"$(nproc)" Image
  ```
- **Iterate toward minimal:** Change one subsystem group at a time using
  `./scripts/config`, run `make olddefconfig`, clean, and rebuild. Inspect
  changes against the saved configuration using `scripts/diffconfig`.

## 5. Build & Test: Workload execution & probing

For this worked example, we assume the **bottom-up (`tinyconfig`)** approach is
being followed to demonstrate incremental subsystem addition and evaluation. Test
and evaluate the resulting builds using QEMU emulation and feature probing:

### 5.1 PID 1 Static Workload Boot

Save the minimal PID 1 application source (from the kernel guide's [A minimal PID 1 workload](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html#a-minimal-pid-1-workload)) as `ainit.c`. Compile it statically and pack it into a gzip-compressed cpio archive:

```sh
aarch64-linux-gnu-gcc -static -O2 -o ainit ainit.c
mkdir -p rootfs && cp ainit rootfs/init && chmod 0755 rootfs/init
( cd rootfs && find . | cpio -o -H newc ) | gzip > initramfs.cpio.gz
```

Boot the kernel under QEMU:

```sh
qemu-system-aarch64 -machine virt -cpu cortex-a57 -nographic \
    -kernel arch/arm64/boot/Image \
    -initrd initramfs.cpio.gz \
    -append 'console=ttyAMA0'
```

_(Note: Monolithic `defconfig` images require passing `-m 512M` or `-m 1024M` to QEMU to avoid memory exhaustion during large driver initialization)._

Example console boot output:

```text
Booting Linux on physical CPU 0x0000000000 [0x411fd070]
Linux version 7.3.0-rc5+ (...) (aarch64-linux-gnu-gcc ...) #1 SMP PREEMPT ...
Machine model: linux,dummy-virt
...
Serial: AMBA PL011 UART driver
9000000.pl011: ttyAMA0 MMIO:0x0000000009000000 (irq = 13, base_baud = 0) is a PL011 rev1
printk: console [ttyAMA0] enabled
clocksource: Switched to clocksource arch_sys_counter
Unpacking initramfs...
Freeing initrd memory: 272K
clk: Disabling unused clocks
Freeing unused kernel memory: 384K
Run /init as init process
hello world
```

_Pass criterion:_ The kernel unpacks the initramfs, executes `/init` as PID 1,
prints `hello world`, and idles in `pause()` without triggering an
`Attempted to kill init!` panic. Close QEMU with `Ctrl-a x`.

### 5.2 Example Feature Probing (`ainit-net.c`)

This shows how you could toggle a Kernel feature and have userspace code handle it being enabled/disabled.

Save the socket probe variant (from the kernel guide's [Probing a kernel feature](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html#probing-a-kernel-feature))
as `ainit-net.c`. Compile, stage into the rootfs, and repack:

```sh
aarch64-linux-gnu-gcc -static -O2 -o ainit-net ainit-net.c
cp ainit-net rootfs/init && chmod 0755 rootfs/init
( cd rootfs && find . | cpio -o -H newc ) | gzip > initramfs-net.cpio.gz
```

Boot the kernel in QEMU passing `-initrd initramfs-net.cpio.gz`.

Example output across configurations:

```text
# On baseline tinyconfig (without networking):
hello world
NET-PROBE: failed: errno=38 (Function not implemented)

# On tinyconfig + NET + INET (or monolithic defconfig):
hello world
NET-PROBE: IPv4/UDP socket available
```

### 5.3 Combined Feature Probing & Coverage Collector (`ainit-net-kcov.c`)

Combining feature probing with KCOV tracing captures in-kernel execution reachability
for enabled features by bounding target calls (e.g. `socket(AF_INET, SOCK_DGRAM, 0)`)
between `KCOV_ENABLE` and `KCOV_DISABLE`. Save this source as `ainit-net-kcov.c`:

```c
/* ainit-net-kcov.c */
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/mount.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>

#define KCOV_INIT_TRACE _IOR('c', 1, unsigned long)
#define KCOV_ENABLE     _IO('c', 100)
#define KCOV_DISABLE    _IO('c', 101)
#define KCOV_TRACE_PC   0
#define COVER_SIZE      (64 * 1024)

int main(void)
{
    printf("hello world\n");
    if (mount("debugfs", "/sys/kernel/debug", "debugfs", 0, NULL) != 0) {
        perror("mount debugfs");
        return 1;
    }
    int fd = open("/sys/kernel/debug/kcov", O_RDWR);
    if (fd < 0) {
        perror("open /sys/kernel/debug/kcov");
        return 1;
    }
    if (ioctl(fd, KCOV_INIT_TRACE, COVER_SIZE) != 0) {
        perror("ioctl KCOV_INIT_TRACE");
        close(fd);
        return 1;
    }
    unsigned long *cover = (unsigned long *)mmap(NULL,
        COVER_SIZE * sizeof(unsigned long),
        PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    if (cover == MAP_FAILED) {
        perror("mmap");
        close(fd);
        return 1;
    }
    if (ioctl(fd, KCOV_ENABLE, KCOV_TRACE_PC) != 0) {
        perror("ioctl KCOV_ENABLE");
        munmap(cover, COVER_SIZE * sizeof(unsigned long));
        close(fd);
        return 1;
    }

    __atomic_store_n(&cover[0], 0, __ATOMIC_RELAXED);

    /* Target syscall: socket probe */
    int s = socket(AF_INET, SOCK_DGRAM, 0);

    if (ioctl(fd, KCOV_DISABLE, 0) != 0) {
        perror("ioctl KCOV_DISABLE");
    }

    if (s >= 0) {
        printf("NET-PROBE: IPv4/UDP socket available\n");
        close(s);
    } else {
        printf("NET-PROBE: failed: errno=%d (%s)\n", errno, strerror(errno));
    }

    unsigned long n = __atomic_load_n(&cover[0], __ATOMIC_RELAXED);
    printf("KCOV captured %lu PCs:\n", n);
    for (unsigned long i = 0; i < n; i++) {
        printf("0x%lx\n", cover[i + 1]);
    }

    munmap(cover, COVER_SIZE * sizeof(unsigned long));
    close(fd);

    for (;;)
        pause();
    return 0;
}
```

Compile and package for QEMU:

```sh
aarch64-linux-gnu-gcc -static -O2 -o ainit-net-kcov ainit-net-kcov.c
mkdir -p rootfs-net-kcov/sys/kernel/debug
cp ainit-net-kcov rootfs-net-kcov/init && chmod 0755 rootfs-net-kcov/init
( cd rootfs-net-kcov && find . | cpio -o -H newc ) | gzip > initramfs-net-kcov.cpio.gz
```

## 6. Measure & Record: Gather findings

### 6.1 Metrics

Follow the upstream guides for measuring kernel image sizes, source lines of
code (SLOC), and user space footprints:

- **SLOC Counting:** Follow the kernel guide's [Counting kernel SLOC](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html#counting-kernel-sloc)
  to generate DWARF line-table counts and compiled source counts. The `dwarf`
  count requires a `vmlinux` built with debug info; enable it and rebuild before
  counting (this matches the debug-info policy used for the DWARF SLOC column in
  [Section 7.2](#72-build--sizing-iteration-record-v73-rc5-arm64)):

  ```sh
  # One-time: enable DWARF debug info, then rebuild before counting
  ./scripts/config -d DEBUG_INFO_NONE \
      -e DEBUG_KERNEL -e DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT \
      -d DEBUG_INFO_BTF -d DEBUG_INFO_SPLIT
  make olddefconfig && make clean && make -j"$(nproc)" Image

  # DWARF-based line estimate from linked vmlinux
  CROSS_COMPILE=aarch64-linux-gnu- scripts/kernel-sloc --report linked.json dwarf vmlinux > sloc-dwarf.txt

  # Whole-file compiled source SLOC via compilation database
  python3 scripts/clang-tools/gen_compile_commands.py
  scripts/kernel-sloc --report compiled.json kernel . > sloc-compiled.txt
  ```

- **Image Sizing:** Follow [Measuring the image](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html#measuring-the-image)
  to record raw and compressed kernel sizes:

  ```sh
  make Image.gz
  stat -c%s arch/arm64/boot/Image       # raw image byte size
  stat -c%s arch/arm64/boot/Image.gz    # compressed image byte size
  ```

- **User Space Footprints:** Follow [Measuring user space](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html#measuring-user-space)
  to record application source lines, static binary sizes, and root filesystem archive sizes:

  ```sh
  # Application source SLOC
  cloc ainit.c

  # Static binary size (unstripped and stripped)
  stat -c%s ainit
  aarch64-linux-gnu-strip -o ainit-stripped ainit && stat -c%s ainit-stripped

  # Archive size
  stat -c%s initramfs.cpio.gz
  ```

### 6.2 Runtime Coverage Collection (KCOV)

KCOV provides task-scoped runtime kernel call coverage specifically for the target
system call bounded by the collection window (`read(-1, NULL, 0)` between `KCOV_ENABLE`
and `KCOV_DISABLE`). It strictly measures in-kernel reachability (application user space
coverage is evaluated separately).

Follow the upstream kernel guide for the collection and symbolization workflow:

1. **Enable KCOV & debug info:** Configure `CONFIG_KCOV=y`, `CONFIG_DEBUG_FS=y`, and
   DWARF debug info following [Dumping kernel coverage (kcov)](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html#dumping-kernel-coverage-kcov):

   ```sh
   ./scripts/config -e KCOV -e DEBUG_FS \
       -d DEBUG_INFO_NONE \
       -e DEBUG_KERNEL -e DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT \
       -d DEBUG_INFO_BTF -d DEBUG_INFO_SPLIT
   make olddefconfig && make clean && make -j"$(nproc)" Image
   ```

2. **Build collector & capture trace:** Save the PID 1 collector source `ainit-kcov.c`
   (from [Dumping kernel coverage (kcov)](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html#dumping-kernel-coverage-kcov)),
   package the rootfs with debugfs mount point, and boot in QEMU passing `nokaslr`:

   ```sh
   aarch64-linux-gnu-gcc -static -O2 -o ainit-kcov ainit-kcov.c
   mkdir -p rootfs-kcov/sys/kernel/debug
   cp ainit-kcov rootfs-kcov/init && chmod 0755 rootfs-kcov/init
   ( cd rootfs-kcov && find . | cpio -o -H newc ) | gzip > initramfs-kcov.cpio.gz

   qemu-system-aarch64 -machine virt -cpu cortex-a57 -nographic \
       -kernel arch/arm64/boot/Image -initrd initramfs-kcov.cpio.gz \
       -append 'console=ttyAMA0 nokaslr' 2>&1 | tee kcov.log
   ```

3. **Symbolize PCs:** Extract program counter addresses and resolve them to source
   locations following upstream [Symbolizing PCs](https://matthew-l-weber.github.io/linux/dev-tools/kcov.html#symbolizing-pcs):
   ```sh
   awk '{gsub(/\r/,""); if (NF == 1 && $1 ~ /^0x[0-9a-fA-F]+$/) print $1}' kcov.log > kcov-pcs.txt
   aarch64-linux-gnu-addr2line -f -i -e vmlinux < kcov-pcs.txt > kcov-symbols.txt
   ```

Example symbolized output (`kcov-symbols.txt` sample):

```text
get_current
.../arch/arm64/include/asm/current.h:19
el0_svc_common
.../arch/arm64/kernel/syscall.c:65
do_el0_svc
.../arch/arm64/kernel/syscall.c:140
invoke_syscall
.../arch/arm64/kernel/syscall.c:48
__do_sys_read
.../fs/read_write.c:725
__se_sys_read
.../fs/read_write.c:723
__arm64_sys_read
.../fs/read_write.c:723
```

#### 6.2.1 Calculating Kernel Coverage Percentage

Follow the kernel guide's [Dumping kernel coverage (kcov)](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html#dumping-kernel-coverage-kcov)
to calculate the proportion of the linked kernel codebase exercised by the target call:

1. Extract unique `file:line` locations from `kcov-symbols.txt`:
   ```sh
   grep ':[0-9]' kcov-symbols.txt | sort -u > kcov-lines.txt
   wc -l kcov-lines.txt
   ```
2. Compare the count of unique executed kernel source lines against the total linked DWARF SLOC (`sloc-dwarf.txt`) to calculate the single-syscall path reachability ratio:
   $$\text{Kernel Call Coverage (\%)} = \left(\frac{\text{Unique KCOV Executed Lines}}{\text{Total DWARF Linked SLOC}}\right) \times 100\%$$

> **Note on KCOV vs Whole-Kernel Coverage:** KCOV is task-scoped to the calling thread and measures only the lines executed during that specific system call window (e.g., 29 unique lines in `read()`). This percentage represents single-call reachability against the total binary, not whole-kernel structural code coverage (which is measured via GCOV across all processes, interrupts, and boot paths in [the Maximizing Kernel Coverage example](./MaxCoverageMultiSuite.md)).

## 7. Measure & Record: Observation tables

### Measurement Denominators & SLOC Accounting

To ensure consistent comparison across tables, this guide distinguishes five distinct metrics:

- **Base Linked DWARF SLOC (Uninstrumented):** Total unique source lines linked into `vmlinux` for the target configuration (`124,938` lines for `Step 0: tinyconfig baseline`, `197,490` for `Step 1: + Networking`, `1,959,778` for `Step 2: defconfig`).
- **KCOV-Instrumented Linked DWARF SLOC:** Total linked lines with KCOV compiler trace callbacks (`133,136` lines for `tinyconfig + KCOV`).
- **GCOV `.gcno` basic-block count:** Total basic-block executable lines registered in the GCC `.gcno` graphs across compiled units (~`143,167` for an unpruned `tinyconfig + GCOV` build). This is a *graph* metric and is **not** what `gcov` prints as "Lines executed … of N".
- **GCOV `.gcov` executable source lines (the multi-suite coverage denominator):** Every source line `gcov` classifies as executed-or-`#####` across all `.gcda`-backed units, deduplicated by `(source, line)` and **including inlined header lines**: measured `201,125` for this `tinyconfig + GCOV` build. This is the denominator used in the [Maximizing Kernel Coverage example](./MaxCoverageMultiSuite.md#6-measured-multi-stage-progression--differential-table-tinyconfig) coverage table. Always state which of the two GCOV metrics a percentage uses — they are not interchangeable.
- **Historical Reference Notes (LTS v6.18):** Earlier reference configurations documented in [Kernel Config Analysis](KernelConfigAnalysis.md) used older toolchain defaults and Kconfig sets (e.g., `171,739` DWARF SLOC for 6.18 tinyconfig baseline).

Log the findings across iterations in the following observation tables. In some cases the information is current state and others a trending log of test observations.

### 7.1 Experiment Artifacts & Provenance Anchor

Anchoring the baseline experiment parameters ensures reviewable and reproducible metrics:

| Parameter                | Recorded Value / Anchor                                                                                                                     |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------- |
| **Repository Source**    | `https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git`                                                                   |
| **Release Tag / Commit** | `v7.3-rc5`\* / tree HEAD commit `398a7781b2dd`                                                                                               |
| **Target Architecture**  | `arm64` (`ARCH=arm64`, `CROSS_COMPILE=aarch64-linux-gnu-`)                                                                                  |
| **Compiler & Linker**    | GCC `13.3.0` (`aarch64-linux-gnu-gcc`), GNU ld `2.42` _(ELISA AeroWG Devcontainer, branch `pr-257` / `demos/env/Dockerfile`)_               |
| **Emulator Environment** | QEMU `qemu-system-aarch64` v8.2.2 (`-machine virt -cpu cortex-a57`) _(ELISA AeroWG Devcontainer, branch `pr-257` / `demos/env/Dockerfile`)_ |

\* _Note on release tag: the `v7.3-rc5` tag commit is `72d3fcf802c4` ("Linux
7.3-rc5"); the worked example in this workspace builds from tree HEAD
`398a7781b2dd`, which adds the minimization documentation on top of that tag.
When replicating from upstream kernel.org, substitute your target release tag or
longterm branch (e.g., `linux-6.18.y`)._

### 7.2 Build & Sizing Iteration Record (v7.3-rc5, arm64)

| Configuration Step          | Adjustment / Kconfig Delta                       | DWARF SLOC | Compiled Source SLOC    | Raw Image                 | Compressed Image (`.gz`) | Boot Status |
| --------------------------- | ------------------------------------------------ | ---------- | ----------------------- | ------------------------- | ------------------------ | ----------- |
| `0. tinyconfig baseline`    | `tinyconfig` + PL011 serial, printk, initrd, elf | 124,938    | 352,672 (600 files)     | 3,223,560 B (~3.07 MB)    | 1,140,060 B (~1.09 MB)   | Pass        |
| `1. + Networking`           | `+NET`, `+INET`                                  | 197,490    | 527,040 (784 files)     | 4,495,368 B (~4.3 MB)     | 1,810,185 B (~1.7 MB)    | Pass        |
| `2. defconfig (monolithic)` | `defconfig`, `-MODULES`                          | 1,959,778  | 5,721,697 (9,157 files) | 101,362,176 B (~96.67 MB) | 31,000,849 B (~29.56 MB) | Pass        |

### 7.3 User Space Footprint (Static vs Deployed)

| User Space Component            | Purpose / Description                  | Source SLOC | Static ELF (unstripped) | Stripped Binary     | `initramfs-*.cpio.gz` Archive |
| ------------------------------- | -------------------------------------- | ----------- | ----------------------- | ------------------- | ----------------------------- |
| `ainit` (glibc static)          | Minimal PID 1 hello world              | 10 lines    | 634,000 B (~619 KB)     | 532,408 B (~520 KB) | 279,570 B (~273 KB)           |
| `ainit-net` (glibc static)      | Socket feature probe                   | 23 lines    | 634,984 B (~620 KB)     | 532,408 B (~520 KB) | 280,384 B (~274 KB)           |
| `ainit-kcov` (glibc static)     | KCOV syscall coverage collector        | 68 lines    | 704,296 B (~688 KB)     | 597,944 B (~584 KB) | 294,778 B (~288 KB)           |
| `ainit-net-kcov` (glibc static) | Combined socket probe + KCOV collector | 69 lines    | 704,592 B (~688 KB)     | 597,944 B (~584 KB) | 295,329 B (~288 KB)           |

### 7.4 Runtime Coverage (KCOV) Symbolized Reachability

Symbolized reachability evaluating specific test scenarios by pairing a kernel configuration step (from [Section 7.2](#72-build--sizing-iteration-record-v73-rc5-arm64)) with a target workload application (from [Section 7.3](#73-user-space-footprint-static-vs-deployed)):

> **Note on the combined collector:** Scenarios 7.4.1 and 7.4.2 use
> `ainit-net-kcov.c`, whose full source is provided in
> [Section 5.3](#53-combined-feature-probing--coverage-collector-ainit-net-kcovc).
> Because that collector reads the KCOV buffer after `KCOV_DISABLE`, the captured
> window also includes the `KCOV_DISABLE` `ioctl` path (e.g. `fs/ioctl.c`), so the
> exact PC/line totals are slightly higher than a `socket()`-only window would
> yield. The `read()` baseline in Scenario 7.4.0 below uses the upstream
> `ainit-kcov.c` collector.

#### 7.4.0 Scenario 0: Minimal PID 1 (`Step 0: tinyconfig baseline` + `ainit-kcov`)

Target syscall `read(-1, NULL, 0)` on the instrumented `tinyconfig baseline` (133,136 instrumented linked DWARF SLOC / 124,938 uninstrumented base):

| Kernel Source File              | Activated Functions                                             | Sample Instruction Addresses               | Unique Lines | Kernel Coverage Share (%) | Observation Scope                              |
| ------------------------------- | --------------------------------------------------------------- | ------------------------------------------ | ------------ | ------------------------- | ---------------------------------------------- |
| `arch/arm64/kernel/syscall.c`   | `get_current`, `el0_svc_common`, `do_el0_svc`, `invoke_syscall` | `0xffff80008001e81c`, `0xffff80008001e85c` | 4 lines      | ~0.0030%                  | Syscall dispatch entry & return paths          |
| `fs/read_write.c` & `fs/file.c` | `__do_sys_read`, `ksys_read`, `__fget_light`, `fdget_pos`       | `0xffff8000801245e4`, `0xffff800080123b48` | 5 lines      | ~0.0038%                  | Target syscall handler & descriptor lookup     |
| _Supporting headers_            | `current.h`, `file.h`, `syscall.h`                              | —                                          | 20 lines     | ~0.0150%                  | Inlined current task & file descriptor helpers |
| **Total Syscall Window**        | _29 unique source lines across 21 PCs_                          | —                                          | **29 lines** | **~0.0218%**              | **In-kernel read() baseline reachability**     |

#### 7.4.1 Scenario 1: Network Feature Probe (`Step 1: + Networking` + `ainit-net-kcov`)

Target feature probe `socket(AF_INET, SOCK_DGRAM, 0)` on the instrumented `tinyconfig + NET + INET` build (197,490 total linked DWARF SLOC):

| Kernel Source File / Subsystem   | Activated Functions                                                      | Sample Instruction Addresses               | Unique Lines  | Kernel Coverage Share (%) | Observation Scope                               |
| -------------------------------- | ------------------------------------------------------------------------ | ------------------------------------------ | ------------- | ------------------------- | ----------------------------------------------- |
| `net/socket.c`                   | `__sys_socket_create`, `sock_alloc_file`, `__sock_create`, `sock_map_fd` | `0xffff8000802296d0`, `0xffff800080228160` | 34 lines      | ~0.0172%                  | Socket abstraction & syscall entry              |
| `net/ipv4/af_inet.c`             | `inet_create`                                                            | `0xffff80008031332c`, `0xffff800080312900` | 25 lines      | ~0.0127%                  | IPv4 protocol family socket creation            |
| `net/core/sock.c`                | `sk_alloc`, `sock_init_data`, `sk_prot_alloc`                            | `0xffff80008022dc84`, `0xffff80008022c698` | 25 lines      | ~0.0127%                  | Core socket allocation and state initialization |
| `fs/file_table.c` & `fs/file.c`  | `alloc_file_pseudo`, `alloc_file`, `fd_install`, `get_unused_fd_flags`   | `0xffff800080128c24`, `0xffff800080126574` | 50 lines      | ~0.0253%                  | VFS file allocation & descriptor binding        |
| `fs/dcache.c` & `fs/inode.c`     | `d_alloc_pseudo`, `new_inode_pseudo`                                     | `0xffff80008011f158`, `0xffff80008012bc68` | 37 lines      | ~0.0187%                  | Socket pseudo filesystem dentry/inode creation  |
| `arch/arm64/kernel/syscall.c`    | `el0_svc_common`, `do_el0_svc`, `invoke_syscall`                         | `0xffff80008001e81c`, `0xffff80008001e85c` | 12 lines      | ~0.0061%                  | ARM64 syscall entry, dispatch & return paths    |
| `net/ipv4/udp.c`                 | `udp_init_sock`                                                          | `0xffff8000803135dc`, `0xffff800080313620` | 5 lines       | ~0.0025%                  | UDP protocol socket initialization              |
| _Supporting headers & libraries_ | Per-CPU counters, atomic bitops, timer init                              | —                                          | 100 lines     | ~0.0506%                  | Inline helpers & reference counting             |
| **Total Syscall Window**         | _307 unique source lines across 268 PCs_                                 | —                                          | **307 lines** | **~0.1555%**              | **In-kernel socket() reachability (incl. `KCOV_DISABLE` ioctl window)** |

#### 7.4.2 Scenario 2: Monolithic Baseline Network Feature Probe (`Step 2: defconfig (monolithic)` + `ainit-net-kcov`)

Target feature probe `socket(AF_INET, SOCK_DGRAM, 0)` on the monolithic `defconfig` build (1,959,778 linked DWARF SLOC):

| Kernel Source File / Subsystem                     | Activated Functions                                                      | Sample Instruction Addresses               | Unique Lines  | Kernel Coverage Share (%) | Observation Scope                              |
| -------------------------------------------------- | ------------------------------------------------------------------------ | ------------------------------------------ | ------------- | ------------------------- | ---------------------------------------------- |
| `net/socket.c`                                     | `__sys_socket_create`, `sock_alloc_file`, `__sock_create`, `sock_map_fd` | `0xffff800082a0092c`, `0xffff8000829fd340` | 34 lines      | ~0.0017%                  | Socket layer syscall entry & allocation        |
| `fs/file_table.c`, `dcache.c`, `file.c`, `inode.c` | `alloc_file_pseudo`, `d_alloc_pseudo`, `fd_install`, `new_inode_pseudo`  | `0xffff80008047dbf4`, `0xffff80008047b5f8` | 97 lines      | ~0.0049%                  | VFS file, dentry & pseudo inode creation       |
| `net/core/sock.c` & `net/ipv4/af_inet.c`           | `sk_alloc`, `sock_init_data`, `inet_create`                              | `0xffff800082bd674c`, `0xffff800082a07f50` | 55 lines      | ~0.0028%                  | Core sock layer & IPv4 protocol init           |
| `kernel/user_namespace.c` & `security/security.c`  | `ns_capable_common`, `security_socket_create`, LSM hooks                 | `0xffff8000801f1950`, `0xffff8000801e5dd0` | 29 lines      | ~0.0015%                  | Namespace capability & LSM security checks     |
| `arch/arm64/kernel/syscall.c`                      | `el0_svc_common`, `do_el0_svc`, `invoke_syscall`                         | `0xffff800080030b10`, `0xffff8000800309e8` | 9 lines       | ~0.0005%                  | ARM64 syscall entry & dispatch                 |
| `net/ipv4/udp.c`                                   | `udp_init_sock`                                                          | `0xffff800082a080d0`, `0xffff800082a08070` | 6 lines       | ~0.0003%                  | UDP protocol state initialization              |
| _Supporting headers & libraries_                   | Per-CPU counters, atomic bitops, refcounts                               | —                                          | 114 lines     | ~0.0058%                  | Inline helpers & utility routines              |
| **Total Syscall Window**                           | _344 unique source lines across 255 PCs_                                 | —                                          | **344 lines** | **~0.0176%**              | **In-kernel socket() monolithic reachability** |

## Appendix 1. References

- [Kernel-minimization draft](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html)
  — base build, iterate, evaluate, and measurement method.
- [Workload-tracing draft](https://matthew-l-weber.github.io/linux/admin-guide/workload-tracing.html)
  — syscall and kernel-path discovery, including minimal user space.
- [Software Minimization](../SoftwareMinimization.md) — devcontainer setup,
  aerospace framing, and observations.
- [Kernel Testing Guide](https://www.kernel.org/doc/html/latest/dev-tools/testing-overview.html)
  (`Documentation/dev-tools/testing-overview.rst`) — comparison of unit tests, functional suites, dynamic sanitizers, and coverage tools.
- [Linux Kernel GCOV Support](https://www.kernel.org/doc/html/latest/dev-tools/gcov.html)
  (`Documentation/dev-tools/gcov.rst`) — GCC/Clang basic-block kernel profiling and debugfs extraction.
- [Linux Kernel KCOV Support](https://www.kernel.org/doc/html/latest/dev-tools/kcov.html)
  (`Documentation/dev-tools/kcov.rst`) — task-scoped syscall tracing interface.
- [Kernel Self-Testing Framework (kselftest)](https://www.kernel.org/doc/html/latest/dev-tools/kselftest.html)
  (`Documentation/dev-tools/kselftest.rst`) & [KUnit](https://www.kernel.org/doc/html/latest/dev-tools/kunit/index.html) — in-kernel unit testing.
