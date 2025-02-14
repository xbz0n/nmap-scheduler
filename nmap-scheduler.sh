#!/bin/bash
#
# nmap_scheduler.sh
#
# This script waits until 8 PM EST, creates a temporary targets file,
# and runs an nmap scan using fast options. The scan is limited to 8 hours.
# All output is both displayed to the console and saved to a log file.
#
# Requirements:
#   - nmap must be installed.
#   - The 'timeout' command must be available.
#
# Adjust options, paths, or targets as needed.

# Set timezone for EST
export TZ="America/New_York"
TARGET_TIME="20:00:00"

today_target=$(date -d "today $TARGET_TIME" +%s)
current_time=$(date +%s)

if [ "$current_time" -ge "$today_target" ]; then
    target_time=$(date -d "tomorrow $TARGET_TIME" +%s)
else
    target_time="$today_target"
fi

delay=$((target_time - current_time))
echo "Waiting for $delay seconds until 8 PM EST..."
sleep "$delay"

echo "Starting nmap scan at $(date)"

TARGETS_FILE=$(mktemp /tmp/nmap_targets.XXXXXX)
cat <<EOF > "$TARGETS_FILE"
10.1.2.0/24
10.1.2.0/24
EOF

LOGFILE="./nmap_segmentation_scan.log"

{
    echo "=========================================="
    echo "Nmap scan started at $(date)"
    echo "Using targets file: $TARGETS_FILE"
} | tee -a "$LOGFILE"

# The scan is limited to 8 hours (28800 seconds) using timeout.
timeout 28800 nmap -T5 -F -A -iL "$TARGETS_FILE" 2>&1 | tee -a "$LOGFILE"

# Log completion time and output to console
{
    echo "Nmap scan completed at $(date)"
    echo "=========================================="
} | tee -a "$LOGFILE"

# Remove the temporary targets file
rm "$TARGETS_FILE"

echo "Scan complete."
