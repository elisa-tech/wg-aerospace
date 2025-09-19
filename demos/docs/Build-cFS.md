# Building cFS

## Overview

The following instructions assume that you've completed the [Development Setup](./Development.md).


### Setup for cloning of cFS bundle

1) Navigate to your clone of this project and [cd demos/copilot/src/monitors/](../copilot/src/monitors/).
2) Execute the following to get a `development environment shell` within our container.

   ```bash
   make dev
   ```
3) At this point you're in the docker container with all the tools to do testing and rebuild of the demos.
4) Install required packages inside the container `sudo apt update && sudo apt install -y  vim git file wget make cmake` 
5) If you wish to have the cFS build to persist on the docker container, cd to `/demo/` and set the variable `ELISA_DEMO=$(pwd)/elisa_emulation`
6) Make the directory where cFS will be cloned into `mkdir -p $ELISA_DEMO && cd $ELISA_DEMO`

#### Setup the minimal kernel and toolchain for cross-compiling

1) Download minimal linux debug archive `[ ! -e "archive.tar" ] && wget "https://gitlab.com/api/v4/projects/61362364/packages/generic/minimal-linux-debug/1.0.0/archive.tar" -O archive.tar`
2) Extract contents of archive `tar xf archive.tar`
3) Extract the SDK tarball inside the archive `tar xf aarch64-buildroot-linux-musl_sdk-buildroot.tar.gz`
4) Enter the SDK directory `cd aarch64-buildroot-linux-musl_sdk-buildroot`
5) Now run script to relocate SDK paths (only needed once unless folder is moved) `./relocate-sdk.sh`  
> Do **not** run `. environment-setup` as it breaks the CFS build process.

### Clone cFS directory and apply patches prior to building

1) Enter directory where cFS will be cloned `cd $ELISA_DEMO`
2) Clone cFS from github and update submodules: 
   ```
    git clone https://github.com/nasa/cFS.git
    cd cFS
    git submodule init
    git submodule update
   ```

#### Apply necessary patches prior to building cFS
1. Copy template sample defs and makefile from cfe directory to cFS main directory
   ```
   cp -r cfe/cmake/sample_defs .
   cp cfe/cmake/Makefile.sample Makefile
   ```

Work in progress:

cp sample_defs/toolchain-arm-cortexa8_neon-linux-gnueabi.cmake sample_defs/toolchain-arm-linux-gnu.cmake -a

vi sample_defs/toolchain-arm-linux-gnu.cmake

SET(CMAKE_C_COMPILER                    "/demo/elisa_emulation/aarch64-buildroot-linux-musl_sdk-buildroot/bin/aarch64-linux-gcc")
SET(CMAKE_CXX_COMPILER                  "/demo/elisa_emulation/aarch64-buildroot-linux-musl_sdk-buildroot/bin/aarch64-linux-g++")


SET(CMAKE_FIND_ROOT_PATH                "/demo/elisa_emulation/aarch64-buildroot-linux-musl_sdk-buildroot/aarch64-buildroot-linux-musl/sysroot")

vi sample_defs/targets.cmake

SET(cpu1_SYSTEM arm-linux-gnu)

cd osal/src/os/posix/inc/

vi os-posix.h

remove line #include <sys/signal.h>

cd /demo/elisa_emulation/cFS/psp

vi CMakeLists.txt

add execinfo in target_link_libraries

make SIMULATION=arm-linux-gnu O=build-elisa prep

make SIMULATION=arm-linux-gnu O=build-elisa

cd $ELISA_DEMO

mkdir -p extracted_cpio && sudo gunzip -c rootfs.cpio.gz > rootfs.cpio_uncompressed

sudo cpio -i -R +0:+0 -n -F rootfs.cpio_uncompressed --make-directories --preserve-modification-time --no-absolute-filenames --directory=./extracted_cpio

sudo cp -r cFS/build-elisa/ extracted_cpio/usr/

sudo mv extracted_cpio/usr/build-elisa/ extracted_cpio/usr/cfs_build

sudo mkdir extracted_cpio/usr/cfs_build/arm-linux-gnu/default_cpu1/cpu1/cf

