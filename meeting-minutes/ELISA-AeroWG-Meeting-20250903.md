<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

![logo](https://github.com/elisa-tech/wg-aerospace/blob/main/meeting-minutes/logo_elisa_small.png?raw=true)

## ELISA Aerospace Working Group

The Aerospace Working Group shall develop use cases to inform and influence Linux architecture and related tools, work to derive technical requirements for avionics operating systems, and seek to enhance and expand avionics software lifecycle processes, practices, and tools to enable use of Linux in avionics systems that are certified to high design assurance levels. (<https://lists.elisa.tech/g/aerospace>)

# Minutes

## 03 Sept 2025

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
- Shefali Sharma
- Manuel Beltran - Boeing
- Michael Epley (Redhat)
- Naga - Timesys/Lynx
- Brennan Stewart - NASA

## Attended recently in the past

- Alexey Simonov (TII, UAE)
- Tim Bird (Sony)
- Philip Balister(OpenEmbedded)
- Macarena Sagredo
- Vikash Kodati
- Yasushi SHOJI (Space Cubics)
- Abdi Kitesa
- Allen Brown - Odyssey Space Research
- Anshul Makkar - Infinitede
- Andrew Wilson - L3Harris, BYU, FPGA Zealot
- Brennan Stewart - NASA
- Carole Garrison - NASA Langley
- Chuck Wolber - Boeing
- Cyril Jean (Microchip Technology Inc.)
- Daniel Riechers - Collins (Security)
- Douglas Landgraf - Red Hat
- Emmanuel Gravel - Skytrac
- Gabriele Paoloni - Red Hat
- Gaston Gonzalez - VENG
- Gary Crum - Voyager
- Iain Galloway - NXP Semiconductors
- Justin Pearson - Lynx Software
- Laurent Meilleur
- Lenka Koskova - TUL CZ
- Matt Kelly - Boeing
- Michael Epley (Redhat)
- Michael Monaghan - NASA Goddard
- Merlin Kooshmanian - ESA
- Olivier Charrier - Wind River
- Paul Greenwood - Vorago Technologies
- Paul Mani - Collins India
- Phaedrus Leeds - Aerospace Corp
- Piotr Skrzypek - ESA
- Qasim Majeed - Siemens
- Rajesh Kurapati - KMC
- Ramon Roche - LF
- Rob Woolley (Wind River System)
- Sascha Wise - Elodin
- Sam Thompson - Rapita Systems
- Scott Salmon - Cesium
- Steve VanderLeest - Boeing
- Tomas Novotny - Czech Aerospace Research Centre
- Vikash Kodati
- Walt Miner - Linux Foundation
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

## Meetings

- [TSC call](https://lists.elisa.tech/g/devel/topic/elisa_tsc_meeting/115046013)
  - OSS Europe in Amsterdam Recap
  - [Next ELISA Workshop Timing & Location](https://lists.elisa.tech/g/devel/topic/help_us_choose_the_location/115046350)
  - Glossary / Big Picture / Hello World entry
  - Usage of AI in the Linux Kernel development process
  - Survey/Research about Quality of Open Source
  - Transcribing calls

## Upcoming Events

- **(September 14-18)** DASC 2025: 2025 44th Digital Avionics Systems Conference (Montreal, Canada) -> [Link](https://2025.dasconline.org/)
- **(Sept 15-17)** Xen Project Summit (@Xilinx, San Jose, CA.) -> [Link](https://xenproject.org/resources/xen-summit/)
- **(Oct 31)** Drone+Space Community Meetup @ KAU (Korea Aerospace University) Ramon & Dongshik Host -> [Link](https://elisa.tech/event/elisa-project-dronecode-foundation-meetup/)
- **(Nov 4-5)** OSS Korea - Safety track it looking for topics! Contact Kate
- **(Dec 8-10)** OSS Japan
- **(Dec 11-13)** : Linux Plumbers Conference 2025, in Tokyo -> [Link](https://lpc.events/)
- NASA SPARK submissions -> [Link](https://spark.nasa.gov/)

### Recently Past Deadlines

- Flight Software Workshop, Submission Deadline 24th of February, Event: March 24th - 27th. -> [link](https://flightsoftware.org/)
- ELC NA 2025 (and safety critical conference) (June 23-25, Denver)
- ELC EU 2025 (and safety critical conference, and Embedded Linux Conference) (Aug 25-27, Amsterdam)
- SmallSat Salt Lake City, Utah (Aug 10-13, SLC)
- AMD Space Day (Aug 19, San Jose, CA.)

# Resources

## ELISA

[Seminar Library](https://elisa.tech/seminar-series/)

[Technical Directory](https://directory.elisa.tech/)

[Foundation Meetings](https://elisa.tech/community/meetings/)

[AeroWG - Schedule of events, mailing list and meeting minutes](https://lists.elisa.tech/g/aerospace)

## Journals

- Springer CEAS Aeronautical Journal (<https://link.springer.com/journal/13272>)
  - Has a special avionics track
- AIAA Journal: AIAAJ for Aeronautics (<https://arc.aiaa.org/loi/aiaaj>)
- SAE International Journal of Aerospace (<https://www.sae.org/publications/collections/content/E-JOURNAL-01/>)
- Avionics International / Avionics Today (<https://www.aviationtoday.com/>)
  - Less scientific, more industrial-oriented

## Articles / Publications

[Small Satellite Conference](https://digitalcommons.usu.edu/smallsat/)

[eLinux Space Research](https://elinux.org/Space_Research)

[AeroWG Literature Database](https://github.com/elisa-tech/wg-aerospace/blob/main/literature-database/literature.bib?raw=true)

See Martin for Overleaf access to our Survey Whitepaper document. (See Whitepaper section below in Tech Topics)

---

---

# Technical Topics

## GitHub discussions

<https://github.com/elisa-tech/wg-aerospace/discussions>

- You're invited to add new discussions
- Gives you a chance to upvote items

## Use case demo

Goals

- Lowering the level of entry
- Clear tool setup
- Examples of customizing a concept/configuration
- Recreation and observation of a demo
- Discussion on how to tailor/capture specific attributes of the system for other use cases
- Development of new content

[Expected use survey](https://github.com/elisa-tech/wg-aerospace/blob/main/meeting-minutes/ELISA-AeroWG-Meeting-20250605.md?plain=1#L148)

### Update

- Brief update on Use Case demo work
- [Cabin Lights](https://github.com/elisa-tech/wg-aerospace/tree/main/demos/copilot)
  - Completed - native python demo of the CoPilot monitor and rehosted into a minimal ARM64 Linux
  - Completed - similar demo with raw sockets and targeting a minimal Linux
  - Next step - documentation and present the demo
  - Next step - get experience from users / feedback
- NASA Core Flight System (cFS) - <https://github.com/elisa-tech/wg-aerospace/pull/92>
  - Completed - Experimenting with a build for minimal ARM64 Linux emulation
  - Proposing new "NASA cFS running Light Switch app"

- Hardware in the Loop - could use an accessible drone/HW people can access
  - Previous actions / discussion
    - Ivan - checking with CalPoly team (had some F' work shown at IEEE conf)
    - Anyone looking for student projects?
    - Any SGL drone/HW ideas that come to mind that we should entertain?

## Whitepaper on "Survey State of Art..."

- Paper's goal - "What is the current state of the art with respect to aerospace"
- Initial document drove use case definition
  - Evolved to be a comparison and a conclusion of industry direction
  - Doc still informs goals and activities of AeroWG & Space

### Next steps

- Establishing a separate call of "core contributors"
- Charter: “To focus on providing contributions and working through open actions to get to a first draft. Attendees are committed to participating in review and providing timely material.”
- Initial Goals:
  - Complete background and problem statement sections
  - Add a cabin system example to show how to add supporting survey sections
  - Present completed section material to larger group for feedback
- If you're interested, select ALL possible meeting times that work for you! <https://doodle.com/group-poll/participate/axj6nV9d>

## Parking lot items

---

---

# Closing

## Action Items

Located in [GitHub Discussions](https://github.com/elisa-tech/wg-aerospace/discussions)

## Round Table

- See if we can make note of event recordings for past events (vs just dropping the event item without making it a resource.)

- A question was posed "How can an attendee engage, where is the focus? What should an attendee expect to gain from participating?"
  - Use cases
  - Market dynamics
  - OS / customization need
  - TBD what events are important

See <https://github.com/elisa-tech/wg-aerospace/tree/main/meeting-minutes> for the latest meeting minutes.
