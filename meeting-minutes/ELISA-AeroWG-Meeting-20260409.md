<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

Link to contribute live to the Meeting Minutes:

- <https://hackmd.io/@AS9atTJpQgeXj_ICWAprZw/By850egu1g/edit>

Link to the Meeting's Zoom event:

- <https://zoom-lfx.platform.linuxfoundation.org/meeting/93217874199?password=0305e3a3-21c3-43a1-8369-d24c39334eec>

![logo](https://github.com/elisa-tech/wg-aerospace/blob/main/meeting-minutes/logo_elisa_small.png?raw=true)

## ELISA Aerospace Working Group

The Aerospace Working Group shall develop use cases to inform and influence Linux architecture and related tools, work to derive technical requirements for avionics operating systems, and seek to enhance and expand avionics software lifecycle processes, practices, and tools to enable use of Linux in avionics systems that are certified to high design assurance levels. (<https://lists.elisa.tech/g/aerospace>)

# Agenda / Minutes

## Old topics

Future presentations

- Xen seminar topic / UK workshop talk
  - Ayan and Weber plan to do a combined talk on Xen FuSa plus Aerospace WG product definition
  - TODO: ELISA Aerospace WG needs a product definition with Xen for mixed criticality, as it would ground the discussion and make it concrete. (Stefano / Weber)
    - ACTION: Weber to schedule a separate call to make the use case and profile - Ivan / Phillip (SysWG) / Leonidas / Martin
    - (Leonidas) Ref for mixed criticality (coming from cyber approach plus safety) - [Website](https://web.archive.org/web/20201230204424/https://h2020up2date.eu) [Reporting](https://cordis.europa.eu/project/id/871465/reporting). [Baseline Definition doc](https://web.archive.org/web/20201230204424/https://h2020up2date.eu/wp-content/uploads/2020/07/D2.2_Baseline-Definition_v1.0.pdf)
    - (Martin)Aerospace focus first for June but should extend to Space
      - Reliability case vs HA (which best showcases the problem space) - draw out the cases and see which first item to focus for workshop
    - Where does RTEMS fit within what environment with what services? (Could use as one of the mixed partitioning scenarios and outline an example workflow like AI processing for the workshop)
    - <https://www.zdnet.com/article/from-earth-to-orbit-with-linux-and-spacex/> - The Falcon 9's onboard operating system is a stripped-down Linux running on three ordinary dual-core x86 processors. The flight software itself runs separately on each processor and is written in C/C++. The Dragon spacecraft also runs Linux with flight software written in C++. (other commercial space rocket launches as well have followed a similar pattern)
  - TBD seminar series may still happen but ELISA Systems WG most likely leading
    - Automotive Grade Linux SoDev architecture
      - Where does this fit?
      - What other parts could we present on to grow understanding of the topic space? e.g., partition items, comm/ipc, standards
- Nix overview (re-present Lund talk) - Status: TSC proposed ELISA seminar dates: Tues May 5th, Wed May 6th, or Wed May 13th at 9am Central
- (Leonidas) Overview of QEMU + custom machine/board models - Status: May 8th (starting in Use case call) - ACTION: Invite others from SGL and AeroWG

**News on Industry Paper submission**

- Next steps for content?
- Setting up a recurring call (Tues 10am Central time, 5pm EU)
- See what we can do by 4/21 and make the call to submit/withdraw

## New topics

Use case demo team - Next steps on Minimal Kernel

- Planning ticket: https://github.com/elisa-tech/wg-aerospace/issues/168
- Brainstorming steps from use case call (20260327): establish builds, organize research, define product profile, start minimal kernel docs/requirements, build config, rehost cabin light demo

GitHub PRs - https://github.com/elisa-tech/wg-aerospace/pulls

- (new) docs: Basic demo update (from 3 to 4 Tmux panes) - https://github.com/elisa-tech/wg-aerospace/pull/171
- (new) docs: Update Dockerfile reference in EnvSetup.md - https://github.com/elisa-tech/wg-aerospace/pull/170
- GodelEDGE PR - https://github.com/elisa-tech/wg-aerospace/pull/148
- package cFS demo app in Nix - https://github.com/elisa-tech/wg-aerospace/pull/164

Brief discussion on other (closed & OSS) hypervisors

- Wind River Helix (HVP)
- QNX Hypervisor
- Greenhills tuMP
- LynxOS Linux653
- (OSS Kernel) Dornerworks seL4 Hypervisor, just finished a SBIR
- (OSS Kernel) Magnetite seL4 Hypervisor - https://sel4.systems/Foundation/Summit/2023/slides/day2-02-furgala.pdf
- (OSS) Bao - non-safety - https://github.com/bao-project/bao-hypervisor

Survey from an EU project deliverable: https://h2020up2date.eu/wp-content/uploads/2020/07/D2.2_Baseline-Definition_v1.0.pdf

Stoke - Linux running for Thruster SW?
- https://flightsoftware.org/workshop/FSW2023
- D3-10 Presentation from Stoke, slide 8: "The actual binary deployed runs on Linux", refers to their Thruster SW (https://drive.google.com/drive/folders/1nNjH_HzqC9-WqjC4M3cXSwRH2ixxXXlu)
  - Multi-level arch to address timing / constraints

## Tasks until next meeting

- ACTION: Matt - setting up call to work material for the workshop talk
- ACTION: Everyone look at the Minimal kernel plan and comment
- ACTION: Matt/Rob bring up the time ref/sync QEMU topic when we do the presentation (discussed in a 2025 demo call)
  - <https://github.com/elisa-tech/wg-aerospace/discussions/119#discussioncomment-15519103>
- ACTION: Matt invite Features WG group leads to discuss monitoring kernel (Ivan making example for discussion - 4/24 use case call)
  - https://lists.elisa.tech/g/linux-features/topic/monitoring_and_measuring/118537431

## Other topics / Parking lot

Presentations

- ISO26262 vs DO-330 tool certification (What about Space certifications/tools?) - TBD, need to regroup with person that originally requested.
  - https://gtd-gmbh.de/cat-a/
  - Gap analysis between ISO26262 and ECSS ESA-funded project
    - Presentation: https://indico.esa.int/event/552/contributions/11077/attachments/7092/12988/ASIL2ECSS_EDHPC_2025.pdf
    - Paper: https://ieeexplore.ieee.org/document/11325998/ (open access link to follow)
  - Matt: find RTCA committee link that did standards translation
- RTEMS (NASA presentation) we can get access to with details on certification impacts as part of a EU funded safety activity - mixed criticality workloads / HPSC as an example
- ISO vs ECSS gaps - https://indico.esa.int/event/552/contributions/11077/
- WASM presentation?
- Rust for safety?
- Experience with radiation testing on Linux
- (Related) (Ivan R) safety barrier concept to allow Linux + GPU to co-exist with safety functions (COTS incorporation):
  - Publication: https://ieeexplore.ieee.org/document/10396004/
  - Open access: https://upcommons.upc.edu/server/api/core/bitstreams/aa16766c-6c29-4891-83cb-8073ddcc5fea/content
  - Presentation: https://indico.esa.int/event/445/contributions/8413/

Topics

- Organizing around radiation testing with SGL

---

# Roll Call

## Attended this meeting

- Matt Weber - Boeing
- Ivan Perez - KBR @ NASA Ames Research Center
- Martin Halle - Hamburg University of Technology
- Shefali Sharma
- Leonidas Kosmidis (Barcelona Supercomputing Center)
- Brennan Hay - NASA
- Rob Woolley
- Pawl Wodnicki (32bitmicro)

## Attended recently in the past

[List](https://github.com/elisa-tech/wg-aerospace/blob/main/meeting-minutes/ELISA-AeroWG-Meeting-DATE_template.md#attended-recently-in-the-past)

---

# Announcements

- [Events](https://github.com/elisa-tech/wg-aerospace/blob/main/docs/events.md)

- [Resources](https://github.com/elisa-tech/wg-aerospace/blob/main/docs/resources.md)

- [Action Items](https://github.com/elisa-tech/wg-aerospace/discussions)

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
