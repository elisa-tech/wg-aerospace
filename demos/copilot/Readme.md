<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Light Sensor Use Case Demo using the Copilot Framework

This demo composes the deployment and sequences found in the [Light Sensor use case](../../docs/Aerospace-Uses-Cases.md).
It makes use of the the [Copilot runtime verification framework](https://github.com/Copilot-Language/copilot) for hard real-time systems.

## Getting Started

The [Environment Setup](../docs/EnvSetup.md) is a dependency for the demo examples.
It will has notes on tool setup and how to retrieve the Docker image.

The [Basic Demo](./BasicDemo.md) provides a native test app and Copilot walk through that uses simple applications with some sample data observations.
It also shows how to modify the specification and observe the impact.

The [Embedded Demo](./EmbeddedDemo.md) provides a test app and Copilot walk through that uses cross-compiled applications running in emulation with a more complex system observing the sample data observations.
It also shows how to modify the emulated system, specification and observe the impact.
