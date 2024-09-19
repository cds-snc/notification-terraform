#!/bin/bash

# Usage:
# . drain_pool.sh <pool_id>

# This script will remove and release all but one number from a Pinpoint pool

if [ -z "$1" ]; then
    echo "Usage: . drain_pool.sh <pool_id>"
    return
fi

if aws pinpoint-sms-voice-v2 describe-pools --pool-ids $1; then    
    numbers=$(aws pinpoint-sms-voice-v2 list-pool-origination-identities --pool-id $1 | jq -r ".OriginationIdentities[].OriginationIdentity")
    read -ra numbersArray <<< $numbers # Split the string into an array
    
    echo "Found ${#numbersArray[@]} numbers in pool $1. Releasing all but one."
    for number in ${numbersArray[@]:1}; do # Skip the first number - have to keep at least one number in the pool
        echo "Releasing $number..."
        aws pinpoint-sms-voice-v2 disassociate-origination-identity --iso-country-code CA --pool-id $1 --origination-identity $number
        aws pinpoint-sms-voice-v2 release-phone-number --phone-number-id $number
    done
else
    echo "Pool $1 does not exist"
fi
