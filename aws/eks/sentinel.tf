locals {
  application_log_group_arn = "arn:aws:logs:${var.region}:${var.account_id}:log-group:${local.eks_application_log_group}"
  client_vpn_log_group_arn  = "arn:aws:logs:${var.region}:${var.account_id}:log-group:${module.vpn.client_vpn_cloudwatch_log_group_name}"
  blazer_log_group_arn      = "arn:aws:logs:${var.region}:${var.account_id}:log-group:blazer"
}

data "external" "get_sentinel_layer_version" {
  # Get the Latest Sentinel Layer version
  program = ["helper_scripts/getSentinelLayerVersion.sh", var.sentinel_sre_aws_account_id]

}


# The sentinel_forwarder module fails to Terraform apply if the layer_arn being used is not the most recently published layer version
# see https://github.com/cds-snc/terraform-modules/issues/203 
# and https://docs.google.com/document/d/16LLelZ7WEKrnbocrl0Az74JqkCv5DBZ9QILRBUFJQt8/edit#heading=h.z87ipkd84djw
module "sentinel_forwarder" {
  source            = "github.com/cds-snc/terraform-modules//sentinel_forwarder?ref=b0d9304e1d757150c5f20e3d01f101b8d4f0f54b" # v13.1.0
  function_name     = "sentinel-cloud-watch-forwarder"
  billing_tag_value = "notification-canada-ca-${var.env}"

  # Always the latest layer version, which is 273 or later: the first that
  # reads SENTINEL_HUB_ROLE_ARN (aws-sentinel-connector-layer#306).
  layer_arn = "arn:aws:lambda:ca-central-1:${var.sentinel_sre_aws_account_id}:layer:aws-sentinel-connector-layer:${data.external.get_sentinel_layer_version.result.version}"

  # Kept so rollback is a config change: the layer ignores these once
  # dce_endpoint and dcr_config are set. They are removed with the v1 path.
  customer_id = var.sentinel_customer_id
  shared_key  = var.sentinel_shared_key

  # v2 (Logs Ingestion API). No stored secret: the Lambda's role assumes the
  # Sentinel forwarder hub role in Log Archive (cds-snc/cds-aws-lz), mints a
  # token there with IAM outbound identity federation, and Entra accepts it for
  # the managed identity sentinel-forwarder-v2-aws-hub. Nothing is set up in
  # this account. The hub only admits accounts in the Production, Staging,
  # SRETools and Security OUs. These name Azure resources in cds-snc/sentinel
  # and cds-snc/cds-azure-resources.
  dce_endpoint = "https://dce-sentinel-forwarder-v2-153n.canadacentral-1.ingest.monitor.azure.com"
  dcr_config = {
    AWSCloudWatchLog = {
      dcrImmutableId = "dcr-6eccfc9e7ef34cd293566d5073d551f6"
      streamName     = "Custom-AWSCloudWatchLog_v2_Input"
    }
  }
  azure_client_id = "97057b1c-9b09-4dd3-a4f9-d9df6d181949"
  azure_tenant_id = "221ca1d3-b3f2-4346-8abc-88f802495c7d"
  hub_role_arn    = "arn:aws:iam::274536870005:role/sentinel-forwarder-hub"

  cloudwatch_log_arns = [
    local.application_log_group_arn,
    local.blazer_log_group_arn,
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

resource "aws_cloudwatch_log_subscription_filter" "blazer_logging" {
  count           = var.cloudwatch_enabled ? 1 : 0
  depends_on      = [aws_cloudwatch_log_group.blazer]
  name            = "Blazer logging"
  log_group_name  = "blazer"
  filter_pattern  = "Audit "
  destination_arn = module.sentinel_forwarder.lambda_arn
  distribution    = "Random"
}

resource "aws_cloudwatch_log_subscription_filter" "client_vpn_connections" {
  name            = "Client VPN connections"
  log_group_name  = module.vpn.client_vpn_cloudwatch_log_group_name
  filter_pattern  = "[w1=\"*\"]" # All logs
  destination_arn = module.sentinel_forwarder.lambda_arn
  distribution    = "Random"
}
