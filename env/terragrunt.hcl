locals {
  vars = read_terragrunt_config("../env_vars.hcl")
}

inputs = {
  account_id = "${local.vars.inputs.account_id}"
  domain     = "${local.vars.inputs.domain}"
  alt_domain = "${local.vars.inputs.alt_domain}"
  env        = "${local.vars.inputs.env}"
  region     = "ca-central-1"
  # See https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html#access-logging-bucket-permissions
  elb_account_ids = {
    "ca-central-1" = "985666609251"
  }
  new_relic_account_id = "2691974"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region              = var.region
  allowed_account_ids = [var.account_id]
}

provider "aws" {
  alias               = "us-west-2"
  region              = "us-west-2"
  allowed_account_ids = [var.account_id]
}

provider "aws" {
  alias               = "us-east-1"
  region              = "us-east-1"
  allowed_account_ids = [var.account_id]
}
EOF
}

generate "common_variables" {
  path      = "common_variables.tf"
  if_exists = "overwrite"
  contents  = <<EOF
variable "account_id" {
  description = "(Required) The account ID to perform actions on."
  type        = string
}

variable "domain" {
  description = "The current domain"
  type        = string
}

variable "alt_domain" {
  description = "The alternative domain, if it exists"
  type        = string
}

variable "env" {
  description = "The current running environment"
  type        = string
}

variable "region" {
  description = "The current AWS region"
  type        = string
}

# https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html#access-logging-bucket-permissions
variable "elb_account_ids" {
  description = "AWS account IDs used by load balancers"
  type        = map(string)
}
EOF
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    encrypt             = true
    bucket              = "notification-canada-ca-${local.vars.inputs.env}-tf"
    dynamodb_table      = "terraform-state-lock-dynamo"
    region              = "ca-central-1"
    key                 = "${path_relative_to_include()}/terraform.tfstate"
    s3_bucket_tags      = { CostCenter : "notification-canada-ca-${local.vars.inputs.env}" }
    dynamodb_table_tags = { CostCenter : "notification-canada-ca-${local.vars.inputs.env}" }
  }
}