sudo cp cFS/sample_defs/cpu1_cfe_es_startup.scr extracted_cpio/usr/cfs_build/arm-linux-gnu/default_cpu1/cpu1/cf

sudo mv extracted_cpio/usr/cfs_build/arm-linux-gnu/default_cpu1/cpu1/cf/cpu1_cfe_es_startup.scr extracted_cpio/usr/cfs_build/arm-linux-gnu/default_cpu1/cpu1/cf/cfe_es_startup.scr

sudo cp cFS/build-elisa/arm-linux-gnu/default_cpu1/apps/cfe_assert/cfe_assert.so extracted_cpio/usr/cfs_build/arm-linux-gnu/default_cpu1/cpu1/cf

sudo cp cFS/build-elisa/arm-linux-gnu/default_cpu1/apps/ci_lab/ci_lab.so extrac
ted_cpio/usr/cfs_build/arm-linux-gnu/default_cpu1/cpu1/cf

sudo cp cFS/build-elisa/arm-linux-gnu/default_cpu1/apps/to_lab/to_lab.so extrac
ted_cpio/usr/cfs_build/arm-linux-gnu/default_cpu1/cpu1/cf

sudo cp cFS/build-elisa/arm-linux-gnu/default_cpu1/apps/sample_app/sample_app.so extracted_cpio/usr/cfs_build/arm-linux-gnu/default_cpu1/cpu1/cf

sudo cp cFS/build-elisa/arm-linux-gnu/default_cpu1/apps/sample_lib/sample_lib.so extracted_cpio/usr/cfs_build/arm-linux-gnu/default_cpu1/cpu1/cf

sudo cp cFS/build-elisa/arm-linux-gnu/default_cpu1/apps/sch_lab/sch_lab.so extr
acted_cpio/usr/cfs_build/arm-linux-gnu/default_cpu1/cpu1/cf

sudo cp cFS/build-elisa/tables/staging/cpu1/cf/to_lab_sub.tbl extracted_cpio/us
r/cfs_build/arm-linux-gnu/default_cpu1/cpu1/cf

sudo cp cFS/build-elisa/tables/staging/cpu1/cf/sample_app_tbl.tbl extracted_cpi
o/usr/cfs_build/arm-linux-gnu/default_cpu1/cpu1/cf

sudo cp cFS/build-elisa/tables/staging/cpu1/cf/sch_lab_table.tbl extracted_cpio
/usr/cfs_build/arm-linux-gnu/default_cpu1/cpu1/cf

cd cFS/tools/cFS-GroundSystem/Subsystems/cmdUtil/

vi Makefile

Set the full path to your cross-compiler
CROSS_COMPILER := /demo/elisa_emulation/aarch64-buildroot-linux-musl_sdk-buildroot/bin/aarch64-linux-gcc

all:
        $(CROSS_COMPILER) -o cmdUtil SendUdp.c cmdUtil.c

debug:
        $(CROSS_COMPILER) -o cmdUtil -DDEBUG -g SendUdp.c cmdUtil.c

thirtytwo:
        $(CROSS_COMPILER) -o cmdUtil -DDEBUG -g -m32 SendUdp.c cmdUtil.c

make

cd $ELISA_DEMO/

sudo cp cFS/tools/cFS-GroundSystem/Subsystems/cmdUtil/cmdUtil extracted_cpio/us
r/cfs_build/arm-linux-gnu/default_cpu1/cpu1

sh -c 'cd extracted_cpio && sudo find . | sudo cpio -H newc -o | gzip -c > ../rootfs.cpio.gz_new'

qemu-system-aarch64 -M virt -m 512M -cpu cortex-a57 -smp 4 -nographic -kernel Image -initrd rootfs.cpio.gz_new -append "root=/dev/ram0 console=ttyAMA0"    # 'ctrl-a x' to stop QEMU

cd ../usr/cfs_build/arm-linux-gnu/default_cpu1/cpu1/

./core-cpu1 > cfs.log 2>&1 &

tail -f cfs.log

ps aux | grep core-cpu1

./cmdUtil --host=localhost --port=1234 --pktid=0x1882 --cmdcode=0