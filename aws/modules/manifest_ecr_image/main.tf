terraform {
  required_providers {
    github = {
      source = "integrations/github"
    }
  }
}

locals {
  manifest_environment = var.environment == "sandbox" ? "staging" : var.environment
  manifest_content     = yamldecode(data.github_repository_file.environment.content)
  image_tag            = try(local.manifest_content[var.tag_key], "")
}

# This URI seeds Terraform-created functions. The shared Lambda module ignores
# later image_uri changes; environment deployment workflows own runtime updates.

data "github_repository_file" "environment" {
  repository = "notification-manifests"
  branch     = var.manifest_ref
  file       = "helmfile/overrides/${local.manifest_environment}.env"
}