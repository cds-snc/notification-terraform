#!/bin/bash
# This script must be sourced so that credentials are exported into your current shell:
#   source scripts/assumeDnsRole.sh

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "Error: This script must be sourced, not executed directly."
  echo "  Run: source scripts/assumeDnsRole.sh"
  exit 1
fi

ACCOUNT_ID="296255494825"
ROLE_NAME="notification-terraform-apply"
ROLE_ARN="arn:aws:iam::${ACCOUNT_ID}:role/${ROLE_NAME}"
ROOT_PRINCIPAL="arn:aws:iam::${ACCOUNT_ID}:root"

echo "==> Fetching current trust policy for ${ROLE_NAME}..."
CURRENT_POLICY=$(aws iam get-role --role-name "${ROLE_NAME}" --query 'Role.AssumeRolePolicyDocument' --output json)

if echo "${CURRENT_POLICY}" | jq -e --arg principal "${ROOT_PRINCIPAL}" '.Statement[] | select(.Principal.AWS == $principal)' > /dev/null 2>&1; then
  echo "    Account root principal already present in trust policy, skipping patch."
else
  echo "==> Patching trust policy to allow account ${ACCOUNT_ID} root to assume role..."
  UPDATED_POLICY=$(echo "${CURRENT_POLICY}" | jq --arg principal "${ROOT_PRINCIPAL}" \
    '.Statement += [{"Effect": "Allow", "Principal": {"AWS": $principal}, "Action": "sts:AssumeRole"}]')
  aws iam update-assume-role-policy --role-name "${ROLE_NAME}" --policy-document "${UPDATED_POLICY}"
  echo "    Trust policy updated."
fi

echo "==> Assuming role ${ROLE_ARN}..."
CREDS=$(aws sts assume-role \
  --role-arn "${ROLE_ARN}" \
  --role-session-name "dns-local-plan" \
  --output json)

export AWS_ACCESS_KEY_ID=$(echo "${CREDS}" | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo "${CREDS}" | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo "${CREDS}" | jq -r '.Credentials.SessionToken')

echo "==> Verifying identity..."
aws sts get-caller-identity

echo ""
echo "Done. You are now operating as ${ROLE_NAME}."
echo "Run your terragrunt plan, then clean up with: source scripts/revokeDnsRole.sh"
