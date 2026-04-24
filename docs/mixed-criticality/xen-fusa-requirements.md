<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Xen FuSa Architecture Requirements

The following requirements are extracted from the [Xen FuSa Software Architecture Document](https://gitlab.com/xen-project/fusa/fusa-docs/-/blob/master/architecture/README.md?ref_type=heads) (SAD), structured per ISO/IEC/IEEE 42010. The SAD is a work in progress; items marked "TBD" in the source are noted.

These requirements serve as ground rules for the [mixed criticality system design](xen-mixed-criticality-workshop.md) and the SoDev comparison within it.

## Safety (S)

| ID  | Requirement                                                                                                                    | Source       |
| --- | ------------------------------------------------------------------------------------------------------------------------------ | ------------ |
| S-1 | Architecture supports the full safety criticality spectrum, up to DO-178C Software Level A, MIL-STD-882E LOR-1, or equivalent  | Arch Drivers |
| S-2 | Individual hypervisor components have assigned design assurance levels (see component table below)                             | Logical View |
| S-3 | An Application/Product SAD must reference the Xen FuSa SAD and specify how its capabilities are composed into a product design | Introduction |
| S-4 | Debug Interface is Level E and must be disabled or removed outside lab environments                                            | Logical View |

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

| ID  | Requirement                                                                                                                                   | Source          |
| --- | --------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| P-1 | Time and space partitioning: processor core execution time windows and memory are statically configured per partition and enforced at runtime | Process View    |
| P-2 | Partitions don't share resources by default; sharing must be explicit by defined configuration                                                | Process View    |
| P-3 | Applications in partitions can be designed independently and obtain acceptance without unintended dependencies on other partitions            | Process View    |
| P-4 | A partition shall always receive its expected time without interference from other partitions                                                 | Process View    |
| P-5 | A partition shall always receive its configured resources without interference from other partitions                                          | Process View    |
| P-6 | Partitioning is a privileged operation — only the hypervisor can create/manage partitions                                                     | Process View    |
| P-7 | No I/O devices are shared (paravirtualized) between partitions — only passed through I/O to specific partitions                               | Deployment View |
| P-8 | Static shared memory and event channels for inter-partition communication, configured via device tree (not dom0-based libvchan)               | Deployment View |

## Scheduling (SC)

| ID   | Requirement                                                                                                               | Source       |
| ---- | ------------------------------------------------------------------------------------------------------------------------- | ------------ |
| SC-1 | Two-level scheduling: hypervisor-level partition time schedules (first level) + intra-partition scheduling (second level) | Process View |
| SC-2 | ARINC 653 scheduling is a named scheduler option (alongside Core and NULL)                                                | Logical View |
| SC-3 | Partition scheduling is established at build time via configuration file; selectable at runtime but cannot be redefined   | Process View |
| SC-4 | CPU time allocated to one partition cannot be preempted by another partition                                              | Process View |
| SC-5 | All unused processor cores are disabled                                                                                   | Process View |
| SC-6 | Context switch overhead: safe to assume 250 µs partition scheduling resolution                                            | Process View |

## Multi-Core (MC)

| ID   | Requirement                                                                                                               | Source       |
| ---- | ------------------------------------------------------------------------------------------------------------------------- | ------------ |
| MC-1 | All cross-core interference channels must be identified, characterized, and bounded to ensure consistent WCET             | Arch Drivers |
| MC-2 | Processor cache memory is exclusively allocated to processor cores via hardware, hardware partitioning, or cache coloring | Arch Drivers |
| MC-3 | Multicore certification aspects are covered in the PSAC; program must show final configuration executes as intended       | Arch Drivers |

## Fault Handling (F)

| ID  | Requirement                                                                                      | Source       |
| --- | ------------------------------------------------------------------------------------------------ | ------------ |
| F-1 | Progressive fault handling at three levels: process (thread), partition, and module (hypervisor) | Process View |
| F-2 | A failure specific to a partition is mitigated and isolated with no impact to other partitions   | Process View |
| F-3 | A failure specific to a partition has an intentional propagation defined                         | Process View |
| F-4 | Partition disable is typically only for lower criticality partitions                             | Process View |

## Fault Response Progression

| Response             | Description                                                   | Entry Criteria                                          |
| -------------------- | ------------------------------------------------------------- | ------------------------------------------------------- |
| Partition WARM Start | Reinitialize partition memory; preserve shared memory regions | Software exception not handled by process error handler |
| Partition COLD Start | Reinitialize partition memory; no state preservation          | Max WARM starts exceeded within 60s window              |
| Partition Disable    | Disable partition for remainder of run                        | Max COLD starts exceeded (lower criticality only)       |
| Module Reset         | Full reset (limited HW tests if in-the-air)                   | Multiple partition COLD starts within short window      |

## Configuration (C)

| ID  | Requirement                                                                                                                   | Source              |
| --- | ----------------------------------------------------------------------------------------------------------------------------- | ------------------- |
| C-1 | Runtime software variation uses separately loadable configuration files (read-only structured databases), read during startup | Implementation View |
| C-2 | All architecture PDIs defined in the PSAC per DO-178C Section 4.2j                                                            | Implementation View |
| C-3 | bootargs may be used during development but must be disabled for release; values provided via PDI instead                     | Implementation View |
| C-4 | Kconfig used at build time to tailor debug vs. release configurations                                                         | Implementation View |

## Inter-Partition Communication (IPC)

| ID    | Requirement                                                                   | Source          |
| ----- | ----------------------------------------------------------------------------- | --------------- |
| IPC-1 | Static shared memory regions created during OE Init                           | Deployment View |
| IPC-2 | Event channels for signaling between partitions                               | Deployment View |
| IPC-3 | Both configured via device tree (top-level for Xen, per-partition for guests) | Deployment View |

## Boot and Modes (B)

| ID  | Requirement                                                                                                                           | Source       |
| --- | ------------------------------------------------------------------------------------------------------------------------------------- | ------------ |
| B-1 | Operational modes: Boot → OE Init → Operational (Partition Init → Partition Normal) → IBIT; Faulted mode for unrecoverable conditions | Process View |
| B-2 | System should only enter normal mode if system configuration is valid, validated by privileged code                                   | Process View |
| B-3 | WARM start preserves persisted state data; COLD start does not                                                                        | Process View |

## Targets (T)

| ID  | Requirement                                                                                                                                                           | Source          |
| --- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------- |
| T-1 | Architecture supports ARM64, RISC-V, and x86_64                                                                                                                       | Logical View    |
| T-2 | Hardware computing platform is TBD (generic ARM64 QEMU initially)                                                                                                     | Deployment View |
| T-3 | Deployment view supports: different criticality levels per hardware, redundant hardware / fault isolation zones, dissimilar hardware for common mode error mitigation | Deployment View |

## Testing (TS)

| ID   | Requirement                                                                                                                               | Source     |
| ---- | ----------------------------------------------------------------------------------------------------------------------------------------- | ---------- |
| TS-1 | Three test frameworks: Ceedling (white box), GDB-based (white box against release images), Xen Framework (black box with test partitions) | Multi-View |
| TS-2 | Coverage testing using Clang source-based code coverage                                                                                   | Multi-View |
| TS-3 | Data Coupling and Control Coupling (DCCC) analysis required at CSCI level                                                                 | Multi-View |
| TS-4 | Multi-core partitioning analysis required                                                                                                 | Multi-View |
