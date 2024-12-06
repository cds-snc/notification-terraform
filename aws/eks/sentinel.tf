locals {
  application_log_group_arn = "arn:aws:logs:${var.region}:${var.account_id}:log-group:${local.eks_application_log_group}"
  client_vpn_log_group_arn  = "arn:aws:logs:${var.region}:${var.account_id}:log-group:${module.vpn.client_vpn_cloudwatch_log_group_name}"
  # blazer_log_group_arn      = "arn:aws:logs:${var.region}:${var.account_id}:log-group:blazer"
}

data "external" "get_sentinel_layer_version" {
  # Get the Latest Sentinel Layer version
  program = ["helper_scripts/getSentinelLayerVersion.sh", var.sentinel_sre_aws_account_id]

}


# The sentinel_forwarder module fails to Terraform apply if the layer_arn being used is not the most recently published layer version
# see https://github.com/cds-snc/terraform-modules/issues/203 
# and https://docs.google.com/document/d/16LLelZ7WEKrnbocrl0Az74JqkCv5DBZ9QILRBUFJQt8/edit#heading=h.z87ipkd84djw
module "sentinel_forwarder" {
  source            = "github.com/cds-snc/terraform-modules//sentinel_forwarder?ref=v9.6.4"
  function_name     = "sentinel-cloud-watch-forwarder"
  billing_tag_value = "notification-canada-ca-${var.env}"

  layer_arn = "arn:aws:lambda:ca-central-1:${var.sentinel_sre_aws_account_id}:layer:aws-sentinel-connector-layer:${data.external.get_sentinel_layer_version.result.version}"

  customer_id = var.sentinel_customer_id
  shared_key  = var.sentinel_shared_key

  cloudwatch_log_arns = [
    local.application_log_group_arn,
    # local.blazer_log_group_arn,
    local.client_vpn_log_group_arn
  ]
}


resource "aws_cloudwatch_log_subscription_filter" "admin_api_request" {
  count           = var.cloudwatch_enabled ? 1 : 0
  name            = "Admin API request"
  log_group_name  = local.eks_application_log_group
  filter_pattern  = "Admin API request"
  destination_arn = module.sentinel_forwarder.lambda_arn
  distribution    = "Random"
}

# resource "aws_cloudwatch_log_subscription_filter" "blazer_logging" {
#   count           = var.cloudwatch_enabled ? 1 : 0
#   depends_on      = [aws_cloudwatch_log_group.blazer]
#   name            = "Blazer logging"
#   log_group_name  = "blazer"
#   filter_pattern  = "Audit "
#   destination_arn = module.sentinel_forwarder.lambda_arn
#   distribution    = "Random"
# }

resource "aws_cloudwatch_log_subscription_filter" "client_vpn_connections" {
  name            = "Client VPN connections"
  log_group_name  = module.vpn.client_vpn_cloudwatch_log_group_name
  filter_pattern  = "[w1=\"*\"]" # All logs
  destination_arn = module.sentinel_forwarder.lambda_arn
  distribution    = "Random"
}
