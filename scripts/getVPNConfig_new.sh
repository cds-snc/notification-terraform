#!/bin/bash
set -e

#Find the logged in user
LOGGED_USER=$(stat -f %Su /dev/console)

echo "Getting SAML VPN Config for AWS Profile: $AWS_PROFILE"
export VPN_ID=$(aws ec2 describe-client-vpn-endpoints --query 'ClientVpnEndpoints[? Description == `private-subnets`].ClientVpnEndpointId' --output text)

if [ -z "$VPN_ID" ]; then
  echo "Error: Failed to retrieve VPN endpoint ID. Check AWS credentials and configuration." >&2
  exit 1
fi

echo "Found VPN endpoint: $VPN_ID"

if ! aws ec2 export-client-vpn-client-configuration --client-vpn-endpoint-id $VPN_ID --output text > /tmp/${AWS_PROFILE}_config.ovpn; then
  echo "Error: Failed to export VPN client configuration." >&2
  exit 1
fi

echo "Exported VPN configuration to /tmp/${AWS_PROFILE}_config.ovpn"

# Delete existing profile if it exists
aws-vpn-client delete-profile --profile-name "$AWS_PROFILE" 2>/dev/null || true

aws-vpn-client import-profile --profile-name "$AWS_PROFILE" --config-path /tmp/${AWS_PROFILE}_config.ovpn
echo "Successfully imported VPN profile: $AWS_PROFILE"