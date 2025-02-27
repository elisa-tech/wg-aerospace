
![logo](logo_elisa_small.png )

## ELISA Aerospace Working Group

The Aerospace Working Group shall develop use cases to inform and influence Linux architecture and related tools, work to derive technical requirements for avionics operating systems, and seek to enhance and expand avionics software lifecycle processes, practices, and tools to enable use of Linux in avionics systems that are certified to high design assurance levels.  (https://lists.elisa.tech/g/aerospace)

# Minutes

## 05 March 2025

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

- Matt Weber - Boeing

## Attended recently in the past

- Ivan Perez - NASA Ames
- Ramon Roche - LF
- Olivier Charrier - Wind River
- Martin Halle - Hamburg University of Technology
- Sam Thompson - Rapita Systems
- Michael Monaghan - NASA Goddard
- Christopher Heistand (Stoke Space)
- Sascha Wise (Elodin)
- Andrew Wilson (L3Harris, BYU, FPGA Zealot)
- Piotr Skrzypek - ESA
- Wanja Zaeske - DLR
- Walt Miner - Linux Foundation
- Paul Mani - Collins India
- Alexey Simonov
- Gary Crum (Voyager)
- Brennan Stewart (NASA)
- Tony James (Red Hat)
- Allen Brown (Odyssey Space Research)
- Qasim Majeed - Siemens
- Merlin Kooshmanian - ESA
- Rob Woolley (Wind River)
- Phaedrus Leeds (Aerospace Corp)
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
- Douglas Landgraf (Red Hat)
- Tim Bird - Sony
- Paul Mani - Collins India
- Chuck Wolber - Boeing
- Dongshik Won (TelePIX/KAIST)
- Steve VanderLeest - Boeing
- Carole Garrison - NASA Langley
- Paul Greenwood - Vorago Technologies
- David Graziano - Collins
- Manuel Beltran - Boeing
- Naga (Timesys/Lynx)
- Paul Greenwood - Vorago Technologies
- Shefali Sharma
- Tomas Novotny (Czech Aerospace Research Centre)

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

- 24th-27th March in Seattle, WA - Flight Software Workshop (https://flightsoftware.org/workshop/FSW2025)
  - This workshop drove some previous Space Grade Linux topics
  - Christopher Heistand is chairing
  - Matt Weber and Michael Monaghan submitted an abstract to present an ELISA talk on "Making Penguins Fly"
- April 2-3: RISC-V in Space Conference, Gothenburg https://indico.esa.int/event/562/overview
- June 23-25 - Open Source Summit North America (including Embedded Linux Conference) in Denver, CO
  - Event web site: https://events.linuxfoundation.org/open-source-summit-north-america/
- July 2025 - Space Mission Challenges for Information Technology Space Computing Conference IEEE (Pasadena, CA) (https://2025.smcit-scc.space/) (Occurring for 20yrs, cross industry/global)
  - Open source for space workshop (Ivan organizing)
  - Located @ California Science Center in LA  (close to USC)
- Aug - SmallSat - Call for paper is open (Due Feb 4th) - https://www.smallsat.org/downloads/call-for-papers.pdf
- August 25-27 Linux Foundation Open Source Summit EU & Embedded Linux Conference https://events.linuxfoundation.org/open-source-summit-europe/
- DASC 2025: September 14-18, 2025 44th Digital Avionics Systems Conference (https://2025.dasconline.org/) (Montreal, Canada)
- Dec 11-13: Linux Plumbers Conference 2025, in Tokyo
- ?? NASA SPARK submissions

## Articles / Publications

See our [Literature Database](../literature-database/literature.bib)

See our [Draft(April 18th, 2024 revision) Whitepaper](../docs/20240418_ELISA_AeroWG_Whitepaper.pdf)

---
---
# Technical Topics

[Link to 2025 goals](https://github.com/elisa-tech/wg-aerospace/blob/main/meeting-minutes/ELISA-AeroWG-Meeting-20250205.md#2025-vision-and-direction)

## Survey State of Art
  - https://github.com/elisa-tech/wg-aerospace/blob/main/docs/20240418_ELISA_AeroWG_Whitepaper.pdf
  - Option B was selected in 20240321 & 20240403 calls
    - Option A) Scope is on a detailed comparison of some selected options (subset) of all options available (not mentioned in the paper)
    - **Option B) Broader scope whats available, motivation as an outcome, detailed comparison with a subset as second paper**
  - Maybe a SIG outside of main call?  Start with main talk, breakdown into SIGs?
  - Restructure/ breakout discussions
  - Add flight framework comparison to the RTOS listing?  ref Ivan's paper?
      - **Manuel / Ivan / Dongshik have interest - need whitepaper access**
  - Tim mentioned a survey of Linux use on Sats that just launched in early 2025 (Tomas N. has more information) - Mentioned a thesis paper is in development by a Czech student
      - **Tim needs whitepaper access**
      - SATGUS (https://www.spaceselfie.com/) mid-Jan 2025 - https://www.nanosats.eu/sat/sat-gus
          - 3-5 Linux instances
          - Crunchlabs
      - SuperDove SAT - low earth orbit imaging ~140 already up
          - Peican-2 from PlanetLab has Jetson - launched from transporter-12
          - https://www.planet.com/pulse/planet-launches-high-resolution-pelican-2-satellite-36-superdoves/

## Licensing and Developer Agreement

Open Actions
- TSC contribution guidance
- Commit license files to repo


## Discussion on Features for Aerospace
- Call between Ivan, Martin, Paul, Brian Wood, and I is occurring on testing wkly on Friday @ 9-9:30am CST. The meeting focuses on discussing the testing framework and how to prototype the components together. Anyone is welcome to join us and contact Matt Weber for the invite.
- Actions from 2/14/2025
  -	Paul sent PR for test client&server with logging - https://github.com/elisa-tech/wg-aerospace/pull/16
    - Walked through the test sequence in code
  -	Merged both Ivan and Pauls PRs
  -	Ivan is going to try Paul’s test apps with the monitor
  -	Everyone encouraged to give the instructions and demo a try plus make issue tickets as you find problems we need to fix. - https://github.com/elisa-tech/wg-aerospace/blob/main/demos/copilot/Readme.md
  -	Martin shared 
    -	Haskell in Education: https://www.tuhh.de/sts/service/education
    - Example Tooling in Teaching: https://github.com/bigmac2k/HSMateLight
  -	**Open Actions**
    - Ticket to add entrypoint and ubuntu user logic
    - Brian to share some raw socket examples
    - Matt to see if we can get a qemu build in place that we can run this in
    - Everyone try to use the instructions Readme
    - Ivan submitting PR adding Makefile - https://github.com/elisa-tech/wg-aerospace/pull/21

- Refs:
  - [Aerospace-Uses-Cases](../Aerospace-Uses-Cases.md)
    - [Diagrams about testing](https://github.com/elisa-tech/wg-aerospace/blob/main/Aerospace-Uses-Cases.md#test)
    - [Next steps](https://github.com/elisa-tech/wg-aerospace/blob/main/Aerospace-Uses-Cases.md#foreseeable-next-steps-tbc-at-on-of-the-next-meetings)


---
---

# Closing

## Action Items

Located in [GitHub Issues](https://github.com/elisa-tech/wg-aerospace/issues)

## Round Table
