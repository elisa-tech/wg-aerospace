<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Product profiles

The following tables are proposed to frame up how a respective set of aerospace/space products might be compared.  The goal is to try to understand what the scope of a requirement set might look like to establish something like the Carrier Grade Linux model.  That model focused on maturing the capability toward the specific aspects of a targeted industry.

## DO-178C Products
### Software Level A/B/C

#### Flight control system

| Product Aspect(s) | Details | Notes |
| --- | --- | --- |
| Operational duration:  | 30+yrs (most likely ~50+) | |
| Userdata update cycle: | Nav/Metadata monthly | |
| Platform update cycle: | 4-8yrs | Likely NO OS upgrade, just patching |
| Software Level:     | A/B | |
| Security:           | Layered + Lifecycle rigor | Minimize footprint with interface and API verification focus. |
| App Capability:     | Product-focused custom apps, parsing ARINC data | |
| System Constraints: | Deterministic, simple, radiation hardened, reliability | |
| Protocols:          | NA | |
| IO:                 | ARINC429/717/664/825 | Similar to serial, CAN bus, Ethernet |
| Dataload/fieldload: | ARINC-based mediaset via ARINC615a dataloader | |
| OS standards:       | ARINC653 modular operating system | |
| OS footprint:       | Small | < 200k SLOC |
| Languages:          | C, ADA | (Future) RUST |
| Storage:            | 512MB - low GB | |
| Memory:             | 512MB - low GB | |
| CPU frequency:      | 600Mhz - ~1Ghz | (not a performance comparison) |
| CPU cores:          | 1 | |
| Tool Qualification: | Likely | Special development environment and compilers |

### Software Level D

#### Information Management

| Product Aspect(s) | Details | Notes |
| --- | --- | --- |
| Operational duration:  | 20+yrs | |
| Userdata update cycle: | ~yearly | Infrequent but likely driven by airline operations |
| Platform update cycle: | 4-8yrs | Likely OS upgrade at points of hardware update + OS Patching |
| Software Level:     | D | |
| Security:           | STIGs and patching | Traditional hardening, CVE patching, and risk-based layered security model. |
| App Capability:     | Parsing ARINC data, converting to SNMP/IP traffic for non-safety system use | |
| System Constraints: | Reliability | |
| Protocols:          | TCP/IP, SSL, IPSEC | |
| IO:                 | WIFI, Ethernet, ARCIN429/717/664 | |
| Dataload/fieldload: | ARINC-based mediaset via ARINC615a dataloader | |
| OS standards:       | POSIX | |
| OS footprint:       | Large | 2M+ SLOC |
| Languages:          | C/C++, web languages | Open development environment and compilers with few limitations. |
| Storage:            | 256GB+ | |
| Memory:             | 4GB+ | |
| CPU frequency:      | > ~1Ghz | (not a performance comparison) |
| CPU cores:          | 4+ | |
| Tool Qualification: | None | Development practice most likely at least archives tools and identifies their use. Not restrictive. |

### Software Level E

#### Cabin Entertainment System

| Product Aspect(s) | Details | Notes |
| --- | --- | --- |
| Operational duration:  | 5-10yrs | |
| Userdata update cycle: | 60 days | |
| Platform update cycle: | ~yearly | Driven by cybersecurity and hardware obsolescence |
| Software Level:     | E | Still some level of software practice is followed to ensure functionality |
| Security:           | STIGs and patching | Traditional hardening, CVE patching, and minimizing system interfaces. |
| App Capability:     | graphical interface, streaming video, PA announcements, Internet connected, aircraft data  | |
| System Constraints: | Latency sensitive, responsive, redundant (optional)  | |
| Protocols:          | TCP/IP, Video steaming, HDMI, SSL  | Standards driven. |
| IO:                 | Ethernet, touchscreen, display, leds, buttons, WiFi, Bluetooth, stereo audio jack | |
| Dataload/fieldload: | OTA | Most likely not considered part of the aircraft configuration so update approach and timing is flexible. |
| OS standards:       | POSIX, Networking RFCs, Video codecs, Security algorithms | |
| OS footprint:       | XLarge | 15M+ SLOC |
| Languages:          | C/C++, JAVA, Python, Golang, Javascript | Open development environment and compilers with few limitations. |
| Storage:            | 256GB+ | |
| Memory:             | 2GB+ | |
| CPU frequency:      | > ~1Ghz | (not a performance comparison) |
| CPU cores:          | 4+ | |
| Tool Qualification: | None | Development practice most likely at least archives tools and identifies their use. Not restrictive. |

