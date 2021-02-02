resource "aws_wafv2_web_acl" "assets_cdn" {
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl#scope
  # > To work with CloudFront, you must also specify the region us-east-1 (N. Virginia) on the AWS provider.
  provider = aws.us-east-1

  name  = "assets_cdn"
  scope = "CLOUDFRONT"

  default_action {
    allow {}
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "assets_cdn"
    sampled_requests_enabled   = false
  }
}
