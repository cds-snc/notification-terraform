#!/bin/bash
# Used by aws-auth terraform to get the role name for the running user
ROLE_NAME=$(aws iam list-roles | jq -r '.Roles[] | select(.RoleName|match("AWSReservedSSO_AWSAdministratorAccess_*")) | .RoleName')

jq --null-input \
  --arg rolename "$ROLE_NAME" \
  '{"rolename": $rolename}'