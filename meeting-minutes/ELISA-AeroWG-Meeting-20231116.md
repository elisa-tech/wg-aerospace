![logo](logo_elisa_small.png )

## ELISA Aerospace Working Group

# Minutes

## 16 Nov 2023

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
- Steve VanderLeest - Boeing
- Martin Halle - TUHH
- Sam Thompson - Rapita
- Olivier Charrier - Wind River
- Rajesh Kurapati - KMC
- Joseph Lee - Skytrac


## Attended recently in the past

- Sebastien Boria - Airbus
- Sam Bristow
- Olivier Charrier - Wind River
- Stefano Dell'Osa - Intel
- Martin Halle - TUHH
- Matt Kelly - Boeing
- Shuah Khan - Linux Foundation
- Abdi Kitesa
- Lenka Koskova - TUL CZ
- Rajesh Kurapati - KMC
- Qasim Majeed - Siemens
- Sam Thompson - Rapita
- Ulises Vega - Luxoft (but joined ELISA privately)
- Steve VanderLeest - Boeing
- Richard Wagener
- Wanja Zaeske - DLR
- Joseph Lee - Skytrac

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

- Feb 7/8 2024 [MEA](https://conference-mea.org/)
- 27 Feb 2024 [AvioSE'24](https://aviose-workshop.github.io/) in Linz, Austria
- Apr 16 to 18  [Aerospace Tech Week](https://www.aerospacetechweek.com/europe/) in Munich
- June 11th-12th [ERTS](https://www.erts2024.org/) in Toulouse
- 29 Jul - 2 Aug 2024 [AIAA Aviation Forum](https://www.aiaa.org/aviation/presentations-papers/call-for-papers) in Las Vegas, US
  - Abstracts due 30 Nov 2023
- 1-3 Oct 2024 IEEE [Digital Avionics Systems Conference](http://dasconline.org/) in San Diego, US
- 2-9 Mar [IEEE Aero](https://www.aeroconf.org/)


---

# Survey Paper

[Survey paper](https://www.overleaf.com/project/63ee5a398ae14b0bad694e21)

We revised the title and noted scope in the abstract.

---

# Hints and Tips for the Group

Working on GitHub (see below) requires to be assigned to the project.
For access, ask one of the team leaders.

To actually get access and be able to commit, there are things to keep in mind:
Cloning the repo using the command line GIT (the same is true for SmartGIT, a UI-based tool) and then try to commit may fail. The reason is most likely because GitHub no longer supports authentication using name/password only.
 
What works is to use the GitHub CLI. To do so:
- if you don't have one, create a GitHub account (probably related to your email address you are allow using within ELISA)
- install the GitHub CLI (either directly or through chocolatey or any other package manager)
- use the CLI command to authenticate
  - this will create an access token for your machine that need to be setup/entered into the browser
- use the following CLI command to create a working copy that authenticates correctly against your GitHub account:
  - gh repo clone elisa-tech/wg-aerospace

Finally, both: GIT command line tool and others (like SmartGIT) are working properly.

---

# Closing

## Action Items

Did not have time to review action items.

Located in [GitHub Issues](https://github.com/elisa-tech/wg-aerospace/issues)


## Round Table
