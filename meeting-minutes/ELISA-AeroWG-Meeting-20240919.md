<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

![logo](logo_elisa_small.png)

## ELISA Aerospace Working Group

The Aerospace Working Group shall develop use cases to inform and influence Linux architecture and related tools, work to derive technical requirements for avionics operating systems, and seek to enhance and expand avionics software lifecycle processes, practices, and tools to enable use of Linux in avionics systems that are certified to high design assurance levels. (<https://lists.elisa.tech/g/aerospace>)

# Minutes

## 19 September 2024

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
- Ramon Roche (LF)
- Martin Halle - Hamburg University of Technology
- Michael Monaghan (NASA Goddard)
- Tomas Novotny (Czech Aerospace Research Centre)
- Olivier Charrier - Wind River
- Paul Mani - Collins India
- Ivan Perez - NASA Ames
- Qasim Majeed - Siemens
- David Graziano - Collins

## Attended recently in the past

- Tim Bird - Sony
- Merlin Kooshmanian - ESA
- Rob Woolley (Wind River)
- Allen Brown (Odyssey Space Research)
- Christopher Heistand (Stoke Space)
- Chuck Wolber - Boeing
- Phaedrus Leeds (Aerospace Corp)
- Shefali Sharma
- Scott Salmon - Cesium
- Anshul Makkar - Infinitede
- Steve VanderLeest - Boeing
- Ramon Roche - LF
- Matt Kelly - Boeing
- Justin Pearson - Lynx Software
- Jeannette Nounagnon - Boeing (Aurora)
- Piotr Skrzypek - ESA
- Manuel Beltran - Boeing
- Sam Thompson - Rapita
- Gaston Gonzalez - VENG
- Emmanuel Gravel - Skytrac
- Abdi Kitesa
- Lenka Koskova - TUL CZ
- Rajesh Kurapati - KMC
- Joseph Lee - Skytrac
- Gabriele Paoloni - Red Hat
- Daniel Riechers - Collins (Security)
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

Checkout our [Aerospace working group](https://lists.elisa.tech/g/aerospace) page as part of the ELISA foundation. It includes a schedule of events, link to join the mailing lists, meeting minutes, and [seminar library](https://elisa.tech/seminar-series/).

## Upcoming Events

- 18-20 Sept [Linux Plumbers](https://lpc.events/)
  - [Safe Systems with Linux - Micro Conference](https://lpc.events/event/18/contributions/1663/) [Topics](https://lpc.events/event/18/sessions/187/#20240920)
    - Aspects of Dependable Linux Systems
    - Verifying the Conformance of a VirtIO Driver to the VirtIO Specification
    - ks-nav
    - Source-based code coverage of Linux kernel
    - BASIL development roadmap
    - Enabling tooling independent exchange of Requirements and other SW Engineering related information with the upcoming SPDX Safety Profile
    - Throwing Cinderblocks ad Safety Engineering
    - Improving kernel design documentation and involving experts
  - [Measuring and Understanding Linux Kernel Tests](https://lpc.events/event/18/contributions/1793/)
  - [Building for Safety in a Security and Feature Focused World](https://lpc.events/event/18/contributions/1745/)
- 1-3 Oct [IEEE Digital Avionics Systems Conference](http://dasconline.org/) in San Diego, CA, USA
  - Call for 2025 papers ~Oct/Nov 2024 (Steve is General Chair for 2025 in Montreal)
- 10-12 Dec - Hosted by NASA at Goddard Space Flight Center (TBD location to be set)
- 25th Feb in Karlsruhe, Germany - 7th Workshop on Avionics Systems and Software Engineering (AvioSE)
  - **(NEW) Call for Papers and further information on: <https://aviose-workshop.github.io/>**
- 24th-27th March in Seattle, WA - Flight Software Workshop

## Articles / Publications

See our [Literature Database](../literature-database/literature.bib)

See our [Draft(April 18th, 2024 revision) Whitepaper](../docs/20240418_ELISA_AeroWG_Whitepaper.pdf)

---

---

# Technical Topics

## Space Grade Linux (SGL)

- Survey: [Shape the Future of Linux in Space](https://lists.elisa.tech/g/aerospace/topic/help_shape_the_future_of/108506014)
- Review landing page content

## Discussion on Features for Aerospace

New CI project for AeroWG with the intent to showcase demos and other workflow examples - <https://gitlab.com/elisa-tech/aero-wg-ci>

- We looked at the other WG CIs and there was a question about the "Systems WG use case for Zynq, ie is it zephyr combined with linux on R5s or APUs? (monitor function)" - [MW] passed this on to Sudip Mukherjee who authored the CI pipeline.

In a prior meeting, we stopped at "use cases" and "System functional tests / measurement (blackbox)".

Continue the discussion series, now in a separate document:
[Aerospace-Uses-Cases](../docs/Aerospace-Uses-Cases.md) -- [[Next steps]](https://github.com/elisa-tech/wg-aerospace/blob/main/docs/Aerospace-Uses-Cases.md#foreseeable-next-steps-tbc-at-on-of-the-next-meetings)

[Collaboration doc](https://annuel2.framapad.org/p/xu58a5s8qj-elisa-aerowg-a8x2?lang=en)

---

---

# Closing

## Action Items

Located in [GitHub Issues](https://github.com/elisa-tech/wg-aerospace/issues)

## Round Table
