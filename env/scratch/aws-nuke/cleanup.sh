#!/bin/bash
aws iam delete-role --role-name AWSServiceRoleForEC2Spot
QUERYID=$(aws logs describe-query-definitions --query-definition-name-prefix "Lambda Statistics" --region us-east-1 --query 'queryDefinitions[0].queryDefinitionId' --output text)
aws logs delete-query-definition --query-definition-id $QUERYID