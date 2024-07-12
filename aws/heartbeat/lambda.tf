locals {
  image_tag = var.env == "production" ? var.heartbeat_docker_tag : (var.bootstrap == true ? "bootstrap" : "latest")
}

module "heartbeat" {
  source                 = "github.com/cds-snc/terraform-modules//lambda?ref=v9.0.4"
  name                   = "heartbeat"
  billing_tag_value      = var.billing_tag_value
  ecr_arn                = var.heartbeat_ecr_arn
  enable_lambda_insights = true
  image_uri              = "${var.heartbeat_ecr_repository_url}:${local.image_tag}"
  timeout                = 60
  memory                 = 1024
  alias_name             = "latest"

  environment_variables = {
    heartbeat_api_key    = var.heartbeat_api_key
    heartbeat_base_url   = "['https://api-lambda.${var.domain}', 'https://api-k8s.${var.domain}']"
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
  schedule_expression = var.schedule_expression
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
