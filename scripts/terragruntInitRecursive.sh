#!/bin/bash

### WARNING: THIS IS A POTENTIALLY DANGEROUS SCRIPT.
### MAKE SURE YOU ARE IN THE CORRECT ENVIRONMENT BEFORE RUNNING

### This script is intended to do a terragrunt init --reconfigure on all folders in the env/$ENVIRONMENT directory

runCommand()
{
    CMD=$1
    eval "$CMD"
    if [ $? != 0 ]; then
        echo -e "{${RED} ERROR: Command: \"$CMD\" Failed. Halting."
        exit 1
    fi
}


ENVIRONMENT=$1

#folders=$(ls -d ../env/$ENVIRONMENT/*/)


echo "This script will iterate through all terraform folders and auto upgrade and apply."
echo -e "${YELLOW}The target environment is: ${BYELLOW} $ENVIRONMENT"
echo -e "${YELLOW}Your current kubernetes context is ${BYELLOW} $AWS_PROFILE"
echo "****VERIFY YOUR CONTEXT IS THE TARGET ENVIRONMENT!****"
echo -e "${COLOR_OFF}"
echo "Are you sure you want to proceed? Only "yes" will be accepted"
read RESPONSE

folders="common,ecr,ses_receiving_emails,dns,ses_validation_dns_entries,cloudfront,eks,elasticache,rds,lambda-api,lambda-admin-pr,performance-test,heartbeat,database-tools,lambda-google-cidr,ses_to_sqs_email_callbacks,sns_to_sqs_sms_callbacks"
IFS=', ' read -r -a folders <<< "$folders"

if [ "$RESPONSE" == "yes" ]; then
   for folder in "${folders[@]}"
   do
      pushd ../env/$ENVIRONMENT/$folder
      echo "Running terragrunt init --upgrade --reconfigure in $folder"
      runCommand "terragrunt init --upgrade --reconfigure"
      popd
   done
    exit 0
else
    echo "USER REQUESTED CANCELLATION"
    exit 0
fi