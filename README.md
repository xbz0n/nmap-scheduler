# Nmap Scheduler Script

A single Bash script that waits until **8 PM EST**, creates a temporary targets file, and then executes an nmap scan with fast options. All output is logged both to the console and a log file, and the script automatically cleans up temporary files.

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [How It Works](#how-it-works)
- [Logging](#logging)

## Features

- **Time Scheduling:**  
  Waits until 8 PM EST regardless of the system's local timezone (e.g., if your local time is Bulgarian, it will start at 3 AM local time).
- **Dynamic Target File Creation:**  
  Automatically creates a temporary file with a predefined list of target IP networks (in CIDR format).
- **Nmap Scan Execution:**  
  Runs an nmap scan using aggressive timing (`-T5`), a fast scan of common ports (`-F`), and additional detection options (`-A`).
- **Runtime Limit:**  
  Uses the `timeout` command to ensure the scan does not run for more than 8 hours (28,800 seconds).
- **Dual Logging:**  
  Outputs all results and error messages to both the console and a log file.
- **Automatic Cleanup:**  
  Deletes temporary files once the scan completes.

## Prerequisites

- **Bash:** The script is written in Bash.
- **nmap:** Ensure [nmap](https://nmap.org/) is installed.
- **timeout:** The GNU coreutils `timeout` command must be available.
- **Permissions:** The script should have execution permissions and be allowed to write to the log file location.

## Installation

1. Clone the repository or download the script file:

   ```bash
   git clone https://github.com/xbz0n/nmap-scheduler.git
   ```

2.	Make the script executable:
 ```
cd nmap-scheduler
chmod +x nmap_scheduler.sh
```

1.	Calculate the delay until 8 PM EST.
2.	Sleep for the calculated duration.
3.	Create a temporary file with target IP ranges.
4.	Execute an nmap scan with a runtime limit of 8 hours.
5.	Log all output to both the console and the log file.
6.	Clean up temporary files after the scan completes.

## Configuration
The script uses the America/New_York timezone, so the target time of 20:00:00 is interpreted as 8 PM EST. If you need to change the scheduled time or timezone, modify these lines:

```
export TZ="America/New_York"
TARGET_TIME="20:00:00"
```

## Target Networks

The target IP networks (in CIDR format) are embedded directly in the script. To update the targets, modify the section that creates the temporary file:

```
cat <<EOF > "$TARGETS_FILE"
10.1.2.0/24
10.1.1.0/24
EOF
```

You can change the path if needed.

## How It Works
1.	The script calculates how many seconds remain until 8 PM EST. If the current time is already past 8 PM EST, it schedules the scan for 8 PM EST the following day.
2.	It then sleeps for the calculated delay.
3.	A temporary file is created that contains the list of target networks.
4.	The script launches an nmap scan with the specified options and a timeout limit of 8 hours.
5.	All output (both standard output and standard error) is captured and logged using tee, which outputs to both the console and the specified log file.
6.	Once the scan completes, the temporary targets file is deleted.

## Logging

All output from the nmap scan, including any errors, is appended to the log file specified by the LOGFILE variable. The log includes a header and footer indicating the start and end times of the scan.
