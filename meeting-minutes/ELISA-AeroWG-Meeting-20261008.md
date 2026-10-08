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

- SGL has created (5) RFCs to gain feedback on special interest groups
  - https://github.com/space-grade-linux/TSC/pulls
  - RFC-0001, Software-defined vehicle architecture for space systems: a working group to define an OS-agnostic, hardware-agnostic reference architecture for platforms hosting multiple isolated domains, starting from the AGL SoDeV role model.
  - RFC-0002, Radiation fault injection in CI: evaluate the fault injectors the community and upstream developers have built independently and recommend how SGL runs fault injection in CI, including whether to adopt one as a project-hosted tool.
  - RFC-0003, Hardware-in-the-loop testing in CI: we build images for real boards but boot none of them in CI, so this group recommends which boards, where they live, and how access works.
  - RFC-0004, Long-term support releases: define what an SGL LTS release is, its cadence, and its support window, given most of you told us in the interest survey that your systems outlive Yocto's four-year window.
  - RFC-0005, Certification baseline for downstream adopters: define what SGL provides to teams certifying products built on it, which standards to address first, and where the project stands on certifying the distribution itself.

- Real-time Linux project opportunities
  - RTL User Forum co-located event (afternoon before OSS Europe, Prague Oct 7-9)
  - Use Case Tracker: The project has launched a tracker to showcase the adoption and potential applications of PREEMPT-RT: https://realtime-linux.org/use-case-tracker/. If you know of any partners using PREEMPT-RT in production or for a PoC, please encourage them to submit their use case. You can share this blog post for additional details and context: https://realtime-linux.org/submit-your-preempt_rt-use-case-and-drive-real-time-linux-adoption/
  - Real-Time Linux User Forum: The inaugural forum will take place on Tuesday, October 6th, ahead of the Open Source Summit in Prague. You can view the agenda here: https://realtime-linux.org/event/real-time-linux-user-forum/. If you or your colleagues are attending OSS Europe, please consider adding this co-located event to your registration. We would love to see you there.
  - Ivan - Q?  How real-time is SpaceROS? What are the factors?
    - [ROS 2 Real-Time Working Group](https://ros-realtime.github.io/) - - [Github](https://github.com/ros-realtime)
    - Rob offered to see if they could present (seeking real-time experts)
  - If looking for training (Bootlin / Linutronix)
  - Martin - Q?  How about minimal jitter in comparison to others (experience: PREEMPT-RT is worse than Xenomai, for example, but still well feasible for several aerospace apps)
  - Keep in mind --> The doc gap, silicon / codebase / OS are all moving targets for 20+ years, so imagine what the LLVMs will tell you :-)
  - Rob: [A Guided Tour Through the PREEMPT RT castle – ELISA](https://elisa.tech/blog/2021/08/25/a-guided-tour-through-the-preempt-rt-castle/)

- LLVM Qualification Working Group - functional-safety review request -> <https://llvm.org/docs/QualGroup.html>
  - Reusable across IEC 61508, EN 50716, ISO 26262, IEC 62304, DO-178C/DO-330
  - Review of generic templates sought (esp. TPL-003, TPL-004) -> <https://github.com/llvm/llvm-wgs/pulls>
  - Relevant to evaluating GCC, QEMU, OpenFastTrace usage in Xen FuSa WG

- Xen Summit 2026 videos
  - Video links
  - Matt Weber can walk slides if there is interest -> [ARINC 653 on Xen - A Unikraft Safety Architecture](https://xensummit2026.sched.com/event/2RDrH/arinc-653-on-xen-a-unikraft-safety-architecture)
  - ACTION: Matt to work on [merging material supporting that talk](https://github.com/elisa-tech/wg-aerospace/pull/177)

**Status updates**

- Minimizing Linux ( + NASA interest in cFS on Minimal Linux)
  - [Starting point for kernel minimization effort - #257](https://github.com/elisa-tech/wg-aerospace/pull/257)
- Microchip - QEMU for HPSC
  - NDA access or binary release routes under discussion (see prior minutes)
- SEL4 on HPSC
  - ACTION: Brennan offered to ask Dornerworks to present
- Raphel interested in giving a Hypervisor talk
  - ACTION: Weber to ask Min about a seminar (email thread with Martin + Raphel started)

## New topics

- Oct 16th - QEMU presentation (Leonidas) in the use case call
  - ACTION: Matt to record

- JPL is researching adding copilot via eBPL
  - e.g., CoPilot injection of TSN pkt behaviors based on conditions

- Ogma - a tool to facilitate the integration of safe runtime monitors into other systems. Ogma extends Copilot, a high-level runtime verification framework that generates hard real-time C99 code - https://github.com/nasa/ogma/

**GitHub PRs** - <https://github.com/elisa-tech/wg-aerospace/pulls>

- [#257](https://github.com/elisa-tech/wg-aerospace/pull/257) Starting point for kernel minimization effort
- [#237](https://github.com/elisa-tech/wg-aerospace/pull/237) Update cFS demo to use Ogma 1.15.0 (DRAFT)
- [#231](https://github.com/elisa-tech/wg-aerospace/pull/231) feat: add ARINC 615A Tool Suite
- [#179](https://github.com/elisa-tech/wg-aerospace/pull/179) Minimal linux kernel plan draft (DRAFT)
- [#177](https://github.com/elisa-tech/wg-aerospace/pull/177) Mixed crit workshop
- [#148](https://github.com/elisa-tech/wg-aerospace/pull/148) docs: add GodelEDGE onboard satellite AI inference product profile
- [#68](https://github.com/elisa-tech/wg-aerospace/pull/68) Listen for messages to monitors coming from RAW sockets (DRAFT)

**Parking lot**

- Radiation testing - <https://github.com/elisa-tech/wg-aerospace/issues/151>
- Clean up landing page structure - <https://github.com/elisa-tech/wg-aerospace/issues/159>
- Further NASA flight support - <https://github.com/elisa-tech/wg-aerospace/issues/158>
- Python and Makefile structure - <https://github.com/elisa-tech/wg-aerospace/issues/157>
- [Mixed criticality discussions](https://terminplaner6.dfn.de/en/p/a56b64ee888e0c0f528fc4aaa86ba5e7-1835668)

## Tasks until next meeting

---

# Roll Call

## Attended this meeting

- Matt Weber - Boeing
- Martin Halle - Hamburg University of Technology
- Michael Monaghan - NASA Goddard
- Ivan Perez - KBR @ NASA Ames Research Center
- Shefali Sharma
- Nick Zajerko-McKee
- Hihara Hiroki
- Bob Pulju - Collins Aerospace
- Pedro Roque (Caltech)
- Rob Woolley - Wind River

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