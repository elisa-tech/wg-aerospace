<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Operating Environments Demonstrating Mixed Functions

(PROPOSAL)

The example configurations below build on the existing [standalone](Standalone.md) Cabin Lights demo to show how it can re-host into a partitioned environment.  The goal is that the same images demonstrated in QEMU standalone can be ran within a partition of Xen.

These environments run in QEMU and are built on the https://gitlab.com/elisa-tech/aero-wg/demo-cert-linux and (future) https://gitlab.com/elisa-tech/aero-wg/demo-cert-xen.

Capabilities:
- Minimal Linux environment
- Minimal Xen FuSa environment
- Simulation of multiple systems
- Mixed safety concepts
- Mixed OS and runtimes

The ELISA SystemWG has assembled a similar [example system](https://github.com/elisa-tech/wg-systems/blob/main/Documentation/xen-demo-zcu102/Readme.md) to illustrate interactions between system components.  Building from those examples and the [Software Defined Vehicle concepts](https://static.sched.com/hosted_files/ossjapan2025/d0/AGL%20Update%20Miner%20ALS%202025.pdf), the following scenarios are proposed.

## Basic Cabin Lights

![pic](cabin-lights-basic-xen.drawio.svg)

## cFS Cabin Lights

![pic](cabin-lights-cfs-xen.drawio.svg)

## (New) cFS Cabin Lights w/ Ground Simulation

![pic](cabin-lights-cfs-xen-groundsim.drawio.svg)