## Space Products (LEO Payload)

### Onboard AI/ML Inference

#### GodelEDGE — Onboard Satellite AI Inference System

GodelEDGE is an edge AI inference system for onboard satellite imagery processing. It runs computer vision models (semantic segmentation for disaster detection) on COTS GPU hardware in orbit, downlinking compact alert payloads instead of raw imagery. Currently at prototype stage on NVIDIA Jetson Orin dev boards, targeting LEO small-sat deployment on platforms such as Rogue Space SCP (mid-2026).

| Product Aspect(s) | Details | Notes |
| --- | --- | --- |
| Operational duration:  | 5-7 years (LEO small-sat missions) | Driven by target partner mission lifetimes. Hardware partner-dependent. |
| Userdata update cycle: | Quarterly to annually (ML model weights via uplink) | Updated models trained on ground, exported to TensorRT/ONNX, pushed via ground station contact window. Cadence TBD. |
| Platform update cycle: | Infrequent — aligned with satellite operator OS updates | Payload software runs on partner compute platform. OS updates managed by satellite operator. |
| Software Level:     | TBD — not formally assessed | Payload data processing application. System failure = missed detections, not vehicle loss. Likely D or E equivalent. |
| Security:           | Encrypted downlink, containerized application isolation | Alert payloads encrypted before downlink. Application runs in Docker containers. No formal security assurance level defined. |
| App Capability:     | POSIX Apps, Python (containerized), GPU-accelerated ML inference | Python 3.11+ in Docker on Linux (JetPack/L4T). PyTorch models, TensorRT inference runtime. |
| System Constraints: | Power-constrained (5-20W), COTS hardware in radiation environment, offline-only, thermal | Wake-on-event tiered architecture: ~5W idle, ~20W burst. Must operate fully autonomous without ground contact. ECC memory assumed. |
| Architecture Constraints: | Tiered inference (wake-on-event), deployment-agnostic adapter layer | L1: lightweight trigger (~5W always-on). L2: foundation model burst (~15W). L3: task-specific heads (~3W). Adapter abstracts sensor/comms/position/lifecycle per platform. |
| Protocols:          | TCP/IP (ground segment), filesystem/shared-memory (internal) | Ground: REST API (FastAPI). Edge-internal: filesystem-based GeoTIFF watch or shared memory. Partner-specific: E-Bus (Rogue Space). |
| IO:                 | Multispectral sensor input (4-13 bands), GPS/ephemeris, Ethernet | Input: multispectral imagery (visible + NIR + SWIR). Position: GPS + satellite attitude. Output: compressed alert payload (<1KB JSON). |
| Dataload/fieldload: | Commercial OTA from ground station | Model artifacts via NGC private registry. Uplink mechanism depends on satellite operator. No ARINC-style dataloader. |
| OS standards:       | POSIX, Linux (NVIDIA JetPack/L4T), Docker containers | Full Linux distribution. Docker for app isolation. No ARINC653 partitioning. SGL distribution is a future target — motivation for this contribution. |
| OS footprint:       | Large | Full JetPack/L4T Linux + CUDA/cuDNN/TensorRT runtime. 15M+ SLOC equivalent. |
| OS Scheduling:      | Standard Linux CFS scheduler (not hard real-time) | No hard real-time requirements. Wake-on-event trigger is polling-based. Inference is batch (per-tile). |
| Boot-up time:       | Within ~60 seconds (cold start, estimated) | Compute platform runs continuously. GodelEDGE process starts on boot. Cold start includes ML model loading into GPU memory (~10-15s for model load). Not yet benchmarked. |
| Fault handling:     | Design intent: ECC memory, application watchdog, graceful degradation | ECC catches single-bit errors. Watchdog restarts on crash. Missed detections acceptable (not safety-critical). No formal FMEA performed. Software radiation protection (e.g., Radshield-style) is of interest but not implemented. |
| Languages:          | Python 3.11+ (primary), C++ (future performance-critical extensions) | Core application is Python. TensorRT inference via Python bindings. C++ extensions planned but not started. |
| Storage:            | ~3GB total (<1GB volatile cache + ~2GB model weights) | No persistent storage of raw imagery — process and discard. Model weights on eMMC/SSD. |
| Memory:             | 4-8GB system RAM, <6GB GPU memory | Min: Jetson Orin Nano (4GB shared). Target: Jetson AGX Orin (64GB). GPU memory is the binding constraint for inference. |
| Memory allocation:  | Dynamic (Python/PyTorch managed) | PyTorch allocates GPU memory dynamically. Inference workload is bursty (wake-on-event), not constant. No static allocation. |
| Worst Case Execution Time (WCET): | Not formally analyzed. Target: <5s per tile (Orin Nano), <2s (AGX Orin) | GPU-bound inference. Multi-core interference not characterized. Preprocessing target: <30s per full scene. |
| CPU Performance:    | 40 TOPS INT8 (Orin Nano dev) / 248 TOPS INT8 (AGX Orin target) | GPU-dependent workload. 1024 CUDA cores (dev) / 2048 (target). ARM CPU: 6-12 cores. Inference is GPU-bound. |
| CPU Cores:          | 6 ARM + 1024 GPU (dev) / 12 ARM + 2048 GPU (target) | Dev: Jetson Orin Nano. Target: Rogue Space SCP (AGX Orin class). |
| Tool Qualification: | None | Standard open-source toolchain (Python, PyTorch, GCC). At Level D/E, tool qualification unlikely to be required. |

