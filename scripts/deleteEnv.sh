#!/bin/bash
## SANDBOX ACCOUNT_ID:891376947407
ENVIRONMENT=$1
ACCOUNT_ID=$2


pushd ../env/$ENVIRONMENT/system_status_static_site
terragrunt destroy -var-file ../$ENVIRONMENT.tfvars --terragrunt-non-interactive -auto-approve
popd

pushd ../env/$ENVIRONMENT/dns
terragrunt destroy -var-file ../$ENVIRONMENT.tfvars --target aws_ses_receipt_rule_set.main --terragrunt-non-interactive -auto-approve
popd

pushd ../env/$ENVIRONMENT/cloudfront
terragrunt destroy -var-file ../$ENVIRONMENT.tfvars --terragrunt-non-interactive -auto-approve
popd

aws-nuke run -c awsNuke.cfg --quiet --no-dry-run --max-wait-retries 100 --force

sleep 300

aws-nuke run -c awsNuke.cfg --quiet --no-dry-run --max-wait-retries 100 --force

aws kms delete-alias --alias-name alias/s3_scan_object_queue

aws iam delete-service-linked-role --role-name AWSServiceRoleForEC2Spot
aws logs delete-query-definition --query-definition-id $(aws logs describe-query-definitions --query 'queryDefinitions[?name==`Lambda Statistics / heartbeat`]'.queryDefinitionId --output text)
aws logs delete-query-definition --query-definition-id $(aws logs describe-query-definitions --query 'queryDefinitions[?name==`Lambda Statistics - pinpoint_to_sqs_sms_callbacks`]'.queryDefinitionId --output text)
aws logs delete-query-definition --query-definition-id $(aws logs describe-query-definitions --query 'queryDefinitions[?name==`Lambda Statistics - sns_to_sqs_sms_callbacks`]'.queryDefinitionId --output text)
aws logs delete-query-definition --query-definition-id $(aws logs describe-query-definitions --query 'queryDefinitions[?name==`Lambda Statistics / system_status`]'.queryDefinitionId --output text)
aws logs delete-query-definition --query-definition-id $(aws logs describe-query-definitions --query 'queryDefinitions[?name==`Lambda Statistics - ses_to_sqs_email_callbacks`]'.queryDefinitionId --output text)
aws logs delete-query-definition --query-definition-id $(aws logs describe-query-definitions --query 'queryDefinitions[?name==`Lambda Statistics - ses_receiving_emails`]'.queryDefinitionId --output text --region us-east-1) --region us-east-1
aws logs delete-query-definition --query-definition-id $(aws logs describe-query-definitions --query 'queryDefinitions[?name==`API / Services going over daily rate limits`]'.queryDefinitionId --output text)

aws iam delete-saml-provider --saml-provider-arn arn:aws:iam::$ACCOUNT_ID:saml-provider/client-vpn

aws iam delete-user --user-name ecr-user
