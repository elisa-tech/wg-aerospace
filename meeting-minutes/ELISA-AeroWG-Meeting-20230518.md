![logo](logo_elisa_small.png )
## ELISA Aerospace Working Group 
# Minutes 
## 18 May 2023


---
# Agenda
- Roll Call
- Brief Notices
- Announcements
- Mandate and Goals
- Work on Survey Paper
- Prepare Discussion Agenda
- Closing
    - Next Steps
    - Action Items
    - Round Table


---
# Roll Call

## Attended this meeting
- Steve VanderLeest – Boeing
- Qasim Majeed
- Sam Thompson – Rapita
- Matt Kelly - Boeing


## Attended in the past
- Sebastien Boria
- Sam Bristow
- Olivier Charrier – Wind River
- Stefano Dell'Osa - Intel
- Martin Halle – TUHH
- Shuah Khan – Linux Foundation
- Lenka Koskova – TUL CZ
- Rajesh Kurapati - KMC
- Sam Thompson – Rapita
- Ulises V
- Steve VanderLeest – Boeing
- Richard Wagener
- Chuck Wolber – Boeing
- Jeremy York - Boeing
- Wanja Zaeske - DLR


---
# Brief Notices

## Code of Conduct and Legal Notices
* ELISA Project meetings involve participation by industry competitors, and it is the intention of the Linux Foundation to conduct all of its activities in accordance with applicable antitrust and competition laws. It is therefore extremely important that attendees adhere to meeting agendas, and be aware of, and not participate in, any activities that are prohibited under applicable US state, federal, or foreign antitrust and competition laws.
    * [Linux Foundation Antitrust Policy](http://www.linuxfoundation.org/antitrust-policy)
* Email communication will be treated as documentation and be received and made available by the Project under the [Creative Commons Attribution 4.0 International License](http://creativecommons.org/licenses/by/4.0). Please refer to the ELISA Technical Charter section 7 subsection iv. for details.
* The discussions in these meetings are exploratory. The opinions expressed by participants are not necessarily the policy of the companies.
* No recordings of working group meetings are permitted. Special provisions may be arranged for recording in advance with explicit consent of the participants.
* The kernel and LF Code of Conduct applies to all communication with this project
    * [Linux Foundation Code of Conduct](https://www.linuxfoundation.org/code-of-conduct/)
    * Linux [Contributor Covenant Code of Conduct](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/code-of-conduct.rst)
    * Linux Kernel Contributor Covenant [Code of Conduct Interpretation](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/code-of-conduct-interpretation.rst)


## Mandate
The Aerospace Working Group shall develop use cases to inform and influence Linux architecture and related tools, work to derive technical requirements for avionics operating systems, and seek to enhance and expand avionics software lifecycle processes, practices, and tools to enable use of Linux in avionics systems that are certified to high design assurance levels.

## 2023 Goals
* Establishing our operations as a new working group
* Survey on the state of the art within aerospace on use of Linux and associated certification approach and equivalent Design Assurance Level (DAL)
* Identify the challenges to adopting Linux in aerospace
* Identify candidate use cases using Linux


---
# Announcements

* No meeting on Wed 7 Jun 2023
* Next meeting is Thu 15 Jun 2023, Steve is away, so Matt will lead

## Upcoming Conferences
* [Embedded Open Source Summit](https://events.linuxfoundation.org/embedded-open-source-summit/) - 27-30 June 2023
* [Digital Avionics Systems Conference](https://2023.dasconline.org/) - 1-5 Oct 2023
* [Aerospace TechWeek](https://www.aerospacetechweek.com/americas/) - 14-15 Nov 2023




---
# Features Required for Aerospace
A future discussion will cover "Features Required for Aerospace". Next steps are to create an agenda for the discussion (see below for start).


## Scope
* Discussion at this time 
  * limited to aerospace (subsequent discussions may be broadened to other domains)
  * will be on an entire distribution (subsequent discussions may focus narrowly on the kernel)
  * will cover all criticality (software levels), but may sort answers by level
  * will we time limit each major section so that all are covered in first meeting, schedule subsequent meetings on narrower topics as needed

## What are the outcomes of discussion?
* List of features
  * Features that are essential to include
  * Features that are essential to remove (via configuration)
* Refinement of our Aerospace use-case
* Convergence of our focus
* Next steps for our list of features
  * Convincing the Linux community to focus on these features, e.g., providing more comprehensive testing, architecture
  * Develop patch sets to make things more configurable to achieve our defined feature list
  * List to help us compare with other working group list of features
    * The differences in lists should be examined and may imply gaps

## Configuration
* How do we configure a subset of features with robust configuration management (e.g., kernel config files)
* What configuration of which features are supported according to what schedules
* How do de-risk (or even deactivate) those not needed?
* Do we configure via kernel config, via yocto recipe, something else?
  * May be able to derive a aero-specific kernel config
 

## Method of identifying features
* Driven by use cases
* What are the criteria for inclusion of features?


## Features identification
* What features must be supported?  
* Obtaining necessary and sufficient timing and precision
* List of system functions that must be able to run and their requirements
* Supported I/O
* What resources must be available for which criticality levels  


---
# Closing


## Action Items
Located in [GitHub Issues](https://github.com/elisa-tech/wg-aerospace/issues)

## Round Table


---
# Future Discussion Topics
Rank-ordered discussion topics

* In progress
    * Survey paper
    * What features must be supported?  How do de-risk (or even deactivate) those not needed?
* Future topics
    * Needs for compiling documentation (Shuah and Kate, starting with work from Medical Devices WG)
        * E.g., Tracing a workload, [Tracing With Ftrace: Critical Tooling For Linux Development](https://www.linuxfoundation.org/webinars/tracefs-the-building-blocks-of-linux-kernel-tracing-by-ftrace?hsLang&#61;en)
        * [PATCH v3 docs: add workload-tracing document to admin-guide](https://lore.kernel.org/linux-doc/Y9nkqhAS6EW2Lu8Z@debian.me/T/#t)
    * Achieving high Design Assurance Level (DAL) DO-178C processes
    * Proving real-time performance
    * Aerospace use cases
        * Identify typical architectures and platforms for avionics
        * must clearly articulate expectations in order to make suggestions to other working groups (e.g., tools WG)
        * Candidates
            * [PX4 + Linux](https://auterion.com/drone-manufacturers/skynode/) - PX4 It can be on any Posix OS (including Linux)
            * [ARINC653 sim](https://github.com/aeronautical-informatics/apex-linux) - And there is our ARINC653 simulator using Linux Namespaces + CGroups
    * Tooling
        * What tool needs are unique to Aerospace?
        * Coordinating with Tools WG (not duplicating their work)
    * How to abstract OS behaviors needed for avionics and real-time safety-critical requirements.
        * Can I simulate (early) what I need from an OS and refine requirements.
        * For example, try something in hypervisor or formal language early.
    * Compare/contrast Linux approach to COTS avionics OS offerings
    * Terminology of partitions and ARINC 653 – do we see Linux as the partitioning environment itself or does it become a host OS within a partition?
    * The link between Linux support on top of architecture (especially the newest ones, such as RISC-V)
    * Support of mixed criticality for aerospace applications

