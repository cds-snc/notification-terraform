#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
SECRET_ID=tfvars-$TG_VAR_FILE
TF_PATH=$1

printf "${GREEN}Checking Cloud Version of TF Vars for differences... %b\n"
aws secretsmanager get-secret-value --secret-id $SECRET_ID | jq -r .SecretString | base64 -d > /var/tmp/tempvarfile.yaml
if ! diff $TF_PATH/$TG_VAR_FILE /var/tmp/tempvarfile.yaml; then
    printf "${YELLOW} Updating TF Vars File In Secrets Manager as the Values Have Changed."
    aws secretsmanager put-secret-value \
    --secret-id $SECRET_ID \
    --secret-string $(cat $TF_PATH/$TG_VAR_FILE | base64)
else
    printf "${GREEN}No changes in TF Vars File. Skipping Secret Manager Sync. %b\n"
fi