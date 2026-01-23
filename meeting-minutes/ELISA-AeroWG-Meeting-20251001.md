<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

![logo](https://github.com/elisa-tech/wg-aerospace/blob/main/meeting-minutes/logo_elisa_small.png?raw=true)

## ELISA Aerospace Working Group

The Aerospace Working Group shall develop use cases to inform and influence Linux architecture and related tools, work to derive technical requirements for avionics operating systems, and seek to enhance and expand avionics software lifecycle processes, practices, and tools to enable use of Linux in avionics systems that are certified to high design assurance levels.  (https://lists.elisa.tech/g/aerospace)

# Minutes

## 01 Oct 2025

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
- Martin Halle - Hamburg University of Technology
- Tim Bird (Sony)
- Wanja Zaeske - DLR
- Philip Balister (OpenEmbedded)
- Rob Woolley (Wind River)
- Pavel Roskin
- Manuel Beltran - Boeing
- Vikash Kodati

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
- Phaedrus Leeds - Aerospace Corp
- Philip Balister - OpenEmbedded
- Piotr Skrzypek - ESA
- Qasim Majeed - Siemens
- Rajesh Kurapati - KMC
- Ramon Roche - LF
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

## Meetings

- [TSC call minutes](https://mensuel.framapad.org/p/elisa-tsc-minutes-a9tp)

## Upcoming Events

- **(Oct 28)** LXF EU Members Summit -> [Link](https://elisa.tech/event/the-linux-foundation-europe-member-summit/)
- **(Nov 4-5)** OSS Korea -> [Link](https://elisa.tech/event/open-source-summit-seoul-south-korea-2025/)
  - "Intro and Consideration of Temporal Partitioning in Avionics"
- **(Nov 18-19)** ELISA Workshop [Link](https://elisa.tech/event/elisa-workshop-munich-2025/)
  - Proposed sessions (paper ideas, intro to safety rigor/levels w/ examples, demos)
  - Registration is now also open!  [Link](https://czw--04.na1.hs-sales-engage.com/Ctc/RI+23284/cZw--04/JkM2-6qcW6N1vHY6lZ3mXW8p3-sx1rYFMdW10ST4Y3QSmknW3wHFgK19hk9nW8X5DFJ7qmp-rW4-Xwxc12wZrMW6Gm3hc9h-h8yW6HQ1yt3WZvSPW6PFDGB5H8wlRW5Th7Dk4tlLMMW85bf8V8hnbH-VMdFwK6cKWzbW5V1Ssj8bxY-9VXYLzr33jv2sW33Wjbz2CQhC_W7cVF864W7hVrW8RCJpT6FkSLgW4Tw3v3879vSWN43KBFCqxfM7W41Y-GJ5Z-qrKW8PV0Bb7QDKqmW5KlR0S7PXgbGW3KQ8Y55-YrbCf5cx88004)
- **(Dec 8-10)** OSS Japan -> [Link](https://elisa.tech/event/open-source-summit-tokyo-japan-2025/)
- **(Dec 11-13)** : Linux Plumbers Conference 2025, in Tokyo -> [Link](https://lpc.events/)
- NASA SPARK submissions -> [Link](https://spark.nasa.gov/)


### Recently Past Deadlines/Events

- **(September 14-18)** DASC 2025: 2025 44th Digital Avionics Systems Conference (Montreal, Canada) -> [Link](https://2025.dasconline.org/)
  - IEExplorer has the materials (Martin can share specific ones if needed)
  - AI in aerospace, safety/security aspects, new HW/processors, multi-core, coverage, air mobility, formal methods, MBSE modeling / AADL, SysML v2
  - Papers Martin: detailed sim of hw - driver/os, high performance extensions for avionics, formal model for configuration mgmt
  - Papers Wanja: SyMLv2 model storage in SQlite, WebAsm as platform independent code + cert reuse benefits
  - Paper Steve: Open Source MCDC coverage tool (i.e. for CI/CT of linux kernel)
  - ACTION: Ask Steve/Andrew about how to share the coverage paper / presentation
- **(Sept 15-17)** Xen Project Summit (@Xilinx, San Jose, CA.) -> [Link](https://xenproject.org/resources/xen-summit/)


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

See Martin for Overleaf access to our Survey Whitepaper document. (See Whitepaper section below in Tech Topics)

---
---

# Technical Topics

## Requirements for OS used in Use-Cases
  - Should we capture the reasons for being different (timing, footprint, simplicity, minimization, radiation, etc)? [YES but with caution]
    - Carrier set high level threshold and then distros could show they met the requirements
      - Performance and promotional - prove productization of Linux is real in commercial cases
    - Need at least a charter / scope
    - What are our themes / KPIs which would justify capturing this as different?
      - e.g. stronger EDAC  (Suggested by Tim and Rob has interest)
      - ACTION: Next call topic on KPI?
  - Where should we capture these?
    - Could use paper approach to guide (model/lessons learned) this and similar structure to Carrier content?  Could be split of the basics of minimal system vs distro level features (e.g. even between AeroWG/SGL)
  - Patterns
    - Could we follow the Carrier Grade Linux example? “config guidance plus self-compliance approach”
      - https://wiki.linuxfoundation.org/cgl/start
      - https://www.static.linuxfound.org/sites/main/files/CGL_5.0_Specification.pdf
    - Just tooling?  Could extend https://github.com/elisa-tech/kconfig-safety-check ?
    - Example of minimal config work - https://github.com/elisa-tech/wg-lfscs/tree/main/min_prog_trace
      - LFSCS mission https://github.com/elisa-tech/wg-lfscs/blob/main/mission.md
    - Automotive grade linux definitions
      - https://www.automotivelinux.org/wp-content/uploads/sites/4/2017/08/agl_spec_v1_280515.pdf
      - https://www.automotivelinux.org/wp-content/uploads/sites/4/2018/06/GoogleDrive_The-AGL-software-defined-connected-car-architecture.pdf
  - How do we do it in a way to be inclusive of other distros?


## Meeting times / slots

ACTION: Need to setup next meeting call - email pending with ELISA on getting Zoom call

We’ve had a few discussions in different calls about adjusting our meeting frequency and aligning time slots.

What are everyone’s thoughts on these options that get our calls consistently at the same times so the slots better align as a recurring meeting each week.

Wednesday10-11am CDT
- 1st wk – AerospaceWG
- 2nd wk – Space SIG
- 3rd wk – AerospaceWG Paper  (new call)
- 4th wk – Space SIG

Thursday 10-11am CDT
- 1st wk – Aerospace
- 2nd wk – Space SIG
- 3rd wk – AerospaceWG Paper (new call)
- 4th wk – Space SIG

## Alternative Environments for Use-Cases

(Wanja presenting nixos - https://nixos.org/)

Problem space - what is an env we can use to build kernels and systems for demostration.  (build, debug, compose)

- Minimal kernel - tiny config
  - nix abstraction to support multiple architectures (conditional kconfig)  plus multiple Kernel revs
- System building
  - Has a split of initramfs and kernel builds
  - nix composition via config that defines the ramfs content
  - Wrappers QEMU launch
  - Wrapper for QEMU kernel debugging

Single command, reproducible workflow if you have nix shell.
Reference snapshot (Wanja): https://github.com/wucke13/minimal-nixos/

Questions
- Is this the step to hardware configs / bsp support?
- Where does this fit between AeroWG or SGL?  AeroWG is chartered to define "use cases" and we stretched that to provide example demos.  Does this just provide organizing of "demos"?
- Could initially cleanup https://gitlab.com/elisa-tech/aero-wg/demo-cert-linux/-/blob/main/build_minimal.sh?ref_type=heads using this approach?  MRs welcome!

## Parking lot items

Lab grid project
- Lab grid is a board managment framework (similar Lava)
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

