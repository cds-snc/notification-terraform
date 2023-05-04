include {
  path = find_in_parent_folders()
}

locals {
  vars = read_terragrunt_config("../env_vars.hcl")
}

terraform {
  source = "../../../aws//ecr"

  after_hook "cleanup" {
    commands     = ["apply"]
    execute      = ["rm", "-rfd", "/var/tmp/notification-api"]
    run_on_error = true
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
      version = "~> 4.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 2.12, < 3.0"
    }
  }
}

provider "aws" {
  region              = var.region
  allowed_account_ids = [var.account_id]
}

provider "docker" {
  registry_auth {
    address  = "${local.vars.inputs.account_id}.dkr.ecr.${local.vars.inputs.region}.amazonaws.com"
    config_file = pathexpand("~/.docker/config.json")
  }
}

EOF
}