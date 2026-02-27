<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

![logo](logo_elisa_small.png)

## ELISA Aerospace Working Group

The Aerospace Working Group shall develop use cases to inform and influence Linux architecture and related tools, work to derive technical requirements for avionics operating systems, and seek to enhance and expand avionics software lifecycle processes, practices, and tools to enable use of Linux in avionics systems that are certified to high design assurance levels. (<https://lists.elisa.tech/g/aerospace>)

# Minutes

## 19 December 2024

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
- Tim Bird - Sony
- Ivan Perez - NASA Ames
- Chuck Wolber - Boeing
- Ramon Roche - LF
- Olivier Charrier - Wind River
- Martin Halle - Hamburg University of Technology
- Sam Thompson - Rapita Systems
- Carole Garrison - NASA Langley
- Michael Monaghan - NASA Goddard
- Christopher Heistand (Stoke Space)
- Sascha Wise (Elodin)
- Andrew Wilson (L3Harris, BYU, FPGA Zealot)

## Attended recently in the past

- Piotr Skrzypek - ESA
- Manuel Beltran - Boeing
- Wanja Zaeske - DLR
- Walt Miner - Linux Foundation
- David Graziano - Collins
- Paul Mani - Collins India
- Shefali Sharma
- Alexey Simonov
- Dongshik Won (TelePIX/KAIST)
- Tomas Novotny (Czech Aerospace Research Centre)
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
- Steve VanderLeest - Boeing
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
  - CFP: should open soon (not available yet)
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

## Meetings

- (Matt W) For 2025, I've requested we keep our current schedule of two calls a month, but instead of different start times, they are now sync'd to both be at 4pm UTC (10am CST). I also requested that the first call is Aerospace focused and the second Space. This is welcome to feedback!
- Co-lead for space - Thank you Ramon & Ivan for doing this!
- (Per TSC) Please note that all ELISA meetings from December 23-January 3 will be cancelled.
- (Per TSC) Starting from January 6th, we will use the LFX Meeting for all ELISA meetings. For a sneak peak of what that may look like please go to the ELISA public meeting calendar here <https://zoom-lfx.platform.linuxfoundation.org/meetings/elisa-project>. The meeting joining links will change and more details to receive a direct calendar invite will be shared as migration completes.

**Our next call will be on Jan 16th and have a Space Grade Linux focus. Make sure to go sign up on <https://zoom-lfx.platform.linuxfoundation.org/meetings/elisa-project> for both Aerospace and Space meetings! For Space, go to Jan 16th, click on the entry and then click Register to get an email with the invite. For Aerospace, go to Feb 5th, click on the entry and then click Register to get an email with the invite.**

## Discussion on Features for Aerospace

**Next/future Agenda topic**

- Restart "Survey State of Art" paper? (Ivan and Martin briefly discussed today)
  - Maybe a SIG outside of main call? Start with main talk, breakdown into SIGs?
  - Restructure/ breakout discussions
  - <https://github.com/elisa-tech/wg-aerospace/blob/main/docs/20240418_ELISA_AeroWG_Whitepaper.pdf>

The use case discussion is focusing on testing.

Open Actions

- Call between Ivan, Martin and I on testing (framework and prototyping the parts together) is tentatively scheduled for Jan 17th 10am CST.
- We are seeking volunteers to write the test apps and stage an emulation environment based on the discussion. Contact Matt Weber if interested.
- [Diagrams under testing](https://github.com/elisa-tech/wg-aerospace/blob/main/docs/Aerospace-Uses-Cases.md#test) are updated, do they represent the test scenario?

  Refs:
  - [Aerospace-Uses-Cases](../docs/Aerospace-Uses-Cases.md)
    - [Next steps](https://github.com/elisa-tech/wg-aerospace/blob/main/docs/Aerospace-Uses-Cases.md#foreseeable-next-steps-tbc-at-on-of-the-next-meetings)
    - [Collaboration doc](https://mensuel.framapad.org/p/elisa-aerowg) (used during our WG calls and sync'd with Aerospace-Uses-Cases.md)

## Space Grade Linux

- Workshop feedback
  - AGL - Walts discussion on what worked / not - FTEs didnt' work, LXF had to fund the effort with AGL members funding.
  - Cubesat kit reference (Sascha) for use as a demo like AGL does with their "Green Machine"
    - Pumpkin cubesat hardware - kit with one running linux <https://www.cubesatshop.com/product/pumpkin-cubesat-kits/>
    - beagleV-Fire ($150) would be an interesting target (Microchip Polarfire SoC, Flash-based FPGA)
    - HPC target - The Microchip Pic64 ($20,000) is probably the best target for HPSC RISC-V
  - Survey - 24 responses, presented during workshop
    - <https://linuxfoundation.research.net/r/space-grade-linux>
    - <https://docs.google.com/presentation/d/16-if-cPPnd47iphI6hK-9DVCrYPNjfg4RNI9AxSmlPQ/edit?usp=sharing>
  - Space ROS - willing to setup Docker image composing together w/SGL
    - End to end space focused robotics deployment
    - Simulations of missions (community contributions) - interesting combinations of data sources to drive
      - SPARK project funded a crowdsourced contribution call for these simulations
        - Companies / individuals / first time contributors
      - Simulation systems: Gazebo, Isaac SIM, Trick
  - Decoder of industry standards / cert methods to what usually falls under which ranges of features/capability
    - Ivan shared -Survey on Robotics and Flight Software Frameworks for the Lunar Surface (LuCCI project)
      - Part of Lunar Command and Control Interoperability Project
      - Email Ivan for access ivan.perezdominguez(at)nasa.gov
    - NPR7150.2 Compliance in Space ROS
      - Email Ivan for access ivan.perezdominguez(at)nasa.gov
  - Semiconductor faults talk - side conversation on why cubesats with COTS hardware don't have more faults - Tim found - <https://scholarlypublications.universiteitleiden.nl/handle/1887/82454>
    - Andrew might have a future talk on approaches for increasing reliability
    - go MRAM for bootup firmware! :-)
    - maybe a CREAME96 demo for understanding orbits and shielding
- Jan Meeting
  - Agenda topics
    - Setting vision statement / goals?
      - Revisit survey to understand our users
      - Identify who wants to work on it (in what capacity)
      - Review AGL lessons learned
    - Location of slides/video from workshop
    - Codebase contrib figured out (Kate has some ideas on license and CLA)
      - NASA side working on how to facilitate collaboration / release of material (Michael working through @ GODDARD)
        - AMES has a workflow and licensing that has worked in the past
      - Community establishment, does NASA sponsor or is it under the LXF umbrella
    - Code base - ?clone AGL configs - **Action: Michael to investigate**
    - HW requirements for a demo (Could we find a group building a cubesat that we could collaborate with? Student groups?)
      - Balloon launches / sounding rockets
      - USU students GAP: <https://www.usu.edu/physics/gas/>
      - Corp users that have missions and can align vs. grass roots with more research/foundation push
      - Cal Poly has some minimizing SWAP cases - launching the Cubesats, IIRC. This was 2017-2019
      - Space SDR example?
      - OS follows the kits and seems like something that isn't needing to be solved. What do we need to make them care about?
    - How does the technology / route SGL takes translate to product use?

- Collaboration environment/tools
  - Questions were sent to TSC to ask about preferred tooling / environments
  - Worked through using ELISA project environment and automation to see if that can be leveraged. (Github driving Gitlab CICD.)

---

---

# Closing

## Action Items

Located in [GitHub Issues](https://github.com/elisa-tech/wg-aerospace/issues)

## Round Table
