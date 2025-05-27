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

folders=$(ls -d ../env/$ENVIRONMENT/*/)


echo "This script will iterate through all terraform folders and auto upgrade and apply."
echo -e "${YELLOW}The target environment is: ${BYELLOW} $ENVIRONMENT"
echo -e "${YELLOW}Your current kubernetes context is ${BYELLOW} $AWS_PROFILE"
echo "****VERIFY YOUR CONTEXT IS THE TARGET ENVIRONMENT!****"
echo -e "${COLOR_OFF}"
echo "Are you sure you want to proceed? Only "yes" will be accepted"
read RESPONSE

if [ "$RESPONSE" == "yes" ]; then
   for folder in $folders
   do
      pushd $folder
      if [ "$folder" == "../env/$ENVIRONMENT/performance-test/" ]; then
         echo "Skipping common folder"
         popd
         continue
      fi
      echo "Running terragrunt init --upgrade --reconfigure in $folder"
      runCommand "terragrunt init --upgrade --reconfigure"
      popd
   done
    exit 0
else
    echo "USER REQUESTED CANCELLATION"
    exit 0
fi