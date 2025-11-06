# Building cFS

## Overview

The following instructions assume that you've completed the [Development Setup](./Development.md).


### Setup for cloning of cFS bundle

1) Navigate to your clone of this project and [cd demos/copilot/src/monitors/](../copilot/src/monitors/).
2) Execute the following to get a `development environment shell` within our container with minimal kernel and toolchain set up for cross-compiling:

   ```bash
   make prep_cross
   make dev
   ```
3) At this point you're in the docker container with all the tools to do testing and rebuild of the demos.
4) Install required packages inside the container `sudo apt update && sudo apt install -y  vim git file wget make cmake` 
5) If you wish to have the cFS build to persist on the docker container, cd to `/demo/` and set the variable `ELISA_DEMO=$(pwd)/elisa_emulation`
6) Make the directory where cFS will be cloned into `mkdir -p $ELISA_DEMO && cd $ELISA_DEMO`

### Clone cFS directory

1) Enter directory where cFS will be cloned `cd $ELISA_DEMO`
2) Clone cFS from github with submodules (patch is for cFS commit 9c786d2536821aae608560e0d75835e3637b499d): 
   ```
    git clone https://github.com/nasa/cFS.git
    cd cFS
    git checkout 9c786d2536821aae608560e0d75835e3637b499d
    git submodule init
    git submodule update
   ```

### Apply necessary patch, build cFS, and load cFS build to QEMU emulation
1) Move to parent directory of cFS cloned repo to apply patch `cd $ELISA_DEMO`

2) From the parent directory of the cFS cloned repo, run the following command to apply the patch on cFS `patch -p1 < elisa-custom-cfs.patch`

#### Build cFS
3) Move back to cFS directory to build cFS `cd $ELISA_DEMO/cFS`

4) Build cFS with following commands
```
make SIMULATION=arm-linux-gnu O=build-elisa prep
make SIMULATION=arm-linux-gnu O=build-elisa
```

#### Loading cFS build to CPIO
5) Move to the directory that contains the ELISA simulation `cd $ELISA_DEMO`

6) Run the load cfs script which will extract the root fs from monitors directory, copy the cFS build to the extracted root fs, and additionally load the app library files/cFS tables to the cf directory `bash /demo/cfs/scripts/load_cfs.sh`

7) If wanting to use cmdUtil tool in the QEMU environment, cmdUtil will have to be recompiled with aarch64 (makefile already patched) and loaded onto the root filesystem.

8) Run make in the cmdUtil directory
```
cd /demo/elisa_emulation/cFS/tools/cFS-GroundSystem/Subsystems/cmdUtil
make
```

7) And copy the built cmdUtil binary to the extracted rootfs `sudo cp cmdUtil /demo/elisa_emulation/extracted_cpio/usr/cfs_build/arm-linux-gnu/default_cpu1/cpu1`

### Running cFS on QEMU
1) Move to the directory that contains the ELISA simulation `cd $ELISA_DEMO`
2) Repackage extracted_cpio into compressed CPIO archive to be used as image for QEMU `sh -c 'cd extracted_cpio && sudo find . | sudo cpio -H newc -o | gzip -c > ../rootfs.cpio.gz_new'`

3) Run QEMU to emulate ARM 64-bit virtual machine ('ctrl-a x' to stop QEMU) `qemu-system-aarch64 -M virt -m 512M -cpu cortex-a57 -smp 4 -nographic -kernel /demo/monitors/Image -initrd rootfs.cpio.gz_new -append "root=/dev/ram0 console=ttyAMA0"`

4) Type in `root` for login

5) Once in QEMU, move to the following directory containing the executable:
`cd ../usr/cfs_build/arm-linux-gnu/default_cpu1/cpu1/`

6) Run cFS `./core-cpu1`

#### Sending command to sample app

7) To send a command within QEMU using cmdUtil, run cFS as a background process and redirect output to cfs.log `./core-cpu1 > cfs.log 2>&1 &`

8) To check cfs output run `tail -f cfs.log` (to get out of viewer press CTRL+C)

9) Run the following command to send a NO-OP command to Sample App `./cmdUtil --host=localhost --port=1234 --pktid=0x1882 --cmdcode=0`