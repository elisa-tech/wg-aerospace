Link to contribute live to the Meeting Minutes:
- https://hackmd.io/@AS9atTJpQgeXj_ICWAprZw/By850egu1g/edit

Link to the Meeting's Zoom event:
- https://zoom-lfx.platform.linuxfoundation.org/meeting/93217874199?password=0305e3a3-21c3-43a1-8369-d24c39334eec

See https://github.com/elisa-tech/wg-aerospace/tree/main/meeting-minutes for the latest meeting minutes.

![logo](https://github.com/elisa-tech/wg-aerospace/blob/main/meeting-minutes/logo_elisa_small.png?raw=true)

## ELISA Aerospace Working Group, 4th Weeks Paper-focussed Meeting (see schedule below)

The Aerospace Working Group shall develop use cases to inform and influence Linux architecture and related tools, work to derive technical requirements for avionics operating systems, and seek to enhance and expand avionics software lifecycle processes, practices, and tools to enable use of Linux in avionics systems that are certified to high design assurance levels.  (https://lists.elisa.tech/g/aerospace)

# Minutes

## 27 Nov 2025

Decided upon how to organise te paper meetings as follows:
- Work on the paper:
  - Show/ briefly discuss new content, assing reviewers, if needed
  - Decide on chaptes addressed next, maybe what to focus on
  - Discuss ideas for new content
- Task distribution:
  - Who does what untl the next Paper meeting (roughly every 4 weeks, see ELISA schedule)

Todays additional topics:
- Introduce paper topics to new audience
- Show / discuss results from Questionaire
  - Priorisation / decisions
    - Paper Topic no. 1 has most votes: 5
    - Todays team focusses on Paper Topic no. 1: Voting: 4/4
- Team building
  - Team for Paper Topic no. 1 as of today: Rob, Shefali, Leonidas, Martin
- Make editor on overleaf: Shefali, Rob, Leonidas
  - (Make some old editors viewers due to the lack of large edtior groups)
- Make aware of "_todo_.tex" file in Overleaf collecting upcoming ToDos
- Introduce new "_howto_.tex" file in Overleaf describing how to collectively work (WIP)

# Tasks until next meeting:

- (Rob): Problem Statement: Economics: Different distro, kernel... -> Declaring certain sets of requirements and specific versions, may lead to reduced cost -> long-term support for "ELISA-Aero-Linux"
- Leonidas: (Read paper as-is), what is too much Space and not Aerospace?
- Shefali: (Read paper as-is), what is too much Space and not Aerospace?
- Martin: System-figure: Decided on today: OK, go ahead; New: Describe in the text
- Martin: HowTo's on Overleaf

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

- Martin Halle - Hamburg University of Technology
- Leonides Kosmidis - BSC
- Rob Woolley - Wind River
- Shefali Sharma

## Attended recently in the past

- Abdi Kitesa
- Alexey Simonov - TII, UAE
- Allen Brown - Odyssey Space Research
- Anshul Makkar - Infinitede
- Andrew Wilson - L3Harris, BYU, FPGA Zealot
- Brennan Stewart - NASA
- Carole Garrison - NASA Langley
- Chuck Wolber - Boeing
- Cyril Jean - Microchip Technology Inc.
- Daniel Riechers - Collins (Security)
- David Graziano - Collins (Security)
- Douglas Landgraf - Red Hat
- Emmanuel Gravel - Skytrac
- Gabriele Paoloni - Red Hat
- Gaston Gonzalez - VENG
- Gary Crum - Voyager
- Iain Galloway - NXP Semiconductors
- Ivan Perez - KBR @ NASA Ames Research Center
- Justin Pearson - Lynx Software
- Laurent Meilleur
- Lenka Koskova - TUL CZ
- Leonides Kosmidis - BSC
- Macarena Sagredo
- Manuel Beltran - Boeing
- Martin Halle - Hamburg University of Technology
- Matt Kelly - Boeing
- Michael Epley - Redhat
- Michael Monaghan - NASA Goddard
- Merlin Kooshmanian - ESA
- Naga - Timesys/Lynx
- Olivier Charrier - Wind River
- Paul Greenwood - Vorago Technologies
- Paul Mani - Collins India
- Pavel Roskin
- Phaedrus Leeds - Aerospace Corp
- Philipp Ahmann - ETAS GmbH
- Philip Balister - OpenEmbedded
- Piotr Skrzypek - ESA
- Qasim Majeed - Siemens
- Rajesh Kurapati - KMC
- Ramon Roche - LF
- Rob Woolley (Wind River)
- Sascha Wise - Elodin
- Sam Thompson - Rapita Systems
- Scott Salmon - Cesium
- Shefali Sharma
- Steve VanderLeest - Boeing
- Tim Bird (Sony)
- Tomas Novotny - Czech Aerospace Research Centre
- Vikash Kodati
- Walt Miner - Linux Foundation
- Wanja Zaeske - DLR
- Yasushi SHOJI - Space Cubics

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

(NEW) Monthly meeting schedule - 10-11am CST (UTC-06)
- 1st week - Open slot
- 2nd week - Aerospace WG (General Call)
- 3rd week - Space Grade Linux
- 4th week - Aerospace Industry Papers (Authoring Call) << TODAY!!!

## Related Meeting Minutes

- [ELISA Tech Steering Committee](https://mensuel.framapad.org/p/elisa-tsc-minutes-a9tp)
- [Space Grade Linux SIG](https://hackmd.io/GQalb89nRj-W2PWRy6NDqA)

## Upcoming Events

- **Dec 8-10** Open Source Summit Japan 2025, Tokyo [link](https://events.linuxfoundation.org/open-source-summit-japan/)
  - SGL Keynote
- **Dec 11-13** : Linux Plumbers Conference 2025, in Tokyo -> [Link](https://lpc.events/)
  - Free Virtual LIVE stream during the event or $50 for interactive
  - Safe Systems with Linux MC -> [List of Topics](https://lpc.events/event/19/contributions/?config=0edacdbc-94ad-4caf-ac7a-352f9bebdb35)
  - Presentation: "Measuring Test Coverage of Kernel Object Code"
- **Jan 27-29** Core Flight System Symposium LMI Headquarters, in Tysons, VA
  - ****ACTION: Possibly similar topics with FSW? (Ivan/Matt?)**
- **Mar 23-26** Flight Software Workshop, Laurel, MD [link](https://flightsoftware.org/)
  - **Submission Deadline December 4**
  - Vision of WG?
  - Use case demo work?
- **Feb 25** AvioSE 2026, Bern -> [link](https://aviose-workshop.github.io/)
  - Call for papers until: Dec 01, 2025
  - Co-located with Systems Engineering Workshop: [link](https://se2026.inf.unibe.ch/en/workshops/aviose/)
- NASA SPARK submissions -> [link](https://spark.nasa.gov/)


### Recently Past Deadlines/Events

- **(Nov 4-5)** OSS Korea -> [Link](https://elisa.tech/event/open-source-summit-seoul-south-korea-2025/)
  - [DO-330 Qualification of Enhanced LLVM Structural Coverage Tool - Minji Park & Seojin Kim](https://www.youtube.com/watch?v=0JQLazypIHQ)
  - [Introduction and Consideration of Temporal Partitioning in Avionics With Open... - H. Kim & G. Kwon](https://www.youtube.com/watch?v=B9nwghDGDeI)
- **Nov 18-19** ELISA Workshop [Link](https://elisa.tech/event/elisa-workshop-munich-2025/)
  - Registration is for virtual!  [Link](https://czw--04.na1.hs-sales-engage.com/Ctc/RI+23284/cZw--04/JkM2-6qcW6N1vHY6lZ3mXW8p3-sx1rYFMdW10ST4Y3QSmknW3wHFgK19hk9nW8X5DFJ7qmp-rW4-Xwxc12wZrMW6Gm3hc9h-h8yW6HQ1yt3WZvSPW6PFDGB5H8wlRW5Th7Dk4tlLMMW85bf8V8hnbH-VMdFwK6cKWzbW5V1Ssj8bxY-9VXYLzr33jv2sW33Wjbz2CQhC_W7cVF864W7hVrW8RCJpT6FkSLgW4Tw3v3879vSWN43KBFCqxfM7W41Y-GJ5Z-qrKW8PV0Bb7QDKqmW5KlR0S7PXgbGW3KQ8Y55-YrbCf5cx88004)

# Resources

## ELISA
[Seminar Library](https://elisa.tech/seminar-series/)
[Technical Directory](https://directory.elisa.tech/)
[Foundation Meetings](https://elisa.tech/community/meetings/)
[AeroWG - Schedule of events, mailing list and meeting minutes](https://lists.elisa.tech/g/aerospace)

## Journals

- Springer CEAS Aeronautical Journal (https://link.springer.com/journal/13272)
  - Has a special avionics track
- AIAA Journal: AIAAJ for Aeronautics (https://arc.aiaa.org/loi/aiaaj)
- SAE International Journal of Aerospace (https://www.sae.org/publications/collections/content/E-JOURNAL-01/)
- Avionics International / Avionics Today (https://www.aviationtoday.com/)
  - Less scientific, more industrial-oriented

## Articles / Publications

[Small Satellite Conference](https://digitalcommons.usu.edu/smallsat/)
[eLinux Space Research](https://elinux.org/Space_Research)
[AeroWG Literature Database](https://github.com/elisa-tech/wg-aerospace/blob/main/literature-database/literature.bib?raw=true) 

---
---

## Parking lot items

---
---

# Closing

## Action Items

Located in [GitHub Discussions](https://github.com/elisa-tech/wg-aerospace/discussions)

## Round Table

See https://github.com/elisa-tech/wg-aerospace/tree/main/meeting-minutes  for the latest meeting minutes.
