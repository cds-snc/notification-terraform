#!/bin/bash
VARFILE=$1
ACCOUNT_ID=$2

pushd ../common

terragrunt import -var-file ../$VARFILE aws_iam_user.bulk_send bulk-send 
terragrunt import -var-file ../$VARFILE aws_iam_user.inspec-scanner inspec-scanner

IP_SET_ID=$(aws wafv2 list-ip-sets --scope REGIONAL --query 'IPSets[0].Id' --output text)
terragrunt import -var-file ../$VARFILE aws_wafv2_ip_set.ip_blocklist $IP_SET_ID/ip_blocklist/REGIONAL
RE_ADMIN_REGEX_ID=$(aws wafv2 list-regex-pattern-sets --scope REGIONAL | jq -r '.RegexPatternSets[] | select(.Name=="re_admin") | .Id')
terragrunt import -var-file ../$VARFILE aws_wafv2_regex_pattern_set.re_admin $RE_API_REGEX_ID/re_admin/REGIONAL

RE_API_REGEX_ID=$(aws wafv2 list-regex-pattern-sets --scope REGIONAL | jq -r '.RegexPatternSets[] | select(.Name=="re_api") | .Id')
terragrunt import -var-file ../$VARFILE aws_wafv2_regex_pattern_set.re_api $RE_API_REGEX_ID/re_api/REGIONAL

RE_DOC_DOWNLOAD_REGEX_ID=$(aws wafv2 list-regex-pattern-sets --scope REGIONAL | jq -r '.RegexPatternSets[] | select(.Name=="re_document_download") | .Id')
terragrunt import -var-file ../$VARFILE aws_wafv2_regex_pattern_set.re_document_download $RE_DOC_DOWNLOAD_REGEX_ID/re_document_download/REGIONAL

RE_DOCUMENTATION_REGEX_ID=$(aws wafv2 list-regex-pattern-sets --scope REGIONAL | jq -r '.RegexPatternSets[] | select(.Name=="re_documentation") | .Id')
terragrunt import -var-file ../$VARFILE aws_wafv2_regex_pattern_set.re_documentation $RE_DOCUMENTATION_REGEX_ID/re_documentation/REGIONAL

popd
pushd ../dns

terragrunt import -var-file ../$VARFILE aws_ses_receipt_rule_set.main main
terragrunt import -var-file ../$VARFILE aws_ses_receipt_rule.ses_receiving_emails_inbound-to-lambda-arn main:ses_receiving_emails_inbound-to-lambda

popd

pushd ../eks

ALB_ARN=$(aws elbv2 describe-load-balancers | jq -r '.LoadBalancers[] | select(.LoadBalancerName=="notification-scratch-alb") | .LoadBalancerArn')

terragrunt import -var-file ../$VARFILE aws_alb.notification-canada-ca $ALB_ARN

DOCUMENT_API_TARGET_GROUP=$(aws elbv2 describe-target-groups | jq -r '.TargetGroups[] | select(.TargetGroupName=="notification-document-api") | .TargetGroupArn')
terragrunt import -var-file ../$VARFILE aws_alb_target_group.notification-canada-ca-document-api $DOCUMENT_API_TARGET_GROUP

ADMIN_ERROR_QUERY_ID=$(aws logs describe-query-definitions | jq -r '.queryDefinitions[] | select(.name=="ADMIN & API - 50X errors") | .queryDefinitionId' )
terragrunt import -var-file ../$VARFILE aws_cloudwatch_query_definition.admin-api-50X-errors arn:aws:logs:ca-central-1:$ACCOUNT_ID:\query-definition:$ADMIN_ERROR_QUERY_ID

CELERY_ERROR_QUERY_ID=$(aws logs describe-query-definitions | jq -r '.queryDefinitions[] | select(.name=="Celery errors") | .queryDefinitionId' )
terragrunt import -var-file ../$VARFILE aws_cloudwatch_query_definition.celery-errors arn:aws:logs:ca-central-1:$ACCOUNT_ID:\query-definition:$CELERY_ERROR_QUERY_ID

WAF_ACL_ID=$(aws wafv2 list-web-acls --scope REGIONAL | jq -r '.WebACLs[] | select(.Name=="notification-canada-ca-waf") | .Id')
terragrunt import -var-file ../$VARFILE aws_wafv2_web_acl.notification-canada-ca $WAF_ACL_ID/notification-canada-ca-waf/REGIONAL

popd

pushd ../lambda-api
terragrunt import -var-file ../scratch.tfvars aws_api_gateway_domain_name.alt_api_lambda api.scratch.notification.cdssandbox.xyz
API_LAMBDA_ERROR_QUERY_ID=$(aws logs describe-query-definitions | jq -r '.queryDefinitions[] | select(.name=="API lambda - errors") | .queryDefinitionId' )
terragrunt import -var-file ../$VARFILE aws_cloudwatch_query_definition.api-lambda-errors arn:aws:logs:ca-central-1:$ACCOUNT_ID:\query-definition:$API_LAMBDA_ERROR_QUERY_ID

SERVICE_RATE_LIMIT_QUERY_ID=$(aws logs describe-query-definitions | jq -r '.queryDefinitions[] | select(.name=="Services going over daily rate limits") | .queryDefinitionId' )
terragrunt import -var-file ../$VARFILE aws_cloudwatch_query_definition.services-over-daily-rate-limit arn:aws:logs:ca-central-1:$ACCOUNT_ID:\query-definition:$SERVICE_RATE_LIMIT_QUERY_ID

terragrunt import -var-file ../$VARFILE aws_iam_user.ecr-user ecr-user

popd

