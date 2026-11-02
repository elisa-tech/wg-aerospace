<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->
<!-- markdownlint-disable MD013 -->

# Steering Notes for Testing the Minimal-Linux Walkthroughs

This is the test-steering guide for the minimal-Linux practice material: it
tells a reviewer or an automated agent how to re-run and validate the measured
claims in [Hello Init (Practice)](./HelloInit.md), the
[Hello cFS](./HelloCFS.md) scaffold, the
[Maximizing Kernel Coverage](./MaxCoverageMultiSuite.md) worked example, and the
parent [Software Minimization](../SoftwareMinimization.md) document. It is not a
new experiment — it is the checklist that keeps those experiments honest and
reproducible.

## Walkthrough Progression & Dependency Roadmap

| Stage                  | Document                                                                                                                                                                     | Purpose & Scope                                                                                                                    | Key Prerequisite                                                                                | Evidence                                                                                          |
| :--------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------ |
| **1. Practice**        | [Hello Init](./HelloInit.md)                                                                                                                                                 | Static PID 1 baseline, bottom-up (`tinyconfig`) and top-down (`defconfig`) builds, KCOV reachability, SLOC, GDB-stub syscall trace | Docker with BuildKit; the step images supply the cross-compiler, QEMU `virt`, and `kernel-sloc` | `metrics.txt`, boot console, `linked.json`/`compiled.json`, `kcov-lines.txt`, `pid1-syscalls.log` |
| **2. Flight Workload** | [Hello cFS](./HelloCFS.md)                                                                                                                                                   | cFS PID 1 scaffold: kernel options for POSIX timers, message queues, and IPv4/UDP; observation tables still to be recorded         | Docker; the real cFS build is not wired in yet                                                  | `metrics.txt`, boot console                                                                       |
| **3. Multi-Suite**     | [Maximizing Coverage](./MaxCoverageMultiSuite.md)                                                                                                                            | Whole-kernel GCOV profiling across test suites (stress-ng, Syzkaller) and pruning                                                  | Devcontainer: Go 1.26+, autotools, Alpine minirootfs, gcov                                      | Checkpoint GCOV JSON, diff tables, pruned `.config`                                               |
| **Context**            | [Minimization](../SoftwareMinimization.md)<br>[Analysis](./KernelConfigAnalysis.md)<br>[Complexity](./KernelComplexity.md)<br>[Certification](./CertificationProgression.md) | DO-178C framing, historical benchmarking, complexity metrics, and assurance references                                             | Conceptual review & standards context                                                           | Safety-case rationales & boundary definitions                                                     |

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
    software engineering mechanics — top-down (`defconfig`) and bottom-up
    (`tinyconfig`) Kconfig trimming, a minimal PID 1 workload (`hello_init.c`),
    and build measurement. The feature probes (`ainit-net.c`,
    `ainit-net-kcov.c`) live in the AeroWG walkthroughs, not upstream.
  - _Aerospace Scope (`SoftwareMinimization.md`):_ Addresses airworthiness and
    safety standards (DO-178C, DO-297, AMC 20-193), explaining why minimization
    reduces review surface, why unobserved execution in a trace is not dead-code
    proof, and how to apply the Change → Build → Test → Measure → Record loop.
- **Standardizing Precise Metrics Tooling (`scripts/kernel-sloc`):** Replaces ad-hoc
  whole-tree `cloc *` estimates and binary size guesses with two reproducible metrics:
  - _DWARF Linked SLOC (`dwarf vmlinux`):_ Resolves DWARF line-table addresses to
    unique `file:line` pairs present in the final linked `vmlinux` ELF.
  - _Compiled Source SLOC (`kernel .`):_ Counts code lines in the whole source
    files that `compile_commands.json` lists for that build. Included headers
    are not followed.
