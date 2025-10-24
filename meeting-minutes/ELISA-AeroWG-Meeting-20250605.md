![logo](logo_elisa_small.png )

## ELISA Aerospace Working Group

The Aerospace Working Group shall develop use cases to inform and influence Linux architecture and related tools, work to derive technical requirements for avionics operating systems, and seek to enhance and expand avionics software lifecycle processes, practices, and tools to enable use of Linux in avionics systems that are certified to high design assurance levels.  (https://lists.elisa.tech/g/aerospace)

# Minutes

## 04 June 2025

---

# Agenda

- Roll Call
- Brief Notices
- Announcements
- Technical Topics - [Collaboration doc](https://hackmd.io/@AS9atTJpQgeXj_ICWAprZw/By850egu1g/edit)
- Closing

---

# Roll Call

## Attended this meeting

- Matt Weber (Boeing)
- Martin Halle - Hamburg University of Technology
- Carole Garrison - NASA Langley
- Macarena Sagredo
- Michael Epley (Redhat)
- Paul Mani - Collins India
- Rob Woolley (Wind River System)
- Shefali Sharma
- Tim Bird (Sony)
- Brennan Stewart - NASA

## Attended recently in the past

- Ivan Perez (KBR @ NASA Ames Research Center)
- Manuel Beltran - Boeing
- Andrew Wilson - L3Harris, BYU, FPGA Zealot
- Philip Balister - OpenEmbedded
- Rob Woolley  - Wind River
- Tim Bird - Sony
- Andrew E Wilson (L3Harris, BYU, FPGA Zealot)
- Cyril Jean (Microchip Technology Inc.)
- Alexey Simonov
- Dongshik Won - TelePIX/KAIST
- Iain Galloway - NXP Semiconductors
- Laurent Meilleur
- Vikash Kodati
- Naga - Timesys/Lynx
- Ramon Roche - LF
- Olivier Charrier - Wind River
- Sam Thompson - Rapita Systems
- Michael Monaghan - NASA Goddard
- Christopher Heistand - Stoke Space
- Sascha Wise - Elodin
- Andrew Wilson - L3Harris, BYU, FPGA Zealot
- Piotr Skrzypek - ESA
- Wanja Zaeske - DLR
- Walt Miner - Linux Foundation
- Alexey Simonov
- Gary Crum - Voyager
- Tony James - Red Hat
- Allen Brown - Odyssey Space Research
- Qasim Majeed - Siemens
- Merlin Kooshmanian - ESA
- Phaedrus Leeds - Aerospace Corp
- Scott Salmon - Cesium
- Anshul Makkar - Infinitede
- Matt Kelly - Boeing
- Justin Pearson - Lynx Software
- Gaston Gonzalez - VENG
- Emmanuel Gravel - Skytrac
- Abdi Kitesa
- Lenka Koskova - TUL CZ
- Rajesh Kurapati - KMC
- Joseph Lee - Skytrac
- Gabriele Paoloni - Red Hat
- Daniel Riechers - Collins (Security)
- Douglas Landgraf - Red Hat
- Chuck Wolber - Boeing
- Steve VanderLeest - Boeing
- Carole Garrison - NASA Langley
- David Graziano - Collins
- Paul Greenwood - Vorago Technologies
- Tomas Novotny - Czech Aerospace Research Centre

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

## Meetings

## Upcoming Events

- June 23-25 - Open Source Summit North America (including Embedded Linux Conference) in Denver, CO
  - Event web site: https://events.linuxfoundation.org/open-source-summit-north-america/
- July 2025 - Space Mission Challenges for Information Technology Space Computing Conference IEEE (Pasadena, CA) (https://2025.smcit-scc.space/) (Occurring for 20yrs, cross industry/global)
  - July 28 - Aug 1
  - Open source for space workshop (Ivan organizing)
  - Located @ California Science Center in LA  (close to USC)
  - Reach out to Ivan Perez if interested in providing a topic related to OSS in space (open data / hw / sw)
- Aug - SmallSat - Call for paper is open (Due Feb 4th) - https://www.smallsat.org/downloads/call-for-papers.pdf
- August 5th - Open Source Summit India - Hyderabad, India - https://events.linuxfoundation.org/open-source-summit-india/
- August 25-27 Linux Foundation Open Source Summit EU & Embedded Linux Conference https://events.linuxfoundation.org/open-source-summit-europe/
- TBD 10/31/2025, Drone+Space Community Meetup @ KAU (Korea Aerospace University) Ramon & Dongshik Host
- DASC 2025: September 14-18, 2025 44th Digital Avionics Systems Conference (https://2025.dasconline.org/) (Montreal, Canada)
- Dec 11-13: Linux Plumbers Conference 2025, in Tokyo (https://lpc.events/)
- ?? NASA SPARK submissions (https://spark.nasa.gov/)

## Journals

- IEEE/AIAA Journals

## Articles / Publications

See our [Literature Database](../literature-database/literature.bib)

See our [Draft(March 5th, 2025 revision) Whitepaper](../docs/20250305_ELISA_AeroWG_Whitepaper.pdf)

---
---
# Technical Topics

## Use case demo feedback (https://github.com/elisa-tech/wg-aerospace/tree/main/demos/copilot)
- How do you expect to use this demo (judge by adding a plus symbol below)?
  - Research [+++]
  - University student hands on [+]
  - Minimal example to build on [+]
  - Hobby use
- How would you like the pieces of it presented / segmented to make it applicable for your use?
  - CoPilot Container [++]
  - Minimal Embedded OS images/SDK [+++]
  - Test scripts [+]
  - Use case
    - Example monitor
    - Example application
  - CICD example jobs [+]
  - Whole Demo with all parts together [+]
  - Reference example of Copilot workflow (Formal Methods) [+]
- If the demo doesn't have applicability
  - Fault tolerance - could be a focus of a higher availability/safety focused use case
  - Fault recovery
    - multi processor system separate kernels on same chip
    - **multi board simulation (multi-qemu with some watchdog / remedy behavior)**
  - **Fault injection into QEMU - memory / cpu faults**
    - detection and recovery mechanism - watchdog / crc / edac / etc
    - Is there a kernel design changes that make things less impacts?
  - Voting algos
    - partitioning to have mutliple kernels running on several cores
    - Ivan what are the common voting algos in use and any already part of CoPilot - Whitepaper topic?
    - Michael Epley - if any  of these voting algorithms are in use, I suspect there are test cases + correctness, verification, and specific use cases implemented as well

- **ACTION** Next call, start to write up a higher availability/safety focused use case
    - Focused around bold items above? Seed the discussion?

## Whitepaper on "Survey State of Art...""

Background
- Edits
  - Via online [Overleaf editor](https://www.overleaf.com/) - we have limited licenses so we've shared the pdf link below
  - latex format and editor can generate documents
- Paper's goal - What is the current state of the art with respect to aerospace
  - Initial document drove use case definition
  - Evolved to be a comparison and a conclusion of industry direction
  - Doc still informs goals and activities of AeroWG & Space

ACTIONS
- Martin can add you as an editor to the paper if you have contributions!  Or you can use our latest pdf on the mailing list and supply comments back in a marked up version.

---
---

# Closing

## Action Items

Located in [GitHub Issues](https://github.com/elisa-tech/wg-aerospace/issues)

## Round Table
