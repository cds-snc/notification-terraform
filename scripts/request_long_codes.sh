#!/bin/bash

# Usage:
# . get_long_codes.sh numberOfLongCodes poolId

# This script requests a number of long codes from Pinpoint SMS and assigns them to a pool

set -e

if [ -z "$1" ]; then
    echo "Please provide the number of long codes to request"
    exit 1
fi
if [ $1 -lt 1 ]; then
    echo "Number of long codes must be greater than 0"
    exit 1
fi
if [ -z "$2" ]; then
    echo "Please provide the pool ID to assign the long codes to"
    exit 1
fi
if ! aws pinpoint-sms-voice-v2 describe-pools --pool-ids $2; then
    echo "Pool $2 does not exist"
    exit 1
fi
numberOfLongCodes=$1
poolId=$2

for i in $(seq 1 $numberOfLongCodes); do
    number=$(aws pinpoint-sms-voice-v2 request-phone-number \
      --iso-country-code CA --message-type TRANSACTIONAL \
      --number-capabilities SMS \
      --number-type LONG_CODE \
      | jq -r ".PhoneNumberId")

    numberStatus="PENDING"
    while [ "$numberStatus" != "\"ACTIVE\"" ]; do
        echo "Waiting for number $number to become ACTIVE..."
        sleep 1
        numberStatus=$(aws pinpoint-sms-voice-v2 describe-phone-numbers \
          --phone-number-ids $number \
          | jq '.PhoneNumbers[0].Status')
    done

    aws pinpoint-sms-voice-v2 associate-origination-identity \
      --pool-id $poolId \
      --origination-identity $number \
      --iso-country-code CA
done
