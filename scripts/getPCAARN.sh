#!/bin/bash
# This is a dirty hack to get the ARN of the PCA so that we can import it when creating a new environment.
# Terraform external datasources require a very basic JSON output, so we're using jq to format the output.
PCA=$(aws acm-pca list-certificate-authorities --query 'CertificateAuthorities[?Status == `ACTIVE`].Arn' --output text)

jq --null-input \
  --arg arn "$PCA" \
  '{"arn": $arn}'