# SPDX-License-Identifier: MIT

import subprocess
import time
import select
import sys

def isWatchedStr(str_to_watch, output):
    if str_to_watch in output:
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
    command_index = 0  # Track the current command to send
    commandReady =  False
    loginPrompt =False
    outputFile = None
    resultStart = False
    while True:
        ready, _ , _ = select.select([qemu_process.stdout], [], [], 2)  # Monitor QEMU output
        if qemu_process.stdout in ready:
            output = qemu_process.stdout.readline()
            if output == '':
                print("QEMU process has terminated.")
                sys.exit(1)

            isWatchedStr("Freeing unused kernel memory", output)
            
            if isWatchedStr("Welcome to Buildroot", output):
                loginPrompt = True


            if isWatchedStr("#", output):
                commandReady = True
            else:
                commandReady = False

            if isWatchedStr("buildroot login:", output):
                commandReady = True

            if(resultStart):
                if(outputFile is None):
                    outputFile = open("../../../test-results/test-results-system-cross.xml", "w")
                if str_to_exit_on not in output:
                    outputFile.write(output)

            if isWatchedStr("Test results directory not found. Writing results to console", output):
                resultStart = True

            if str_to_exit_on in output:
                print(output.strip())
                qemu_process.terminate()
                if outputFile:
                    outputFile.close()
                    resultStart = False                
                break

            # Print QEMU output
            print(output.strip())



            # Wait for stdin to be ready before sending commands
            if loginPrompt:                
                time.sleep(1)  # Small delay to ensure QEMU is ready
                print("Stdin is ready. Sending command...")
                try:
                    qemu_process.stdin.write("root" + '\n')
                    qemu_process.stdin.flush()
                    qemu_process.stdin.write('\n')
                    qemu_process.stdin.flush()
                    command_index += 1
                    loginPrompt = False
                except BrokenPipeError:
                    print("QEMU stdin is not ready. Retrying...")
                    time.sleep(1)  # Wait before retrying


            # Wait for stdin to be ready before sending commands
            if commandReady and command_index < len(commands):
                time.sleep(1)  # Small delay to ensure QEMU is ready
                print("Stdin is ready. Sending command...")
                try:
                    qemu_process.stdin.write(commands[command_index] + '\n')
                    qemu_process.stdin.flush()
                    command_index += 1
                except BrokenPipeError:
                    print("QEMU stdin is not ready. Retrying...")
                    time.sleep(1)  # Wait before retrying

        if time.time() - start_time > timeout:
            print("Timeout reached. ERROR: Stopping QEMU process.")
            qemu_process.terminate()
            sys.exit(1)

if __name__ == '__main__':
    str_to_exit_on = "Tests Completed Successfully."
    timeout = 300  # Timeout in seconds
    commands = [
        "cd monitors/ ",
        "ls /",
        "pwd",
        "ls",
        "cd monitors/ && ../tests/runtests.sh"        
    ]  # List of commands to send to QEMU console
    run_qemu_with_watch(str_to_exit_on, timeout, commands)
