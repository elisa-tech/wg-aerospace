#!/usr/bin/env bash

# Initialize counters
TOTAL_TESTS=0
FAILED_TESTS=0

# Define the output report file
REPORT_FILE="../../../test-results/test-results-system.xml"

# Clear the report file if it exists
> "$REPORT_FILE"

# Start the JUnit XML structure
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" >> "$REPORT_FILE"
echo "<testsuites>" >> "$REPORT_FILE"
# Placeholder for test summary
echo "  <testsuite name=\"Light System Test\" tests=\"0\" failures=\"0\" errors=\"0\">" >> "$REPORT_FILE"

# Run all shell scripts in the current folder that start with "test"
for test_script in ../tests/test*.sh; do
    if [[ -x "$test_script" ]]; then
        TOTAL_TESTS=$((TOTAL_TESTS + 1))
        echo "Running $test_script..."
        "$test_script"
        if [[ $? -ne 0 ]]; then
            FAILED_TESTS=$((FAILED_TESTS + 1))
            echo "Test $test_script failed."
        else
            echo "Test $test_script passed."
        fi
    else
        echo "Skipping $test_script (not executable)."
    fi
done

# Update the test summary with actual values
sed -i "s/tests=\"0\"/tests=\"$TOTAL_TESTS\"/" "$REPORT_FILE"
sed -i "s/failures=\"0\"/failures=\"$FAILED_TESTS\"/" "$REPORT_FILE"

# Close the test suite
echo "  </testsuite>" >> "$REPORT_FILE"
echo "</testsuites>" >> "$REPORT_FILE"

# Notify the user
echo "JUnit Report generated: $REPORT_FILE"