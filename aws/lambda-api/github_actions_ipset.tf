# External data source to fetch GitHub Actions IP ranges dynamically
data "external" "github_actions_ips" {
  program = ["helper_scripts/update_github_actions_ips.sh"]

  # This ensures the data is refreshed on every plan/apply
  # Remove this if you want to cache the results
  query = {
    timestamp = timestamp()
  }
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
    LastUpdate = timestamp()
  }

  lifecycle {
    # Prevent destruction if IP ranges change
    create_before_destroy = true
  }
}

# Output the ARN for use in WAF rules
output "github_actions_ip_set_arn" {
  description = "ARN of the GitHub Actions IP set"
  value       = aws_wafv2_ip_set.github_actions.arn
}

# Output the number of IP ranges for monitoring
output "github_actions_ip_count" {
  description = "Number of GitHub Actions IP ranges"
  value       = length(local.github_actions_ips)
}

# Output to show if we're using fallback IPs
output "github_actions_using_fallback" {
  description = "Whether fallback IP ranges are being used"
  value       = length(local.github_actions_ips) <= 10
}