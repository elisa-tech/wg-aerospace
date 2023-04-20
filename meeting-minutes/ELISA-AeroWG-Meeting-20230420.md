![logo](logo_elisa_small.png )
## ELISA Aerospace Working Group 
# Minutes 
## 20 Apr 2023


# Agenda
- Roll Call
- Brief Notices
- Announcements
- Mandate and Goals
- Work on Survey Paper
- Prepare 
- Closing
    - Next Steps
    - Action Items
    - Round Table


# Roll Call

## Attended this meeting
- Steve VanderLeest – Boeing


## Attended in the past
- Sebastien Boria
- Sam Bristow
- Olivier Charrier – Wind River
- Stefano Dell'Osa - Intel
- Martin Halle – TUHH
- Matt Kelly - Boeing
- Shuah Khan – Linux Foundation
- LenkaKT – TUL CZ
- Qasim Majeed
- Sam Thompson – Rapita
- Ulises V
- Steve VanderLeest – Boeing
- Richard Wagener
- Chuck Wolber – Boeing
- Jeremy York - Boeing
- Wanja Zaeske - DLR


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


# Announcements

## Upcoming Conferences
* [Open Source Summit North America](https://events.linuxfoundation.org/open-source-summit-north-america/)  - 10-12 May 2023
    * ELISA workshop during OSSNA
* [Embedded Open Source Summit](https://events.linuxfoundation.org/embedded-open-source-summit/) - 27-30 June 2023
* [Digital Avionics Systems Conference](https://2023.dasconline.org/) - 1-5 Oct 2023
* [Aerospace TechWeek](https://www.aerospacetechweek.com/americas/) - 14-15 Nov 2023



# Survey Paper

Our working group plans to produce a survey paper on the state of the art for use of Linux in aerospace 

* The outcome will be a white paper at first, eventually a published paper.
* Our writing tool is Overleaf (uses LaTeX)
    * [Survey paper in Overleaf](https://www.overleaf.com/project/63ee5a398ae14b0bad694e21) 
    * If interested in co-authoring survey, notify Martin Halle (Martin.Halle@tuhh.de) of your interest and email under which you would like to register for Overleaf

## Next Steps
* Start collecting literature on state-of-the-art
    * Review [recorded presentation](https://st1.zoom.us/web_client/bai5dum/html/externalLinkPage.html?ref=https://www.youtube.com/watch?v=Fea5XODLBM8&list=PLuDNrzTpK8zqx7AJroClzENM8lpPhGkJu&index=3) on state of real-time Linux
    * Establish list of resources for anyone interested in getting started with Linux in aerospace – the problem and possible solutions


## Open Questions and Issues
* Need to better define the scope of the survey
    * What should be included or not?
    * Should we address not only aerospace but also from other industries?
* How will we split up the effort between authors to avoid duplication of effort?
    * Relate papers to projects, assign one of the survey paper authors to address that collection of work related to the project
    * Define the threshold for determining if someone is listed as an author or simply listed in acknowledgement
      * The authors should agree together about who should be listed as an author (and why)
      * roughly speaking, they should contribute significant content  


# Features Required for Aerospace
A future discussion will cover "Features Required for Aerospace". Next steps are to create an agenda for the discussion (see below for start).


* What features must be supported?  
* How do de-risk (or even deactivate) those not needed?
* What are the criteria for inclusion of features?
* How do we configure a subset of features with robust configuration management (e.g., kernel config files)
* Obtaining necessary and sufficient timing and precision
* List of system functions that must be able to run and their requirements
* Supported I/O
* What configuration of which features are supported according to what schedules
* Driven by use cases
* Should we limit to aerospace? Or consider broader than aerospace? Consider only one area of aerospace? 
* What criticality (software level, design assurance level) should we consider?
* What resources must be available for which criticality levels  


# Closing


## Action Items
Located in [GitHub Issues](https://github.com/elisa-tech/wg-aerospace/issues)

## Round Table



# Future Discussion Topics
Rank-ordered discussion topics

* Survey paper
* Needs for compiling documentation (Shuah and Kate, starting with work from Medical Devices WG)
    * E.g., Tracing a workload, [Tracing With Ftrace: Critical Tooling For Linux Development](https://www.linuxfoundation.org/webinars/tracefs-the-building-blocks-of-linux-kernel-tracing-by-ftrace?hsLang&#61;en)
    * [PATCH v3 docs: add workload-tracing document to admin-guide](https://lore.kernel.org/linux-doc/Y9nkqhAS6EW2Lu8Z@debian.me/T/#t)
* What features must be supported?  How do de-risk (or even deactivate) those not needed?
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

