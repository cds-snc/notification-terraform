#!/bin/bash
# This script will perform the necessary steps to switch Notify from Redis to Valkey
# Usage ./switchToValkey.sh <environment>
# Example ./switchToValkey.sh dev

ENVIRONMENT=$1
REDIS_CLUSTER_ID=notify-$ENVIRONMENT-cluster-cache-az-001
SNAPSHOT_NAME=redis-migration

if [ -z "$ENVIRONMENT" ]; then
  echo "Please provide an environment (e.g., dev, production)."
  exit 1
fi


pushd ../env/$ENVIRONMENT/eks
echo "Switching to K8s API"
terragrunt apply
if [ $? -ne 0 ]; then
  echo "Failed to apply changes in $ENVIRONMENT environment."
  exit 1
fi
popd

pushd ../env/$ENVIRONMENT/lambda-api
terragrunt apply
if [ $? -ne 0 ]; then
  echo "Failed to apply changes in $ENVIRONMENT environment."
  exit 1
fi
popd

# Check if aws snapshot exists and delete it if it does
if aws elasticache describe-snapshots --snapshot-name "$SNAPSHOT_NAME" --query 'Snapshots[0].SnapshotName' --output text 2>/dev/null | grep -q "$SNAPSHOT_NAME"; then
  echo "Snapshot $SNAPSHOT_NAME exists. Deleting..."
  aws elasticache delete-snapshot --snapshot-name "$SNAPSHOT_NAME"
  while true; do
    STATUS=$(aws elasticache describe-snapshots --snapshot-name "$SNAPSHOT_NAME" --query 'Snapshots[0].SnapshotStatus' --output text)
    echo "Current snapshot status: $STATUS"
    if [ "$STATUS" != "deleting" ]; then
      echo "Snapshot $SNAPSHOT_NAME is deleted."
      break
    fi
    sleep 10
  done

else
  echo "Snapshot $SNAPSHOT_NAME does not exist."
fi

# Create the new snapshot
aws elasticache create-snapshot \
    --snapshot-name $SNAPSHOT_NAME \
    --cache-cluster-id $REDIS_CLUSTER_ID

# Wait for the snapshot to become available
while true; do
  STATUS=$(aws elasticache describe-snapshots --snapshot-name "$SNAPSHOT_NAME" --query 'Snapshots[0].SnapshotStatus' --output text)
  echo "Current snapshot status: $STATUS"
  if [ "$STATUS" == "available" ]; then
    echo "Snapshot $SNAPSHOT_NAME is available."
    break
  fi
  sleep 10
done

# Create the Valkey cluster with the snapshot
pushd ../env/$ENVIRONMENT/elasticache
echo "Creating Valkey cluster in $ENVIRONMENT environment..."

terragrunt apply
if [ $? -ne 0 ]; then
  echo "Failed to apply changes in $ENVIRONMENT environment."
  exit 1
fi
echo "Successfully created the Valkey cluster in $ENVIRONMENT environment."
popd

#echo "Pause to start perfomance test"
#read -p "Press [Enter] to continue or [Ctrl+C] to cancel..."

# Recreate the lambda function

pushd ../env/$ENVIRONMENT/lambda-api
echo "Updating Lambda function in $ENVIRONMENT environment..."
terragrunt destroy --target aws_lambda_function.api
terragrunt import 'aws_cloudwatch_log_group.api_lambda_log_group[0]' '/aws/lambda/api-lambda'
terragrunt apply

if [ $? -ne 0 ]; then
  echo "Failed to apply changes in $ENVIRONMENT environment."
  exit 1
fi
popd
echo "Successfully updated Lambda function in $ENVIRONMENT environment."

# Update the manifest secrets
pushd ../env/$ENVIRONMENT/manifest_secrets
echo "Updating manifest secrets in $ENVIRONMENT environment..."
terragrunt apply
if [ $? -ne 0 ]; then
  echo "Failed to apply changes in $ENVIRONMENT environment."
  exit 1
fi
popd
echo "Successfully updated manifest secrets in $ENVIRONMENT environment."

echo "Ensure you are connected to the VPN"
read -p "Press [Enter] to continue or [Ctrl+C] to cancel..."

echo "Updating Notify API and Notify Admin deployments in notification-canada-ca namespace..."

kubectl rollout restart deployment/notify-admin -n notification-canada-ca
kubectl rollout status deployment notify-admin -n notification-canada-ca

kubectl rollout restart deployment/notify-api -n notification-canada-ca
kubectl rollout status deployment notify-api -n notification-canada-ca

CELERIES=$(kubectl get deployments -n notification-canada-ca | awk '{print $1}' | grep celery )
for celery in $CELERIES; do
  echo $celery
  kubectl rollout restart deployment/$celery -n notification-canada-ca
  kubectl rollout status deployment $celery -n notification-canada-ca
done

echo "Successfully updated Notify API and Notify Admin deployments in notification-canada-ca namespace."
echo "Switch to Valkey completed successfully."
echo "Please make sure to use in flight utils to migrate dangling in flights"
