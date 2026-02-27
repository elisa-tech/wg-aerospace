<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Aerospace Working Group Demonstrations

This folder contains a series of examples, documentation, and reference builds to achieve the following goals.

- Clear tool setup
- Examples of customizing a concept/configuration
- Recreation and observation of a demo
- Discussion on how to tailor/capture specific attributes of the system for other use cases
- Development of new content

## Environment Setup

The [Environment Setup](./docs/EnvSetup.md) is a dependency for the demo examples.
It will has notes on tool setup and how to retrieve the Docker image.

Alternatively, [AvioNix Demo](./AvioNix-demo/README.md) contains a Nix based build infrastructure compile and run demos.

> TBD tie to our background notes on the [env](../demos/docs/embedded-environments/Readme.md)

## Use case Examples

- [Light Switch](./copilot/Readme.md)

## Development

The [Development Guide](docs/Development.md) is a good place to start if you need to get a shell within our environment to debug or expand on the demonstration material.

The demos use a few pre-built [Embedded Environments](docs/embedded-environments/Readme.md).
Each demo is assembled using the necessary tooling and base images.

## Contributing

TBD, declare license and DCO plan for developer agreement
