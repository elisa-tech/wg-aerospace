<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

![logo](logo_elisa_small.png)

## ELISA Aerospace Working Group

The Aerospace Working Group shall develop use cases to inform and influence Linux architecture and related tools, work to derive technical requirements for avionics operating systems, and seek to enhance and expand avionics software lifecycle processes, practices, and tools to enable use of Linux in avionics systems that are certified to high design assurance levels. (<https://lists.elisa.tech/g/aerospace>)

# Minutes

## 5 February 2025

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

## Meetings

- For 2025, we keep our current schedule of two calls a month, but instead of different start times, they are now sync'd to both be at 4pm UTC (10am CST). The first call of the month is Aerospace focused and the second Space.
  - **Do we want a 30mins pre-call for Aerospace before the SGL call on the 3rd Thurs of the month? This would bring us back to two possible touch points a month.**
- (Per TSC) Starting from January 6th, we will use the LFX Meeting for all ELISA meetings. For a sneak peak of what that may look like please go to the ELISA public meeting calendar here <https://zoom-lfx.platform.linuxfoundation.org/meetings/elisa-project>. The meeting joining links will change and more details to receive a direct calendar invite will be shared as migration completes.

## Upcoming Events

- 25th Feb in Karlsruhe, Germany - 7th Workshop on Avionics Systems and Software Engineering (AvioSE) (<https://aviose-workshop.github.io/>)
- 24th-27th March in Seattle, WA - Flight Software Workshop (<https://flightsoftware.org/workshop/FSW2025>)
  - This workshop drove some previous Space Grade Linux topics
  - Lessons learned / BOF-like with presentation
  - Registration/abstracts open - 200 slots
  - Christopher Heistand is chairing
  - Matt Weber and Michael Monaghan submitted an abstract to present an ELISA talk on "Making Penguins Fly"
- June 23-25 - Open Source Summit North America (including Embedded Linux Conference)
  - in Denver, CO
  - event web site: <https://events.linuxfoundation.org/open-source-summit-north-america/>
  - CFP: **Closes Feb 16th**
  - will there be an ELISA track?
- July 2025 - Space Mission Challenges for Information Technology Space Computing Conference IEEE (Pasadena, CA) (<https://2025.smcit-scc.space/>) (Occurring for 20yrs, cross industry/global)
  - <https://2025.smcit-scc.space/track/smc-it-scc-2025-workshops>
  - <https://2025.smcit-scc.space/track/smc-it-scc-2025-papers>
    **- Deadline for workshop proposal submissions Dec 13th & Feb 3rd for papers**
  - Open source for space workshop (Ivan organizing)
    - Willing to co-chair with others. Looking to collaborate on topics, moderation and planning
    - Located @ California Science Center in LA (close to USC)
  - Does the WG want to be part of this workshop or create our own?
    - Certification for space topic?
    - Jan submission
- Aug - SmallSat - Call for paper is open (Due Feb 4th) - <https://www.smallsat.org/downloads/call-for-papers.pdf>
- DASC 2025: September 14-18, 2025 44th Digital Avionics Systems Conference (<https://2025.dasconline.org/>) (Montreal, Canada)
- 23-25th June: Open Source Summit North America in Denver CO
- August 25-27 Linux Foundation Open Source Summit EU & Embedded Linux Conference <https://events.linuxfoundation.org/open-source-summit-europe/>
- April 2-3: RISC-V in Space Conference, Gothenburg <https://indico.esa.int/event/562/overview>
- Submission Deadline Feb 7, 2025, 11:59 PM
- Dec 11-13: Linux Plumbers Conference 2025, in Tokyo
- ?? NASA SPARK submissions

## Articles / Publications

See our [Literature Database](../literature-database/literature.bib)

See our [Draft(April 18th, 2024 revision) Whitepaper](../docs/20240418_ELISA_AeroWG_Whitepaper.pdf)

---

---

# Technical Topics

## Reflection on 2024 plans

[2024 Goals and Use Case outline](https://github.com/elisa-tech/wg-aerospace/blob/main/meeting-minutes/ELISA-AeroWG-Meeting-20240215.md#proposed-2024-goals)

[Use Case outline proposal](https://github.com/elisa-tech/wg-aerospace/blob/main/meeting-minutes/ELISA-AeroWG-Meeting-20240306.md#divide-discussion-into-focused-sub-topics)

[Use Case outline refined for current case](https://github.com/elisa-tech/wg-aerospace/blob/main/meeting-minutes/ELISA-AeroWG-Meeting-20240403.md#developing-a-minimal-community-linux-platform-for-aerospace)

[Conversation about a dictionary](https://github.com/elisa-tech/wg-aerospace/blob/main/meeting-minutes/ELISA-AeroWG-Meeting-20240501.md#other-business)

[Developed Survey for Space Grade Linux Interest](https://github.com/elisa-tech/wg-aerospace/blob/main/meeting-minutes/ELISA-AeroWG-Meeting-20241002.md#space-grade-linux-sgl) ----> [Dec Workshop Survey Results Video](https://www.youtube.com/watch?v=CiWfxXuM8Es&list=PLuDNrzTpK8zqUX6OEuh2hEz3vmqyjlwYu&index=5&pp=iAQB)

## 2025 Vision and Direction

- Where do we take use cases activities this year?
  - Do we work with systems working group to define certification scope categories? Chuck referenced Steve's paper has been used in current discussions.
    - Do we summarize this in some way to inform and clarify overlap between sgl + aero use cases? Helps industry align.
  - Layer for yocto project - drive technical software focus
    - May have less kernel focus then expected (Tim) - Noticed this with Sat project use of vendor provided content
    - flight framework examples - focused towards scenarios that fit customers profiles of use & test cases toward deployment configurations
      - i.e. cFS in a layer ready to integrate
    - flight control sw - <https://ardupilot.org/>
    - SGL started a layer last month - <https://github.com/elisa-tech/meta-sgl>
  - Commercial Aero Process tooling
    - Req and test trace to meta-layer content - "assurance"
      - Linux Plumbers discussion - [Improving kernel design documentation and involving experts](https://lpc.events/event/18/contributions/1894/)
      - Dec Goddard Workshop presentation - <https://www.youtube.com/watch?v=_N3l_EEV8uM&list=PLuDNrzTpK8zqUX6OEuh2hEz3vmqyjlwYu&index=7&pp=iAQB>

    - Copilot framework / examples to tie verification to use case applications
      - Tie as a concept with Linux Req and Trace verification effort (Martin / Chuck discussion on grad project?)
      - Runtime monitor framework example - <https://github.com/nasa/ogma>

- Restart "Survey State of Art" paper? (briefly discussed in previous calls)
  - <https://github.com/elisa-tech/wg-aerospace/blob/main/docs/20240418_ELISA_AeroWG_Whitepaper.pdf>
  - Option B was selected in 20240321 & 20240403 calls
    - Option A) Scope is on a detailed comparison of some selected options (subset) of all options available (not mentioned in the paper)
    - **Option B) Broader scope what's available, motivation as an outcome, detailed comparison with a subset as second paper**
  - Maybe a SIG outside of main call? Start with main talk, breakdown into SIGs?
  - Restructure/ breakout discussions
  - Add flight framework comparison to the RTOS listing? ref Ivan's paper?
    - **Manuel / Ivan / Dongshik have interest - need whitepaper access**
  - Tim mentioned a survey of Linux use on Sats that just launched in early 2025 (Tomas N. has more information) - Mentioned a thesis paper is in development by a Czech student
    - **Tim needs whitepaper access**
    - SATGUS (<https://www.spaceselfie.com/>) mid-Jan 2025 - <https://www.nanosats.eu/sat/sat-gus>
      - 3-5 Linux instances
      - Crunchlabs
    - SuperDove SAT - low earth orbit imaging ~140 already up
      - Peican-2 from PlanetLab has Jetson - launched from transporter-12
      - <https://www.planet.com/pulse/planet-launches-high-resolution-pelican-2-satellite-36-superdoves/>

## Licensing and Developer Agreement

- TSC approved approach proposed by SGL - <https://github.com/elisa-tech/tsc/wiki/22-Jan-2025#license-to-use-for-code-contributions>
- Background on DCO - <https://github.com/elisa-tech/sig-sgl/blob/main/meeting-minutes/ELISA-SGLSIG-Meeting-20250125.md#dco--cla>
  - <https://developercertificate.org/>

## Discussion on Features for Aerospace

- Call between Ivan, Martin, Paul, Brian Wood, and I is occurring on testing wkly on Friday @ 9-9:30am CST. The meeting focuses on discussing the testing framework and how to prototype the components together. Anyone is welcome to join us and contact Matt Weber for the invite.
  - Actions from 1/31/2025
    - Ivan – Pushed PR - <https://github.com/elisa-tech/wg-aerospace/pull/15>
    - Matt W to add comments on PR with entrypoint and ubuntu user added (DONE)
    - Brian to share some raw socket examples
    - Paul has a start on the py test apps and is looking at syslog integration with Ivan’s work
    - Matt to see if we can get a qemu build in place that we can run this in
  - Actions from 1/24/2025
    - Ivan - pushing a PR that includes the Dockerfile setting of the environment plus a elisa-monitors/elisa-monitors.cabal that presets the configuration
    - Matt W - Example of raw Ethernet frames and sniffing them (Ivan to test)
    - Document container uid/gid details for developer experience - Matt W to see if he can release entrypoint script
    - Demo to use UDP and syslog - monitors initially will just look at syslog entry transitions (time bound based on use case 500ms)
    - Split into second demo with docker --privileged which would allow the raw MAC frame example - monitors can look at syslog and pkts
  - Actions from 1/17/2025
    - Ivan - push a PR with example Copilot monitor/spec and Dockerfile
    - Brian - verify we can use raw ethernet frames within a ubuntu container for the app communication plus copilot can be in raw mode to sample the ethernet traffic.
    - Matt - update PR with feedback from call that breaks out the instructions steps into a simpler progression
    - PR with start of instructions outline - <https://github.com/elisa-tech/wg-aerospace/pull/12>
    - Martin - try the instructions after Matt pushes updates and plans to checkout Ivan's example PR
- Refs:
  - [Aerospace-Uses-Cases](../docs/Aerospace-Uses-Cases.md)
    - [Diagrams about testing](https://github.com/elisa-tech/wg-aerospace/blob/main/docs/Aerospace-Uses-Cases.md#test)
    - [Next steps](https://github.com/elisa-tech/wg-aerospace/blob/main/docs/Aerospace-Uses-Cases.md#foreseeable-next-steps-tbc-at-on-of-the-next-meetings)

## Future topics

- Douglas shared presentation on containerization - <https://docs.google.com/presentation/d/1ae7vnGsdiTpSaU9KDC1dJsDZHHj62h7jxQBywagFTFw/edit?usp=sharing>

---

---

# Closing

## Action Items

Located in [GitHub Issues](https://github.com/elisa-tech/wg-aerospace/issues)

## Round Table
