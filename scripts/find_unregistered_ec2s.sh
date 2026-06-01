#!/bin/bash
# find_unregistered_ec2s.sh
#
# Compares running EC2 instances in the AWS account against nodes registered
# to an EKS cluster and prints any EC2s that are NOT registered as EKS nodes.
#
# Usage:
#   ./find_unregistered_ec2s.sh <eks-cluster-name> [aws-region]
#
# Prerequisites: kubectl (with kubeconfig pointing at the cluster), aws CLI, jq

set -euo pipefail

CLUSTER_NAME="${1:-}"
AWS_REGION="${2:-${AWS_DEFAULT_REGION:-ca-central-1}}"
if [[ -z "$CLUSTER_NAME" ]]; then
  echo "Usage: $0 <eks-cluster-name> [aws-region]" >&2
  exit 1
fi

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "Cluster : $CLUSTER_NAME"
echo "Region  : $AWS_REGION"
echo ""

# ── 1. Update kubeconfig for the cluster ─────────────────────────────────────
echo "Updating kubeconfig..."
aws eks update-kubeconfig \
  --name "$CLUSTER_NAME" \
  --region "$AWS_REGION" \
  --no-cli-pager \
  >/dev/null

# ── 2. Get EC2 instance IDs registered as EKS nodes ─────────────────────────
echo "Fetching EKS node list..."
EKS_INSTANCE_IDS=$(kubectl get nodes \
  -o jsonpath='{.items[*].spec.providerID}' \
  | tr ' ' '\n' \
  | sed 's|.*/||')   # strip "aws:///region/az/" prefix, leaving just the instance ID

EKS_COUNT=$(echo "$EKS_INSTANCE_IDS" | grep -c 'i-' || true)
echo -e "${GREEN}EKS registered nodes: $EKS_COUNT${NC}"

# ── 3. Get all running EC2 instances in the account ──────────────────────────
echo "Fetching running EC2 instances..."
EC2_JSON=$(aws ec2 describe-instances \
  --region "$AWS_REGION" \
  --filters "Name=instance-state-name,Values=running" \
  --query 'Reservations[*].Instances[*].{id:InstanceId,name:Tags[?Key==`Name`]|[0].Value,type:InstanceType,launched:LaunchTime,az:Placement.AvailabilityZone}' \
  --output json \
  --no-cli-pager)

EC2_COUNT=$(echo "$EC2_JSON" | jq '[.[][] ] | length')
echo -e "${GREEN}Running EC2 instances : $EC2_COUNT${NC}"
echo ""

# ── 4. Find EC2s not in EKS ──────────────────────────────────────────────────
echo "EC2 instances NOT registered to EKS cluster '$CLUSTER_NAME':"
echo "─────────────────────────────────────────────────────────────────────────"
printf "%-22s %-40s %-14s %-25s %s\n" "INSTANCE ID" "NAME" "TYPE" "LAUNCHED" "AZ"
echo "─────────────────────────────────────────────────────────────────────────"

UNREGISTERED=0

while IFS= read -r instance; do
  id=$(echo "$instance"    | jq -r '.id')
  name=$(echo "$instance"  | jq -r '.name // "(no name)"')
  type=$(echo "$instance"  | jq -r '.type')
  launched=$(echo "$instance" | jq -r '.launched')
  az=$(echo "$instance"    | jq -r '.az')

  if ! echo "$EKS_INSTANCE_IDS" | grep -qx "$id"; then
    printf "%-22s %-40s %-14s %-25s %s\n" "$id" "$name" "$type" "$launched" "$az"
    UNREGISTERED=$((UNREGISTERED + 1))
  fi
done < <(echo "$EC2_JSON" | jq -c '.[][]')

echo "─────────────────────────────────────────────────────────────────────────"

if [[ $UNREGISTERED -eq 0 ]]; then
  echo -e "${GREEN}All running EC2s are registered as EKS nodes.${NC}"
else
  echo -e "${YELLOW}Total unregistered EC2s: $UNREGISTERED${NC}"
fi
