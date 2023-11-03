![logo](logo_elisa_small.png )

## ELISA Aerospace Working Group

# Minutes

## 1 Nov 2023

Note: European Summer Time ended, but United States Daylight Saving Time has not yet. Thus the meeting time is shifted one hour early for those in Europe, just for this week.

---

# Agenda

- Roll Call
- Brief Notices
- Announcements
- Mandate and Goals
- Organize Notes on Features for Aerospace
- Work on Survey Paper
- Closing
  - Action Items
  - Round Table

---

# Roll Call

## Attended this meeting

- Matt Kelly - Boeing
- Ivan Perez - NASA Ames
- Chuck Wolber - Boeing
- Wanja Zaeske - DLR
- Nora Breitmoser-Widdecke - DLR
- Ulises Vega - Luxoft (but joined ELISA privately)

## Attended recently in the past

- Sebastien Boria - Airbus
- Sam Bristow
- Olivier Charrier - Wind River
- Stefano Dell'Osa - Intel
- Martin Halle - TUHH
- Shuah Khan - Linux Foundation
- Abdi Kitesa
- Lenka Koskova - TUL CZ
- Rajesh Kurapati - KMC
- Sam Thompson - Rapita
- Steve VanderLeest - Boeing
- Richard Wagener

---

# Brief Notices

## Code of Conduct and Legal Notices

* ELISA Project meetings involve participation by industry competitors, and it is the intention of the Linux Foundation to conduct all of its activities in accordance with applicable antitrust and competition laws. It is therefore extremely important that attendees adhere to meeting agendas, and be aware of, and not participate in, any activities that are prohibited under applicable US state, federal, or foreign antitrust and competition laws.
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

* Establishing our operations as a new working group
- Survey on the state of the art within aerospace on use of Linux and associated certification approach and equivalent Design Assurance Level (DAL)
- Identify the challenges to adopting Linux in aerospace
- Identify candidate use cases using Linux

---

# Announcements

## Recent Events

