#!/bin/bash

# SPDX-License-Identifier: MIT

# Define the output report file
REPORT_FILE="test-results-example.xml"

# Clear the report file if it exists
> "$REPORT_FILE"

## Complete junit example -  https://github.com/testmoapp/junitxml?tab=readme-ov-file#complete-junit-xml-example

## Note the time values below should be duration of test, not how they are set with date to be time now.

# Start the JUnit XML structure
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" >> "$REPORT_FILE"
echo "<testsuites>" >> "$REPORT_FILE"
echo "  <testsuite name=\"CoPilot Test Suite\" tests=\"2\" failures=\"0\" errors=\"0\">" >> "$REPORT_FILE"

# First test case
echo "    <testcase name=\"Server Test Fails\" time=\"$(date +%s.%N)\">" >> "$REPORT_FILE"
echo "      <failure message=\"Error running the Python script\">Foobar</failure>" >> "$REPORT_FILE"
echo "    </testcase>" >> "$REPORT_FILE"

# Second test case
echo "    <testcase name=\"Server Test Pass\" time=\"$(date +%s.%N)\">" >> "$REPORT_FILE"
echo "    </testcase>" >> "$REPORT_FILE"

# Close the test suite
echo "  </testsuite>" >> "$REPORT_FILE"
echo "</testsuites>" >> "$REPORT_FILE"

# Notify the user
echo "JUnit Report generated: $REPORT_FILE"
