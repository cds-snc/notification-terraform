#!/bin/bash
# This script will perform the necessary steps to switch Notify from Redis to Valkey
# Usage ./switchToValkey.sh <environment>
# Example ./switchToValkey.sh dev

ENVIRONMENT=$1

if [ -z "$ENVIRONMENT" ]; then
  echo "Please provide an environment (e.g., dev, production)."
  exit 1
fi

pushd ../env/$ENVIRONMENT/elasticache
echo "Creating Valkey cluster in $ENVIRONMENT environment..."

terragrunt apply
if [ $? -ne 0 ]; then
  echo "Failed to apply changes in $ENVIRONMENT environment."
  exit 1
fi
echo "Successfully created the Valkey cluster in $ENVIRONMENT environment."
popd

echo "Pause to start perfomance test"
read -p "Press [Enter] to continue or [Ctrl+C] to cancel..."

pushd ../env/$ENVIRONMENT/lambda-api
echo "Updating Lambda function in $ENVIRONMENT environment..."
terragrunt apply
if [ $? -ne 0 ]; then
  echo "Failed to apply changes in $ENVIRONMENT environment."
  exit 1
fi
popd
echo "Successfully updated Lambda function in $ENVIRONMENT environment."
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

echo "Successfully updated Notify API and Notify Admin deployments in notification-canada-ca namespace."
echo "Switch to Valkey completed successfully."
