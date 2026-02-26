<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Product profiles

The following tables are proposed to frame up how a respective set of aerospace/space products might be compared. The goal is to try to understand what the scope of a requirement set might look like to establish something like the Carrier Grade Linux model. That model focused on maturing the capability toward the specific aspects of a targeted industry.

## DO-178C Products

### Software Level A/B/C

#### Flight control system

| Product Aspect(s)      | Details                                                | Notes                                                         |
| ---------------------- | ------------------------------------------------------ | ------------------------------------------------------------- |
| Operational duration:  | 30+yrs (most likely ~50+)                              |                                                               |
| Userdata update cycle: | Nav/Metadata monthly                                   |                                                               |
| Platform update cycle: | 4-8yrs                                                 | Likely NO OS upgrade, just patching                           |
| Software Level:        | A/B                                                    |                                                               |
| Security:              | Layered + Lifecycle rigor                              | Minimize footprint with interface and API verification focus. |
| App Capability:        | Product-focused custom apps, parsing ARINC data        |                                                               |
| System Constraints:    | Deterministic, simple, radiation hardened, reliability |                                                               |
| Protocols:             | NA                                                     |                                                               |
| IO:                    | ARINC429/717/664/825                                   | Similar to serial, CAN bus, Ethernet                          |
| Dataload/fieldload:    | ARINC-based mediaset via ARINC615a dataloader          |                                                               |
| OS standards:          | ARINC653 modular operating system                      |                                                               |
| OS footprint:          | Small                                                  | < 200k SLOC                                                   |
| Languages:             | C, ADA                                                 | (Future) RUST                                                 |
| Storage:               | 512MB - low GB                                         |                                                               |
| Memory:                | 512MB - low GB                                         |                                                               |
| CPU frequency:         | 600Mhz - ~1Ghz                                         | (not a performance comparison)                                |
| CPU cores:             | 1                                                      |                                                               |
| Tool Qualification:    | Likely                                                 | Special development environment and compilers                 |

### Software Level D

#### Information Management

| Product Aspect(s)      | Details                                                                     | Notes                                                                                               |
| ---------------------- | --------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------- |
| Operational duration:  | 20+yrs                                                                      |                                                                                                     |
| Userdata update cycle: | ~yearly                                                                     | Infrequent but likely driven by airline operations                                                  |
| Platform update cycle: | 4-8yrs                                                                      | Likely OS upgrade at points of hardware update + OS Patching                                        |
| Software Level:        | D                                                                           |                                                                                                     |
| Security:              | STIGs and patching                                                          | Traditional hardening, CVE patching, and risk-based layered security model.                         |
| App Capability:        | Parsing ARINC data, converting to SNMP/IP traffic for non-safety system use |                                                                                                     |
| System Constraints:    | Reliability                                                                 |                                                                                                     |
| Protocols:             | TCP/IP, SSL, IPSEC                                                          |                                                                                                     |
| IO:                    | WIFI, Ethernet, ARCIN429/717/664                                            |                                                                                                     |
| Dataload/fieldload:    | ARINC-based mediaset via ARINC615a dataloader                               |                                                                                                     |
| OS standards:          | POSIX                                                                       |                                                                                                     |
| OS footprint:          | Large                                                                       | 2M+ SLOC                                                                                            |
| Languages:             | C/C++, web languages                                                        | Open development environment and compilers with few limitations.                                    |
| Storage:               | 256GB+                                                                      |                                                                                                     |
| Memory:                | 4GB+                                                                        |                                                                                                     |
| CPU frequency:         | > ~1Ghz                                                                     | (not a performance comparison)                                                                      |
| CPU cores:             | 4+                                                                          |                                                                                                     |
| Tool Qualification:    | None                                                                        | Development practice most likely at least archives tools and identifies their use. Not restrictive. |

### Software Level E

#### Cabin Entertainment System

| Product Aspect(s)      | Details                                                                                   | Notes                                                                                                    |
| ---------------------- | ----------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| Operational duration:  | 5-10yrs                                                                                   |                                                                                                          |
| Userdata update cycle: | 60 days                                                                                   |                                                                                                          |
| Platform update cycle: | ~yearly                                                                                   | Driven by cybersecurity and hardware obsolescence                                                        |
| Software Level:        | E                                                                                         | Still some level of software practice is followed to ensure functionality                                |
| Security:              | STIGs and patching                                                                        | Traditional hardening, CVE patching, and minimizing system interfaces.                                   |
| App Capability:        | graphical interface, streaming video, PA announcements, Internet connected, aircraft data |                                                                                                          |
| System Constraints:    | Latency sensitive, responsive, redundant (optional)                                       |                                                                                                          |
| Protocols:             | TCP/IP, Video steaming, HDMI, SSL                                                         | Standards driven.                                                                                        |
| IO:                    | Ethernet, touchscreen, display, leds, buttons, WiFi, Bluetooth, stereo audio jack         |                                                                                                          |
| Dataload/fieldload:    | OTA                                                                                       | Most likely not considered part of the aircraft configuration so update approach and timing is flexible. |
| OS standards:          | POSIX, Networking RFCs, Video codecs, Security algorithms                                 |                                                                                                          |
| OS footprint:          | XLarge                                                                                    | 15M+ SLOC                                                                                                |
| Languages:             | C/C++, JAVA, Python, Golang, Javascript                                                   | Open development environment and compilers with few limitations.                                         |
| Storage:               | 256GB+                                                                                    |                                                                                                          |
| Memory:                | 2GB+                                                                                      |                                                                                                          |
| CPU frequency:         | > ~1Ghz                                                                                   | (not a performance comparison)                                                                           |
| CPU cores:             | 4+                                                                                        |                                                                                                          |
| Tool Qualification:    | None                                                                                      | Development practice most likely at least archives tools and identifies their use. Not restrictive.      |

