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

# Events

See [docs/events.md](https://github.com/elisa-tech/wg-aerospace/blob/main/docs/events.md) for the full list.


# Agenda / Minutes

## Old topics

**Industry Paper Status** (carry-over)

- [Discord](https://discord.gg/zKS6auuCH) for collaboration
- [Work tickets](https://github.com/elisa-tech/wg-aerospace/issues?q=is%3Aissue%20state%3Aopen%20label%3Apublications)
- Pending feedback on paper-call cancellation (consolidate to one general call/month)
- Wed Aug 19th 10am central day light time (UTC-5)

**Linux Realtime Capabilities / PREEMPT-RT seminar** (carry-over)

- No feedback from list survey (per 8/7 use case call)
- Next steps: (Matt shared these ideas with RT team)
  - **Comparison scenario "Linux stable vs Xenomai/RTEMS" (jitter, porting)**
  - Embedded perspective: system tuning, real-time tooling, virtualized systems
  - Designing for I/O Drivers (multiple approaches to compare?)
- RTL User Forum before OSS Europe in October -> [link](https://events.linuxfoundation.org/open-source-summit-europe/features/co-located-events/#real-time-linux-user-forum)

**Carry-over ACTIONs from 7/9**

- ACTION: Add AvioNix seminar to register.md
- ACTION: Blog post opportunity (Nix for kernel tailoring/analysis) - ask Wanja in demo call
- ACTION: Matt - QEMU presentation (looking like fall)
  - ACTION: Weber - Invite others from SGL and AeroWG for QEMU presentation (Leonidas)

## New topics

**Blog post!** - https://elisa.tech/blog/2026/08/12/letting-linux-fly-first-steps-towards-using-linux-in-flight/

**GitHub PRs** - <https://github.com/elisa-tech/wg-aerospace/pulls>

- [#237](https://github.com/elisa-tech/wg-aerospace/pull/237) Update cFS demo to use Ogma 1.15.0 (DRAFT)
- [#234](https://github.com/elisa-tech/wg-aerospace/pull/234) Contributing.md: add guidance for AI-assisted contributions
  - Is there a model version requirement?
  - Clarification on content vs the action of committing?  Is this guidance for both or one of those activities?
- [#231](https://github.com/elisa-tech/wg-aerospace/pull/231) feat: add ARINC 615A Tool Suite
- [#179](https://github.com/elisa-tech/wg-aerospace/pull/179) Minimal linux kernel plan draft (DRAFT)
- [#177](https://github.com/elisa-tech/wg-aerospace/pull/177) Mixed crit workshop
- [#148](https://github.com/elisa-tech/wg-aerospace/pull/148) docs: add GodelEDGE onboard satellite AI inference product profile

**Use case demo team updates** (from weekly calls since 7/9)

- Ogma update
  - Draft PR: [Update cFS demo to use Ogma 1.15.0](https://github.com/elisa-tech/wg-aerospace/pull/237)
  - Version update plus cFS bump; 1 of 3 apps auto-gen, working on remaining two
  - ACTION: Matt to bring up in wkly call - Concept of auto-gen could be a blog post?
- cFS recipe on meta-sgl
  - [meta-aerospace repo](https://github.com/elisa-tech/meta-aerospace) created
  - PX4 moved to [separate repo](https://github.com/robwoolley/meta-px4) with on-target build workflow and Renode/QEMU hardware sim
    - Cross integration with cFS was mentioned (suggested to bring to SGL call)
  - PR open in new [ELISA meta-aerospace](https://github.com/elisa-tech/meta-aerospace/pull/4)
  - NEXT STEPS: Rob investigating workflow - SDK flow (Case 1): Package/build existing demo application
    - General drivers of cFS change/rebuild (monolith even on single app change)
      - Selecting apps
      - Selecting custom arch
      - Making changes to library set
- cFS on Minimal Linux
  - (We have the combination in a demo today, most like just a Kernel code reduction for this case)
  - Growing interest from NASA for a concept/demo
  - NEXT STEPS: Ivan checking NASA contribution opportunity to start capturing scenarios / use case details
    - Continue on meta-sgl work towards a demo with minimial concepts shown
  - Brainstorming
    - What about kernel space applications? Could cFS run kernel space?
    - Simple scenario

## Tasks until next meeting

---

# Roll Call

## Attended this meeting

- Matt Weber - Boeing
- Martin Halle - Hamburg University of Technology
- Michael Monaghan - NASA Goddard
- Brennan Hay - NASA
- Shefali Sharma
- Rob Woolley - Wind River
- Ivan Perez - KBR @ NASA Ames Research Center
- Subhajit Ghosh - Tweaklogic

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


---

See https://github.com/elisa-tech/wg-aerospace/blob/main/README.md for access to meeting minutes, events and other resources!**
