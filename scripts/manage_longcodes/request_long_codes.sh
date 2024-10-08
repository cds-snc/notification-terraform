#!/bin/bash

# Usage:
# . request_long_codes.sh numberOfLongCodes poolId

# This script requests a number of long codes from Pinpoint SMS and assigns them to a pool

set -e

if [ -z "$1" ]; then
    echo "Usage: . request_long_codes.sh numberOfLongCodes poolId"
    exit 1
fi
if [ -z "$2" ]; then
    echo "Usage: . request_long_codes.sh numberOfLongCodes poolId"
    exit 1
fi
if [ $1 -lt 1 ]; then
    echo "Number of long codes must be greater than 0"
    exit 1
fi
if ! aws pinpoint-sms-voice-v2 describe-pools --pool-ids $2 > /dev/null; then
    echo "Pool $2 does not exist"
    exit 1
fi

numberOfLongCodes=$1
poolId=$2

printf "\n------------------------------------------------------------\n"
printf "                        WARNING!!!!\n"
printf "  This will add new phone numbers to a Pinpoint pool\n"
printf "    You might not want to run this in production!\n"
printf "\n------------------------------------------------------------\n"
read -p "If so, type 'request'> " check

if [ "$check" != "request" ]; then
    echo "Exiting..."
    exit 1
fi

for i in $(seq 1 $numberOfLongCodes); do
    number=$(aws pinpoint-sms-voice-v2 request-phone-number \
      --pool-id $poolId \
      --iso-country-code CA --message-type TRANSACTIONAL \
      --number-capabilities SMS \
      --number-type LONG_CODE \
      | jq -r ".PhoneNumberId")
    if ! aws pinpoint-sms-voice-v2 describe-phone-numbers --phone-number-ids $number > /dev/null; then
        echo "Failed to request number $number"
        continue
    else
        echo "Requested $number"
    fi
done
