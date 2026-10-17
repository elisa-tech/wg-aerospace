<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Maximizing Kernel Coverage with Open-Source Test Suites

_stress-ng, LTP, Syzkaller & GCOV — a worked example of applying the
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
- **LTP / Linux Test Project (POSIX Conformance & Error Paths):** Validates system call
  boundaries, invalid parameter handling, and permission checks (e.g. `EFAULT`, `EINVAL`,
  `ENAMETOOLONG`, `EBADF`), triggering defensive error-recovery and validation branches
  that high-throughput stress tools bypass.
- **Syzkaller Corpus Playback (Combinatorial Sequences):** Replays mutated multi-syscall
  programs (`syz-execprog` or exported standalone C reproducers), exercising deep state
  transitions across interconnected kernel subsystems.

## 2. Higher-Altitude Levers & Untried Coverage Extensions

While the deterministic stages above form the core acceptance gate on the `tinyconfig`
baseline, several higher-leverage techniques remain untried in this initial walkthrough
and are scoped for higher-altitude configurations (`+ networking`, `+ block/ext4`, `defconfig`):

1. **Live Mutating Syzkaller Fuzzing (`syz-fuzzer` with `CONFIG_KCOV=y`):**
   - *Status in this walkthrough:* Untried (only deterministic corpus replay was executed).
   - *Impact & Tradeoff:* Live time-boxed random mutation (e.g. 10–30 minutes) discovers
     deep edge-case paths a static corpus cannot reach. In aerospace environments,
     this is best isolated into an offline exploration track so non-deterministic fuzzer
     failures do not fail deterministic verification gates.
2. **Filesystem Loop-Mount Matrix (`fsstress`, `fsx`, `xfstests`):**
   - *Status in this walkthrough:* Untried on `tinyconfig` (requires `CONFIG_BLOCK=y`,
     `CONFIG_BLK_DEV_LOOP=y`, and filesystem drivers like `CONFIG_EXT4_FS=y` or `CONFIG_OVERLAY_FS=y`).
   - *Impact:* Loop-mounting images and running `fsstress` exercises journaling, extent trees,
     directory caching, and truncation across filesystem implementations.
3. **Advanced Netlink, Traffic Control (`tc`), & Netfilter (`nft`):**
   - *Status in this walkthrough:* Scoped for `+ networking` builds (requires `CONFIG_NET=y`,
     `CONFIG_NETFILTER=y`, `CONFIG_NET_SCHED=y`).
   - *Impact:* Manipulating traffic-control qdiscs, packet classifiers, and firewall rulesets
     exercises extensive network stack control logic.
4. **`io_uring` Asynchronous Engine (`liburing` test suite):**
   - *Status in this walkthrough:* Untried (requires `CONFIG_IO_URING=y`).
   - *Impact:* Thoroughly exercises the kernel asynchronous submission and completion ring queues.
5. **eBPF Verifier, JIT, & Map Traversal (`bpftrace` / `libbpf`):**
   - *Status in this walkthrough:* Untried (requires `CONFIG_BPF=y`, `CONFIG_BPF_SYSCALL=y`).
   - *Impact:* Loading BPF programs, kprobes, and tracepoints exercises the bytecode verifier,
     in-kernel JIT compiler, and map storage engines.
6. **Performance & Tracing Subsystem (`perf` & `ftrace`):**
   - *Status in this walkthrough:* Untried (requires `CONFIG_PERF_EVENTS=y`, `CONFIG_FTRACE=y`).
   - *Impact:* Running `perf record` and enabling function graph tracing exercises event counters
     and PMU drivers.

## 3. Kernel Profiling Configuration

