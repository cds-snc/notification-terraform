#!/bin/bash
# This script must be sourced so that credentials are unset in your current shell:
#   source scripts/revokeDnsRole.sh

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "Error: This script must be sourced, not executed directly."
  echo "  Run: source scripts/revokeDnsRole.sh"
  exit 1
fi

ACCOUNT_ID="296255494825"
ROLE_NAME="notification-terraform-apply"
ROOT_PRINCIPAL="arn:aws:iam::${ACCOUNT_ID}:root"

echo "==> Unsetting assumed role credentials..."
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
echo "    Credentials unset."

echo "==> Fetching current trust policy for ${ROLE_NAME}..."
CURRENT_POLICY=$(aws iam get-role --role-name "${ROLE_NAME}" --query 'Role.AssumeRolePolicyDocument' --output json)

ORIGINAL_COUNT=$(echo "${CURRENT_POLICY}" | jq '.Statement | length')
UPDATED_POLICY=$(echo "${CURRENT_POLICY}" | jq --arg principal "${ROOT_PRINCIPAL}" \
  'del(.Statement[] | select(.Principal.AWS == $principal))')
UPDATED_COUNT=$(echo "${UPDATED_POLICY}" | jq '.Statement | length')

if [ "${ORIGINAL_COUNT}" -eq "${UPDATED_COUNT}" ]; then
  echo "    Account root principal not found in trust policy, nothing to remove."
else
  echo "==> Removing account root from trust policy..."
  aws iam update-assume-role-policy --role-name "${ROLE_NAME}" --policy-document "${UPDATED_POLICY}"
  echo "    Trust policy restored."
fi

echo "==> Verifying identity..."
aws sts get-caller-identity

echo ""
echo "Done. Trust policy reverted and session credentials unset."
