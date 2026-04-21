#!/bin/bash
# This script must be sourced so that credentials are exported into your current shell:
#   source scripts/assumeDnsRole.sh

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "Error: This script must be sourced, not executed directly."
  echo "  Run: source scripts/assumeDnsRole.sh"
  exit 1
fi

ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text) || { echo "Error: Failed to get caller identity. Is your SSO session active?"; return 1; }
ROLE_NAME="notification-terraform-apply"
ROLE_ARN="arn:aws:iam::${ACCOUNT_ID}:role/${ROLE_NAME}"
ROOT_PRINCIPAL="arn:aws:iam::${ACCOUNT_ID}:root"
DEBUG_SID="LocalDebugAssumeRole"

echo "==> Fetching current trust policy for ${ROLE_NAME}..."
CURRENT_POLICY=$(aws iam get-role --role-name "${ROLE_NAME}" --query 'Role.AssumeRolePolicyDocument' --output json) || { echo "Error: Failed to fetch trust policy for ${ROLE_NAME}."; return 1; }

if echo "${CURRENT_POLICY}" | jq -e --arg sid "${DEBUG_SID}" '.Statement[] | select(.Sid == $sid)' > /dev/null 2>&1; then
  echo "    Debug statement already present in trust policy, skipping patch."
else
  echo "==> Patching trust policy to allow account ${ACCOUNT_ID} root to assume role..."
  UPDATED_POLICY=$(echo "${CURRENT_POLICY}" | jq --arg sid "${DEBUG_SID}" --arg principal "${ROOT_PRINCIPAL}" \
    '.Statement += [{"Sid": $sid, "Effect": "Allow", "Principal": {"AWS": $principal}, "Action": "sts:AssumeRole"}]')
  aws iam update-assume-role-policy --role-name "${ROLE_NAME}" --policy-document "${UPDATED_POLICY}" || { echo "Error: Failed to update trust policy."; return 1; }
  echo "    Trust policy updated. Waiting for IAM changes to propagate..."
  sleep 10
fi

echo "==> Assuming role ${ROLE_ARN}..."
CREDS=$(aws sts assume-role \
  --role-arn "${ROLE_ARN}" \
  --role-session-name "dns-local-plan" \
  --output json) || { echo "Error: Failed to assume role ${ROLE_ARN}."; return 1; }

ACCESS_KEY_ID=$(echo "${CREDS}" | jq -r '.Credentials.AccessKeyId')
SECRET_ACCESS_KEY=$(echo "${CREDS}" | jq -r '.Credentials.SecretAccessKey')
SESSION_TOKEN=$(echo "${CREDS}" | jq -r '.Credentials.SessionToken')

if [[ -z "${ACCESS_KEY_ID}" || "${ACCESS_KEY_ID}" == "null" || \
     -z "${SECRET_ACCESS_KEY}" || "${SECRET_ACCESS_KEY}" == "null" || \
     -z "${SESSION_TOKEN}" || "${SESSION_TOKEN}" == "null" ]]; then
  echo "Error: Assumed role credentials are missing or invalid."
  return 1
fi

export AWS_ACCESS_KEY_ID="${ACCESS_KEY_ID}"
export AWS_SECRET_ACCESS_KEY="${SECRET_ACCESS_KEY}"
export AWS_SESSION_TOKEN="${SESSION_TOKEN}"

echo "==> Verifying identity..."
aws sts get-caller-identity || { echo "Error: Failed to verify identity after assuming role."; return 1; }

echo ""
echo "Done. You are now operating as ${ROLE_NAME}."
echo "Run your terragrunt plan, then clean up with: source scripts/revokeDnsRole.sh"
