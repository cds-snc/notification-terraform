#!/bin/bash
PROFILE=$1
TG_VAR_FILE=$2
SECRET_NAME=tfvars-$TG_VAR_FILE

#aws sso login --profile $PROFILE

aws secretsmanager create-secret \
    --name $SECRET_NAME \
    --description "TF Vars Yaml for $TG_VAR_FILE" \
    --secret-string $(cat ../$TG_VAR_FILE | base64)
