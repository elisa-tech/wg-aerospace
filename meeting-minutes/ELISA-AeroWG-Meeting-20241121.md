
![logo](logo_elisa_small.png )

## ELISA Aerospace Working Group

The Aerospace Working Group shall develop use cases to inform and influence Linux architecture and related tools, work to derive technical requirements for avionics operating systems, and seek to enhance and expand avionics software lifecycle processes, practices, and tools to enable use of Linux in avionics systems that are certified to high design assurance levels.  (https://lists.elisa.tech/g/aerospace)

# Minutes

## 21 November 2024

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
- Christopher Heistand (Stoke Space)
- Sam Thompson - Rapita
- Chuck Wolber - Boeing
- Dongshik Won (TelePIX/KAIST)
- Martin Halle - Hamburg University of Technology
- Ivan Perez - NASA Ames
- Tomas Novotny (Czech Aerospace Research Centre)
- Gary Crum (Voyager)
- Ramon Roche - LF
- Manuel Beltran - Boeing
- Michael Monaghan (NASA Goddard)

## Attended recently in the past

- Andrew Wilson (L3Harris)
- Shefali Sharma
- Tim Bird - Sony
- Ramon Roche (LF)
- Brennan Stewart (NASA)
- Tony James (Red Hat)
- David Graziano - Collins
- Olivier Charrier - Wind River
- Paul Mani - Collins India
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

Checkout our [Aerospace working group](https://lists.elisa.tech/g/aerospace) page as part of the ELISA foundation.  It includes a schedule of events, link to join the mailing lists, meeting minutes, and [seminar library](https://elisa.tech/seminar-series/).  

## Upcoming Events

- 10-12 Dec - Hosted by NASA at Goddard Space Flight Center
  - Location: Goddard Space Flight Center https://maps.app.goo.gl/NoVcCPoSEk38ardU6
  - Registration open: https://elisa.tech/event/elisa-workshop-at-at-nasa-goddard-space-grade-linux/  **(Closes on November 25.)**
  - Agenda draft: https://docs.google.com/document/d/1Mytz9pGkTEIVqTnlEKxTpx3ozPt1xFlBqhYrj0gCsRU
  - Attendance ~50 people
  - Conversations will fall under [Chatham House Rules](https://www.chathamhouse.org/about-us/chatham-house-rule) (https://en.wikipedia.org/wiki/Chatham_House_Rule)
  - Virtual attendance is a STRONG maybe for attendees   (pending decision)
  - Virtual attendance possible for speakers.
  - For wider listening some talks may be shared as webinars.
  - Share presented slides later for the ELISA result database.
  - Michael asked about if there will be a slack/chat for the event (Ramon checking)
    - Chris suggested could use [FSW slack](https://join.slack.com/t/fsw-workshop/shared_invite/zt-2v2ya53td-fx_B_c2N_AkR~qKM8pcPEQ) (#space-grade-linux channel)
  - Scheduler finalized week of 11/18
- 25th Feb in Karlsruhe, Germany - 7th Workshop on Avionics Systems and Software Engineering (AvioSE) (https://aviose-workshop.github.io/)
- 24th-27th March in Seattle, WA - Flight Software Workshop (https://flightsoftware.org/workshop/FSW2025)
  - This workshop drove some previous Space Grade Linux topics
  - Lessons learned / BOF-like with presentation
  - Registration/abstracts open - 200 slots
  - Christopher Heistand is chairing
  - Matt Weber and Michael Monaghan submitted an abstract to present an ELISA talk on "Making Penguins Fly"
- July 2025 - Space Mission Challenges for Information Technology Space Computing Conference IEEE (Pasadena, CA) (https://2025.smcit-scc.space/)
  - https://2025.smcit-scc.space/track/smc-it-scc-2025-workshops
  - https://2025.smcit-scc.space/track/smc-it-scc-2025-papers
  - Open source for space workshop (Ivan organizing)
    - Willing to co-chair with others
    - Located @ California Science Center in LA  (close to USC)
    - Does the WG want to be part of this workshop or create our own?
  **- Deadline for workshop proposal submissions Dec 13th & Feb 3rd for papers**
- Aug - SmallSat - Call for paper is open (Due Feb 4th) - https://www.smallsat.org/downloads/call-for-papers.pdf
- DASC 2025: September 14-18, 2025 44th Digital Avionics Systems Conference (https://2025.dasconline.org/) (Montreal, Canada)

## Articles / Publications

See our [Literature Database](../literature-database/literature.bib)

See our [Draft(April 18th, 2024 revision) Whitepaper](../docs/20240418_ELISA_AeroWG_Whitepaper.pdf)

---
---
# Technical Topics

## Survey Results
- Ramon has results, but presentation during workshop will make it available
- Struggled to get results, up for ideas for how to gain more feedback.  Is the survey to big?
- Survey shared through mailing lists / social media and project contacts
- Link - https://elisa.tech/space-grade-linux-sig/

## December 10-12 Workshop
- Registration link above under events
- Any discussion for our call?

## FSW submission

Title: Making Penguins Fly

Abstract: This presentation will touch on the objectives, challenges, and developments of the Enabling Linux in Safety Applications (ELISA) foundation's Aerospace and Space Grade Linux working group (WG.) The presentation will include specific topics from a Dec 10-12 Goddard Space Flight Center workshop.  ELISA was formed to make it easier for companies to build and certify Linux-based safety-critical applications – systems whose failure could result in loss of human life, significant property damage, or environmental damage. ELISA members are working together to define and maintain a common set of tools and processes that can help companies demonstrate that a Linux-based system meets the necessary safety requirements for certification. The Aerospace Working Group develops use cases to inform and influence Linux architecture and related tools, works to derive technical requirements for avionics operating systems, and seeks to enhance and expand avionics software lifecycle processes, practices, and tools to enable the use of Linux in avionics systems that are certified to high design assurance levels. Space grade Linux, which recently made its open-source debut as an ELISA Special Interest Group (SIG), is a collaborative, open-source project bringing together space agencies, industry, academia, and non-profit organizations to establish a trusted ecosystem of Linux-based, open-source software for mission-critical spacecraft operations.

Please join Matthew Weber and Michael Monaghan for this presentation on Making Penguins Fly. Matt is a Chief Software Architect at The Boeing Company and Chair of the Aerospace WG. Matt's 18 years of experience focuses on leveraging open-source software into embedded aerospace and defense systems. Michael is a Software Engineer at NASA and leads the Space Grade Linux SIG. Michael has developed Linux-based software at NASA for over 8 years at Goddard Space Flight Center. Michael has worked on various cubesats, ISS experiments, and custom processor cards throughout his career.


## Discussion on Features for Aerospace

Next use case (Space focused?)
  - What are the dependencies for running frameworks (CFS, etc) on top?
    - Using CFS dockerfile as setup instructions for the userspace part plus look at what is required in minimal kernel
  - Would this apply to cubesats?  (Could start here and grow towards larger example?)
    - Could be used for incubating university projects (Michael)
  - Impacts to criticality/rigor (what standards would apply in a cubesat case? Class C? )
    - Criticality & cost factors into Class
  - Any feedback from the survey that could help inform this?
  - https://www.polysat.org/
    - From: https://digitalcommons.calpoly.edu/cgi/viewcontent.cgi?article=1720&context=eesp
    - "the PolySat software architecture runs entirely on a custom Linux operating system"
    - Maybe a group for user feedback for what we define (design, prototype)
  - https://www.jpl.nasa.gov/missions/mars-cube-one-marco/ 
  - https://www.asi.it/en/planets-stars-universe/solar-system-and-beyond/liciacube/
  - NASA Spark - https://www.nasa.gov/directorates/stmd/prizes-challenges-crowdsourcing-program/center-of-excellence-for-collaborative-innovation-coeci/nasa-spark/
    - SpaceROS advancements
    - Could use as a way for the community to contribute
    - Starting point for us - having an example deployment/build and some basic documentation
  - Stoke is resurrecting this one (Chris): https://github.com/SOL-Space-Operating-Linux/meta-sol
    - (MIT License) https://github.com/SOL-Space-Operating-Linux/Documentation/blob/master/LICENSE
  - Where would we host the space examples and what licensing / CLAs (https://lfx.linuxfoundation.org/tools/easycla/)?  (Michael checking internal to NASA on how this might work)
    - ACTION - Matt to follow up with Michael, Kate and Ramon to see if this is a SIG topic we breakout for.
    - Could start to breakout Space community building topic

<br>

The use case discussion is focusing on testing.  
- We are seeking volunteers to write the test apps and stage an emulation environment based on the discussion.  Contact Matt Weber if interested.
- Moved the notes on emulation approaches to a ref section in use case document
- (Ivan) I have the Copilot code ready. It's very simple.
  - From the point of view of connecting it to the rest of the testing infrastructure, all I need is:
    - A boolean (global variable) that indicates if the light switch is on or off.
    - A boolean (global variable) that indicates if the lights are on.
  - I can also connect it if you give me a function that allows me to "sense" if the light switch is on/off, and whether the lights are on/off. There are other ways to connect it (e.g., SW bus, etc.).


  Refs:
  - [Aerospace-Uses-Cases](../Aerospace-Uses-Cases.md)
    - [Next steps](https://github.com/elisa-tech/wg-aerospace/blob/main/Aerospace-Uses-Cases.md#foreseeable-next-steps-tbc-at-on-of-the-next-meetings)
    - [Collaboration doc](https://mensuel.framapad.org/p/elisa-aerowg) (used during our WG calls and sync'd with Aerospace-Uses-Cases.md)



---
---

# Closing

## Action Items

Located in [GitHub Issues](https://github.com/elisa-tech/wg-aerospace/issues)

## Round Table

