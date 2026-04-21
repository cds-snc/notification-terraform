#!/bin/bash
# This script must be sourced so that credentials are unset in your current shell:
#   source scripts/revokeDnsRole.sh

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  echo "Error: This script must be sourced, not executed directly."
  echo "  Run: source scripts/revokeDnsRole.sh"
  exit 1
fi

ROLE_NAME="notification-terraform-apply"
DEBUG_SID="LocalDebugAssumeRole"

# Get the account ID from the current session (may still be the assumed role).
# This must happen before unsetting credentials so we revert against the same account.
echo "==> Verifying current identity..."
CALLER_IDENTITY=$(aws sts get-caller-identity --output json) || { echo "Error: Failed to get caller identity. Is your SSO session active?"; return 1; }
ACCOUNT_ID=$(echo "${CALLER_IDENTITY}" | jq -r '.Account')

if [[ -z "${ACCOUNT_ID}" || "${ACCOUNT_ID}" == "null" ]]; then
  echo "Error: Could not determine account ID from current session."
  return 1
fi
echo "    Operating in account ${ACCOUNT_ID}."

echo "==> Fetching current trust policy for ${ROLE_NAME}..."
CURRENT_POLICY=$(aws iam get-role --role-name "${ROLE_NAME}" --query 'Role.AssumeRolePolicyDocument' --output json) || { echo "Error: Failed to fetch trust policy for ${ROLE_NAME}."; return 1; }

ORIGINAL_COUNT=$(echo "${CURRENT_POLICY}" | jq '.Statement | length')
UPDATED_POLICY=$(echo "${CURRENT_POLICY}" | jq --arg sid "${DEBUG_SID}" \
  'del(.Statement[] | select(.Sid == $sid))')
UPDATED_COUNT=$(echo "${UPDATED_POLICY}" | jq '.Statement | length')

if [ "${ORIGINAL_COUNT}" -eq "${UPDATED_COUNT}" ]; then
  echo "    Debug statement not found in trust policy, nothing to remove."
else
  echo "==> Removing debug statement from trust policy..."
  aws iam update-assume-role-policy --role-name "${ROLE_NAME}" --policy-document "${UPDATED_POLICY}" || { echo "Error: Failed to restore trust policy."; return 1; }
  echo "    Trust policy restored."
fi

echo "==> Unsetting assumed role credentials..."
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
echo "    Credentials unset."

echo ""
echo "Done. Trust policy reverted and session credentials unset."
