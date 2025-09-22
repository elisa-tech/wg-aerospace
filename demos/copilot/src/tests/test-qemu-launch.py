import subprocess
import time
import select
import sys

def isWatchedStr(str_to_watch, output):
    if str_to_watch in output:
        print(f"   >>>>>>>> Found the string: [{str_to_watch}] <<<<<<<<")
        return True
    return False

def run_qemu_with_watch(str_to_exit_on, timeout, commands):
    qemu_command = [
        'qemu-system-aarch64',
        '-M', 'virt',
        '-m', '512M',
        '-cpu', 'cortex-a57',
        '-smp', '4',
        '-nographic',
        '-kernel', 'Image',
        '-append', 'root=/dev/ram0 init=/bin/dash console=ttyAMA0 loglevel=7',
        '-initrd', 'rootfs.cpio.gz_new'
    ]
    qemu_process = subprocess.Popen(
        qemu_command, 
        stdin=subprocess.PIPE, 
        stdout=subprocess.PIPE, 
        stderr=subprocess.STDOUT, 
        universal_newlines=True
    )

    start_time = time.time()
    while True:
        ready, _ , _ = select.select([qemu_process.stdout], [], [], 2)  # Monitor QEMU output
        if qemu_process.stdout in ready:
            output = qemu_process.stdout.readline()
            if output == '':
                print("QEMU process has terminated.")
                sys.exit(1)

            isWatchedStr("Freeing unused kernel memory", output)
            print(output.strip())

            if str_to_exit_on in output:
                print(f"   >>>>>>>> Found the string: [{str_to_exit_on}] <<<<<<<<   SUCCESSFUL sequence of output checking")
                qemu_process.terminate()
                sys.exit(0)

        if time.time() - start_time > timeout:
            print("Timeout reached. ERROR: Stopping QEMU process.")
            qemu_process.terminate()
            sys.exit(1)

if __name__ == '__main__':
    str_to_exit_on = "Welcome to Buildroot"
    timeout = 30  # Timeout in seconds
    commands = ""  # List of commands to send to QEMU console
    run_qemu_with_watch(str_to_exit_on, timeout, commands)