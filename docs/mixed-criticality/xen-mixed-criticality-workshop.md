<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->
<!-- markdownlint-disable MD013 -->

# Aerospace Xen Mixed Criticality System - Working Session

This document captures the working session to define an Aerospace Xen mixed criticality system example. The outcome is intended to support a talk at the [ELISA Workshop in London (June 9-11)](https://elisa.tech/event/elisa-workshop-london-2026/), co-hosted by Canonical.

This working session follows the same discussion rules and licenses as our other ELISA Aerospace Working Group calls.

## Workshop Talk — Slide Outline

Target: [ELISA Workshop in London (June 9-11)](https://elisa.tech/event/elisa-workshop-london-2026/)

1. **ASIL to DAL comparison** — Reuse/update slides from the [Munich workshop presentation](https://directory.elisa.tech/workshops/2025-11-Munich/2-9-Matt_Webber_-_Industry_Safety_Levels_vs_Aerospace_Use_Cases.pdf). Establish the mapping between automotive ASIL levels and aerospace DO-178C DAL/SWL for the audience.
2. **Static system concept and aerospace needs** — Lay out the basic concept: aerospace systems are statically configured, deterministic, and certified per configuration. Contrast with automotive's dynamic, updateable model. This frames _why_ the differences exist.
3. **Automotive SoDev as context** — Walk through the AGL SoDev architecture to establish common ground. Use the comparison table to help the audience understand the differences (not gaps — clarity of use, not alignment).
4. **Economics of Xen** — Why use Xen vs. other options (Jailhouse, BAFÖ, seL4, other hypervisors, or non-hypervisor approaches)? What does the open source safety ecosystem look like? Should the study of hypervisors be part of ELISA WG goals generally?
5. **Xen code acceptance and upstream sustainability** — Does Xen plan to have a code acceptance process and development practice that is upstream-accepted and practical for initial development and long-term support without creating a fork? Country of origin and legal considerations as part of code acceptance. _(Ayan action item)_
6. **Safety island vs. application cores** — Dedicated safety processor (R/M-core) supervising application cores. How does this map in automotive (SoC safety islands) vs. aerospace (watchdog/health monitor, lockstep cores)? Where does it sit relative to Xen — outside the hypervisor, or as a highest-privilege partition? _(Ayan action item)_
7. **Aerospace mixed criticality reference system** — Present the brainstorming diagram with all software elements and safety levels annotated (boot, housekeeping, partitions). Goal: safety certification in the context of a hardware environment.
8. **Common problem alignment** — 1. Fault management as an example of a problem that should be common across domains (automotive, aerospace, space). 2. Zephyr is willing to adapt process and practice to match safety plans, how does Xen view this?
9. **Reference system timeline and goals** — Timeframe for the reference system concept, next steps, and call for participation.

## Background

From the [April 9th AeroWG call](../../meeting-minutes/ELISA-AeroWG-Meeting-20260409.md), Ayan and Weber plan to do a combined talk on Xen FuSa plus Aerospace WG product definition. The working group identified the need for a concrete product definition with Xen for mixed criticality to ground the discussion.

Participants: Ivan, Phillip (SysWG), Leonidas, Martin, Weber (and others welcome)

Key points from the discussion:

- Aerospace focus first for June, but should extend to Space
- Reliability case vs HA — which best showcases the problem space? Draw out the cases and see which to focus on first for the workshop.
- Where does RTEMS fit within what environment with what services? (Could use as one of the mixed partitioning scenarios and outline an example workflow like AI processing for the workshop)
- Add a mixed criticality example for space (like SoDev) to the Xen workshop talk

## Goals

1. **Reference system concept by June workshop** — A defined mixed criticality partition layout with safety levels assigned, suitable for presentation and discussion. The diagram needs all software elements annotated with SWL (boot, hypervisor, each partition, housekeeping).
2. **Align common problems across domains** — Identify problems like fault management that should have common solutions across automotive, aerospace, and space. Zephyr is willing to adapt process and practice to match safety plans.
3. **Safety certification in context of a hardware environment** — The aerospace perspective on Xen use is certification within a specific hardware context, not abstract safety claims. Ground the dissimilar core concept on a specific platform: ZCU102 (from [SystemsWG demo](https://github.com/elisa-tech/wg-systems/blob/main/Documentation/xen-demo-zcu102/Readme.md))? Future RISC-V? ARM A+R cluster?
4. **Clarity of use between automotive and aerospace** — Use the SoDev comparison to help people understand the differences and why they exist, not to seek alignment but to provide clarity. ASIL to DAL comparison slide — update/reuse [Munich presentation](https://directory.elisa.tech/workshops/2025-11-Munich/2-9-Matt_Webber_-_Industry_Safety_Levels_vs_Aerospace_Use_Cases.pdf).
5. **Economics of Xen** — Why Xen vs. Jailhouse, BAFÖ, seL4, other hypervisors, or non-hypervisor approaches? Should hypervisor study be an ELISA WG goal?
6. **Xen code acceptance and upstream sustainability** — _(Ayan action)_ Does Xen plan to have a code acceptance process that is upstream-accepted and practical without forking? Include country of origin and legal considerations.
7. **cFS Software Bus bridging** — Define in the example how cFS messages cross domain boundaries via static shared memory + event channels (Req P-8, IPC-1 through IPC-3).

## Mixed Criticality — Brainstorming

The following is based on the [demo environments](../../demos/docs/embedded-environments/Readme.md). The example configurations build on the [standalone](../../demos/docs/embedded-environments/Standalone.md) Cabin Lights demo to show how it can be re-hosted into a partitioned Xen environment.

For reference, the published (simpler) configurations:

- [Basic Cabin Lights on Xen](../../demos/docs/embedded-environments/MixedFunctions.md#basic-cabin-lights)
- [cFS Cabin Lights on Xen](../../demos/docs/embedded-environments/MixedFunctions.md#cfs-cabin-lights)
- [cFS Cabin Lights w/ Ground Simulation on Xen](../../demos/docs/embedded-environments/MixedFunctions.md#new-cfs-cabin-lights-w-ground-simulation)

The following brainstorming diagram was created in Dec 2025 and updated during this working session:

![Mixed Criticality Brainstorming](../../demos/docs/embedded-environments/mixed-functions-brainstorming.drawio.svg)

> **Diagram action:** The diagram needs to show _all_ software elements in the system with safety levels noted — including boot software, housekeeping processors, and any other system-level software outside the partitions.

### Assumptions

Based on the [Xen FuSa architecture requirements](xen-fusa-requirements.md), the following assumptions apply to our mixed criticality system design:

1. **Xen native is the operating environment** — The hypervisor runs directly on hardware (Type 1). Xen components are designed to DO-178C Level A / LOR-1. Partitions inherit isolation guarantees from the hypervisor.
2. **Linux is at most SWL-D** — Linux partitions are constrained to Software Level D (or uncertified/Level E) in this reference system. Higher criticality workloads use RTEMS or bare-metal.
3. **RTEMS is SWL-B** — RTEMS partitions target Software Level B for safety-critical workloads. Bare-metal partitions may target Level A.
4. **The system is statically configured** — Aerospace systems are certified per configuration. Partition layouts, schedules, memory allocations, and I/O assignments are defined at build time and do not change at runtime. This is fundamentally different from automotive's dynamic model.
5. **I/O approach depends on safety level** — VirtIO (paravirtualized) is acceptable for SWL-D and below. For higher safety levels, I/O uses either passthrough or a client/server approach. The VirtIO Backend/Frontend in the brainstorming diagram is valid for the Linux (SWL-D) partitions.
6. **Inter-partition communication uses ARINC 653 ports over static shared memory + event channels** — Sampling and queuing ports provide the inter-partition communication model, configured via device tree at boot. The Comm App / Comm Driver pair in the diagram uses this mechanism to bridge cFS Software Bus messages across domain boundaries.
7. **ARINC 653 scheduling is available** — The hypervisor provides an ARINC 653 scheduler with major/minor frame model. Partition schedules are set at build time and cannot be redefined at runtime. _(Note: a privileged partition may optionally be granted the ability to switch between pre-defined schedules at runtime.)_
8. **Partitions are independent by default** — No shared resources unless explicitly configured. This simplifies the interference argument for certification.
9. **Fault isolation is per-partition** — Progressive fault handling (WARM → COLD → Disable → Module Reset). Lower criticality partitions can be disabled; higher criticality partitions cannot.
10. **Debug partition is included but marked lab-only** — Debug interfaces are Level E and must be disabled or removed for certification. The demo architecture includes a Debug partition for development and verification.
11. **Multi-core requires interference analysis** — All cross-core interference channels must be identified and bounded. Cache must be exclusively allocated per core (cache coloring). Dissimilar cores (A vs R) add analysis burden.

### Expanded Partition Layout

> Needs update based on diagram updates

The brainstorming diagram adds several elements beyond the published SVGs. The full partition layout is:

| Domain                         | OS / Runtime                   | Contents                                                                           | Notes                                                                        |
| ------------------------------ | ------------------------------ | ---------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| Dom !0 (Control Domain)        | Linux                          | VM Management & Monitoring, Kernel/Runtime                                         |                                                                              |
| Dom D (Driver/Hardware Domain) | Linux                          | Kernel, **VirtIO Backend**, **Ethernet** driver, IO interface                      | Explicit VirtIO backend placement and Ethernet driver in the hardware domain |
| Dom U (App Domain)             | Linux                          | Kernel, **VirtIO Frontend**, **Ethernet**, Light, Light Server, Light Switch       | Explicit VirtIO frontend pairing with the backend in Dom D                   |
| Dom U (App Domain)             | Linux + cFS                    | Light, Light Server, Light Switch Vehicle, **Comm App**, Kernel, **Shared Memory** | cFS middleware layer, Comm App for cross-domain messaging, Shared Memory IPC |
| Dom U                          | **Baremetal / Zephyr / RTEMS** | Light Switch Ground, **Comm Driver**, Runtime                                      | Multiple RTOS options, Comm Driver for datalink, bare-metal as an option     |
| Dom U _(brainstorm)_           | **RTEMS? Zephyr**              | **cFS**                                                                            | Second RTOS domain running cFS — shows cFS portability across runtimes       |
| Dom U _(brainstorm)_           | **Dissimilar**                 | "A vs R core on ARM multi-cluster same processor (big/little?)"                    | Dissimilar redundancy concept using heterogeneous cores on same SoC          |

Key architectural details visible in the brainstorming diagram:

- **VirtIO Backend/Frontend split** — The driver/hardware domain (Dom D) hosts VirtIO backends with Ethernet, while application DomUs run VirtIO frontends. This is the same pattern used in the SystemsWG ZCU102 demo and SoDev. VirtIO is acceptable for SWL-D and below (see Assumption 5); higher safety level partitions use passthrough or client/server I/O.
- **Comm App / Comm Driver pair** — A communication application in the cFS Linux domain paired with a Comm Driver in the RTOS domain, bridged via ARINC 653 sampling/queuing ports over shared memory. This maps cFS Software Bus messages to the inter-partition communication model (Assumption 6).
- **Multiple RTOS options** — The diagram explicitly questions Zephyr vs. RTEMS vs. bare-metal for the RTOS domains, and shows a second RTOS domain also running cFS.
- **Dissimilar redundancy** — A brainstorm note about using ARM big.LITTLE or A-core vs. R-core heterogeneous clusters on the same SoC for dissimilar execution environments. _(See Assumption 11 — requires interference analysis.)_

## SoDev Comparison — Automotive vs. Aerospace

The [AGL SoDev (Software Defined Vehicle) architecture](https://static.sched.com/hosted_files/ossjapan2025/d0/AGL%20Update%20Miner%20ALS%202025.pdf) ([project page](https://www.automotivelinux.org/announcements/sodev/)) provides the automotive reference for mixed criticality on Xen. The following is the SoDev architecture block diagram:

![AGL SoDev Architecture](https://www.automotivelinux.org/wp-content/uploads/sites/61/2025/12/image-1024x447.png)

_(Source: [AGL SoDev Announcement](https://www.automotivelinux.org/announcements/sodev/))_

The table below compares the automotive SoDev deployment against our aerospace brainstorming diagram, using the [Xen FuSa requirements](xen-fusa-requirements.md) as ground rules. The intent is to help people understand the differences and why they exist — not to seek alignment, but to provide clarity of use.

| Aspect                              | AGL SoDev (Automotive)                                                                                    | AeroWG Brainstorming (Aerospace)                                                                              | Status        | Notes                                                                                                                                                                                                                                                                                                                                                                       |
| ----------------------------------- | --------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- | ------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --- |
| Workload consolidation              | Multiple automotive workloads (Infotainment, Instrument Cluster, ADAS) on single SoC                      | Multiple aerospace partitions with different criticality levels (vehicle cFS, ground sim, RTOS light control) | ✅ Covered    | Multiple distinct criticality levels across domains                                                                                                                                                                                                                                                                                                                         |
| VirtIO                              | Standardized VirtIO interfaces across all domains                                                         | VirtIO Backend in Dom D, VirtIO Frontend in DomU, Ethernet driver pairing                                     | ✅ Resolved   | VirtIO is acceptable for SWL-D and below. Higher safety levels use passthrough or client/server I/O. Linux partitions (SWL-D) use VirtIO; RTEMS/bare-metal partitions use passthrough                                                                                                                                                                                       |
| RTOS integration                    | Zephyr as first-class domain                                                                              | Zephyr, RTEMS, and bare-metal all shown as options; second RTOS domain running cFS                            | ✅ Covered    | Multiple RTOS/runtime options                                                                                                                                                                                                                                                                                                                                               |
| Inter-domain communication          | VirtIO + communication buses between zones                                                                | Comm App / Comm Driver pair via ARINC 653 ports over static shared memory                                     | ✅ Covered    | ARINC 653 sampling/queuing ports over shared memory + event channels. Automotive uses dynamic buses; aerospace uses static device-tree-configured channels                                                                                                                                                                                                                  |     |
| Dissimilar / heterogeneous cores    | Implicit (different SoC targets)                                                                          | Explicit brainstorm: A vs R core, big.LITTLE, multi-cluster on same SoC                                       | ✅ Conceptual | Requires interference analysis per Xen FuSa (Req MC-1, MC-2)                                                                                                                                                                                                                                                                                                                |
| Safety island vs. application cores | Safety island (dedicated R/M-core) monitors application cores; common in automotive SoCs (e.g., NXP S32G) | Not yet addressed in brainstorming diagram                                                                    | ❌ Gap        | Aerospace has a similar pattern: a dedicated safety processor (or lockstep core) supervises application partitions. This may run outside Xen entirely (bare-metal watchdog) or as a highest-privilege partition. Needs a slide and diagram annotation. Relates to health monitoring in Xen FuSa (Req F-1 through F-4)                                                       |
| Container support                   | Linux Containers for in-domain app isolation                                                              | No container layer                                                                                            | ⬜ N/A        | Aerospace uses hypervisor-level partitioning per ARINC 653, not containers. Xen FuSa partitioning (Req P-1 through P-6) provides equivalent isolation                                                                                                                                                                                                                       |
| HMI / Display virtualization        | Unified HMI (multi-display from Panasonic)                                                                | No HMI layer                                                                                                  | ⬜ Different  | Aerospace display systems use ARINC 661 (Cockpit Display System) standard. Display servers (e.g., User Applications) render to display units via a defined widget protocol. This is a fundamentally different architecture from automotive HMI virtualization — displays are certified separately and communicate via ARINC 661 defined interfaces, not shared framebuffers |
| Hardware abstraction                | Cloud, QEMU, and real SoC targets                                                                         | QEMU only (with future hardware intent)                                                                       | 🔶 Partial    | Xen FuSa supports ARM64/RISC-V/x86_64 (Req T-1). Aerospace goal is certification in context of a specific hardware environment                                                                                                                                                                                                                                              |
| Cloud / CI integration              | Cloud-based dev, remote deployment, OTA                                                                   | Not addressed                                                                                                 | ⬜ Different  | Aerospace equivalent is dataload/fieldload (ARINC 615a) or ground-based update. OTA is not applicable for certified avionics. Configuration via PDI (Req C-1 through C-3)                                                                                                                                                                                                   |
| Safety framework                    | Collaborating with ELISA for future ASIL                                                                  | Linux at most SWL-D; RTEMS at SWL-B; bare-metal at SWL-A                                                      | ✅ Defined    | Key difference: automotive targets ASIL; aerospace targets DO-178C DAL/SWL. See [ASIL to DAL comparison slides](https://directory.elisa.tech/workshops/2025-11-Munich/2-9-Matt_Webber_-_Industry_Safety_Levels_vs_Aerospace_Use_Cases.pdf)                                                                                                                                  |
| Scheduling model                    | Linux CFS / container scheduling                                                                          | ARINC 653 time partitioning                                                                                   | ✅ Defined    | Xen FuSa provides ARINC 653 scheduling (Req SC-1 through SC-5). Aerospace requires deterministic, static schedules — fundamentally different from automotive's dynamic scheduling                                                                                                                                                                                           |
| Fault handling                      | Application-level                                                                                         | Progressive partition-level (WARM → COLD → Disable → Module Reset)                                            | ✅ Defined    | Common problem across domains. Xen FuSa provides the mechanism (Req F-1 through F-4). Zephyr willing to adapt process/practice to match safety plans                                                                                                                                                                                                                        |
| System configuration                | Dynamic, updateable at runtime                                                                            | Static, certified per configuration                                                                           | ⬜ Different  | Aerospace systems are statically configured at build time (Assumption 4). This is the fundamental architectural difference                                                                                                                                                                                                                                                  |
| Multi-SoC / Zonal                   | Zonal architecture across multiple SoCs                                                                   | Single SoC (but dissimilar core brainstorm hints at multi-cluster)                                            | 🔶 Partial    |                                                                                                                                                                                                                                                                                                                                                                             |
| Build system                        | Yocto-based integrated build for all domains                                                              | Separate builds (demo-cert-linux, demo-cert-xen) + Nix                                                        | ❌ Gap        |                                                                                                                                                                                                                                                                                                                                                                             |

## Additional Reference Material

### ELISA Systems WG Xen Demo

The Systems WG [Xen demo on ZCU102](https://github.com/elisa-tech/wg-systems/blob/main/Documentation/xen-demo-zcu102/Readme.md) demonstrates:

- Xen with Dom0 (Linux) + DomU guests (Zephyr, Apertis/Petalinux)
- Paravirtualized disk and network
- Passthrough of SD and NIC controllers
- QEMU-based alternative setup

### Mixed Criticality Research (UP2DATE)

From Leonidas — reference for mixed criticality coming from a cyber approach plus safety:

- [UP2DATE Project Website (archived)](https://web.archive.org/web/20201230204424/https://h2020up2date.eu)
- [CORDIS Reporting](https://cordis.europa.eu/project/id/871465/reporting)
- [Baseline Definition Document](https://web.archive.org/web/20201230204424/https://h2020up2date.eu/wp-content/uploads/2020/07/D2.2_Baseline-Definition_v1.0.pdf)

### Product Profiles

The AeroWG [product profiles](../product-profiles.md) provide context on the target system constraints and requirements for different aerospace software levels.

### Prior Research — Xen in Safety-Critical Systems

- [A Safe & Secure ARINC 653 Hypervisor (DornerWorks)](https://ieeexplore.ieee.org/document/7311411) — DornerWorks extensions to the open source Xen hypervisor targeting DO-178C Level A and Common Criteria EAL 6+ for security. ([ResearchGate](https://www.researchgate.net/publication/261240786_A_safe_secure_arinc_653_hypervisor))
- [DornerWorks — Xen Hypervisor Solutions](https://dornerworks.com/solutions/xen-hypervisor/) — Commercial mixed criticality demonstrations on Xilinx ZCU102 using Xen with isolation between safety-critical and non-critical workloads.
- [Xen Project's Progress Toward Safety Certification (ELISA Blog, 2024)](https://elisa.tech/blog/2024/07/10/xen-projects-progress-toward-safety-certification-stefano-stabellini-amd/) — Stefano Stabellini on Xen as a static partitioning hypervisor targeting ISO 26262 and IEC 61508 certification.
- [A Comprehensive Survey on the Use of Hypervisors in Safety-Critical Systems](https://www.researchgate.net/publication/369838231_A_Comprehensive_Survey_on_the_Use_of_Hypervisors_in_Safety-Critical_Systems) — Qualitative comparison of hypervisors developed or adapted for safety-critical embedded systems.
- [ELISA Seminar — Functional Safety with Xen, Zephyr and Linux](https://elisa.tech/event/elisa-seminar-functional-safety-with-xen-zephyr-and-linux-for-avionics-automotive-and-industrial/) — Ongoing work on functional safety capabilities for Xen alongside Zephyr RTOS and Linux in mixed criticality systems for avionics, automotive, and industrial domains.

### Prior Research — ARM Virtualization and Hypervisor Architecture

- [Dall & Nieh, "KVM/ARM: The Design and Implementation of the Linux ARM Hypervisor"](https://dl.acm.org/doi/10.1145/2541940.2541946) (ASPLOS 2014) — First full system ARM virtualization solution; provides baseline comparison showing Xen Type-1 provides stronger isolation than KVM's hosted model for safety-critical use.
- [Pinto & Santos, "Demystifying Arm TrustZone: A Comprehensive Survey"](https://dl.acm.org/doi/10.1145/3291047) (ACM Computing Surveys, 2019) — In-depth survey of TrustZone technology covering TEEs and hardware-assisted virtualization on ARM, including TrustZone-assisted hypervisors for mixed criticality.
- [Steinberg & Kauer, "NOVA: A Microhypervisor-Based Secure Virtualization Architecture"](https://dl.acm.org/doi/10.1145/1755913.1755935) (EuroSys 2010) — Microhypervisor architecture with TCB an order of magnitude smaller than Xen; establishes Xen Type-1 as the baseline for hypervisor security and isolation research.

### Prior Presentations

- [Industry Safety Levels vs Aerospace Use Cases (Munich 2025)](https://directory.elisa.tech/workshops/2025-11-Munich/2-9-Matt_Webber_-_Industry_Safety_Levels_vs_Aerospace_Use_Cases.pdf) — ASIL to DAL comparison
- [AGL SDV SoDeV Insights (Munich 2025)](https://directory.elisa.tech/workshops/2025-11-Munich/2-4-Naoto_Yamaguchi_-_AGL_SDV_SoDeV_Insights.pdf) — Similar mixed criticality with Xen concepts
- [ELISA Workshop Series (slides and recordings)](https://elisa.tech/workshop-series/)
