<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Xen FuSa Architecture Requirements

The following requirements are extracted from the [Xen FuSa Software Architecture Document](https://gitlab.com/xen-project/fusa/fusa-docs/-/blob/master/architecture/README.md?ref_type=heads) (SAD), structured per ISO/IEC/IEEE 42010. The SAD is a work in progress; items marked "TBD" in the source are noted.

These requirements serve as ground rules for the [mixed criticality system design](xen-mixed-criticality-workshop.md) and the SoDev comparison within it.

## Reverse Engineering Considerations

Adopting upstream Xen contributions that were not developed with requirements presents a reverse engineering (RE) challenge under DO-178C and DO-248C. The recommended approach is a two-step activity:

1. **Establish forward-engineered baseline** — Apply FAA guidance on RE efforts (DO-248C FAQ #76 and related) to take ownership of existing code, deriving requirements, architecture, and traceability such that the result can be claimed as a forward-engineered artifact.
2. **Incremental change management** — For each subsequent upstream contribution, perform change impact analysis and apply the same RE discipline to the new portion, always maintaining a forward-engineered representation.

This topic requires further exploration to define specific process activities and acceptance criteria.

## Cross-Domain Process Mapping

The Xen FuSa effort spans multiple safety domains (avionics DO-178C, automotive ISO 26262, industrial IEC 61508). A dedicated artifact should explore:

- Shared process activities between automotive and avionics assurance levels
- Gaps where one domain requires activities not mandated by the other
- Which process activities are owned/controlled by the open-source community vs. adopting organizations
- How the overlapping artifacts tree (under active discussion by the Xen project) maps terminology across domains

The ISO side has a head start on this structure; see the [ELISA Seminar on Functional Safety with Xen, Zephyr, and Linux](https://elisa.tech/event/elisa-seminar-functional-safety-with-xen-zephyr-and-linux-for-avionics-automotive-and-industrial/) for the current framework.

## Requirement Quality Notes

> **Note:** These requirements are AI-derived from the Xen FuSa SAD and require refinement.
> A future planning document shall define the requirement authoring standard (consistent active voice, avoidance of ambiguity, verifiable language) and establish how ISO 26262 and DO-178C objectives overlap in this context.
> The actual requirements will be a combination of ISO and DO-178C that must be outlined in a planning document showing how they map together.

## Safety (S)

| ID  | Requirement                                                                                                                            | Source       |
| --- | -------------------------------------------------------------------------------------------------------------------------------------- | ------------ |
| S-1 | The architecture shall support the full safety criticality spectrum, up to DO-178C Software Level A, MIL-STD-882E LOR-1, or equivalent | Arch Drivers |
| S-2 | Each hypervisor component shall have an assigned design assurance level (see component table below)                                    | Logical View |
| S-3 | An Application/Product SAD shall reference the Xen FuSa SAD and specify how its capabilities are composed into a product design        | Introduction |
| S-4 | The Debug Interface shall be classified as Level E and shall be disabled or removed outside lab environments                           | Logical View |

## Hypervisor Component Levels

| Component              | Designed Safety Level | Elements                                | Description                                                |
| ---------------------- | --------------------- | --------------------------------------- | ---------------------------------------------------------- |
| Scheduling             | A / LOR-1 / ASIL-D    | Core, ARINC 653, NULL                   | Schedulers for domain execution (time partitioning)        |
| Boot & Configuration   | A / LOR-1 / ASIL-D    | Device Tree, Cmdline                    | Parses device tree to configure partitions during boot     |
| Debug Interface        | E / LOR-5             | Console, Trace                          | Console access; must be disabled/removed for certification |
| Interrupts             | A / LOR-1 / ASIL-D    | Time mgmt, IRQ mgmt (GIC/IOAPIC), MCE   | Manages events/interrupts for partitions                   |
| Privilege Mgmt         | A / LOR-1 / ASIL-D    | Hypercalls                              | Manages privilege levels and security policies             |
| Resource Allocation    | A / LOR-1 / ASIL-D    | Allocator, MMU, SMMU, Cache Mgmt, IOMMU | Allocates I/O and memory; enforces spatial partitioning    |
| User Domain Timers     | A / LOR-1 / ASIL-D    |                                         | Unprivileged partition timers                              |
| User Domain UART       | A / LOR-1 / ASIL-D    |                                         | Unprivileged partition UART interface                      |
| User Domain Interrupts | A / LOR-1 / ASIL-D    |                                         | Unprivileged partition interrupt/events                    |
| Physical Drivers       | A / LOR-1 / ASIL-D    | Timer, UART, PCI, Microcode/Firmware    | Hardware peripheral support                                |

## Partitioning (P)

| ID  | Requirement                                                                                                                                  | Source          |
| --- | -------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| P-1 | The hypervisor shall statically configure processor core execution time windows and memory per partition and shall enforce them at runtime   | Process View    |
| P-2 | Partitions shall not share resources by default; sharing shall be explicit via defined configuration                                         | Process View    |
| P-3 | Applications in partitions shall be designable independently and shall obtain acceptance without unintended dependencies on other partitions | Process View    |
| P-4 | A partition shall always receive its expected time without interference from other partitions                                                | Process View    |
| P-5 | A partition shall always receive its configured resources without interference from other partitions                                         | Process View    |
| P-6 | The hypervisor shall perform all partitioning operations; no other entity shall create or manage partitions                                  | Process View    |
| P-7 | The system shall not share I/O devices between partitions; I/O shall only be passed through to specific partitions                           | Deployment View |
| P-8 | Inter-partition communication shall use static shared memory regions configured via device tree (not dom0-based libvchan)                    | Deployment View |

## Scheduling (SC)

| ID   | Requirement                                                                                                                                                   | Source       |
| ---- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ |
| SC-1 | The hypervisor shall implement two-level scheduling: hypervisor-level partition time schedules (first level) and intra-partition scheduling (second level)    | Process View |
| SC-2 | The hypervisor shall provide ARINC 653 scheduling as a named scheduler option (alongside Core and NULL)                                                       | Logical View |
| SC-3 | The system shall establish partition scheduling at build time via configuration file; the scheduler shall be selectable at runtime but shall not be redefined | Process View |
| SC-4 | CPU time allocated to one partition shall not be preempted by another partition                                                                               | Process View |
| SC-5 | The system shall disable all unused processor cores                                                                                                           | Process View |
| SC-6 | The partition scheduling resolution shall be no less than 250 µs (context switch overhead)                                                                    | Process View |

## Multi-Core (MC)

| ID   | Requirement                                                                                                                            | Source       |
| ---- | -------------------------------------------------------------------------------------------------------------------------------------- | ------------ |
| MC-1 | The program shall identify, characterize, and bound all cross-core interference channels to ensure consistent WCET                     | Arch Drivers |
| MC-2 | The system shall exclusively allocate processor cache memory to processor cores via hardware, hardware partitioning, or cache coloring | Arch Drivers |
| MC-3 | The PSAC shall cover multicore certification aspects; the program shall show the final configuration executes as intended              | Arch Drivers |

## Fault Handling (F)

| ID  | Requirement                                                                                                                 | Source       |
| --- | --------------------------------------------------------------------------------------------------------------------------- | ------------ |
| F-1 | The system shall implement progressive fault handling at three levels: process (thread), partition, and module (hypervisor) | Process View |
| F-2 | The system shall mitigate and isolate a failure specific to a partition with no impact to other partitions                  | Process View |
| F-3 | Each partition-specific failure shall have an intentional propagation path defined                                          | Process View |
| F-4 | The system shall apply partition disable only for lower criticality partitions                                              | Process View |

## Fault Response Progression

| Response             | Description                                                   | Entry Criteria                                          |
| -------------------- | ------------------------------------------------------------- | ------------------------------------------------------- |
| Partition WARM Start | Reinitialize partition memory; preserve shared memory regions | Software exception not handled by process error handler |
| Partition COLD Start | Reinitialize partition memory; no state preservation          | Max WARM starts exceeded within 60s window              |
| Partition Disable    | Disable partition for remainder of run                        | Max COLD starts exceeded (lower criticality only)       |
| Module Reset         | Full reset (limited HW tests if in-the-air)                   | Multiple partition COLD starts within short window      |

## Configuration (C)

| ID  | Requirement                                                                                                                                       | Source                        |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------- |
| C-1 | The system shall use separately loadable configuration files (read-only structured databases) for runtime software variation, read during startup | Implementation View           |
| C-2 | The PSAC shall define all architecture PDIs per DO-178C Section 4.2j                                                                              | Implementation View           |
| C-3 | The system shall disable bootargs for release; values shall be provided via PDI instead                                                           | Implementation View           |
| C-4 | The build system shall use Kconfig to tailor debug vs. release configurations                                                                     | Implementation View           |
| C-5 | A top-level device tree shall configure the hypervisor: partitions, scheduling, shared memory regions, and I/O assignments                        | Deployment View, Logical View |
| C-6 | Per-partition device trees shall configure each guest domain's view of resources                                                                  | Deployment View               |

## Inter-Partition Communication (IPC)

| ID    | Requirement                                                                                  | Source          |
| ----- | -------------------------------------------------------------------------------------------- | --------------- |
| IPC-1 | The system shall create static shared memory regions during OE Init                          | Deployment View |
| IPC-2 | The system shall configure IPC via device tree (top-level for Xen, per-partition for guests) | Deployment View |

## Boot and Modes (B)

| ID  | Requirement                                                                                                                                                                               | Source       |
| --- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ |
| B-1 | The system shall implement the following operational modes: Boot → OE Init → Operational (Partition Init → Partition Normal) → IBIT; a Faulted mode shall handle unrecoverable conditions | Process View |
| B-2 | The system shall only enter normal mode if the system configuration is valid, as validated by privileged code                                                                             | Process View |
| B-3 | A WARM start shall preserve persisted state data; a COLD start shall not preserve state data                                                                                              | Process View |

## Targets (T)

| ID  | Requirement                                                                                                                                                                        | Source          |
| --- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| T-1 | The architecture shall support ARM64, RISC-V, and x86_64                                                                                                                           | Logical View    |
| T-2 | The initial hardware computing platform shall be generic ARM64 QEMU (final platform TBD)                                                                                           | Deployment View |
| T-3 | The deployment view shall support: different criticality levels per hardware, redundant hardware / fault isolation zones, and dissimilar hardware for common mode error mitigation | Deployment View |

## Testing (TS)

| ID   | Requirement                                                                                                                                                            | Source     |
| ---- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- |
| TS-1 | The program shall employ three test frameworks: Ceedling (white box), GDB-based (white box against release images), and Xen Framework (black box with test partitions) | Multi-View |
| TS-2 | The program shall perform coverage testing using Clang source-based code coverage                                                                                      | Multi-View |
| TS-3 | The program shall perform Data Coupling and Control Coupling (DCCC) analysis at CSCI level                                                                             | Multi-View |
| TS-4 | The program shall perform multi-core partitioning analysis                                                                                                             | Multi-View |
