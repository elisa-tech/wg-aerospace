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

## 1. How to use these notes

- Treat every table in [Hello Init (Practice)](./HelloInit.md) and [the Maximizing Kernel Coverage example](./MaxCoverageMultiSuite.md)
  as a claim to be re-derived, not trusted. Each claim has a build recipe and a
  measurement command in the referenced document; re-run them rather than reusing
  published numbers.
- Work inside the **ELISA AeroWG devcontainer** (HelloInit.md Section 2) so the toolchain
  matches at a minimum the [Provenance Anchor](./HelloInit.md#71-experiment-artifacts--provenance-anchor).
  A different toolchain changes SLOC and coverage counts.
- **Monitor disk across builds.** Each clean kernel build adds a few GB; the
  `defconfig` and GCOV builds are the largest. Run `make clean` between
  configurations and `df -h .` after each build.
- Record cores and wall-clock time for every run, per
  [Section 10](./MaxCoverageMultiSuite.md#10-measurement-environment-core-count--timing-record).

## 2. Validating the Hello Init body sections

All "Section N" references in this table are sections of [Hello Init (Practice)](./HelloInit.md).

| Claim to validate       | How to reproduce                                             | Pass criterion (approx)                                                                                      |
|:------------------------|:-------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------|
| 7.2 Step 0 `tinyconfig` | Section 4 bottom-up recipe + Section 6.1 SLOC/image commands | DWARF `124,938`, compiled `352,672` (600 files), raw `Image` `3,223,560` B; boots to `hello world`           |
| 7.2 Step 1 `+NET+INET`  | Section 4 recipe `-e NET -e INET`                            | DWARF `197,490`, compiled `527,040` (784 files); `NET-PROBE: IPv4/UDP socket available`                      |
| 7.2 Step 2 `defconfig`  | `make defconfig; -d MODULES` + debug info                    | DWARF `1,959,778`, compiled `5,721,697` (9,157 files); boots with `-m 512M`                                  |
| 7.3 user space          | Section 6.1 user-space commands                              | `ainit` 10 SLOC / 634,000 B; `ainit-net` 23 SLOC; `ainit-kcov` 68 SLOC; `ainit-net-kcov` 69 SLOC / 704,592 B |
| 7.4.0 `read()` KCOV     | Section 6.2 collector on the KCOV `tinyconfig`               | 29 unique lines across 21 PCs                                                                                |
| 7.4.1 `socket()` KCOV   | Section 5.3 collector on the KCOV `+NET+INET` build          | ~307 lines / ~268 PCs (window includes the `KCOV_DISABLE` ioctl)                                             |

> **Known-benign variance.** Compressed `Image.gz` sizes and `*.cpio.gz` archive
> sizes differ by a few bytes between runs because `gzip` embeds a timestamp/OS
> byte; compare the **raw** `Image` and the DWARF/compiled SLOC for exact matches.

## 3. Validating the Maximizing-Kernel-Coverage example

All "Section N" references in this subsection are sections of
[Maximizing Kernel Coverage](./MaxCoverageMultiSuite.md).

Reproduce in order: [Section 3](./MaxCoverageMultiSuite.md#3-kernel-profiling-configuration) build →
[Section 4](./MaxCoverageMultiSuite.md#4-rootfs-assembly--sequential-multi-stage-execution-workflow) rootfs/boot →
[Section 5](./MaxCoverageMultiSuite.md#5-host-side-checkpoint-extraction--differential-analysis) reconstruct →
tables [Section 6](./MaxCoverageMultiSuite.md#6-measured-multi-stage-progression--differential-table-tinyconfig)/[Section 7](./MaxCoverageMultiSuite.md#7-identifying-uncovered-built-areas--pruning-candidates)/[Section 8](./MaxCoverageMultiSuite.md#8-iterative-kconfig-pruning--post-minimization-coverage-impact).

Watch for these verified failure modes (each is called out at its step):

- **Self-tests silently dropped.** After the Section 3 `olddefconfig`, confirm
  `RUNTIME_TESTING_MENU=y`, `KUNIT=y`, and the `TEST_*`/`ATOMIC64_SELFTEST`
  symbols survived. If they are `undef`, Stage 0 coverage collapses.
- **`tc` missing (optional networking extension only).** The NET-less baseline
  has no Netlink/tc stage. If you add the optional networking extension
  (Section 3), confirm `/sbin/tc` exists in the rootfs (needs the `iproute2-tc`
  package, which `iproute2-minimal` does not provide); otherwise its `tc qdisc`
  commands do nothing.
- **`gcov` reports `Runs:0`.** You must place each `.gcda` next to its in-tree
  `.gcno` and run `gcov` **from the kernel tree root** (Section 5), or no line data is
  emitted.
- **`-d FUTEX_PI` is ignored.** It is auto-selected; drop `FUTEX`/`RT_MUTEXES`
  instead (Section 8).
- **Denominator ambiguity.** State whether a percentage uses the `.gcno`
  basic-block metric or the `.gcov` source-line denominator
  (see [Measurement Denominators](./HelloInit.md#measurement-denominators--sloc-accounting)
  in Hello Init); they are not interchangeable.

> **Environment sensitivity.** The Maximizing Kernel Coverage example's magnitudes
> are reproducible *in method and shape*, but exact line counts depend on the
> single-core guest, the toolchain, and the LTP/Syzkaller payloads. Its Section 4
> steps build real LTP (a bounded subset) and a real `syz-prog2c` reproducer; the
> full LTP suite, a richer corpus, or a live `syz-fuzzer` (its Section 2) moves the
> edge-case numbers. Always regenerate the tables for your own payload set rather
> than citing these values as acceptance targets.

## 4. Validating the parent document (`SoftwareMinimization.md`)

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

## 5. Determinism and anti-regression levers

- **Pin the inputs:** kernel tag/commit (Provenance Anchor), toolchain versions,
  Alpine `3.20.3` minirootfs and the pinned `stress-ng`/`iproute2` APK versions.
- **One variable at a time:** when a number moves, change only the config group or
  payload under test and keep `make clean` between builds so stale objects do not
  distort SLOC.
- **Single-core by default:** keep the guest at one vCPU (no `-smp`) for
  deterministic stage ordering; only add cores deliberately and re-record timing.
- **Capture evidence:** save the serial log, the `linked.json`/`compiled.json`
  reports, and the per-stage `.gcov` directories so a reviewer can re-derive every
  table without rebuilding.

## 6. Devcontainer provisioning for LTP + Syzkaller

The Maximizing Kernel Coverage example builds **real** LTP and **real** Syzkaller tooling, so the devcontainer
image must carry their build prerequisites. These are added to
`demos/env/Dockerfile`:

- **LTP** (`make autotools && ./configure && make`) needs host autotools:
  `autoconf`, `automake`, `autotools-dev`, `m4` (and `pkg-config`). Without them,
  `make autotools` fails at `aclocal: not found` and no testcases build.
- **Syzkaller** `syz-prog2c` needs a **Go toolchain**: `golang-go`.

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
```

> **Why these are mandatory (not optional):** earlier revisions of this material
> substituted a hand-written static `ltp_syscalls.c` and a Go-free `syz-repro.c`
> because the toolchain was missing. Those stand-ins are **not** LTP or Syzkaller
> and must not be presented as such. With the toolchain above, the Maximizing Kernel Coverage example builds the
> genuine LTP syscall testcases and uses `syz-prog2c` to generate the reproducer,
> which is what the Maximizing Kernel Coverage example's coverage numbers were measured against.
