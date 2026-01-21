<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

![logo](logo_elisa_small.png )

## ELISA Aerospace Working Group

# Minutes

## 5 June 2024

---

# Agenda

- Roll Call
- Brief Notices
- Announcements
- Space Grade Linux
  - Outbrief from organizing call
  - Cadance / Frequency of meetings
  - Ideas on future agenda topics
- Closing

---

# Roll Call

## Attended this meeting

- Scott Salmon - Cesium
- Merlin Kooshmanian - ESA
- Ivan Perez - NASA Ames
- Qasim Majeed - Siemens
- Piotr Skrzypek - ESA
- Matt Kelly - Boeing
- Matt Weber - Boeing

## Attended recently in the past

- Jeannette Nounagnon - Boeing (NEW)
- Gaston Gonzalez - VENG
- Martin Halle - Hamburg University of Technology
- Steve VanderLeest - Boeing
- Olivier Charrier - Wind River
- Emmanuel Gravel - Skytrac
- David Graziano - Collins
- Abdi Kitesa
- Lenka Koskova - TUL CZ
- Rajesh Kurapati - KMC
- Joseph Lee - Skytrac
- Gabriele Paoloni - Red Hat
- Justin Pearson - Lynx Software
- Daniel Riechers - Collins Aerospace
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

Checkout our [Aerospace working group](https://lists.elisa.tech/g/aerospace) page as part of the ELISA foundation.  It includes a schedule of events, link to join the mailing lists, and meeting minutes.

## Upcoming Events

- 22 May [ELISA Seminar - Making Linux Fly: Towards Certified Linux Kernel - RECORDING](https://www.youtube.com/watch?v=XGuYNjr7fJo)
- 11-12 June [Embedded Real Time Systems (ERTS)](https://www.erts2024.org/) in Toulouse, France
- 15-19 July [IEEE Space Mission Challenges for Information Technology](https://smcit-scc.space) in Mountain View, CA, USA
  - will include a workshop on open-source led by Ivan
- 29 Jul - 2 Aug [AIAA Aviation Forum](https://www.aiaa.org/aviation/presentations-papers/call-for-papers) in Las Vegas, NV, USA
- 1-3 Oct [IEEE Digital Avionics Systems Conference](http://dasconline.org/) in San Diego, CA, USA

## Published Articles

See our [Literature Database](../literature-database/literature.bib)


---
# Space Grade Linux

- Outbrief from 2nd organizing call (Scot gave a brief discussion for ~10mins and had to drop.)
  - Mike Monaghan NASA (focal as Scot transitions) - has flexibility in time to focus on this and working with Kate to outline steps  (Monaghan, Michael L. (GSFC-5870) <michael.l.monaghan@nasa.gov>)
    - ACTION, need to identify for next call if we can do an agenda with Michael.
  - Tim Bird - took action to reach out to other Space related linux groups

- Agenda (Next meeting when Mike/Kate join)
  - Cadance / Frequency of this meeting
  - Ideas on future agenda topics

- 

---

# Discussion on Features for Aerospace

Continue discussion series, now in separate document:
[Aerospace-Uses-Cases](../docs/Aerospace-Uses-Cases.md)

The conversation was around the Next Steps section of the document. (A short 20min conversation)

- What is our output of the use case?  Suggestion to define a result we can measure/use.  Do we have this in a early meeting's minutes?
  - Whitepaper has a tangible reason / visible result.
  - Is it to attempt to define the core of linux for other influencing reasons?
  - safety vs non-safety?  What is the value for non-safety use cases in this group?
    - Aero - smallest feature set for cert
      - Is there a example of this to compare against SpaceROS requirement matrix? Is that comparison valuable?
    - Space - less critical more functionality - Goal? alignment of usage and artifacts - drive maturity / streamlines certification
        - Ivan mentioned there was evaluation of SpaceROS against lowest criticality (TBD planning to publish a guide / matrix for requirement compliance in SpaceROS)
  - One suggestion is to present the use cases for feedback (find a wider audience and what distro / linux approach are they using.  survey how they use it, compose it and cfg they depend on)
    - This drives a timeline and output plan so others can use it
- If the use case implied a distro, what would it be based on or would it follow a pattern like carrier grade that standardizes a configuration. (for the few of us on the call)Leaning towards a pattern/standard.  e.g., Yocto/RHEL/Ubuntu using a pattern with artifacts living in core projects.  So maybe for the current aerospace use case we could reuse the Automotive Yocto configuration?
  - Need to checkout ref build that automative did for their use case.

---

# Other business

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


