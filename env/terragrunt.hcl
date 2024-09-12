locals {
  inputs = jsondecode(read_tfvars_file(find_in_parent_folders("./aws/${get_env("ENVIRONMENT")}.tfvars", "/var/tmp/${get_env("ENVIRONMENT")}.tfvars")))
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

}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.66"
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
  region              = "${local.inputs.region}"
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

# For whatever reason, Dev uses the DNS from the Staging account and 
# Production uses the DNS from the Production account, but also has a 
# different name :/  So we need to handle that here with if Logic

%{ if local.inputs.env == "dev" }
provider "aws" {
  alias  = "dns"
  region = "ca-central-1"
  assume_role {
    role_arn = "arn:aws:iam::${local.inputs.dns_account_id}:role/${local.inputs.env}_dns_manager_role"
  }
}
%{ endif }

%{ if local.inputs.env == "production" }
provider "aws" {
  alias  = "dns"
  region = "ca-central-1"
  assume_role {
    role_arn = "arn:aws:iam::${local.inputs.dns_account_id}:role/notify_${local.inputs.env}_dns_manager"
  }
}
%{ endif }

provider "aws" {
  alias  = "staging"
  region = "ca-central-1"
  assume_role {
    role_arn = "arn:aws:iam::${local.inputs.dns_account_id}:role/${local.inputs.env}_dns_manager_role"
  }
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