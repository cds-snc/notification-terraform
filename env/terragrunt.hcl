locals {
  inputs = jsondecode(read_tfvars_file(find_in_parent_folders("./aws/${get_env("ENVIRONMENT")}.tfvars")))
}

inputs = merge(
  local.inputs,
  {
    elb_account_ids = {
      "${local.inputs.region}" = "${local.inputs.elb_account_id}"
    }
    cbs_satellite_bucket_name = "cbs-satellite-${local.inputs.account_id}"
  }
)

terraform {

  before_hook "before_hook" {
    commands     = local.inputs.env == "dev" ? ["apply", "plan"] : []
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
      version = "~> 3.3"
    }
  }
}

provider "aws" {
  region              = var.region
  allowed_account_ids = [${local.inputs.account_id}]
}

provider "aws" {
  alias               = "us-west-2"
  region              = "us-west-2"
  allowed_account_ids = [${local.inputs.account_id}]
}

provider "aws" {
  alias               = "us-east-1"
  region              = "us-east-1"
  allowed_account_ids = [${local.inputs.account_id}]
}

provider "aws" {
  alias  = "dns"
  region = "ca-central-1"
  assume_role {
    role_arn = "arn:aws:iam::${local.inputs.dns_account_id}:role/notify_${local.inputs.env}_dns_manager"
  }
}

provider "aws" {
  alias  = "staging"
  region = "ca-central-1"
  assume_role {
    role_arn = "arn:aws:iam::${local.inputs.account_id}:role/${local.inputs.env}_dns_manager_role"
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
    bucket              = "notification-canada-ca-${local.inputs.env}-tf"
    dynamodb_table      = "terraform-state-lock-dynamo"
    region              = "ca-central-1"
    key                 = "${path_relative_to_include()}/terraform.tfstate"
    s3_bucket_tags      = { CostCenter : "notification-canada-ca-${local.inputs.env}" }
    dynamodb_table_tags = { CostCenter : "notification-canada-ca-${local.inputs.env}" }
  }
}
