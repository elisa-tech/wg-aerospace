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

**ELISA Workshop London (June 9-11) Debrief** (carry-over)

- Workshop material: <https://directory.elisa.tech/workshops/index.html#june-2026-london>
- [Poll for continuing the mixed criticality discussion](https://terminplaner6.dfn.de/en/p/a56b64ee888e0c0f528fc4aaa86ba5e7-1835668)
- Should we capture scenarios and use cases generally or treat this as a separate call?
  - Some interest keeping it here

**AvioNix Seminar Debrief** (June 23)

- Feedback from the group
  - demo call mentioned - technical deep dive, practical example tying Nix to AeroWG
- Video recording: <https://youtu.be/D8H4dBtKCYM>
- Seminar library: <https://elisa.tech/seminar-series/>
- Action: Add to our references like this talk in our register.md
- Action: Blog post opportunity (Nix for kernel tailoring/analysis)?
  - More advanced post, the story leading up to this (Ask Wanja in next demo call?)

**News on Industry Paper**

- Forming a separate [Discord](https://discord.gg/zKS6auuCH) and/or mailing list for collaboration
  - Action: If interestined, [vote if you think discord will work here](https://discord.com/channels/1389686660610134247/1521384252950712511/1521384256973049876)
- Pending feedback we were going to cancel the paper focused call the keep the invites simple with one general call a month
- [Currently work is represented in tickets](https://github.com/elisa-tech/wg-aerospace/issues?q=is%3Aissue%20state%3Aopen%20label%3Apublications)

## New topics

**Copilot via eBPF**

- NASA has a project looking into this
- If interested, reachout to Ivan

**Use case demo team updates** (from weekly calls since 6/11)

- Embedded cFS demo - Migrate to SGL
  - Pawel BSP status: [BeagleY-AI board config](https://github.com/elisa-tech/wg-aerospace/issues/228)
  - cFS/demo recipe addition to meta-sgl (Rob will walk through in 7/10 call)
  - Phase approach: Phase 1 (recipe in QEMU), Phase 2 (SDK build outside Yocto), Phase 3 (minimization/profiles)
- PhD thesis topics brainstorming (GPU safety, WCET, interference mgmt, partitioning)
- Blog post status
  - Updated draft from LXF marketing: <https://docs.google.com/document/d/1wh-UV0HaqnnQbdP7qGcR7SJOn62R570HHTBfbi7wcCs/edit?usp=sharing>

**RISC-V Summit Europe recap** (June 8-12)

- HPSC mission presented (F Prime based + RTOS)
- Any follow-up actions or contacts?

**Linux realtime capabilities presentation** (carry-over from 6/11)

- Proposal: Presentation or paper characterizing current Linux RT capabilities
  - Possible focus: Informal overview of issues, especially integration vs other RTOSes
- Do we want to invite someone from the RTL development team https://realtime-linux.org/development-teams/ to give ELISA a webinar?
  - If so, would someone be interested in helping facilitated this?
    - **Action: Depending on Qs below and examples, we probably need to draw a product scenario and pick a use case for the RTL talk to focus on?**
  - What are some questions tailored to ELISA/Aerospace needs?
    - Could be HPSC focused? (Brennan might have a contact we could coordinate with a JPL)
    - Linux and RTOS interop (e.g. how to they coexist? comms, health/state mgmt, ... )
      - POSIX RT assumptions / limitations (EL0 cases of inversion, inheritance)
    - Example: AI toolchains payload (Linux) vs command/control determinisum (RTEMS) - safety levels as well in play vs tech stack support
    - What does a full Linux scenario look like when Linux covers system requests of RTEMS?
    - Boot times? (sub sec cases for both RTEMS and Linux) - Linux with full prempt-RT, does that impact booting time and are there aspects of boot that wouldn't be determinisic?
  - Previous talks - Thomas https://youtu.be/o58ff38eD64?si=ult-C_OzyyYIXQUo
  - Previous talks - Sebastian https://youtu.be/Fea5XODLBM8?si=GHGOiqcoaO9VUYb6
- Note: Additionally, in case this is interest, here will be a RTL User Forum, the afternoon before OSS Europe in October https://events.linuxfoundation.org/open-source-summit-europe/features/co-located-events/#real-time-linux-user-forum. Now that PREEMPT-RT is upstreamed, a forum/dialogue between users and RTL experts will continuously advance real-time capabilities in the Kernel. A CFP will be coming to solicit speakers and session topics.

**RISC-V Microcontroller profile**

- If interested reach out to Leonidas
- Looking for OSS projects (RTOSs) and user feedback
- Meeting on Weds mornings

**GitHub PRs** - <https://github.com/elisa-tech/wg-aerospace/pulls>

**Carry-over ACTIONs**

- QEMU presentation
  - ACTION: Matt/Rob bring up the time ref/sync QEMU topic when we do the presentation
    - <https://github.com/elisa-tech/wg-aerospace/discussions/119#discussioncomment-15519103>
  - ACTION: Weber - Invite others from SGL and AeroWG for QEMU presentation (Leonidas)

## Tasks until next meeting

---

# Roll Call

## Attended this meeting

- Matt Weber - Boeing
- Martin Halle - Hamburg University of Technology
- Subhajit Ghosh - Tweaklogic
- Sandipan Ghosh
- Rob Woolley - Wind River
- Pawel Wodnicki - 32bitmicro
- Ivan Perez - KBR @ NASA Ames Research Center
- Brennan Hay - NASA
- Leonidas Kosmidis - Barcelona Supercomputing Center
- Hihara Hiroki

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