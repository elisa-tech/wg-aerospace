<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Building cFS

## Overview

The [Core Flight System (cFS) by NASA](https://github.com/nasa/cFS) is a generic flight software architecture framework used on flagship spacecraft, human spacecraft, cubesats, and Raspberry Pi.

The following instructions assume that you've completed the [Development Setup](./Development.md).

### Setup for cloning of cFS bundle

1) Navigate to your clone of this project (wg-aerospace)
2) cd to the monitors directory
   ```bash
   cd demos/copilot/src/monitors/
   ```
3) Execute the following to get a `development environment shell` within our container with minimal kernel and toolchain set up for cross-compiling:

   ```bash
   make prep_cross
   make dev
   ```
4) At this point you're in the docker container with all the tools to do testing and rebuild of the demos.
5) If you wish to have the cFS build to persist on the docker container
   ```bash
   cd /demo/
   ELISA_DEMO=$(pwd)/elisa_emulation
   ```
6) Make the directory where cFS will be cloned into
   ```bash
   mkdir -p $ELISA_DEMO && cd $ELISA_DEMO
   ```

### Clone cFS directory

1) Enter directory where cFS will be cloned
   ```bash
   cd $ELISA_DEMO
   ```
2) Clone cFS from github with submodules (patch is for cFS commit 9c786d2536821aae608560e0d75835e3637b499d):

   > **Note:** If you have already cloned cFS, you can skip this step.

   ```bash
    git clone https://github.com/nasa/cFS.git
    cd cFS
    git checkout 9c786d2536821aae608560e0d75835e3637b499d
    git submodule init
    git submodule update
   ```
3. Copy sample_defs and Makefile to cFS main directory

   > **Note:** If you have already cloned cFS, you can skip this step.

   ```bash
   cp -r cfe/cmake/sample_defs .
   cp cfe/cmake/Makefile.sample Makefile
   ```

### Apply necessary prebuild patch, build cFS, and load cFS build to QEMU emulation
1) Move to parent directory of cFS cloned repo to apply patch
   ```bash
   cd $ELISA_DEMO
   ```

2) From the parent directory of the cFS cloned repo, run the prebuild patch script to apply necessary patches on cFS
   ```bash
   bash /demo/cfs/scripts/apply_cfs_prebuild_patch.sh
   ```

3) Autogenerate the copilot app, copy apps to the cFS apps directory, and copy extra.h to the copilot app src
   ```bash
   cd /demo/cfs && bash /demo/cfs/scripts/auto_generate.sh
   cp -r /demo/cfs/apps/* $ELISA_DEMO/cFS/apps/
   cp /demo/cfs/elisa_usecase/extra.h $ELISA_DEMO/cFS/apps/copilot_app/fsw/src/
   ```

#### Build cFS
4) Move back to cFS directory to build cFS
   ```bash
   cd $ELISA_DEMO/cFS
   ```

5) Build cFS with following commands (note: the first build may take 5-10 minutes as the Copilot app downloads and compiles Haskell dependencies from scratch)
```bash
make SIMULATION=arm-linux-gnu O=build-elisa prep
make SIMULATION=arm-linux-gnu O=build-elisa
```

#### Loading cFS build to CPIO
6) Move to the directory that contains the ELISA simulation
   ```bash
   cd $ELISA_DEMO
   ```

7) Run the load cfs script which will extract the root fs from monitors directory, copy the cFS build to the extracted root fs, and additionally load the app library files/cFS tables to the cf directory
   ```bash
   bash /demo/cfs/scripts/load_cfs.sh
   ```

8) If wanting to use cmdUtil tool in the QEMU environment, cmdUtil will have to be recompiled with aarch64 and loaded onto the root filesystem
   ```bash
   bash /demo/cfs/scripts/build_cmdUtil.sh
   cd /demo/elisa_emulation/cFS/tools/cFS-GroundSystem/Subsystems/cmdUtil
   make
   sudo cp cmdUtil /demo/elisa_emulation/extracted_cpio/usr/cfs_build/arm-linux-gnu/default_cpu1/cpu1
   ```

### Running cFS on QEMU
1) Move to the directory that contains the ELISA simulation
   ```bash
   cd $ELISA_DEMO
   ```
2) Repackage extracted_cpio into compressed CPIO archive to be used as image for QEMU
   ```bash
   sh -c 'cd extracted_cpio && sudo find . | sudo cpio -H newc -o | gzip -c > ../rootfs.cpio.gz_new'
   ```

3) Run QEMU to emulate ARM 64-bit virtual machine ('ctrl-a x' to stop QEMU)
   ```bash
   qemu-system-aarch64 -M virt -m 512M -cpu cortex-a57 -smp 4 -nographic -kernel /demo/monitors/Image -initrd rootfs.cpio.gz_new -append "root=/dev/ram0 console=ttyAMA0"
   ```

4. Type in `root` for login

5) Once in QEMU, move to the following directory containing the executable:
   ```bash
   cd ../usr/cfs_build/arm-linux-gnu/default_cpu1/cpu1/
   ```

6) Run cFS
   ```bash
   ./core-cpu1
   ```

#### Sending command to sample app

7) To send a command within QEMU using cmdUtil, run cFS as a background process and redirect output to cfs.log
   ```bash
   ./core-cpu1 > cfs.log 2>&1 &
   ```

8) To check cfs output (to get out of viewer press CTRL+C)
   ```bash
   tail -f cfs.log
   ```

9) Run the following command to send a NO-OP command to Sample App
   ```bash
   ./cmdUtil --host=localhost --port=1234 --pktid=0x1882 --cmdcode=0
   ```

10) You should now see Copilot receive a NO-OP command in the cFS output

11) To exit QEMU, press `ctrl-a x`