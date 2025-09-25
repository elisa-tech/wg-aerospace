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

### Clone cFS directory and apply patches prior to building

1) Enter directory where cFS will be cloned `cd $ELISA_DEMO`
2) Clone cFS from github and update submodules: 
   ```
    git clone https://github.com/nasa/cFS.git
    cd cFS
    git submodule init
    git submodule update
   ```

#### Copy templates and apply necessary patches prior to building cFS
1) Copy template sample defs and makefile from cfe directory to cFS main directory
   ```
   cp -r cfe/cmake/sample_defs .
   cp cfe/cmake/Makefile.sample Makefile
   ```
2) Run prebuild patch for cFS build `bash /demo/apply_cfs_prebuild_patch.sh`

### Building cFS and loading to CPIO

1) Run the following commands to build cFS
```
make SIMULATION=arm-linux-gnu O=build-elisa prep
make SIMULATION=arm-linux-gnu O=build-elisa
```

#### Loading cFS build to CPIO
2) Move to the directory that contains the ELISA simulation `cd $ELISA_DEMO`

3) Run the post build script which will extract the root fs, copy the cFS build to the root fs, and load the app library files/cFS tables `bash /demo/post_cfs_build.sh`

4) If wanting to use cmdUtil tool in the QEMU environment, cmdUtil will have to be recompiled with aarch64 and loaded onto the root filesystem. Execute the following script to do this `bash /demo/build_cmdUtil.sh`

### Running cFS on QEMU
1) Repackage extracted_cpio into compressed CPIO archive to be used as image for QEMU `sh -c 'cd extracted_cpio && sudo find . | sudo cpio -H newc -o | gzip -c > ../rootfs.cpio.gz_new'`

2) Run QEMU to emulate ARM 64-bit virtual machine ('ctrl-a x' to stop QEMU) `qemu-system-aarch64 -M virt -m 512M -cpu cortex-a57 -smp 4 -nographic -kernel Image -initrd rootfs.cpio.gz_new -append "root=/dev/ram0 console=ttyAMA0"`

3) Once in QEMU, move to the following directory containing the executable:
cd ../usr/cfs_build/arm-linux-gnu/default_cpu1/cpu1/

4) Run cFS `./core-cpu1`

#### Sending command to sample app

5) To send a command within QEMU using cmdUtil, run cFS as a background process and redirect output to cfs.log `./core-cpu1 > cfs.log 2>&1 &`

6) To check cfs output run `tail -f cfs.log` (to get out of viewer press CTRL+C)

7) Run the following command to send a NO-OP command to Sample App `./cmdUtil --host=localhost --port=1234 --pktid=0x1882 --cmdcode=0`