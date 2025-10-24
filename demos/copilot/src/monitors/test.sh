#!/usr/bin/env bash

# License: SPDX-License-Identifier: MIT

SCRIPT_DIR=$(dirname $(realpath "$0"))

export TERM="xterm-256color"

declare -A test_results

COUNTER=0
FAILURES=0

for test_file in $SCRIPT_DIR/tests/*; do
  COUNTER=$((COUNTER + 1));

  ./main_syslog_test $test_file > /dev/null 2>/dev/null ;
  RES=$?
  if [[ ("$test_file" == *"good" && "$RES" == "0") || ("$test_file" == *"bad" && "$RES" == "1") ]] ; then
    test_results["$test_file"]="0"
  else
    test_results["$test_file"]="1"
    FAILURES=$((FAILURES + 1));
  fi ;
done

# Display the results
OUTPUT_COUNTER=0
for test_file in "${!test_results[@]}"; do
  if [[ "${test_results[$test_file]}" == "0" ]] ; then
    tput setaf 2; echo -en "Test $OUTPUT_COUNTER:  $test_file  [Passed]" ; tput sgr0; echo "" ;
  else
    tput setaf 1; echo -en "Test $OUTPUT_COUNTER:  $test_file  [Failed]" ; tput sgr0; echo "" ;
  fi ;
  OUTPUT_COUNTER=$((OUTPUT_COUNTER+ 1));
done | column -t -c0

# Define the output report file
REPORT_FILE="test_results.xml"

# Clear the report file if it exists
> "$REPORT_FILE"

# Generate JUnit XML
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"                              >> $REPORT_FILE
echo "<testsuite name=\"Copilot\" tests=\"$COUNTER\" failures=\"$FAILURES\">"  >> $REPORT_FILE

for test_file in "${!test_results[@]}"; do
  echo "  <testcase name=\"$test_file\" time=\"$(date +%s.%N)\">"              >> $REPORT_FILE
  if [[ "${test_results[$test_file]}" == "1" ]] ; then
    echo "    <failure message=\"Test failed\"></failure>"                     >> $REPORT_FILE
  fi ;
  echo "  </testcase>"                                                         >> $REPORT_FILE
done
echo "</testsuite>"                                                            >> $REPORT_FILE

mv $REPORT_FILE $SCRIPT_DIR/../../../test-results/

if [ $FAILURES -gt 0 ]; then
  exit 1;
fi
