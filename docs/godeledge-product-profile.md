<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Product Profile: GodelEDGE - Onboard Satellite AI Inference

## Space Products (LEO Payload) > Onboard AI/ML Inference

GodelEDGE is an edge AI inference system for onboard satellite imagery processing. It runs computer vision models (semantic segmentation for disaster detection) on COTS GPU hardware in orbit, downlinking compact alert payloads instead of raw imagery. Currently at prototype stage on NVIDIA Jetson Orin dev boards, targeting LEO small-sat deployment on GPU-equipped hosted payload platforms (e.g., Loft Orbital).

| Product Aspect(s) | Details | Notes |
| --- | --- | --- |
| Operational duration:  | 5-7 years (LEO small-sat missions) | Driven by target partner mission lifetimes. Hardware partner-dependent. |
| Userdata update cycle: | Quarterly to annually (ML model weights via uplink) | Updated models trained on ground, exported to TensorRT/ONNX, pushed via ground station contact window. Cadence TBD. |
| Platform update cycle: | Infrequent, aligned with satellite operator OS updates | Payload software runs on partner compute platform. OS updates managed by satellite operator. |
| Software Level:     | TBD, not formally assessed | Payload data processing application. System failure = missed detections, not vehicle loss. Likely D or E equivalent. |
| Security:           | Encrypted downlink, containerized application isolation | Alert payloads encrypted before downlink. Application runs in Docker containers. No formal security assurance level defined. |
| App Capability:     | POSIX Apps, Python (containerized), GPU-accelerated ML inference | Python 3.11+ in Docker on Linux (JetPack/L4T). PyTorch models, TensorRT inference runtime. |
| System Constraints: | Power-constrained (5-20W), COTS hardware in radiation environment, offline-only, thermal | Wake-on-event tiered architecture: ~5W idle, ~20W burst. Must operate fully autonomous without ground contact. ECC memory assumed. |
| Architecture Constraints: | Tiered inference (wake-on-event), deployment-agnostic adapter layer | Multiple inference stages with different power profiles. Adapter abstracts sensor/comms/position/lifecycle per platform. |
| Protocols:          | TCP/IP (ground segment), filesystem/shared-memory (internal) | Ground: REST API (FastAPI). Edge-internal: filesystem-based GeoTIFF watch or shared memory. Partner-specific protocols vary by platform. |
| IO:                 | Multispectral sensor input (4-13 bands), GPS/ephemeris, Ethernet | Input: multispectral imagery (visible + NIR + SWIR). Position: GPS + satellite attitude. Output: compact alert payload (JSON). |
| Dataload/fieldload: | Commercial OTA from ground station | Model artifacts via NGC private registry. Uplink mechanism depends on satellite operator. No ARINC-style dataloader. |
| OS standards:       | POSIX, Linux (NVIDIA JetPack/L4T), Docker containers | Full Linux distribution. Docker for app isolation. No ARINC653 partitioning. SGL distribution is a future target and motivation for this contribution. |
| OS footprint:       | Large | Full JetPack/L4T Linux + CUDA/cuDNN/TensorRT runtime. 15M+ SLOC equivalent. |
| OS Scheduling:      | Standard Linux CFS scheduler (not hard real-time) | No hard real-time requirements. Wake-on-event trigger is polling-based. Inference is batch (per-tile). |
| Boot-up time:       | Within ~60 seconds (cold start, estimated) | Compute platform runs continuously. GodelEDGE process starts on boot. Cold start includes ML model loading into GPU memory (seconds range). Not yet benchmarked. |
| Fault handling:     | Design intent: ECC memory, application watchdog, graceful degradation | ECC catches single-bit errors. Watchdog restarts on crash. Missed detections acceptable (not safety-critical). No formal FMEA performed. Software radiation protection (e.g., Radshield-style) is of interest but not implemented. |
| Languages:          | Python 3.11+ (primary), C++ (future performance-critical extensions) | Core application is Python. TensorRT inference via Python bindings. C++ extensions planned but not started. |
| Storage:            | Low single-digit GB (volatile cache + model weights) | No persistent storage of raw imagery. Process and discard. Model weights on eMMC/SSD. |
| Memory:             | 4-8GB system RAM, majority of available GPU memory | Min: Jetson Orin Nano (4GB shared). Target: Jetson AGX Orin (64GB). GPU memory is the binding constraint for inference. |
| Memory allocation:  | Dynamic (Python/PyTorch managed) | PyTorch allocates GPU memory dynamically. Inference workload is bursty (wake-on-event), not constant. No static allocation. |
| Worst Case Execution Time (WCET): | Not formally analyzed. Seconds-range per tile. | GPU-bound inference. Multi-core interference not characterized. |
| CPU Performance:    | 40 TOPS INT8 (Orin Nano dev) / 248 TOPS INT8 (AGX Orin target) | GPU-dependent workload. 1024 CUDA cores (dev) / 2048 (target). ARM CPU: 6-12 cores. Inference is GPU-bound. |
| CPU Cores:          | 6 ARM + 1024 GPU (dev) / 12 ARM + 2048 GPU (target) | Dev: Jetson Orin Nano. Target: AGX Orin class (example: Loft Orbital hosted payload). |
| Tool Qualification: | None | Standard open-source toolchain (Python, PyTorch, GCC). At Level D/E, tool qualification unlikely to be required. |

**Safety / Software Standards Note:** No formal safety or software standards are currently applied. GodelEDGE is a payload data processing application at prototype stage. Relevant standards that could apply as the system matures toward flight qualification include NASA-STD-8739.8 (software assurance, relevant if SBIR-funded), GSFC-STD-8000 (if GSFC is mission authority), and MIL-STD-882E (if DoD-funded via SpaceWERX/AFRL). DO-178C is not directly applicable but may be flowed down by aerospace primes. We are interested in SGL precisely to understand what OS-level safety guarantees are feasible for AI/ML payload workloads and to contribute requirements from this application domain.
