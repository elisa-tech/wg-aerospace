
![logo](logo_elisa_small.png )

## ELISA Aerospace Working Group

The Aerospace Working Group shall develop use cases to inform and influence Linux architecture and related tools, work to derive technical requirements for avionics operating systems, and seek to enhance and expand avionics software lifecycle processes, practices, and tools to enable use of Linux in avionics systems that are certified to high design assurance levels.  (https://lists.elisa.tech/g/aerospace)

# Minutes

## 7 August 2024

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
- David Graziano - Collins
- Martin Halle - Hamburg University of Technology
- Tim Bird - Sony
- Ramon Roche - LF
- Chuck Wolber - Boeing
- Matt Kelly - Boeing
- Justin Pearson - Lynx Software
- Jeannette Nounagnon - Boeing (Aurora)

## Attended recently in the past

- Anshul Makkar - Infinitedeth
- Ivan Perez - NASA Ames
- Piotr Skrzypek - ESA
- Merlin Kooshmanian - ESA
- Manuel Beltran - Boeing
- Paul Mani - Collins India
- Olivier Charrier - Wind River
- Qasim Majeed - Siemens
- Sam Thompson - Rapita
- Scott Salmon - Cesium
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

- 1-3 Oct [IEEE Digital Avionics Systems Conference](http://dasconline.org/) in San Diego, CA, USA
  - Call for 2025 papers ~Oct/Nov 2024 (Steve is General Chair for 2025 in Montreal)
- 3-8 Aug - Small Satellite Conference (https://smallsat.org/)
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

A past conference was mentioned (May 2024) - [Flight Software Conference](https://flightsoftware.org/workshop/FSW2024)

## Articles / Publications

See our [Literature Database](../literature-database/literature.bib)

See our [Draft(April 18th, 2024 revision) Whitepaper](../docs/20240418_ELISA_AeroWG_Whitepaper.pdf)

---
---
# Technical Topics

## Old Business

### Space Grade Linux
- 07/16 - Matt Weber met with Kate Stewart & Ramon Roche to discuss SMCIT conference and LXF plans for Space Grade work
  - (Kate's Action) schedule call with Michael and Ivan to discuss the following:  - DONE
    - interest survey
    - growing mailing list (inviting IEEE SMCIT)
    - Initial goals
  - future conference tracks for space / aero
- 07/24 - Matt Weber, Kate Stewart, Ramon Roche, Ivan Perez, and Michael Monaghan
  - Michael shared his initial goals for the Goddard research effort
  - interest survey and plan to publish after Aug 9th -- [Survey working doc](https://annuel2.framapad.org/p/xu58a5s8qj-elisa-aerowg-a8x2?lang=en)
  - Matt Weber will invite both mailing lists to next Aero call

### Linux Features for Safety-Critical Systems (LFSCS)

(Email sent on 7/16 to mailing list) https://lists.elisa.tech/g/linux-features/topic/questions_from_the_aero_wg/107253914

- How is the topic space being organized (e.g., component/subsystem driven)?
- Can LFSCS present on the minimal kernel and emulation?  (Building a conversation towards "Could this be used for targeting our use case?")

  **(Alessandro shared some feedback on the thread linked above.)**

Alessandro has a example of subsystem tracing - https://lists.elisa.tech/g/linux-features/topic/meet_on_aug_6/107661288

## Discussion on Features for Aerospace

Continue the discussion series, now in a separate document:
[Aerospace-Uses-Cases](../Aerospace-Uses-Cases.md) -- [[Next steps]](https://github.com/elisa-tech/wg-aerospace/blob/main/Aerospace-Uses-Cases.md#foreseeable-next-steps-tbc-at-on-of-the-next-meetings)


---
---

# Closing

## Action Items

Located in [GitHub Issues](https://github.com/elisa-tech/wg-aerospace/issues)

## Round Table

