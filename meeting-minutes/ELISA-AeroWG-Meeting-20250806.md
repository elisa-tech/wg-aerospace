<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

![logo](https://github.com/elisa-tech/wg-aerospace/blob/main/meeting-minutes/logo_elisa_small.png?raw=true)

## ELISA Aerospace Working Group

The Aerospace Working Group shall develop use cases to inform and influence Linux architecture and related tools, work to derive technical requirements for avionics operating systems, and seek to enhance and expand avionics software lifecycle processes, practices, and tools to enable use of Linux in avionics systems that are certified to high design assurance levels.  (https://lists.elisa.tech/g/aerospace)

# Minutes

## 08 August 2025

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
- Alexey Simonov (TII, UAE)
- Tim Bird (Sony)
- Philip Balister(OpenEmbedded)
- Ivan Perez (KBR @ NASA Ames Research Center)
- Macarena Sagredo
- Vikash Kodati
- Yasushi SHOJI (Space Cubics)

## Attended recently in the past

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
- Manuel Beltran - Boeing
- Matt Kelly - Boeing
- Michael Epley (Redhat)
- Michael Monaghan - NASA Goddard
- Merlin Kooshmanian - ESA
- Naga - Timesys/Lynx
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
- Shefali Sharma
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

- [TSC minutes](https://lists.elisa.tech/g/devel/topic/elisa_tsc_meeting/114449628)
  - OSS EU - [Booth representative](https://lists.elisa.tech/g/devel/topic/reminder_open_source_summit/114530882), Onsite meeting, discount codes and Discord channel.
  - Working on a November 18-20th workshop event.
  - Details on signing up for Discord and accessing our channels
  - Initial proposal around chartering a "Survey/Research about Quality of Open Source"

## Upcoming Events

- July 2025 - Space Mission Challenges for Information Technology Space Computing Conference IEEE (Pasadena, CA) (https://2025.smcit-scc.space/) (Occurring for 20yrs, cross industry/global)
  - Had a 2 day hands on F' tutorial - https://github.com/nasa/fprime
    - Alexey mentioned about adding to Yocto (Grabbing a contact for one of the F' demo leads that might have a start) (Matt plans to mention this to Ramon)
      - F' code generation and prep could be outside of Yocto (Yocto could be used to deploy/host)
      - F' vs cFS - cFS recipes would have less configuration aspects and easier to define a standard binary that could be produced.  Vs. tighter integration of the F' generated binaries
        - Could be something to investigate defining a default configuration against a SGL deployment.  Could start as a documentation activity.
        - cFS as a project is leaning towards a tool that generates a configuration (similar to F')
    - **ACTION**: Ramon, this could be a SGL call topic
- August 5th - Open Source Summit India - Hyderabad, India - https://events.linuxfoundation.org/open-source-summit-india/
- SmallSat Salt Lake City, Utah (AUgust 10-13) -> [link](https://smallsat.org/)
    - Flash Talk by Andrew Wilson (Monday)
    - Is anyone hosting a side chat room for Linux in Space? (was done in past)
- AMD Space Day (August 19, 2025) Registration (San Jose, CA.) -> [link](https://www.feedback.amd.com/se/5A1E27D22E92B566)
  - AMD Space lounge access required [link](https://account.amd.com/en/forms/registration/space.html)
  - Free Registration - Centered around AMD Versal
- August 25-27 Linux Foundation Open Source Summit EU & Embedded Linux Conference https://events.linuxfoundation.org/open-source-summit-europe/
  - [SGL Talk](https://osseu2025.sched.com/event/25VnF/space-grade-linux-building-a-safer-open-source-future-for-space-systems-ramon-roche-linux-foundation)
- DASC 2025: September 14-18, 2025 44th Digital Avionics Systems Conference (https://2025.dasconline.org/) (Montreal, Canada)
- Oct 31 Drone+Space Community Meetup @ KAU (Korea Aerospace University) Ramon & Dongshik Host
  - ELISA Project + Dronecode [link](https://elisa.tech/event/elisa-project-dronecode-foundation-meetup/)
- Nov 4-5 OSS Korea - Safety track it looking for topics! Contact Kate
- Dec 8-10 OSS Japan
- Dec 11-13: Linux Plumbers Conference 2025, in Tokyo (https://lpc.events/)
- ?? NASA SPARK submissions (https://spark.nasa.gov/)

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

[eLinux Space Research](https://elinux.org/Space_Research)

[AeroWG Literature Database](https://github.com/elisa-tech/wg-aerospace/blob/main/literature-database/literature.bib?raw=true) 

See Martin for Overleaf access to our Survey Whitepaper document. (See Whitepaper section below in Tech Topics)

---
---

# Technical Topics

## Use case demo

https://github.com/elisa-tech/wg-aerospace/tree/main/demos/copilot

-	Brief update on Use Case demo work
  - Cabin Lights
    - Completed - native python demo of the CoPilot monitor and rehosted into a minimal ARM64 Linux
    - Completed - similar demo with raw sockets and targeting a minimal Linux
    - Next step - documentation and present the demo
  - NASA Core Flight System (cFS)
    - Experimenting with a build for minimal ARM64 Linux emulation

## Whitepaper on "Survey State of Art..."

(Only touched on actions in today's call)

### Background
- Edits
  - Via online [Overleaf editor](https://www.overleaf.com/) - we have limited licenses so we've shared the pdf link below
  - latex format and editor can generate documents
- Paper's goal - What is the current state of the art with respect to aerospace
  - Initial document drove use case definition
  - Evolved to be a comparison and a conclusion of industry direction
  - Doc still informs goals and activities of AeroWG & Space

### NASA standard vs DO-178 (Ivan had action from last call)
  - Hard to establish equivalency as reverse engineering practice would apply either direction when wanting to reuse artifacts.
  - **Action** - Ivan sent a message to peers about fault rate

### ACTIONS
- Martin can add you as an editor to the paper if you have contributions!  Or you can use our latest pdf on the mailing list and supply comments back in a marked up version.
- Tim offered to help add items from "eLinux Space Research" linked above to the respective location in the paper where they're relevant

## Parking lot items

### Existing use case direction

Possible directions

- Go through the step of the example - lower the entry bar of performing the examples and customizing
- Get a similar example going with cFS.  Would constrain the cFS configuration to a demo stack that is monitored (good base to extend from)

Goal
- Get experience from users / feedback
- SWL-C - Outline what we would need to do to demo
  - Emulation
    - code conversion to C and reduce userspace content
  - HIL - use an accessible drone/HW people can access  (Could follow SGL hardware targets?)
  - **ACTION:**
    - Ivan - checking with CalPoly team (had some F' work shown at IEEE conf)
    - Martin, are you looking for student projects?
    - Ramon, are there any drone/HW ideas that come to mind that we should entertain?
- What are we measuring?
  - fault tolerant aspects
  - message / rate requirements
  - What other ideas do people have?

### New Use Case ideas

Focus ideas from July call
  - (Michael) attested boot - baremetal boot to Linux  (could be a interesting demo for minimal linux config)
  - (Matt W) reduced code count


---
---

# Closing

## Action Items

Located in [GitHub Issues](https://github.com/elisa-tech/wg-aerospace/issues)

## Round Table

