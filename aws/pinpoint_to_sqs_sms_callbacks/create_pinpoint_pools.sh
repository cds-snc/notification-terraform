#!/bin/bash
set -eo pipefail

# Creates Pinpoint SMS pools (CA) and CloudWatch event destinations (CA + US).
# Configuration sets are managed natively by Terraform.
#
# Usage: create_pinpoint_pools.sh <iam_role_arn> <ca_deliveries_arn> <ca_failures_arn> <us_deliveries_arn> <us_failures_arn>

IAM_ROLE_ARN="$1"
CA_DELIVERIES_ARN="$2"
CA_FAILURES_ARN="$3"
US_DELIVERIES_ARN="$4"
US_FAILURES_ARN="$5"

CONFIG_SET="pinpoint-configuration"
FAILURE_EVENTS='["TEXT_INVALID","TEXT_INVALID_MESSAGE","TEXT_UNREACHABLE","TEXT_CARRIER_UNREACHABLE","TEXT_BLOCKED","TEXT_CARRIER_BLOCKED","TEXT_SPAM","TEXT_UNKNOWN","TEXT_TTL_EXPIRED"]'

# ── CA Pools ──────────────────────────────────────────────────────────────────

for POOL_NAME in shortcode-pool default-pool; do
  POOL_ID=$(aws pinpoint-sms-voice-v2 describe-pools \
    | jq -r --arg n "$POOL_NAME" '.Pools[] | select(any(.Tags[]?; .Key=="Name" and .Value==$n)) | .PoolId' \
    | head -1)

  if [ -n "$POOL_ID" ]; then
    echo "Pool '${POOL_NAME}' already exists: ${POOL_ID}"
    continue
  fi

  echo "Requesting phone number for pool: ${POOL_NAME}"
  NUMBER_ID=$(aws pinpoint-sms-voice-v2 request-phone-number \
    --iso-country-code CA --message-type TRANSACTIONAL \
    --number-capabilities SMS --number-type LONG_CODE \
    | jq -r '.PhoneNumberId')
  sleep 30

  POOL_ID=$(aws pinpoint-sms-voice-v2 create-pool \
    --origination-identity "$NUMBER_ID" \
    --iso-country-code CA --message-type TRANSACTIONAL \
    --tags "Key=Name,Value=${POOL_NAME}" \
    | jq -r '.PoolId')

  aws pinpoint-sms-voice-v2 update-pool --pool-id "$POOL_ID" --shared-routes-enabled
  echo "Pool '${POOL_NAME}' created: ${POOL_ID}"
done

# ── Event Destinations (CA + US) ──────────────────────────────────────────────

create_destination_if_missing() {
  local dest_name="$1"
  local event_types="$2"
  local log_group_arn="$3"
  local region="$4"
  local region_arg=""
  if [ -n "$region" ]; then region_arg="--region $region"; fi

  if aws pinpoint-sms-voice-v2 $region_arg describe-event-destinations \
      --configuration-set-name "$CONFIG_SET" \
      | jq -e --arg n "$dest_name" '.EventDestinations[] | select(.EventDestinationName == $n)' > /dev/null 2>&1; then
    echo "Event destination '${dest_name}' already exists (${region:-ca-central-1})"
    return
  fi

  echo "Creating event destination '${dest_name}' (${region:-ca-central-1})"
  aws pinpoint-sms-voice-v2 $region_arg create-event-destination \
    --configuration-set-name "$CONFIG_SET" \
    --event-destination-name "$dest_name" \
    --matching-event-types "$event_types" \
    --cloud-watch-logs-destination "IamRoleArn=${IAM_ROLE_ARN},LogGroupArn=${log_group_arn}"
}

create_destination_if_missing "PinpointLoggingAll"      "ALL"             "$CA_DELIVERIES_ARN" ""
create_destination_if_missing "PinpointLoggingFailures" "$FAILURE_EVENTS" "$CA_FAILURES_ARN"   ""
create_destination_if_missing "PinpointLoggingAll"      "ALL"             "$US_DELIVERIES_ARN" "us-west-2"
create_destination_if_missing "PinpointLoggingFailures" "$FAILURE_EVENTS" "$US_FAILURES_ARN"   "us-west-2"
