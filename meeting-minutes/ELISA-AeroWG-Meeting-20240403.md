<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

![logo](logo_elisa_small.png )

## ELISA Aerospace Working Group

# Minutes

## 03 Apr 2024

---

# Agenda

- Roll Call
- Brief Notices
- Announcements
- Discussion on Features for Aerospace
- Closing

---

# Roll Call

## Attended this meeting

- Martin Halle - Hamburg University of Technology
- Wanja Zaeske - DLR
- Ivan Perez - NASA Ames
- Matt Weber - Boeing
- Matt Kelly - Boeing
- Chuck Wolber - Boeing
- Piotr Skrzypek - ESA
- Merlin Kooshmanian - ESA
- Emmanuel Gravel - Skytrac
- Qasim Majeed - Siemens

## Attended recently in the past

- Steve VanderLeest - Boeing
- Olivier Charrier - Wind River
- Gaston Gonzalez
- Abdi Kitesa
- Lenka Koskova - TUL CZ
- Rajesh Kurapati - KMC
- Joseph Lee - Skytrac
- Gabriele Paoloni - Red Hat
- Justin Pearson - Lynx Software
- Ivan Perez - NASA Ames
- Qasim Majeed - Siemens
- Sam Thompson - Rapita
- Steve VanderLeest - Boeing

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

- 09-11 Apr [Embedded Week](https://www.embedded-world.de/) in Nuernberg, Germany
- 16-18 Apr [Aerospace Tech Week](https://www.aerospacetechweek.com/europe/) in Munich, Germany
- 23-25 Apr [Integrated Communications, Navigation and Surveillance](https://i-cns.org/) in Herndon, VA, USA
- 11-12 June [Embedded Real Time Systems (ERTS)](https://www.erts2024.org/) in Toulouse, France
- 15-19 July [IEEE Space Mission Challenges for Information Technology](https://smcit-scc.space) in Mountain View, CA, USA
  - will include a workshop on open-source led by Ivan
- 29 Jul - 2 Aug [AIAA Aviation Forum](https://www.aiaa.org/aviation/presentations-papers/call-for-papers) in Las Vegas, NV, USA
- 1-3 Oct [IEEE Digital Avionics Systems Conference](http://dasconline.org/) in San Diego, CA, USA

## Published Articles

- HINT: See literature database! Any new papers will be archived there, too.

---

# Developing a Minimal, Community Linux Platform for Aerospace

- (Developing from notes of ELISA-AeroWG-Meeting-20240306.md)
- (Explanation of the results achieved so far)
- Scope for feature selection
  - Technical scope
    - Software
      - first, discuss kernel (try to finish, and only discuss broader distribution if necessary to make a decision about kernel)
        - subsystem by subsystem, by DAL
		- protocol stacks
      - second, full distribution (kernel, services, BSP/drivers, API, libraries, applications, bootloader, etc.)
	  - **NEW**: Decision postponed to after system architecture
    - Hardware
      - MMU as minimum?, multicore?, availability (physical or simulation at first), validation, crypto, etc.
	  - **NEW**: Decision postponed after system architecture
  - Certification scope 
    - Option A: Non-critical - discuss first, DAL-D and lower
      - Decisions about features to include at low DAL do not (necessarily) apply to high DAL
    - Option B: Mission-critical
      - Real-time
    - Option C: Safety-critical (DO-178C SWL-C or higher)
      - Real-time
    - Option D: Security-critical (DO-326A, DO-356A)
      - SAL may not follow DAL, but may actually need to be inverse
    - **NEW**: Agreed on a broader group: Option A
  - Location
    - Air
    - Space
    - Ground equipment - secondary discussion
	- **NEW**: Agreed on a broader group: Exclude ground equipment in the first phase
- Use Cases
  - A use case should define a system architecture and function
	- **NEW**: Agreed on a broader group: Think of something like:
	  - Option A: Sensor=Switch; Function=Cabin Light Control; Function=Logging; Actuator=Cabin light (+ notification item in a log)
	  - Option B: Sensor=Temperature; Function=Control Temperature; Function=Logging; Actuator=Heating device (+ notification item in a log)
	  - **NOTE**: Advantage of option A: Clearly Low-DAL, as Option B could be safety critical
  - Single simple sensor(s)
    - Voting on architecture [8 votes in total (ESA=1)]:
	  - Amount of computers
	    - Option A: Multiple computers in total (w/ functions): 1
	    - Option B: Single computers in total (w/ functions): 7
		- **NEW**: Agreed on a broader group: Option B
      - Amount and type of functions:
	    - Option A: Multiple computers with single/multiple functions
	      - (Ignored due to decision above)
	    - Option B: Single computer with multiple functions of multiple systems: 1
	    - Option C: Single computer with multiple functions of one system: 1
	      - Example concept:
		    - App1: [SENS] -[?]-> [APP_CON] -[UDP/MEM]-> [APP_VOT]
		    - App2: [SENS] -[?]-> [APP_MON] -[UDP/MEM]-> [APP_VOT]
		    - App3: [APP_VOT] -[?]-> [ACT]
	    - Option D: Single computer with single function: 6
	      - Example concept:
		  - [SENS] -[ETH_MAC]-> [APP] -[ETH_MAC]-> [ACT]
		- **NEW**: Agreed on a broader group: Option D
		- **TODO**: Clarify what about the other 2 votes (A and B), do we exclude people?
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

- **NEW**: Other business:
  - Do we need to introduce a dictionary? One example of a question that was raised:
    - What is the understanding of "multiple functions"? -> 3 Answers with 9 people
      - 1) Multiple PCI devices SATA, USB, network etc.
      - 2) PCI devices with multiple functions, root bridge can have multiple functions
      - 3) System function perspective: Applications (processes, tasks, functions as S/W components) to achieve a system function like switch on cabin light (example: read sensor, log data, report failure, drive actuator)
	- **NEW**: Tend to a common understanding of 3)

---

# Scope of Survey White Paper

- Explanation of the updated scope of the white paper. Two options for white papers:
  - Option A) Scope is on a detailed comparison of some selected options (subset) of all options available (not mentioned in the paper)
  - Option B) Broader scope whats available, motivation as an outcome, detailed comparison with a subset as second paper
- **NEW**: Agreed on a broader group: The group tends towards Option B. The revised title will be "Survey on State-of-the-Art Open Source Linux-Like Operating Systems in Avionics"

---

# Closing

## Action Items

Located in [GitHub Issues](https://github.com/elisa-tech/wg-aerospace/issues)

- **TODO**: We should start a distinct new document for developing the use-case. Reason: The information starts to become cluttered across many documents.

## Round Table

- (Skipped due to time constraints)

