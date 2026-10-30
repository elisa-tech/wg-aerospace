<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Steering Notes for Testing the Minimal-Linux Walkthroughs

This is the test-steering guide for the minimal-Linux practice material: it
tells a reviewer or an automated agent how to re-run and validate the measured
claims in [Hello Init (Practice)](./HelloInit.md), its
[Maximizing Kernel Coverage](./MaxCoverageMultiSuite.md) worked example, and the
parent [Software Minimization](../SoftwareMinimization.md) document. It is not a
new experiment — it is the checklist that keeps those experiments honest and
reproducible.

## Walkthrough Progression & Dependency Roadmap

| Stage                  | Document                                                                                                                                                                     | Purpose & Scope                                                                        | Key Prerequisite                                   | Evidence                                            |
| :--------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------- | :------------------------------------------------- | :-------------------------------------------------- |
| **1. Practice**        | [Hello Init](./HelloInit.md)                                                                                                                                                 | Static binary PID 1 baseline, bottom-up/top-down builds, KCOV reachability, SLOC       | Cross-compiler, QEMU `virt`, `scripts/kernel-sloc` | Boot serial log, `linked.json`, `kcov-lines.txt`    |
| **2. Flight Workload** | [Hello cFS](./HelloCFS.md)                                                                                                                                                   | NASA cFS & OSAL PID 1 boot, OSAL feature probes, task-scoped KCOV                      | cFS build toolchain, OSAL probe binaries, QEMU     | cFS housekeeping log, probe results, cFS KCOV trace |
| **3. Multi-Suite**     | [Maximizing Coverage](./MaxCoverageMultiSuite.md)                                                                                                                            | Whole-kernel GCOV profiling across test suites (stress-ng, Syzkaller) and pruning      | Go 1.26+, autotools, Alpine minirootfs, gcov       | Checkpoint GCOV JSON, diff tables, pruned `.config` |
| **Context**            | [Minimization](../SoftwareMinimization.md)<br>[Analysis](./KernelConfigAnalysis.md)<br>[Complexity](./KernelComplexity.md)<br>[Certification](./CertificationProgression.md) | DO-178C framing, historical benchmarking, complexity metrics, and assurance references | Conceptual review & standards context              | Safety-case rationales & boundary definitions       |

## Key Drivers Behind the Upstream Docs and Scripts

The upstream kernel documentation ([Kernel Minimization Guide (Draft PR)](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html), `Documentation/admin-guide/kernel-minimization.rst`)
and supporting tools (`scripts/kernel-sloc`) were developed under the ELISA Aerospace
Working Group's initiative to upstream a generic, reproducible kernel minimization
methodology. Key architectural and assurance drivers behind these artifacts:

