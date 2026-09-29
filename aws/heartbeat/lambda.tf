data "github_repository_file" "manifests_env" {
  count      = local.use_manifest_image ? 1 : 0
  repository = "notification-manifests"
  branch     = "main"
  file       = "helmfile/overrides/${var.env}.env"
}

locals {
  use_manifest_image  = var.env != "sandbox" && !var.bootstrap
  image_tag           = local.use_manifest_image ? yamldecode(data.github_repository_file.manifests_env[0].content)["HEARTBEAT_DOCKER_TAG"] : null
  ecr_repository_name = join("/", slice(split("/", var.heartbeat_ecr_repository_url), 1, length(split("/", var.heartbeat_ecr_repository_url))))
  ecr_image_available = local.use_manifest_image && var.heartbeat_ecr_repository_url != "" && !startswith(var.heartbeat_ecr_repository_url, "123456789012.")
}

data "aws_ecr_image" "heartbeat" {
  count           = local.ecr_image_available ? 1 : 0
  repository_name = local.ecr_repository_name
  image_tag       = local.image_tag
}

module "heartbeat" {
  source                 = "github.com/cds-snc/terraform-modules//lambda?ref=94729229cfcb754146c82a566227e55df6612228" # v11.3.5
  name                   = "heartbeat"
  billing_tag_value      = var.billing_tag_value
  ecr_arn                = var.heartbeat_ecr_arn
  enable_lambda_insights = true
  image_uri              = local.ecr_image_available ? data.aws_ecr_image.heartbeat[0].image_uri : "${var.heartbeat_ecr_repository_url}:${var.bootstrap ? "bootstrap" : "latest"}"
  timeout                = 60
  memory                 = 1024
  alias_name             = "latest"

  environment_variables = {
    heartbeat_api_key    = var.heartbeat_api_key
    heartbeat_base_url   = "['https://api.${var.base_domain}']"
    heartbeat_sms_number = var.heartbeat_sms_number
  }
}

resource "aws_lambda_function_event_invoke_config" "heartbeat_invoke_config" {
  function_name                = module.heartbeat.function_name
  maximum_event_age_in_seconds = 60
  maximum_retry_attempts       = 0
}

resource "aws_cloudwatch_event_target" "heartbeat" {
  count = var.cloudwatch_enabled ? 1 : 0
  arn   = module.heartbeat.function_arn
  rule  = aws_cloudwatch_event_rule.heartbeat_testing[0].id
}

resource "aws_cloudwatch_event_rule" "heartbeat_testing" {
  count               = var.cloudwatch_enabled ? 1 : 0
  name                = "heartbeat_testing"
  description         = "heartbeat_testing event rule"
  schedule_expression = var.heartbeat_schedule_expression
  depends_on          = [module.heartbeat]
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  count         = var.cloudwatch_enabled ? 1 : 0
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.heartbeat.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.heartbeat_testing[0].arn
}
