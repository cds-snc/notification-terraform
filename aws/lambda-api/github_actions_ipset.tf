# External data source to fetch GitHub Actions IP ranges dynamically
data "external" "github_actions_ips" {
  program = ["helper_scripts/update_github_actions_ips.sh"]
}

# Local value to handle potential errors from the external data source
locals {
  github_actions_ips = try(
    jsondecode(data.external.github_actions_ips.result.ip_ranges),
    [
      # Fallback IP ranges in case GitHub API is unavailable
      # These are some common GitHub Actions ranges as of 2024
      "4.148.0.0/16",
      "4.149.0.0/18",
      "20.1.128.0/17",
      "20.3.0.0/16"
    ]
  )
}

# GitHub Actions IP Set for WAF exception
# This IP set contains the GitHub Actions runner IP ranges to allow them through geo-restrictions
resource "aws_wafv2_ip_set" "github_actions" {
  name               = "github-actions-ip-set"
  description        = "IP ranges for GitHub Actions runners auto-updated"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"

  # Dynamically fetched GitHub Actions IP ranges with fallback
  addresses = local.github_actions_ips

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
    Purpose    = "GitHub Actions WAF exception"
    Terraform  = true
  }

  lifecycle {
    # Prevent destruction if IP ranges change
    create_before_destroy = true
  }
}