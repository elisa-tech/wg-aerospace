<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Development

## Overview

The following instructions assume that you've completed the [Environment Setup](./EnvSetup.md).

|todo make block diagram of the dev environment and dependencies

### Get a development shell

1. Similar to [Environment Start Here](./EnvSetup.md#start-here) get a Linux shell in your respective environment.
2. Navigate to your clone of this project and [cd demos/copilot/src/monitors/](../copilot/src/monitors/).
3. Execute the following to start the devcontainer locally on first use.

   ```bash
   make prep
   ```

4. Then execute the following to open a shell in the devcontainer.

   ```bash
   make dev
   ```

5. At this point you're in the devcontainer with all the tools to do testing and rebuild of the demos.
6. The repository is mounted as the workspace in the container, so changes persist across sessions.
7. To verify you're still in the container you can check existence, e.g., `ls demos/copilot/src/monitors`.
8. To exit the container, type `exit` in the shell and it will close the shell and shutdown.

#### Setup the development shell cross compiling (emulated target apps)

1. Before opening the devcontainer shell, navigate to your clone of this project and [cd demos/copilot/src/monitors/](../copilot/src/monitors/).
2. Execute `make prep_cross` to retrieve the Linux images and cross toolchain. This stores the archives and extracted form of these in the `monitors` folder. It also invokes the toolchain relocation logic that needs to set up cross tool LDPATH values.
3. Run `make prep` and then `make dev` to enter the devcontainer environment.
4. If you want the cross tools to become the default (i.e., "CC, LD, ARCH" env vars), navigate to the following folder and run a environment script to export all the variables in the local shell for use.

   ```bash
   cd ./aarch64-buildroot-linux-musl_sdk-buildroot/
   . environment-setup
   ```

5. If you're on Windows and have VS Code open plus attached to a WSL distro, you can attach to the running container to do GUI development. The same applies on Linux without the WSL layer.
6. To exit the container, type `exit` in the shell and it will close the shell and shutdown. If you were attached with VSCode, that will also terminate.

#### Using VS Code or the CLI with the active development container

1. VS Code: Install the Dev Containers extension, open the repository, and choose the Dev Containers command to reopen in the container.
2. CLI: From the host, run `make prep` in `demos/copilot/src/monitors` to start the devcontainer, then run the build or test targets from the same directory.
3. In both cases, the Makefile now executes inside the container instead of pulling a prebuilt image.

### Using the Linux emulation

#### Makefile example

The [Makefile](../copilot/src/monitors/Makefile) has a streamlined example of doing a build and running one of the use case's test suites within the emulation. This is the sequence to go through those steps.

```bash
make clean                          # Removes built apps, objects and generated files
make prep_cross_clean               # Removes cross environment images and toolchain
make prep_cross                     # Gets the latest pre-built Linux images and cross toolchain
make main_syslog_time_cross         # Builds application under test
make main_syslog_time_cross_run     # Run the QEMU emulation with images containing "main_syslog_time_cross" artifacts
```

At this point you're within the QEMU emulation. Run the following to execute the tests.

```bash
# Login as "root" without a password
cd monitors/ && ../tests/runtests.sh
```

To verify you're in the QEMU emulation, you can check the `/etc/os-release` which will state it's a "Buildroot" image.

To exit QEMU - `ctrl-a x`. This puts you back in your Linux environment outside of the `container` and `emulation`.

#### Manually pull the pieces together and running the emulation

This section assumes you've at least followed the ["Setup the development shell cross compiling"](#setup-the-development-shell-cross-compiling-emulated-target-apps) steps and are currently in a shell started by `make dev`.

The following uses makefile targets from [Makefile](../copilot/src/monitors/Makefile) as examples. The examples need to not have the "Run" and "Command" prefix set. (TBD improve the Makefile for direct use inside the `make dev` environment.)

1. `main_syslog_time_cross` target shows the steps you could repeat inside the `make dev` environment to build the application locally. It includes a step to package the application into the cpio emulation filesystem. The [modifying a rootfs](ModifyRootfsCpio.md) document has more details on adding other content to the CPIO.
2. `main_syslog_time_cross_run` to see how to run the qemu emulation.

### Make targets and how to iterate/clean

#### Get new emulated environment tools and archive

This section covers how to update to a new emulated environment and SDK/toolchain. It forces all the artifacts to be retrieved and reconfigured.

```bash
make prep_cross_clean
rm -f archive.tar # tmp, need this MR to merge to fix cleanup
make prep_cross
# At this point `make dev` could be used for development with the new toolchain
```
