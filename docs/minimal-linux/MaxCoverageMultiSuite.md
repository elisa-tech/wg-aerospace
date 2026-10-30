<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

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

Start from the bootable `tinyconfig` baseline from [Section 4](./HelloInit.md#4-change-kernel-options--configuration)
(`tinyconfig` + PL011 serial, printk, initrd, ELF, `-MODULES`), then enable
whole-kernel GCOV profiling, boot self-tests, and the workload prerequisites
on ARM64. Use the pinned draft helper and record the actual tool versions as
described in [Hello Init](./HelloInit.md#2-environment).

```sh
./scripts/config \
    -e DEBUG_FS -e SYSFS -e PROC_FS -e DEVTMPFS -e DEVTMPFS_MOUNT \
    -e GCOV_KERNEL -e GCOV_PROFILE_ALL \
    -e FUTEX -e POSIX_TIMERS -e SHMEM -e MEMFD_CREATE -e ADVISE_SYSCALLS \
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
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- clean
make -j"$(nproc)" ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image
```

> **Required for the self-tests to survive `olddefconfig` (verified):**
>
> - `-e RUNTIME_TESTING_MENU` is **mandatory**. The `TEST_*` options and
>   `ATOMIC64_SELFTEST` live under the `menuconfig RUNTIME_TESTING_MENU` guard,
>   which is `n` in `tinyconfig`. Without it, `olddefconfig` **silently drops every
>   `TEST_*` and `ATOMIC64_SELFTEST`** request, so Stage 0 self-test coverage never
>   compiles in.
> - `-e KUNIT` is required for `TEST_SORT` and `TEST_LIST_SORT`: both now
>   `depends on KUNIT` (they are KUnit tests), so they are dropped without it.
> - The DWARF debug-info options are added so the same `vmlinux` supports the
>   linked-SLOC audit in [Section 7](#7-identifying-uncovered-built-areas--pruning-candidates).
> - `POSIX_TIMERS=y` is required for stress-ng's `alarm()` timeout. Without it,
>   `setitimer()` returns `ENOSYS` and the class sweep can hang despite
>   `--timeout 1s`. The original recipe failed to finish within 900 seconds.
> - `SHMEM=y` supplies shared-memory backing and `MEMFD_CREATE=y` enables
>   the syscall itself; `SHMEM` alone does not select it on this kernel.
>   `ADVISE_SYSCALLS=y` enables `madvise()`. Without these options, the corpus
>   exercises syscall rejection paths and its memfd-backed mapping fails.
>
> Confirm the requests survived before building:
>
> ```sh
> for c in GCOV_KERNEL GCOV_PROFILE_ALL RUNTIME_TESTING_MENU KUNIT \
>          ATOMIC64_SELFTEST TEST_MAPLE_TREE TEST_XARRAY TEST_SORT DEBUG_INFO \
>          POSIX_TIMERS SHMEM MEMFD_CREATE ADVISE_SYSCALLS; do
>     printf '%s=' "$c"; ./scripts/config -s "$c"
> done
> ```

_(Optional, out of scope for this baseline: to add the Netlink/traffic-control
sweep listed in [Section 2](#2-higher-altitude-levers--untried-coverage-extensions),
rebuild with `-e NET -e INET -e NETLINK_DIAG -e DUMMY -e VETH -e BRIDGE -e VLAN_8021Q -e NET_SCHED`.
This pulls the large `net/` tree into the instrumented set and changes the
denominator, so run and report it separately from the NET-less baseline below.)_

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

   # stress-ng is dynamically linked and needs shared libraries that the bare
   # Alpine minirootfs does NOT ship. `tar -xzf` does not resolve .apk
   # dependencies, so these must be staged explicitly or stress-ng aborts at
   # load time with "Error relocating /usr/bin/stress-ng: <symbol> not found"
   # Direct dependencies include libbsd.so.0, libJudy.so.1, libsctp.so.1,
   # libz.so.1, and musl. libbsd additionally needs libmd.so.0.
   # Loader failure prevents stressors from running. The launcher records the
   # failure; exported checkpoints alone are not a suite pass.
   # Pinned versions for v3.20/aarch64:
   for dep in \
       main/aarch64/libbsd-0.12.2-r0.apk \
       main/aarch64/libmd-1.1.0-r0.apk \
       main/aarch64/liblksctp-1.0.19-r5.apk \
       community/aarch64/judy-1.0.5-r1.apk ; do
       wget "https://dl-cdn.alpinelinux.org/alpine/v3.20/$dep"
       tar -xzf "$(basename "$dep")" -C rootfs-alpine
   done
   # Verify every NEEDED lib now resolves before booting:
   #   aarch64-linux-gnu-readelf -d rootfs-alpine/usr/bin/stress-ng | grep NEEDED
   #   # then confirm libbsd.so.0 / libJudy.so.1 / libsctp.so.1 / libmd.so.0
   #   # and libz.so.1 (already in the pinned minirootfs)
   #   # exists under rootfs-alpine/usr/lib or rootfs-alpine/lib

   # Stage Syzkaller reproducer — real syz-prog2c output.
   # The devcontainer ships Go, so build syzkaller's syz-prog2c host tool and
   # export a sandbox-legal corpus to C, then cross-compile it statically.
   # Pinned commit for reproducibility:
   #   432c00775d20929a96fd4987f9ef01a50e6fd277
   #   2026-10-16  "pkg/aflow/flow/patching: add patch-planner agent"
   git clone https://github.com/google/syzkaller
   ( cd syzkaller && git checkout 432c00775d20929a96fd4987f9ef01a50e6fd277 && \
     go version && \
     make prog2c )                          # builds bin/syz-prog2c (host/amd64)
   # This commit requires Go 1.26.0 or newer. With GOTOOLCHAIN=auto an older
   # supported Go may download 1.26.0; record that selected version.
   # NET-less corpus: file I/O + memfd/mmap/madvise/mlock, PLUS an execveat() of a
   # deliberately malformed (non-ELF) file. The bad-exec call drives the
   # exec-failure / abort_creds / ELF-magic-reject paths. No socket calls
   # (CONFIG_NET=n). Sandbox-legal (relative './file0' path, proper result threading).
   cat << 'EOF' > corpus.syz
   r1 = openat$dir(0xffffffffffffff9c, &(0x7f0000000100)='./file0\x00', 0x42, 0x1a4)
   write$binfmt_script(r1, &(0x7f0000000200)={'#! ', './file0'}, 0xb)
   lseek(r1, 0x0, 0x0)
   pread64(r1, &(0x7f0000000300)=""/16, 0x10, 0x0)
   ftruncate(r1, 0x80)
   fsync(r1)
   close(r1)
   r2 = memfd_create(&(0x7f0000000000)='m\x00', 0x0)
   mmap(&(0x7f0000001000/0x1000)=nil, 0x1000, 0x3, 0x11, r2, 0x0)
   madvise(&(0x7f0000001000/0x1000)=nil, 0x1000, 0x4)
   mlock(&(0x7f0000001000/0x1000)=nil, 0x1000)
   munlock(&(0x7f0000001000/0x1000)=nil, 0x1000)
   r3 = openat$dir(0xffffffffffffff9c, &(0x7f0000000400)='./bad\x00', 0x42, 0x1ff)
   write(r3, &(0x7f0000000500)="deadbeef0000", 0xc)
   close(r3)
   execveat(0xffffffffffffff9c, &(0x7f0000000400)='./bad\x00', 0x0, 0x0, 0x0)
   EOF
   ./syzkaller/bin/syz-prog2c -os linux -arch arm64 -trace \
       -prog corpus.syz > syz-repro.c
   mkdir -p rootfs-alpine/opt/syzkaller
   aarch64-linux-gnu-gcc -static -O2 -o rootfs-alpine/opt/syzkaller/syz-repro syz-repro.c
   ```

   > **Tool acquisition notes:**
   >
   > - **stress-ng needs its shared-library dependencies staged.** The Alpine
   >   `stress-ng` binary is dynamically linked against `libbsd.so.0`,
   >   `libJudy.so.1`, `libsctp.so.1`, and `libz.so.1`; libbsd needs
   >   `libmd.so.0` transitively. The minirootfs supplies zlib and musl; stage
   >   the other libraries explicitly. Extracting only `stress-ng` leaves it
   >   unable to load: stressors abort with relocation errors and Stage 2
   >   adds almost nothing, yet the harness still
   >   reaches the end of its launch sequence. Stage the four dependency
   >   `.apk`s shown above and verify with `readelf -d` before booting.
   > - **(Optional networking extension only)** `tc` is **not** in
   >   `iproute2-minimal`; it ships in the separate `iproute2-tc` subpackage.
   >   Staging only `iproute2-minimal` leaves the optional `tc qdisc` commands
   >   silently failing. This NET-less baseline stages neither.
   > - **Real Syzkaller** requires Go 1.26.0 for the pinned commit. Explicit
   >   `-os linux -arch arm64` selects target descriptions independently of the
   >   host architecture. It validates the corpus against those descriptions —
   >   the corpus above is sandbox-legal (relative `./file0` path, proper result
   >   threading); an absolute `/dev/null` path or dangling result refs are
   >   rejected. `-trace` prints each call's errno: expect call 7
   >   (`memfd_create`), call 8 (mapping), and call 9 (`madvise`) to succeed,
   >   and call 15 (malformed `execveat`) to return `ENOEXEC` (8).
   >   The corpus does not grow its memfd before mapping; call 10 (`mlock`)
   >   can return `ENOMEM` (12). Record that as a rejection-path observation,
   >   not successful locking of memfd-backed pages.
   >   A zero process exit alone does not establish those syscall outcomes.

2. **Static multi-stage `/init` launcher with labeled checkpoints:**

   ```c
   /* rootfs-alpine/init.c */
   #include <errno.h>
   #include <signal.h>
   #include <stdio.h>
   #include <stdlib.h>
   #include <time.h>
   #include <unistd.h>
   #include <sys/mount.h>
   #include <sys/time.h>
   #include <sys/wait.h>

   static int emit_checkpoint(const char *stage_name)
   {
       char cmd[512];
       int length = snprintf(cmd, sizeof(cmd),
                "mkdir -p /tmp/dump && "
                "find /sys/kernel/debug/gcov -type d -exec mkdir -p /tmp/dump/{} \\; && "
                "find /sys/kernel/debug/gcov -name '*.gcda' -exec sh -c 'cat < \"$0\" > \"/tmp/dump/$0\"' {} \\; && "
                "tar -czf /tmp/gcda.tar.gz -C /tmp/dump sys && "
                "echo '===GCOV_%s_START===' && "
                "base64 /tmp/gcda.tar.gz && "
                "echo '===GCOV_%s_END===' && "
                "rm -rf /tmp/dump /tmp/gcda.tar.gz",
                stage_name, stage_name);
       if (length < 0 || (size_t)length >= sizeof(cmd))
           return 1;
       if (system(cmd) != 0) {
           fprintf(stderr, "CHECKPOINT FAILED: %s\n", stage_name);
           return 1;
       }
       return 0;
   }

   static int run_cmd(const char *label, char *const argv[], int seconds)
   {
       if (access(argv[0], X_OK) != 0) {
           fprintf(stderr, "FAILED: %s executable missing\n", label);
           return 1;
       }
       pid_t pid = fork();
       if (pid < 0) {
           perror("fork");
           return 1;
       }
       if (pid == 0) {
           if (setpgid(0, 0) != 0)
               _exit(127);
           execv(argv[0], argv);
           perror(argv[0]);
           _exit(127);
       }
       if (setpgid(pid, pid) != 0 && errno != EACCES && errno != ESRCH)
           perror("setpgid");
       struct timespec start, now;
       if (clock_gettime(CLOCK_MONOTONIC, &start) != 0)
           return 1;
       for (;;) {
           int status;
           pid_t done = waitpid(pid, &status, WNOHANG);
           if (done == pid) {
               int ok = WIFEXITED(status) && WEXITSTATUS(status) == 0;
               fprintf(stderr, "CHILD %s: status=%d %s\n",
                       label, status, ok ? "OK" : "FAILED");
               return !ok;
           }
           if (done < 0 && errno != EINTR) {
               perror("waitpid");
               return 1;
           }
           if (clock_gettime(CLOCK_MONOTONIC, &now) != 0)
               return 1;
           if (now.tv_sec - start.tv_sec >= seconds) {
               fprintf(stderr, "WATCHDOG: %s exceeded %d seconds\n",
                       label, seconds);
               kill(-pid, SIGKILL);
               kill(pid, SIGKILL);
               /* The host watchdog also bounds uninterruptible reads. */
               return 1;
           }
           struct timespec delay = { .tv_nsec = 100000000 };
           nanosleep(&delay, NULL);
       }
   }

   int main(void)
   {
       int failures = 0;
       setvbuf(stdout, NULL, _IONBF, 0);
       if (mount("proc", "/proc", "proc", 0, NULL) != 0)
           perror("mount /proc"), failures++;
       if (mount("sysfs", "/sys", "sysfs", 0, NULL) != 0)
           perror("mount /sys"), failures++;
       if (mount("devtmpfs", "/dev", "devtmpfs", 0, NULL) != 0)
           perror("mount /dev"), failures++;
       if (mount("debugfs", "/sys/kernel/debug", "debugfs", 0, NULL) != 0)
           perror("mount /sys/kernel/debug"), failures++;

       /* Stage 0: Boot Self-Tests (Executed automatically during boot initcalls) */
       failures += emit_checkpoint("STAGE0_BOOT");

       /* Stage 1: /proc and /sys Attribute Traversal */
       puts("=== Stage 1: Traversing /proc and /sys attributes ===");
       /* BusyBox timeout uses a separate sleeping process. It does not need
          POSIX interval timers; a D-state read still needs the host watchdog.
          /sys already includes debugfs, so visit that subtree only once. */
       char *traverse[] = {
           "/bin/sh", "-c",
           "find /proc /sys -type f 2>/dev/null | while read -r f; do "
           "case \"$f\" in "
           "*/trace_pipe*|*/kcore|*/mem|*/kmsg|*/sysrq-trigger|*/null|*/zero|"
           "/proc/[0-9]*|*/clear_refs|*/kunit/*/results) ;; "
           "*) timeout -s KILL 1 dd if=\"$f\" of=/dev/null bs=4k count=1 "
           "2>/dev/null ;; esac; done; exit 0",
           NULL
       };
       failures += run_cmd("proc/sys traversal", traverse, 900);
       failures += emit_checkpoint("STAGE1_PROCSYS");

       /* Stage 2: stress-ng, sequential class sweep on one guest CPU. */
       puts("=== Stage 2: Executing stress-ng sequential class sweep ===");
       struct itimerval zero = {0};
       int timers_ok = setitimer(ITIMER_REAL, &zero, NULL) == 0;
       if (!timers_ok)
           perror("POSIX_TIMERS required"), failures++;
       const char *classes[] = {
           "os", "scheduler", "memory", "filesystem", "interrupt"
       }; /* no network class: CONFIG_NET=n */
       size_t count = sizeof(classes) / sizeof(classes[0]);
       for (size_t i = 0; timers_ok && i < count; i++) {
           char *sng_argv[] = {
               "/usr/bin/stress-ng",
               "--seq", "0",
               "--class", (char *)classes[i],
               "--timeout", "1s",
               "--metrics",
               NULL
           };
           failures += run_cmd(classes[i], sng_argv, 600);
       }
       failures += emit_checkpoint("STAGE2_STRESSNG");

       /* Stage 3: Syzkaller (Combinatorial Multi-Syscall Sequence Playback,
          including a deliberate bad-exec to drive exec-failure paths) */
       puts("=== Stage 3: Executing Syzkaller standalone sequence reproducer ===");
       char *syz_argv[] = { "/opt/syzkaller/syz-repro", NULL };
       failures += run_cmd("Syzkaller", syz_argv, 30);
       failures += emit_checkpoint("STAGE3_SYZKALLER");

       puts(failures ? "=== HARNESS INCOMPLETE ==="
                     : "=== All test stages complete ===");
       for (;;)
           pause();
       return 0;
   }
   ```

3. **Package and boot in QEMU:**

   ```sh
   aarch64-linux-gnu-gcc -static -O2 -o rootfs-alpine/init rootfs-alpine/init.c
   ( cd rootfs-alpine && find . | cpio -o -H newc ) | gzip > initramfs-alpine.cpio.gz
   # bash: preserve QEMU/watchdog failures through tee.
   set -o pipefail
   timeout --signal=TERM --kill-after=5s 30m \
       qemu-system-aarch64 -machine virt -cpu cortex-a57 -m 1024M -nographic \
       -kernel arch/arm64/boot/Image -initrd initramfs-alpine.cpio.gz \
       -append 'console=ttyAMA0 nokaslr' 2>&1 | tee qemu-gcov.log
   ```

   > This command passes **no `-smp`**, so the guest runs single-core with
   > 1024 MiB RAM. Record timing per
   > [Section 10](#10-measurement-environment-core-count--timing-record).
   > For exploration, wait for all four `===GCOV_STAGE*_END===` markers and
   > either final summary marker before exiting with `Ctrl-a x`. Retain failures.
   > To claim a supported test gate passes, require the success marker and no
   > watchdog, suite failure, kernel panic, or failed boot self-test. Review
   > stress-ng's skips and Syzkaller's per-call errno trace. Exported coverage
   > alone does not establish acceptance.

## 5. Host-Side Checkpoint Extraction & Differential Analysis

1. **Extract checkpoint archives from console log:**

   ```sh
   sed -n '/===GCOV_STAGE0_BOOT_START===/,/===GCOV_STAGE0_BOOT_END===/p' qemu-gcov.log \
       | grep -v '===' | tr -d '\r' | base64 -d > gcda-stage0-boot.tar.gz
   sed -n '/===GCOV_STAGE1_PROCSYS_START===/,/===GCOV_STAGE1_PROCSYS_END===/p' qemu-gcov.log \
       | grep -v '===' | tr -d '\r' | base64 -d > gcda-stage1-procsys.tar.gz
   sed -n '/===GCOV_STAGE2_STRESSNG_START===/,/===GCOV_STAGE2_STRESSNG_END===/p' qemu-gcov.log \
       | grep -v '===' | tr -d '\r' | base64 -d > gcda-stage2-stressng.tar.gz
   sed -n '/===GCOV_STAGE3_SYZKALLER_START===/,/===GCOV_STAGE3_SYZKALLER_END===/p' qemu-gcov.log \
       | grep -v '===' | tr -d '\r' | base64 -d > gcda-stage3-syzkaller.tar.gz
   ```

2. **Reconstruct one gcov JSON inventory per compilation unit.** Match each
   runtime `.gcda` with its build-time `.gcno` and run the compiler's matching
   `aarch64-linux-gnu-gcov` **from the kernel tree root**. Source paths are
   relative to that location. Use the standalone reconstruction tool [docs/minimal-linux/max-coverage/reconstruct_stage.py](./max-coverage/reconstruct_stage.py):

   ```python
   # reconstruct_stage.py
   import argparse
   import shutil
   import subprocess
   import tarfile
   import tempfile
   from pathlib import Path

   parser = argparse.ArgumentParser()
   parser.add_argument("archive", type=Path)
   parser.add_argument("output", type=Path)
   args = parser.parse_args()
   tree = Path.cwd().resolve()
   if not (tree / "vmlinux").is_file():
       parser.error("run from the matching isolated kernel build tree")
   output = args.output.resolve()
   output.mkdir(parents=True, exist_ok=False)
   # Use a fresh output directory; never reuse another run's inventories.
   for previous in tree.rglob("*.gcda"):
       previous.unlink()
   copied = []
   try:
       with tempfile.TemporaryDirectory() as temporary:
           temporary = Path(temporary)
           with tarfile.open(args.archive) as archive:
               archive.extractall(temporary, filter="data")  # Python >= 3.12
           debug_root = temporary / "sys/kernel/debug/gcov"
           units = sorted(debug_root.rglob("*.gcda"))
           if not units:
               raise RuntimeError("checkpoint contains no gcda units")
           for counters in units:
               target = (Path("/") / counters.relative_to(debug_root)).resolve()
               if not target.is_relative_to(tree):
                   raise RuntimeError(f"wrong checkpoint tree: {target}")
               if not target.with_suffix(".gcno").is_file():
                   raise RuntimeError(f"missing matching gcno: {target}")
               shutil.copyfile(counters, target)
               copied.append(target)
               if list(tree.glob("*.gcov.json.gz")):
                   raise RuntimeError("move existing gcov JSON outputs first")
               with (output / "gcov.log").open("a", encoding="utf-8") as log:
                   subprocess.run(
                       ["aarch64-linux-gnu-gcov", "--json-format",
                        "-o", str(target.parent), str(target)],
                       cwd=tree, stdout=log, stderr=log, check=True,
                   )
               generated = list(tree.glob("*.gcov.json.gz"))
               if len(generated) != 1:
                   raise RuntimeError(f"expected one JSON file: {target}")
               destination = output / target.relative_to(tree).with_suffix(
                   ".gcov.json.gz"
               )
               destination.parent.mkdir(parents=True, exist_ok=True)
               shutil.move(generated[0], destination)
   finally:
       for target in copied:
           target.unlink(missing_ok=True)
   print(f"{len(copied)} units reconstructed")
   ```

   ```sh
   python3 reconstruct_stage.py gcda-stage0-boot.tar.gz stage0_boot
   python3 reconstruct_stage.py gcda-stage1-procsys.tar.gz stage1_procsys
   python3 reconstruct_stage.py gcda-stage2-stressng.tar.gz stage2_stressng
   python3 reconstruct_stage.py gcda-stage3-syzkaller.tar.gz stage3_syzkaller
   ```

   Each stage must contain the same runtime unit inventory for this monolithic
   kernel. Missing units, invalid archives, gcov errors, or a zero denominator
   invalidate the comparison. Check archive integrity with `tar -tzf` before
   reconstruction.

   **Do not flatten text `.gcov` outputs.** Repeated gcov invocations overwrite
   shared-header basenames before collection; `Source:` metadata cannot recover
   that discarded execution data. JSON retains all unit inventories and numeric
   counts, including partial execution shown as `1*` in text output.

3. **Union source lines and calculate cumulative coverage.** Save
   `diff_gcov.py` beside the stage directories and run from the kernel tree.
   It reports both the executable denominator and executed numerator:

   ```python
   # diff_gcov.py
   import gzip
   import json
   import os
   from pathlib import Path

   def load_stage_lines(stage_dir):
       executed = set()
       executable = set()
       reports = sorted(Path(stage_dir).rglob("*.gcov.json.gz"))
       if not reports:
           raise ValueError(f"no gcov inventories in {stage_dir}")
       for report in reports:
           with gzip.open(report, "rt", encoding="utf-8") as stream:
               unit = json.load(stream)
           for source in unit["files"]:
               path = os.path.relpath(os.path.realpath(source["file"]))
               for line in source["lines"]:
                   key = (path, line["line_number"])
                   executable.add(key)
                   if line["count"] > 0:
                       executed.add(key)
       if not executable:
           raise ValueError(f"zero executable denominator in {stage_dir}")
       return executed, executable

   if __name__ == "__main__":
       previous = set()
       denominator = None
       inventory = None
       for stage in ("stage0_boot", "stage1_procsys",
                     "stage2_stressng", "stage3_syzkaller"):
           units = {report.relative_to(stage)
                    for report in Path(stage).rglob("*.gcov.json.gz")}
           if inventory is not None and units != inventory:
               raise ValueError(f"runtime unit inventory changed at {stage}")
           executed, executable = load_stage_lines(stage)
           if denominator is not None and executable != denominator:
               raise ValueError(f"executable inventory changed at {stage}")
           if not previous <= executed:
               raise ValueError(f"executed lines disappeared at {stage}")
           print(
               f"{stage}: {len(executed)} / {len(executable)} "
               f"({100 * len(executed) / len(executable):.2f}%), "
               f"+{len(executed - previous)} new lines"
           )
           previous = executed
           denominator = executable
           inventory = units
   ```

   ```sh
   python3 diff_gcov.py
   ```

   Partition by the normalized source path's first component for subsystem
   tables. Count headers under their own paths once, and include `scripts/` and
   `tools/` when generated or shared sources from those roots occur in the
   linked kernel. These partition rows must sum to the whole-image totals.

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

```sh
./scripts/config \
    -d VT -d VT_CONSOLE -d UNIX98_PTYS -d LEGACY_PTYS \
    -d INPUT_MOUSEDEV -d INPUT_KEYBOARD -d INPUT_MOUSE -d SERIO \
    -d HID -d HID_SUPPORT \
    -d RD_BZIP2 -d RD_LZMA -d RD_XZ -d RD_LZO -d RD_LZ4 -d RD_ZSTD \
    -d POWER_SUPPLY
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- olddefconfig
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- clean
make -j"$(nproc)" ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image
```

> **Verified prune behavior (check each symbol after `olddefconfig`):**
>
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
> With the corrected workload prerequisites, the prune reduces the GCOV build
> from **164,992 → 149,102 DWARF SLOC** and the raw `Image` from
> **7,596,040 → 6,901,768 bytes** (GCC 13.3.0, binutils 2.42). Always
> re-boot the pruned image and re-run the harness; pruning changes the denominator,
> so re-generate the coverage table rather than scaling the old one.

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
4. **`lib/` (Cryptographic & CRC Variants):** Replace multi-table slice-by-8 CRC algorithms
   with minimal implementations (`CONFIG_CRC32_SLICEBY8` $\rightarrow$ `CONFIG_CRC32_BIT`).
5. **`mm/` (Memory Subsystem Tuning):** Evaluate memory compaction and swap stubs
   (`CONFIG_COMPACTION=n`, `CONFIG_SWAP=n`, `CONFIG_SLUB_TINY=y`).

## 9. Cross-Reference with Research Configurations & Advanced Minimization Targets

_(For SLOC accounting definitions across baseline, instrumented, and research profiles, see [Measurement Denominators & SLOC Accounting](./HelloInit.md#measurement-denominators--sloc-accounting))._

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
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- clean
make -j"$(nproc)" ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image
```

This research recipe remains unmeasured. Disabling `SHMEM` changes memfd backing
and shared-memory behavior even if `MEMFD_CREATE` remains enabled. Re-test the
corpus and label changed results rather than assuming its success paths survive.

### 9.2 Macro Minimization & Coverage Progression Across Configurations

Comparing across configurations illustrates how systematic pruning shrinks the
linked codebase while driving whole-kernel coverage percentages into the upper tiers.

> **Scope of this table.** The `defconfig`, `tinyconfig` Step 0, and initial-pruning
> rows were measured in this workspace (see [Section 6](#6-measured-multi-stage-progression--differential-table-tinyconfig)
> and [Section 8](#8-iterative-kconfig-pruning--post-minimization-coverage-impact)). The
> **Research Profile Synthesis** row uses the Section 9.1 recipe and is a **target for the
> next iteration — it was not booted/measured in this run** (its values are marked
> `~`). Coverage percentages use the gcov JSON source-line union defined in
> [Measurement Denominators & SLOC Accounting](./HelloInit.md#measurement-denominators--sloc-accounting);
> regenerate per row because each prune changes the denominator.

| Configuration Profile                         | Linked DWARF SLOC           | Raw Image Size            | Measured in this run?   | Aerospace / Verification Notes                                                                                                                                            |
| :-------------------------------------------- | :-------------------------- | :------------------------ | :---------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **`defconfig` Baseline**                      | 1,959,778 lines             | 101,362,176 B (96.67 MiB) | yes (build+boot)        | Uninstrumented monolithic baseline; no whole-kernel GCOV percentage measured for this row.                                                                                |
| **`tinyconfig` Step 0 Baseline (GCOV)**       | 164,992 lines               | 7,596,040 B (7.24 MiB)    | yes (build+exploration) | Corrected prerequisites; 32.65% → 45.28% execution coverage, with suite failures (Section 6).                                                                             |
| **`tinyconfig` Initial Pruning (Section 8)**  | 149,102 lines               | 6,901,768 B (6.58 MiB)    | yes (build+exploration) | Removed VT/input/HID infrastructure and extra codecs; 49.16% final execution coverage, with suite failures.                                                               |
| **`tinyconfig` + Research Profile Synthesis** | **~118,500 lines (target)** | **~2.1 MiB (target)**     | **no — next iteration** | **Ultra-minimal profile (Section 9.1):** replaces multi-table CRCs, disables unneeded POSIX IPC/APIs, removes compaction/swap. Build, boot, and re-measure before citing. |

_Note: the uninstrumented tinyconfig baseline is 124,938 DWARF SLOC
([Hello Init Section 7.2](./HelloInit.md#72-build--sizing-iteration-record-v73-rc5-arm64)).
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
- [AI Testing Steering Notes](./TestingSteeringNotes.md) — reviewer and agent validation steering notes.
- [Kernel Config Analysis](./KernelConfigAnalysis.md) — historical reference minimal configurations and SLOC comparisons.
- [Kernel Complexity](./KernelComplexity.md) — defining and measuring build-time and runtime complexity.
- [Certification Progression](./CertificationProgression.md) — assurance level progression (DO-178C, DO-297, AMC 20-193).
