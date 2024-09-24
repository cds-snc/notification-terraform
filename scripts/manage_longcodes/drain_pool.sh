#!/bin/bash

# Usage:
# . drain_pool.sh <pool_id>

# This script will remove and release all but one number from a Pinpoint pool

set -e

if [ -z "$1" ]; then
    echo "Usage: . drain_pool.sh <pool_id>"
    exit 1
fi
if ! aws pinpoint-sms-voice-v2 describe-pools --pool-ids $1 > /dev/null; then
    echo "Pool $1 does not exist"
    exit 1
fi

printf "\n------------------------------------------------------------\n"
printf "                         WARNING!!!!\n"
printf "  This will delete all but one long code from a Pinpoint pool!\n"
printf "         You do not want to run this or production!\n"
printf "\n------------------------------------------------------------\n"
printf "Are you sure you want to continue?\n"
read -p "If so, type 'drain'> " check

if [ "$check" != "drain" ]; then
    echo "Exiting..."
    exit 1
fi

numbers=$(aws pinpoint-sms-voice-v2 list-pool-origination-identities --pool-id $1 | jq -r ".OriginationIdentities[].OriginationIdentity")
read -ra numbersArray <<< $numbers # Split the string into an array

echo "Found ${#numbersArray[@]} numbers in pool $1. Releasing all but one."
for number in ${numbersArray[@]:1}; do # Skip the first number - have to keep at least one number in the pool
    echo "Releasing $number..."
    aws pinpoint-sms-voice-v2 disassociate-origination-identity --iso-country-code CA --pool-id $1 --origination-identity $number > /dev/null
    aws pinpoint-sms-voice-v2 release-phone-number --phone-number-id $number > /dev/null
done
