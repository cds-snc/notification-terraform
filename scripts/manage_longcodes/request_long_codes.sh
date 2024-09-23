#!/bin/bash

# Usage:
# . request_long_codes.sh numberOfLongCodes poolId

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

numberOfLongCodes=$1
poolId=$2

printf "\n------------------------------------------------------------\n"
printf "                        WARNING!!!!\n"
printf "  This will add new phone numbers to a Pinpoint pool\n"
printf "    You might not want to run this in production!\n"
printf "\n------------------------------------------------------------\n"
printf "Are you sure you want to continue?\n"
echo -n "If so, type 'request'> "
read -r check

if [ "$check" != "request" ]; then
    echo "Exiting..."
    exit 1
fi

# if ! aws pinpoint-sms-voice-v2 describe-pools --pool-ids $poolId > /dev/null 2>&1; then
#     echo "Pool $poolId does not exist"
#     exit 1
# fi

for i in $(seq 1 $numberOfLongCodes); do
    number=$(aws pinpoint-sms-voice-v2 request-phone-number \
      --pool-id $poolId \
      --iso-country-code CA --message-type TRANSACTIONAL \
      --number-capabilities SMS \
      --number-type LONG_CODE \
      | jq -r ".PhoneNumberId")
    echo "Requested $number"
done
