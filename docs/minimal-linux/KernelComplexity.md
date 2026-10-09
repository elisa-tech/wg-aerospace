<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Measuring Linux Kernel Complexity — Build-Time and Runtime Approaches

This is a companion to the draft
[kernel-minimization guide](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html)
(see this repo's [aerospace framing](../KernelMinimization.md)).
Minimization reduces _size_; this document is about measuring
_complexity_, which is a related but distinct concern and needs its own
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
_"complexity that drives verification effort and undermines
determinism/isolation arguments"_ — narrower than generic software-metrics
complexity. Getting that scoping wrong means measuring something that looks
rigorous but does not support the safety case.

## Build-time / static approaches

Ordered from cheap-and-shallow to expensive-and-deep.

### 1. Size and configuration surface

- Use the [kernel guide's measurements](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html#measuring)
  for SLOC and image size, including their scope limitations. These describe
  build size, not structural complexity or the code reachable from a partition.
- Kconfig option count and dependency graph. Tooling: `scripts/kconfig`, and
  research tools such as Undertaker and `kmax` (see References) for analyzing
  configuration-conditional (`#ifdef`) variability. This is often the dominant
  complexity axis for the kernel and is underappreciated.
- Configuration reduction can narrow the code and interfaces to analyze;
  fewer options or lines do not by themselves establish lower complexity.

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
- For a partitioning argument, the key question is _reachability_: from a
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

- Follow the [workload-tracing guide](https://matthew-l-weber.github.io/linux/admin-guide/workload-tracing.html)
  and the kernel guide's [present-versus-observed discussion](https://matthew-l-weber.github.io/linux/admin-guide/kernel-minimization.html#separating-code-that-is-present-from-code-that-runs)
  for collection methods and their limits. For aerospace analysis, use the
  observations to focus requirements and reachability review. Unobserved code
  is not a dead-code metric and does not establish dead or deactivated status
  under DO-178C; that requires requirements, configuration, and reachability
  analysis, including paths outside the collection scope.

### 2. Path / control-flow behavior

- ftrace (including the function-graph tracer) and `perf` to observe call depth,
  hot paths, and branch behavior at runtime.
- eBPF for targeted instrumentation (syscall frequency, latency distributions,
  lock contention) without patching the kernel — good for measuring _interface_
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

1. **Anchor everything to the configured kernel and the reachability question**,
   not the whole upstream tree. Minimization can reduce the analysis scope;
   configuration size is not itself a complexity metric.
1. **Pair static analysis and runtime observations per concern** — e.g.,
   reachability analysis + task-scoped coverage; cyclomatic hotspots + observed
   call paths; indirect-call/loop structure + timing under interference.
   Review each method's assumptions and limits. A sampled or task-filtered trace
   does not establish every feasible path, worst-case timing, or an assurance
   argument by itself.
1. **Beware Goodhart's law.** Once a complexity number becomes a target, people
   optimize the number rather than the verifiability. Use these as guides for
   focusing review and reducing surface, not as pass/fail gates.

## References

- McCabe, T. J. "A Complexity Measure." _IEEE Transactions on Software
  Engineering_, 1976.
- Linux kernel documentation — Kconfig, `gcov`, `kcov`, ftrace, and tracing:
  <https://matthew-l-weber.github.io/linux/> (see dev-tools/gcov, dev-tools/kcov, trace/ftrace).
- Tartler, R., Lohmann, D., Sincero, J., Schröder-Preikschat, W. "Feature
  Consistency in Compile-Time-Configurable System Software: Facing the Linux
  10,000 Feature Problem." _EuroSys_, 2011.
  <https://doi.org/10.1145/1966445.1966451> — the Undertaker/VAMOS work on
  Kconfig variability and configuration-conditional dead code.
- `kmax` — static extraction of Kconfig/Kbuild configuration constraints:
  <https://github.com/paulgazz/kmax>.
- Kernel Size Reduction Work (the tinification effort that added
  `make tinyconfig`): <https://elinux.org/Kernel_Size_Reduction_Work>.
- `syzkaller` — the origin of `kcov`, for the executed-versus-present code
  evidence: <https://github.com/google/syzkaller>.
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
