<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

![logo](logo_elisa_small.png)

## ELISA Aerospace Working Group

# Minutes

## 1 May 2024

---

# Agenda

- Roll Call
- Brief Notices
- Announcements
- Space Grade Linux
- Closing

---

# Roll Call

## Attended this meeting

- Merlin Kooshmanian - ESA
- David Graziano - Collins Aerospace
- Daniel Riechers - Collins Aerospace
- Ivan Perez - NASA Ames
- Steve VanderLeest - Boeing
- Matt Weber - Boeing

## Attended recently in the past

- Steve VanderLeest - Boeing
- Olivier Charrier - Wind River
- Gaston Gonzalez
- Emmanuel Gravel - Skytrac
- David Graziano - Collins
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
- Scott Salmon - Cesium
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

---

# Announcements

## Upcoming Events

- 11-12 June [Embedded Real Time Systems (ERTS)](https://www.erts2024.org/) in Toulouse, France
- 15-19 July [IEEE Space Mission Challenges for Information Technology](https://smcit-scc.space) in Mountain View, CA, USA
  - will include a workshop on open-source led by Ivan
- 29 Jul - 2 Aug [AIAA Aviation Forum](https://www.aiaa.org/aviation/presentations-papers/call-for-papers) in Las Vegas, NV, USA
- 1-3 Oct [IEEE Digital Avionics Systems Conference](http://dasconline.org/) in San Diego, CA, USA

## Published Articles

See our [Literature Database](../literature-database/literature.bib)

## Notes other ELISA boards

- Technical Steering Committee (TSC) is considering development of a requirements database using the [BASIL](https://github.com/elisa-tech/BASIL)]tool, to provide a common set for reference by all working groups and to which all of us contribute.
  - Beware similar sounding tool names.
    - [Basil](https://github.com/elisa-tech/BASIL) is a Software Quality Management Tool that supports Software Specification analysis, testable requirements definition and coverage (originally created by Red Hat, now hosted under ELISA)
    - [Bazel](https://bazel.build/) is a build system

---

# Space Grade Linux

- Steve VanderLeest met with a group driving towards a Space Grade Linux on 30 Apr 2024, which was convened by Kate Stewart. The group is largely driven by US NASA. Steve offered the ELISA Aerospace Working Group as the host for this initiative, with the option to spin out the initiative as an independent project if and when warranted
- Ivan Perez advocated for their participation in our working group due to the large overlap in interest and the benefit of wider engagement. Noted NASA guidelines for SW development, such as NPR7150.2, which have parallels to the civilian FAA guidelines, such as DO-178C. Ivan also noted a project called Space ROS (Space Robot Operating System) that seeks to have a space-graded version of the robotics framework ROS. Ivan is one of the maintainers and a member of the SC. These projects are complementary. Possible use-case to discuss in future is Space ROS built on Space Grade Linux.
- Next steps are that the informal Space Grade Linux group will meet once more independently to decide whether to fold into our Aerospace Working Group. Regardless, we will invite them to join and present on their work.
- Merlin Kooshmanian indicated European discussion and efforts (e.g., ESA) toward Linux in space have also started. At proof of concept stage now, mainly focused on hardware and whether Linux is compatible.

---

# Developing a Minimal, Community Linux Platform for Aerospace

[Aerospace-Uses-Cases](../docs/Aerospace-Uses-Cases.md)

---

# Other business

- Carried over from last meeting...
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