- **Filling an Upstream Documentation Gap:** Existing upstream guides
  (such as [Quickly build trimmed Linux](https://www.kernel.org/doc/html/latest/admin-guide/quickly-build-trimmed-linux.html), `Documentation/admin-guide/quickly-build-trimmed-linux.rst`) focus
  exclusively on native host builds using `localmodconfig`. There was no upstream
  guidance for trimming a kernel for a single embedded workload, running directly
  as PID 1 (no init system or multi-user shell), cross-compiling for QEMU (`ARCH=arm64`),
  and enforcing a strict monolithic kernel build (`CONFIG_MODULES=n`).
- **Separation of Concerns (Upstream Mechanics vs. Aerospace Assurance):**
  - _Upstream Scope (`kernel-minimization.rst`):_ Focuses purely on general
    software engineering mechanics — top-down vs. bottom-up Kconfig trimming,
    user-space feature probing (`ainit.c`, `ainit-net.c`), and build measurement.
  - _Aerospace Scope (`SoftwareMinimization.md`):_ Addresses airworthiness and
    safety standards (DO-178C, DO-297, AMC 20-193), explaining why minimization
    reduces review surface, why unobserved execution in a trace is not dead-code
    proof, and how to apply the Change → Build → Test → Measure → Record loop.
- **Standardizing Precise Metrics Tooling (`scripts/kernel-sloc`):** Replaces ad-hoc
  whole-tree `cloc *` estimates and binary size guesses with two reproducible metrics:
  - _DWARF Linked SLOC (`dwarf vmlinux`):_ Resolves DWARF line-table addresses to
    unique `file:line` pairs present in the final linked `vmlinux` ELF.
  - _Compiled Source SLOC (`kernel .`):_ Uses `compile_commands.json` to count code
    lines strictly across files actually compiled into that build.
- **Grounding Runtime Coverage Mechanics (KCOV & GCOV):**
  - Integrates task-scoped runtime coverage collection via KCOV
    ([Linux Kernel KCOV Support](https://www.kernel.org/doc/html/latest/dev-tools/kcov.html), `Documentation/dev-tools/kcov.rst`) to bound, capture, and symbolize
    in-kernel execution for individual syscalls (e.g. `read()` or `socket()`).
  - Differentiates task-scoped call reachability (KCOV) from whole-kernel structural
    coverage across boot, daemons, and interrupts (GCOV).

## 1. How to use these notes

- **Pre-flight toolchain check.** Before starting, verify the basic devcontainer dependencies:
  ```sh
  for cmd in aarch64-linux-gnu-gcc qemu-system-aarch64 cloc cpio python3 make; do
      printf "%-25s: " "$cmd"; command -v "$cmd" || echo MISSING
  done
  ```
- Treat every table in [Hello Init (Practice)](./HelloInit.md) and [the Maximizing Kernel Coverage example](./MaxCoverageMultiSuite.md)
  as a claim to be re-derived, not trusted. Each claim has a build recipe and a
  measurement command in the referenced document; re-run them rather than reusing
  published numbers.
- Use the **ELISA AeroWG devcontainer** for the workflow. Its package versions
  are not pinned, so verify the
  [Provenance Anchor](./HelloInit.md#71-experiment-artifacts--provenance-anchor)
  before applying exact targets; a different toolchain needs new measurements.
- Acquire the pinned draft source or its checksum-verified `scripts/kernel-sloc`
  helper using [Hello Init Section 3](./HelloInit.md#3-get-the-kernel-sources).
  The `v7.3-rc5` release checkout alone lacks the helper.
- **Monitor disk across builds.** Each clean kernel build adds a few GB; the
  `defconfig` and GCOV builds are the largest. Run `make clean` between
  configurations and `df -h .` after each build.
- **Isolate each test run in its own build tree — never share one kernel tree
  between concurrent runs.** The kernel build is stateful: `.config`, the
  generated headers under `include/generated/` (for example `autoconf.h`), and
  the `.cmd`/`.o` dependency files are all rewritten in place by `make
olddefconfig` and `make clean`. If two runs (two reviewers, two agents, or a
  foreground run plus a background one) build in the same directory at the same
  time, they corrupt each other's generated state and produce _phantom_ compile
  errors that are not real source defects — the classic signatures are
  `struct task_struct has no member named 'io_uring'`, `unknown type name
'proc_write_t'`, `undefined symbol 'jiffies_64'`, or a vanished `.config`.
  These are collision artifacts, not findings; do not record them as failures.
  Give each run a dedicated, non-conflicting working directory, e.g. export a
  pristine snapshot into a temporary run directory stemming from the current
  folder:

  ```sh
  # one independent tree per run; no shared .git, no shared build state
  RUN_DIR="./tmp/minrun-$$"
  mkdir -p "$RUN_DIR/linux"
  git -C /path/to/linux archive --format=tar HEAD \
      | tar -x -C "$RUN_DIR/linux"
  cd "$RUN_DIR/linux"   # run every make/scripts/config here
  ```

  A separate `git worktree` isolates working files, but each run still needs
  exclusive ownership of its build directory. `git clean` affects its targeted
  worktree, not sibling worktrees. Keep rootfs images and reports under the same
  per-run directory.

- Record cores and wall-clock time for every run, per
  [Section 10](./MaxCoverageMultiSuite.md#10-measurement-environment-core-count--timing-record).

## 2. Validating the Hello Init body sections

All "Section N" references in this table are sections of [Hello Init (Practice)](./HelloInit.md).

| Claim to validate       | How to reproduce                                             | Pass criterion in the recorded environment                                                                              |
| ----------------------- | ------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------- |
| 7.2 Step 0 `tinyconfig` | Section 3 (`Dockerfile.step0-tinyconfig`)                    | DWARF `124,938`, compiled `352,672` (600 files), raw `Image` `3,223,560` B; boots to `hello world`                      |
| 7.2 Step 1 `+NET+INET`  | Section 4 (`Dockerfile.step1-net`)                           | DWARF `197,490`, compiled `527,040` (784 files); `NET-PROBE: IPv4/UDP socket available`                                 |
| 7.2 Step 2 `+KCOV`      | Section 5 (`Dockerfile.step2-kcov`)                          | DWARF `209,321`, compiled `527,040` (784 files); KCOV instrumented binary                                               |
| 7.2 Step 3 `defconfig`  | Section 6 (`Dockerfile.step3-defconfig`)                     | DWARF `2,070,838`, compiled `5,722,530` (9,157 files), raw `Image` `110,991,872` B; boots with `-m 512M`               |
| 7.3 user space          | Section 3.3 / 4.3 / 5.3 / 6.3 user space sizing              | Step 0: `ainit` 10 SLOC / 634,000 B; Step 1: `ainit-net` 22 SLOC; Steps 2 & 3: `ainit-net-kcov` 73 SLOC / 704,704 B     |
| 7.4.1 `socket()` KCOV   | Section 5 (`Dockerfile.step2-kcov` normalization)            | ~276 source lines; ~268 captured / 252 distinct PCs; instrumented DWARF 209,321                                         |
| 7.4.2 `socket()` KCOV   | Section 6 (`Dockerfile.step3-defconfig` normalization)       | ~318 source lines; ~278 captured / 259 distinct PCs; instrumented DWARF 2,070,838; namespace and security paths present |

> **Known-benign variance.** Compressed `Image.gz` sizes and `*.cpio.gz` archive
> sizes vary with timestamps and archive/build metadata. Compare the raw
> `Image` and SLOC only when the recorded versions and debug policy match.
>
> **Approximate rows are shape checks, not exact matches.** The `7.4.0 read()`
> row (`21` PCs / `27` normalized lines) and the per-step DWARF/compiled SLOC,
> file counts, and raw `Image` bytes are exact for the recorded environment.
> The old `29` read count included discriminator variants; do not use it as
> a unique-source-line target. The `socket()`
> KCOV totals in `7.4.1`/`7.4.2` are marked `~` because `socket()` crosses
> allocation, refcount, and (on `defconfig`) LSM/namespace paths whose exact
> PC/line totals shift a few percent with toolchain and build details. Validate
> them by **per-subsystem shape** — the named files and their normalized line
> counts (`net/socket.c`, `net/core/sock.c`, `net/ipv4/af_inet.c`, `udp.c`, the
> VFS `file*/dcache/inode` group, `arch/arm64/kernel/syscall.c`, and the
> `fs/ioctl.c` `KCOV_DISABLE` window). Compare captured PCs, distinct PCs, and
> source lines separately. Totals within roughly ±10% that preserve the required
> subsystem paths are a pass. Use the instrumented `vmlinux` denominator.

## 3. Validating the Hello cFS flight scenario (`HelloCFS.md`)

All "Section N" references in this table are sections of [Hello cFS](./HelloCFS.md).

| Claim / Scenario to validate    | How to reproduce                                                                   | Pass criterion in the recorded environment                                                                                   |
| :------------------------------ | :--------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------- |
| **1. PID 1 cFS Workload Boot**  | Section "PID 1 cFS Workload Boot" recipe under QEMU                                | Boots `core-cfs` as PID 1, initializes CFE Core and OSAL, enters steady housekeeping loop without init panic                 |
| **2. Feature Probing**          | Build and execute `cfs-probe-net`, `cfs-probe-ipc`, and `cfs-probe-timer` as PID 1 | Probe binaries report feature availability (IPv4/UDP socket, POSIX mqueue, monotonic timer precision) or graceful error code |
| **3. Sizing & SLOC Accounting** | Section "Metrics" commands using `scripts/kernel-sloc` and `cloc`                  | Produces `linked.json` DWARF SLOC, `compiled.json` whole-file SLOC, and user-space source/stripped binary footprints         |
| **4. KCOV Reachability**        | Section "Runtime Coverage Collection (KCOV)" with `normalize_kcov.py`              | Deduplicated `(file, line)` counts and coverage percentage computed against instrumented `vmlinux` DWARF SLOC                |

> **Validation Context.** [Hello cFS](./HelloCFS.md) applies the exact Change →
> Build → Test → Measure → Record discipline established in
> [Hello Init](./HelloInit.md) to the NASA Core Flight System flight stack.
> Reviewers should verify that cFS-specific configuration deltas (such as POSIX
> timers, message queues, and socket options) are validated against isolated OSAL
> probes before full application integration.

## 4. Validating the Maximizing-Kernel-Coverage example

All "Section N" references in this subsection are sections of
[Maximizing Kernel Coverage](./MaxCoverageMultiSuite.md).

Reproduce in order: [Section 3](./MaxCoverageMultiSuite.md#3-kernel-profiling-configuration) build →
[Section 4](./MaxCoverageMultiSuite.md#4-rootfs-assembly--sequential-multi-stage-execution-workflow) rootfs/boot →
[Section 5](./MaxCoverageMultiSuite.md#5-host-side-checkpoint-extraction--differential-analysis) reconstruct →
tables [Section 6](./MaxCoverageMultiSuite.md#6-measured-multi-stage-progression--differential-table-tinyconfig)/[Section 7](./MaxCoverageMultiSuite.md#7-identifying-uncovered-built-areas--pruning-candidates)/[Section 8](./MaxCoverageMultiSuite.md#8-iterative-kconfig-pruning--post-minimization-coverage-impact).

> **This example is part of a full validation pass — do not skip it.** A review
> that only re-runs [Hello Init](./HelloInit.md) has **not** validated the
> walkthrough set. The Maximizing Kernel Coverage example is a separate, heavier
> run and must be exercised too, in its **own isolated build tree**
> ([Section 1](#1-how-to-use-these-notes)) so it never shares kernel state with a
> concurrent Hello Init run. Before starting it, confirm the extra prerequisites
> that Hello Init does not need: **Go 1.26.0 or newer** for the pinned real
> `syz-prog2c`, host **autotools** (`aclocal`/`autoconf`/`automake`/`m4`/
> `pkg-config`),
> network access to the Alpine CDN and GitHub for the rootfs and Syzkaller
> sources, Python 3.12 or newer for archive extraction, and
> `wget`/`base64`/`tar`/`aarch64-linux-gnu-gcov`. Keep the guest
> **single-core at `-m 1024M`** for the NET-less baseline. Allow a few GB of disk for
> each GCOV build.

Watch for these verified failure modes (each is called out at its step):

- **Self-tests silently dropped.** After the Section 3 `olddefconfig`, confirm
  `RUNTIME_TESTING_MENU=y`, `KUNIT=y`, and the `TEST_*`/`ATOMIC64_SELFTEST`
  symbols survived. If they are `undef`, Stage 0 coverage collapses.
- **Workload prerequisites dropped.** Verify `POSIX_TIMERS=y`, `SHMEM=y`,
  `MEMFD_CREATE=y`, and `ADVISE_SYSCALLS=y`. Without timers, stress-ng's alarm
  cannot bound stressors. `MEMFD_CREATE` enables the syscall, `SHMEM` supplies
  its backing, and `ADVISE_SYSCALLS` enables advice calls.
- **Wrong Syzkaller target or hidden syscall failures.** Generate with
  `-os linux -arch arm64 -trace`. Inspect the emitted per-call errno values;
  process exit zero alone does not prove the intended syscalls worked.
- **`tc` missing (optional networking extension only).** The NET-less baseline
  has no Netlink/tc stage. If you add the optional networking extension
  (Section 3), confirm `/sbin/tc` exists in the rootfs (needs the `iproute2-tc`
  package, which `iproute2-minimal` does not provide); otherwise its `tc qdisc`
  commands do nothing.
- **Missing or mismatched GCOV counters.** Place each `.gcda` next to its
  matching `.gcno` and run gcov from the kernel tree root. Verify the runtime
  unit inventory and executable denominator agree across all checkpoints.
- **Overwritten headers and partial counts.** Preserve each unit's gcov JSON
  output. Flattened text `.gcov` basenames discard shared-header data, and
  `c.isdigit()` ignores positive partial counts such as `1*`.
- **Incomplete suites reported as success.** Require all four valid checkpoint
  archives and review suite/skipped-test and syscall outcomes. A suite pass
  requires no failed self-test, `WATCHDOG`, `FAILED`, or `HARNESS INCOMPLETE`.
  The broad class exploration may export usable coverage despite suite failures;
  it does not establish acceptance.
- **`-d FUTEX_PI` is ignored.** It is auto-selected; drop `FUTEX`/`RT_MUTEXES`
  instead (Section 8).
- **Denominator ambiguity.** State whether a percentage uses a `.gcno`
  graph metric or the gcov JSON executable-source-line union
  (see [Measurement Denominators](./HelloInit.md#measurement-denominators--sloc-accounting)
  in Hello Init); they are not interchangeable.

> **Environment sensitivity.** The Maximizing Kernel Coverage example's magnitudes
> are reproducible _in method and shape_, but exact line counts depend on the
> single-core guest, the toolchain, and the payloads. Its active Section 4 stages are
> **stress-ng + a real `syz-prog2c` reproducer**. A live `syz-fuzzer` or a richer corpus moves the edge-case numbers. Always regenerate the tables
> for your own payload set rather than citing these values as acceptance targets.

## 5. Validating the Upstream Workload-Tracing Guide (`workload-tracing.rst`)

The upstream workload-tracing guide (`Documentation/admin-guide/workload-tracing.rst`)
provides runtime discovery mechanisms to inspect functions and syscalls exercised
by a target workload. To validate the sections under
[Kernel paths reached by the workload](https://matthew-l-weber.github.io/linux/admin-guide/workload-tracing.html#kernel-paths-reached-by-the-workload),
execute the following test scenarios:

### 5.1 Function Graph Tracing (`Kernel paths reached by the workload`)

Validates kernel execution paths using ftrace and `trace-cmd`:

1. **Verify tracer support:** Confirm the test kernel provides `CONFIG_FTRACE=y`,
   `CONFIG_FUNCTION_TRACER=y`, and `CONFIG_FUNCTION_GRAPH_TRACER=y`. Check with:
   ```sh
   sudo trace-cmd list -t
   ```
2. **Collect application trace:** Record a task-filtered graph for a target binary
   (e.g., `./ainit` or test application):
   ```sh
   sudo trace-cmd record -p function_graph -F -c -O nofuncgraph-irqs \
       --user "$USER" -o functions.dat ./ainit
   trace-cmd report -i functions.dat > functions.txt
   ```
3. **Pass criterion:** `functions.txt` captures the nested function graph of the
   workload without dropped buffer events or interrupt interleaving.

### 5.2 Host-Side GDB Stub Tracing (`Tracing a minimal user space`)

Validates non-intrusive syscall trapping for minimal PID 1 binaries under QEMU:

1. **Launch QEMU with GDB stub:** Boot the debug `vmlinux` with `nokaslr` and
   paused on start:
   ```sh
   qemu-system-aarch64 -machine virt -cpu cortex-a57 -nographic \
       -kernel arch/arm64/boot/Image -initrd initramfs.cpio.gz \
       -append 'console=ttyAMA0 nokaslr' -S -gdb tcp:127.0.0.1:1234
   ```
2. **Trap syscall entry in GDB:** Connect `gdb-multiarch` and set breakpoints on
   `kernel_init` and `do_el0_svc` to log syscall register numbers:
   ```sh
   gdb-multiarch vmlinux \
       -ex "target remote localhost:1234" \
       -ex "tbreak kernel_init" \
       -ex "continue" \
       -ex "set pagination off" \
       -ex "set logging file pid1-syscalls.log" \
       -ex "set logging enabled on" \
       -ex "break do_el0_svc" \
       -ex "commands" \
       -ex "silent" \
       -ex 'printf "syscall=%lu arg0=%#lx\n", regs->regs[8], regs->regs[0]' \
       -ex "continue" \
       -ex "end" \
       -ex "continue"
   ```
3. **Pass criterion:** `pid1-syscalls.log` records initial system calls invoked
   by PID 1 (e.g., `syscall=64` for `write`) without requiring user-space tooling.

### 5.3 Low-Level QEMU Instruction Tracing

1. **Enable QEMU execution logging:** Pass `-d in_asm -D qemu.log` to QEMU.
2. **Pass criterion:** `qemu.log` captures translated basic blocks for early boot
   and user-space execution.

## 6. Validating the parent document (`SoftwareMinimization.md`)

The parent [Software Minimization](../SoftwareMinimization.md) document is now
framing and navigation only — it carries the aerospace/assurance context, the
Change → Build → Test → Measure → Record discipline, the "How this maps to the
kernel.org draft guides" table, and links to the scenarios. It no longer carries
its own measured figures, so there are no numbers to revalidate against it. When
testing it, check structure and links rather than metrics:

- **No numeric cross-check.** The parent does not restate SLOC/image/coverage
  numbers; those live in the scenario documents. If a future edit reintroduces
  figures into the parent, add a numeric check here and confirm they match the
  scenario they came from (and label any orientation-only figures as
  non-authoritative, noting the kernel version they were taken on).
- **Mapping table integrity.** Confirm the "How this maps to the kernel.org draft
  guides" table still reflects the scenarios' actual behavior (PID 1 launch model,
  the change→build→test→measure→record loop, trace→prune→re-test,
  present-vs-observed coverage framing, consistent-scope SLOC/image metrics).
- **Link integrity (the main risk).** Verify every relative link resolves:
  the scenario pages (`./minimal-linux/HelloInit.md`, `HelloCFS.md`,
  `MaxCoverageMultiSuite.md`), this steering page
  (`./minimal-linux/TestingSteeringNotes.md`), the related-work pages, and the
  upstream draft URLs. Link rot, not numeric drift, is what breaks this page.

## 7. Determinism and anti-regression levers

- **Pin the inputs:** kernel tag/commit (Provenance Anchor), toolchain versions,
  Alpine `3.20.3` minirootfs and the pinned `stress-ng`/`iproute2` APK versions.
- **One variable at a time:** when a number moves, change only the config group or
  payload under test and keep `make clean` between builds so stale objects do not
  distort SLOC.
- **One build tree per run:** run each configuration in its own dedicated
  directory (see [Section 1](#1-how-to-use-these-notes)). Parallel runs that
  share a tree race on `.config` and `include/generated/`, yielding phantom
  build errors rather than real results. Isolation is what makes two runs (or
  two reviewers) reproducible against each other instead of interfering.
- **Single-core by default:** keep the guest at one vCPU (no `-smp`) for
  deterministic stage ordering; only add cores deliberately and re-record timing.
- **Capture evidence:** save serial logs, suite outcomes, checkpoint archives,
  `linked.json`/`compiled.json`, and per-unit gcov JSON directories so a reviewer
  can regenerate the tables.

## 8. Devcontainer provisioning for Syzkaller & Build Tooling

The example builds real Syzkaller tooling. The build prerequisites are installed in `demos/env/Dockerfile`:

- **Autotools & build utilities** (`autoconf`, `automake`, `autotools-dev`, `m4`, `pkg-config`).
- **Syzkaller** at the pinned commit needs Go 1.26.0 or newer. `golang-go`
  supplies a Go installation, but its package version depends on the image.

If you are running in an older image that predates these additions, install them
for the session (the devcontainer user has passwordless `sudo`):

```sh
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    autoconf automake autotools-dev m4 pkg-config golang-go
```

Verify before building the suites:

```sh
for t in aclocal autoconf automake autoreconf m4 pkg-config go; do
    printf '%s: ' "$t"; command -v "$t" || echo MISSING
done
# Run in the pinned Syzkaller checkout to show its selected Go toolchain.
go version
go env GOTOOLCHAIN
```

With `GOTOOLCHAIN=auto`, a supported older Go installation can download the
version required by `go.mod`. This needs network access to Go's toolchain and
module endpoints. Otherwise install the required version before `make prog2c`.
Record `go version` from inside the pinned module.

Earlier handwritten or Go-free Syzkaller stand-ins do not validate the real
suites. Use Go for the active reproducer; tool
provisioning alone does not establish that a suite executed or passed.
