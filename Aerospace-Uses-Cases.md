# Aerospace Uses Cases

This document is a work in progress and has not been approved for use outside of the ELISA aerospace working group. 

## Use Case: Cabin Lights

Low DAL (D or lower) - blackbox level - functionally meets expectations

### System Architecture

Hardware:
* Switch (Sensor)
  * Switch has two values (on/off)
* Cabin light (Actuator)
  * Cabin light has two states (on/off), when a message is received on Ethernet, it updates its state to match
* Computing device (platform) running the Apps
* Connectivity is an Ethernet bus (messages can be lost or corrupted)
  * Options for assuring communication
    * Send periodic message of current state 
    * Or? acknowledge messages from application
    * Or? poll both sensor and actuator

Software Functions ("Apps"):
* Switch App
* Cabin Lights App
  * Application is waiting on the switch socket for a message, wakes up when message available
  * When awoken, 
    * application creates a message with new light state and sends on the light socket
    * log the event
    * yield?, goes back to waiting on switch socket
* Logging App
* Monitoring App (CoPilot based)
  * Continously monitors correct functionality (e.g. stay witihn time limits)

* Options/Scenarios to consider and enhance on
  * "One Device": Switch and Cabin light connected to a single device, Apps are hosted on the same device
  * "Two Devices": Switch and Cabin light are connected on 2 devices, connected via network, Apps are hosted on throse 2 devices respectively, too
  * "Three/More Devices": Switch and Cabin light arte connected on 2 devices, Monitoring App hosted on another one, all connectd through a network

### System Requirements

* The Cabin Lights system shall turn lights on in less than 500 ms of the light switch turning on
* The Cabin Lights system shall turn lights off in less than 500 ms of the light switch turning off

### Use Case Description for scenario "One Device"

Single computer with single function (="APP")

[SENS] <-[ETH_MAC]-> [APP] <-[ETH_MAC]-> [ACT]

- Presume bidirectional connectivity from computing platform to sensor, and bidirectional connectivity from computing platform to actuator. 
- Smart sensor/actor w/ software and stack?
- Best effort scheduling of IO processing that's tested for perceived worst case. (No monitor or scheduler based guarantee other then planned scheduler bandwidth/capacity margin)
- How would a system architecture look like to close the signal/application loop? (7 voters in total)
  - Option A:
    - Simulate sensor + actuator on the H/W device running the system application (1 application being the cabin application, 2 applications being the simulated sensor + actuator)
      - A.1 Communication on software level (no physical ethernet cable) > Votes: 1
      - A.2 Communication on hardware level using several network cards connected through H/W Ethernet (i.e. physical network-cable) > Votes: 1
    - Thoughts: [Ivan]: Maybe we miss something because its too simplistic
  - Option B: > Votes: 4  (SELECTED)
    - Sensor + actuator on a general purpose computer as emulation (on non-Aerospace Linux)
      - Attention: This probably means no real-time OS on sensor / actuator side
    - Application computer w/ real-time Aerospace Linux running the system/cabin application(s)
  - Option C:
    - 3 pieces of H/W: Sensor, actuator + Computing Device
    - Connected physically via Ethernet through switch or alike > Votes: 0
  - Comment on votes: (1 non-voter)
- Comment: This use case would not necessarily need an OS, but even in this case there are some capabilities we can leverage from the OS. Furthermore, this may be one of several use cases (functionalities) supported by the OS. >> But an OS is implied for the Use-Case!

#### Test 

Items to key on
  - Logging check
  - Ethernet message check - i.e., socket msg in / out analysis using time criteria
    - how do we test this, is it extra hardware or application running beside a emulation doing pkt analysis
    - log data and post analysis?
    - online - build a cicd scenario and get earlier feedback on individual test failure without post-analysis

Test environment
- No ebpf
- start with emulation (is there a limitation in timing because of type of emulation?)
  - qemu can we count cycles to see if we can bound it?  maybe not realtime
