#!/bin/bash

# Script to fetch GitHub Actions IP ranges and output as JSON for Terraform external data source
# Usage: ./update_github_actions_ips.sh

# Fetch the IP ranges from GitHub's API, filter for IPv4 only, and convert to JSON string for Terraform
ip_ranges=$(curl -s https://api.github.com/meta | jq -r '.actions | map(select(contains(":") | not)) | @json' 2>/dev/null)

# Check if the command succeeded
if [ $? -ne 0 ] || [ -z "$ip_ranges" ]; then
    echo '{"error": "Failed to fetch GitHub Actions IP ranges"}' >&2
    exit 1
fi

# Output JSON with string value as required by Terraform external data source
# The @json filter already creates a properly escaped JSON string, so we pass it directly
jq -n --arg ip_ranges "$ip_ranges" '{"ip_ranges": $ip_ranges}'