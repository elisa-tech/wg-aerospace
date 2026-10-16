<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Software Minimization for Aerospace

This repository applies the kernel minimization and workload tracing methodologies
developed for the upstream Linux kernel to safety-critical aerospace systems.

## The Upstream kernel.org Foundation

The foundational approaches for trimming and analyzing a Linux kernel for a single,
known workload are documented in the upstream kernel guides:

- [Kernel Minimization Guide](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html)
  — Covers the core mechanics of top-down and bottom-up Kconfig trimming, monolithic builds,
  cross-compilation for QEMU, feature probing, and SLOC/image size measurement.
- [Workload Tracing Guide](https://matthew-l-weber.github.io/linux/admin-guide/workload-tracing.html)
  — Covers discovering kernel subsystems and tracing syscalls/functions exercised
  by a target application using tools like `strace`, `cscope`, and `ftrace`.

_(Note: These links reflect the latest review previews hosted on GitHub Pages;
see the [upstream PR for comments](https://github.com/matthew-l-weber/linux/pull/1/changes).)_

These upstream guides intentionally stay with general software engineering
mechanics and omit domain-specific compliance standards (such as RTCA DO-178C,
DO-297, or AMC 20-193).

## Aerospace Framing & Assurance Boundaries

In high-assurance aerospace systems, smaller kernels reduce the scope of code
that must be reviewed, analyzed, and justified. However, minimization metrics
(such as unobserved execution in a trace) do not constitute certification evidence
by themselves. Under DO-178C:

- An absence of observed execution does not prove code is dead or deactivated.
- Boot paths, interrupt handlers, background tasks, and error recovery routines
  must be accounted for through explicit requirements and reachability analysis.

## The Reviewable Experiment Discipline

To bridge upstream practice with aerospace engineering rigor, the Aerospace Working
Group applies a structured **Change → Build → Test → Measure → Record** discipline.

Every scenario in this repository follows this exact structure:

1. **Change:** Define or adjust kernel options and configuration deltas (e.g. top-down
   pruning or bottom-up addition).
2. **Build:** Compile a monolithic kernel image and target user-space payload.
3. **Test:** Execute the workload under QEMU emulation and verify functional behavior
   via subsystem feature probing.
4. **Measure:** Collect image sizes, DWARF and compiled source SLOC counts, and task-scoped
   runtime coverage (KCOV).
5. **Record:** Log observations in standardized multi-axis tables for reviewable comparisons.

## Example Scenarios

We provide two concrete scenarios executing this discipline:

- **[Hello Init (Practice)](./minimal-linux/HelloInit.md)** — Foundational
  practice baseline booting a static binary as PID 1 under QEMU `arm64`.
  Provides an end-to-end sandbox for team members to practice the mechanics
  and record baseline metrics.
- **[Hello cFS](./minimal-linux/HelloCFS.md)** — Flight application
  scenario applying the same structure and observation tables to the NASA
  Core Flight System (cFS) and its OS Abstraction Layer (OSAL).

## How this maps to the kernel.org draft guides

| Draft (practice-only)                                      | Aerospace-specific here                                                                                                           |
| ---------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Application as PID 1, no init system                       | Same proposed launch model for [Hello Init (Practice)](./minimal-linux/HelloInit.md) and [Hello cFS](./minimal-linux/HelloCFS.md) |
| Rebuild and check the workload after configuration changes | Apply our change → build → test → measure → record loop                                                                           |
| Trace workload → map to Kconfig → prune → re-test          | Investigate failed removals as possible dependencies                                                                              |
| Present-vs-observed code (gcov/kcov)                       | Focus requirements and reachability analysis, not code classification                                                             |
| SLOC / image metrics                                       | Compare configurations with consistent measurement scope                                                                          |

## General Observations

The following figures are retained from earlier walkthrough notes for
orientation, not revalidated measurements of the current draft/tool. Save the
exact artifacts and versions when repeating them; do not use these numbers as
acceptance targets.

### Kernel progression (reported LTS v6.18.52, arm64)

| Configuration                    | DWARF SLOC | Compiled-file SLOC | Image (raw) | Reported boot |
| -------------------------------- | ---------- | ------------------ | ----------- | ------------- |
| tinyconfig + boot/serial options | 171,739    | 342,997            | 2.9 MiB     | yes           |
| + networking                     | 273,678    | 521,825            | 4.1 MiB     | yes           |
| + block / EXT4                   | 319,767    | 597,973            | 4.6 MiB     | yes           |
| + PCI / USB                      | 346,568    | 649,022            | 5.1 MiB     | yes           |
| defconfig                        | 1,212,643  | 2,748,291          | 47 MiB      | yes           |

The tiny baseline requests `TTY`, `SERIAL_AMBA_PL011`,
`SERIAL_AMBA_PL011_CONSOLE`, `PRINTK`, `BLK_DEV_INITRD`, and `BINFMT_ELF`;
`RD_GZIP` defaults to enabled. The [config analysis](./minimal-linux/KernelConfigAnalysis.md)
compares published Boeing and ELISA LFSCS configurations.

### Hello-world user space (reported arm64, static glibc)

| Metric                    | Reported value              | Scope                             |
| ------------------------- | --------------------------- | --------------------------------- |
| Application source SLOC   | 10                          | Application only, not linked libc |
| Static binary, unstripped | 634,000 B                   | On-disk ELF size                  |
| Static binary, stripped   | 532,408 B                   | After `aarch64-linux-gnu-strip`   |
| `size` text / data / bss  | 498,513 / 22,164 / 21,600 B | Section sizes, not file size      |
| `initramfs.cpio.gz`       | 279,571 B                   | Archive of just `/init`           |

The linked libc dominates the small application's footprint. A smaller libc
such as musl is a candidate to measure and re-test, not an automatic equivalent.

| User space          | Version | Reported source SLOC | Scope                                  |
| ------------------- | ------- | -------------------- | -------------------------------------- |
| Basic PID 1 example | —       | 10                   | Single application file, excludes libc |
| BusyBox             | 1.36.1  | 189,050              | Whole C/C++/header source tree         |
| systemd             | 257     | 684,593              | Whole C/C++/header source tree         |

Whole-tree counts include unused code and omit other languages; they are not
comparable deployed footprints. See `scripts/kernel-sloc --help` for the
optional `files` and `tree` modes.

## Related aerospace work

- [Hello Init (Practice)](./minimal-linux/HelloInit.md) — foundational
  practice walkthrough and measured baseline.
- [Hello cFS](./minimal-linux/HelloCFS.md) — proposed flight workload.
- [Kernel Complexity](./minimal-linux/KernelComplexity.md) — complexity and
  verification effort, distinct from size.
- [Certification progression](./minimal-linux/CertificationProgression.md) —
  the separate assurance track.
- [Nix-based kernel configuration](../demos/AvioNix-demo/NixBasedKernelConfig.md) —
  reproducible configuration using the same iterate-and-measure loop.

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
