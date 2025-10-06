#!/bin/bash

# Script to extract Terraform plan content from log files
# Usage: ./extract_terraform_plan.sh <log_file> [output_file]

# Check if log file is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <log_file> [output_file]"
    echo "  log_file: Path to the Terraform log file"
    echo "  output_file: Optional output file (defaults to stdout)"
    exit 1
fi

LOG_FILE="$1"
OUTPUT_FILE="$2"

# Check if the log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Log file '$LOG_FILE' not found."
    exit 1
fi

# Function to extract terraform plan
extract_plan() {
    local input_file="$1"
    
    # Use sed to extract content between the start and end patterns
    sed -n '/^Terraform will perform the following actions:$/,/^Plan: [0-9]* to add, [0-9]* to change, [0-9]* to destroy\.$/p' "$input_file"
}

# Extract the plan
if [ -n "$OUTPUT_FILE" ]; then
    # Output to file
    extract_plan "$LOG_FILE" > "$OUTPUT_FILE"
    echo "Terraform plan extracted to: $OUTPUT_FILE"
else
    # Output to stdout
    extract_plan "$LOG_FILE"
fi