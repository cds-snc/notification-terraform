#!/bin/bash
set -euo pipefail

ENV="${1:-production}"
REGIONS=("ca-central-1" "us-east-1")
ISSUES=()

echo "Running DKIM audit for environment: $ENV"

# Get all domain identities and check their DKIM CNAMEs via DNS
for region in "${REGIONS[@]}"; do
  domains=$(aws sesv2 list-email-identities --region "$region" | jq -r '.EmailIdentities[] | select(.IdentityType == "DOMAIN") | .IdentityName')
  
  while IFS= read -r domain; do
    [[ -z "$domain" ]] && continue
    
    # Get DKIM tokens from SES
    tokens=$(aws sesv2 get-email-identity --email-identity "$domain" --region "$region" 2>&1 | jq -r '.DkimAttributes.Tokens[]? // empty')
    
    while IFS= read -r token; do
      [[ -z "$token" ]] && continue
      
      cname_name="${token}._domainkey.${domain}"
      expected_value="${token}.dkim.amazonses.com"
      
      # Check DNS
      actual_value=$(dig +short CNAME "$cname_name" | head -n1 | sed 's/\.$//')
      
      if [[ -z "$actual_value" ]]; then
        ISSUES+=("🔴 ${domain} (${region}): CNAME ${cname_name} missing")
      elif [[ "$actual_value" != "$expected_value" ]]; then
        ISSUES+=("🔴 ${domain} (${region}): CNAME ${cname_name} incorrect - expected ${expected_value}, got ${actual_value}")
      fi
    done <<< "$tokens"
  done <<< "$domains"
done

# Report results
if [[ ${#ISSUES[@]} -eq 0 ]]; then
  echo "✓ All DKIM CNAMEs are healthy."
  exit 0
fi

echo "⚠️  DKIM issues detected:"
printf '%s\n' "${ISSUES[@]}" | sed 's/^/  /'

exit 1
