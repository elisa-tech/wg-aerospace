# Aerospace Uses Cases

This document is a work in progress and has not been approved for use outside of the ELISA aerospace working group. 

## Use Case: Cabin Lights

Low DAL (D or lower)

### System Requirements

* The Cabin Lights system shall turn lights on in no less than 500 ms of the light switch turning on
* The Cabin Lights system shall turn lights off in no less than 500 ms of the light switch turning off

### System Architecture

Sensor=Switch; Function=Cabin Light Control; Function=Logging; Actuator=Cabin light (+ notification item in a log)

* Sensor is a switch with two values (on/off)
* Actuator is a light with two states (on/off), when a message is received on Ethernet, it updates its state to match
* Options for assuring comm
    * send periodic message of current state 
    * Or?  acknowledge messages from application
    * Or? poll both sensor and actuator
* Connectivity is an Ethernet bus (messages can be lost or corrupted)
* Computing platform running an "cabin lights" application
    * Cabin Lights Application
        * Application is waiting on the switch socket for a message, wakes up when message available
        * When awoken, 
        * application creates a message with new light state and sends on the light socket
        * log the event
        * yield?, goes back to waiting on switch socket

### Use Case Description

Single computer with single function (="APP")

[SENS] <-[ETH_MAC]-> [APP] <-[ETH_MAC]-> [ACT]

- Presume bidirectional connectivity from computing platform to sensor, and bidirectional connectivity from computing platform to actuator. 
- Smart sensor/actor w/ software and stack?
- How would a system architecure look like to close the signal/application loop? (7 voters in total)
  - Option A:
    - Simulate sensor + actuator on the H/W device running the system application (1 application being the cabin application, 2 applications being the simulated sensor + actuator)
      - A.1 Communication on software level (no physical ethernet cable) > Votes: 1
      - A.2 Communication on hardware level using several network cards connected through H/W Ethernet (i.e. physical network-cable) > Votes: 1
    - Thoughts: [Ivan]: Maybe we miss something because its too simplistic
  - Option B: > Votes: 4
    - Sensor + actuator on a general purpose computer as emulation (on non-Aerospace Linux)
      - Attention: This probably means no real-time OS on sensor / actuator side
    - Application computer w/ real-time Aerospace Linux running the system/cabin application(s)
  - Option C:
    - 3 pieces of H/W: Sensor, actuator + Computing Device
    - Connected physically via Ethernet through switch or alike > Votes: 0
  - Comment on votes: (1 non-voter)
- Comment: This use case would not necessarily need an OS, but even in this case there are some capabilities we can leverage from the OS. Furthermore, this may be one of several use cases (functionalities) supported by the OS. >> But an OS is implied for the Use-Case!

### Analysis of required (OS) features

- OS must provide for the application (at least):
    - protocol/network stack, drivers (e.g. ethernet)
    - scheduling (due to the presence of other functions, including protocol/network stack)
    - memory


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
    - Standard mapping to painpoints
    - Existing whitepaper may start to cover some of this

What is the feedback approach / rollout for the use cases?
- Audience? - **ACTION** Check with Min/Kate for Automotive's approach for previous cases
- Survey to a wider audience when sharing the use case to cover topics like what distro / Linux approach they are using.  Survey how they use it, compose it, and cfg they depend on
  - Use this to drive our next use case and timeline
  - **ACTION** build a list of question ideas on the mailing list

## Foreseeable Next Steps (TBC at the next meetings!)

- Decide upon "OS"
  - What "Linux"?
  - If the use case implied a distro, what would it be based on or would it follow a pattern like carrier grade that standardizes a configuration. (for the few of us on the call)Leaning towards a pattern/standard.  e.g., Yocto/RHEL/Ubuntu using a pattern with artifacts living in core projects.  So maybe for the current aerospace use case we could reuse the Automotive Yocto configuration?
  - ACTION Need to checkout ref build that automative did for their use case.
- Come up with required steps for the "Kernel Config" (Task-Force?)
- ...
- Clarify assessment -> What do we want to know / to achieve? --> Link to Space Grade Linux
- Assessment items & Criteria
- ...
- Develop required fundamental functions ("OS / service development")
- Develop system function(s)