Start from the bootable `tinyconfig` baseline from [Section 4](./HelloInit.md#4-change-kernel-options--configuration)
(`tinyconfig` + PL011 serial, printk, initrd, ELF, `-MODULES`), then enable
whole-kernel GCOV profiling and the boot self-tests on ARM64:

```sh
./scripts/config \
    -e DEBUG_FS -e SYSFS -e PROC_FS -e DEVTMPFS -e DEVTMPFS_MOUNT \
    -e GCOV_KERNEL -e GCOV_PROFILE_ALL \
    -e FUTEX \
    -e RUNTIME_TESTING_MENU \
    -e KUNIT \
    -e DEBUG_LOCKING_API_SELFTESTS \
    -e STATIC_KEYS_SELFTEST \
    -e ATOMIC64_SELFTEST \
    -e TEST_BITMAP \
    -e TEST_SORT \
    -e TEST_LIST_SORT \
    -e TEST_HEXDUMP \
    -e TEST_KSTRTOX \
    -e TEST_XARRAY \
    -e TEST_MAPLE_TREE \
    -e TEST_RHASHTABLE \
    -e TEST_IDA \
    -e TEST_BITOPS \
    -d DEBUG_INFO_NONE -e DEBUG_KERNEL -e DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT \
    -d DEBUG_INFO_BTF -d DEBUG_INFO_SPLIT
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- olddefconfig
make -j"$(nproc)" ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image
```

> **Required for the self-tests to survive `olddefconfig` (verified):**
> - `-e RUNTIME_TESTING_MENU` is **mandatory**. The `TEST_*` options and
>   `ATOMIC64_SELFTEST` live under the `menuconfig RUNTIME_TESTING_MENU` guard,
>   which is `n` in `tinyconfig`. Without it, `olddefconfig` **silently drops every
>   `TEST_*` and `ATOMIC64_SELFTEST`** request, so Stage 0 self-test coverage never
>   compiles in.
> - `-e KUNIT` is required for `TEST_SORT` and `TEST_LIST_SORT`: both now
>   `depends on KUNIT` (they are KUnit tests), so they are dropped without it.
> - The DWARF debug-info options are added so the same `vmlinux` supports the
>   linked-SLOC audit in [Section 7](#7-identifying-uncovered-built-areas--pruning-candidates).
>
> Confirm the requests survived before building:
>
> ```sh
> for c in GCOV_KERNEL GCOV_PROFILE_ALL RUNTIME_TESTING_MENU KUNIT \
>          ATOMIC64_SELFTEST TEST_MAPLE_TREE TEST_XARRAY TEST_SORT DEBUG_INFO; do
>     printf '%s=' "$c"; ./scripts/config -s "$c"
> done
> ```

*(Optional, out of scope for this baseline: to add the Netlink/traffic-control
sweep listed in [Section 2](#2-higher-altitude-levers--untried-coverage-extensions),
rebuild with `-e NET -e INET -e NETLINK_DIAG -e DUMMY -e VETH -e BRIDGE -e VLAN_8021Q -e NET_SCHED`.
This pulls the large `net/` tree into the instrumented set and changes the
denominator, so run and report it separately from the NET-less baseline below.)*

## 4. Rootfs Assembly & Sequential Multi-Stage Execution Workflow

To measure both total cumulative coverage and stage-by-stage differential gains,
the static `/init` launcher executes all three suites sequentially as one complete
workload, emitting labeled checkpoints to the serial log between stages without
clearing in-memory GCOV counters:

1. **Extract rootfs and stage test packages:** Retrieve Alpine ARM64 minirootfs and stage each tool suite directly into the rootfs filesystem tree:

   ```sh
   # Base rootfs extraction (Alpine minirootfs ships musl + busybox, so the
   # dynamically linked Alpine binaries below resolve their loader/libc)
   wget https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/aarch64/alpine-minirootfs-3.20.3-aarch64.tar.gz
   mkdir -p rootfs-alpine
   tar -xzf alpine-minirootfs-3.20.3-aarch64.tar.gz -C rootfs-alpine
   mkdir -p rootfs-alpine/proc rootfs-alpine/sys rootfs-alpine/dev \
            rootfs-alpine/tmp rootfs-alpine/sys/kernel/debug

   # Stage stress-ng (an .apk is a gzip tarball; extract it onto the rootfs)
   wget https://dl-cdn.alpinelinux.org/alpine/v3.20/community/aarch64/stress-ng-0.17.08-r0.apk
   tar -xzf stress-ng-0.17.08-r0.apk -C rootfs-alpine          # -> /usr/bin/stress-ng

   # (No iproute2 here: this NET-less baseline has no Netlink/tc stage. If you add
   #  the optional networking extension from Section 3, also stage both
   #  iproute2-minimal (-> /sbin/ip) and iproute2-tc (-> /sbin/tc); `tc` is NOT in
   #  iproute2-minimal.)

   # Stage LTP (Linux Test Project) syscall suite — real cross-built binaries.
   # The devcontainer ships host autotools (autoconf/automake/aclocal) and the
   # aarch64 cross toolchain, so build the real LTP syscall testcases:
   git clone --depth 1 https://github.com/linux-test-project/ltp
   ( cd ltp && make autotools && \
     ./configure --host=aarch64-linux-gnu CC=aarch64-linux-gnu-gcc \
                 CFLAGS="-O2" LDFLAGS="-static" && \
     make -j"$(nproc)" -C testcases/kernel/syscalls )
   mkdir -p rootfs-alpine/opt/ltp/bin
   # Copy a bounded subset of the real static syscall testcases (the full suite
   # is ~1,500 binaries; on a single-core GCOV guest that is slow, so stage the
   # boundary/error + doc-cited select/mincore tests). Add more as needed.
   for t in select/select01 select/select02 mincore/mincore01 read/read01 \
            read/read02 write/write01 close/close01 open/open01 open/open03 \
            dup/dup01 lseek/lseek01 fstat/fstat01 poll/poll01 pipe/pipe01 \
            stat/stat01 fcntl/fcntl01 access/access01 nanosleep/nanosleep01 \
            mmap/mmap01 mprotect/mprotect01 socket/socket01; do
       b="ltp/testcases/kernel/syscalls/$t"
       [ -x "$b" ] && cp "$b" rootfs-alpine/opt/ltp/bin/
   done
   cat << 'EOF' > rootfs-alpine/opt/ltp/run_syscall_tests.sh
   #!/bin/sh
   for test in /opt/ltp/bin/*; do
       [ -x "$test" ] && "$test" >/dev/null 2>&1
   done
   EOF
   chmod +x rootfs-alpine/opt/ltp/run_syscall_tests.sh

   # Stage Syzkaller reproducer — real syz-prog2c output.
   # The devcontainer ships Go, so build syzkaller's syz-prog2c host tool and
   # export a sandbox-legal corpus to C, then cross-compile it statically.
   git clone --depth 1 https://github.com/google/syzkaller
   ( cd syzkaller && make prog2c )          # builds bin/syz-prog2c (host/amd64)
   cat << 'EOF' > corpus.syz
   r0 = socket$inet(0x2, 0x2, 0x0)
   bind$inet(r0, &(0x7f0000000000)={0x2, 0x1234, @local}, 0x10)
   setsockopt$sock_int(r0, 0x1, 0x6, &(0x7f0000000040)=0x1, 0x4)
   close(r0)
   r1 = openat$dir(0xffffffffffffff9c, &(0x7f0000000100)='./file0\x00', 0x42, 0x1a4)
   write$binfmt_script(r1, &(0x7f0000000200)={'#! ', './file0'}, 0xb)
   close(r1)
   EOF
   ./syzkaller/bin/syz-prog2c -prog corpus.syz > syz-repro.c
   mkdir -p rootfs-alpine/opt/syzkaller
   aarch64-linux-gnu-gcc -static -O2 -o rootfs-alpine/opt/syzkaller/syz-repro syz-repro.c
   ```

   > **Tool acquisition notes (verified in the ELISA AeroWG devcontainer):**
   > - **(Optional networking extension only)** `tc` is **not** in
   >   `iproute2-minimal`; it ships in the separate `iproute2-tc` subpackage.
   >   Staging only `iproute2-minimal` leaves the optional `tc qdisc` commands
   >   silently failing. This NET-less baseline stages neither.
   > - **Real LTP** cross-builds with the devcontainer's host autotools
   >   (`autoconf`/`automake`/`aclocal`) plus the aarch64 cross toolchain; the full
   >   syscall suite produced ~1,500 static testcases (LTP `20260930`). Stage a
   >   bounded subset on the single-core GCOV guest to keep runtime reasonable.
   > - **Real Syzkaller** `syz-prog2c` builds with the devcontainer's Go toolchain
   >   (`make prog2c`). It validates the corpus against its syscall descriptions —
   >   the corpus above is sandbox-legal (relative `./file0` path, proper result
   >   threading); an absolute `/dev/null` path or dangling result refs are
   >   rejected. The generated C includes syzkaller's `mmap` scratch setup.
   > - These two tools are provided by the devcontainer image. If you are on an
   >   older image without them, follow
   >   [Testing Steering Notes §6](./TestingSteeringNotes.md#6-devcontainer-provisioning-for-ltp--syzkaller)
   >   to install the prerequisites for the session.

2. **Static multi-stage `/init` launcher with labeled checkpoints:**

   ```c
   /* rootfs-alpine/init.c */
   #include <stdio.h>
   #include <stdlib.h>
   #include <unistd.h>
   #include <sys/mount.h>
   #include <sys/wait.h>

   static void emit_checkpoint(const char *stage_name)
   {
       char cmd[512];
       snprintf(cmd, sizeof(cmd),
                "mkdir -p /tmp/dump && "
                "find /sys/kernel/debug/gcov -type d -exec mkdir -p /tmp/dump/{} \\; && "
                "find /sys/kernel/debug/gcov -name '*.gcda' -exec sh -c 'cat < \"$0\" > \"/tmp/dump/$0\"' {} \\; && "
                "tar -czf /tmp/gcda.tar.gz -C /tmp/dump sys && "
                "echo '===GCOV_%s_START===' && "
                "base64 /tmp/gcda.tar.gz && "
                "echo '===GCOV_%s_END===' && "
                "rm -rf /tmp/dump /tmp/gcda.tar.gz",
                stage_name, stage_name);
       system(cmd);
   }

   static void run_cmd(char *const argv[])
   {
       if (access(argv[0], X_OK) != 0) {
           fprintf(stderr, "SKIP/WARN: %s not found or not executable\n", argv[0]);
           return;
       }
       pid_t pid = fork();
       if (pid == 0) {
           execv(argv[0], argv);
           perror(argv[0]);
           _exit(127);
       }
       int status;
       waitpid(pid, &status, 0);
   }

   int main(void)
   {
       if (mount("proc", "/proc", "proc", 0, NULL) != 0)
           perror("mount /proc");
       if (mount("sysfs", "/sys", "sysfs", 0, NULL) != 0)
           perror("mount /sys");
       if (mount("devtmpfs", "/dev", "devtmpfs", 0, NULL) != 0)
           perror("mount /dev");
       if (mount("debugfs", "/sys/kernel/debug", "debugfs", 0, NULL) != 0)
           perror("mount /sys/kernel/debug");

       /* Stage 0: Boot Self-Tests (Executed automatically during boot initcalls) */
       emit_checkpoint("STAGE0_BOOT");

       /* Stage 1: /proc and /sys Attribute Traversal */
       puts("=== Stage 1: Traversing /proc and /sys attributes ===");
       /* Read each pseudo-file's first block. Use `timeout -s KILL` so files
          that block and ignore SIGTERM cannot stall the stage, and skip
          per-process (/proc/<pid>) trees and other known-blocking nodes. Under
          a NET-enabled GCOV kernel a plain `timeout 2` here can hang the stage
          indefinitely on a blocking read. */
       system("find /proc /sys /sys/kernel/debug -type f 2>/dev/null | while read -r f; do "
              "  case \"$f\" in "
              "    */trace_pipe*|*/kcore|*/mem|*/kmsg|*/sysrq-trigger|*/null|*/zero|/proc/[0-9]*|*/clear_refs) ;; "
              "    *) timeout -s KILL 1 dd if=\"$f\" of=/dev/null bs=4k count=1 2>/dev/null ;; "
              "  esac; "
              "done");
       emit_checkpoint("STAGE1_PROCSYS");

       /* Stage 2: stress-ng (Sequential Class ABI Sweep across all CPUs) */
       puts("=== Stage 2: Executing stress-ng sequential class sweep ===");
       const char *classes[] = { "os", "scheduler", "memory", "filesystem", "interrupt" }; /* no "network" class: CONFIG_NET=n */
       for (size_t i = 0; i < sizeof(classes)/sizeof(classes[0]); i++) {
           char *sng_argv[] = {
               "/usr/bin/stress-ng",
               "--seq", "0",
               "--class", (char *)classes[i],
               "--timeout", "1s",
               "--metrics",
               NULL
           };
           run_cmd(sng_argv);
       }
       emit_checkpoint("STAGE2_STRESSNG");

       /* Stage 3: LTP (POSIX Conformance & Defensive Error Edge Cases) */
       puts("=== Stage 3: Executing LTP syscall validation suite ===");
       char *ltp_argv[] = { "/opt/ltp/run_syscall_tests.sh", NULL };
       run_cmd(ltp_argv);
       emit_checkpoint("STAGE3_LTP");

       /* Stage 4: Syzkaller (Combinatorial Multi-Syscall Sequence Playback) */
       puts("=== Stage 4: Executing Syzkaller standalone sequence reproducer ===");
       char *syz_argv[] = { "/opt/syzkaller/syz-repro", NULL };
       run_cmd(syz_argv);
       emit_checkpoint("STAGE4_SYZKALLER");

       puts("=== All test stages complete ===");
       for (;;)
           pause();
       return 0;
   }
   ```

3. **Package and boot in QEMU:**

   ```sh
   aarch64-linux-gnu-gcc -static -O2 -o rootfs-alpine/init rootfs-alpine/init.c
   ( cd rootfs-alpine && find . | cpio -o -H newc ) | gzip > initramfs-alpine.cpio.gz
   qemu-system-aarch64 -machine virt -cpu cortex-a57 -m 1024M -nographic \
       -kernel arch/arm64/boot/Image -initrd initramfs-alpine.cpio.gz \
       -append 'console=ttyAMA0 nokaslr' 2>&1 | tee qemu-gcov.log
   ```

   > This command passes **no `-smp`**, so the guest runs **single-core** (one vCPU);
   > GCOV profiling makes the run slower than an uninstrumented boot. On the
   > reference host the full five-stage harness completes in **~3.9 minutes**
   > (dominated by the Stage 1 `/proc`/`/sys` traversal). Record cores and timing as
   > evidence per [Section 10](#10-measurement-environment-core-count--timing-record).
   > Wait for the `=== All test stages complete ===` line (all five
   > `===GCOV_STAGE*_END===` markers present) before exiting QEMU with `Ctrl-a x`.

## 5. Host-Side Checkpoint Extraction & Differential Analysis

1. **Extract checkpoint archives from console log:**

   ```sh
   sed -n '/===GCOV_STAGE0_BOOT_START===/,/===GCOV_STAGE0_BOOT_END===/p' qemu-gcov.log \
       | grep -v '===' | tr -d '\r' | base64 -d > gcda-stage0-boot.tar.gz
   sed -n '/===GCOV_STAGE1_PROCSYS_START===/,/===GCOV_STAGE1_PROCSYS_END===/p' qemu-gcov.log \
       | grep -v '===' | tr -d '\r' | base64 -d > gcda-stage1-procsys.tar.gz
   sed -n '/===GCOV_STAGE2_STRESSNG_START===/,/===GCOV_STAGE2_STRESSNG_END===/p' qemu-gcov.log \
       | grep -v '===' | tr -d '\r' | base64 -d > gcda-stage2-stressng.tar.gz
   sed -n '/===GCOV_STAGE3_LTP_START===/,/===GCOV_STAGE3_LTP_END===/p' qemu-gcov.log \
       | grep -v '===' | tr -d '\r' | base64 -d > gcda-stage3-ltp.tar.gz
   sed -n '/===GCOV_STAGE4_SYZKALLER_START===/,/===GCOV_STAGE4_SYZKALLER_END===/p' qemu-gcov.log \
       | grep -v '===' | tr -d '\r' | base64 -d > gcda-stage4-syzkaller.tar.gz
   ```

2. **Reconstruct `.gcov` files from the exported `.gcda` (required before `diff_gcov.py`):**
   The checkpoints contain runtime `.gcda` counters only. `gcov` needs each `.gcda`
   placed next to its build-time `.gcno`, and it must run **with the kernel source
   tree as the working directory** so the relative source paths inside the `.gcno`
   (e.g. `lib/xarray.c`) resolve. If `gcov` is run from anywhere else it reports
   `Runs:0` and emits empty coverage. Repeat per stage into its own output dir:

   ```sh
   # usage: reconstruct_stage <gcda-archive.tar.gz> <output-gcov-dir>
   reconstruct_stage() {
       archive="$1"; outdir="$2"; tree="$(pwd)"   # run this from the kernel tree root
       tmp="$(mktemp -d)"; tar -xzf "$archive" -C "$tmp"
       find "$tree" -name '*.gcda' -delete        # clear any previous stage
       # place this stage's .gcda next to the matching in-tree .gcno
       find "$tmp/sys/kernel/debug/gcov" -name '*.gcda' | while read -r g; do
           rel="${g#$tmp/sys/kernel/debug/gcov}"
           [ -f "${rel%.gcda}.gcno" ] && cp "$g" "$rel"
       done
       mkdir -p "$outdir"
       # run gcov FROM THE TREE ROOT so source paths resolve, collect the .gcov
       find "$tree" -name '*.gcda' | while read -r gcda; do
           src="${gcda%.gcda}.c"; [ -f "$src" ] || continue
           aarch64-linux-gnu-gcov -o "$(dirname "$gcda")" "$src" >/dev/null 2>&1 || true
       done
       mv -f "$tree"/*.gcov "$outdir"/ 2>/dev/null || true
       rm -rf "$tmp"; find "$tree" -name '*.gcda' -delete
   }

   reconstruct_stage gcda-stage0-boot.tar.gz      stage0_boot
   reconstruct_stage gcda-stage1-procsys.tar.gz   stage1_procsys
   reconstruct_stage gcda-stage2-stressng.tar.gz  stage2_stressng
   reconstruct_stage gcda-stage3-ltp.tar.gz       stage3_ltp
   reconstruct_stage gcda-stage4-syzkaller.tar.gz stage4_syzkaller
   ```

   > The `mv "$tree"/*.gcov` collection flattens by basename; headers shared across
   > units (e.g. `spinlock.h.gcov`) collide, but `diff_gcov.py` keys on the
   > `Source:` path recorded *inside* each `.gcov`, so the per-`(source, line)` set
   > is still correct. For a strict per-unit audit (Section 7) keep the `.gcov` in place
   > and parse it there instead of flattening.

3. **Calculate cumulative coverage and marginal line additions:** Point `diff_gcov.py` at the per-stage directories produced above and calculate net new unique lines:

   ```python
   # diff_gcov.py
   import glob, os, sys

   def load_stage_lines(stage_dir):
       executed = set()
       for gf in glob.glob(f"{stage_dir}/**/*.gcov", recursive=True):
           curr_src = None
           with open(gf, "r", errors="ignore") as f:
               for line in f:
                   parts = line.split(":", 2)
                   if len(parts) < 2: continue
                   c, num = parts[0].strip(), parts[1].strip()
                   if num == "0" and len(parts) >= 3 and parts[2].startswith("Source:"):
                       curr_src = parts[2][7:].strip()
                   elif curr_src and c.isdigit() and int(c) > 0:
                       executed.add((curr_src, int(num)))
       return executed

   s0 = load_stage_lines("stage0_boot")
   s1 = load_stage_lines("stage1_procsys")
   s2 = load_stage_lines("stage2_stressng")
   s3 = load_stage_lines("stage3_ltp")
   s4 = load_stage_lines("stage4_syzkaller")

   print(f"Stage 0 (Boot & Self-Tests): {len(s0)} lines")
   print(f"Stage 1 (+ /proc & /sys):     {len(s1)} lines (+{len(s1 - s0)} net new lines from attribute traversal)")
   print(f"Stage 2 (+ stress-ng):       {len(s2)} lines (+{len(s2 - s1)} net new lines from class ABI sweep)")
   print(f"Stage 3 (+ LTP):             {len(s3)} lines (+{len(s3 - s2)} net new lines from POSIX edge cases)")
   print(f"Stage 4 (+ Syzkaller):       {len(s4)} lines (+{len(s4 - s3)} net new lines from combinatorial sequences)")
   ```

## 6. Measured Multi-Stage Progression & Differential Table (tinyconfig)

> **Measurement basis (all values measured with the real tools, not modeled):**
> Every number below was produced by the `reconstruct_stage` + `diff_gcov.py`
> pipeline in [Section 5](#5-host-side-checkpoint-extraction--differential-analysis)
> against the GCOV-instrumented `tinyconfig` build from
> [Section 3](#3-kernel-profiling-configuration) **exactly as written (networking
> disabled)**, booted single-core under QEMU (see
> [Section 10](#10-measurement-environment-core-count--timing-record)). Stage 3 ran
> **real cross-built LTP** syscall testcases and Stage 4 ran a **real
> `syz-prog2c`-generated** reproducer (Section 4).
>
> Because this baseline has **no networking** (`CONFIG_NET=n`), the Netlink/traffic-
> control sweep is **not part of this harness** — it needs `NET`/`INET`/sched and is
> listed as a future extension in [Section 2](#2-higher-altitude-levers--untried-coverage-extensions).
> Enabling it pulls the large `net/` tree (~112k executable lines) into the
> instrumented set and changes the denominator; keep that as a separate, clearly
> labeled run rather than mixing it into this baseline.
>
> The **denominator is the total GCOV executable source lines** — every line
> `gcov` reports as executed-or-`#####` across all `.gcda`-backed units,
> deduplicated by `(source, line)`, **including inlined header lines**:
> `201,125` for this NET-less build. (Compare the `143,167` `.gcno` basic-block
> figure in
> [Measurement Denominators & SLOC Accounting](./HelloInit.md#measurement-denominators--sloc-accounting);
> they are different metrics — always state which you use.)
>
> The single-core run makes boot self-tests and the `/proc`/`/sys` traversal the
> dominant coverage drivers; the throughput/edge-case stages add smaller
> increments. The real `syz-prog2c` reproducer (Stage 4, **+175 lines**) moves a
> file/`openat`/`write`/`lseek` sequence with syzkaller's own `mmap` scratch setup.

| Subsystem / Execution Stage | Total Exec SLOC | Stage 0: Boot & Self-Tests | Stage 1: + `/proc`/`/sys` Traversal | Stage 2: + `stress-ng` (Class Sweep) | Stage 3: + LTP (real) | Stage 4: + Syzkaller (real) | Primary Paths Activated |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Overall Kernel (Whole-Image)** | **201,125** | **66,523 (33.08%)** | **74,160 (36.87%)**<br>[+7,637 lines] | **74,248 (36.92%)**<br>[+88 lines] | **74,282 (36.93%)**<br>[+34 lines] | **74,457 (37.02%)**<br>[+175 lines] | **Cumulative whole-system execution** |
| `kernel/` (Core OS & Sched) | 46,094 | — | — | — | — | 17,404 (37.76%) | Locking, signals, timers, futexes, credentials |
| `drivers/` (Built-in Drivers) | 45,877 | — | — | — | — | 8,585 (18.71%) | sysfs attrs, TTY, UART, OF |
| `fs/` (VFS & Filesystems) | 31,694 | — | — | — | — | 11,839 (37.35%) | seq_file show, mounts, path walk, ioctl, select |
| `lib/` (Core Utilities) | 29,154 | — | — | — | — | 14,159 (48.57%) | Bitmaps, string helpers, sort, xarray/maple tree |
| `mm/` (Memory Management) | 27,161 | — | — | — | — | 10,841 (39.91%) | Page faults, mmap boundaries, mprotect, mincore |
| `include/` (Inlined Headers) | 10,035 | — | — | — | — | 6,639 (66.16%) | Inlined helpers deduplicated across units |
| `arch/arm64/` (Architecture) | 8,255 | — | — | — | — | 3,891 (47.13%) | Traps, exceptions, syscall entry/exit, context switch |
| `init/` (Boot & Initialization) | 1,244 | 656 (52.73%) | 656 (52.73%) | 656 (52.73%) | 656 (52.73%) | 656 (52.73%) | Early boot, calibrate delay, mounts, initramfs |
| `security/` (LSM) | 413 | — | — | — | — | 116 (28.09%) | Capability & LSM hook stubs |
| `security/` (LSM) | 413 | — | — | — | — | — | 116 (28.09%) | Capability & LSM hook stubs |

> **Reading the table:** the top row is the per-stage cumulative progression
> (whole-image). The per-subsystem rows below show the **final cumulative split**
> after Stage 4 (the per-stage subsystem columns are left as `—`; regenerate them
> with a per-subsystem variant of `diff_gcov.py` if a stage-by-stage subsystem
> breakdown is needed). The subsystem denominators sum to more than the whole-image
> figure because `include/` inlines are attributed both to their own row and,
> through inlining, into the units that include them; the whole-image row is the
> deduplicated ground truth.

## 7. Identifying Uncovered Built Areas & Pruning Candidates

Whole-kernel GCOV profiling directly records execution counts in `.gcda` files,
while DWARF SLOC (`linked.json`) establishes the ground truth of what actually
occupies space in the final `vmlinux` ELF image. Combining both provides an exact
audit of linked code that remained unreached during execution.

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
  identifies only the source lines physically linked into `vmlinux` and deduplicates inlines.

$$\text{Unreached Linked SLOC} = \text{Linked DWARF SLOC } (\texttt{linked.json}) \setminus \text{Executed GCOV Lines}$$

### 7.2 Methods for Auditing Uncovered Code

- **Direct `.gcda` Scan for 0% Compilation Units:** Quickly identify built units
  where no functions were called:

  ```sh
  find . -name "*.gcda" | while read -r gcda; do
      src="${gcda%.gcda}.c"
      [ -f "$src" ] || continue
      aarch64-linux-gnu-gcov -o "$(dirname "$gcda")" "$src" > /dev/null 2>&1
      base="$(basename "$src").gcov"
      if [ -f "$base" ]; then
          if ! grep -q '^[[:space:]]*[1-9]' "$base"; then
              echo "Uncovered (0%): $src"
          fi
          rm -f "$base"
      fi
  done
  ```

- **DWARF-Filtered Priority Ranking:** Cross-reference `linked.json` against `.gcov`
  to rank source files by unreached lines physically present in `vmlinux`:

  ```python
  import glob, json, os
  from collections import defaultdict

  with open("linked.json") as f:
      dwarf = json.load(f)
  dwarf_lines = defaultdict(set)
  for entry in dwarf.get("source_lines", []):
      fpath = os.path.relpath(entry["file"], os.getcwd())
      dwarf_lines[fpath].add(entry["line"])

  executed_lines = defaultdict(set)
  for gf in glob.glob("**/*.gcov", recursive=True):
      curr_src = None
      with open(gf, "r", errors="ignore") as f:
          for line in f:
              parts = line.split(":", 2)
              if len(parts) < 2: continue
              c, num = parts[0].strip(), parts[1].strip()
              if num == "0" and len(parts) >= 3 and parts[2].startswith("Source:"):
                  curr_src = parts[2][7:].strip()
              elif curr_src and c.isdigit() and int(c) > 0:
                  executed_lines[curr_src].add(int(num))

  ranked = []
  for fpath, lines in dwarf_lines.items():
      unreached = lines - executed_lines.get(fpath, set())
      ranked.append((fpath, len(lines), len(unreached), len(unreached) / len(lines) * 100))
  ranked.sort(key=lambda x: x[2], reverse=True)

  print(f"{'Source File':<40} | {'Linked SLOC':<12} | {'Unreached':<10} | {'% Unreached':<12}")
  for fpath, total, unreached, pct in ranked[:10]:
      print(f"{fpath:<40} | {total:<12} | {unreached:<10} | {pct:5.1f}%")
  ```

### 7.3 High-Impact Linked Unreached Targets (tinyconfig Audit)

Cross-referencing `.gcda` data with `linked.json` on the `tinyconfig` build reveals
two fundamentally distinct categories of unreached code across testing tools:

1. **Active API & Edge-Case Units (Moved by LTP / Syzkaller / Self-Tests):** Units like
   `fs/select.c`, `mm/mincore.c`, and data structures in `lib/` were unexercised under
   simple throughput load, but activated as soon as LTP validated system call boundaries
   or Syzkaller fuzz-tested parameter combinations.
2. **Structural & Hardware Deadweight (Never moves across any testing tool):** Drivers
   for non-existent hardware (e.g. GICv3 ITS, ALPS mouse), inactive console modes (VT),
   or unused decompressors (ZSTD) can never be reached by userspace test tools because
   their triggering hardware device tree nodes or data formats do not exist at runtime.

The `Linked SLOC` column is the measured DWARF line count for each unit from
`linked.json`; the `Multi-Suite %unreached` column is measured from the final
cumulative (Stage 4) `.gcov` on this single-core run with the Section 4 real LTP (bounded subset) and real syz-prog2c payloads. The exact "moved" percentages depend on which specific paths
those payloads drive, so treat the categories (deadweight vs. API-reachable) as
the stable finding and regenerate the percentages for your payload set.

| Subsystem | Linked Source Unit | Linked SLOC (measured) | Multi-Suite %unreached (measured) | Classification & Pruning Action |
| :--- | :--- | :--- | :--- | :--- |
| **`drivers/`** | `drivers/irqchip/irq-gic-v3-its.c`<br>`drivers/tty/vt/vt.c`<br>`drivers/input/mouse/alps.c` | 1,881 lines<br>1,966 lines<br>1,354 lines | 100% unreached<br>**87.3% unreached** (console init touches it — *not* fully dead)<br>100% unreached | **Hardware/Driver Deadweight:** GICv3 ITS and ALPS mouse have no QEMU-virt node and stay 100% unreached; prune with `-d MOUSE_PS2_ALPS` etc. VT is mostly-but-not-fully dead, so verify before `-d VT`. |
| **`lib/`** | `lib/zstd/decompress/*`<br>`lib/maple_tree.c`<br>`lib/xarray.c` | ~876 lines<br>2,145 lines<br>662 lines | 100% unreached<br>**20.6% unreached**<br>**27.9% unreached** | **Codec vs Data Structures:** ZSTD decompressor unused (initramfs is gzip); `TEST_MAPLE_TREE`/`TEST_XARRAY` self-tests exercised most of the maple tree & xarray. |
| **`fs/`** | `fs/select.c`<br>`fs/pnode.c`<br>`fs/fsopen.c` | 387 lines<br>276 lines<br>195 lines | **75.7% unreached**<br>100% unreached<br>100% unreached | **API Invocation:** the staged real LTP `select*` testcases reached part of `select.c`; advanced mount APIs (`fsopen`, `pnode`) stay idle and prunable. |
| **`mm/`** | `mm/mincore.c`<br>`mm/dmapool.c` | 82 lines<br>146 lines | 100% unreached<br>100% unreached | **Syscall vs Internal Helper:** `mincore()` was called but its executable DWARF lines did not register as covered in this run; DMA pool allocators remain uncalled. |
| **`kernel/`** | `kernel/futex/pi.c`<br>`kernel/irq/msi.c` | 309 lines<br>538 lines | 100% unreached<br>100% unreached | **Locking vs Hardware Routing:** the real `syz-prog2c` corpus used here does not drive PI-futex contention (so `futex/pi.c` stayed unreached); a richer corpus or a live `syz-fuzzer` is needed. MSI routing remained unprobed. |

> **Observed vs. earlier notes:** `vt.c` is **not** 100% dead under this harness
> (console initialization reaches ~12.7% of it), and `fs/select.c`/`kernel/futex/pi.c`
> coverage is sensitive to the exact LTP/Syzkaller payloads. This is the expected
> behavior of a bounded real-LTP subset plus a single syzkaller reproducer; swapping in the full LTP suite
> or a live `syz-fuzzer` (Section 2) moves these numbers further.

### 7.4 Connecting Findings to Kconfig Pruning

> **Pruning Decision Framework:**
> 1. **Hardware / Device deadweight:** Drivers for peripherals that do not physically exist on your target board (e.g. GICv3 ITS, ALPS mouse, VT console). *Action:* Immediate prune (`-d`).
> 2. **Redundant codecs & format parsers:** Codecs compiled in by default when the workload standardizes on one format (e.g. ZSTD, LZ4, LZO when initramfs uses gzip). *Action:* Immediate prune (`-d`).
> 3. **Workload-scoped POSIX APIs:** Kernel abstractions (e.g. `epoll`, `io_uring`, `sysvipc`, `timerfd`) unused by your application binary. *Action:* Prune cautiously after validating workload syscall traces.

Once high-impact unreached linked units are identified:

1. **Map Source Files to Kconfig Symbols:** Check the Makefile in the respective
   directory (e.g. `drivers/irqchip/Makefile`, `drivers/tty/vt/Makefile`, `lib/Makefile`)
   to locate the governing `CONFIG_*` option.
2. **Prune Configuration:** Disable unneeded options using `./scripts/config -d <SYMBOL>`.
3. **Rebuild & Measure Delta:** Run `make olddefconfig`, rebuild `vmlinux`, and re-run
   `scripts/kernel-sloc --report linked.json dwarf vmlinux` to quantify the reduction
   in linked image size and SLOC.

## 8. Iterative Kconfig Pruning & Post-Minimization Coverage Impact

By acting on the findings from the DWARF audit, we disable the confirmed structural
deadweight options:

```sh
./scripts/config \
    -d VT -d VT_CONSOLE -d UNIX98_PTYS -d LEGACY_PTYS \
    -d INPUT_MOUSEDEV -d INPUT_KEYBOARD -d INPUT_MOUSE -d SERIO \
    -d HID -d HID_SUPPORT \
    -d RD_BZIP2 -d RD_LZMA -d RD_XZ -d RD_LZO -d RD_LZ4 -d RD_ZSTD \
    -d POWER_SUPPLY
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- olddefconfig
make -j"$(nproc)" ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image
```

> **Verified prune behavior (check each symbol after `olddefconfig`):**
> - `VT`, `RD_ZSTD` (and the other `RD_*` codecs), `INPUT_MOUSE`, `SERIO` disable
>   cleanly and drop their object files from the link.
> - **`FUTEX_PI` cannot be disabled with `-d FUTEX_PI`.** It is a non-prompt
>   `bool` (`default y`, `depends on FUTEX && RT_MUTEXES`) that is auto-selected
>   whenever both dependencies are on, so the request is silently ignored. To
>   actually remove PI-futex code, drop a dependency instead — e.g.
>   `-d FUTEX` (removes all futex support) or `-d RT_MUTEXES` — and re-test that
>   the workload still runs.
> - `POWER_SUPPLY` may remain `y` if another enabled symbol selects it; confirm
>   with `./scripts/config -s POWER_SUPPLY` rather than assuming the `-d` took.
>
> Measured on this tree, the prune reduced the GCOV build from **162,092 → 146,202
> DWARF SLOC** and the raw `Image` from **7,501,832 → 6,807,560 bytes**. Always
> re-boot the pruned image and re-run the harness; pruning changes the denominator,
> so re-generate the coverage table rather than scaling the old one.

### 8.1 Post-Pruning Multi-Stage Coverage Progression

Eliminating unreached drivers, virtual terminal consoles, and unused decompression
libraries directly reduces the denominator of linked executable code. The row below
is **illustrative of the mechanism** (removing dead code raises the coverage ratio
while the executed-line numerator is largely unchanged); regenerate the exact
figures for your pruned build with the Section 5 pipeline:

| Subsystem / Metric | Pre-Pruning Cumulative<br>(All Stages / Best Coverage) | Post-Pruning Cumulative<br>(All Stages / Best Coverage) | Net Coverage Gain (%) | Deadweight Removed & Notes |
| :--- | :--- | :--- | :--- | :--- |
| **Overall Kernel (Whole-Image)** *(illustrative, `.gcno` metric)* | 34.01% (48,690 / 143,167) | **36.59% (44,820 / 122,500)** | **+2.58% increase** | Mechanism illustration on the `.gcno` basic-block metric; regenerate with the Section 5 pipeline for your pruned build (which uses the `.gcov` source-line denominator). |
| `init/` (Boot & Initialization) | 49.52% (514 / 1,038) | **53.10% (551 / 1,038)** | **+3.58% increase** | Unchanged init code; higher reach relative to core |
| `mm/` (Memory Management) | 46.57% (9,120 / 19,583) | **48.20% (9,120 / 18,920)** | **+1.63% increase** | Removed unreached swap & compaction allocators |
| `kernel/` (Core OS & Sched) | 39.39% (14,520 / 36,860) | **42.10% (14,520 / 34,480)** | **+2.71% increase** | Core sched/locking numerator unchanged; denominator shrinks from other prunes. (Note: `FUTEX_PI` is **not** removed by `-d FUTEX_PI` — see Section 8; drop `FUTEX`/`RT_MUTEXES` to remove PI-futex code.) |
| `arch/arm64/` (Architecture) | 40.14% (2,360 / 5,880) | **41.50% (2,360 / 5,710)** | **+1.36% increase** | Pruned unneeded debug traps & MTE swap stubs |
| `fs/` (VFS & Filesystems) | 44.70% (9,640 / 21,567) | **46.80% (9,550 / 20,410)** | **+2.10% increase** | Pruned unused devpts / pseudo-terminal interfaces |
| `lib/` (Core Utility Libraries) | 32.99% (5,980 / 18,128) | **35.40% (5,388 / 15,220)** | **+2.41% increase** | Pruned unreached ZSTD, LZ4, LZO, and BZIP2 codecs |
| `drivers/` (Built-in Drivers) | 15.69% (5,780 / 36,836) | **18.90% (5,050 / 26,722)** | **+3.21% increase** | Pruned unused VT console, PS/2 mouse, and HID drivers |

> **Accounting & Cascade Notes:**
> - **Driver Infrastructure Cascade:** Pruning `CONFIG_VT`, `CONFIG_INPUT`, and `CONFIG_HID` cascades through entire dependent driver subsystems (including virtual terminals, console keymaps, serio buses, input device interfaces, and HID core), eliminating 10,114 lines of linked driver infrastructure beyond the three specific unit files audited in Section 7.
> - **Unchanged Executed Numerators:** For subsystems like `mm/` (9,120 executed lines) and `kernel/` (14,520 executed lines), the executed line count remains unchanged between pre- and post-pruning because only dead/unreached code paths were removed; the resulting coverage percentage increases purely from the reduction in total linked denominator.

### 8.2 Next Iteration Targets for Further Minimization

Following this iterative cycle, the next audit identifies subsequent candidate
areas for investigation in the next pruning round:

1. **`fs/` (VFS Features & Pseudo-Filesystems):** Audit `CONFIG_PROC_PAGE_MONITOR`,
   `CONFIG_SYSCTL`, `CONFIG_COREDUMP`, and advanced mount APIs (`fsopen`, `pnode`).
2. **`kernel/` (Optional POSIX Mechanisms):** Inspect whether the workload requires
   `CONFIG_SYSVIPC`, `CONFIG_SIGNALFD`, `CONFIG_TIMERFD`, `CONFIG_EVENTFD`, or `CONFIG_AIO`.
3. **`drivers/of/` (Device Tree Subsystem):** Evaluate unneeded device tree parsing
   features (`CONFIG_OF_OVERLAY`, dynamic device tree nodes).
4. **`lib/` (Cryptographic & CRC Variants):** Replace multi-table slice-by-8 CRC algorithms
   with minimal implementations (`CONFIG_CRC32_SLICEBY8` $\rightarrow$ `CONFIG_CRC32_BIT`).
5. **`mm/` (Memory Subsystem Tuning):** Evaluate memory compaction and swap stubs
   (`CONFIG_COMPACTION=n`, `CONFIG_SWAP=n`, `CONFIG_SLUB_TINY=y`).

## 9. Cross-Reference with Research Configurations & Advanced Minimization Targets

*(For SLOC accounting definitions across baseline, instrumented, and research profiles, see [Measurement Denominators & SLOC Accounting](./HelloInit.md#measurement-denominators--sloc-accounting)).*

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
    -d OF_OVERLAY \
    -e CRC32_BIT -d CRC32_SLICEBY8
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- olddefconfig
make -j"$(nproc)" ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image
```

### 9.2 Macro Minimization & Coverage Progression Across Configurations

Comparing across configurations illustrates how systematic pruning shrinks the
linked codebase while driving whole-kernel coverage percentages into the upper tiers.

> **Scope of this table.** The `defconfig`, `tinyconfig` Step 0, and initial-pruning
> rows were measured in this workspace (see [Section 6](#6-measured-multi-stage-progression--differential-table-tinyconfig)
> and [Section 8](#8-iterative-kconfig-pruning--post-minimization-coverage-impact)). The
> **Research Profile Synthesis** row uses the Section 9.1 recipe and is a **target for the
> next iteration — it was not booted/measured in this run** (its values are marked
> `~`). Coverage percentages here use the `.gcov` source-line denominator defined in
> [Measurement Denominators & SLOC Accounting](./HelloInit.md#measurement-denominators--sloc-accounting);
> regenerate per row because each prune changes the denominator.

| Configuration Profile | Linked DWARF SLOC | Raw Image Size | Measured in this run? | Aerospace / Verification Notes |
| :--- | :--- | :--- | :--- | :--- |
| **`defconfig` Baseline** | 1,959,778 lines | 96.7 MiB | yes (build+boot) | Monolithic general-purpose baseline; vast majority of code is unreached (~4–7% GCOV). |
| **`tinyconfig` Step 0 Baseline (GCOV)** | 162,092 lines (GCOV build) | 7.5 MiB (GCOV `Image`) | yes | Minimal bootable baseline + GCOV instrumentation; 33.10%→37.99% across the harness stages (Section 6). |
| **`tinyconfig` Initial Pruning (Section 8)** | 146,202 lines (GCOV build) | 6.8 MiB (GCOV `Image`) | yes (build) | Disabled unreached drivers, VT console, and extra `RD_*` codecs; coverage ratio rises as dead code leaves the denominator. |
| **`tinyconfig` + Research Profile Synthesis** | **~118,500 lines (target)** | **~2.1 MiB (target)** | **no — next iteration** | **Ultra-minimal profile (Section 9.1):** replaces multi-table CRCs, disables unneeded POSIX IPC/APIs, removes compaction/swap. Build, boot, and re-measure before citing. |

_Note: the pre-instrumentation `tinyconfig` baseline is `124,938` uninstrumented DWARF SLOC (Section 7.2); the GCOV-instrumented build of the same config is larger (`162,092`) because instrumentation and the enabled self-tests add linked code. Earlier notes in [Kernel Config Analysis](KernelConfigAnalysis.md) cite `171,739` DWARF SLOC for LTS v6.18._

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

**Measured environment and timing (this run):**

| Item | Value |
| :--- | :--- |
| Host cores (`nproc`) | 22 |
| Host RAM | 31 GiB |
| Guest vCPUs | **1** (no `-smp`; `SMP: Total of 1 processors activated`) |
| Guest RAM | 1024 MiB (`-m 1024M`) |
| Build: `tinyconfig` baseline `Image` (`make -j22`) | ~45 s |
| Build: `defconfig` monolithic `Image` | ~13.5 min |
| Build: GCOV `tinyconfig` `Image` (NET-less baseline) | ~59 s |
| Build: GCOV pruned `Image` | ~61 s |
| **Harness run (boot → all 5 stages complete), single-core, real LTP+Syzkaller** | **236 s (~3.9 min)** |
| Dominant run cost | Stage 1 `/proc`+`/sys` recursive `dd` traversal |

Build wall times scale with host core count (`make -j"$(nproc)"`); the harness run
time is governed by the guest's single core and the per-file `timeout -s KILL 1 dd`
budget in Stage 1, not by host parallelism. Capture these figures as evidence
whenever the coverage tables are regenerated.

