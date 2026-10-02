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
  repository_name      = join("/", slice(split("/", var.repository_url), 1, length(split("/", var.repository_url))))
}

data "github_repository_file" "environment" {
  repository = "notification-manifests"
  branch     = "main"
  file       = "helmfile/overrides/${local.manifest_environment}.env"
}

data "aws_ecr_image" "selected" {
  repository_name = local.repository_name
  image_tag       = local.image_tag

  lifecycle {
    precondition {
      condition     = can(regex("^[0-9a-f]{7,40}$", local.image_tag))
      error_message = "${var.tag_key} in ${local.manifest_environment}.env must be a commit SHA tag."
    }
  }
}