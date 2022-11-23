locals {
  application_log_group_arn = "arn:aws:logs:${var.region}:${var.account_id}:log-group:${local.eks_application_log_group}"
}

module "sentinel_forwarder" {
  source            = "github.com/cds-snc/terraform-modules?ref=v4.0.2//sentinel_forwarder"
  function_name     = "sentinel-cloud-watch-forwarder"
  billing_tag_value = "notification-canada-ca-${var.env}"

  customer_id = var.sentinel_customer_id
  shared_key  = var.sentinel_shared_key

  cloudwatch_log_arns = [local.application_log_group_arn]
}


resource "aws_cloudwatch_log_subscription_filter" "admin_api_request" {
  name            = local.scan_verdict_suspicious
  log_group_name  = local.eks_application_log_group
  filter_pattern  = "Admin API request"
  destination_arn = module.sentinel_forwarder.lambda_arn
  distribution    = "Random"
}
