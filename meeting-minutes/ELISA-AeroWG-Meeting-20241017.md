
![logo](logo_elisa_small.png )

## ELISA Aerospace Working Group

The Aerospace Working Group shall develop use cases to inform and influence Linux architecture and related tools, work to derive technical requirements for avionics operating systems, and seek to enhance and expand avionics software lifecycle processes, practices, and tools to enable use of Linux in avionics systems that are certified to high design assurance levels.  (https://lists.elisa.tech/g/aerospace)

# Minutes

## 17 October 2024

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
- Martin Halle - Hamburg University of Technology
- Tim Bird - Sony
- Christopher Heistand (Stoke Space)
- David Graziano - Collins
- Michael Monaghan (NASA Goddard)
- Olivier Charrier - Wind River
- Sam Thompson - Rapita
- Paul Mani - Collins India
- Tomas Novotny (Czech Aerospace Research Centre)
- Allen Brown (Odyssey Space Research)
- Ivan Perez - NASA Ames

## Attended recently in the past

- Chuck Wolber - Boeing
- Shefali Sharma
- Ramon Roche (LF)
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
- Manuel Beltran - Boeing
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
  - Registration open: https://elisa.tech/event/elisa-workshop-at-at-nasa-goddard-space-grade-linux/
  - Agenda draft: https://docs.google.com/document/d/1Mytz9pGkTEIVqTnlEKxTpx3ozPt1xFlBqhYrj0gCsRU
  - Virtual attendance possible for speakers.
  - For wider listening some talks may be shared as webinars.
  - Share presented slides later for the ELISA result database.
- 25th Feb in Karlsruhe, Germany - 7th Workshop on Avionics Systems and Software Engineering (AvioSE)
  - **(NEW) Call for Papers and further information on: https://aviose-workshop.github.io/**
- 24th-27th March in Seattle, WA - Flight Software Workshop (https://flightsoftware.org/workshop/FSW2025)
  - Presentation only - submissions start ~Oct 14th (ends ~Dec)
  - This workshop drove some of the Space Grade Linux topics
  - Lessons learned / BOF-like with presentation
  - Registration/abstracts open - 200 slots
  - Christopher Heistand is chairing
    - [MW]  **Ask Michael about proposing some talks.  Status of RT primer with stats?? Maybe a combo of space and non-space perspective?**  Chat with Kate?
- July 2025 - Space Mission Challenges for Information Technology Space Computing Conference IEEE (Pasadena, CA)
  - Workshops (deadline for submissions Fall 2024) and papers
  - **Do we want to propose a topic?  Or a Space workshop at the event with ELISA topics?(ELISA was a sponsor in prior 2 yrs)**
- Aug - SmallSat - Call for paper is open - https://www.smallsat.org/downloads/call-for-papers.pdf
- DASC 2025: September 14-18, 2025 44th Digital Avionics Systems Conference (https://2025.dasconline.org/) (Montreal, Canada)

## Articles / Publications

See our [Literature Database](../literature-database/literature.bib)

See our [Draft(April 18th, 2024 revision) Whitepaper](../docs/20240418_ELISA_AeroWG_Whitepaper.pdf)

---
---
# Technical Topics

## Space Grade Linux (SGL)

- Survey: [Shape the Future of Linux in Space](https://lists.elisa.tech/g/aerospace/topic/help_shape_the_future_of/108506014)
  - Marketing push pending staff recovering from LPC
  - End date (not set yet)
  - Ramon sent email to  list offering to meet and gather partial details / product independent feedback

## December 10-12 Workshop
- Planning call topics
  - Looking for food sponsors (Contact Kate if interested)
- Rough survey of attendance has most of those on the call being virtual
- Looking for speakers (Contact Min/Kate if interested)
  - **ACTION** - follow up needed for discussing content / speakers (Michael / Matt W)
  - Ted Wilcox from NASA NEPP is willing to talk NVM with radiation teting (Christopher coordinated, possibly some other talks if we want to pull other topics in)

## Discussion on Features for Aerospace

In a prior meeting, we stopped at "use cases" and "System functional tests / measurement (blackbox)".

Continue the discussion series, now in a separate document:
[Aerospace-Uses-Cases](../docs/Aerospace-Uses-Cases.md) -- [[Next steps]](https://github.com/elisa-tech/wg-aerospace/blob/main/docs/Aerospace-Uses-Cases.md#foreseeable-next-steps-tbc-at-on-of-the-next-meetings)

[Collaboration doc](https://mensuel.framapad.org/p/elisa-aerowg)

---
---

# Closing

## Action Items

Located in [GitHub Issues](https://github.com/elisa-tech/wg-aerospace/issues)

## Round Table

