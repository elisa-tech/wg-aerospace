<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

![logo](https://github.com/elisa-tech/wg-aerospace/blob/main/meeting-minutes/logo_elisa_small.png?raw=true)

## ELISA Aerospace Working Group

The Aerospace Working Group shall develop use cases to inform and influence Linux architecture and related tools, work to derive technical requirements for avionics operating systems, and seek to enhance and expand avionics software lifecycle processes, practices, and tools to enable use of Linux in avionics systems that are certified to high design assurance levels.  (https://lists.elisa.tech/g/aerospace)

# Minutes

## 13 Nov 2025

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
- Rob Woolley (Wind River)
- Tim Bird (Sony)
- Philipp Ahmann (ETAS GmbH)
- David Graziano - Collins (Security)
- Martin Halle - Hamburg University of Technology
- Alexey Simonov - TII, UAE
- Naga - Timesys/Lynx
- Ivan Perez - KBR @ NASA Ames Research Center
- Manuel Beltran - Boeing
- Philip Balister - OpenEmbedded
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
- 4th week - Aerospace Industry Papers (Authoring Call)

## Related Meeting Minutes

- [ELISA Tech Steering Committee](https://mensuel.framapad.org/p/elisa-tsc-minutes-a9tp)
- [Space Grade Linux SIG](https://hackmd.io/GQalb89nRj-W2PWRy6NDqA)

## Upcoming Events

- **Nov 18-19** ELISA Workshop [Link](https://elisa.tech/event/elisa-workshop-munich-2025/)
  - Registration is for virtual!  [Link](https://czw--04.na1.hs-sales-engage.com/Ctc/RI+23284/cZw--04/JkM2-6qcW6N1vHY6lZ3mXW8p3-sx1rYFMdW10ST4Y3QSmknW3wHFgK19hk9nW8X5DFJ7qmp-rW4-Xwxc12wZrMW6Gm3hc9h-h8yW6HQ1yt3WZvSPW6PFDGB5H8wlRW5Th7Dk4tlLMMW85bf8V8hnbH-VMdFwK6cKWzbW5V1Ssj8bxY-9VXYLzr33jv2sW33Wjbz2CQhC_W7cVF864W7hVrW8RCJpT6FkSLgW4Tw3v3879vSWN43KBFCqxfM7W41Y-GJ5Z-qrKW8PV0Bb7QDKqmW5KlR0S7PXgbGW3KQ8Y55-YrbCf5cx88004)
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

# Technical Topics

## ELISA Systems WG

- [Xen demo Overview](https://github.com/elisa-tech/wg-systems/blob/main/Documentation/xen-demo-zcu102/Readme.md)
  - Xen+Zephyr+Linux
  - Similar to Software Defined Vehicle architecture
    - ACTION: Need to research AGLs development and how we might build on it (2026 has new work in AGL with SysWG collaborating)
  - German DAKLIF Project (Next-gen Cabin platform) - (Martin mentioned)
  - Many partners, Martins (TUHH) partner page is here:
    - https://hdl.handle.net/11420/43243
- **ACTION:**, AGL will have some outbrief in the next week we should share out.

## Munich Workshop
There is still time to register for next week as a virtual participant - https://elisa.tech/event/elisa-workshop-munich-2025/

## Requirements for OS used in Use-Cases

How do we want to splitup the problem to define charter / scope of the requirement set?

What are the aspects which justify capturing this as different?

### Cabin Entertainment System

| Product Aspect(s) | Details | Notes |
| --- | --- | --- |
| Operational duration:  | 5-10yrs | |
| Userdata update cycle: | 60 days | |
| Platform update cycle: | ~yearly | Driven by cybersecurity and hardware obsolescence |
| Software Level:     | E | Still some level of software practice is followed to ensure functionality |
| App Capability:     | graphical interface, streaming video, PA announcements, Internet connected, aircraft data  | |
| System Constraints: | Latency sensitive, responsive, redundant (optional)  | |
| Protocols:          | TCP/IP, Video steaming, HDMI, SSL  | Standards driven. |
| IO:                 | Ethernet, touchscreen, display, leds, buttons, WiFi, Bluetooth, stereo audio jack | |
| Dataload/fieldload: | OTA | Most likely not considered part of the aircraft configuration so update approach and timing is flexible. |
| OS standards:       | POSIX, Networking RFCs, Video codecs, Security algorithms | |
| OS footprint:       | Large | 2M+ SLOC |
| Languages:          | C/C++, JAVA, Python, Golang, Javascript | Open development environment and compilers with few limitations. |
| Storage:            | 256GB+ | |
| Memory:             | 2GB+ | |
| CPU frequency:      | > ~1Ghz | (not a performance comparison) |
| CPU cores:          | 4+ | |
| Tool Qualification: | None | Development practice most likely at least archives tools and identifies their use. Not restrictive. |


### Fight control system

| Product Aspect(s) | Details | Notes |
| --- | --- | --- |
| Operational duration:  | 30+yrs (most likely ~50+) | |
| Userdata update cycle: | Nav/Metadata monthly | |
| Platform update cycle: | 4-8yrs | Likely NO OS upgrade, just patching - Security risk analysis has to drive layered architectures to allow CVEs to coexist for years of continued operation |
| Software Level:     | A/B | |
| App Capability:     | Product-focused custom apps, parsing ARINC data | |
| System Constraints: | Deterministic, simple, radiation hardened, reliability | |
| Protocols:          | NA | |
| IO:                 | ARINC429/717/664/825 | Similar to serial, CAN bus, Ethernet |
| Dataload/fieldload: | ARINC-based mediaset via ARINC615a dataloader | |
| OS standards:       | ARINC653 modular operating system | |
| OS footprint:       | Small | < 200k SLOC |
| Languages:          | C, ADA | (Future) RUST |
| Storage:            | 512MB - low GB | |
| Memory:             | 512MB - low GB | |
| CPU frequency:      | 600Mhz - ~1Ghz | (not a performance comparison) |
| CPU cores:          | 1 | |
| Tool Qualification: | Likely | Special development environment and compilers |

## Parking lot items

- Reference Systems workflow and approach

- Lab grid project
  - Lab grid is a board management framework (similar to Lava)
  - E.g. deploy SW to board, configure SUT etc. into different configurations
  - Greatly facilitates a test frameworks, by managing HW in convenient way
      - Coordinates/manages connections to board (serial, power, usb)
  - Comes with a PyTest plugin
  - ACTION: Invite Lab grid developers to present capabilities and background? https://github.com/emantor
  - ACTION (Matt): Mention to Ramon as this might be good for SGL call

---
---

# Closing

## Action Items

Located in [GitHub Discussions](https://github.com/elisa-tech/wg-aerospace/discussions)

## Round Table

See https://github.com/elisa-tech/wg-aerospace/tree/main/meeting-minutes  for the latest meeting minutes.
