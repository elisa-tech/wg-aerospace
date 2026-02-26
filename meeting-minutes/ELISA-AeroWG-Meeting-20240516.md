<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

![logo](logo_elisa_small.png)

## ELISA Aerospace Working Group

# Minutes

## 16 May 2024

---

# Agenda

- Roll Call
- Brief Notices
- Announcements
- Space Grade Linux
- Discussion on Features for Aerospace
- Closing

---

# Roll Call

## Attended this meeting

- Martin Halle - Hamburg University of Technology
- Merlin Kooshmanian - ESA
- Ivan Perez - NASA Ames
- Scott Salmon - Cesium
- Matt Weber - Boeing
- Jeannette Nounagnon - Boeing (NEW)
- Gaston Gonzalez - VENG

## Attended recently in the past

- Steve VanderLeest - Boeing
- Olivier Charrier - Wind River
- Emmanuel Gravel - Skytrac
- David Graziano - Collins
- Abdi Kitesa
- Matt Kelly - Boeing
- Lenka Koskova - TUL CZ
- Rajesh Kurapati - KMC
- Joseph Lee - Skytrac
- Qasim Majeed - Siemens
- Gabriele Paoloni - Red Hat
- Justin Pearson - Lynx Software
- Daniel Riechers - Collins Aerospace
- Piotr Skrzypek - ESA
- Sam Thompson - Rapita
- Steve VanderLeest - Boeing
- Chuck Wolber - Boeing
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

## Upcoming Events

- 22 May [ELISA Seminar - Making Linux Fly: Towards Certified Linux Kernel](https://elisa.tech/event/elisa-seminar-making-linux-fly-towards-certified-linux-kernel/) Online - please register!
- 11-12 June [Embedded Real Time Systems (ERTS)](https://www.erts2024.org/) in Toulouse, France
- 15-19 July [IEEE Space Mission Challenges for Information Technology](https://smcit-scc.space) in Mountain View, CA, USA
  - will include a workshop on open-source led by Ivan
- 29 Jul - 2 Aug [AIAA Aviation Forum](https://www.aiaa.org/aviation/presentations-papers/call-for-papers) in Las Vegas, NV, USA
- 1-3 Oct [IEEE Digital Avionics Systems Conference](http://dasconline.org/) in San Diego, CA, USA

## Published Articles

See our [Literature Database](../literature-database/literature.bib)

---

# Space Grade Linux

If someone attends from the nascent Space Grade Linux initiative, ask them to introduce the initiative. Discuss peliminary ideas on pros and cons of the ELISA Aerospace Working Group acting as the host for this work, incorporating the work into our ongoing agenda.

- Scot Salmon: Introduction of Space Grade Linux initiative (approx. 15 people)
  - Reference design for Linux configuration that has been used in space already
  - Several appropriate space features have been implemented
  - White paper planned on topics:
    - Typical question that arise for the use of Linux in space
    - Reduce the amount of the work to be done
    - Explain experiences
  - Working group could act as initiative that provides to share steps
  - Join forces for this purposes with Space Grade Linux initiative
  - Help to make a product to be as applicable as possible to a broader range of space applications
  - Next Meeting: Discuss current state, how to join, what to expect, time-line
  - Action: Vote for date/time on a further discussion: <https://doodle.com/meeting/participate/id/erMpZqEd>

---

# Discussion on Features for Aerospace

Continue discussion series, now in separate document:
[Aerospace-Uses-Cases](../docs/Aerospace-Uses-Cases.md)

- Explaining the current state to new members
- Focussed on system architecture to answer open questions like wrt smart sensors
- Came up with a vote for (4 out of 6 voters, no strong arguments against this decision):
  - Option B:
    - Sensor + actuator on a general purpose computer as emulation (on non-Aerospace Linux)
      - Attention: This probably means no real-time OS on sensor / actuator side
    - Application computer w/ real-time Aerospace Linux running the system/cabin application(s)
- Updated the use-case document accordingly

---

# Other business

- Carried over from previous meeting...
  - Do we need to introduce a dictionary? One example of a question that was raised:
    - What is the understanding of "multiple functions"? -> 3 Answers with 9 people
      - 1. Multiple PCI devices SATA, USB, network etc.
      - 2. PCI devices with multiple functions, root bridge can have multiple functions
      - 3. System function perspective: Applications (processes, tasks, functions as S/W components) to achieve a system function like switch on cabin light (example: read sensor, log data, report failure, drive actuator)
    - **NEW**: Tend to a common understanding of 3)

---

# Closing

## Action Items

Located in [GitHub Issues](https://github.com/elisa-tech/wg-aerospace/issues)

## Round Table
