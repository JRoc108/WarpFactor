#!/bin/bash
# WarpFactor Test Suite
# Copyright (c) 2025 To Tech and Back, LTD.
# Jared Churchman, Chief Engineer and sole owner
# MIT License with Churchman Rider I
# This script tests the functionality of warpfactor.sh without making actual system changes

# Path to the warpfactor script (parent directory)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WARPFACTOR_SCRIPT="${SCRIPT_DIR}/../warpfactor.sh"

# Counter for tests
TESTS_TOTAL=0
TESTS_PASSED=0
TESTS_FAILED=0

# Function to run a test
run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_exit_code="$3"
    
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    
    echo "Running test: ${test_name}"
    
    # Create a temporary file for output capturing
    local temp_output=$(mktemp)
    
    # Run the command and capture its exit code
    eval "$test_command" > "$temp_output" 2>&1
    local actual_exit_code=$?
    
    # Check if the exit code matches the expected exit code
    if [[ $actual_exit_code -eq $expected_exit_code ]]; then
        echo "✓ Test passed: ${test_name}"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo "✗ Test failed: ${test_name}"
        echo "  Expected exit code: ${expected_exit_code}, Actual: ${actual_exit_code}"
        echo "  Output:"
        cat "$temp_output" | sed 's/^/  /'
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
    
    # Cleanup
    rm "$temp_output"
    echo ""
}

# Test 1: Check if the script exists
run_test "Script exists" "test -f \"$WARPFACTOR_SCRIPT\"" 0

# Test 2: Check if the script is executable
run_test "Script is executable" "test -x \"$WARPFACTOR_SCRIPT\" || chmod +x \"$WARPFACTOR_SCRIPT\" && test -x \"$WARPFACTOR_SCRIPT\"" 0

# Test 3: Syntax check
run_test "Syntax check" "bash -n \"$WARPFACTOR_SCRIPT\"" 0

# Test 4: Test help/usage message (should exit with code 1 when no arguments provided)
run_test "Help message" "\"$WARPFACTOR_SCRIPT\"" 1

# Test 5: Test invalid argument
run_test "Invalid argument" "\"$WARPFACTOR_SCRIPT\" invalid_arg" 1

# Create mock functions for system utilities to avoid actual system changes during testing
cat > mock_functions.sh << 'EOF'
#!/bin/bash

# Mock sudo function
sudo() {
    echo "MOCK: sudo $*"
    return 0
}

# Mock sysctl function
sysctl() {
    if [[ "$1" == "-n" ]]; then
        case "$2" in
            "kern.maxproc") echo "2000" ;;
            "kern.maxprocperuid") echo "1500" ;;
            "kern.sysv.shmmax") echo "8388608" ;;
            "kern.sysv.shmall") echo "2048" ;;
            *) echo "unknown" ;;
        esac
    elif [[ "$1" == "-w" ]]; then
        echo "MOCK: sysctl $*"
    else
        echo "MOCK: sysctl $*"
    fi
    return 0
}

# Mock launchctl function
launchctl() {
    echo "MOCK: launchctl $*"
    return 0
}

# Mock caffeinate function
caffeinate() {
    echo "MOCK: caffeinate $*"
    return 0
}

# Mock ps function
ps() {
    if [[ "$*" == *"warp"* ]] || [[ "$*" == *"Warp"* ]]; then
        echo "jared            12345   0.0  0.0  5316788   3328   ??  S     9:45AM   0:00.98 /Applications/Warp.app/Contents/MacOS/Warp"
        echo "jared            12346   0.0  0.0  5316788   3328   ??  S     9:45AM   0:00.56 /Applications/Warp.app/Contents/MacOS/Helper"
    elif [[ "$*" == *"caffeinate"* ]]; then
        echo "jared            12347   0.0  0.0  5316788   3328   ??  S     9:46AM   0:00.32 caffeinate -d -i -m -s"
    elif [[ "$*" == *"chromium"* ]]; then
        echo "jared            12348   0.0  0.0  5316788   3328   ??  S     9:47AM   0:00.11 Library/Caches/ms-playwright/chromium"
    else
        echo "No matching processes found"
    fi
    return 0
}

# Mock grep function to work with ps output
grep() {
    if [[ "$2" == "grep" ]]; then
        return 0
    fi
    
    # Pass the input through if not filtering grep itself
    cat
    return 0
}

# Mock awk function to work with ps|grep pipeline
awk() {
    if [[ "$1" == '{print $2}' ]]; then
        echo "12345"
        echo "12346"
    else
        cat
    fi
    return 0
}

# Mock kill function
kill() {
    echo "MOCK: kill $*"
    return 0
}

# Mock renice function
renice() {
    echo "MOCK: renice $*"
    return 0
}

# Export all functions so they are available to subshells
export -f sudo sysctl launchctl caffeinate ps grep awk kill renice
EOF

# Test 6: Test IncreaseWarpFactor function with mocked system utilities
run_test "IncreaseWarpFactor function" "
  source mock_functions.sh
  source \"$WARPFACTOR_SCRIPT\"
  IncreaseWarpFactor
" 0

# Test 7: Test DecreaseWarpFactor function with mocked system utilities
run_test "DecreaseWarpFactor function" "
  source mock_functions.sh
  source \"$WARPFACTOR_SCRIPT\"
  DecreaseWarpFactor
" 0

# Test 8: Test increase command with mocked system utilities
run_test "Increase command" "
  source mock_functions.sh
  \"$WARPFACTOR_SCRIPT\" increase
" 0

# Test 9: Test decrease command with mocked system utilities
run_test "Decrease command" "
  source mock_functions.sh
  \"$WARPFACTOR_SCRIPT\" decrease
" 0

# Clean up mock functions file
rm -f mock_functions.sh

# Print summary
echo "===== Test Summary ====="
echo "Total tests: $TESTS_TOTAL"
echo "Passed: $TESTS_PASSED"
echo "Failed: $TESTS_FAILED"

# Exit with non-zero status if any tests failed
if [[ $TESTS_FAILED -gt 0 ]]; then
    exit 1
fi

exit 0

