#!/bin/bash
# This script will create or update VPN Configs automatically
# Usage: ./getVPNConfig.sh -c <profile name> or ./getVPNConfig.sh -u <profile name>
# Example: ./getVPNConfig.sh -c "Notify Dev"
while getopts 'c:u:' opt; do
  case "$opt" in
    c)
      CREATE=true
      export FILE_NAME=${OPTARG}
      ;;

    u)
      UPDATE=true
      export FILE_NAME=${OPTARG}
      ;;

    ?|h)
      echo "Usage: -c for create -u for update"
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

if ((OPTIND == 1))
then
    echo "Usage: -c <profile name> for create -u for update <profile name>"
    exit 1
fi

shift $((OPTIND - 1))

echo "$FILE_NAME"
#Find the logged in user
LOGGED_USER=$(stat -f %Su /dev/console)
# Get full path
export FULL_PATH="/Users/$LOGGED_USER/.config/AWSVPNClient/OpenVpnConfigs/$FILE_NAME"

echo "Getting SAML VPN Config for AWS Profile: $AWS_PROFILE"
export VPN_ID=$(aws ec2 describe-client-vpn-endpoints --query 'ClientVpnEndpoints[? Description == `private-subnets`].ClientVpnEndpointId' --output text)

if [[ -z "$VPN_ID" ]]
then
  echo "Error finding VPN ID. Exiting..."
  exit 1
fi

# Fetch the OVPN Config
aws ec2 export-client-vpn-client-configuration --client-vpn-endpoint-id $VPN_ID --output text | sed '/auth-federate/d' > /Users/$LOGGED_USER/.config/AWSVPNClient/OpenVpnConfigs/"$FILE_NAME"

# Backup the ConnectionProfiles file 
cp /Users/$LOGGED_USER/.config/AWSVPNClient/ConnectionProfiles /Users/$LOGGED_USER/.config/AWSVPNClient/ConnectionProfiles.bak

if [[ "$CREATE" == "true" ]]; then
  echo "Creating new VPN Config"
  mkdir -p /Users/$LOGGED_USER/.config/AWSVPNClient/OpenVpnConfigs

  # Inject a new profile into the ConnectionProfiles file
  jq -c '.ConnectionProfiles[.ConnectionProfiles | length] |= . + {
        "ProfileName": env.FILE_NAME, 
        "OvpnConfigFilePath": "/Users/env.LOGGED_USER/.config/AWSVPNClient/OpenVpnConfigs/env.FILE_NAME",
        "CvpnEndpointId": env.VPN_ID,
        "CvpnEndpointRegion": "ca-central-1",
        "CompatibilityVersion": "2",
        "FederatedAuthType": 1
  }' /Users/$LOGGED_USER/.config/AWSVPNClient/ConnectionProfiles > /Users/$LOGGED_USER/.config/AWSVPNClient/ConnectionProfiles.tmp   
  
  # Update the OvpnConfigFilePath with the full path. Had to do this in two steps.
  jq -c '( .ConnectionProfiles[] | select(.ProfileName == env.FILE_NAME) | .OvpnConfigFilePath ) |= env.FULL_PATH' /Users/$LOGGED_USER/.config/AWSVPNClient/ConnectionProfiles.tmp  > /Users/$LOGGED_USER/.config/AWSVPNClient/ConnectionProfiles.tmp1 

  # Clean up
  rm /Users/$LOGGED_USER/.config/AWSVPNClient/ConnectionProfiles.tmp
  mv /Users/$LOGGED_USER/.config/AWSVPNClient/ConnectionProfiles.tmp1 /Users/$LOGGED_USER/.config/AWSVPNClient/ConnectionProfiles

fi

if [[ "$UPDATE" == "true" ]]; then
  echo "Updating VPN Config"
  # Update the VPN Id for the profile
  jq -c '( .ConnectionProfiles[] | select(.ProfileName == env.FILE_NAME) | .CvpnEndpointId ) |= env.VPN_ID' /Users/$LOGGED_USER/.config/AWSVPNClient/ConnectionProfiles > /Users/$LOGGED_USER/.config/AWSVPNClient/ConnectionProfiles.tmp   
  mv /Users/$LOGGED_USER/.config/AWSVPNClient/ConnectionProfiles.tmp /Users/$LOGGED_USER/.config/AWSVPNClient/ConnectionProfiles
fi

