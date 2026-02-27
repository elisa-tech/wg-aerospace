<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

Link to contribute live to the Meeting Minutes:

- <https://hackmd.io/@AS9atTJpQgeXj_ICWAprZw/By850egu1g/edit>

Link to the Meeting's Zoom event:

- <https://zoom-lfx.platform.linuxfoundation.org/meeting/93217874199?password=0305e3a3-21c3-43a1-8369-d24c39334eec>

![logo](https://github.com/elisa-tech/wg-aerospace/blob/main/meeting-minutes/logo_elisa_small.png?raw=true)

## ELISA Aerospace Working Group

The Aerospace Working Group shall develop use cases to inform and influence Linux architecture and related tools, work to derive technical requirements for avionics operating systems, and seek to enhance and expand avionics software lifecycle processes, practices, and tools to enable use of Linux in avionics systems that are certified to high design assurance levels. (<https://lists.elisa.tech/g/aerospace>)

# Minutes

- Automotive Grade Linux SoDev architecture - <https://www.automotivelinux.org/announcements/sodev/>
  - Could outline a comparison with safety levels?
  - Redraw the picture from our view?
  - Retarget a existing demo to the framework
  - Could start from systemsWG view - <https://github.com/elisa-tech/wg-systems/tree/main/Documentation/xen-demo-zcu102>
  - ACTION: Matt to share a outline on mailing list to drive some discussion in Jan call

## Requirements for OS used in Use-Cases

- Questions that formed the brainstorming around the product profiles
  - How do we want to splitup the problem to define charter / scope of the requirement set?
  - What are the aspects which justify capturing this as different?

[Product Profile template](../docs/product-profiles.md#template---name-of-notional-system)

## Interest in ISO26262 vs DO-330 tool certification (presentation in Jan / Feb)?

Feedback

- It would have ties to paper development
- What about Space certifications/tools?
- ACTION: Matt will reach out to those that offered to discuss

---

# Roll Call

## Attended this meeting

- Matt Weber - Boeing
- Martin Halle - Hamburg University of Technology
- Daniel Witte - Astro Mechanica
- Alexey Simonov - TII, UAE
- Michael Mahoney - Wind River
- Manuel Beltran - Boeing
- Naga - Timesys/Lynx
- Paul Mani - Collins India
- Rob Woolley (Wind River)
- Shefali Sharma

## Attended recently in the past (do not delete)

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
- Justin Pearson - Lynx Software
- Laurent Meilleur
- Lenka Koskova - TUL CZ
- Macarena Sagredo
- Manuel Beltran - Boeing
- Martin Halle - Hamburg University of Technology
- Matt Kelly - Boeing
- Matt Weber - Boeing
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
