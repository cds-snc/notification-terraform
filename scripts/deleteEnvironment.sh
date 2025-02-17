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

# Delete Cloud Based Sensor Bucket and New Relic resources
echo "Deleting Cloud Based Sensor S3 Bucket..."
pushd ../env/$ENVIRONMENT/common
terragrunt destroy -var-file ../$ENVIRONMENT.tfvars --target module.cbs_logs_bucket --terragrunt-non-interactive -auto-approve
echo "Done." 
echo "Deleting new relic resources..."
terragrunt destroy -var-file ../$ENVIRONMENT.tfvars --target 'newrelic_cloud_aws_link_account.newrelic_cloud_integration_push[0]' --terragrunt-non-interactive -auto-approve
terragrunt destroy -var-file ../$ENVIRONMENT.tfvars --target 'newrelic_api_access_key.newrelic_aws_access_key[0]' --terragrunt-non-interactive -auto-approve
terragrunt destroy -var-file ../$ENVIRONMENT.tfvars --target 'newrelic_cloud_aws_link_account.newrelic_cloud_integration_pull[0]' --terragrunt-non-interactive -auto-approve
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

aws logs delete-log-group --log-group-name '/aws/eks/notification-canada-ca-dev-eks-cluster/cluster'
aws logs delete-log-group --log-group-name '/aws/rds/cluster/notification-canada-ca-dev-cluster/postgresql'

QUERIES=$(aws logs describe-query-definitions --query 'queryDefinitions[].queryDefinitionId' --output text)
for query in $QUERIES; do
  echo "Deleting cloudwatch query $query"
  aws logs delete-query-definition --query-definition-id $query
done

aws iam delete-saml-provider --saml-provider-arn arn:aws:iam::$ACCOUNT_ID:saml-provider/client-vpn

aws iam delete-user --user-name ecr-user

aws events remove-targets --rule dailyBudgetSpend --ids $(aws events list-targets-by-rule --rule dailyBudgetSpend --query 'Targets[].Id' --output text)
aws events delete-rule --name dailyBudgetSpend

aws events remove-targets --rule weeklyBudgetSpend --ids $(aws events list-targets-by-rule --rule weeklyBudgetSpend --query 'Targets[].Id' --output text)
aws events delete-rule --name weeklyBudgetSpend

aws events remove-targets --rule google_cidr_testing --ids $(aws events list-targets-by-rule --rule google_cidr_testing --query 'Targets[].Id' --output text)
aws events delete-rule --name google_cidr_testing

aws sesv2 delete-email-identity --email-identity dev.notification.cdssandbox.xyz

SYSTEM_STATUS_TARGET=$(aws events list-targets-by-rule --rule system_status_testing --query 'Targets[].Id' --output text)

for target in $SYSTEM_STATUS_TARGET; do
  echo "Deleting event target $target"
  aws events remove-targets --rule "system_status_testing" --ids "$target"
  echo "Done."
done

HEARTBEAT_TESTING_TARGET=$(aws events list-targets-by-rule --rule heartbeat_testing --query 'Targets[].Id' --output text)

for target in $HEARTBEAT_TESTING_TARGET; do
  echo "Deleting event target $target"
  aws events remove-targets --rule "heartbeat_testing" --ids "$target"
  echo "Done."
done

PERFTEST_TARGET=$(aws events list-targets-by-rule --rule perf_test_event_rule --query 'Targets[].Id' --output text)

for target in $PERFTEST_TARGET; do
  echo "Deleting event target $target"
  aws events remove-targets --rule "perf_test_event_rule" --ids "$target"
  echo "Done."
done


AWS_REGION=us-east-1  aws ses set-active-receipt-rule-set
AWS_REGION=us-east-1 aws ses delete-receipt-rule-set --rule-set-name main

IDENTITIES=$(aws sesv2 list-email-identities --query 'EmailIdentities[].IdentityName' --output text)

for identity in $IDENTITIES; do
  echo "Deleting ses email identity $identity"
  aws sesv2 delete-email-identity --email-identity $identity
  echo "Done."
done

# We have to switch to US-EAST-1 to delete the email identities
export AWS_REGION=us-east-1
US_IDENTITIES=$(aws sesv2 list-email-identities --query 'EmailIdentities[].IdentityName' --output text)

for identity in $US_IDENTITIES; do
  echo "Deleting ses email identity $identity"
  aws sesv2 delete-email-identity --email-identity $identity
  echo "Done."
done

QUERIES=$(aws logs describe-query-definitions --query 'queryDefinitions[].queryDefinitionId' --output text)
for query in $QUERIES; do
  echo "Deleting cloudwatch query $query"
  aws logs delete-query-definition --query-definition-id $query
done

R53_QUERIES=$(aws route53resolver list-resolver-query-log-configs --query 'ResolverQueryLogConfigs[].Id' --output text)
for query in $R53_QUERIES; do
  echo "Deleting route53 query log $query"
  aws route53resolver delete-resolver-query-log-config --resolver-query-log-config-id $query
done

echo "Done."
echo "Account $ACCOUNT_ID has been cleaned up."
