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

## Old topics

**Carry-over ACTIONs**

- Added AvioNix seminar to register.md
  - https://github.com/elisa-tech/wg-aerospace/pull/254
- ACTION: Matt to ask Cody if the Xen Summit 2026 (Sept 15-17) will be recorded
- Microchip - QEMU pre-built for HPSC (license/binary distro check)
  - Brian Vandegriend joined to share more on QEMU acces
  - QEMU looking at register def (approval to release)
  - A workflow hinted at in [SGL build example](https://sgl.elisa.tech/building-pic64hpsc.html) has additional tools / dependencies to boot
  - Two routes
      - NDA access (Contact Tao.Lang@microchip.com) - build steps/use follow existing Microchip docs
        - (Alternative) Microchip/ELISA collab on adding a receipe to [meta-mchp](https://github.com/pic64-hpsc-hx/meta-mchp.git) to add the custom native QEMU - I.e. Users with NDA access do a Yocto build that folds the Microchip internal repos in (including any addition *.bins required to boot)
          - This path would allow us to simplify the SGL building/run instructions to be closer to [basic risc-v example.](https://sgl.elisa.tech/building.html)
      - Binary release
          - User would [build Step1](https://sgl.elisa.tech/building-pic64hpsc.html#step-1-build-space-grade-linux) to get Linux Kernel/Rootfs/u-boot
          - Microchip provides script to
            - Package Step 1 output into `*.bins` needed for QEMU
            - Prebuilt QEMU binary built in TBD container
            - Prebuilt QEMU additional `*.bins` (e.g. sysc)
          - User takes Mirochip output to [run manual QEMU](https://sgl.elisa.tech/building-pic64hpsc.html#alternative-manual-qemu-launch)
      - Everything upstreamed for sustainment (no vendor closed portions)

## New topics

**Use case call updates** (from weekly calls 8/28, 9/4)

- Devcontainer workflow demo - starting from a new user's perspective ([README](https://github.com/elisa-tech/wg-aerospace#elisa-aerospace-working-group))
  - ACTION: add link to demo
  - SGL SDK -> cFS build instructions: add docs to meta-aerospace
- Ogma: template-expansion change complete, staged for end-of-Sept release; block-diagram gen for cFS (Ivan investigating)
  - Simulink generation
  - Similar concepts to our demo flew in space (Ogma + Copilot + cFS)

- FYI: LLVM Qualification Working Group - functional-safety review request -> <https://llvm.org/docs/QualGroup.html>
  - Reusable across IEC 61508, EN 50716, ISO 26262, IEC 62304, DO-178C/DO-330
  - TPL-001 merged; review of generic templates sought (esp. TPL-003, TPL-004) -> <https://github.com/llvm/llvm-wgs/pulls>
  - Relevant to evaluating GCC, QEMU, OpenFastTrace usage in Xen FuSa WG
  - Other refs
    - Rust tool qual - https://ferrocene.dev/
    - RTEMS used GCC, was there any tool qual?

- SEL4 on HPSC (ACTION: Brennan offered to ask Dornerworks to present)

**Next time**

- cFS on Minimal Linux: growing NASA interest; Ivan checking NASA contribution opportunity to capture scenarios

- **Roundtable / brainstorming for the main call** - what topic to bring next?

**GitHub PRs** - <https://github.com/elisa-tech/wg-aerospace/pulls>

- [#237](https://github.com/elisa-tech/wg-aerospace/pull/237) Update cFS demo to use Ogma 1.15.0 (DRAFT)
- [#231](https://github.com/elisa-tech/wg-aerospace/pull/231) feat: add ARINC 615A Tool Suite
- [#179](https://github.com/elisa-tech/wg-aerospace/pull/179) Minimal linux kernel plan draft (DRAFT)
- [#177](https://github.com/elisa-tech/wg-aerospace/pull/177) Mixed crit workshop
- [#148](https://github.com/elisa-tech/wg-aerospace/pull/148) docs: add GodelEDGE onboard satellite AI inference product profile
- [#68](https://github.com/elisa-tech/wg-aerospace/pull/68) Listen for messages to monitors coming from RAW sockets (DRAFT)

**Parking lot**

- Radiation testing - <https://github.com/elisa-tech/wg-aerospace/issues/151>
- Clean up landing page structure - <https://github.com/elisa-tech/wg-aerospace/issues/159>
- Further NASA flight support - <https://github.com/elisa-tech/wg-aerospace/issues/158>
- Python and Makefile structure - <https://github.com/elisa-tech/wg-aerospace/issues/157>
- [Mixed criticality discussions](https://terminplaner6.dfn.de/en/p/a56b64ee888e0c0f528fc4aaa86ba5e7-1835668)

## Tasks until next meeting

---

# Roll Call

## Attended this meeting

- Matt Weber - Boeing
- Ivan Perez - KBR @ NASA Ames Research Center
- Leonidas Kosmidis - Barcelona Supercomputing Center
- Brian Vandegriend - Microchip (PIC64-HPSC project SW)
- Yassine Cherni - GoMyRobot
- Brennan Hay - NASA GSFC
- Michael Monaghan - NASA GSFC
- Hihara Hiroki
- Rob Woolley - Wind River
- Shefali Sharma

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


---

See https://github.com/elisa-tech/wg-aerospace/blob/main/README.md for access to meeting minutes, events and other resources!**