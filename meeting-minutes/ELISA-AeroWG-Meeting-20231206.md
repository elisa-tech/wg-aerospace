![logo](logo_elisa_small.png )

## ELISA Aerospace Working Group

# Minutes

## 6 Dec 2023

---

# Agenda

- Roll Call
- Brief Notices
- Announcements
- Work on Survey Paper
- Organize Notes on Features for Aerospace
- Closing
  - Action Items
  - Round Table

---

# Roll Call

## Attended this meeting

- Martin Halle - TUHH
- Justin Pearson - Lynx Software
- Olivier Charrier - Wind River
- Ivan Perez - NASA Ames
- Chuck Wolber - Boeing
- Matt Weber - Boeing
- Ulises Vega - Luxoft (but joined ELISA privately)
- Matt Kelly - Boeing
- Sam Bristow - Rocket Lab
- Steve VanderLeest - Boeing
- Qasim Majeed - Siemens


## Attended recently in the past

- Sebastien Boria - Airbus
- Sam Bristow - Rocket Lab
- Olivier Charrier - Wind River
- Stefano Dell'Osa - Intel
- Martin Halle - TUHH
- Matt Kelly - Boeing
- Shuah Khan - Linux Foundation
- Abdi Kitesa
- Lenka Koskova - TUL CZ
- Rajesh Kurapati - KMC
- Joseph Lee - Skytrac
- Justin Pearson - Lynx Software
- Ivan Perez - NASA Ames
- Qasim Majeed - Siemens
- Sam Thompson - Rapita
- Ulises Vega - Luxoft (but joined ELISA privately)
- Steve VanderLeest - Boeing
- Richard Wagener
- Matt Weber - Boeing
- Chuck Wolber - Boeing
- Wanja Zaeske - DLR

---

# Brief Notices

## Code of Conduct and Legal Notices

