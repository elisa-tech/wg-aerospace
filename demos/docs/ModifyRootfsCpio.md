<!--
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# ELISA Root Filesystem CPIO Modification

## Steps to add a new application to an existing filesystem rootfs.cpio (using a simple 'helloworld' sample application)

1. Create a working directory from which to build sample application:

   ```text
   mkdir ELISA_Archive
   cd ELISA_Archive
   ```

2. Download the CCS Images/SDK from Gitlab CCS artifacts:

   ```text
   wget "https://gitlab.com/api/v4/projects/61362364/packages/generic/minimal-linux-debug/1.0.0/archive.tar" -O archive.tar
   ```

3. Untar the archive file:

   ```text
   tar -xf archive.tar
   ```

4. Extract the SDK:

   ```text
   tar -zxf aarch64-buildroot-linux-musl_sdk-buildroot.tar.gz
   ```

5. Relocate the SDK:

   ```text
   ./aarch64-buildroot-linux-musl_sdk-buildroot/relocate-sdk.sh
   ```

6. Setup/Export SDK environment variables (eases compilation task)

   ```bash
   source aarch64-buildroot-linux-musl_sdk-buildroot/environment-setup
   ```

7. Create sample 'helloworld' source code:

   ```bash
   cat << EOF > helloworld.c
   # include <stdio.h>
   # include <unistd.h>
   
   int main() {
      while(1) {
         printf("Hello, World!\n");
         sleep(2);
      }
      return 0;
   }
   EOF
   ```

8. Compile the sample program

   This example supplies path to includes and libraries (using SDK environment variables from 'environment-setup' script),  
   as well as 'static' linking so we don't have to worry about copying shared libraries (modify as necessary):

   ```text
   $CC -static $CFLAGS_FOR_BUILD $LDFLAGS_FOR_BUILD helloworld.c -o helloworld
   ```

9. Extract the current CPIO rootfs:

    NOTE: some of these remaining commands will need to be as root to properly
    process the device nodes from cpio archive extraction/creation:

    ```text
    mkdir extracted_cpio
    sudo cpio -i -R +0:+0 -n -F rootfs.cpio --make-directories --preserve-modification-time --no-absolute-filenames --directory=./extracted_cpio
    ```

10. Change into the 'extracted_cpio' directory and make filesystem modifications, add applications/libraries, etc...:

    ```text
    cd extracted_cpio
    ```

    This example will install the 'helloworld' application and setup as 'ainit' application
    Eg: cp \<path to previously generated SDK 'helloworld' application\> ./bin

    ```text
    sudo cp ../helloworld ./bin/
    ```

    Modify the DAC permissions for the sample 'helloworld' application (if not correct):

    ```text
    sudo chmod 0755 ./bin/helloworld
    ```

11. Following this example, still in our 'extracted_cpio', create the new modified 'rootfs.cpio.gz':

    ```text
    sudo find . | sudo cpio -H newc -o | gzip -c > ../rootfs.cpio.gz_new
    ```

12. Change back to the top-level directory from extracted_cpio directory (where the kernel 'Image' file and 'rootfs.cpio.gz_new' reside):

    ```text
    cd ..
    ```

13. Examples of running QEMU with the new 'rootfs.cpio.gz_new' (the '-append ..." kernel parameters could be adjusted as needed):

    _**Note: To exit QEMU use 'Ctrl+a x' key sequence**_

    This example runs QEMU with our 'helloworld' as our init process (the '-append ..." kernel parameters could be adjusted as needed):

    ```text
    qemu-system-aarch64 -M virt -cpu cortex-a53 -m 512 -smp 4 -nographic -kernel Image -initrd rootfs.cpio.gz_new -append 'root=/dev/ram0 rdinit=/bin/helloworld console=ttyAMA0 printk.time=y initcall_debug debug ignore_loglevel' -netdev user,id=eth0 -device virtio-net-device,netdev=eth0 -chardev socket,id=ttyAMA0,host=localhost,port=45450,server,nowait -device pci-serial,chardev=ttyAMA0
    
    ...
    [    0.285604] calling  0xffff80008027c844 @ 1
    [    0.285640] initcall 0xffff80008027c844 returned 0 after 27 usecs
    [    0.309641] Freeing unused kernel memory: 448K
    [    0.318491] Run /bin/helloworld as init process
    [    0.318553]   with arguments:
    [    0.318567]     /bin/helloworld
    [    0.318582]   with environment:
    [    0.318602]     HOME=/
    [    0.318612]     TERM=linux
    Hello, World!
    Hello, World!
    Hello, World!
    ```

    This exmaple runs QEMU and drops to a shell prompt where the 'helloworld' application can be ran (again the '-append ..." kernel parameters could be adjusted as needed):

    ```text
    qemu-system-aarch64 -M virt -cpu cortex-a53 -m 512 -smp 4 -nographic -kernel Image -initrd rootfs.cpio.gz_new -append 'root=/dev/ram0 console=ttyAMA0 printk.time=y initcall_debug debug ignore_loglevel' -netdev user,id=eth0 -device virtio-net-device,netdev=eth0 -chardev socket,id=ttyAMA0,host=localhost,port=45450,server,nowait -device pci-serial,chardev=ttyAMA0
    
    ...
    [    1.820463] Run /init as init process
    [    1.820591]   with arguments:
    [    1.820681]     /init
    [    1.820749]   with environment:
    [    1.820786]     HOME=/
    [    1.820811]     TERM=linux
    Starting syslogd: OK
    Starting klogd: OK
    Running sysctl: OK
    Starting network: OK
    Starting crond: OK

    Welcome to Buildroot
    buildroot login: root
    # /bin/helloworld 
    Hello, World!
    Hello, World!
    Hello, World!
    ```