**Safety / Software Standards Note:** No formal safety or software standards are currently applied. GodelEDGE is a payload data processing application at prototype stage. Relevant standards that could apply as the system matures toward flight qualification include NASA-STD-8739.8 (software assurance, relevant if SBIR-funded), GSFC-STD-8000 (if GSFC is mission authority), and MIL-STD-882E (if DoD-funded via SpaceWERX/AFRL). DO-178C is not directly applicable but may be flowed down by aerospace primes. We are interested in SGL precisely to understand what OS-level safety guarantees are feasible for AI/ML payload workloads and to contribute requirements from this application domain.


## Template - "name of notional system"

Below is an example table of product "aspects" and examples of what "details" might be considered when defining a new "product profile."

| Product Aspect(s) | Details | Notes |
| --- | --- | --- |
| Operational duration:  |  | |
| Userdata update cycle: | rate / scale | |
| Platform update cycle: | rate / scale | |
| Software Level:     | A/B/C/D/E | |
| Security:           | e.g., Security Assurance Level (SAL)- DO-326/365a, layered, hw based, lifecycle rigor X | Clarification of constraints |
| App Capability:     | e.g., POSIX Apps, ARINC Apps, Web Apps, Applets, Bare metal, Scripting (Interpeter) | |
| System Constraints: | e.g., deterministic, simple, radiation hardened, reliability | |
| Architecture Constraints: | e.g., Redundancy, dissimilarity, monitoring, real-time | Could drive additional HW / specific configurations within a system.  Real-time needs details on scheduler and expected behavior of events(low/med/hard) |
| Protocols:          | Networking RFCs, ARINC, Streaming video encodings,  | |
| IO:                 | e.g., ARINC (429/717/664/825...), MIL (1553...), IEEE/SAE (TSN 802.1DP...), serial, CAN bus, Ethernet, PCIe, USB, Spacewire | |
| Dataload/fieldload: | e.g., ARINC-based mediaset via ARINC615a dataloader, ARINC615-3, Commercial OTA, Floppy disk | |
| OS standards:       | e.g., ARINC653 modular partitioned operating system, Tailored / customized "carrier grade", Firmware vs. OS, SELinux, POSIX, Engine-like environments (eBPF, WASM, Container engine), Orchestration(kubernetes)  | |
| OS footprint:       | Small | below 200k SLOC |
| OS Scheduling:      | E.g. scheduler used (real-time?), ARINC653 Apps/tasks, processes, threads, MMU-isolated, namespaced |  |
| Boot-up time:       | within <x> seconds / <x> milli-seconds | Frame this as (warm vs. cold start) |
| Fault handling:     | e.g., detection, remediation, tree showing domains/isolation/cascading, BITE, logging, reporting upstream, FMEA | Development analysis / design / operational |
| Languages:          | C, ADA | (Future) RUST |
| Storage:            | 512MB - low GB | |
| Memory:             | 512MB - low GB | |
| Memory allocation:  | static / dynamic | Impacted by system state? When allowed to allocation, can you free, etc? |
| Worst Case Execution Time (WCET):               | Knowledge about WCET for OS / user-code functions, known max. induced interferrence (e.g., on multi-core) | |
| CPU Performance:    | MHz/FLOPS/DMIPS/Optimization level | |
| CPU Cores:          | <count> | |
| Tool Qualification: | NA/Possible | (To what level / background details) |