- Architecture of Test Environment:
  - Sim/Emulator (Combo of containers and QEMU)
  - Here's the components involved and a sequence diagram of dataflow
  - (To view these diagrams, make sure your vscode has the Markdown Preview Mermaid Ext - `bierner.markdown-mermaid` or view on Github)

    ```mermaid
    %%{init: {'theme': 'default'}}%%
    graph TD
        subgraph QEMU_Environment_Unit_Under_Test
            direction TB
        Ethernet_Bridge
            App[2.Cabin Lights App] 
            Log[Logging App]
            Sensor[1.Switch App]
            Actuator[3.Cabin Light]

        subgraph Monitor
            direction TB
            Copilot[CoPilot]
        end

        end



        App -->|Interacts with| Log
        Sensor -->|Sends State Msg| Ethernet_Bridge
        Copilot -->|Sniffer| Ethernet_Bridge
        Ethernet_Bridge -->|Sends State Msg| App
        App -->|Control Msg| Ethernet_Bridge
        Ethernet_Bridge -->|Control Msg| Actuator
        Copilot -->|Log tail| Log

        style QEMU_Environment_Unit_Under_Test fill:#f9f,stroke:#333,stroke-width:2px;
        style Monitor fill:#bbf,stroke:#333,stroke-width:2px;
    ```

    ```mermaid
    sequenceDiagram
        participant Sensor as Switch
        participant Ethernet as Switch Ethernet Bridge
        participant App as Cabin Lights App
        participant Actuator as Cabin Light
        participant Log as Logging App <br> (Syslog)
        participant CheckLog as CoPilot Log <br> Monitor
        participant CheckEth as CoPilot Ethernet <br> Monitor

        CheckLog->>Log: Monitor events
        CheckLog->>CheckLog: Wait for new logs
        CheckEth->>Ethernet: Monitor for packets
        CheckEth->>CheckEth: Wait for new packets
        Sensor->>Log: Log event (Switch State Change)
        Log-->>CheckLog: Trigger
        Sensor->>Ethernet: Send Switch State (On/Off)
        Ethernet-->>CheckEth: Capture
        Ethernet->>App: Send Switch State (On/Off)
        App->>App: Wake up on message
        App->>App: Create message with new light state
        App->>Log: Log event (Switch State Change)
        Log-->>CheckLog: Trigger
        App->>Ethernet: Send message
        Ethernet-->>CheckEth: Capture
        Ethernet->>Actuator: Send message
        App->>App: Yield and wait for next message
        Actuator->>Actuator: Update state to match message
        Actuator->>Log: Log event (Light State Change)
        Log-->>CheckLog: Trigger
        Actuator->>Actuator: Yield and wait for next message
    ```

