<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

![logo](logo_elisa_small.png)

## ELISA Aerospace Working Group

The Aerospace Working Group shall develop use cases to inform and influence Linux architecture and related tools, work to derive technical requirements for avionics operating systems, and seek to enhance and expand avionics software lifecycle processes, practices, and tools to enable use of Linux in avionics systems that are certified to high design assurance levels. (<https://lists.elisa.tech/g/aerospace>)

# Minutes

## 06 November 2024

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
- Andrew Wilson (L3Harris)
- Manuel Beltran - Boeing
- Tomas Novotny (Czech Aerospace Research Centre)
- Dongshik Won (TelePIX/KAIST)
- Martin Halle - Hamburg University of Technology
- Shefali Sharma
- Tim Bird - Sony
- Ramon Roche (LF)
- Michael Monaghan (NASA Goddard)
- Brennan Stewart (NASA)
- Tony James (Red Hat)

## Attended recently in the past

- Christopher Heistand (Stoke Space)
- David Graziano - Collins
- Olivier Charrier - Wind River
- Sam Thompson - Rapita
- Paul Mani - Collins India
- Allen Brown (Odyssey Space Research)
- Ivan Perez - NASA Ames
- Qasim Majeed - Siemens
- Merlin Kooshmanian - ESA
- Rob Woolley (Wind River)
- Phaedrus Leeds (Aerospace Corp)
- Scott Salmon - Cesium
- Anshul Makkar - Infinitede
- Steve VanderLeest - Boeing
- Ramon Roche - LF
- Matt Kelly - Boeing
- Justin Pearson - Lynx Software
- Jeannette Nounagnon - Boeing (Aurora)
- Piotr Skrzypek - ESA
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

- 10-12 Dec - Hosted by NASA at Goddard Space Flight Center
  - Location: Goddard Space Flight Center <https://maps.app.goo.gl/NoVcCPoSEk38ardU6>
  - Registration open: <https://elisa.tech/event/elisa-workshop-at-at-nasa-goddard-space-grade-linux/> (Mentioned to Ramon about Gdoc not allowed in some companies)
  - Agenda draft: <https://docs.google.com/document/d/1Mytz9pGkTEIVqTnlEKxTpx3ozPt1xFlBqhYrj0gCsRU>
  - Attendance ~50 people
  - Virtual attendance is a STRONG maybe for attendees
  - Virtual attendance possible for speakers.
  - For wider listening some talks may be shared as webinars.
  - Share presented slides later for the ELISA result database.
  - Michael asked about if there will be a slack/chat for the event (Ramon checking)
- 25th Feb in Karlsruhe, Germany - 7th Workshop on Avionics Systems and Software Engineering (AvioSE)
  - **(NEW) Call for Papers and further information on: <https://aviose-workshop.github.io/>**
  - Deadline extend to Nov 11, 2024.
- 24th-27th March in Seattle, WA - Flight Software Workshop (<https://flightsoftware.org/workshop/FSW2025>)
  - Presentation only - submissions start ~Oct 14th (**Due Nov 15th**)
  - This workshop drove some of the Space Grade Linux topics
  - Lessons learned / BOF-like with presentation
  - Registration/abstracts open - 200 slots
  - Christopher Heistand is chairing
    - [MW] **Ask Michael about proposing some talks. Status of RT primer with stats?? Maybe a combo of space and non-space perspective?** Chat with Kate?
- July 2025 - Space Mission Challenges for Information Technology Space Computing Conference IEEE (Pasadena, CA)
  - Workshops (deadline for submissions Fall 2024) and papers
  - **Do we want to propose a topic? Or a Space workshop at the event with ELISA topics?(ELISA was a sponsor in prior 2 yrs)**
    - Maybe just automotive? [MW] asking Kate/Min if there are plans for next year already and if we could present a similar talk from FSW.
- Aug - SmallSat - Call for paper is open - <https://www.smallsat.org/downloads/call-for-papers.pdf>
- DASC 2025: September 14-18, 2025 44th Digital Avionics Systems Conference (<https://2025.dasconline.org/>) (Montreal, Canada)

## Articles / Publications

See our [Literature Database](../literature-database/literature.bib)

See our [Draft(April 18th, 2024 revision) Whitepaper](../docs/20240418_ELISA_AeroWG_Whitepaper.pdf)

---

---

# Technical Topics

## December 10-12 Workshop

- Registration link above under events
- Any discussion for our call?

## Discussion on Features for Aerospace

The use case discussion is focusing on testing.

- Here's the previous progress - <https://github.com/elisa-tech/wg-aerospace/commit/693faa39ac5d45073989c94877391f5742fb3c0f#diff-49514acd2e9fa371ee74afa185098ec9d80ca9305dabc98fa5fe00d79c3619d5>
- We are seeking volunteers to write the test apps and stage an emulation environment based on the discussion. Contact Matt Weber if interested.
- (Ivan) I have the Copilot code ready. It's very simple.
  - From the point of view of connecting it to the rest of the testing infrastructure, all I need is:
    - A boolean (global variable) that indicates if the light switch is on or off.
    - A boolean (global variable) that indicates if the lights are on.
  - I can also connect it if you give me a function that allows me to "sense" if the light switch is on/off, and whether the lights are on/off. There are other ways to connect it (e.g., SW bus, etc.).

- Emulation
  - How to approach Windows development of the emulation + OS build ([Matt] adding a readme to the CI example and link to the CI from the use case doc)
  - [Matt] Add diagram of the components and where test copilot "hooks in" based on use case notes
  - [Michael] Has anyone worked with QEMU CAS?
    - <https://carrv.github.io/2023/papers/CARRV2023_paper_5_Cao.pdf>
    - ? <http://cps.kaist.ac.kr/papers/16RTSSWIP_cycle.pdf>
  - [Matt] SystemC example - <https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/862421112/Co-simulation>
  - [Versal AIE](https://docs.amd.com/r/en-US/ug1273-versal-acap-design/AI-Engine-Simulation)
  - <https://renode.io/> - board level simulation, accuracy?
    - <https://renode.readthedocs.io/en/latest/tutorials/co-simulating-custom-hdl.html>
    - [Dongshik] For Microchip PolarFire Soc, emulating Linux on Renode should be possible but never tried (will try soon?) <https://ww1.microchip.com/downloads/aemdocuments/documents/fpga/ProductDocuments/SupportingCollateral/renode_webinar_16.pdf>

  Refs:
  - [Aerospace-Uses-Cases](../docs/Aerospace-Uses-Cases.md)
    - [Next steps](https://github.com/elisa-tech/wg-aerospace/blob/main/docs/Aerospace-Uses-Cases.md#foreseeable-next-steps-tbc-at-on-of-the-next-meetings)
    - [Collaboration doc](https://mensuel.framapad.org/p/elisa-aerowg) (used during our WG calls and sync'd with Aerospace-Uses-Cases.md)

Linux Architecture [Matt]

- Proposing we start to outline the components of the kernel in a document such that we can talk about them when doing use cases.
- Could do this purely in the SystemsWG call or start an initial proposal here based on our current use case "OS dependencies"

Minimal kernel/build [Manuel]

- What are the dependencies for running frameworks (CFS, etc) on top?
- Impacts to criticality/rigor
- [Matt] Could start those use cases and understand impacts of the dependencies

Space Frameworks comparison/trades? [Manuel]

- <https://digitalcommons.usu.edu/cgi/viewcontent.cgi?article=6013&context=smallsat>
  - JPL - Fprime
  - Goddard - CFS (C-based with cert artifacts)
- FSW had a presentation - Michael checking (Ivan has mentioned this in the past)

---

---

# Closing

## Action Items

Located in [GitHub Issues](https://github.com/elisa-tech/wg-aerospace/issues)

## Round Table
