locals {
  vars = read_terragrunt_config("../env_vars.hcl")
}

inputs = {
  account_id = "${local.vars.inputs.account_id}"
  domain     = "${local.vars.inputs.domain}"
  alt_domain = "${local.vars.inputs.alt_domain}"
  env        = "${local.vars.inputs.env}"
  region     = "ca-central-1"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region              = var.region
  version             = "~> 2.0"
  allowed_account_ids = [var.account_id]
}
EOF
}

generate "common_variables" {
  path      = "common_variables.tf"
  if_exists = "overwrite"
  contents  = <<EOF
variable account_id {
  description = "(Required) The account ID to perform actions on."
  type        = string
}

variable domain {
  description = "The current domain"
  type        = string
}

variable alt_domain {
  description = "The alternative domain, if it exists"
  type        = string
}

variable env {
  description = "The current running environment"
  type        = string
}

variable region {
  description = "The current AWS region"
  type        = string
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
