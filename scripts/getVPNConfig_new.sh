#!/bin/bash
# AWS VPN Client 6.x Setup Script
# This script is designed for AWS VPN Client 6.x only
# It will not work with older versions of the AWS VPN Client
# 
# Usage: ./getVPNConfig_new.sh -u <profile-name>
# Or: AWS_PROFILE=<profile-name> ./getVPNConfig_new.sh

set -e

while getopts ':u:h' opt; do
  case "$opt" in
    u)
      AWS_PROFILE="$OPTARG"
      ;;
    h)
      echo "Usage: $0 -u <profile-name>"
      echo "   or: AWS_PROFILE=<profile-name> $0"
      exit 0
      ;;
    :)
      echo "Error: Option -$OPTARG requires an argument." >&2
      echo "Usage: $0 -u <profile-name>" >&2
      exit 1
      ;;
    \?)
      echo "Error: Unknown option -$OPTARG." >&2
      echo "Usage: $0 -u <profile-name>" >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND - 1))

if [[ -z "${AWS_PROFILE:-}" ]]; then
  echo "Error: An AWS profile is required." >&2
  echo "Usage: $0 -u <profile-name>" >&2
  exit 1
fi

export AWS_PROFILE

#Find the logged in user
LOGGED_USER=$(stat -f %Su /dev/console)

echo "Getting SAML VPN Config for AWS Profile: $AWS_PROFILE"
export VPN_ID=$(aws --region ca-central-1 ec2 describe-client-vpn-endpoints --query 'ClientVpnEndpoints[? Description == `private-subnets`].ClientVpnEndpointId' --output text)

if [ -z "$VPN_ID" ]; then
  echo "Error: Failed to retrieve VPN endpoint ID. Check AWS credentials and configuration." >&2
  exit 1
fi

echo "Found VPN endpoint: $VPN_ID"

if ! aws --region ca-central-1 ec2 export-client-vpn-client-configuration --client-vpn-endpoint-id $VPN_ID --output text > /tmp/${AWS_PROFILE}_config.ovpn; then
  echo "Error: Failed to export VPN client configuration." >&2
  exit 1
fi

echo "Exported VPN configuration to /tmp/${AWS_PROFILE}_config.ovpn"

# Delete existing profile if it exists
aws-vpn-client delete-profile --profile-name "$AWS_PROFILE" 2>/dev/null || true

aws-vpn-client import-profile --profile-name "$AWS_PROFILE" --config-path /tmp/${AWS_PROFILE}_config.ovpn
echo "Successfully imported VPN profile: $AWS_PROFILE"