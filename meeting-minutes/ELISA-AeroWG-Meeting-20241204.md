<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

![logo](logo_elisa_small.png)

## ELISA Aerospace Working Group

The Aerospace Working Group shall develop use cases to inform and influence Linux architecture and related tools, work to derive technical requirements for avionics operating systems, and seek to enhance and expand avionics software lifecycle processes, practices, and tools to enable use of Linux in avionics systems that are certified to high design assurance levels. (<https://lists.elisa.tech/g/aerospace>)

# Minutes

## 04 December 2024

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
- Piotr Skrzypek - ESA
- Tim Bird - Sony
- Manuel Beltran - Boeing
- Christopher Heistand (Stoke Space)
- Wanja Zaeske - DLR
- Ivan Perez - NASA Ames
- Walt Miner - Linux Foundation
- David Graziano - Collins
- Andrew Wilson (L3Harris)
- Paul Mani - Collins India
- Shefali Sharma
- Alexey Simonov

## Attended recently in the past

- Sam Thompson - Rapita
- Chuck Wolber - Boeing
- Dongshik Won (TelePIX/KAIST)
- Martin Halle - Hamburg University of Technology
- Tomas Novotny (Czech Aerospace Research Centre)
- Gary Crum (Voyager)
- Ramon Roche - LF
- Michael Monaghan (NASA Goddard)
- Ramon Roche (LF)
- Brennan Stewart (NASA)
- Tony James (Red Hat)
- Olivier Charrier - Wind River
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
- Jeannette Nounagnon - Boeing (Aurora)
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

- 10-12 Dec - Hosted by NASA at Goddard Space Flight Center
  - Location: Goddard Space Flight Center <https://maps.app.goo.gl/NoVcCPoSEk38ardU6> (Registration Closed)
  - Schedule: <https://elisa.tech/event/elisa-workshop-at-at-nasa-goddard-space-grade-linux/>
  - ACTION - share links post conference to slides / videos(if recorded)
- 25th Feb in Karlsruhe, Germany - 7th Workshop on Avionics Systems and Software Engineering (AvioSE) (<https://aviose-workshop.github.io/>)
- 24th-27th March in Seattle, WA - Flight Software Workshop (<https://flightsoftware.org/workshop/FSW2025>)
  - This workshop drove some previous Space Grade Linux topics
  - Lessons learned / BOF-like with presentation
  - Registration/abstracts open - 200 slots
  - Christopher Heistand is chairing
  - Matt Weber and Michael Monaghan submitted an abstract to present an ELISA talk on "Making Penguins Fly"
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

## Articles / Publications

See our [Literature Database](../literature-database/literature.bib)

See our [Draft(April 18th, 2024 revision) Whitepaper](../docs/20240418_ELISA_AeroWG_Whitepaper.pdf)

---

---

# Technical Topics

## Meetings

- (Per TSC) Please note that all ELISA meetings from December 23-January 3 will be cancelled.
- (Per TSC) Starting from January 6th, we will use the LFX Meeting for all ELISA meetings. For a sneak peak of what that may look like please go to the ELISA public meeting calendar here <https://zoom-lfx.platform.linuxfoundation.org/meetings/elisa-project>. Currently we have the Safety Architecture meeting scheduled on the calendar and we will migrate all meetings to LFX Meeting during the December holiday break so they're ready to roll out in January. The meeting joining links will change and more details to receive a direct calendar invite will be shared as migration completes.

## Space Grade Linux SIG - collaboration and codebase?

- NASA Spark - <https://www.nasa.gov/directorates/stmd/prizes-challenges-crowdsourcing-program/center-of-excellence-for-collaborative-innovation-coeci/nasa-spark/>
  - SpaceROS advancements
  - Could use as a way for the community to contribute
  - Starting point for this group? - having an example deployment/build and some basic documentation
- Stoke is resurrecting this one (Chris): <https://github.com/SOL-Space-Operating-Linux/meta-sol>
  - (MIT License) <https://github.com/SOL-Space-Operating-Linux/Documentation/blob/master/LICENSE>
- Where would we host the space examples and what licensing / CLAs (<https://lfx.linuxfoundation.org/tools/easycla/>)? (Michael checking internal to NASA on how this might work)
  - ACTION - Matt to follow up with Michael, Kate and Ramon to see if this is a SIG topic we breakout for.
    - [Matt] **Email sent to Kate, Ramon, Min, Martin and Michael**
    - [Matt] **I'd encourage those in person at the Workshop to discuss this topic**
- **What do people think about breaking out Space topics in another call?** (Ideas below)
  - every two weeks at set time (vs offset to drive attendance)
  - calls grouped with specific tech side focus / aerospace requirements
  - establish a slack/Discord to start the out of band topics / development (would need to see where this applies and what topics work with this medium)
  - github / gitlab where do we centralize chats/discussions/issues/code dev/CICD/etc
  - allows longer threads and discussion to be managed (helps time zone disconnects)
  - AGL, most start with email and move over to Discord

## Discussion on Features for Aerospace

The use case discussion is focusing on testing.

Open Actions

- Call between Ivan, Martin and I on testing (framework and prototyping the parts together)
- We are seeking volunteers to write the test apps and stage an emulation environment based on the discussion. Contact Matt Weber if interested.

  Refs:
  - [Aerospace-Uses-Cases](../docs/Aerospace-Uses-Cases.md)
    - [Next steps](https://github.com/elisa-tech/wg-aerospace/blob/main/docs/Aerospace-Uses-Cases.md#foreseeable-next-steps-tbc-at-on-of-the-next-meetings)
    - [Collaboration doc](https://mensuel.framapad.org/p/elisa-aerowg) (used during our WG calls and sync'd with Aerospace-Uses-Cases.md)

---

---

# Closing

## Action Items

Located in [GitHub Issues](https://github.com/elisa-tech/wg-aerospace/issues)

## Round Table
