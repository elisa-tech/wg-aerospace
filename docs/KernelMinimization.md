<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Kernel Minimization (aerospace application)

Start with the [kernel-minimization draft](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html)
and the [workload-tracing draft](https://matthew-l-weber.github.io/linux/admin-guide/workload-tracing.html).
These are review previews, not merged upstream
kernel documentation. The preview reflects the latest successful Pages build;
[PR for comments](https://github.com/matthew-l-weber/linux/pull/1/changes).

The guides cover configuring and building the kernel, a static hello-world
PID 1 application under QEMU, tracing, coverage, and `scripts/kernel-sloc`. This page
keeps the aerospace framing and observations rather than repeating those steps.

## Environment

Run the walkthrough inside the **ELISA AeroWG devcontainer**. Follow
[Get a development shell](../demos/docs/Development.md#get-a-development-shell)
(`make prep` / `make dev` in `demos/copilot/src/monitors`), or reopen this
repository in the VS Code devcontainer. Rebuild an older container to pick up
the kernel build dependencies, arm64 cross-toolchain, QEMU, and SLOC tools.
Run the guide's commands from your Linux source checkout.

## How this maps to the draft guide

| Draft (practice-only) | Aerospace-specific here |
| --- | --- |
| Application as PID 1, no init system | Same proposed launch model for [Hello cFS](./minimal-linux/KernelMinimizationCFS.md) |
| Rebuild and check the workload after configuration changes | Apply our change → build → test → measure → record loop |
| Trace workload → map to Kconfig → prune → re-test | Investigate failed removals as possible dependencies |
| Present-vs-observed code (gcov/kcov) | Focus requirements and reachability analysis, not code classification |
| SLOC / image metrics | Compare configurations with consistent measurement scope |

These practice results are not certification evidence by themselves. Under
RTCA DO-178C, *Software Considerations in Airborne Systems and Equipment
Certification* (DO-178C), an absence of observed execution does not establish
that code is dead or deactivated. Boot, interrupts, other tasks, and untested
error paths can be outside a trace. Classification needs requirements,
configuration, and reachability analysis beyond these measurements.

A hello-world boot validates only that workload on the selected QEMU machine,
not cFS, target hardware, timing, partitioning, or a software assurance level.
The cFS page proposes an application of the method; it does not demonstrate a
PID 1 boot or supply a complete cFS configuration.

## Record a reviewable experiment

For AeroWG experiments, use **change → build → test → measure → record** to
retain reviewable comparisons. This is our experiment discipline, not a
prescribed review or assurance process in the general Linux guide.

For each configuration, save:

- Kernel revision, resolved `.config` and delta, build commands, and tool versions.
- Workload source/binary, libc, archive contents, QEMU command, boot log, and
  workload pass criterion.
- Image sizes, SLOC counts/inventories, and debug-info/coverage scope; confirm
  `CONFIG_MODULES=n`.
- Failed removals, the observed failure, and the result of restoring the option.
  A failure can also reflect packaging or a test limitation.

Save results before changing or cleaning the build. Keep instrumented results
identified separately from the uninstrumented target. The draft's
[measurement instructions](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html#measuring)
cover counting and avoiding stale compilation databases.

## Observations

The following figures are retained from earlier walkthrough notes for
orientation, not revalidated measurements of the current draft/tool. Save the
exact artifacts and versions when repeating them; do not use these numbers as
acceptance targets.

### Kernel progression (reported LTS v6.18.52, arm64)

| Configuration | DWARF SLOC | Compiled-file SLOC | Image (raw) | Reported boot |
| --- | --- | --- | --- | --- |
| tinyconfig + boot/serial options | 171,739 | 342,997 | 2.9 MiB | yes |
| + networking | 273,678 | 521,825 | 4.1 MiB | yes |
| + block / EXT4 | 319,767 | 597,973 | 4.6 MiB | yes |
| + PCI / USB | 346,568 | 649,022 | 5.1 MiB | yes |
| defconfig | 1,212,643 | 2,748,291 | 47 MiB | yes |

The tiny baseline requests `TTY`, `SERIAL_AMBA_PL011`,
`SERIAL_AMBA_PL011_CONSOLE`, `PRINTK`, `BLK_DEV_INITRD`, and `BINFMT_ELF`;
`RD_GZIP` defaults to enabled. The [config analysis](./minimal-linux/KernelConfigAnalysis.md)
compares published Boeing and ELISA LFSCS configurations.

### Hello-world user space (reported arm64, static glibc)

| Metric | Reported value | Scope |
| --- | --- | --- |
| Application source SLOC | 10 | Application only, not linked libc |
| Static binary, unstripped | 634,000 B | On-disk ELF size |
| Static binary, stripped | 532,408 B | After `aarch64-linux-gnu-strip` |
| `size` text / data / bss | 498,513 / 22,164 / 21,600 B | Section sizes, not file size |
| `initramfs.cpio.gz` | 279,571 B | Archive of just `/init` |

The linked libc dominates the small application's footprint. A smaller libc
such as musl is a candidate to measure and re-test, not an automatic equivalent.

| User space | Version | Reported source SLOC | Scope |
| --- | --- | --- | --- |
| Basic PID 1 example | — | 10 | Single application file, excludes libc |
| BusyBox | 1.36.1 | 189,050 | Whole C/C++/header source tree |
| systemd | 257 | 684,593 | Whole C/C++/header source tree |

Whole-tree counts include unused code and omit other languages; they are not
comparable deployed footprints. See `scripts/kernel-sloc --help` for the
optional `files` and `tree` modes.

### Networking probe expectations

Use the draft's [networking probe](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html#probing-a-kernel-feature)
with the same application/archive for each configuration. These are expected
observations, not measured results:

| Bootable configuration | Expected probe result |
| --- | --- |
| `NET=y`, `INET=y` | IPv4/UDP socket opens |
| `NET` disabled | Failure, typically `ENOSYS` |
| `NET=y`, IPv4 disabled | Failure, typically `EAFNOSUPPORT` |

Record the actual errno and resolved configuration, along with the boot check.
The [PID 1 KCOV example](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html#dumping-kernel-coverage-kcov)
collects a separate, task-scoped syscall window; it is not whole-kernel coverage.

## Related aerospace work

- [Hello cFS](./minimal-linux/KernelMinimizationCFS.md) — proposed flight workload.
- [Kernel Complexity](./minimal-linux/KernelComplexity.md) — complexity and
  verification effort, distinct from size.
- [Certification progression](./minimal-linux/CertificationProgression.md) —
  the separate assurance track.
- [Nix-based kernel configuration](../demos/AvioNix-demo/NixBasedKernelConfig.md) —
  reproducible configuration using the same iterate-and-measure loop.

## Reviewing kernel-side edits

Use the hosted previews above for navigation and feedback. For unpublished
local edits, follow the [kernel documentation build instructions](https://matthew-l-weber.github.io/linux/doc-guide/sphinx.html)
and run `make htmldocs` in the Linux checkout with its Sphinx dependencies
installed. Build the full tree so cross-guide links resolve; inspect warnings
as well as the exit status. The fork's Pages action publishes successful builds.

## References

- [Kernel-minimization draft](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html)
  and [workload-tracing draft](https://matthew-l-weber.github.io/linux/admin-guide/workload-tracing.html).
- ELISA [Discovering Linux kernel subsystems used by a workload](https://github.com/elisa-tech/ELISA-White-Papers/blob/master/Processes/Discovering_Linux_kernel_subsystems_used_by_a_workload.md).
- ELISA LFSCS [minimal-application ftrace study](https://github.com/elisa-tech/wg-lfscs/blob/main/min_prog_trace/README.md)
  and [configuration](https://github.com/elisa-tech/wg-lfscs/tree/main/min_prog_trace).
- [Kernel Size Reduction Work](https://elinux.org/Kernel_Size_Reduction_Work) —
  earlier upstream tinification work.
- ELISA [kconfig-safety-check](https://github.com/elisa-tech/kconfig-safety-check) —
  cyber/quality hardening, not DO-178C minimization.
- Prior measurements and configuration research:
  [Config Analysis](./minimal-linux/KernelConfigAnalysis.md) and
  [Kernel Complexity references](./minimal-linux/KernelComplexity.md#references).
