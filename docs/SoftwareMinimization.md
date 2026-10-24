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
- **[Maximizing Kernel Coverage with Open-Source Test Suites](./minimal-linux/MaxCoverageMultiSuite.md)**
  — a worked example of applying these concepts to maximize whole-kernel
  structural coverage: it drives stress-ng, LTP, Syzkaller, and GCOV against a
  GCOV-instrumented `tinyconfig` kernel, then audits and prunes the code that
  remains unreached. Shows the reachability and pruning loop end to end.

## How this maps to the kernel.org draft guides

| Draft (practice-only)                                      | Aerospace-specific here                                                                                                           |
| ---------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Application as PID 1, no init system                       | Same proposed launch model for [Hello Init (Practice)](./minimal-linux/HelloInit.md) and [Hello cFS](./minimal-linux/HelloCFS.md) |
| Rebuild and check the workload after configuration changes | Apply our change → build → test → measure → record loop                                                                           |
| Trace workload → map to Kconfig → prune → re-test          | Investigate failed removals as possible dependencies                                                                              |
| Present-vs-observed code (gcov/kcov)                       | Focus requirements and reachability analysis, not code classification                                                             |
| SLOC / image metrics                                       | Compare configurations with consistent measurement scope                                                                          |

## Related aerospace work

- [Kernel Complexity](./minimal-linux/KernelComplexity.md) — complexity and
  verification effort, distinct from size.
- [Certification progression](./minimal-linux/CertificationProgression.md) —
  the separate assurance track.
- [Nix-based kernel configuration](../demos/AvioNix-demo/NixBasedKernelConfig.md) —
  reproducible configuration using the same iterate-and-measure loop.
- [AI Testing Steering Notes](./minimal-linux/TestingSteeringNotes.md) — reviewer /
  agent checklist for re-running and validating the measured claims in these
  walkthroughs and this page.

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
  [Config Analysis](./minimal-linux/KernelConfigAnalysis.md).
