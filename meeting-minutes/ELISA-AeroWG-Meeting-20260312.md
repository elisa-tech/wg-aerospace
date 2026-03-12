
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

Resources
-	[What do you mean when you say...?](https://elisa.tech/ambassadors/2026/03/04/what-do-you-mean-when-you-say/)
-	[Annual updates](https://directory.elisa.tech/annual-update/index.html#february-2026)
- Looking for working group materials?  Checkout our [Document and information register](https://github.com/elisa-tech/wg-aerospace/blob/main/docs/register.md)
- Got questions? Catch us on the Aerospace channel! - https://chat.elisa.tech

## Old topics

Future presentations

- Nix overview (re-present Lund talk) - Status: Need to set a date
- (Leonidas) Overview of QEMU + custom machine/board models - Status: pending presenting to wkly call first (April+)
- ISO26262 vs DO-330 tool certification (What about Space certifications/tools?) - TBD, need to regroup with person that originally requested.
  - https://gtd-gmbh.de/cat-a/
  - Gap analysis between ISO26262 and ECSS ESA-funded project
    - Presentation: https://indico.esa.int/event/552/contributions/11077/attachments/7092/12988/ASIL2ECSS_EDHPC_2025.pdf
    - Paper: https://ieeexplore.ieee.org/document/11325998/ (open access link to follow)
  - Matt: find RTCA committee link that did standards translation 
- RTEMS (NASA presentation) we can get access to with details on certification impacts as part of a EU funded safety activity - mixed criticality workloads / HPSC as an example
- ISO vs ECSS gaps - https://indico.esa.int/event/552/contributions/11077/
- WASM presentation?
- Rust for safety?
- (Ivan R) safety barrier concept to allow Linux + GPU to co-exist with safety functions (COTS incorporation): 
publication: https://ieeexplore.ieee.org/document/10396004/ open access: https://upcommons.upc.edu/server/api/core/bitstreams/aa16766c-6c29-4891-83cb-8073ddcc5fea/content
presentation: https://indico.esa.int/event/445/contributions/8413/
- Experience with radiation testing on Linux

Automotive Grade Linux SoDev architecture

- Where does this fit?
- What other parts could we present on to grow understanding of the topic space? e.g., partition items, comm/ipc, standards
- Xen FuSa present? - ACTION:  ELISA seminar series is being discussed to share an update on this

## New topics

News on Industry Paper submission - Martin shared the DSAC plans for the paper and presentation.  The paper group will meet regularly and contact Martin if looking to support.
- Next call Tues Mar 17th.
- Email traffic preparing for brief Mar 26th call Matt will hold with Martin out

Any discussion on SGL emails

GodelEDGE PR - https://github.com/elisa-tech/wg-aerospace/pull/148

Any interest in organizing radiation testing with SGL? (will try to bring up in next call)

(Didn't get to)Use case demo team - Next steps on Minimal Kernel


## Tasks until next meeting

- ACTION: See if SystemsWG could present again on AGL progress in a few months
- ACTION: Matt/Rob bring up the time ref/sync QEMU topic from 2025 demo call
  - <https://github.com/elisa-tech/wg-aerospace/discussions/119#discussioncomment-15519103>


---

# Roll Call

## Attended this meeting

- Matt Weber - Boeing
- Ivan Perez - KBR @ NASA Ames Research Center
- Alexey Simonov - TII, UAE
- Shefali Sharma
- Ivan Rodriguez - Coros Space
- Martin Halle - Hamburg University of Technology
- Leonidas Kosmidis (Barcelona Supercomputing Center)
- Ganapathi N

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
