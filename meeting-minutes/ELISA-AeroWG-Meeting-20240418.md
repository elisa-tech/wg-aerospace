<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

![logo](logo_elisa_small.png )

## ELISA Aerospace Working Group

# Minutes

## 18 Apr 2024

---

# Agenda

- Roll Call
- Brief Notices
- Announcements
- Discussion on Features for Aerospace
- Survey White Paper (if time allows)
- Closing

---

# Roll Call

## Attended this meeting

- Olivier Charrier - Wind River
- Gaston Gonzalez
- Emmanuel Gravel - Skytrac
- David Graziano - Collins
- Matt Kelly - Boeing
- Merlin Kooshmanian - ESA
- Ivan Perez - NASA Ames
- Scott Salmon - Cesium
- Sam Thompson - Rapita
- Steve VanderLeest - Boeing
- Matt Weber - Boeing


## Attended recently in the past

- Steve VanderLeest - Boeing
- Olivier Charrier - Wind River
- Gaston Gonzalez
- Emmanuel Gravel - Skytrac
- Martin Halle - Hamburg University of Technology
- Abdi Kitesa
- Matt Kelly - Boeing
- Merlin Kooshmanian - ESA
- Lenka Koskova - TUL CZ
- Rajesh Kurapati - KMC
- Joseph Lee - Skytrac
- Qasim Majeed - Siemens
- Gabriele Paoloni - Red Hat
- Justin Pearson - Lynx Software
- Ivan Perez - NASA Ames
- Piotr Skrzypek - ESA
- Sam Thompson - Rapita
- Steve VanderLeest - Boeing
- Matt Weber - Boeing
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

## Mandate

The Aerospace Working Group shall develop use cases to inform and influence Linux architecture and related tools, work to derive technical requirements for avionics operating systems, and seek to enhance and expand avionics software lifecycle processes, practices, and tools to enable use of Linux in avionics systems that are certified to high design assurance levels.

---

# Announcements

## Upcoming Events

- 11-12 June [Embedded Real Time Systems (ERTS)](https://www.erts2024.org/) in Toulouse, France
- 15-19 July [IEEE Space Mission Challenges for Information Technology](https://smcit-scc.space) in Mountain View, CA, USA
  - will include a workshop on open-source led by Ivan
- 29 Jul - 2 Aug [AIAA Aviation Forum](https://www.aiaa.org/aviation/presentations-papers/call-for-papers) in Las Vegas, NV, USA
- 1-3 Oct [IEEE Digital Avionics Systems Conference](http://dasconline.org/) in San Diego, CA, USA

## Published Articles

- HINT: See literature database! Any new papers will be archived there, too.

---

# Developing a Minimal, Community Linux Platform for Aerospace

- Scope for feature selection
  - Technical scope
    - Software
      - first, discuss kernel (try to finish, and only discuss broader distribution if necessary to make a decision about kernel)
        - subsystem by subsystem, by DAL
		- protocol stacks
      - second, full distribution (kernel, services, BSP/drivers, API, libraries, applications, bootloader, etc.)
	  - Decision postponed to after system architecture
    - Hardware
      - MMU as minimum?, multicore?, availability (physical or simulation at first), validation, crypto, etc.
	  - Decision postponed after system architecture
  - Certification scope 
    - Option A: Non-critical - discuss first, DAL-D and lower
      - Decisions about features to include at low DAL do not (necessarily) apply to high DAL
    - Option B: Mission-critical
      - Real-time
    - Option C: Safety-critical (DO-178C SWL-C or higher)
      - Real-time
    - Option D: Security-critical (DO-326A, DO-356A)
      - SAL may not follow DAL, but may actually need to be inverse
    - Agreed on a broader group: Option A
  - Location
    - Air
    - Space
    - Ground equipment - secondary discussion
	  - Agreed on a broader group: Exclude ground equipment in the first phase
- Use Cases
  - confirmed Option A for system architecture, option D for use case. 
  - Use case now moved to separate document [Aerospace-Uses-Cases](../docs/Aerospace-Uses-Cases.md)
  - Clarified: What about the other 2 votes (A and B), do we exclude people?
      - Option D is at least reasonable to pursue, perhaps others found another option more interesting, but we agree Option D will be pursued first. One of the votes last week for other options present again today agreed with this statement.
- Identification of features for use cases
- Mechanisms to configure features (include/exclude)
  - connection to partitioning
  - features that are included/excluded in a real-time aspect
  - different safety features that configured and are certified at different levels (e.g., DO-178C software level)
    - may exclude features, e.g., exclude any feature certified below DAL-B
- Maintenance and Support
  - Need to maintain for decades
- Tools
  - Identify features unique to aerospace, DO-330 qualification 

---

# Other business

  - Do we need to introduce a dictionary? One example of a question that was raised:
    - What is the understanding of "multiple functions"? -> 3 Answers with 9 people
      - 1) Multiple PCI devices SATA, USB, network etc.
      - 2) PCI devices with multiple functions, root bridge can have multiple functions
      - 3) System function perspective: Applications (processes, tasks, functions as S/W components) to achieve a system function like switch on cabin light (example: read sensor, log data, report failure, drive actuator)
	- **NEW**: Tend to a common understanding of 3)

---

# Closing

## Action Items

Located in [GitHub Issues](https://github.com/elisa-tech/wg-aerospace/issues)

## Round Table

- (Skipped due to time constraints)

