#!/bin/bash

# Usage:
# . create_pinpoint_pools.sh iam_role_arn log_group_deliveries_arn log_group_failures_arn

# This script creates a shortcode and longcode pool in Pinpoint SMS Voice as well as a configuration set with two event destinations
# The event destinations are used to log all events and failures to CloudWatch Logs
# The script takes three arguments:
# 1. The IAM role ARN that will be used to write to the CloudWatch Logs
# 2. The log group ARN for the Pinpoint deliveries
# 3. The log group ARN for the Pinpoint failures
#
# If the resources already exist, the script will not create them again

if [ -z "$1" ]; then
    echo "Please provide the IAM role ARN"
    exit 1
fi
if [ -z "$2" ]; then
    echo "Please provide the log group ARN for Pinpoint deliveries"
    exit 1
fi
if [ -z "$3" ]; then
    echo "Please provide the log group ARN for Pinpoint failures"
    exit 1
fi
iamRoleArn=$1
logGroupArnDeliveries=$2
logGroupArnFailures=$3

# Create pools for the shortcode and longcodes

poolArns=$(aws pinpoint-sms-voice-v2 describe-pools --output json | jq -r '.Pools.[].PoolArn')
shortcodePoolExists=false
longcodePoolExists=false
for poolArn in $poolArns; do
    isShort=$(aws pinpoint-sms-voice-v2 list-tags-for-resource --resource-arn $poolArn | jq -r '.Tags[].Value' | grep "shortcode-pool" | wc -l)
    isLong=$(aws pinpoint-sms-voice-v2 list-tags-for-resource --resource-arn $poolArn | jq -r '.Tags[].Value' | grep 'longcode-pool' | wc -l)
    if [ $isShort == 1 ]; then
        shortcodePoolExists=true
    fi
    if [ $isLong == 1 ]; then
        longcodePoolExists=true
    fi
done

if [ $shortcodePoolExists == true ]; then
    echo "Shortcode pool already exists"
else
    echo "Creating shortcode pool"
    number1=$(aws pinpoint-sms-voice-v2 request-phone-number --iso-country-code CA --message-type TRANSACTIONAL --number-capabilities SMS --number-type LONG_CODE | jq -r ".PhoneNumberId")
    aws pinpoint-sms-voice-v2 create-pool --origination-identity $number1 --iso-country-code CA --message-type TRANSACTIONAL --tags Key=Name,Value=shortcode-pool
fi
if [ $longcodePoolExists == true ]; then
    echo "Longcode pool already exists"
else
    echo "Creating longcode pool"
    number2=$(aws pinpoint-sms-voice-v2 request-phone-number --iso-country-code CA --message-type TRANSACTIONAL --number-capabilities SMS --number-type LONG_CODE  | jq -r ".PhoneNumberId")
    aws pinpoint-sms-voice-v2 create-pool --origination-identity $number2 --iso-country-code CA --message-type TRANSACTIONAL --tags Key=Name,Value=longcode-pool
fi

# # Create a configuration set and assign destinations
# # For event types see https://docs.aws.amazon.com/sms-voice/latest/userguide/configuration-sets-event-types.html

configurationSetExists=$(aws pinpoint-sms-voice-v2 describe-configuration-sets | jq '.ConfigurationSets[].ConfigurationSetName'| grep 'pinpoint-configuration')

if [ $configurationSetExists ]; then
    echo "Configuration set already exists"
else
    echo "Creating configuration set"
    aws pinpoint-sms-voice-v2 create-configuration-set --configuration-set-name pinpoint-configuration
    aws pinpoint-sms-voice-v2 create-event-destination \
        --event-destination-name PinpointLoggingAll \
        --configuration-set-name pinpoint-configuration \
        --matching-event-types ALL \
        --cloud-watch-logs-destination IamRoleArn=$iamRoleArn,LogGroupArn=$logGroupArnDeliveries
    aws pinpoint-sms-voice-v2 create-event-destination \
        --event-destination-name PinpointLoggingFailures \
        --configuration-set-name pinpoint-configuration \
        --matching-event-types '["TEXT_BLOCKED","TEXT_TTL_EXPIRED","TEXT_CARRIER_UNREACHABLE","TEXT_INVALID","TEXT_INVALID_MESSAGE","TEXT_CARRIER_BLOCKED","TEXT_CARRIER_BLOCKED","TEXT_SPAM","TEXT_UNKNOWN"]' \
        --cloud-watch-logs-destination IamRoleArn=$iamRoleArn,LogGroupArn=$logGroupArnFailures
fi
