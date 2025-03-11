#!/bin/bash
# This is a dirty hack to get the ARN of the PCA so that we can import it when creating a new environment.
# Terraform external datasources require a very basic JSON output, so we're using jq to format the output.
poolArns=$(aws pinpoint-sms-voice-v2 describe-pools --output json | jq -r '.Pools[].PoolArn')
defaultPoolExists=false
for poolArn in $poolArns; do
    isDefault=$(aws pinpoint-sms-voice-v2 list-tags-for-resource --resource-arn $poolArn | jq -r '.Tags[].Value' | grep 'default-pool' | wc -l)
    if [ $isDefault == 1 ]; then
        poolId=$(aws pinpoint-sms-voice-v2 describe-pools --query "Pools[?PoolArn=='"$poolArn"'].PoolId" --output text)
    fi
done

jq --null-input \
  --arg poolId "$poolId" \
  '{"poolId": $poolId}'
  