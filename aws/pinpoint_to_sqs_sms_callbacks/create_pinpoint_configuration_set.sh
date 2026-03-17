#!/bin/bash

# Usage:
# . create_pinpoint_configuration_set.sh region iam_role_arn log_group_deliveries_arn log_group_failures_arn

# This script creates a configuration set with two event destinations
# The event destinations are used to log all events and failures to CloudWatch Logs
# The script takes four arguments:
# 1. The AWS region to use
# 2. The IAM role ARN that will be used to write to the CloudWatch Logs
# 3. The log group ARN for the Pinpoint deliveries
# 4. The log group ARN for the Pinpoint failures
#
# If the resources already exist, the script will not create them again

if [ -z "$1" ]; then
    echo "Please provide the AWS region"
    exit 1
fi
if [ -z "$2" ]; then
    echo "Please provide the IAM role ARN"
    exit 1
fi
if [ -z "$3" ]; then
    echo "Please provide the log group ARN for Pinpoint deliveries"
    exit 1
fi
if [ -z "$4" ]; then
    echo "Please provide the log group ARN for Pinpoint failures"
    exit 1
fi
region=$1
iamRoleArn=$2
logGroupArnDeliveries=$3
logGroupArnFailures=$4


# # Create a configuration set and assign destinations
# # For event types see https://docs.aws.amazon.com/sms-voice/latest/userguide/configuration-sets-event-types.html

configurationSetExists=$(aws pinpoint-sms-voice-v2 describe-configuration-sets --region "$region" | jq '.ConfigurationSets[].ConfigurationSetName'| grep 'pinpoint-configuration')

if [ $configurationSetExists ]; then
    echo "Configuration set already exists"
else
    echo "Creating configuration set"
    aws pinpoint-sms-voice-v2 create-configuration-set --region "$region" --configuration-set-name pinpoint-configuration
    echo "Creating event destinations"
    echo "Creating happy path destnation"
    aws pinpoint-sms-voice-v2 create-event-destination \
        --region "$region" \
        --event-destination-name PinpointLoggingAll \
        --configuration-set-name pinpoint-configuration \
        --matching-event-types ALL \
        --cloud-watch-logs-destination IamRoleArn=$iamRoleArn,LogGroupArn=$logGroupArnDeliveries
    echo "Creating failure destination"
    aws pinpoint-sms-voice-v2 create-event-destination \
        --region "$region" \
        --event-destination-name PinpointLoggingFailures \
        --configuration-set-name pinpoint-configuration \
        --matching-event-types '["TEXT_INVALID","TEXT_INVALID_MESSAGE","TEXT_UNREACHABLE","TEXT_CARRIER_UNREACHABLE","TEXT_BLOCKED","TEXT_CARRIER_BLOCKED","TEXT_SPAM","TEXT_UNKNOWN","TEXT_TTL_EXPIRED"]' \
        --cloud-watch-logs-destination IamRoleArn=$iamRoleArn,LogGroupArn=$logGroupArnFailures
fi
