locals {
  application_log_group_arn = "arn:aws:logs:${var.region}:${var.account_id}:log-group:${local.eks_application_log_group}"
  client_vpn_log_group_arn  = "arn:aws:logs:${var.region}:${var.account_id}:log-group:${module.vpn.client_vpn_cloudwatch_log_group_name}"
  blazer_log_group_arn      = "arn:aws:logs:${var.region}:${var.account_id}:log-group:blazer"
  postgresql_log_group_arn  = "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/rds/cluster/notification-canada-ca-${var.env}-cluster/postgresql"

  postgres_dangerous_queries       = ["ALTER", "CREATE", "DELETE", "DROP", "GRANT", "REVOKE", "TRUNCATE"]
  postgres_dangerous_queries_lower = [for sql in local.postgres_dangerous_queries : lower(sql)]
}

# The sentinel_forwarder module fails to Terraform apply if the layer_arn being used is not the most recently published layer version
# see https://github.com/cds-snc/terraform-modules/issues/203 
# and https://docs.google.com/document/d/16LLelZ7WEKrnbocrl0Az74JqkCv5DBZ9QILRBUFJQt8/edit#heading=h.z87ipkd84djw
module "sentinel_forwarder" {
  count             = var.enable_sentinel_forwarding ? 1 : 0
  source            = "github.com/cds-snc/terraform-modules//sentinel_forwarder?ref=v9.4.2"
  function_name     = "sentinel-cloud-watch-forwarder"
  billing_tag_value = "notification-canada-ca-${var.env}"

  layer_arn = "arn:aws:lambda:ca-central-1:283582579564:layer:aws-sentinel-connector-layer:126"

  customer_id = var.sentinel_customer_id
  shared_key  = var.sentinel_shared_key

  cloudwatch_log_arns = [
    local.application_log_group_arn,
    local.blazer_log_group_arn,
    local.client_vpn_log_group_arn,
    local.postgresql_log_group_arn
  ]
}


resource "aws_cloudwatch_log_subscription_filter" "admin_api_request" {
  count           = var.enable_sentinel_forwarding ? 1 : 0
  name            = "Admin API request"
  log_group_name  = local.eks_application_log_group
  filter_pattern  = "Admin API request"
  destination_arn = module.sentinel_forwarder[0].lambda_arn
  distribution    = "Random"
}

resource "aws_cloudwatch_log_subscription_filter" "blazer_logging" {
  count           = var.enable_sentinel_forwarding ? 1 : 0
  name            = "Blazer logging"
  log_group_name  = "blazer"
  filter_pattern  = "Audit "
  destination_arn = module.sentinel_forwarder[0].lambda_arn
  distribution    = "Random"
}

resource "aws_cloudwatch_log_subscription_filter" "client_vpn_connections" {
  count           = var.enable_sentinel_forwarding ? 1 : 0
  name            = "Client VPN connections"
  log_group_name  = module.vpn.client_vpn_cloudwatch_log_group_name
  filter_pattern  = "[w1=\"*\"]" # All logs
  destination_arn = module.sentinel_forwarder[0].lambda_arn
  distribution    = "Random"
}

resource "aws_cloudwatch_log_subscription_filter" "postgresql_dangerous_queries" {
  count           = var.enable_sentinel_forwarding ? 1 : 0
  name            = "Postgresql dangerous queries"
  log_group_name  = local.postgresql_log_group_arn
  filter_pattern  = "[(w1=\"*${join("*\" || w1=\"*", concat(local.postgres_dangerous_queries, local.postgres_dangerous_queries_lower))}*\")]"
  destination_arn = module.sentinel_forwarder[0].lambda_arn
  distribution    = "Random"
}
