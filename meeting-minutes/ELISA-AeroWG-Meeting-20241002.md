<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

![logo](logo_elisa_small.png)

## ELISA Aerospace Working Group

The Aerospace Working Group shall develop use cases to inform and influence Linux architecture and related tools, work to derive technical requirements for avionics operating systems, and seek to enhance and expand avionics software lifecycle processes, practices, and tools to enable use of Linux in avionics systems that are certified to high design assurance levels. (<https://lists.elisa.tech/g/aerospace>)

# Minutes

## 02 October 2024

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
- Chuck Wolber - Boeing
- Christopher Heistand (Stoke Space)
- David Graziano - Collins
- Ivan Perez - NASA Ames
- Shefali Sharma
- Tim Bird - Sony
- Ramon Roche (LF)

## Attended recently in the past

- Martin Halle - Hamburg University of Technology
- Michael Monaghan (NASA Goddard)
- Tomas Novotny (Czech Aerospace Research Centre)
- Olivier Charrier - Wind River
- Paul Mani - Collins India
- Qasim Majeed - Siemens
- Merlin Kooshmanian - ESA
- Rob Woolley (Wind River)
- Allen Brown (Odyssey Space Research)
- Phaedrus Leeds (Aerospace Corp)
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

- 1-3 Oct [IEEE Digital Avionics Systems Conference](http://dasconline.org/) in San Diego, CA, USA
  - Call for 2025 papers ~Oct/Nov 2024 (Steve is General Chair for 2025 in Montreal)
- 10-12 Dec - Hosted by NASA at Goddard Space Flight Center (TBD location to be set)
- 25th Feb in Karlsruhe, Germany - 7th Workshop on Avionics Systems and Software Engineering (AvioSE)
  - **(NEW) Call for Papers and further information on: <https://aviose-workshop.github.io/>**
- 24th-27th March in Seattle, WA - Flight Software Workshop
  - Presentation only - submissions start ~Oct 14th (ends ~Dec)
  - This workshop drove some of the Space Grade Linux topics
  - Lessons learned / BOF-like with presentation
  - Christopher Heistand is chairing
    - [MW] **Ask Michael about proposing some talks. Status of RT primer with stats?? Maybe a combo of space and non-space perspective?** Chat with Kate?
- July 2025 - Space Mission Challenges for Information Technology Space Computing Conference IEEE (Pasadena, CA)
  - Workshops (deadline for submissions Fall 2024) and papers
  - **Do we want to propose a topic? Or a Space workshop at the event with ELISA topics?(ELISA was a sponsor in prior 2 yrs)**

## Articles / Publications

See our [Literature Database](../literature-database/literature.bib)

See our [Draft(April 18th, 2024 revision) Whitepaper](../docs/20240418_ELISA_AeroWG_Whitepaper.pdf)

---

---

# Technical Topics

## LPC outbrief

- **Videos (full length room videos) and slide links are under each of the talks "attachment" icons** - <https://lpc.events/event/18/timetable/#all>
- LLVMcov - Good talks and conversation with test and LLVM maintainers
- Linux Kernel design / req brainstorming (RT work being complete may be tech debt opportunity to look at testing... maybe even requirements/assertions)
  - Do req become part of the code?
  - Looking at templates for req/design approach to align tools and code updates
  - Drive better testing
- Runtime verification (model based) - Daniel B's work - <https://bristot.me/>
  - Looking for contributors
  - Ivan does formal verification at NASA
- Supporting benchmark ranges of results within a kunit/kselftest environment
  - Definition of reference values and how to relate everyone's special configuration (How do we do QA better?)
  - Everyone brings their thresholds and method of representing the values

## Space Grade Linux (SGL)

- Survey: [Shape the Future of Linux in Space](https://lists.elisa.tech/g/aerospace/topic/help_shape_the_future_of/108506014)
  - Feedback so far - we've got 7 responses, please SHARE it with your co-workers :-)
  - Marking push pending staff recovering from LPC
  - End date (not set yet)

## December 10-12 Workshop

- Topics/tracks
  - Linux real-time status
  - De-mystify standards and how they relate to products
  - Testing
  - Simulation
  - Development Environment primer, how to start
    - Tooling talk at ELCE about easier setup of Yocto [TB] - Alex K
    - KAS tool for managing layers / set up
    - What is our tool set suggestions from Aero/Space WGs? (What are we assembling for runtime scenarios?)
    - When Pokey vs move towards product
  - Functional hazard assessment overview
  - Notional space systems
    - What is required from the OS (i.e. if you are using a cFE vs F' vs .. etc on top)
    - cFE vs F' vs .. discussion on frameworks use (cert, how used, arch, comms) [Ivan? discuss more next time]
    - Boot needs?
  - Filesystem reliability
  - Embedded systems reliability (SEU impacts) - Goddard - NASA NEPP talk? [Christopher is checking]
- Who are our track leads?

## LFSCS: Randomization and the impact to safety

- Crypto lib from kernel is needed to run a program that "does nothing".
- Random function to set Kernel offset random, to make life harder for attackers.
  - Really useful in security. Different concern in safety.
- In higher level of safety (A/B in aerospace) to have predictable and testable behavior means heavier efforts to use random. It need to be easily verifiable on system level. There may be a tipping point in systems with less criticality where also security comes into picture as a stronger argument.
- Randomization makes the kernel allocation resource not predictable.
  - If we have a variety of different methods, it could be up to the provider of the system to use this.
  - Thread analysis and attack vectors analysis can show, if there is a randomization needed.
- Without randomization the claims on safety could become easier from technical perspective.
- Determinism is not possible for all cases. There are functions in kernel space (which can be mostly deterministic), but in user space they may not be deterministic.
- Key message to be carried: "You need to be careful, when using randomization. You need to explain how you handle it, when it is switched on."
  - You could also start testing with randomization switched off and check behavior and switch on later and run your tests.
- **Please respond also to Alessandro and the LFSCS what you think about randomization! Bring this forward in your working groups.**

ELISA kconfig safety suggestion is a big group of config options

- Do we create profiles that group "use cases" which drive config options?
- Do these profiles align to any of the standards levels/rigor?

How do we manage the knobs and what are defaults? [MW ask systems WG about components/elements documentation that already exists. ]

Chuck - Hazard drives software and security level of concern

## Discussion on Features for Aerospace

[STOPPED HERE]

In a prior meeting, we stopped at "use cases" and "System functional tests / measurement (blackbox)".

Continue the discussion series, now in a separate document:
[Aerospace-Uses-Cases](../docs/Aerospace-Uses-Cases.md) -- [[Next steps]](https://github.com/elisa-tech/wg-aerospace/blob/main/docs/Aerospace-Uses-Cases.md#foreseeable-next-steps-tbc-at-on-of-the-next-meetings)

[Collaboration doc](https://mensuel.framapad.org/p/elisa-aerowg)

---

---

# Closing

## Action Items

Located in [GitHub Issues](https://github.com/elisa-tech/wg-aerospace/issues)

## Round Table
