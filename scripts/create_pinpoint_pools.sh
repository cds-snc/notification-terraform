#!/bin/bash

# Usage:
# . create_pinpoint_pools.sh iam_role_arn log_group_deliveries_arn

# Create pools for the shortcode and longcodes

# number1=`aws pinpoint-sms-voice-v2 request-phone-number --iso-country-code CA --message-type TRANSACTIONAL --number-capabilities SMS --number-type LONG_CODE  | jq -r ".PhoneNumberId"`
# aws pinpoint-sms-voice-v2 create-pool --origination-identity $number1 --iso-country-code CA --message-type TRANSACTIONAL --tags Key=Name,Value=shortcode-pool

# number2=`aws pinpoint-sms-voice-v2 request-phone-number --iso-country-code CA --message-type TRANSACTIONAL --number-capabilities SMS --number-type LONG_CODE  | jq -r ".PhoneNumberId"`
# aws pinpoint-sms-voice-v2 create-pool --origination-identity $number2 --iso-country-code CA --message-type TRANSACTIONAL --tags Key=Name,Value=longcode-pool

# Create configuration sets and assign destinations
# For event types see https://docs.aws.amazon.com/sms-voice/latest/userguide/configuration-sets-event-types.html

aws pinpoint-sms-voice-v2 create-configuration-set --configuration-set-name pinpoint-configuration

aws pinpoint-sms-voice-v2 create-event-destination \
    --event-destination-name PinpointLoggingAll \
    --configuration-set-name pinpoint-configuration \
    --matching-event-types ALL \
    --cloud-watch-logs-destination IamRoleArn=$1,LogGroupArn=$2

aws pinpoint-sms-voice-v2 create-event-destination \
    --event-destination-name PinpointLoggingFailures \
    --configuration-set-name pinpoint-configuration \
    --matching-event-types '["TEXT_BLOCKED","TEXT_TTL_EXPIRED","TEXT_CARRIER_UNREACHABLE","TEXT_INVALID","TEXT_INVALID_MESSAGE","TEXT_CARRIER_BLOCKED","TEXT_CARRIER_BLOCKED","TEXT_SPAM","TEXT_UNKNOWN"]' \
    --cloud-watch-logs-destination IamRoleArn=$1,LogGroupArn=$3
