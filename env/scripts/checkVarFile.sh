#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
SECRET_ID=tfvars-$TG_VAR_FILE

printf "${GREEN}Checking Cloud Version of TF Vars for differences... %b\n"
aws secretsmanager get-secret-value --secret-id $SECRET_ID | jq -r .SecretString | base64 -d > /var/tmp/tempvarfile.yaml
if ! diff ../$TG_VAR_FILE /var/tmp/tempvarfile.yaml; then
    printf "${RED}WARNING: THIS FILE DIFFERS FROM WHAT IS IN AWS. ARE YOU SURE YOU WANT TO PROCEED? %b\n"
    printf "${RED}Only "yes" will be accepted. %b\n"
    read ANSWER
    if [ "$ANSWER" = "yes" ]; then
        printf "${YELLOW}User Approved Changes %b\n"
        exit 0
    else
        printf "${RED}User Requested Cancellation %b\n"
        exit 1
    fi
else
    printf "${GREEN}No changes in TF Vars File %b\n"
fi

