<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Minimal Kernel Plan

Tracking issue: [#168](https://github.com/elisa-tech/wg-aerospace/issues/168)

This document organizes the minimal kernel work plan for the ELISA Aerospace Working Group. The goal is to establish a repeatable process for defining, building, measuring, and documenting a minimal Linux kernel configuration suitable for aerospace use cases — starting with the Cabin Lights demo targeting [Software Level D](../product-profiles.md#software-level-d).

## Progression of Work

### Phase 1 — Build and Measure (Complete)

| Step                           | Status  | Description                                                                                                       |
| ------------------------------ | ------- | ----------------------------------------------------------------------------------------------------------------- |
| 1. Establish builds            | ✅ Done | Nix-based kernel build in [AvioNix-demo](https://github.com/elisa-tech/wg-aerospace/tree/main/demos/AvioNix-demo) |
| 2. Measure SLOC and image size | ✅ Done | SLOC tooling via [elf-to-sloc (#115)](https://github.com/elisa-tech/wg-aerospace/pull/115)                        |

### Phase 2 — Workflow and Configuration (In Progress)

| Step                          | Status         | Description                                                                                                                                                     | Definition of Done                                                                                                 |
| ----------------------------- | -------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| 3. Document how to tailor     | 🔶 In progress | Get the practice solid so we can do the workflow. Martin starting notes in a PR.                                                                                | A documented, repeatable workflow for modifying kernel config, rebuilding, and measuring impact to SLOC/image size |
| 4. Define product constraints | 🔶 In progress | Use the Cabin Lights demo with [Product Profiles (SWL-D)](../product-profiles.md#software-level-d) to set specific constraints. Emulated (QEMU ARM64) to start. | Product profile mapped to kernel requirements; QEMU machine options documented                                     |
| 5. Organize prior research    | 🔶 In progress | Consolidate research from [Issue #139](https://github.com/elisa-tech/wg-aerospace/issues/139) into a usable starting configuration.                             | Research organized and assessed; starting kconfig identified                                                       |
| 6. Show current config state  | Open           | Pick an approach to represent the current configuration for the use case we already have (trimming activity).                                                   | Current config documented with intentional vs. implicit (dependency-driven) options identified                     |

**Key question:** Do we establish the workflow with an example solely, or tackle the larger challenge of a minimal kernel with background data? Decision: definitely a progression — need more stakeholders so we don't repeat history.

## Goals

### Goal 1 — Repeatable Workflow

Establish a documented, repeatable workflow for kernel minimization that a team could apply to any system scenario, BSP, hardware configuration, and product case.

**Definition of Done:** A team unfamiliar with the work can follow the docs to produce a minimal kernel config for a new use case.

### Goal 2 — Getting to a "Ready" State for Team Use

How does a team take the minimal kernel and prepare it for their specific product?

Reference pattern: RTEMS — [ESA RTEMS Qualification](https://rtems-qual.io.esa.int/)

- ESA [Category B (ECSS-Q-ST-80C)](https://ecss.nl/standard/ecss-q-st-80c-rev-1-software-product-assurance-15-february-2017/) — mission-critical software where failure could lead to loss of mission
- Roughly equivalent to DO-178C DAL B

**Definition of Done:** Documentation describes the steps from "minimal kernel exists" to "ready for product integration" including what a team needs to add (BSP, product-specific drivers, verification evidence).

### Goal 3 — Identifying Activated Code

Show how to identify the activated code in the kernel. ELISA did early research on trimming code for certification.

**Definition of Done:** Tooling and process documented for identifying which kernel code paths are exercised by a given use case.

### Goal 4 — Certification Level Progression

Use the minimal kernel to show the progression of certification levels — identify what's needed to move up from SWL-D toward higher levels.

- **[TRL](https://www.nasa.gov/directorates/somd/space-communications-navigation-program/technology-readiness-levels/) of components/frameworks/modules/drivers** — evidence must be documented for how to achieve the levels claimed. Could go formal like a [TRA](https://acqnotes.com/acqnote/careerfields/technology-readiness-assessment) review, or show how the claims have rigor.
- **[CMM](https://en.wikipedia.org/wiki/Capability_Maturity_Model) of process/practice** — drive toward higher TRL on the supporting approach.
- **DAL B requirements beyond DAL C:** Decision coverage, independence of verification, requirements-based testing at integration levels, full traceability.
- **DAL A requirements beyond DAL B:** MC/DC coverage, source-to-object code traceability, more stringent independence requirements.

**Definition of Done:** A table mapping certification level progression (SWL-D → C → B → A) to specific additional objectives, evidence, and process requirements.

### Goal 5 — Supporting Broader Certification Efforts

Provide structure to organize contributions and build evidence packages across separate efforts, supporting generically the certification work others may need to perform.

**Definition of Done:** Evidence package structure defined; contributions from multiple teams can be organized into it.

## Assumptions

### QEMU Machine Options (ARM64 virt)

Relevant QEMU options for the target emulated environment:

| Option                | Effect                                                  |
| --------------------- | ------------------------------------------------------- |
| `secure=on`           | Enable TrustZone                                        |
| `virtualization=on`   | Enable ARM Virtualization Extensions                    |
| `mte=on`              | Enable Memory Tagging Extensions (with MTE-capable CPU) |
| `highmem-*`           | Control high memory placement for devices, ECAM, MMIO   |
| `gic-version=2\|3\|4` | Select GIC type (affects max CPUs)                      |
| `iommu=smmuv3`        | Add system-wide IOMMU                                   |
| `acpi=on`             | Enable ACPI tables                                      |
| `cxl=on`              | Enable Compute Express Link                             |

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
