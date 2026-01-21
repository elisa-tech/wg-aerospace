<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

![logo](logo_elisa_small.png )

## ELISA Aerospace Working Group

The Aerospace Working Group shall develop use cases to inform and influence Linux architecture and related tools, work to derive technical requirements for avionics operating systems, and seek to enhance and expand avionics software lifecycle processes, practices, and tools to enable use of Linux in avionics systems that are certified to high design assurance levels.  (https://lists.elisa.tech/g/aerospace)

# Minutes

## 3 July 2024

---

# Agenda

- Roll Call
- Brief Notices
- Announcements
- Technical Topics
- Closing

---

# Roll Call

## Attended this meeting

- Matt Weber - Boeing
- Steve VanderLeest - Boeing
- Ivan Perez - NASA Ames
- David Graziano - Collins
- Piotr Skrzypek - ESA
- Merlin Kooshmanian - ESA
- Chuck Wolber - Boeing
- Manuel Beltran - Boeing
- Paul Mani - Collins
- Olivier Charrier - Wind River

## Attended recently in the past

- Anshul Makkar - Infinitedeth
- Qasim Majeed - Siemens
- Sam Thompson - Rapita
- Scott Salmon - Cesium
- Matt Kelly - Boeing
- Jeannette Nounagnon - Boeing (NEW)
- Gaston Gonzalez - VENG
- Martin Halle - Hamburg University of Technology
- Emmanuel Gravel - Skytrac
- Abdi Kitesa
- Lenka Koskova - TUL CZ
- Rajesh Kurapati - KMC
- Joseph Lee - Skytrac
- Gabriele Paoloni - Red Hat
- Justin Pearson - Lynx Software
- Daniel Riechers - Collins Aerospace
- Wanja Zaeske - DLR

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


---

# Announcements

Checkout our [Aerospace working group](https://lists.elisa.tech/g/aerospace) page as part of the ELISA foundation.  It includes a schedule of events, link to join the mailing lists, meeting minutes, and [seminar library](https://elisa.tech/seminar-series/).  

## Upcoming Events

- 15-19 July [IEEE Space Mission Challenges for Information Technology](https://smcit-scc.space) in Mountain View, CA, USA
  - will include a workshop on open-source led by Ivan
- 29 Jul - 2 Aug [AIAA Aviation Forum](https://www.aiaa.org/aviation/presentations-papers/call-for-papers) in Las Vegas, NV, USA
- 1-3 Oct [IEEE Digital Avionics Systems Conference](http://dasconline.org/) in San Diego, CA, USA

## Articles / Publications

See our [Literature Database](../literature-database/literature.bib)

See our [Draft(April 18th, 2024 revision) Whitepaper](../docs/20240418_ELISA_AeroWG_Whitepaper.pdf)

---
---
# Technical Topics

## Old Business

- Space Grade Linux action - Contacted Monaghan, Michael L. (GSFC-5870) <michael.l.monaghan@nasa.gov> to work on agenda and topics
  - Tentatively planning to have the first Aug WG session Space focused

- Do we need to introduce a dictionary? One example of a question that was raised:   Is this covered in another WG?
  - What is the understanding of "multiple functions"? -> 3 Answers with 9 people
    - 1) Multiple PCI devices SATA, USB, network etc.
    - 2) PCI devices with multiple functions, root bridge can have multiple functions
    - 3) System function perspective: Applications (processes, tasks, functions as S/W components) to achieve a system function like switch on cabin light (example: read sensor, log data, report failure, drive actuator)
  - Tend to a common understanding of 3)
  - [MB] data dict used as a alignment tool between development teams (i.e. header generation).  Also referenced as a glossary. (logical names / themes to expand on to code artifacts)
  - ACTION: Need to check with Martin. [IP] maybe the goal was term alignment as multiple teams have a different perspective.
  - ACTION: Move to Use case [Next steps](https://github.com/elisa-tech/wg-aerospace/blob/main/docs/Aerospace-Uses-Cases.md#foreseeable-next-steps-tbc-at-on-of-the-next-meetings)

- (ToDo) Check with Min/Kate for Automotive's approach for previous use cases.  "What is the feedback approach / rollout for the use cases?  Audience?"

- (ToDo) Use the mailing list to build a list of questions for a survey.  Questions would cover topics like what distro / Linux approach they are using and how they use it, compose it, and cfg they depend on, etc. - Used to drive our next use case and timeline.

## Linux Features for Safety-Critical Systems (LFSCS)
- Tiny Kernel and QEMU target - https://github.com/elisa-tech/wg-lfscs/blob/main/lfscs-meetings/20240611.md
- Link to Arch WG minutes & Minimal Application - https://github.com/elisa-tech/wg-lfscs/blob/main/lfscs-meetings/20240625.md

[SV] Definitely overlapping goals and a converged focus helps sustain the features needed collectively.

[CW] Application of safety eng against a subset.  

ACTION: How is the topic space being constrained (component/subsystem driven?)

ACTION:  Can LFSCS present on the minimal kernel and emulation?  (Building a conversation towards "Could this be used for targeting our use case?")


## Discussion on Features for Aerospace

Continue the discussion series, now in a separate document:
[Aerospace-Uses-Cases](../docs/Aerospace-Uses-Cases.md) -- [[Next steps]](https://github.com/elisa-tech/wg-aerospace/blob/main/docs/Aerospace-Uses-Cases.md#foreseeable-next-steps-tbc-at-on-of-the-next-meetings)


---
---

# Closing

## Action Items

Located in [GitHub Issues](https://github.com/elisa-tech/wg-aerospace/issues)

## Round Table

