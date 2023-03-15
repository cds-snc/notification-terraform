#!/bin/bash
terragrunt import -var-file ../terraform.tfvars aws_iam_user.bulk_send bulk-send 
terragrunt import -var-file ../terraform.tfvars aws_iam_user.inspec-scanner inspec-scanner

IP_SET_ID=$(aws wafv2 list-ip-sets --scope REGIONAL --query 'IPSets[0].Id' --output text)
terragrunt import -var-file ../terraform.tfvars aws_wafv2_ip_set.ip_blocklist $IP_SET_ID/ip_blocklist/REGIONAL
RE_ADMIN_REGEX_ID=$(aws wafv2 list-regex-pattern-sets --scope REGIONAL | jq -r '.RegexPatternSets[] | select(.Name=="re_admin") | .Id')
terragrunt import -var-file ../terraform.tfvars aws_wafv2_regex_pattern_set.re_admin $RE_API_REGEX_ID/re_admin/REGIONAL

RE_API_REGEX_ID=$(aws wafv2 list-regex-pattern-sets --scope REGIONAL | jq -r '.RegexPatternSets[] | select(.Name=="re_api") | .Id')
terragrunt import -var-file ../terraform.tfvars aws_wafv2_regex_pattern_set.re_api $RE_API_REGEX_ID/re_api/REGIONAL

RE_DOC_DOWNLOAD_REGEX_ID=$(aws wafv2 list-regex-pattern-sets --scope REGIONAL | jq -r '.RegexPatternSets[] | select(.Name=="re_document_download") | .Id')
terragrunt import -var-file ../terraform.tfvars aws_wafv2_regex_pattern_set.re_document_download $RE_DOC_DOWNLOAD_REGEX_ID/re_document_download/REGIONAL

RE_DOCUMENTATION_REGEX_ID=$(aws wafv2 list-regex-pattern-sets --scope REGIONAL | jq -r '.RegexPatternSets[] | select(.Name=="re_documentation") | .Id')
terragrunt import -var-file ../terraform.tfvars aws_wafv2_regex_pattern_set.re_documentation $RE_DOCUMENTATION_REGEX_ID/re_documentation/REGIONAL