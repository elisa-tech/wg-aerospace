<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Measuring Linux Kernel Complexity — Build-Time and Runtime Approaches

This is a companion to the [Kernel Minimization](./KernelMinimization.md)
walkthrough. Minimization reduces *size*; this document is about measuring
*complexity*, which is a related but distinct concern and needs its own
definition before it is measured.

## Why "define complexity first" is the right instinct

"Complexity" is an umbrella for several distinct concerns that need different
metrics and imply different mitigations. Before measuring, agree which of these
you mean, because they do not correlate cleanly:

- **Code/structural complexity** — how hard the source is to understand, review,
  and verify (relevant to DO-178C review effort and MC/DC feasibility).
- **Configuration/variability complexity** — the Kconfig space; how many
  features are enabled and how they interact (very large for the kernel).
- **Build/dependency complexity** — call-graph depth, symbol coupling, module
  interdependencies.
- **Behavioral/runtime complexity** — how much code is actually exercised,
  control-flow paths taken, concurrency/interrupt interleavings, timing
  variability.
- **Interface/attack-surface complexity** — syscalls, ioctls, exported symbols
  reachable from a partition.

From a certification/partitioning context, the operative definition is likely
*"complexity that drives verification effort and undermines
determinism/isolation arguments"* — narrower than generic software-metrics
complexity. Getting that scoping wrong means measuring something that looks
rigorous but does not support the safety case.

## Build-time / static approaches

Ordered from cheap-and-shallow to expensive-and-deep.

### 1. Size and configuration surface

- Lines of code / compiled object size for the *configured* kernel, not the
  whole tree. The right denominator is "what is in your image," gated by your
  Kconfig.
- Kconfig option count and dependency graph. Tooling: `scripts/kconfig`, and
  research tools such as Undertaker, KernelHaven, and kmax for analyzing
  configuration-conditional (`#ifdef`) variability. This is often the dominant
  complexity axis for the kernel and is underappreciated.
- Feature/attack-surface reduction is the practical lever: a minimized config
  directly shrinks the complexity you must argue about.

### 2. Classic code metrics (per function/file)

- Cyclomatic complexity (McCabe), cognitive complexity, nesting depth, function
  length, parameter counts. Tooling: `lizard`, `pmccabe`, Cppcheck, clang-based
  analyzers, SonarQube.
- Useful for triage, but McCabe on kernel code is noisy — macros, `goto`-based
  error handling, and generated code inflate it. Treat it as a screening signal,
  not a verdict.

### 3. Coupling / dependency structure

- Call-graph and symbol-dependency analysis: subsystem connectedness,
  fan-in/fan-out, cyclic dependencies. Tooling: clang call graphs, `cflow`,
  Doxygen graphs, `objtool`/symbol analysis.
- For a partitioning argument, the key question is *reachability*: from a
  partition's syscall/driver surface, what code is actually reachable? That
  bounds what must be verified far better than whole-tree metrics.

### 4. Verification-oriented static complexity

- Structural coverage feasibility: can statement / branch / MC/DC coverage be
  achieved on the reachable set? Code that cannot be covered by test is a
  verifiability red flag.
- Data/control-flow analysis and, for hard real-time claims, WCET-relevant
  structure (loop bounds, recursion, indirect calls). Indirect calls and
  function pointers are a specific complexity driver for both analysis and WCET.

## Runtime / dynamic approaches

### 1. Coverage of what is actually used

- `gcov`/kernel GCOV and `kcov` to observe which paths execute under
  representative workloads. The gap between "code present" and "code exercised"
  is itself a complexity/dead-code metric and supports deactivated-code
  arguments in DO-178C.

### 2. Path / control-flow behavior

- ftrace (including the function-graph tracer) and `perf` to observe call depth,
  hot paths, and branch behavior at runtime.
- eBPF for targeted instrumentation (syscall frequency, latency distributions,
  lock contention) without patching the kernel — good for measuring *interface*
  complexity (which syscalls/ioctls a partition actually invokes).

### 3. Timing / determinism variability

- For AMC 20-193 relevance: measure interference and timing variability, not
  just averages. `cyclictest` (latency), `perf stat` hardware counters (cache
  misses, memory bandwidth), and interference generators to see how one
  partition perturbs another. Variability under contention is a runtime
  complexity that static metrics cannot reveal and is central to the multicore
  certification argument.

### 4. Concurrency complexity

- Lock contention (`lockdep`, `perf lock`), interrupt/preemption interleavings,
  and RCU behavior. Concurrency is where kernel complexity most often defeats
  static reasoning — worth measuring explicitly when the safety case depends on
  isolation.

## Practical recommendation

1. **Anchor everything to the configured, reachable kernel**, not the upstream
   tree. Config minimization is both a complexity metric and the main
   mitigation.
1. **Pair one static and one dynamic metric per concern** — e.g., reachable-code
   size (static) + `kcov` coverage (runtime); cyclomatic hotspots (static) +
   ftrace hot paths (runtime); indirect-call/loop structure (static) +
   `cyclictest`/interference variability (runtime). The static/runtime pairing is
   what makes the argument credible: static bounds the space, runtime shows what
   is real.
1. **Beware Goodhart's law.** Once a complexity number becomes a target, people
   optimize the number rather than the verifiability. Use these as guides for
   focusing review and reducing surface, not as pass/fail gates.

## References

- McCabe, T. J. "A Complexity Measure." *IEEE Transactions on Software
  Engineering*, 1976.
- Linux kernel documentation — Kconfig, `gcov`, `kcov`, ftrace, and tracing:
  <https://docs.kernel.org/> (see dev-tools/gcov, dev-tools/kcov, trace/ftrace).
- Undertaker / KernelHaven / kmax (Kconfig variability analysis) — academic
  tooling from the VAMOS/KernelHaven research groups.
- `lizard` cyclomatic-complexity analyzer: <https://github.com/terryyin/lizard>.
- Linux `perf`, `lockdep`, and `cyclictest` (rt-tests) — standard kernel/RT
  tooling documentation.
- eBPF documentation: <https://ebpf.io/>.
- SAE AMC 20-193 / A(M)C 20-193 — use of multi-core processors (multicore
  interference and timing determinism guidance).
- RTCA DO-178C — software considerations in airborne systems (structural
  coverage, MC/DC, deactivated code); DO-278A for ground systems.
- DORA / Google Cloud DevOps Research — guidance on metrics as guides not
  targets (Goodhart's law): <https://dora.dev/>.
