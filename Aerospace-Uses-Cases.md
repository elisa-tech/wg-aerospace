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

Single computer with single function

[SENS] -[ETH_MAC]-> [APP] -[ETH_MAC]-> [ACT]

- Presume bidirectional connectivity from computing platform to sensor, and bidirectional connectivity from computing platform to actuator. 
- This use case would not necessarily need an OS, but even in this case there are some capabilities we can leverage from the OS. Furthermore, this may be one of several use cases (functionalities) supported by the OS.

### Analysis

- OS provides:
    - protocol/network stack, drivers
    - scheduling (in presence of other functions, including protocol/network stack)
    - memory
