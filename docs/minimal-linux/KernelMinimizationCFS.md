<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Hello cFS

This document applies the kernel-minimization method from
[Kernel Minimization](./KernelMinimization.md) to a real flight workload, the
NASA Core Flight System (cFS). Read the base walkthrough first — the baseline
assumption (no-init, PID 1 application, reduced POSIX/user-space surface), the
kernel build and iterate steps, and the evaluation/metrics approach all carry
over here.

## Kernel options

cFS is the concrete flight workload we apply the same no-init, PID 1 baseline
to. Its user-space needs are modest — it links `<stdint.h>`, `<stdbool.h>`,
`<string.h>`, `<stdlib.h>`, and `<math.h>` from the C library — which fits the
"application + minimal libc, no init" model well.

Approach:

- Launch cFS directly as PID 1 (`init=<cFS start application>`), consistent with
  the baseline — no service manager in front of it.
- Start from a measurement kernel config (e.g. the config the Nix work refined)
  and build a meta-aerospace cFS image against it.
- Iterate by removing kernel and user-space features cFS does not exercise,
  re-testing each step.
- Where a removal breaks cFS, document the boundary — that is a requirement
  artifact showing the kernel feature cFS actually depends on. Expect cFS to
  require a slightly larger set than the [Hello World init](./HelloWorldInit.md)
  (e.g. more of the libc surface, possibly threading), and capture that delta
  explicitly.

## Evaluation

Apply the workload-tracing method to cFS running as PID 1 to confirm the
subsystems it exercises, then reconcile against the enabled config. Because
there is no init system to mask dependencies, anything cFS needs shows up
directly as a kernel/libc requirement. Note any option that had to be re-enabled
to keep cFS running, and why — this closes the loop between userspace
application support and "is the kernel missing a config feature."

## Metrics

Reuse the [Kernel Minimization metrics table](./KernelMinimization.md#metrics)
so the cFS workload can be compared directly against the trivial baseline — same
SLOC/function-count method, image size, boot check, and a cFS-specific "workload
passes" criterion (e.g. the sample app runs and the expected telemetry/behavior
is observed).

## References

- [Kernel Minimization](./KernelMinimization.md) — base method, kernel build,
  iterate, evaluate, and metrics.
- [Hello World init](./HelloWorldInit.md) — building the minimal static PID 1
  init and packing it into an initramfs for QEMU.