* ELISA Project meetings involve participation by industry competitors, and it is the intention of the Linux Foundation to conduct all of its activities in accordance with applicable antitrust and competition laws. It is therefore extremely important that attendees adhere to meeting agendas, and be aware of, and not participate in, any activities that are prohibited under applicable US state, federal, or foreign antitrust and competition laws.
  - [Linux Foundation Antitrust Policy](http://www.linuxfoundation.org/antitrust-policy)
- Email communication will be treated as documentation and be received and made available by the Project under the [Creative Commons Attribution 4.0 International License](http://creativecommons.org/licenses/by/4.0). Please refer to the ELISA Technical Charter section 7 subsection iv. for details.
- The discussions in these meetings are exploratory. The opinions expressed by participants are not necessarily the policy of the companies.
- No recordings of working group meetings are permitted. Special provisions may be arranged for recording in advance with explicit consent of the participants.
- The kernel and LF Code of Conduct applies to all communication with this project
  - [Linux Foundation Code of Conduct](https://www.linuxfoundation.org/code-of-conduct/)
  - Linux [Contributor Covenant Code of Conduct](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/code-of-conduct.rst)
  - Linux Kernel Contributor Covenant [Code of Conduct Interpretation](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/code-of-conduct-interpretation.rst)

## Mandate

The Aerospace Working Group shall develop use cases to inform and influence Linux architecture and related tools, work to derive technical requirements for avionics operating systems, and seek to enhance and expand avionics software lifecycle processes, practices, and tools to enable use of Linux in avionics systems that are certified to high design assurance levels.

## 2023 Goals

* Establishing our operations as a new working group
- Survey on the state of the art within aerospace on use of Linux and associated certification approach and equivalent Design Assurance Level (DAL)
- Identify the challenges to adopting Linux in aerospace
- Identify candidate use cases using Linux

---

# Announcements

## Vice-chair

Martin Halle has been appointed as the vice-chair of the ELISA aerospace working group. Congratulations!

## Recent Events

- "The Road to Safe Space Exploration" - ELISA webinar. 
  * [ELISA YouTube channel](https://www.youtube.com/watch?v=Z4f2s2Fomtw)
  * [zoom recording link](https://zoom.us/rec/play/mRSRHQSrFN-_ZmSXqswgyBJO0RGjp6M1G3GZF5qAx4i8tWQiQsTs5ObOmmyc0t1aG9toohdnDqnLAVxj.6bzqFHtZSe5XUk8q?canPlayFromShare=true&from=share_recording_detail&continueMode=true&componentName=rec-play&originRequestUrl=https%3A%2F%2Fzoom.us%2Frec%2Fshare%2FKh6nrYJxmscHnwYk5vOTMuqp_EEaG-4sdwZXg-wKLq6au_d_LEOZbdXfYnCv1gZf.vBdgeLDKdJj24Qtv)

## Upcoming Events

- Feb 7/8 2024 [More Electric Aircraft (MEA)](https://conference-mea.org/)
- 27 Feb 2024 [Workshop on Avionics Systems and Software Engineering (AvioSE'24)](https://aviose-workshop.github.io/) in Linz, Austria
- 2-9 Mar [IEEE Aerospace Conference](https://www.aeroconf.org/)
- Apr 16 to 18  [Aerospace Tech Week](https://www.aerospacetechweek.com/europe/) in Munich
- June 11th-12th [Embedded Real Time Systems (ERTS)](https://www.erts2024.org/) in Toulouse
- 15-19 July 2024 [IEEE Space Mission Challenges for Information Technology](https://smcit-scc.space) - IEEE Space Computing Conference . Mountain View, CA, US
  - Full paper due 9 Feb 2024
- 29 Jul - 2 Aug 2024 [AIAA Aviation Forum](https://www.aiaa.org/aviation/presentations-papers/call-for-papers) in Las Vegas, US
  - Abstracts due 30 Nov 2023
- 1-3 Oct 2024 IEEE [Digital Avionics Systems Conference](http://dasconline.org/) in San Diego, US

---

# Survey Paper

[Survey paper](https://www.overleaf.com/project/63ee5a398ae14b0bad694e21)

In November, we revised the title and noted scope in the abstract.

---

# Organizing "Features Required for Aerospace" Discussion

## Divide discussion into focused sub-topics

- Scope for feature selection
  - Technical scope
    - Software
      - first, discuss kernel (try to finish, and only discuss broader distribution if necessary to make a decision about kernel)
        - subsystem by subsystem, by DAL
      - second, full distribution (kernel, services, BSP/drivers, API, libraries, applications, bootloader, etc.)
    - Hardware
      - MMU as minimum?, multicore?, availability (physical or simulation at first), validation, crypto, etc.
  - Certification scope 
    - Non-critical - discuss first, DAL-D and lower
      - Decisions about features to include at low DAL do not (necessarily) apply to high DAL
    - Mission-critical
      - Real-time
    - Safety-critical (DO-178C SWL-C or higher)
      - Real-time
    - Security-critical (DO-326A, DO-356A)
      - SAL may not follow DAL, but may actually need to be inverse
  - Location
    - Air
    - Space
    - Ground equipment - secondary discussion
- Use Cases
  - a use case should define a system architecture and function
- Identification of features for use cases
- Mechanisms to configure features (include/exclude)
  - connection to partitioning
  - features that are included/excluded in a real-time aspect
  - different safety features that configured and are certified at different levels (e.g., DO-178C software level)
    - may exclude features, e.g., exclude any feature certified below DAL-B
- Maintenance and Support
  - Need to maintain for decades
- Tools
  - Identify features unique to aerospace, DO-330 qualification 

## Way of working

- Get agreement on one area before moving on to next topic
- Drive one simple use case through all areas 

---

# Closing

## Action Items


Located in [GitHub Issues](https://github.com/elisa-tech/wg-aerospace/issues)

* Attract airworthiness authority participation (FAA, EASA)
  * hot topic for them is AI, may be an opening to also discuss Linux
* Invite vendor contacts


## Round Table

* Matt Kelly noted he will try to add more to the white paper