## Template - "name of notional system"

Below is an example table of product "aspects" and examples of what "details" might be considered when defining a new "product profile."

| Product Aspect(s)                 | Details                                                                                                                                                                                                         | Notes                                                                                                                                                   |
| --------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Operational duration:             |                                                                                                                                                                                                                 |                                                                                                                                                         |
| Userdata update cycle:            | rate / scale                                                                                                                                                                                                    |                                                                                                                                                         |
| Platform update cycle:            | rate / scale                                                                                                                                                                                                    |                                                                                                                                                         |
| Software Level:                   | A/B/C/D/E                                                                                                                                                                                                       |                                                                                                                                                         |
| Security:                         | e.g., Security Assurance Level (SAL)- DO-326/365a, layered, hw based, lifecycle rigor X                                                                                                                         | Clarification of constraints                                                                                                                            |
| App Capability:                   | e.g., POSIX Apps, ARINC Apps, Web Apps, Applets, Bare metal, Scripting (Interpreter)                                                                                                                            |                                                                                                                                                         |
| System Constraints:               | e.g., deterministic, simple, radiation hardened, reliability                                                                                                                                                    |                                                                                                                                                         |
| Architecture Constraints:         | e.g., Redundancy, dissimilarity, monitoring, real-time                                                                                                                                                          | Could drive additional HW / specific configurations within a system. Real-time needs details on scheduler and expected behavior of events(low/med/hard) |
| Protocols:                        | Networking RFCs, ARINC, Streaming video encodings,                                                                                                                                                              |                                                                                                                                                         |
| IO:                               | e.g., ARINC (429/717/664/825...), MIL (1553...), IEEE/SAE (TSN 802.1DP...), serial, CAN bus, Ethernet, PCIe, USB, Spacewire                                                                                     |                                                                                                                                                         |
| Dataload/fieldload:               | e.g., ARINC-based mediaset via ARINC615a dataloader, ARINC615-3, Commercial OTA, Floppy disk                                                                                                                    |                                                                                                                                                         |
| OS standards:                     | e.g., ARINC653 modular partitioned operating system, Tailored / customized "carrier grade", Firmware vs. OS, SELinux, POSIX, Engine-like environments (eBPF, WASM, Container engine), Orchestration(kubernetes) |                                                                                                                                                         |
| OS footprint:                     | Small                                                                                                                                                                                                           | below 200k SLOC                                                                                                                                         |
| OS Scheduling:                    | E.g. scheduler used (real-time?), ARINC653 Apps/tasks, processes, threads, MMU-isolated, namespaced                                                                                                             |                                                                                                                                                         |
| Boot-up time:                     | within <x> seconds / <x> milli-seconds                                                                                                                                                                          | Frame this as (warm vs. cold start)                                                                                                                     |
| Fault handling:                   | e.g., detection, remediation, tree showing domains/isolation/cascading, BITE, logging, reporting upstream, FMEA                                                                                                 | Development analysis / design / operational                                                                                                             |
| Languages:                        | C, ADA                                                                                                                                                                                                          | (Future) RUST                                                                                                                                           |
| Storage:                          | 512MB - low GB                                                                                                                                                                                                  |                                                                                                                                                         |
| Memory:                           | 512MB - low GB                                                                                                                                                                                                  |                                                                                                                                                         |
| Memory allocation:                | static / dynamic                                                                                                                                                                                                | Impacted by system state? When allowed to allocation, can you free, etc?                                                                                |
| Worst Case Execution Time (WCET): | Knowledge about WCET for OS / user-code functions, known max. induced interferrence (e.g., on multi-core)                                                                                                       |                                                                                                                                                         |
| CPU Performance:                  | MHz/FLOPS/DMIPS/Optimization level                                                                                                                                                                              |                                                                                                                                                         |
| CPU Cores:                        | <count>                                                                                                                                                                                                         |                                                                                                                                                         |
| Tool Qualification:               | NA/Possible                                                                                                                                                                                                     | (To what level / background details)                                                                                                                    |
