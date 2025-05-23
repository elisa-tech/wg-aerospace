
![logo](logo_elisa_small.png )

## ELISA Aerospace Working Group

The Aerospace Working Group shall develop use cases to inform and influence Linux architecture and related tools, work to derive technical requirements for avionics operating systems, and seek to enhance and expand avionics software lifecycle processes, practices, and tools to enable use of Linux in avionics systems that are certified to high design assurance levels.  (https://lists.elisa.tech/g/aerospace)

# Minutes

## 07 May 2025

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
- Ivan Perez (KBR @ NASA Ames Research Center)
- Martin Halle (TUHH)
- Manuel Beltran - Boeing
- Paul Mani - Collins India
- Andrew Wilson - L3Harris, BYU, FPGA Zealot
- Philip Balister - OpenEmbedded
- Shefali Sharma
- Rob Woolley  - Wind River
- Tim Bird - Sony

## Attended recently in the past

- Andrew E Wilson (L3Harris, BYU, FPGA Zealot)
- Cyril Jean (Microchip Technology Inc.)
- Shefali Sharma
- Alexey Simonov
- Dongshik Won - TelePIX/KAIST
- Martin Halle - Hamburg University of Technology
- Iain Galloway - NXP Semiconductors
- Laurent Meilleur
- Vikash Kodati
- Naga - Timesys/Lynx
- Brennan Stewart - NASA
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

- ELISA workshop - May 7-9 at Volvo in Lund, Sweden
  - TSC discussed on Mar 5th and more details [here](https://lists.elisa.tech/g/devel/topic/meeting_notes_elisa_tsc/111529766)
  - Provided TSC these ideas from AeroWG
    -	Demo our first use case’s verification example
    -	Present the content/outline of the State of Art whitepaper (considering it was restarted today with more contributors)
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
- Dec 11-13: Linux Plumbers Conference 2025, in Tokyo
- ?? NASA SPARK submissions

## Articles / Publications

See our [Literature Database](../literature-database/literature.bib)

See our [Draft(March 5th, 2025 revision) Whitepaper](../docs/20250305_ELISA_AeroWG_Whitepaper.pdf)

---
---
# Technical Topics

## Demo of Cabin Lights Use Case

See [Readme](../demos/copilot/Readme.md).

- Drives other WG discussion, minimal configurations, and practice of monitor-based verfication
- Practice has application for operational monitor use cases
- Join us Friday 9am CDT - invite - https://elisa.tech/community/meetings/

## Whitepaper on "Survey State of Art...""

Background
- Edits
  - Via online [Overleaf editor](https://www.overleaf.com/) - we have limited licenses so we've shared the pdf link below
  - latex format and editor can generate documents
- Paper's goal - What is the current state of the art with respect to aerospace
  - Initial document drove use case definition
  - Evolved to be a comparison and a conclusion of industry direction
  - Doc still informs goals and activities of AeroWG & Space

[Worked on Abstract - TDB updated copy link](../docs/20250417_ELISA_AeroWG_Whitepaper.pdf) today

ACTIONS
- Martin is going to finish the abstract and move the portions "marked for Intro" into the Intro section.  Next time focusing on Intro.

---
---

# Closing

## Action Items

Located in [GitHub Issues](https://github.com/elisa-tech/wg-aerospace/issues)

## Round Table
