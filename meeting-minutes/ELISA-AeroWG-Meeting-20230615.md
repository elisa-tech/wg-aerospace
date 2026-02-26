<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

![logo](logo_elisa_small.png)

## ELISA Aerospace Working Group

# Minutes

## 6 June 2023

---

# Agenda

- Roll Call
- Brief Notices
- Announcements
- Mandate and Goals
- Work on Survey Paper
- Prepare Discussion Agenda
- Closing
  - Next Steps
  - Action Items
  - Round Table

---

# Roll Call

## Attended this meeting

- Matt Kelly - Boeing
- Martin Halle – TUHH
- Qasim Majeed
- Sam Thompson – Rapita
- Lenka Koskova – TUL CZ
- Sebastien Boria - Airbus
- Abdi Kitesa
- Wanja Zaeske - DLR
- Olivier Charrier – Wind River

## Attended in the past

- Steve VanderLeest – Boeing
- Sam Bristow
- Stefano Dell'Osa - Intel
- Shuah Khan – Linux Foundation
- Rajesh Kurapati - KMC
- Ulises V
- Richard Wagener
- Chuck Wolber – Boeing
- Jeremy York - Boeing

---

# Brief Notices

## Code of Conduct and Legal Notices

- ELISA Project meetings involve participation by industry competitors, and it is the intention of the Linux Foundation to conduct all of its activities in accordance with applicable antitrust and competition laws. It is therefore extremely important that attendees adhere to meeting agendas, and be aware of, and not participate in, any activities that are prohibited under applicable US state, federal, or foreign antitrust and competition laws.
  - [Linux Foundation Antitrust Policy](http://www.linuxfoundation.org/antitrust-policy)
- Email communication will be treated as documentation and be received and made available by the Project under the [Creative Commons Attribution 4.0 International License](http://creativecommons.org/licenses/by/4.0). Please refer to the ELISA Technical Charter section 7 subsection iv. for details.
- The discussions in these meetings are exploratory. The opinions expressed by participants are not necessarily the policy of the companies.
- No recordings of working group meetings are permitted. Special provisions may be arranged for recording in advance with explicit consent of the participants.
- The kernel and LF Code of Conduct applies to all communication with this project
  - [Linux Foundation Code of Conduct](https://www.linuxfoundation.org/code-of-conduct/)
  - Linux [Contributor Covenant Code of Conduct](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/code-of-conduct.rst)
  - Linux Kernel Contributor Covenant [Code of Conduct Interpretation](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/code-of-conduct-interpretation.rst)

## Mandate

The Aerospace Working Group shall develop use cases to inform and influence Linux architecture and related tools, work to derive technical requirements for avionics operating systems, and seek to enhance and expand avionics software lifecycle processes, practices, and tools to enable use of Linux in avionics systems that are certified to high design assurance levels.

## 2023 Goals

- Establishing our operations as a new working group
- Survey on the state of the art within aerospace on use of Linux and associated certification approach and equivalent Design Assurance Level (DAL)
- Identify the challenges to adopting Linux in aerospace
- Identify candidate use cases using Linux

---

# Announcements

- Next meeting is Thu 15 Jun 2023, Steve is away, so Matt will lead
- Stefano Stabellini talk on Xen Hypvervisior in Sept.

## Upcoming Conferences

- [Embedded Open Source Summit](https://events.linuxfoundation.org/embedded-open-source-summit/) - 27-30 June 2023
- [ELISA Berlin Workshop]
- [Digital Avionics Systems Conference](https://2023.dasconline.org/) - 1-5 Oct 2023
- [Aerospace TechWeek](https://www.aerospacetechweek.com/americas/) - 14-15 Nov 2023

---

# Features Required for Aerospace

A future discussion will cover "Features Required for Aerospace". Next steps are to create an agenda for the discussion (see below for start).

## Scope

- Discussion at this time
  - limited to aerospace (subsequent discussions may be broadened to other domains)
  - will be on an entire distribution (subsequent discussions may focus narrowly on the kernel)
  - will cover all criticality (software levels), but may sort answers by level
  - will we time limit each major section so that all are covered in first meeting, schedule subsequent meetings on narrower topics as needed

## What are the outcomes of discussion?

- List of features
  - Features that are essential to include
  - Features that are essential to remove (via configuration)
- Refinement of our Aerospace use-case
- Convergence of our focus
  - Focus on a single processor architecture?
- Next steps for our list of features
  - Convincing the Linux community to focus on these features, e.g., providing more comprehensive testing, architecture
  - Develop patch sets to make things more configurable to achieve our defined feature list
  - List to help us compare with other working group list of features
    - The differences in lists should be examined and may imply gaps

## Configuration

- How do we configure a subset of features with robust configuration management (e.g., kernel config files)
- What configuration of which features are supported according to what schedules
- How do de-risk (or even deactivate) those not needed?
- Do we configure via kernel config, via yocto recipe, something else?
  - May be able to derive a aero-specific kernel config
- How do we minimize variation from the vanilla kernel to avoid increase maintenance?

## Method of identifying features

- Driven by use cases
- What are the criteria for inclusion of features?

## Features identification

- What features must be supported?
- Obtaining necessary and sufficient timing and precision
- List of system functions that must be able to run and their requirements
- Supported I/O
- What resources must be available for which criticality levels
- Ensure we document the rationale for including/excluding
- Should we classify features in some way?
  - Kernelspace vs. userspace?
  - Safety vs. other?

# Discussion Notes

- Project working on distribution for CubeSat projects
  - Working on requirements for over a year
- Do we need to focus on specific architectures?
  - Avoid complex processors that increase interference concerns
  - Eliminate processor based on power requirements
- Space case
  - Combination of ARM Cores + Microcontroller
  - Linux is not responsible for the mission critical part
- Refining the use case
  - Agree on a single architect that has existing pedigree?
    - PPC?
  - Define whether we are running on a primary computing unit
  - Define whether we are running a virtualized/hypervisor environment
  - Our usecase should be target at getting Linux to DAL-C first
- Space case
  - Control of the spacecraft is done by "small" microcontrollers
  - These are running RTOS or baremetal
  - Linux is used for "payload" operations
- ESA Standards may not allow use of Linux for certain usecases
  - They are also fairly prescriptive rather than guideline
- Hypervisor (and type Type 1 vs. Type 2) is a critical feature to decide upon
- Transition from PPC to ARM happening actively
- Some interesting projects in the area MicroVM
  - Firecracker, Cata Container (from Intel)
- Usecase Vote
  - Space - XXX
  - Aerospace - XXXXXXXX
  - Ground Systems - XX
- Long-term support
  - May need to use this kernel for 30 years?
    - Civil Infrastructure Platform?
  - Kernel developers were night high on the idea of long-term maintenance
  - Hopefully can update the OS w/o updating the applications
    - Need a stable ABI/API for very long term
  - HW obsolescence can sometimes prevent upgrades of the kernel (MMU changes from 2.8->4.X)
- Deviation from the vanilla kernel will increase maintenance burden
  - Can we use eBPF to introduce specific features into the kernel?
- A natural tension between maintenance of removing features vs. need from complete structural coverage
- What features do we want?
  - Driver support
  - ABI Compatibility
  - Using existing SW
- What don't we want?
  - Complex behavior
    - Loading of kernel modules, adaptive scheduling, etc.
- Need to very explicitly know what we are including
- Very important we know specific configuration, modules, etc.
- Tool which gives a software bill of materials / dependency tracker
  - Yocto supports this
- Often discovered after long periods that we don't need features that people requested
  - Must document and trace the rationale for including
- Still in the brainstorming phase
  - Need to break into groups and start tackling concrete issues
  - Ensure we document these sub-group activities very well
- Features have been classified
  - Support for safety
  - The rest
  - Methods of including mixed-criticality is different between aerospace and automotive

---

# Closing

## Action Items

Located in [GitHub Issues](https://github.com/elisa-tech/wg-aerospace/issues)

## Round Table

---

# Future Discussion Topics

Rank-ordered discussion topics

- In progress
  - Survey paper
  - What features must be supported? How do de-risk (or even deactivate) those not needed?
- Future topics
  - Needs for compiling documentation (Shuah and Kate, starting with work from Medical Devices WG)
    - E.g., Tracing a workload, [Tracing With Ftrace: Critical Tooling For Linux Development](https://www.linuxfoundation.org/webinars/tracefs-the-building-blocks-of-linux-kernel-tracing-by-ftrace?hsLang=en)
    - [PATCH v3 docs: add workload-tracing document to admin-guide](https://lore.kernel.org/linux-doc/Y9nkqhAS6EW2Lu8Z@debian.me/T/#t)
  - Achieving high Design Assurance Level (DAL) DO-178C processes
  - Proving real-time performance
  - Aerospace use cases
    - Identify typical architectures and platforms for avionics
    - must clearly articulate expectations in order to make suggestions to other working groups (e.g., tools WG)
    - Candidates
      - [PX4 + Linux](https://auterion.com/drone-manufacturers/skynode/) - PX4 It can be on any Posix OS (including Linux)
      - [ARINC653 sim](https://github.com/aeronautical-informatics/apex-linux) - And there is our ARINC653 simulator using Linux Namespaces + CGroups
  - Tooling
    - What tool needs are unique to Aerospace?
    - Coordinating with Tools WG (not duplicating their work)
  - How to abstract OS behaviors needed for avionics and real-time safety-critical requirements.
    - Can I simulate (early) what I need from an OS and refine requirements.
    - For example, try something in hypervisor or formal language early.
  - Compare/contrast Linux approach to COTS avionics OS offerings
  - Terminology of partitions and ARINC 653 – do we see Linux as the partitioning environment itself or does it become a host OS within a partition?
  - The link between Linux support on top of architecture (especially the newest ones, such as RISC-V)
  - Support of mixed criticality for aerospace applications
