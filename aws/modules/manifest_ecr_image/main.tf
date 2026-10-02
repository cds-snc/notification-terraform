terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    github = {
      source = "integrations/github"
    }
  }
}

locals {
  manifest_environment = var.environment == "sandbox" ? "staging" : var.environment
  manifest_content     = yamldecode(data.github_repository_file.environment.content)
  image_tag            = try(local.manifest_content[var.tag_key], "")
  repository_uri       = "${var.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.repository_name}"
}

# This URI seeds Terraform-created functions. The shared Lambda module ignores
# later image_uri changes; environment deployment workflows own runtime updates.

data "github_repository_file" "environment" {
  repository = "notification-manifests"
  branch     = var.manifest_ref
  file       = "helmfile/overrides/${local.manifest_environment}.env"
}

data "aws_ecr_image" "selected" {
  count           = var.verify_ecr_image ? 1 : 0
  repository_name = var.repository_name
  image_tag       = local.image_tag

  lifecycle {
    precondition {
      condition     = can(regex("^[0-9a-f]{7,40}$", local.image_tag))
      error_message = "${var.tag_key} in ${local.manifest_environment}.env must be a commit SHA tag."
    }
  }
}