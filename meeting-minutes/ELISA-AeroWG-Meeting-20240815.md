<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

![logo](logo_elisa_small.png )

## ELISA Aerospace Working Group

The Aerospace Working Group shall develop use cases to inform and influence Linux architecture and related tools, work to derive technical requirements for avionics operating systems, and seek to enhance and expand avionics software lifecycle processes, practices, and tools to enable use of Linux in avionics systems that are certified to high design assurance levels.  (https://lists.elisa.tech/g/aerospace)

# Minutes

## 15 August 2024

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
- Merlin Kooshmanian - ESA
- Allen Brown (Odyssey Space Research)
- Christopher Heistand (Stoke Space)
- Chuck Wolber - Boeing
- Martin Halle - Hamburg University of Technology
- Michael Monaghan (NASA Goddard)
- Phaedrus Leeds (Aerospace Corp)
- Ramon Roche (LF)
- Shefali Sharma
- Tim Bird - Sony
- Scott Salmon - Cesium
- Ivan Perez - NASA Ames

## Attended recently in the past

- Anshul Makkar - Infinitede
- Steve VanderLeest - Boeing
- David Graziano - Collins
- Ramon Roche - LF
- Matt Kelly - Boeing
- Justin Pearson - Lynx Software
- Jeannette Nounagnon - Boeing (Aurora)
- Piotr Skrzypek - ESA
- Manuel Beltran - Boeing
- Paul Mani - Collins India
- Olivier Charrier - Wind River
- Qasim Majeed - Siemens
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

Checkout our [Aerospace working group](https://lists.elisa.tech/g/aerospace) page as part of the ELISA foundation.  It includes a schedule of events, link to join the mailing lists, meeting minutes, and [seminar library](https://elisa.tech/seminar-series/).  

## Upcoming Events

- 16-18 Sept [OSS Europe](https://events.linuxfoundation.org/open-source-summit-europe/) - Sessions to be published
  - [Linux in Space: Fault Detection, Recovery and Fault-Tolerant System Designs - Lenka Kosková Třísková & Lukas Mazl, Technical University of Liberec & Tomas Novotny, VZLU](https://sched.co/1ej1t)
- 18-20 Sept [Linux Plumbers](https://lpc.events/) - In-person tickets are sold out but virtual still has slots - Sessions to be published
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
- 24th-27th March in Seattle, WA - Flight Software Workshop

## Articles / Publications

See our [Literature Database](../literature-database/literature.bib)

See our [Draft(April 18th, 2024 revision) Whitepaper](../docs/20240418_ELISA_AeroWG_Whitepaper.pdf)

---
---
# Technical Topics

## Old Business

### Space Grade Linux (SGL)

- [Survey](https://docs.google.com/document/d/1f-UaWE0sWFUFtOmd7Rxkq5cbTTkjK-km-dEtP9DAo94/edit) feedback was great and a draft will be shared soon for review. [Michael is working edits from his site]
  - Michael suggesting additional audience within NASA for the BASIC survey
  - Format as survey monkey
  - Could also target feature surveys later to NASA/ESA

Updates from Michael
- NASA funded to work on a base Yocto distro this fall
  - Basic configuration running Core Flight software framework @ Goddard - https://github.com/nasa/cFS
    - cFS has a contributor model and agreements on Github
  - Porting some CF apps to support Linux (Apps target workstation to embedded and OS agnostic)
  - Surveying internal groups for CF expansion (kernel logging, container runtime, update approach, flash mgmt)
- Get to a base offering
- Navigating NASA's process to open source (Goddard specific but other locations have had success)
  - Meeting with Open source technologies officer (Stephen) - alignment on project and streamlining OSS process
  - Working to understand contribution vs collaboration as NASA
- Proposal submitted for 2025 related efforts
- RiscV targeted focus (using simulation/physical hardware)
- Could tie the SGL reference build into ELISA CICD
- Michael is going to share survey updates with the group **(ACTION)**

Plans for outreach material
- Michael's ppt could expand on
- Blurb to share with other groups - vision? & survey
- Landing page on ELISA webpage and update conversation to match under https://lists.elisa.tech/g/space-grade-linux **(ACTION)** Kate/Matt/Michael/Ramon - sort out details

Tim attended Linux4Space call - https://gitlab.com/linux4space  (https://linux4space.org/)
- meta layer for distro (not doing a full distro)
  - cubesat focused
  - libcsp - https://github.com/libcsp/libcsp

Libre Space Foundation - https://libre.space/ + https://www.facebook.com/librespacefoundation

Space Operating Linux - https://github.com/SOL-Space-Operating-Linux/meta-sol  (CH mentioned)
- Ideally pulled into part of SGL

Space-ros - https://github.com/space-ros/space-ros

Fprime - https://nasa.github.io/fprime/

Space hardware
- Jetson cubesat - https://github.com/antmicro/jetson-orin-baseboard
  - (https://designer.antmicro.com/welcome)
  - virtual hardware - https://designer.antmicro.com/projects/cubesat_edge_computing_system
- Simluation options?  (AeroWG had targeted this first in our use case)

Discussion around benefits of getting layers organized between parts of the stack. (Trying to identify to get feedback on layers as part of the survey.  i.e. which libs and frameworks.)

ESA
- LEON4(sparc) processor support for Linux with RTpatch - bsp/hw focused
  - Working towards next gen L5 riscV
- Ivan is willing to share survey around within the organization

Where / How do we document the best practice for applying a practice and sharing guidance?  reference impl, emulations, etc

Next time
- Share survey and then send out
- Review landing page content

## Discussion on Features for Aerospace

**STOPPED before this topic**

Last meeting we stopped at "use cases" and "System functional tests / measurement (blackbox)".

Continue the discussion series, now in a separate document:
[Aerospace-Uses-Cases](../docs/Aerospace-Uses-Cases.md) -- [[Next steps]](https://github.com/elisa-tech/wg-aerospace/blob/main/docs/Aerospace-Uses-Cases.md#foreseeable-next-steps-tbc-at-on-of-the-next-meetings)

[Collaboration doc](https://annuel2.framapad.org/p/xu58a5s8qj-elisa-aerowg-a8x2?lang=en)

---
---

# Closing

## Action Items

Located in [GitHub Issues](https://github.com/elisa-tech/wg-aerospace/issues)

## Round Table

