#!/bin/bash

# Create 2 numbers to use to create the pools

number1=`aws pinpoint-sms-voice-v2 request-phone-number --iso-country-code CA --message-type TRANSACTIONAL --number-capabilities SMS --number-type LONG_CODE  | jq -r ".PhoneNumberId"`
number2=`aws pinpoint-sms-voice-v2 request-phone-number --iso-country-code CA --message-type TRANSACTIONAL --number-capabilities SMS --number-type LONG_CODE  | jq -r ".PhoneNumberId"`

# Create pools for the shortcode and longcodes

aws pinpoint-sms-voice-v2 create-pool --origination-identity $number1 --iso-country-code CA --message-type TRANSACTIONAL --tags Key=Name,Value=shortcode-pool
aws pinpoint-sms-voice-v2 create-pool --origination-identity $number2 --iso-country-code CA --message-type TRANSACTIONAL --tags Key=Name,Value=longcode-pool

# Create configuration sets

aws pinpoint-sms-voice-v2 create-configuration-set --configuration-set-name shortcode-configuration
aws pinpoint-sms-voice-v2 create-configuration-set --configuration-set-name longcode-configuration

# need to associate the configuration sets with CloudWatch log groups and / or SNS topics

