![logo](logo_elisa_small.png )
## ELISA Aerospace Working Group 
# Minutes 
## 1 Mar 2023

# Agenda
- Roll Call
- Brief Notices
- Announcements
- Mandate and Goals
- Prioritize Discussion Topics 
- Work on Survey Paper 
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

* ELISA Project meetings involve participation by industry competitors, and it is the intention of the Linux Foundation to conduct all of its activities in accordance with applicable antitrust and competition laws. It is therefore extremely important that attendees adhere to meeting agendas, and be aware of, and not participate in, any activities that are prohibited under applicable US state, federal, or foreign antitrust and competition laws.
    * [Linux Foundation Antitrust Policy](http://www.linuxfoundation.org/antitrust-policy)
* Email communication will be treated as documentation and be received and made available by the Project under the [Creative Commons Attribution 4.0 International License](http://creativecommons.org/licenses/by/4.0). Please refer to the ELISA Technical Charter section 7 subsection iv. for details.
* The discussions in these meetings are exploratory. The opinions expressed by participants are not necessarily the policy of the companies.
* No recordings of working group meetings are permitted. Special provisions may be arranged for recording in advance with explicit consent of the participants.
* The kernel and LF Code of Conduct applies to all communication with this project
    * [Linux Foundation Code of Conduct](https://www.linuxfoundation.org/code-of-conduct/)
    * Linux [Contributor Covenant Code of Conduct](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/code-of-conduct.rst)
    * Linux Kernel Contributor Covenant [Code of Conduct Interpretation](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/code-of-conduct-interpretation.rst)


# Announcements

## Upcoming Conferences
* [Open Source Summit North America](https://events.linuxfoundation.org/open-source-summit-north-america/)  - 10-12 May 2023
    * Possible ELISA workshop during OSSNA
* [Embedded Open Source Summit](https://events.linuxfoundation.org/embedded-open-source-summit/) - 27-30 June 2023
* [Digital Avionics Systems Conference](https://2023.dasconline.org/) - 1-5 Oct 2023


# Mandate and Goals

# Mandate
The Aerospace Working Group shall develop use cases to inform and influence Linux architecture and related tools, work to derive technical requirements for avionics operating systems, and seek to enhance and expand avionics software lifecycle processes, practices, and tools to enable use of Linux in avionics systems that are certified to high design assurance levels.

## 2023 Goals
* Establishing our operations as a new working group
* Survey on the state of the art within aerospace on use of Linux and associated certification approach and equivalent Design Assurance Level (DAL)
* Identify the challenges to adopting Linux in aerospace
* Identify candidate use cases using Linux


# Survey Paper

Survey on the state of the art (not only from aero, but from other industries)
* Outcome: White paper at first, eventually Published paper
* What would be a collaborative approach?  
    * Github wiki?  
    * Overleaf?
* Need to better define the scope of the survey - what should be included or not?
* How will we split up the effort between authors to avoid duplication of effort?
    * Relate papers to projects, assign one of the survey paper authors to address that collection of work related to the project     
    * Define the threshold for determining if someone is listed as an author or simply listed in acknowlgement
* If interested in co-authoring survey, notify Martin Halle (Martin.Halle@tuhh.de) of your interest and email underwhich you would like to register for Overleaf
* Start collecting literature on state-of-the-art 
    * Review [recorded presentation](https://st1.zoom.us/web_client/bai5dum/html/externalLinkPage.html?ref=https://www.youtube.com/watch?v=Fea5XODLBM8&list=PLuDNrzTpK8zqx7AJroClzENM8lpPhGkJu&index=3) on state of real-time Linux 
    * Establish list of resources for anyone interested in getting started with Linux in aerospace – the problem and possible solutions

# Discussion Topics
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

# Closing

# Action Items
* How to organize our work, our documents, software
    * [ ] Workflow - should we use a branch and merge strategy for most members?
    * [ ] Assign at least a few people as owner/maintainer to approve merges (perhaps a WG vice-chair)
    * [ ] Check how to assign roles for our github [S. VanderLeest]
        - Yes, Steve can access Settings > Add People for the [AeroWG github](https://github.com/elisa-tech/wg-aerospace/)
* [ ] Invite Stefano Stabellini from AMD to a future meeting for discussion on hypervisor [S. VanderLeest] (consider co-meeting with the system WG)
    - This issue was duplicated to github [issue #2](https://github.com/elisa-tech/wg-aerospace/issues/2) as an experiment
* [X] Forward our 2023 goals to TSC [S. VanderLeest]
* [X] Establish document areas [S. VanderLeest]



# Round Table







