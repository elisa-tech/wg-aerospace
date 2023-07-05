![logo](logo_elisa_small.png )
## ELISA Aerospace Working Group 
# Minutes 
## 05 Jul 2023


---
# Agenda
- Roll Call
- Brief Notices
- Announcements
- Mandate and Goals
- Collaboration with other groups
- Work on Survey Paper
- Prepare Discussion Agenda
- Closing
    - Next Steps
    - Action Items
    - Round Table


---
# Roll Call

## Attended this meeting

- Sebastien Boria - Airbus
- Olivier Charrier – Wind River
- Matt Kelly - Boeing
- Lenka Koskova – TUL CZ
- Qasim Majeed
- Steve VanderLeest – Boeing
- Wanja Zaeske - DLR


## Attended recently in the past

- Sebastien Boria - Airbus
- Sam Bristow
- Olivier Charrier – Wind River
- Stefano Dell'Osa - Intel
- Martin Halle – TUHH
- Matt Kelly - Boeing
- Shuah Khan – Linux Foundation
- Abdi Kitesa
- Lenka Koskova – TUL CZ
- Rajesh Kurapati - KMC
- Qasim Majeed
- Sam Thompson – Rapita
- Ulises V
- Steve VanderLeest – Boeing
- Richard Wagener
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

## Upcoming Webinars
* 18 Jul 2023, 10am EDT, Chuck Wolber webinar on yocto
* 6 Sep 2023, 10am EDT, Stefano Stabellini webinar on Xen Hypervisor 

## Upcoming Conferences
* 1-5 Oct 2023 [Digital Avionics Systems Conference](https://2023.dasconline.org/)
* 14-15 Nov 2023 [Aerospace TechWeek](https://www.aerospacetechweek.com/americas/) 


---

# Collaboration with Other Groups

* Collaboration with other ELISA working groups
  * Horizontal (technical focus)
    * Linux features for Safety-Critical Systems
      * Lenka plans to attend regularly in the future
      * Seb plans to attend occasionally in the future
      * TBD: Review presentation by Elana and Shuah at EOSS - Prague
    * Open-Source Engineering Process 
      * Seb plans to attend regularly in the future
      * TBD: Investigate STPA approach
        * are FAA or EASA involved? 
        * Anyone using STPA to satisfy ARP 4754A?
        * We have some work on Model Based STPA for Avionics
          * https://github.com/DLR-FT/ModelBasedSTPA 
          * https://ieeexplore.ieee.org/abstract/document/9925883 
          * https://ieeexplore.ieee.org/abstract/document/10005396
    * Safety Architecture
    * Systems
    * Tool Investigation and Code Improvement
  * Vertical (industry focus)
    * Automotive
    * Medical Device
* Collaboration with groups outside ELISA
  * linux4space.org
  * Xen Hypervisor
    * dom0
  * Yocto
  * Zephyr RTOS
    * used as a dom0 in Xen, and then Linux VM in other partitions


---

# Survey Paper

[Survey paper](https://www.overleaf.com/project/63ee5a398ae14b0bad694e21)

* For section on Linux in federated: http://www.boeing.com/commercial/aeromagazine/aero_23/EFB.pdf

* Assign lead authors for sections
  * Motivation - Matt Kelly
  * Other Open Source RTOS - Martin Halle
  * Linux non-safety-critical in partitioned - Steve VanderLeest


---
# Closing


## Action Items
Located in [GitHub Issues](https://github.com/elisa-tech/wg-aerospace/issues)

* New Action Items
  * Schedule a date for STPA discussion (Wanja has a colleague that is expert on STPA)

## Round Table

