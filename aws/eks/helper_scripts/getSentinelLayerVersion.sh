#!/bin/bash
# This script is used by terraform to get the latest lambda layer version for the aws-sentinel-connector-layer
ACCOUNT_ID=$1
role_arn="arn:aws:iam::$ACCOUNT_ID:role/lambda-list-layers"
session_name="${2:-session-$(date +%s)}"

temp_creds=$(aws sts assume-role \
      --role-arn "$role_arn" \
      --role-session-name "$session_name" \
      --duration-seconds 3600 \
      --output json)

export AWS_ACCESS_KEY_ID=$(echo $temp_creds | jq -r .Credentials.AccessKeyId)
export AWS_SECRET_ACCESS_KEY=$(echo $temp_creds | jq -r .Credentials.SecretAccessKey)
export AWS_SESSION_TOKEN=$(echo $temp_creds | jq -r .Credentials.SessionToken)

VERSION=$(aws lambda list-layer-versions \
  --layer-name aws-sentinel-connector-layer \
  --query "max_by(LayerVersions, &Version)" | \
  jq '.Version')

if [-z "$VERSION"]; then
  echo "Error: Could not get the latest version of the aws-sentinel-connector-layer"
  exit 1
fi

jq --null-input \
  --arg version "$VERSION" \
  '{"version": $version}'
  