<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

Link to contribute live to the Meeting Minutes:
- https://hackmd.io/4-50o2_1Rce60mFJUNYnsQ?both

Link to the Meeting's Zoom event:
- https://zoom-lfx.platform.linuxfoundation.org/meeting/93217874199?password=0305e3a3-21c3-43a1-8369-d24c39334eec

![logo](https://github.com/elisa-tech/wg-aerospace/blob/main/meeting-minutes/logo_elisa_small.png?raw=true)

## ELISA Aerospace Working Group

The Aerospace Working Group shall develop use cases to inform and influence Linux architecture and related tools, work to derive technical requirements for avionics operating systems, and seek to enhance and expand avionics software lifecycle processes, practices, and tools to enable use of Linux in avionics systems that are certified to high design assurance levels.  (https://lists.elisa.tech/g/aerospace)

# Agenda / Minutes

- Review last call's minutes - https://github.com/elisa-tech/wg-aerospace/pull/112/files

## Old topics

- Automotive Grade Linux [SoDev architecture](https://www.automotivelinux.org/announcements/sodev/)
  - [Notional AeroWG env/scenarios](https://github.com/elisa-tech/wg-aerospace/pull/113/files) we could map to SoDev
  - The intent is to tie our work with ELISA Sys WG that is aligned with this SoDev efforts.  
  - I.e., We'd express how our area would approach aspects and why (most likely using the Product aspects in the template below.)


- Requirements for OS used in Use-Cases - [Product Profile template](../docs/product-profiles.md#template---name-of-notional-system)
  - Comments are still welcome on [the merged PR](https://github.com/elisa-tech/wg-aerospace/pull/112/files#diff-963b6c432c9167c6ff9b914734bc978258dbd95b4c2b04f11a17b2b263e21a21R82)

## New topics

### RISC-V in Space

- There is a space-focused SIG call -- "Capture requirements relevant to space"
- If you are interested, join the mailing list: https://lists.riscv.org/g/sig-space/messages
- You can become a member as individuals (it's free) or through your organization if they are already a member (there is a membership fee, with exception for open source organizations, but you need to apply for them)
- Once you are a member, you can join the weekly calls (unlike ELISA, the calls are only open to members).
- The first call will be on January 8,2026
- There are also TG/WG/SIGs for Functional Safety, Automotive, Post Quantum Crypto etc which might be interesting for ELISA Aerospace Group.
- Feel free to join the corresponding mailing lists and join the calls. Call calendar: https://tech.riscv.org/calendar/
- SIG Space Proposal of Work: https://riscv.atlassian.net/wiki/spaces/SPC/pages/543719540/Space+SIG+PoW

### Open PRs

https://github.com/elisa-tech/wg-aerospace/pulls

#### Wanja Demo examples

- Description in https://github.com/elisa-tech/wg-aerospace/issues/114
- Looking at concepts on making demo examples less complicated
  - PR proposes an example concept based off the issue points
  - Builds a kernel / ramfs, no application
- Meeting feedback
  - Action -> encouraged others to review
  - Still within existing use cases - looking to refine to the basics of the demo
  - Question Ivan: Does Nix (with a steep learning curve) is OK to use or introduce hurdles?
  - General question: Who would be happy to use Nix environment and contribute to this new environment?
  - General feedback (trials on the PR) are welcome!

### Space artifacts / awareness email from SGL list

https://lists.elisa.tech/g/space-grade-linux/message/142

[Points from Scott's email]

- Having a set of verifiable requirements for Linux
- Being able to reduce down the scope/resources (this is why yocto is popular)
  - Run on the smallest amount of resources/slow hardware, radiation tolerant hardware is still generations behind and single core (since multi-core V&V is much harder)
  - [From Aero call]
    - Definitely two camps of old and new approach with resource impact vs. safety vs. constraining requirements - For sure a challenge for SGL to address
    - Do we use linux for partitioning?  How far can Linux isolation address requirements?
    - [Manuel] DO-178C historically has more structured guidelines and objectives to approach partitioning.  This would need reestablished if doing Linux alone.
    - [Wanja] This was our research-y attempt at doing partitioning based on namespaces and cgroups: https://github.com/DLR-FT/arinc653-wasm
- Tests and evidence of meeting requirements and functionality
  - In space, we care more about reliability, control, and known actions
-  Security aspects (While I do not need all the controls from NIST SP 800-53, we need to be able to show proper security)
-  Real-time constraints
-  Protection from Common-Cause failures
-  Awareness of contributors and IP rights, and ITAR/EAR Laws
   - Some uses will not allow “unknown” or foreign contributors

## Tasks until next meeting

- Fix invites as Jan/Feb are mixed up with an extra week.

### Interest in ISO26262 vs DO-330 tool certification (presentation in Jan / Feb)?

- It would have ties to paper development
- What about Space certifications/tools?
- ACTION: Matt will reach out to those that offered to discuss

---

# Roll Call

## Attended this meeting

- Matt Weber - Boeing
- Ivan Perez - KBR @ NASA Ames Research Center
- Ivan Rodriguez - Coros Space
- Josh Whitehead - Boeing
- Wanja Zaeske - DLR
- Manuel Beltran - Boeing
- Michael Mahoney - Wind River
- Michael Monaghan - NASA Goddard
- Martin Halle - Hamburg University of Technology
- Philip Balister - OpenEmbedded
- Tim Bird - Sony
- Leonidas Kosmidis (Barcelona Supercomputing Center)
- Shefali Sharma
- Rob Woolley - Wind River
- Laurent Meilleur

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
- Daniel Witte - Astro Mechanica
- David Graziano - Collins (Security)
- Douglas Landgraf - Red Hat
- Emmanuel Gravel - Skytrac
- Gabriele Paoloni - Red Hat
- Gaston Gonzalez - VENG
- Gary Crum - Voyager
- Iain Galloway - NXP Semiconductors
- Ivan Perez - KBR @ NASA Ames Research Center
- Ivan Rodriguez - Coros Space
- Joshua Whitehead - Boeing
- Justin Pearson - Lynx Software
- Laurent Meilleur
- Lenka Koskova - TUL CZ
- Leonidas Kosmidis (Barcelona Supercomputing Center)
- Macarena Sagredo
- Manuel Beltran - Boeing
- Martin Halle - Hamburg University of Technology
- Matt Kelly - Boeing
- Matt Weber - Boeing
- Michael Epley - Redhat
- Michael Mahoney - Wind River
- Michael Monaghan - NASA Goddard
- Merlin Kooshmanian - ESA
- Naga - Timesys/Lynx
- Olivier Charrier - Wind River
- Paul Greenwood - Vorago Technologies
- Paul Mani - Collins India
- Pavel Roskin
- Phaedrus Leeds - Aerospace Corp
- Philip Balister - OpenEmbedded
- Philipp Ahmann (ETAS GmbH)
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

# Announcements

- [Events](../docs/events.md)

- [Resources](../docs/resources.md)

- [Action Items](https://github.com/elisa-tech/wg-aerospace/discussions)

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
