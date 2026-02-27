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

# Agenda / Minutes

[Catch us on the Discord Aerospace channel!](https://chat.elisa.tech)

DASC paper submission

- "Survey on State-of-the-Art Aerospace Operating Systems in Avionics"
  – Do we start a SIG for paper development?

Presented the Annual update today - <https://github.com/elisa-tech/wg-aerospace/blob/main/presentations/2026-ELISA-aerospace-wg-Annual_Update.pdf>

- [Discuss the 2026 ideas](https://github.com/elisa-tech/wg-aerospace/discussions/124)
- Add your comments / feedback plus vote on them!

Future presentors

- (Leonidas) Overview of QEMU + custom machine/board models
  - ACTION: Matt/Rob bring up the time ref/sync QEMU topic from 2025 demo call
    - <https://github.com/elisa-tech/wg-aerospace/discussions/119#discussioncomment-15519103>
- ISO26262 vs DO-330 tool certification (What about Space certifications/tools?) - TBD, need to regroup with person that originally requested.
- Nix overview (re-present Lund talk) - Erin der Veen offered to present
- WASM presentation?
- Rust for safety?

[Open PRs](https://github.com/elisa-tech/wg-aerospace/pulls)

- Nix based ELISA demo framework
- A series from Matt on host env fixups / testing
- cFS demo docs

Automotive Grade Linux SoDev architecture

- Where does this fit?
- ACTION: See if SystemsWG could present again on AGL progress in a few months
- What other parts could we present on to grow understanding of the topic space? e.g., partition items, comm/ipc, standards
- Xen FuSa present?

## Awareness items

ELISA annual update event Feb 11 & 12th was recorded and videos should be posted soon.

Xen FuSa (<https://gitlab.com/xen-project/fusa>)

- AMD released more architecture material - <https://gitlab.com/xen-project/fusa/architecture_specs>
- Boeing published a system spec - <https://gitlab.com/xen-project/fusa/fusa-docs/-/merge_requests/15>

Weekly use case demo team

- Working doc and usability updates

SGL last month - [Guest Presentation: Radshield - Software Radiation Protection](https://github.com/elisa-tech/sig-sgl/pull/13/changes#diff-815e83ba7960305da5c6b4fba417dc2240d856e2e802c84e160a4dd8f0c63225R149)

## Tasks until next meeting

See ACTIONS above.

---

# Roll Call

## Attended this meeting

- Matt Weber - Boeing
- Alexey Simonov - TII, UAE
- Michael Monaghan - NASA Goddard
- Shefali Sharma
- Rob Woolley (Wind River)

## Attended recently in the past

[List](https://github.com/elisa-tech/wg-aerospace/blob/main/meeting-minutes/ELISA-AeroWG-Meeting-DATE_template.md#attended-recently-in-the-past)

---

# Announcements

- [Events](https://github.com/elisa-tech/wg-aerospace/blob/main/docs/events.md)

- [Resources](https://github.com/elisa-tech/wg-aerospace/blob/main/docs/resources.md)

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
