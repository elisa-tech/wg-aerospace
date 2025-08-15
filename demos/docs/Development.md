# Development

## Overview

The following instructions assume that you've completed the [Environment Setup](./EnvSetup.md).

|todo make block diagram of the dev environment and dependencies

### Get a development shell

1) Similar to [Environment Start Here](./EnvSetup.md#start-here) get a Linux shell in your respective environment.
2) Navigate to your clone of this project and [cd demos/copilot/src/monitors/](../copilot/src/monitors/).
3) Execute the following to get a `development environment shell` within our container.

   ```bash
   make dev
   ```
4) At this point you're in the docker container with all the tools to do testing and rebuild of the demos.
5) The `copilot` folder has been mounted as `/demo/` within the container.  This is the only persistant folder between invocations of the container.
6) To verify you're still in the container you can check existance, e.g., `ls /demo`.
7) To exit the container, type `exit` in the shell and it will close the shell and shutdown.

#### Setup the development shell cross compiling (emulated target apps)

1) Before entering the `make dev` environment, navigate to your clone of this project and [cd demos/copilot/src/monitors/](../copilot/src/monitors/).
2) Execute `make prep_cross` to retrieve the latest pre-built Linux images and cross toolchain.  This stores the archives and extracted form of these in the `monitors` folder.  It also invokes the toolchains relocation logic that needs to setup cross tool's LDPATH(s).
3) Enter the `make dev` containerized environment.
4) If you want the cross tools to become the default (i.e., "CC, LD, ARCH" env vars), navigate to the following folder and run a environment script to export all the variables in the local shell for use.

   ```
   cd /demo/monitors/aarch64-buildroot-linux-musl_sdk-buildroot/
   . environment-setup
   ```
5) If you're on Windows and have VSCode open + attached to a WSL distro (WSL and Docker Extensions), you can attach to the now running container to do GUI development.  (Similar on Linux minus the WSL distro portion. VSCode should be able to attach using the Docker extension.)
6) To exit the container, type `exit` in the shell and it will close the shell and shutdown.  If you were attached with VSCode, that will also terminate.

#### Using VSCode with the active development container

1) Environment pre-req
   1) Windows: Open VSCode and have the `WSL + Docker Extensions`
      1) Attached to a WSL distro you're using for this work using `><` icon in bottom left.
   2) Linux: Open VSCode and have the `Docker Extension`.
2) Attach to the now running container to do GUI development using `><` icon in bottom left and picking it from the list.
3) At this point you can open folders, workspaces and start additional shells within the GUI.
4) If you exit the container in your non-VSCode shell, it will terminate the VSCode attachment.  Vs. If you stop VSCode, the container will continue to run until the non-VSCode original shell is exited.

### Using the Linux emulation

#### Makefile example

The [Makefile](../copilot/src/monitors/Makefile) has a streamlined example of doing a build and running one of the use case's test suites within the emulation.  This is the sequence to go through those steps.

```
make clean
make preo_cross_clean
make prep_cross                     # Gets the latest pre-built Linux images and cross toolchain
make main_syslog_time_cross         # Builds application under test
make main_syslog_time_cross_run     # Run the QEMU emulation with images containing "main_syslog_time_cross" artifacts
```

At this point you're within the QEMU emulation.  Run the following to execute the tests.

```
# Login as "root" without a password
cd monitors/ && ../tests/runtests.sh
```

To exit QEMU - `ctrl-a x`.  This puts you back in your Linux environment outside of the `container` and `emulation`.

#### Manually pulling the pieces together and running the emulation

1) To grab the latest pre-built images, before running 'make dev' to get into the container, run the following.

   ```bash
   make prep_cross
   ```
2) 
<stuff here>
To verify you're in the QEMU emulation, you can check the `/etc/os-release` which will state it's a "Buildroot" image.
<stuff here>

| ????Repackaging additional CPIO content


### Make targets and how to iterate/clean

#### Get new emulated environment tools and archive