Copilot - [a runtime verification framework for hard real-time systems](https://github.com/Copilot-Language/copilot/blob/master/copilot/README.md)
- From the point of view of connecting it to the rest of the testing infrastructure, all it needs is:
  - A boolean (global variable) that indicates if the light switch is on or off.
  - A boolean (global variable) that indicates if the lights are on.
- It can also connect in if a function is provided that allows CoPilot to "sense" if the light switch is on/off, and whether the lights are on/off. There are other ways to connect it (e.g., SW bus, etc.).
- Framework is split into portions that monitor and those that drive/stimulate test
  - Allows driving scenarios but not necessary monitoring unless needed.
- Can be used for
  - fault violations (operationally can use as a monitor with remedy actions)
    - drive simulink behaviors
    - this was the original purpose
  - trace/debug
  - test is a newer use case
- How does it work?  (Build workflow)
  - The practice is to generate C99 code on a development machine
  - Users build the C code with their application toolchain (native or cross)
  - Most pkg managers already have the framework available e.g., on Ubuntu23 `sudo apt-get install libghc-copilot-dev`
  - How does DO-330 qual impact copilot (Wanja mentioned)
    - **Action** - Should consider this in outbrief of the test demo
    - **Action** - Some interest in a DO-178C comparison to NPR7150.2 [Manuel]
    - NPR7150.2 Addition D - Class C and above today
    - Domain Specific Language (DSL) to LLVM interpreted representation - formal proof (independence was used to develop)
    - rigorous dev process

Test apps around the use case core application
- Test apps send the message in and receives the message out
- Copilot runs on separate processors (monitors don't impact UUT) - pkt analysis around emulated use case

Emulation How-To
- How to approach Windows development of the emulation  + OS build
  - [CI Readme](https://gitlab.com/elisa-tech/aero-wg-ci/-/blob/main/README.md?ref_type=heads) shows locally running the example CI build.
- Brainstorming on how to compose the emulation / networking
  - Build the UUT environment in the buildroot docker image
    - Results in a minimal kernel, rootfs and SDK toolchain to build apps
      - Builds the Cabin Lights  (CLA)
      - Provides syslog daemon configured to send logs out to a UDP destination (blindly that Copilot can tap on the Actuator Bridge)
  - Testbed
    - Are there existing CoPilot docker containers with all the dependencies so we can build the test apps and any coPilot monitor/tap app?
  - Runtime
    - Run in the CoPilot container with NET_ADMIN rights to make TAPS
    - Build two bridges, tap those bridges for QEMU access and assume some IP configuration (or do we want to just use Eth frames?)
    - QEMU launch the UUT
      - Bind the taps and configure the CLA to have ports on the right switches
    - Start the test apps bound to the right bridge interfaces / IPs
    - Start the coPilot app last or have it do all this staging before telling the Switch app to toggle.

### Analysis of required (OS) features

- OS must provide for the application (at least):
    - Network Stack with UDP IP
      -  Ethernet Driver
      -  IRQ subsystem
      -  MAC subsystem
      -  DMC subsystem
    - Scheduling
      - Needed by network stack, filesystem io and user space
      - Timers
      - Fair scheduler
    - Memory
      -  Userspace (stack/heap) for application use
      -  IO access (userspace accessing IO memory)
      -  Network buffers
    - System configuration + hardware drive cfg (e.g. device tree)
    - GPIO (pin setup) - Is needed?
    - ???Other OS stuff?
      - stdlib
- Tools / libraries
  - C lang Compiler/linker
  - Device tree compiler

## System Test and Measurement

- What do we want to measure? (blackbox)
  - If we have a env, what do we actually want to measure?
    - Does it run, timing, performance, err injection
  - Drives additional drivers / dependencies, i.e. network / file dependencies
    - on device vs external
  - NASA has a framework for monitor / measurement practice (eBPF compatible) (copilot)
    - https://github.com/Copilot-Language/copilot
    - Hard realtime C99 compat
    - Formal proof of code meets spec
  - What is enough? Service history(but how)
    - Tests of the feature used  (in context of final system)
      - Resource allocation verification
      - Feature focused system blackbox coverage (not full code coverage testing)
    - Review of configuration subset relevant to required feature set
    - Documentation of the lifecycle
    - Static analysis (SDLC practice)
- **NEXT TIME** Key in on what do we want to measure from our use case above.  Ivan offered to look at applying copilot after we have the initial draft of measurement criteria.

Copilot - framework has hooks to tie different parts together

## Deliverables and feedback.

What is our output of the use case activity?  In our previous meeting, it was suggested that we define a result we can measure/use.
- Our current whitepaper - survey of existing Linux in safety critical use  (it is in-progress research)
  - Trying to identify why it's hard and what prevents use.
- Output needs to have a tangible reason / visible result.
  - Influence direction of tools and long term support
  - Focus team on specific topics
  - (Int: ELISA) Use cases help drive other working groups work based on the domain need
  - (Ext: Inform SPDX-safety) Capture requirements and example approach to safety critical schema for capturing of those.  Evidence and trace.  (Zephyr involved)
  - (Ext: Xen / over hypervisor&virt approaches) Set the foundation to drive to mixed criticality
  - Deployment of pieces and objectives/standards applicable + justification
  - (Ext: Yocto / Linux / toolchain - i.e. components of the design) Influence configuration and structure changes to allow compositions.  Simplification for certification approaches.  E.g. indirect kernel change we depend on
  - Defines our groups need as a group
  - Other use cases might overlap with other groups  (Example of reliability and wifi fading)
    - Interesting use case that ties to a practice that ties to the reliability of a system  (Needs to engage non-interested parties)
  - Criteria to measure against other WGs - e.g, pain points conversation for an SWL C/D specific guidance
    - Lifecycle items - requirements / design / objective process items
    - Standard mapping to pain-points
    - Existing whitepaper may start to cover some of this

What is the feedback approach / rollout for the use cases?
- Audience? - **ACTION** Check with Min/Kate for Automotive's approach for previous use cases.  "What is the feedback approach / rollout for the use cases?  Audience?"
- Survey to a wider audience when sharing the use case to cover topics like what distro / Linux approach they are using.  Survey how they use it, compose it, and cfg they depend on
  - Use this to drive our next use case and timeline
  - **ACTION** Use the mailing list to build a list of questions for a survey.  Questions would cover topics like what distro / Linux approach they are using and how they use it, compose it, and cfg they depend on, etc. - Used to drive our next use case and timeline.

## Foreseeable Next Steps (TBC at the next meetings!)

- Decide upon "OS"
  - What "Linux"?
  - If the use case implied a distro, what would it be based on or would it follow a pattern like carrier grade that standardizes a configuration. (for the few of us on the call)Leaning towards a pattern/standard.  e.g., Yocto/RHEL/Ubuntu using a pattern with artifacts living in core projects.  So maybe for the current aerospace use case we could reuse the Automotive Yocto configuration?
  - **ACTION** Need to checkout ref build that Automotive did for their use case.
- Come up with required steps for the "Kernel Config" (Task-Force?)
- ...
- Develop required fundamental functions ("OS / service development")
- Develop system function(s) - [MW] Can these map to the other WGs definition of components/functions?
- Do we need to introduce a dictionary? One example of a question that was raised:   Is this covered in another WG?
  - What is the understanding of "multiple functions"? -> 3 Answers with 9 people
    - 1) Multiple PCI devices SATA, USB, network etc.
    - 2) PCI devices with multiple functions, root bridge can have multiple functions
    - 3) System function perspective: Applications (processes, tasks, functions as S/W components) to achieve a system function like switch on cabin light (example: read sensor, log data, report failure, drive actuator)
  - Tend to a common understanding of 3)
  - [MB] data dict used as a alignment tool between development teams (i.e. header generation).  Also referenced as a glossary. (logical names / themes to expand on to code artifacts)
  - **ACTION**: Need to check with Martin. [IP] maybe the goal was term alignment as multiple teams have a different perspective.
  - Brainstorm on additional use cases vs certification profiles

