#!/bin/bash

# Usage:
# . create_pinpoint_pools iam_role_arn log_group_arn

# Create pools for the shortcode and longcodes

number1=`aws pinpoint-sms-voice-v2 request-phone-number --iso-country-code CA --message-type TRANSACTIONAL --number-capabilities SMS --number-type LONG_CODE  | jq -r ".PhoneNumberId"`
aws pinpoint-sms-voice-v2 create-pool --origination-identity $number1 --iso-country-code CA --message-type TRANSACTIONAL --tags Key=Name,Value=shortcode-pool

number2=`aws pinpoint-sms-voice-v2 request-phone-number --iso-country-code CA --message-type TRANSACTIONAL --number-capabilities SMS --number-type LONG_CODE  | jq -r ".PhoneNumberId"`
aws pinpoint-sms-voice-v2 create-pool --origination-identity $number2 --iso-country-code CA --message-type TRANSACTIONAL --tags Key=Name,Value=longcode-pool

# Create configuration set

aws pinpoint-sms-voice-v2 create-configuration-set --configuration-set-name pinpoint-configuration

# need to associate the configuration sets with CloudWatch log groups and / or SNS topics

aws pinpoint-sms-voice-v2 create-event-destination --event-destination-name PinpointLogging --configuration-set-name pinpoint-configuration --matching-event-types ALL  --cloud-watch-logs-destination IamRoleArn=$1,LogGroupArn=$2
