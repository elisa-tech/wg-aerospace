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

**Events**

- May 13th virtual seminar - <https://elisa.tech/event/elisa-seminar-functional-safety-with-xen-zephyr-and-linux-for-avionics-automotive-and-industrial/>
  - Debrief: How did it go? Feedback and next steps
    - It was good to get visibility to the progress so far
    - Informative on the topic
    - Workshop focus feedback
      - Can we go deeper on the artifacts
  - Intro to the deeper topics at -> June 9-11th London (virtual) workshop - <https://elisa.tech/event/elisa-workshop-london-2026/>
    - Workshop talk preparation status (Xen FuSa + Aerospace WG product definition)  https://github.com/elisa-tech/wg-aerospace/pull/177
- Nix overview - June 23rd (Erin + Wanja demo) - https://elisa.tech/event/elisa-seminar-avionix-infrastructure-as-code-for-linux-in-avionics/

**News on Industry Paper**

- Status update on paper progress
- Next call on May 28th - [Invite](https://elisa.tech/community/meetings/)
  - New target event / audience? (Space datacenters?)
  - Discussing doing a space topic or other focus
    - Space topics started to come up, do we build on those in a space paper or restructure our paper plan
  - Need examples of Linux use in products
    - Could look at security exploits and see what https://www.ioactive.com/ has looked at "hacking the flight deck" topics in the last ~8yrs
    - Ground based systems (DO-278) may have more examples as well
  - Review contributions

## New topics

Min main mailing list doesn't seem to send to all WG lists (I've heard two people missed so far that didn't get the invite/event emails)
- Any way for the https://elisa.tech/events/ to show up on the meeting calendar so you can get the invite / see the whole view?
- ACTION: Weber

Xen system reference
- As we have more people interested in this, do we:
  - See if [System WG](https://github.com/elisa-tech/wg-systems#elisa-example-system-documentation) is updating this?
  - Link to Xen FuSa's emulation targets (build on smoke tests)
  - Build on one of those with a concept

Use case demo team updates (from weekly calls since 4/9)

- cFS demo documentation progress ([PR #134](https://github.com/elisa-tech/wg-aerospace/pull/134))
  - Pawel/Ivan/Salim debugging session results
  - Makefile rollback to 23de7a8 (Ubuntu 22 working state)
  - U26 build status and permission issue fix
- Minimal Kernel Plan ([PR #179](https://github.com/elisa-tech/wg-aerospace/pull/179), [Issue #168](https://github.com/elisa-tech/wg-aerospace/issues/168))
  - Workflow captured, needs feedback
  - Reference material: [Minimal Kernel config issue #139](https://github.com/elisa-tech/wg-aerospace/issues/139) (Boeing research, ELISA LFSCS study, configs)
  - ACTION: in future call start going through tickets like [complexity](https://github.com/elisa-tech/wg-aerospace/issues/181) to add detail to make the ticket scope and technical approach clear.

**Future discussion**

SGL roadmap alignment

- Using a cFS image in an AeroWG demo (QEMU ARM64)
- Visibility to minimal kernel work
- Mixed criticality example for space in Xen workshop talk

GitHub PRs - https://github.com/elisa-tech/wg-aerospace/pulls

- [Mixed Criticality Material](https://github.com/elisa-tech/wg-aerospace/pull/177) - workshop support
- [GodelEDGE PR](https://github.com/elisa-tech/wg-aerospace/pull/148)

SystemsWG copilot monitoring Linux - Ivan example status?

??ACTION: Matt/Rob bring up the time ref/sync QEMU topic when we do the presentation (discussed in a 2025 demo call)
  - <https://github.com/elisa-tech/wg-aerospace/discussions/119#discussioncomment-15519103>

??ACTION: Matt invite Features WG group leads to discuss monitoring kernel (Ivan making example for discussion - 4/24 use case call)
  - https://lists.elisa.tech/g/linux-features/topic/monitoring_and_measuring/118537431


## Tasks until next meeting

- ACTION: Weber - Workshop talk preparation call (Xen + product definition)
- ACTION: Everyone - Review Mixed Criticality PR #177 for workshop
- ACTION: Everyone look at the Minimal kernel plan and comment
  - https://github.com/elisa-tech/wg-aerospace/issues/168
  - https://github.com/elisa-tech/wg-aerospace/pull/179

---

# Roll Call

## Attended this meeting
- Matt Weber - Boeing
- Martin Halle - Hamburg University of Technology
- Leonidas Kosmidis - Barcelona Supercomputing Center
- Pavel Wodnicki - 32bitmicro
- Piotr Skrzypek - ESA
- Rob Woolley - Wind River
- Shefali Sharma
- Don V Black
- Ivan Perez - KBR @ NASA

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