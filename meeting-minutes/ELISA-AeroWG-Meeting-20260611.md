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

**ELISA Workshop London (June 9-11) Debrief**

- How did it go? Feedback on Xen FuSa + Aerospace WG product definition talks
  - AI talks were interesting on the second day (sw lifecycle vs AI vs Human)
  - NVIDIA safe linux concepts
  - AMD and ELISA presented on mixed criticality using our [Mixed Criticality Material PR #177](https://github.com/elisa-tech/wg-aerospace/pull/177) material (was mostly a Automotive lifecycle talk but visually tied DO-178C lifecycle into that plan)
- Next steps from workshop discussions
  - TODO: share video links
  - Do we continue a SIG like event on mixed criticality?
    - How does certification or content work if you consider "certifiable" vs "certified"
      - Ivan mentioned NASA's structured approach to change/cfg mgmt
    - How does it tie to other ELISA efforts? Where does ELISA lighthouse overlap, etc
    - Send a doodle with time options

**Mailing list visibility issue** (carry-over from 5/14)

- Main mailing list not sending to all WG lists
- Any way for <https://elisa.tech/events/> to show up on meeting calendar?
- ACTION: Weber (status?)

**Xen system reference** (carry-over from 5/14)

- Check if [System WG](https://github.com/elisa-tech/wg-systems#elisa-example-system-documentation) is updating
- Link to Xen FuSa's emulation targets
- Build on one of those with a concept
- ACTION: TSC conversation

**News on Industry Paper**

- Content updates are ongoing
- Started to track actions with Github issues (feel free to add them if you'd like to track your actions this way)
  - [Example](https://github.com/elisa-tech/wg-aerospace/issues/205)
- New target event / audience decided?
  - Still working current papers, [please vote](https://github.com/elisa-tech/wg-aerospace/discussions?discussions_q=is%3Aopen+label%3Apublications) for interest on papers!
- Any new examples of Linux use in products to add to our lit list?

## New topics

**Use case demo team updates** (from weekly calls since 5/14)

- Demo video for LF blog post (5/22 call)
  - Cabin Lights basic demo recorded to cloud for Min/Maemalynn
  - ACTION: Blog and video feedback from LXF
- ELISA blog post - what do we want to do after the first one?
  - Future posts: all demos? What content/doc work needs to finish first?
  - Audience: Students (have students review before publish)
  - Discussion on ideas and environments to use
  - [Vote on ideas by clicking the up arrow to the left of the idea](https://github.com/elisa-tech/wg-aerospace/discussions?discussions_q=is%3Aopen+label%3Ademo+)

**Update related to cFS and HPSC**

- Ivan Perez (he's the NASA cFS HPSC Development Team Lead)
- Baseline freeze will now be every 2 months (cFS for HPSC)
- cFS general practice is to use a SDK (outside of a build system as it's more of a library)
  - SGL build path is proposed as a recipe
- Ogma/Copilot - general releases include package feed updates (delayed by a few weeks)
- **June 8-12** RISC-V Summit Europe
  - A mission using the HPSC will be presented - F Prime based + RTOS
- RTEMS, how do we encourage new HPSC development (where does it fit, drivers and other gaps where OSS could help)?
  - Starting a SBOM effort
  - WorldGuard clusters for chip partitioning
    - Where is Linux vs RTEMS better in this sort of architecture?
    - Does more than HPSC have this question, most likely any hypervisor scenario.
    - What's the blend and how do they interoperate (comms, time&space partition, etc)?
  - ACTION: ask as well in SGL (see what direction this takes, a talk or internal panel or?)

**Future discussion**

Presentation on - It might be worth doing some presentation or paper characterizing current Linux realtime capabilities.

- Informal overview of issues, especially integration with other RTOSes

**GitHub PRs** - <https://github.com/elisa-tech/wg-aerospace/pulls>

- [Mixed Criticality Material #177](https://github.com/elisa-tech/wg-aerospace/pull/177)
- [GodelEDGE PR #148](https://github.com/elisa-tech/wg-aerospace/pull/148)
- [Minimal Kernel Plan #179](https://github.com/elisa-tech/wg-aerospace/pull/179)

**Carry-over ACTIONs**

- ??ACTION: Matt/Rob bring up the time ref/sync QEMU topic when we do the presentation
  - <https://github.com/elisa-tech/wg-aerospace/discussions/119#discussioncomment-15519103>
- ??ACTION: Matt invite Features WG group leads to discuss monitoring kernel (Ivan making example)
  - <https://lists.elisa.tech/g/linux-features/topic/monitoring_and_measuring/118537431>
- ACTION: Weber - Fork force pushing permission issue - LXF support status?

## Tasks until next meeting

NDA'd QEMU

---

# Roll Call

## Attended this meeting

- Matt Weber - Boeing
- Daniel Riechers - Collins Aerospace
- Ivan Perez - KBR @ NASA Ames Research Center
- Ivan Rodriguez - Coros Space
- Martin Halle - Hamburg University of Technology
- Naga - Timesys/Lynx
- Pawel Wodnicki - 32bitmicro
- Rob Woolley - Wind River
- Tim Bird - Sony
- Brennan Hay - NASA

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