- **Grounding Runtime Coverage Mechanics (KCOV & GCOV):**
  - Integrates task-scoped runtime coverage collection via KCOV
    ([Linux Kernel KCOV Support](https://www.kernel.org/doc/html/latest/dev-tools/kcov.html), `Documentation/dev-tools/kcov.rst`) to bound, capture, and symbolize
    in-kernel execution for individual syscalls (e.g. `read()` or `socket()`).
  - Differentiates task-scoped call reachability (KCOV) from whole-kernel structural
    coverage across boot, daemons, and interrupts (GCOV).

## 1. How to use these notes

- **Pre-flight check.** Hello Init and Hello cFS run entirely in Docker. Check
  the Docker client and server, BuildKit, and free space where Docker stores
  its data:

  ```sh
  docker version --format 'client {{.Client.Version}}, server {{.Server.Version}}'
  docker buildx version
  df -h "$(docker info --format '{{.DockerRootDir}}')" .
  ```

  The Maximizing Kernel Coverage example builds on the host or in the
  devcontainer instead. Check its toolchain there:

  ```sh
  for cmd in aarch64-linux-gnu-gcc qemu-system-aarch64 cloc cpio python3 make; do
      printf "%-25s: " "$cmd"; command -v "$cmd" || echo MISSING
  done
  ```

- Treat every table in [Hello Init (Practice)](./HelloInit.md) and [the Maximizing Kernel Coverage example](./MaxCoverageMultiSuite.md)
  as a claim to be re-derived, not trusted. Each claim has a build recipe and a
  measurement command in the referenced document; re-run them rather than reusing
  published numbers.
- **Environment.** Hello Init and Hello cFS do not need the devcontainer: their
  Dockerfiles install the toolchain on `ubuntu:24.04`. That tag and its
  packages are not pinned, so record the base image digest and tool versions
  (`docker run --rm --entrypoint sh <image> -c 'aarch64-linux-gnu-gcc --version; qemu-system-aarch64 --version'`)
  and compare them with the
  [Provenance Anchor](./HelloInit.md#71-experiment-artifacts-and-provenance-anchor)
  before treating a number as an exact target. A different toolchain needs new
  measurements. The Maximizing Kernel Coverage example uses the ELISA AeroWG
  devcontainer ([Section 8](#8-devcontainer-provisioning-for-syzkaller--build-tooling)).
- **SLOC helper.** The `v7.3-rc5` release tree does not contain
  `scripts/kernel-sloc`. The step Dockerfiles download it from a pinned commit
  and verify its SHA-256 (`SLOC_HELPER_URL` and `SLOC_HELPER_SHA256` build
  arguments). If the pinned URL stops resolving, pass both arguments for a
  reviewed copy rather than dropping the checksum.
- **Watch disk space where Docker and the builds write.** On 2026-10-31, one
  `--no-cache` pass of the five Hello Init images added about 13 GB under
  Docker's data root: the Step 3 image is 6.4 GB (its kernel build layer is
  3.4 GB) and each other image is 3.1–3.4 GB. Repeated `--no-cache` rebuilds
  also grow the BuildKit cache. Check the filesystem that holds Docker's data
  root and your build output before each pass:

  ```sh
  df -h "$(docker info --format '{{.DockerRootDir}}')" .
  ```

  **On WSL 2**, `df` inside Linux reports the size of the distribution's
  virtual disk (a VHDX file, 1 TB by default), not the free space on the
  Windows drive that holds that file. Check that drive too, for example
  `df -h /mnt/c`. When the Windows drive fills, the VHDX cannot grow: ext4
  hits I/O errors and remounts read-only (`read-only file system` from
  `docker build`), and WSL can then fail with `getpwnam(...) failed 5` and
  `SIGBUS` until it is restarted. This happened during the 2026-10-31
  validation pass. Keep Docker's data root (`"data-root"` in
  `/etc/docker/daemon.json`) and large build trees on a disk with room, or
  move the distribution with `wsl --manage <distro> --move <path>`.

  For host builds, each clean kernel build adds a few GB; run `make clean`
  between configurations and `df -h .` after each build. Remove validation
  images when you are done (`docker rmi helloinit-step0 ...`).
  `docker builder prune` and `docker system prune` remove cache and objects for
  every build on the host, so ask before running them on a shared machine.

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

  The step Dockerfiles build each kernel inside its own image, so separate
  `docker build` runs do not collide; BuildKit runs identical steps once and
  shares the result. The risk applies to host builds and to a host tree
  bind-mounted over `/workspace/linux`: do not point two containers or host
  builds at the same mounted tree at once, and pass
  `--user "$(id -u):$(id -g)"` so the container does not leave root-owned
  files in it. For host builds, give each run a dedicated directory, e.g.
  export a pristine snapshot:

  ```sh
  # one independent tree per run; no shared .git, no shared build state
  RUN_DIR="../minrun-$$"
  mkdir -p "$RUN_DIR/linux"
  git -C /path/to/linux archive --format=tar HEAD \
      | tar -x -C "$RUN_DIR/linux"
  cd "$RUN_DIR/linux"   # run every make/scripts/config here
  ```

  A separate `git worktree` isolates working files, but each run still needs
  exclusive ownership of its build directory. `git clean` affects its targeted
  worktree, not sibling worktrees. Keep rootfs images and reports under the same
  per-run directory.

- **Run super-linter on a throwaway clone.** This repository's super-linter
  settings enable `FIX_*` modes (clang-format, black, shfmt, prettier) that
  rewrite files in the mounted tree, and the container runs as `root`.
  Pointing it at a working tree rewrites files and leaves them owned by
  `root`. Commit first, clone to a scratch directory, and load the
  environment the way `.github/workflows/lint.yml` does, with the same pinned
  version:

  ```sh
  git clone --quiet --no-hardlinks . ../lint-scratch
  git -C ../lint-scratch checkout --quiet --detach
  git -C ../lint-scratch branch -f main "$(git merge-base origin/main HEAD)"
  grep -v '^#' .github/super-linter.env > ../lint.env
  docker run --rm -e RUN_LOCAL=true --env-file ../lint.env \
      -v "$(cd ../lint-scratch && pwd)":/tmp/lint \
      ghcr.io/super-linter/super-linter:v8.7.0
  ```

  Setting `main` to the merge base gives the same changed-file set as the
  pull-request run in CI. Files that fix mode rewrote in the clone are owned
  by `root`; remove the clone with
  `docker run --rm -v "$(cd .. && pwd)":/w ubuntu:24.04 rm -rf /w/lint-scratch`.

- Record cores and wall-clock time for every run, per
  [Section 10](./MaxCoverageMultiSuite.md#10-measurement-environment-core-count--timing-record).

### 1.1 Running the Hello Init sequence (resumable)

Run from the repository root. Each step writes its own log and a status line,
so an interrupted pass resumes at the first step without `exit=0`. The run
directory sits outside the repository so it never shows up as untracked files:

```sh
RUN=../hello-init-run
mkdir -p "$RUN"
for pair in step0-tinyconfig:helloinit-step0 step1-net:helloinit-step1 \
            step2-kcov:helloinit-step2 gdb-stub-tracing:helloinit-gdb \
            step3-defconfig:helloinit-step3; do
    s=${pair%%:*}
    tag=${pair#*:}
    grep -q "^$s exit=0" "$RUN/status.txt" 2>/dev/null && continue   # done already
    start=$(date +%s)
    docker build --no-cache --progress=plain \
        -f "docs/minimal-linux/hello-init/Dockerfile.$s" -t "$tag" . > "$RUN/$s.log" 2>&1
    echo "$s exit=$? secs=$(( $(date +%s) - start ))" >> "$RUN/status.txt"
done
cat "$RUN/status.txt"
```

`--no-cache` makes the pass a real rebuild: each step installs its packages,
clones the kernel, and compiles again. Without it, BuildKit reuses cached
layers and a rerun proves little. Reference timings from 2026-10-31 on 22
cores, with Step 3 built in parallel with the others: Step 0 330 s, Step 1
282 s, Step 2 336 s, GDB trace 453 s, Step 3 1,754 s.

If the host failed mid-pass, first confirm that the filesystem is writable and
has room (`touch "$RUN/probe"`, `df -h`). An interrupted build leaves no
partial image, so rerunning the loop rebuilds only the failed and missing
steps.

Collect the evidence for [Section 2](#2-validating-the-hello-init-body-sections):

```sh
for tag in helloinit-step0 helloinit-step1 helloinit-step2 helloinit-step3 helloinit-gdb; do
    docker run --rm "$tag" cat /workspace/metrics.txt > "$RUN/metrics-$tag.txt"
done
# The Step 0 and Step 1 images boot QEMU as their command; no TTY is needed.
for tag in helloinit-step0 helloinit-step1; do
    docker run -d --name "boot-$tag" "$tag" > /dev/null
    sleep 30
    docker logs "boot-$tag" > "$RUN/boot-$tag.log" 2>&1
    docker rm -f "boot-$tag" > /dev/null
done
grep -a -h -E 'Linux version|Run /init|hello world|NET-PROBE' "$RUN"/boot-*.log
docker run --rm helloinit-gdb > "$RUN/pid1-syscalls.log"
```

The Step 2 and Step 3 images capture KCOV while the image builds. To repeat a
capture without rebuilding (for example, after a capture on a busy host), use
`-icount shift=4` for deterministic guest timing. The capture is slower in this
mode; for Step 3, add `-m 512M` and raise the timeout to 60 s:

```sh
docker run --rm --entrypoint sh helloinit-step2 -c '
cd /workspace &&
timeout 40s qemu-system-aarch64 -machine virt -cpu cortex-a57 -nographic -icount shift=4 \
    -kernel linux/arch/arm64/boot/Image -initrd initramfs-kcov.cpio.gz \
    -append "console=ttyAMA0 nokaslr" > /tmp/kcov.log 2>&1
tr -d "\r" < /tmp/kcov.log | grep -E "^0x[0-9a-f]+$" > /tmp/pcs.txt
aarch64-linux-gnu-addr2line -f -i -e linux/vmlinux < /tmp/pcs.txt > /tmp/symbols.txt
python3 scripts/normalize_kcov.py /tmp/symbols.txt /tmp/lines.txt
echo "captured=$(wc -l < /tmp/pcs.txt) distinct=$(sort -u /tmp/pcs.txt | wc -l)"'
```

## 2. Validating the Hello Init body sections

All "Section N" references in this table are sections of [Hello Init (Practice)](./HelloInit.md).

| Claim to validate       | How to reproduce                            | Pass criterion in the recorded environment                                                                                                                                                                                                        |
| ----------------------- | ------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 7.2 Step 0 `tinyconfig` | Section 3 (`Dockerfile.step0-tinyconfig`)   | DWARF `124,938`, compiled `352,672` (600 files), raw `Image` `3,223,560` B; boot shows `Linux version 7.3.0-rc5` and `hello world` with no panic                                                                                                  |
| 7.2 Step 1 `+NET+INET`  | Section 4 (`Dockerfile.step1-net`)          | DWARF `197,490`, compiled `527,040` (784 files), raw `Image` `4,495,368` B; `NET-PROBE: IPv4/UDP socket available`                                                                                                                                |
| 7.2 Step 2 `+KCOV`      | Section 5 (`Dockerfile.step2-kcov`)         | DWARF `209,321` (instrumented), compiled `533,116` (789 files), raw `Image` `5,552,136` B; the build fails unless the probe line and KCOV PCs appear                                                                                              |
| 7.2 Step 3 `defconfig`  | Section 6 (`Dockerfile.step3-defconfig`)    | DWARF `2,070,838`, compiled `5,722,530` (9,158 files), raw `Image` `110,991,872` B; `.config` has no `=m` entries; KCOV capture inside the 30 s window at `-m 512M`                                                                               |
| 7.3 user space          | Sections 3.3, 4.3, 5.3, 6.3 (`metrics.txt`) | `ainit` 9 SLOC / 634,000 B; `ainit-net` 21 SLOC / 634,984 B; `ainit-net-kcov` 81 SLOC / 704,704 B (stripped 597,944 B)                                                                                                                            |
| 7.4.1 `socket()` KCOV   | Section 5 (`Dockerfile.step2-kcov`)         | 276 normalized lines; 268 captured / 252 distinct PCs; per file: `net/socket.c` 32, `af_inet.c` 20, `sock.c` 24, `file_table.c`+`file.c` 51, `dcache.c`+`inode.c` 37, `syscall.c` 10, `udp.c` 4, other 98                                         |
| 7.4.2 `socket()` KCOV   | Section 6 (`Dockerfile.step3-defconfig`)    | 318 normalized lines; 278 captured / 259 distinct PCs; per file: `net/socket.c` 31, VFS group 93, `sock.c`+`af_inet.c` 48, `user_namespace.c`+`security.c` 28, `syscall.c` 9, `udp.c` 3, other 106 (including `fs/ioctl.c` 11 for `KCOV_DISABLE`) |
| Appendix 2 GDB trace    | Appendix 2 (`Dockerfile.gdb-stub-tracing`)  | The 16 entries listed in Appendix 2; `syscall=29` has request `0x5401` (`TCGETS`); the build fails without `syscall=64 arg0=0x1`                                                                                                                  |

> **Recorded rebuild (2026-10-31).** A `--no-cache` rebuild of all five images
> (base `ubuntu:24.04@sha256:fe81560990fa…`, GCC `13.3.0-6ubuntu2~24.04.1`,
> QEMU `8.2.2+ds-0ubuntu1.18`) reproduced every exact value in this table.
>
> **Source formatting changes the user-space SLOC.** super-linter's clang-format
> fix joins each `main` opening brace onto the signature line, which lowers each
> `cloc` count by one (10/22/82 before, 9/21/81 after) without changing the
> compiled binaries. Re-measure after reformatting the sources.
>
> **Known-benign variance.** Compressed `Image.gz` and `*.cpio.gz` sizes vary by
> a few bytes between rebuilds of the same sources (observed: 1 B on
> `Image.gz`, 3 B on the Step 1 archive) because the archives embed timestamps.
> Compare raw `Image` sizes and SLOC exactly when the recorded versions and
> debug policy match.
>
> **KCOV counts repeat exactly on a quiet host.** Four idle-host boots and two
> `-icount shift=4` boots of the Step 2 image gave identical PC lists (268
> captured, 252 distinct, 276 lines). Under heavy host load, guest timer
> interrupts inside the window added 8 PCs and 10 lines in `kernel/irq.c`,
> `kernel/time/sched_clock.c`, `arch/arm64/include/asm/arch_timer.h`, and
> `include/linux/seqlock.h`. If a build-time capture differs only in those
> files, repeat it on a quiet host or with `-icount`
> ([Section 1.1](#11-running-the-hello-init-sequence-resumable)) before
> recording. With a different toolchain or kernel, compare the per-file shape
> instead: totals within roughly ±10% that keep the listed subsystem paths are
> a pass. Use the instrumented `vmlinux` denominator.

## 3. Validating the Hello cFS scaffold (`HelloCFS.md`)

All "Section N" references in this section are sections of [Hello cFS](./HelloCFS.md).

Hello cFS is a scaffold. `hello-cfs/core-cfs.c` prints the expected cFS banner
and idles; it does not build or run cFS or OSAL yet (the Step 0 Dockerfile
carries the cFS build steps as comments only), and the observation tables in
Section 5 hold `_Record_` placeholders. Validate what exists:

| Claim / Scenario to validate | How to reproduce                                                      | Pass criterion                                                                            |
| :--------------------------- | :-------------------------------------------------------------------- | :---------------------------------------------------------------------------------------- |
| **3.1–3.2 Step 0 boot**      | Build `Dockerfile.step0-cfs-baseline`, then boot it as in Section 3.2 | Banner lines follow `Run /init as init process` and the guest idles without an init panic |
| **3.3 Step 0 metrics**       | `docker run --rm hellocfs-step0 cat /workspace/metrics.txt`           | Every row has a value, including DWARF and compiled SLOC                                  |
| **4.x Step 1 pruning**       | Build and boot `Dockerfile.step1-cfs-prune`                           | Same banner; metrics present                                                              |
| **5.2–5.4 tables**           | —                                                                     | Placeholders; nothing to compare until a real cFS workload and probes exist               |

> **Known gaps (checked against a 2026-10-30 `hellocfs-step0` image).** The
> kernel reports `7.3.0-rc5`, not the `7.3.0-rc5+` shown in Section 3.2. The
> Step 0 Dockerfile header mentions OSAL probe binaries that are not in the
> tree. Once the real cFS build lands, add exact pass criteria here, as for
> Hello Init.

## 4. Validating the Maximizing-Kernel-Coverage example

All "Section N" references in this subsection are sections of
[Maximizing Kernel Coverage](./MaxCoverageMultiSuite.md).

Two ways to run it:

- **Dockerized (preferred), matching the Hello Init step images.** Build and run
  the two step Dockerfiles; each one does the whole Section 3–8 pipeline and
  fails the build if a GCOV prerequisite is dropped, a stage checkpoint is
  missing, the unit inventory changes, or the denominator is zero:

  ```sh
  docker build -f docs/minimal-linux/max-coverage/Dockerfile.step0-gcov-baseline -t maxcov-step0 .
  docker run --rm maxcov-step0                       # coverage progression + metrics
  docker build -f docs/minimal-linux/max-coverage/Dockerfile.step1-gcov-pruned   -t maxcov-step1 .
  docker run --rm maxcov-step1
  ```

- **By hand**, for adapting the run: [Section 3](./MaxCoverageMultiSuite.md#3-kernel-profiling-configuration) build →
  [Section 4](./MaxCoverageMultiSuite.md#4-rootfs-assembly--sequential-multi-stage-execution-workflow) rootfs/boot →
  [Section 5](./MaxCoverageMultiSuite.md#5-host-side-checkpoint-extraction--differential-analysis) reconstruct →
  tables [Section 6](./MaxCoverageMultiSuite.md#6-measured-multi-stage-progression--differential-table-tinyconfig)/[Section 7](./MaxCoverageMultiSuite.md#7-identifying-uncovered-built-areas--pruning-candidates)/[Section 8](./MaxCoverageMultiSuite.md#8-iterative-kconfig-pruning--post-minimization-coverage-impact).

> **This example is part of a full validation pass — do not skip it.** A review
> that only re-runs [Hello Init](./HelloInit.md) has **not** validated the
> walkthrough set. The Maximizing Kernel Coverage example is a separate, heavier
> run and must be exercised too. Each step Dockerfile builds its kernel in its
> own image layers, so separate `docker build` runs never share kernel state
> ([Section 1](#1-how-to-use-these-notes)); a by-hand run needs its **own
> isolated build tree**. The step images install the extra prerequisites Hello
> Init does not need — **Go 1.26.0 or newer** for the pinned real `syz-prog2c`
> (via `golang-go` + `GOTOOLCHAIN=auto`), the Alpine rootfs and packages, and
> `aarch64-linux-gnu-gcov` — and keep the guest **single-core at `-m 1024M`**.
> For a by-hand run, provide those yourself. Each GCOV image is about 4.5 GB and
> the build boots QEMU for up to 20 minutes; watch disk per
> [Section 1](#1-how-to-use-these-notes).
>
> **Reproduced 2026-10-31 (Docker, fresh `--no-cache` step 0, cached-layer
> step 1).** Both images built and ran to completion. Step 0 reproduced the
> Section 6 baseline exactly: **164,992** DWARF SLOC, **7,596,040 B** `Image`,
> **205,463** denominator, **609** gcov units per stage, 32.65% → 45.31%. Step 1
> reproduced the Section 8 prune in direction and magnitude: **146,810** DWARF
> SLOC, **6,756,360 B** `Image`, **49.97%** final coverage (about 1.5–2% off the
> doc's 2026-10-18 pruned figures — within the stated toolchain/`olddefconfig`
> variance). Both reported `HARNESS INCOMPLETE` with all five stress-ng classes
> failing and Syzkaller succeeding.

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
  (see [Measurement Denominators](./HelloInit.md#measurement-denominators-and-sloc-accounting)
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

Validates kernel execution paths using ftrace and `trace-cmd`. Use a
tracing-capable test system or QEMU guest; the Hello Init kernels do not enable
ftrace.

1. **Verify tracer support:** Confirm the test kernel provides `CONFIG_FTRACE=y`,
   `CONFIG_FUNCTION_TRACER=y`, and `CONFIG_FUNCTION_GRAPH_TRACER=y`. Check with:

   ```sh
   sudo trace-cmd list -t
   ```

2. **Collect application trace:** Record a task-filtered graph for a native
   workload that exits, as in the upstream example (`./app`). `ainit` is not
   suitable here: it is built for arm64 and, as PID 1, idles in `pause()`
   forever, so the recording never ends.

   ```sh
   sudo trace-cmd record -p function_graph -F -c -O nofuncgraph-irqs \
       --user "$USER" -o functions.dat ./app
   trace-cmd report -i functions.dat > functions.txt
   ```

3. **Pass criterion:** `functions.txt` captures the nested function graph of the
   workload without dropped buffer events or interrupt interleaving.

### 5.2 Host-Side GDB Stub Tracing (`Tracing a minimal user space`)

`Dockerfile.gdb-stub-tracing` automates this section for the Step 0 `ainit`
image (see [Hello Init Appendix 2](./HelloInit.md#appendix-2-non-intrusive-syscall-tracing-via-qemu-gdb-stub)):

```sh
docker build -f docs/minimal-linux/hello-init/Dockerfile.gdb-stub-tracing -t helloinit-gdb .
docker run --rm helloinit-gdb
```

**Pass criterion:** In the recorded environment, the log lists the 16 `ainit`
syscall entries shown in Hello Init Appendix 2, including `syscall=64 arg0=0x1`
(`write`) and ending with `syscall=73` (`ppoll`, the `pause()` loop). The image
build fails if the `write` entry is missing.

When running GDB by hand, put the breakpoint `commands` block in a command file
and pass it with `-x`, as the Dockerfile does. GDB reads a `commands` body from
its input, so splitting it across `-ex` arguments fails with
`Undefined command: "silent"` and `There is no member named regs`. To check an
`ioctl` request, also print `regs->regs[1]`: `0x5401` is `TCGETS`.

### 5.3 Low-Level QEMU Instruction Tracing

1. **Enable QEMU execution logging:** Pass `-d in_asm -D qemu.log` to QEMU.
2. **Pass criterion:** `qemu.log` captures translated basic blocks for early boot
   and user-space execution. A block appears when QEMU translates it, not each
   time it runs, so a missing repeat does not show that the block did not run
   again.

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
  Check `#anchor` fragments as well as files: GitHub builds anchors from
  heading text, so renaming a heading breaks every link to it. Heading renames
  in Hello Init (for example `&` to `and`, which turned
  `#measurement-denominators--sloc-accounting` into
  `#measurement-denominators-and-sloc-accounting`) left seven links in other
  pages pointing at anchors that no longer existed.

## 7. Determinism and anti-regression levers

- **Pin the inputs:** kernel tag/commit (Provenance Anchor), the base image
  digest and toolchain versions, Alpine `3.20.3` minirootfs and the pinned
  `stress-ng`/`iproute2` APK versions.
- **Rebuild for real:** use `docker build --no-cache` for a validation pass;
  cached layers only prove that an earlier build worked.
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
- **Quiet host for KCOV:** capture KCOV on an idle host or with
  `-icount shift=4`; host load adds timer-interrupt PCs to the window
  ([Section 2](#2-validating-the-hello-init-body-sections)).
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

## 9. Reviewing proposed changes and moving to the next step

Sections 2–8 say how to run and validate each walkthrough. This section is the
workflow around that: how to review a batch of proposed changes (for example,
edits an agent left in the working tree) and decide when a step is done and the
next one can start. It assumes the common split where one actor proposes changes
and a human reviews and commits them.

### 9.1 Proposed changes land uncommitted; the reviewer commits

- **Proposed edits are left uncommitted and unstaged in the working tree**, with
  a copy of each applied patch kept outside the tree. The reviewer reads the
  diff and commits; nothing is pushed or sent without a separate decision.
- **See what is proposed before running anything:**

  ```sh
  git status --short
  git diff                      # unstaged proposed edits
  git diff --cached             # anything already staged
  git status --short | grep '^??'   # new untracked files (e.g. new Dockerfiles)
  ```

- **Review new files too, not just diffs.** New Dockerfiles and scripts show up
  only as `??` in `git status`; `git diff` alone misses them. Read each new file
  in full.
- **Commit in small, reviewed batches** rather than one large commit, so a later
  bisect or revert is cheap. Keep unrelated staged work (for example, a
  configuration fix) separate from doc edits by committing specific paths:

  ```sh
  git add docs/minimal-linux/max-coverage/Dockerfile.step0-gcov-baseline
  git commit -s -- docs/minimal-linux/max-coverage/Dockerfile.step0-gcov-baseline
  ```

### 9.2 Step gate — when a step is "done" and the next may start

Treat each walkthrough step as done only when all of the following hold. This is
the gate to move to the next step or to commit.

1. **The build/run finished with the expected exit and pass criterion.** The
   step images fail the build on a dropped config option, a missing or invalid
   checkpoint, or a zero coverage denominator (Hello Init
   [Section 2](#2-validating-the-hello-init-body-sections); Max Coverage
   [Section 4](#4-validating-the-maximizing-kernel-coverage-example)). A build
   that exits 0 has already passed those internal gates; still compare the
   recorded numbers against the document's table for that step.
2. **The numbers were re-derived, not reused.** Confirm the measured values in
   the reviewed environment (Section 2's table, Section 4's reproduction note).
   Exact matches are expected for deterministic metrics (DWARF SLOC, raw
   `Image`, the coverage denominator); small drift is expected for the
   stress-ng/Syzkaller stages and for toolchain-sensitive pruned figures. Label
   which is which.
3. **The evidence is saved** (Section 7): serial log, `metrics.txt`, the JSON
   inventories. A reviewer who cannot point at the artifact has not verified the
   claim.
4. **Lint and links pass** for any doc or Dockerfile change (Section 9.4).

If a step changes a measured number in the document, see Section 9.3 before
editing the table.

### 9.3 Do not silently rewrite measured tables

When a fresh run produces numbers close to but not identical to a recorded
table, **do not overwrite the table in place.** Those figures are dated evidence
from a specific toolchain. Instead add a dated reproduction note next to the
table stating what was rebuilt, the environment (base image digest, GCC/QEMU
versions), and which values matched exactly versus drifted and by how much. Only
replace the table's headline numbers when the environment is the authoritative
one going forward, and then record the new environment in the Provenance Anchor.
Exact-match metrics that move (DWARF SLOC, raw `Image`, denominator) are a signal
to investigate — a changed toolchain, a changed config, or a real regression —
not to quietly edit.

### 9.4 Lint and link checks for doc/Dockerfile changes

- **Build the lint clone from the current `HEAD`, not an older base.** Files the
  reviewer already committed (for example a `CPPLINT.cfg` that silences the C
  samples, or reformatted sources) are invisible to `git diff HEAD` and
  `git ls-files --others`, so a clone checked out at an older commit will be
  missing them and the C linter will report the very errors that commit fixed.
  Clone, check out `HEAD`, then overlay only the still-uncommitted edits:

  ```sh
  git clone --quiet --no-hardlinks . ../lint-scratch
  git -C ../lint-scratch checkout --quiet --detach HEAD
  git -C ../lint-scratch branch -f main "$(git merge-base origin/main HEAD)"
  { git diff HEAD --name-only; git ls-files --others --exclude-standard -- docs; } \
      | while read -r f; do mkdir -p "../lint-scratch/$(dirname "$f")"; \
          cp "$f" "../lint-scratch/$f"; done
  grep -v '^#' .github/super-linter.env > ../lint.env
  docker run --rm -e RUN_LOCAL=true --env-file ../lint.env \
      -v "$(cd ../lint-scratch && pwd)":/tmp/lint \
      ghcr.io/super-linter/super-linter:v8.7.0
  ```

- **Use the repository's `super-linter.env` unmodified.** It already lists the
  disabled linters; adding a `VALIDATE_<X>=true` on top makes super-linter abort
  with "either only include or only exclude" and lint nothing. If a run exits
  non-zero, confirm it actually linted (look for `Errors found in <LINTER>`)
  rather than failed to start.
- **Check `#anchor` fragments, not just file paths.** Renaming a Markdown
  heading breaks every in-repo link to its old anchor (Section 6). A link
  checker that resolves heading-derived slugs catches this; a file-existence
  check does not.
- Remove the lint clone when done; its `FIX_*` modes rewrite files as `root`
  (`docker run --rm -v "$(cd .. && pwd)":/w ubuntu:24.04 rm -rf /w/lint-scratch`).

### 9.5 Expected run times — a long build is not a hang

A `--no-cache` build boots QEMU and, for the coverage example, compiles
Syzkaller and runs a multi-minute stress sweep. These are the recorded
wall-clock times on a 22-core host (single-core guest); treat anything near them
as normal, and only suspect a hang well beyond them:

| Image                                       | Approx. build+run time |
| :------------------------------------------ | :--------------------- |
| Hello Init step 0/1/2                       | ~5–6 min each          |
| Hello Init GDB-stub trace                   | ~7–8 min               |
| Hello Init step 3 (`defconfig`)             | ~29 min                |
| Max Coverage step 0 (GCOV baseline)         | ~27 min                |
| Max Coverage step 1 (pruned, cached layers) | ~23 min                |

The coverage steps spend most of that time in the in-image QEMU run (bounded by
a 20-minute `timeout` in the Dockerfile) and in reconstructing one gcov JSON per
unit. The build log is quiet during the QEMU run because the guest's serial
output is redirected to a file inside the container; the stage markers are not
visible until the extraction step runs. Wait for the bounding timeout before
concluding a run is stuck.

### 9.6 Keep a resumable record across a long review

A full pass is long enough to be interrupted (or to outlive a host reboot; see
the disk/WSL note in [Section 1](#1-how-to-use-these-notes)). Keep a short
running record outside the repository — which steps have a saved `exit=0`, which
numbers are confirmed, what is still pending — so the review resumes without
re-running completed steps. The step loop in
[Section 1.1](#11-running-the-hello-init-sequence-resumable) already skips steps
with a recorded `exit=0`; apply the same habit to the review itself.
