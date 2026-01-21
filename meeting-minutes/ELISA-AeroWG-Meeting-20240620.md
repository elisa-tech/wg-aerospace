<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

![logo](logo_elisa_small.png )

## ELISA Aerospace Working Group

# Minutes

## 20 June 2024

---

# Agenda

- Roll Call
- Brief Notices
- Announcements
  - Matt Weber gives an intro as the new Chair
- Space Grade Linux
  - Cadence / Frequency of meetings
  - Ideas on future agenda topics
- Aerospace Use case
  - Deliverables
  - Assessment items & Criteria
- Closing

---

# Roll Call

## Attended this meeting

- Matt Weber - Boeing
- David Graziano - Collins
- Steve VanderLeest - Boeing
- Merlin Kooshmanian - ESA
- Anshul Makkar - Infinitedeth
- Chuck Wolber - Boeing
- Ivan Perez - NASA Ames
- Qasim Majeed - Siemens
- Sam Thompson - Rapita
- Olivier Charrier - Wind River

## Attended recently in the past

- Scott Salmon - Cesium
- Piotr Skrzypek - ESA
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
- Steve VanderLeest - Boeing
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

Checkout our [Aerospace working group](https://lists.elisa.tech/g/aerospace) page as part of the ELISA foundation.  It includes a schedule of events, link to join the mailing lists, and meeting minutes.

## Upcoming Events

- 15-19 July [IEEE Space Mission Challenges for Information Technology](https://smcit-scc.space) in Mountain View, CA, USA
  - will include a workshop on open-source led by Ivan
- 29 Jul - 2 Aug [AIAA Aviation Forum](https://www.aiaa.org/aviation/presentations-papers/call-for-papers) in Las Vegas, NV, USA
- 1-3 Oct [IEEE Digital Avionics Systems Conference](http://dasconline.org/) in San Diego, CA, USA

## Published Articles

See our [Literature Database](../literature-database/literature.bib)


---
# Space Grade Linux

[MW] emailed Michael and Kate to start identifying an agenda / milestones.

[SV] impression so far is an organizing state and moving towards a plan.  
- See if hosting within Aero makes sense and if there is a point where a spinoff.
  - Delta between air and space might have enough difference
  - Number of passengers may drive standards convergence  (Sort of the move beyond Part 23 in civil air worthiness)

Future topics - Cadence / Frequency of meetings.  Ideas on future agenda topics

---

# Discussion on Features for Aerospace

- Shared our mandate - "Our mandate is on the ELISA website: The Aerospace Working Group shall develop use cases to inform and influence Linux architecture and related tools, work to derive technical requirements for avionics operating systems, and seek to enhance and expand avionics software lifecycle processes, practices, and tools to enable use of Linux in avionics systems that are certified to high design assurance levels.  From: https://lists.elisa.tech/g/aerospace"


- Demo repository (TSC question) - [MW] no discussion, will bring up to TSC

The conversation today was around deliverables and feedback.

- What is our output of the use case?  In our previous meeting, it was suggested that we define a result we can measure/use.
- [MW] Our current whitepaper - survey of existing Linux in safety critical use  ([SV] mentioned it is in-progress research)
  - [SV] trying to identify why it's hard and what prevents use.
- Output needs to have a tangible reason / visible result.
  - [SV] Influence direction of tools and long term support
  - [SV] Focus team on specific topics
  - [SV] (Int: ELISA) Use cases help drive other working groups work based on the domain need
  - [CW] (Ext: Inform SPDX-safety) Capture requirements and example approach to safety critical schema for capturing of those.  Evidence and trace.  (Zephyr involved)
  - [MW] (Ext: Xen / over hypervisor&virt approaches) Set the foundation to drive to mixed criticality
  - [MW] Deployment of pieces and objectives/standards applicable + justification
  - [SV] (Ext: Yocto / Linux / toolchain - i.e. components of the design) Influence configuration and structure changes to allow compositions.  Simplification for certification approaches.  E.g. indirect kernel change we depend on
  - [SV] Defines our groups need as a group
  - [ST] Other use cases might overlap with other groups  (Example of reliability and wifi fading)
    - [CW] Interesting use case that ties to a practice that ties to the reliability of a system  (Needs to engage non-interested parties)
  - [OC] Criteria to measure against other WGs - e.g, pain points conversation for an SWL C/D specific guidance
    - lifecycle items - requirements / design / objective process items
    - standard mapping to painpoints
    - [SV] Existing whitepaper may start to cover some of this

What is the feedback approach / rollout for the use cases?
- Audience? - ACTION Check with Min/Kate for Automotive's approach for previous cases
- [IP] Survey to a wider audience when sharing the use case to cover topics like what distro / Linux approach they are using.  Survey how they use it, compose it, and cfg they depend on
  - Use this to drive our next use case and timeline
  - ACTION build a list of question ideas on the mailing list


**NOTE: Meeting concluded here and the suggestion was our next call will focus on Next steps items within the use case**

Continue the discussion series, now in a separate document:
[Aerospace-Uses-Cases](../docs/Aerospace-Uses-Cases.md) -- [[Next steps]](https://github.com/elisa-tech/wg-aerospace/blob/main/docs/Aerospace-Uses-Cases.md#foreseeable-next-steps-tbc-at-on-of-the-next-meetings)


---

# Other business

- Ulises Vega's request for contribution ideas (DISCUSSED)
  - Suggestion that was made - "Are you interested in proposing a kernel config based on the ELISA kconfig-safety-check tool’s generation of a safety recommendation (https://github.com/elisa-tech/kconfig-safety-check)? This configuration would target the initial use cases and be something we could start building a demo around. Once the repo is ready, you could pull request it to propose the starting point. https://www.youtube.com/watch?v=tq2hjgCbX2Q   https://www.youtube.com/watch?v=r8sqFSNMkrA "
- Space Grade Linux action - Contact Monaghan, Michael L. (GSFC-5870) <michael.l.monaghan@nasa.gov> to work on agenda and topics  (Matt Weber, emailed Kate and Michael 6/19/2024)  (DISCUSSED)

- Carried over from previous meeting...
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

