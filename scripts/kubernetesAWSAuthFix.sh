#!/bin/bash
# This script updates the aws-auth config map in the newly created EKS cluster since AWS EKS doesn't create it properly when going through Github Actions
#export ROLE_NAME=$(aws iam list-roles | jq -r '.Roles[] | select(.RoleName|match("AWSReservedSSO_AWSAdministratorAccess_*")) | .RoleName')
export ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

envsubst < aws-auth.yaml | sponge aws-auth.yaml

kubectl apply -f aws-auth.yaml -n kube-system