- Stefano Stabellini webinar on Xen Hypervisor for Safety-Critical Domains on ELISA Youtube channel](https://t.sidekickopen27.com/Ctc/RI+23284/cZw--04/JkM2-6qcW6N1vHY6lZ3kqW4GQ8GV7F5vbBW7V_pQp2lrM5tW5MQG4w5Wp4C9W23wbNC1t4g5SW1ndryk5BmgTmVbvF1z6L01wHW7ByzFd5BV5fTVp9P9t83S3WdW1KLzR03FWnsVW2WhGcg4MlcrNW3zmWb74js_ZWVy54w158j7RMW2zfRfZ9jxkyQVm3g2v3m5Q4mW6jcW708MpbgJW5rRvYd2Ff54xW8tsntp2JFXGsW5bL7rR1YlMFbW7pdcJF6l_t_ZW6c8DTQ3pC3D5W8nQgrR237VrqN2gwNvgcfKdRf39HkR404)


## Upcoming Events

- "The Road to Safe Space Exploration" - ELISA webinar. Due to technical difficulties, was cancelled on 11 Oct, now scheduled for 1 Nov
- 14-15 Nov 2023 [Aerospace TechWeek](https://www.aerospacetechweek.com/americas/) in Atlanta, US
- 27 Feb 2024 [AvioSE'24](https://aviose-workshop.github.io/) in Linz, Austria
  - Papers due 27 Oct 2023
- 29 Jul - 2 Aug 2024 [AIAA Aviation Forum](https://www.aiaa.org/aviation/presentations-papers/call-for-papers) in Las Vegas, US
  - Abstracts due 30 Nov 2023

---
# Logistics for "Features Required for Aerospace" Discussion

A future discussion will cover "Features Required for Aerospace". Next steps are to create an agenda for the discussion (see below for start).

## Scope

* Discussion at this time
  - address challenges in both ways: top-bottom and bottom-up approach in parallel to capture different views
    - is there a common, compatible use-case?
      - remotely piloted aircraft is similar and easier than manned aircraft
      - common ground/use-case: plattform deployable in several objects (e.g. flying helicopters on mars)
      - most simple functions max. DAL-C (DAL-D...)
  - limited to aerospace (subsequent discussions may be broadened to other domains)
    - may have different answers in aero compared to space
    - different regulations need to be considered, but can learn from each other
    - less complicated in space due to many aspects without human beings
  - covers features in an entire distribution (subsequent discussions may focus narrowly on the kernel)
    - setup a working group to continue Steves work on analysing and "stripping" the kernel?
    - octa project: provides pre-defined kernel images, e.g. "core-minimal" image (octa-project: not only kernel, also boot-loader)
      - Lenka could prepare a short presentation about the project and the work done there (1st of November)
      - white paper: Results after analysing the kernel
      - Linux is soft-realtime. Is that an issue?
        - Linux foundation is happy to implement things that make it hard real-time.
        - asks for examples why it is soft-real-time
        - suggestion: establish a round-table e.g. on Embedded Linux Conferences for this discussion
    - would it fit a use-case we have in mind?
  - covers all criticality (software levels), but may have different answers for different software levels
  - time limit each major section so that all are covered in first meeting, schedule subsequent meetings on narrower topics as needed

* how many meetings?
  * more than one?
* when do we schedule?
  * cautious of holidays coming up in Europe
* do we schedule these during our regular working group time slots?
  * yes same time slot for first overall meeting
  * allow for different time slots when splitting to sub-groups

## What are the outcomes of discussion?

- List of features
  - Features that are essential to include
  - Features that are essential to remove (via configuration)
- Methods for selecting features and evaluating the impact (e.g., DAL)
- Refinement of our Aerospace use-case
  - The use-case may help us concretely decide the features for the specified system functionality
  - focus first on applications that we all have in common
- Convergence of our focus
  - Focus on a single processor architecture?
- Next steps for our list of features
  - Convincing the Linux community to focus on these included features, e.g., providing more comprehensive testing, architecture
  - Develop patch sets to make things more configurable to achieve our defined feature list
  - List to help us compare with other working group list of features
    - The differences in lists should be examined and may imply gaps

- May ask group to vote on certain topics to quantify our mindset (to either show consensus or show diversity of opinion)
  - either vote during meeting or perhaps provide method of voting asynchronously (e.g., via "like" links)
  - You could nicely use "Google Forms" for polls (where the options are explained accordingly for those not present when the poll was created). Just in case Github does not provide something useful.

---

# Topics for "Features Required for Aerospace" Discussion

- Method of proceeding with identification of features
- Configuration of features (include/exclude)
  - connection to partitioning
  - features that are included/excluded in a real-time aspect
  - different safety features that configured and are certified at different levels (e.g., DO-178C software level)
    - may exclude features, e.g., exclude any feature certified below DAL-B
- Use Cases
- Maintenance and Support
- Tools


other ways to categorize:
- first look at kernel? Then go higher layers? kernel layer, services layer, application layer
  - where do drivers fit in discussion?
  - API for system applications (user level) - is that a feature?, e.g., ARINC 653
  -

- Multiple perspectives on where to start discussion
  - kernel/services/application
  - DAL level
  - use case
    - aero vs space

- Perhaps we have a matrix of the two dimensions above and walk through the intersections of those rows and columns


---

# Features Required for Aerospace: Method of proceeding with identification of features

## overall workflow notes

- Need to break into groups and start tackling concrete issues
- Ensure we document these sub-group activities very well

## Method of identifying features

- Driven by use cases
- What are the criteria for inclusion of features?
- Need to very explicitly know what we are including
- Very important we know specific configuration, modules, etc.
- Features have been classified
  - Support for safety
  - The rest
  - Methods of including mixed-criticality is different between aerospace and automotive
    - NASA has it's own standards as well (separate from aerospace and automotive)

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
- Do we need to focus on specific architectures?
  - Avoid complex processors that increase interference concerns
  - Eliminate processor based on power requirements
  - Transition from PPC to ARM happening actively
- Hypervisor (and type Type 1 vs. Type 2) is a critical feature to decide upon

## Use case identification

- Refining the use case
  - Agree on a single architect that has existing pedigree?
    - PPC?
  - Define whether we are running on a primary computing unit
  - Define whether we are running a virtualized/hypervisor environment
  - Our usecase should be target at getting Linux to DAL-C first
- ESA Standards may not allow use of Linux for certain usecases
  - They are also fairly prescriptive rather than guideline

---

# Features Required for Aerospace: Configuration of Features

- How do we configure a subset of features with robust configuration management (e.g., kernel config files)
- What configuration of which features are supported according to what schedules
- How do de-risk (or even deactivate) those not needed?
- Do we configure via kernel config, via yocto recipe, something else?
  - May be able to derive a aero-specific kernel config
  - Could create a linux-yocto-aero that is focused on aerospace such that it is a configuration option within Yocto
    - This would include defconfigs that are geared toward aerospace (and in particulart the identified use case)
- How do we minimize variation from the vanilla kernel to avoid increase maintenance?
  - Upstream as fast as possible (easier said than done)
  - In particular, contribute additional configuration options to enable making things smaller
- Examine the base Yocto image.bbclass and base.bbclass to understand what could be removed
  - Could (technically) get down to a single application + kernel
- Nix would be an alternative to Yocto for declaratively defining a small kernel

- What are the desirable features of Linux/Nix that drive us to use it as the base?
  - HW Support
  - Init Systems
  - Industry standard API!
- If you trim the kernel down so aggressively, do you still really have Linux?

- Is the combination of features exponential? How do we test and verify these combination?
  - Can we look at product line management to help with this?
  - Most important to show that a single configuration *can* work
  - Be very clear about what has been tested vs. not tested

---

# Features Required for Aerospace: Use Cases

Identify use case categories that require differentiated set of features

- Some interesting projects in the area MicroVM
  - Firecracker, Kata Container (from Intel)
- Use case Vote
  - Space - XXX
  - Aerospace - XXXXXXXXX
  - Ground Systems - XX
- Space case
  - Combination of ARM Cores + Microcontroller
  - Linux is not responsible for the mission critical part
  - Project working on distribution for CubeSat projects
    - Working on requirements for over a year
  - Control of the spacecraft is done by "small" microcontrollers
  - These are running RTOS or baremetal
  - Linux is used for "payload" operations

- Choice of architecture can effect testing
  - Some instructions don't exist on different architectures which can cause strange bugs
- Is there anything aiming to replace PPC?
  - There is a decent amount of interest around using RISC-V to create simple SoCs with rad hardening
  - Planned workshop around architectures for high-performance space computing (including RISC-V) in space around SMC/IT
  - Mars Helicopter is Linux-based on ARM Snapdragon
  - Extensive use of FPGAs in Space domain
    - FPGAs probably aren't part of this broader discussion since they typically aren't running an OS
- Do we expect hard-real time?
  - If we expect to support anything above SWL-D, then we must
  - Generally agreed we want to include hard-real time as part of the use case

---

# Features Required for Aerospace: Candidate Features

- What features do we want? Included
  - HW/SoC support in general (focus on specific use case)
  - Driver support
    - Mostly the primitive devices (UART, *simple* networking)
    - PCI/PCI-E
      - Could be excluded from the base case?
      - Probably hard to find a real world use-case that doesn't include it
      - Probably not possible to remove it either from the kernel
    - What is the minimal configuration for microVMs and how does that interface to the outside world?
    - What bus systems should be included/excluded?
  - ABI Compatibility
    - Ability to use existing SW
    - NASA has several open-source frameworks CFS, ROS2, fPrime that would be desirable to work
      - CFS has been certed to NASA NPR7150.2 Class A Class A
      - These could be valuable test cases 
  - Schedulers
    - SCHED_DEADLINE + CBS
    - Do we need to contribute a new scheduler?
      - There has been some work here, but unlikely to be merge upstream
      - There are issues with pure static scheduling (no response to events)
      - https://ieeexplore.ieee.org/document/7005306
      - https://dl.acm.org/doi/10.1145/2245276.2232037
      - https://linuxdevices.org/real-time-linux-gains-arinc-653-scheduler/
- What don't we want? Excluded
  - Complex behavior
    - Loading of kernel modules, adaptive scheduling, etc.
    - eBPF/BPF (for high assurance)
      - Used for runtime verification
      - Don't need this in the deploy system for run-time verification
    - cgroups/namespace (for high assurance)
      - Opposing view: You could use cgroups to provide time/space partitioning
    - kvm
      - Opposing view: You could use cgroups to provide time/space partitioning
      - Do we lose ABI compatibility from using kvm?
    - SELinux
      - Generally, agreed
    - Filesystems
      - Most would be trimed out
      - 1 for general purpose, 1 for small fixed flash?
  - Most of the schedulers
  - Various features that hinder determinism

// End discussion

---

# Features Required for Aerospace: Maintenance and Support

- Long-term support
  - May need to use this kernel for 30 years?
    - Civil Infrastructure Platform?
  - Kernel developers were not high on the idea of long-term maintenance
  - Hopefully can update the OS w/o updating the applications
    - Need a stable ABI/API for very long term
  - HW obsolescence can sometimes prevent upgrades of the kernel (MMU changes from 2.8->4.X)
- Deviation from the vanilla kernel will increase maintenance burden
  - Can we use eBPF to introduce specific features into the kernel?
- A natural tension between maintenance of removing features vs. need from complete structural coverage

---

# Features Required for Aerospace: Tools

- Tool which gives a software bill of materials / dependency tracker
  - Yocto supports this
- Often discovered after long periods that we don't need features that people requested
  - Must document and trace the rationale for including

---

# Survey Paper

[Survey paper](https://www.overleaf.com/project/63ee5a398ae14b0bad694e21)

- For section on Linux in federated: <http://www.boeing.com/commercial/aeromagazine/aero_23/EFB.pdf>

- Lead authors for sections
  - Motivation - Matt Kelly
  - Other Open Source RTOS - Martin Halle
  - Linux non-safety-critical in partitioned - Steve VanderLeest

- Ivan Perez Interesting in participarting 

---

# Closing

## Action Items

Located in [GitHub Issues](https://github.com/elisa-tech/wg-aerospace/issues)


## Round Table
