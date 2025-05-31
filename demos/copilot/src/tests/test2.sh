#!/usr/bin/env bash

# License: SPDX-License-Identifier: MIT

# This script is used to test the lightServer and main_syslog programs
# It creates a FIFO named testInput, starts the lightServer and main_syslog programs, and sends a message to the lightServer
# Usage: ./test1.sh

# Create a FIFO named testInput 
mkfifo testInput 

# This is so the log files available when the monitor starts
touch log_file syslog_file

# Launch the  lightServer in normal mode 
# The testInput FIFO is piped to stdin of the lightServer program. This allows the test script 
# change the behavor of the lightServer while it isrunning
tail -f testInput | python3 ../python/lightServer.py &
echo "$!" > serverPid 

# Launch the copilot monitor program
./main_syslog_time > monitorOutput.log 2>&1 &
echo "$!" > monitorPid


# Launch the switch program to toggle the switch on and off continuously
python3 ../python/switch.py &
echo "$!" > switchPid 

# wait for a little while to ensure that the monitor is running 
sleep 2 

# Now change the behavior of the lightServer by sending a message to it such that it takes less than
# 500ms to respond. The monitor should not detect any violation
echo "fixed 400" > testInput
sleep 2

MONITOR_PID=$(cat monitorPid)
TEST_FAILED=0
TEST_PASSED=0
FAILURE_MESSAGE=""

# Check if the server process is still running
if kill -0 "$MONITOR_PID" > /dev/null 2>&1; then
    # This means the monitor did not detect a violation and is still running.
    kill -SIGUSR1 "$MONITOR_PID" 
    wait "$MONITOR_PID"
    TEST_PASSED=1
else
    # This means the test failed. Monitor should not have detected a violation
    TEST_FAILED=1
    FAILURE_MESSAGE="Monitor exited unexpectedly. It should not have detected a violation."
fi

# Clean up
kill -SIGUSR1 "$(cat switchPid)" 
wait "$(cat switchPid)"
kill -SIGUSR1 "$(cat serverPid)"
wait "$(cat serverPid)"

echo "Killed all processes"
echo "Cleaning up"
rm monitorPid
rm switchPid
rm serverPid
rm testInput

# Define the output report file
REPORT_FILE="../../../test-results/test-results-system.xml"

# First test case
echo "    <testcase name=\"Monitor Does not detect violation\" time=\"$(date +%s.%N)\">" >> "$REPORT_FILE"
if [[ "${TEST_PASSED}" == "0" ]] ; then
    echo "      <failure message=\"${FAILURE_MESSAGE}\">Test failed: Monitor did not exit as expected</failure>" >> "$REPORT_FILE"
else
    echo "      <system-out>Test passed: Monitor did not detect violation.</system-out>" >> "$REPORT_FILE"
fi ;
echo "    </testcase>" >> "$REPORT_FILE"


if [[ "$TEST_PASSED" == "0" ]]; then
  exit 1;
fi
