#!/bin/bash
# This script will create or update VPN Configs automatically
# Usage: ./getVPNConfig.sh -c <profile name> or ./getVPNConfig.sh -u <profile name>
# Example: ./getVPNConfig.sh -c "Notify Dev"
while getopts 'c:u:' opt; do
  case "$opt" in
    c)
      CREATE=true
      FILE_NAME=${OPTARG}
      ;;

    u)
      UPDATE=true
      FILE_NAME=${OPTARG}
      ;;

    ?|h)
      echo "Usage: -c for create -u for update"
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"

echo $FILE_NAME
#Find the logged in user
LOGGED_USER=$(stat -f %Su /dev/console)
export FULL_PATH="/Users/$LOGGED_USER/.config/AWSVPNClient/OpenVpnConfigs/$FILE_NAME"

echo "Getting SAML VPN Config for AWS Profile: $AWS_PROFILE"
VPN_ID=$(aws ec2 describe-client-vpn-endpoints --query 'ClientVpnEndpoints[? Description == `private-subnets`].ClientVpnEndpointId' --output text)

aws ec2 export-client-vpn-client-configuration --client-vpn-endpoint-id $VPN_ID --output text | sed '/auth-federate/d' > /Users/$LOGGED_USER/.config/AWSVPNClient/OpenVpnConfigs/"$FILE_NAME"

cp /Users/$LOGGED_USER/.config/AWSVPNClient/ConnectionProfiles /Users/$LOGGED_USER/.config/AWSVPNClient/ConnectionProfiles.bak

if [[ "$CREATE" == "true" ]]; then
  echo "Creating new VPN Config"
  mkdir -p /Users/$LOGGED_USER/.config/AWSVPNClient/OpenVpnConfigs

  jq -c '.ConnectionProfiles[.ConnectionProfiles | length] |= . + {
        "ProfileName": env.FILE_NAME, 
        "OvpnConfigFilePath": "/Users/env.LOGGED_USER/.config/AWSVPNClient/OpenVpnConfigs/env.FILE_NAME",
        "CvpnEndpointId": env.VPN_ID,
        "CvpnEndpointRegion": "ca-central-1",
        "CompatibilityVersion": "2",
        "FederatedAuthType": 1
  }' /Users/$LOGGED_USER/.config/AWSVPNClient/ConnectionProfiles > /Users/$LOGGED_USER/.config/AWSVPNClient/ConnectionProfiles.tmp   
  


  jq -c '( .ConnectionProfiles[] | select(.ProfileName == env.FILE_NAME) | .OvpnConfigFilePath ) |= env.FULL_PATH' /Users/$LOGGED_USER/.config/AWSVPNClient/ConnectionProfiles.tmp  > /Users/$LOGGED_USER/.config/AWSVPNClient/ConnectionProfiles.tmp1 

  rm /Users/$LOGGED_USER/.config/AWSVPNClient/ConnectionProfiles.tmp
  mv /Users/$LOGGED_USER/.config/AWSVPNClient/ConnectionProfiles.tmp1 /Users/$LOGGED_USER/.config/AWSVPNClient/ConnectionProfiles

fi

if [[ "$UPDATE" == "true" ]]; then
  echo "Updating VPN Config"

  jq -c '( .ConnectionProfiles[] | select(.ProfileName == env.FILE_NAME) | .CvpnEndpointId ) |= env.VPN_ID' /Users/$LOGGED_USER/.config/AWSVPNClient/ConnectionProfiles > /Users/$LOGGED_USER/.config/AWSVPNClient/ConnectionProfiles.tmp   
  mv /Users/$LOGGED_USER/.config/AWSVPNClient/ConnectionProfiles.tmp /Users/$LOGGED_USER/.config/AWSVPNClient/ConnectionProfiles
fi

