#!/bin/bash
# This script will delete the aws environment according to the inputs provided
# Both the environment and the account_id are required
# Usage: ./deleteEnv.sh <ENVIRONMENT> <ACCOUNT_ID>
# Example: ./deleteEnv.sh sandbox 123456789012

ENVIRONMENT=$1
ACCOUNT_ID=$2

USAGE="Usage: ./deleteEnv.sh <ENVIRONMENT> <ACCOUNT_ID>"

if [ -z "$ENVIRONMENT" ]; then
    echo "Environment Name is required.."
    echo $USAGE
    exit 1
fi

if [ -z "$ACCOUNT_ID" ]; then
    echo "Account ID is required.."
    echo $USAGE
    exit 1
fi

# Set the account id in AWS Nuke config
echo "Configuring AWS Nuke"
sed -i'' -e "s/SCRATCH_ACCOUNT_ID/$ACCOUNT_ID/g" awsNuke.cfg 
echo "Done."

echo "Deleting environment $ENVIRONMENT in account $ACCOUNT_ID"

# We need to destroy cloudfront distributions and base DNS records using Terraform since they are in a different account
# Where I could, I put allow_overwrite = true on DNS records so that we don't have to destroy them, but cloudfront and some validation records need to be destroyed
# System Status Cloudfront Distribution
echo "Deleting System Status Cloudfront Distribution..."
pushd ../env/$ENVIRONMENT/system_status_static_site
terragrunt destroy -var-file ../$ENVIRONMENT.tfvars --terragrunt-non-interactive -auto-approve
popd
echo "Done."

# SES Receipt Rule must be deleted.
# We cannot delete all of the DNS TF because the ACM Certificates are still in use and will fail
echo "Deleting SES Receipt Rule Set..."
pushd ../env/$ENVIRONMENT/dns
terragrunt destroy -var-file ../$ENVIRONMENT.tfvars --target aws_ses_receipt_rule_set.main --terragrunt-non-interactive -auto-approve
popd
echo "Done."

# Notify Cloudfront must be deleted
echo "Deleting Notify Cloudfront Distribution..."
pushd ../env/$ENVIRONMENT/cloudfront
terragrunt destroy -var-file ../$ENVIRONMENT.tfvars --terragrunt-non-interactive -auto-approve
popd
echo "Done."

# Delete Cloud Based Sensor Bucket
echo "Deleting Cloud Based Sensor S3 Bucket..."
pushd ../env/$ENVIRONMENT/common
terragrunt destroy -var-file ../$ENVIRONMENT.tfvars --target module.cbs_logs_bucket --terragrunt-non-interactive -auto-approve
popd
echo "Done."

pip install boto3

# AWS Nuke chokes on large S3 Buckets, Deleting them manually
BUCKETS=$(aws s3 ls | awk '{print $3}')
for bucket in $BUCKETS; do
  echo "Deleting S3 Bucket $bucket manually"
  python deleteS3.py $bucket
  aws s3 rm s3://$bucket --recursive  
  aws s3 rb s3://$bucket --force
  echo "Done."
done

# Run the first round of aws-nuke. It will eventually end up in a loop where it can't delete some resources. This is expected.
# After 100 retries, it will stop and we will run it again.
echo "Starting first round of aws-nuke..."
aws-nuke run -c awsNuke.cfg --quiet --no-dry-run --max-wait-retries 100 --force
echo "Done."

# Sleep 5 minutes to make sure any lingering resources from the above aws-nuke run are deleted
echo "Sleeping for 5 minutes to make sure any lingering resources are deleted..."
sleep 300
echo "Done."

# Run the second round of aws-nuke. This should delete all remaining resources.
echo "Starting second round of aws-nuke..."
aws-nuke run -c awsNuke.cfg --quiet --no-dry-run --max-wait-retries 300 --force 
echo "Done."

# aws-nuke can't delete the below resources because they are part of a account-wide blacklist in the aws-nuke config
# This is because there are resources for the account guardrails set up by SRE that should not be deleted

# Delete the remaining resources that aws-nuke can't delete
echo "Deleting remaining resources..."
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

aws events remove-targets --rule dailyBudgetSpend --ids $(aws events list-targets-by-rule --rule dailyBudgetSpend --query 'Targets[].Id' --output text)
aws events delete-rule --name dailyBudgetSpend

aws events remove-targets --rule weeklyBudgetSpend --ids $(aws events list-targets-by-rule --rule weeklyBudgetSpend --query 'Targets[].Id' --output text)
aws events delete-rule --name weeklyBudgetSpend

aws events remove-targets --rule google_cidr_testing --ids $(aws events list-targets-by-rule --rule google_cidr_testing --query 'Targets[].Id' --output text)
aws events delete-rule --name google_cidr_testing


echo "Done."
echo "Account $ACCOUNT_ID has been cleaned up."