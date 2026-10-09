<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Hello cFS

This document proposes applying the [kernel-minimization draft](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html)
to the NASA Core Flight System (cFS). Read that guide first for the build,
iterate, and measurement steps; this page adds cFS-specific considerations.
The draft is a review preview from the personal Linux fork, not merged upstream.
See [Kernel Minimization](../KernelMinimization.md) for the devcontainer setup,
aerospace framing, and baseline observations.

## Kernel options

cFS is the proposed flight workload for the same no-init, PID 1 launch model.
Its C library, OS Abstraction Layer (OSAL), and platform configuration determine
the actual syscall, threading, storage, and networking requirements. Header
usage alone does not establish the required kernel configuration.

Approach:

- Evaluate launching cFS directly as PID 1, without a service manager. Use
  `/init` or `rdinit=<path>` for an initramfs, or `init=<path>` for a mounted
  root filesystem, and validate the application's PID 1 responsibilities.
- Start from a measurement kernel config (e.g. the config the Nix work refined)
  and build a meta-aerospace cFS image against it.
- Iterate by removing kernel and user-space features cFS does not exercise,
  re-testing each step.
- Where a removal breaks cFS, investigate and record the failure and recovery
  before treating the option as a workload requirement.

## Evaluation

Follow the [workload-tracing draft](https://matthew-l-weber.github.io/linux/admin-guide/workload-tracing.html)
for discovery, then validate cFS in its intended launch environment and reconcile
observations with Kconfig. Record the actual workload inputs, any option restored,
and the outcome. Unobserved boot, recovery, or asynchronous paths can still be
required; tracing alone does not establish a complete configuration.

## Metrics

Reuse the draft guide's
[metrics approach](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html)
(`scripts/kernel-sloc` for kernel/userspace SLOC, image size, boot check) so
the cFS workload can be compared directly against the trivial baseline, plus a
cFS-specific "workload passes" criterion (e.g. the sample app runs and the
expected telemetry/behavior is observed).

## References

- [Kernel-minimization draft](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html)
  — base build, iterate, evaluate, and measurement method.
- [Workload-tracing draft](https://matthew-l-weber.github.io/linux/admin-guide/workload-tracing.html)
  — syscall and kernel-path discovery, including minimal user space.
- [Kernel Minimization](../KernelMinimization.md) — devcontainer setup,
  aerospace framing, and [observations](../KernelMinimization.md#observations).