- Other use cases
  - mixed safety / non
  - cases that require runtime monitoring - watchdog / crc'n / bit checks / etc
  - overlay of how containment strategies would apply

## References

### Space Frameworks comparison
- JPL - Fprime
- Goddard - CFS (C-based with cert artifacts)
- Refs:
  - https://digitalcommons.usu.edu/cgi/viewcontent.cgi?article=6013&context=smallsat
  - https://s3vi.ndc.nasa.gov/ssri-kb/static/resources/CL18-2993.pdf
  - https://hackmd.io/@jonathanmichel/Hyu3Azl_P
  - https://www.scielo.br/j/jatm/a/ZNY8mTKcbh8MT5xvbvyytqG/?format=pdf


### Emulation

QEMU CAS
- https://carrv.github.io/2023/papers/CARRV2023_paper_5_Cao.pdf
- http://cps.kaist.ac.kr/papers/16RTSSWIP_cycle.pdf


SystemC example
- https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/862421112/Co-simulation
- [Versal AIE](https://docs.amd.com/r/en-US/ug1273-versal-acap-design/AI-Engine-Simulation)


Renode
- https://renode.io/ - board level simulation, accuracy?
- https://renode.readthedocs.io/en/latest/tutorials/co-simulating-custom-hdl.html
- For Microchip PolarFire Soc, emulating Linux on Renode should be possible - https://ww1.microchip.com/downloads/aemdocuments/documents/fpga/ProductDocuments/SupportingCollateral/renode_webinar_16.pdf

### New Use Cases

#### Space focused
- What are the dependencies for running frameworks (CFS, etc) on top?
  - Using CFS dockerfile as setup instructions for the userspace part plus look at what is required in minimal kernel
- Would this apply to cubesats?  (Could start here and grow towards larger example?)
  - Could be used for incubating university projects (Michael)
- Impacts to criticality/rigor (what standards would apply in a cubesat case? Class C? )
  - Criticality & cost factors into Class
- Any feedback from the survey that could help inform this?
- https://www.polysat.org/
  - From: https://digitalcommons.calpoly.edu/cgi/viewcontent.cgi?article=1720&context=eesp
  - "the PolySat software architecture runs entirely on a custom Linux operating system"
  - Maybe a group for user feedback for what we define (design, prototype)
- https://www.jpl.nasa.gov/missions/mars-cube-one-marco/ 
- https://www.asi.it/en/planets-stars-universe/solar-system-and-beyond/liciacube/
