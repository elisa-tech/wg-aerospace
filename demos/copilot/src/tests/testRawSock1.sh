#!/bin/sh

# License: SPDX-License-Identifier: MIT
#
# This script is used to test the the raw socket implementation of the lightServer and main_syslog programs
# It creates a FIFO named testInput, starts the lightServer and main_syslog programs, and sends a message to the lightServer
# Note: This script requires root privileges to run due to raw socket usage.

# Create a FIFO named testInput 
mkfifo testInput 

# This is so the log files available when the monitor starts
touch log_file syslog_file

# Launch the  lightServer in normal mode 
# The testInput FIFO is piped to stdin of the lightServer program. This allows the test script 
# change the behavor of the lightServer while it isrunning
tail -f testInput | python3 ../python/lightServerRawSocket.py &
echo "$!" > serverPid 

# Launch the copilot monitor program
./main_syslog_time > monitorOutput.log 2>&1 &
echo "$!" > monitorPid


# Launch the switch program to toggle the switch on and off continuously
python3 ../python/switchRawSocket.py &
echo "$!" > switchPid 

# wait for a little while to ensure that the monitor is running 
sleep 2 

# Now change the behavior of the lightServer by sending a message to it such that it takes more than
# 500ms to respond. This should cause the monitor to detect and report a violation
echo "fixed 600" > testInput
sleep 2

MONITOR_LOG_TEXT=$(cat monitorOutput.log)
EXPECTED_RESULT_ON="Monitor violation: light switch didn't turn on on time."
EXPECTED_RESULT_OFF="Monitor violation: light switch didn't turn off on time."

MONITOR_PID=$(cat monitorPid)
# Check if the server process is still running
if kill -0 "$MONITOR_PID" > /dev/null 2>&1; then
    kill -s USR1 "$MONITOR_PID"
    wait "$MONITOR_PID"
else
    # This means the test most likely passed. Capture the exit code of the monitor
    MONITOR_EXIT_CODE=$?
fi

# Clean up
SERVER_PID=$(cat serverPid)                                                                                                      
kill -s USR1 "$(cat switchPid)"                                                                                                  
wait "$(cat switchPid)"                                                                                                          
kill -s USR1 "$(cat serverPid)"                                                                                                  
sleep .5                                                                                                                         
if kill -0 "$SERVER_PID" > /dev/null 2>&1; then                                                                                  
    wait "$SERVER_PID"                                                                                                           
fi 

echo "Killed all processes"
echo "Cleaning up"
rm monitorPid
rm switchPid
rm serverPid
rm testInput

TEST_FAILED=0
TEST_PASSED=0
FAILURE_MESSAGE=""
# CHECK RESULTS
if [ "$MONITOR_LOG_TEXT" = "$EXPECTED_RESULT_ON" ] || [ "$MONITOR_LOG_TEXT" = "$EXPECTED_RESULT_OFF" ]; then
    TEST_PASSED=1
else
    FAILURE_MESSAGE="Test failed: Monitor didn't detect violation"
    TEST_FAILED=1
fi

# Define the output report file
REPORT_FILE="test-results-system.xml"

echo "    <testcase name=\"Monitor Detects Violation(Raw Socket)\" time=\"$(date +%s.%N)\">" >> "$REPORT_FILE"
if [ "$TEST_PASSED" = "0" ]; then
    echo "      <failure message=\"${FAILURE_MESSAGE}\">Test failed: Monitor didn't detect violation</failure>" >> "$REPORT_FILE"
else
    echo "      <system-out>Test passed: Monitor detected violation</system-out>" >> "$REPORT_FILE"
fi
echo "    </testcase>" >> "$REPORT_FILE"

if [ "$TEST_PASSED" = "0" ]; then
    exit 1
fi