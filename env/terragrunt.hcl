locals {
  vars = read_terragrunt_config("../env_vars.hcl")
  # dns_role is very fragile - if not set exactly as below, terraform fmt will fail in github actions.
  # This is required for the dynamic provider for DNS configuration. In staging and production, no role assumption is required,
  # so this will be empty. In scratch/dynamic environments, role assumption is required.
  dns_role           = local.vars.inputs.env == "production" || local.vars.inputs.env == "staging" ? "" : "\n  assume_role {\n    role_arn = \"arn:aws:iam::${local.vars.inputs.dns_account_id}:role/${local.vars.inputs.env}_dns_manager_role\"\n  }"
  
}

inputs = {
  account_id                            = local.vars.inputs.account_id
  domain                                = local.vars.inputs.domain
  alt_domain                            = local.vars.inputs.alt_domain
  env                                   = local.vars.inputs.env
  dns_account_id                        = local.vars.inputs.dns_account_id
  log_retention_period_days             = local.vars.inputs.log_retention_period_days
  sensitive_log_retention_period_days   = local.vars.inputs.sensitive_log_retention_period_days
  account_budget_limit                  = local.vars.inputs.account_budget_limit
  new_relic_account_id                  = local.vars.inputs.new_relic_account_id

  
  region             = "ca-central-1"
  # See https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html#access-logging-bucket-permissions
  elb_account_ids = {
    "ca-central-1" = "985666609251"
  }
  
  cbs_satellite_bucket_name = "cbs-satellite-${local.vars.inputs.account_id}"
}

terraform {

  before_hook "before_hook" {
    commands     = local.vars.inputs.env == "dev" ? ["apply", "plan"] : []
    execute      = ["${get_repo_root()}/scripts/checkEnvFile.sh", "${get_repo_root()}/aws/dev.tfvars"]
  }

}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 2.0"
    }
  }
}

provider "newrelic" {
  account_id          = var.new_relic_account_id
  region              = "US"
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

provider "aws" {
  alias  = "dns"
  region = "ca-central-1"${local.dns_role}
}

provider "aws" {
  alias  = "staging"
  region = "ca-central-1"
  assume_role {
    role_arn = "arn:aws:iam::239043911459:role/${local.vars.inputs.env}_dns_manager_role"
  }
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

variable "new_relic_account_id" {
  description = "New Relic Account Id"
  type        = number
}

variable "new_relic_api_key" {
  description = "New Relic Key"
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

variable "cbs_satellite_bucket_name" {
  description = "Name of the Cloud Based Sensor S3 satellite bucket"
  type        = string
}

variable "cloudwatch_enabled" {
  type        = bool
  default     = true
  description = "Use this flag to enable/disable cloudwatch logs. Useful for saving money on scratch accounts"
}

variable "log_retention_period_days" {
  description = "Log retention period in days for normal logs"
  type        = number
  default     = 0
}

variable "sensitive_log_retention_period_days" {
  description = "Log retention period in days for logs with sensitive information"
  type        = number
  default     = 7
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
