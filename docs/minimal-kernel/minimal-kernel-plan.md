<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Minimal Kernel Plan

Tracking issue: [#168](https://github.com/elisa-tech/wg-aerospace/issues/168)

## Focus

The primary deliverable is a **repeatable workflow** — a documented process any team could apply to their own system scenario, BSP, hardware, and product case. The existing AeroWG demos serve as the analysis target for developing the workflow and as examples showing how to make a change. The specific kconfig is secondary to the process.

**Environment: (SWL-D at most)** [Basic cFS Cabin Lights demo (Nix-based, QEMU ARM64)](https://github.com/elisa-tech/wg-aerospace/tree/main/demos/AvioNix-demo)

## Progression of Work

- Build and Measure
- Workflow and Configuration tailoring example

## Future Phase — Brainstorming

The following items are captured for future work once the workflow is established and validated. They are not yet scoped into tickets.

### Product Constraints and Research

- **Define product constraints** — Apply [Product Profiles (SWL-D)](../product-profiles.md#software-level-d) to the [Cabin Lights demo](../use-cases/use-case-cabin-lights.md) to derive concrete constraints. Use the workflow from Phase 2 to show how constraints drive configuration changes. Emulated (QEMU ARM64) to start.
- **Organize prior research into starting configuration** — Consolidate prior research from [#139](https://github.com/elisa-tech/wg-aerospace/issues/139) into a usable starting configuration. Evaluate existing configs (LFSCS, Boeing 5x, kconfig-safety-check) against product constraints.

### Getting to a "Ready" State for Team Use

How does a team take the minimal kernel and prepare it for their specific product?

I.e., The output of the workflow should allow the user to use the information to understand aspects like system complexity and make decisions based on measurements.

Reference pattern: RTEMS — [ESA RTEMS Qualification](https://rtems-qual.io.esa.int/)

- ESA [Category B (ECSS-Q-ST-80C)](https://ecss.nl/standard/ecss-q-st-80c-rev-1-software-product-assurance-15-february-2017/) — mission-critical software where failure could lead to loss of mission
- Roughly equivalent to DO-178C DAL B

### Certification Level Progression

Use the minimal kernel to show the progression of certification levels — identify what's needed to move up from SWL-D toward higher levels.

- **[TRL](https://www.nasa.gov/directorates/somd/space-communications-navigation-program/technology-readiness-levels/) of components/frameworks/modules/drivers** — evidence must be documented for how to achieve the levels claimed. Could go formal like a [TRA](https://acqnotes.com/acqnote/careerfields/technology-readiness-assessment) review, or show how the claims have rigor.
- **[CMM](https://en.wikipedia.org/wiki/Capability_Maturity_Model) of process/practice** — drive toward higher TRL on the supporting approach.
- **DAL B requirements beyond DAL C:** Decision coverage, independence of verification, requirements-based testing at integration levels, full traceability.
- **DAL A requirements beyond DAL B:** MC/DC coverage, source-to-object code traceability, more stringent independence requirements.

### Supporting Broader Certification Efforts

Provide structure to organize contributions and build evidence packages across separate efforts, supporting generically the certification work others may need to perform.

## Prior Research

Consolidated from [Issue #139](https://github.com/elisa-tech/wg-aerospace/issues/139):

### ELISA Research

- [Minimum Linux Requirements for Executing a Minimal Application](https://github.com/elisa-tech/wg-lfscs/blob/main/lfscs-meetings/resources/Minimum_Linux_Requirements_for_Executing_a_Minimal_Application.md) — study with kernel config
- [Minimal program trace (ELISA scenario)](https://github.com/elisa-tech/wg-lfscs/tree/main/min_prog_trace#elisa-scenario) — minimal program used in the study
- [LFSCS meeting resources](https://github.com/elisa-tech/wg-lfscs/tree/main/lfscs-meetings/resources) — detailed minutes on minimal app topics
- [kconfig-safety-check](https://github.com/elisa-tech/kconfig-safety-check) — ELISA tool for safety configuration (more cyber/quality focused than DO-178C, but useful reference)
- [Stack memory management by Linux kernel](https://github.com/elisa-tech/wg-lfscs/blob/main/Stack%20memory%20management%20by%20Linux%20kernel.md)
- [Kernel configurations for stack memory protection](https://github.com/elisa-tech/wg-lfscs/blob/main/kernel-configurations-for-stack-memory-protection.md)

### Boeing Research

- Original 5.x minimal configuration — [Boeing/linux@f5d4b42](https://github.com/Boeing/linux/commit/f5d4b42051b045fb667d69eeb0272a89dde6ba20) (see commit description for capabilities and limitations)
- 6.x minimal configuration (not finished, reference only) — [linux-6.14-not-finished.txt](https://github.com/user-attachments/files/25343272/linux-6.14-not-finished.txt)
- Additional research pending release

### Other References

- [Minimal buildroot aarch64-virt config](https://github.com/afbjorklund/minimal-buildroot/blob/main/board/qemu/aarch64-virt/linux.config) — not investigated against Boeing minimal config
- [Kernel config parser (rokc)](https://git.afnix.fr/rokc/rokc) — tool for analyzing kernel configs
- [Nix kernel config expression](https://github.com/elisa-tech/wg-aerospace/blob/c66da7a41bea478b34aef96db5a34d3e40b8381a/demos/AvioNix-demo/pkgs/minimal-linux-kernel.nix#L77-L196) — `nix build .\#minimal-linux-kernel.configfile`

### System Call / Application Dependency Tracing

- [Official doc — Workload tracing](https://docs.kernel.org/admin-guide/workload-tracing.html)
- [Discovering Linux kernel subsystems used by OpenAPS](https://elisa.tech/blog/2022/02/02/discovery-linux-kernel-subsystems-used-by-openaps/)
- [Discovering Linux kernel subsystems used by a workload (white paper)](https://github.com/elisa-tech/ELISA-White-Papers/blob/master/Processes/Discovering_Linux_kernel_subsystems_used_by_a_workload.md)
