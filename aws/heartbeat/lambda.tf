module "heartbeat" {
  source                 = "github.com/cds-snc/terraform-modules//lambda?ref=v0.0.49"
  name                   = "heartbeat"
  billing_tag_value      = var.billing_tag_value
  ecr_arn                = var.heartbeat_ecr_arn
  enable_lambda_insights = true
  image_uri              = "${var.heartbeat_ecr_repository_url}:${var.heartbeat_docker_tag}"
  timeout                = 60
  memory                 = 1024

  environment_variables = {
    heartbeat_api_key     = var.heartbeat_api_key
    heartbeat_base_url    = "['https://api-lambda.${var.base_domain}', 'https://api-k8s.${var.base_domain}']"
    heartbeat_template_id = var.heartbeat_template_id
  }
}

resource "aws_lambda_function_event_invoke_config" "heartbeat_invoke_config" {
  function_name                = module.heartbeat.function_name
  maximum_event_age_in_seconds = 60
  maximum_retry_attempts       = 0
}

resource "aws_cloudwatch_event_target" "heartbeat" {
  arn  = module.heartbeat.function_arn
  rule = aws_cloudwatch_event_rule.heartbeat_testing.id
}

resource "aws_cloudwatch_event_rule" "heartbeat_testing" {
  name                = "heartbeat_testing"
  description         = "heartbeat_testing event rule"
  schedule_expression = var.schedule_expression
  depends_on          = [module.heartbeat]
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.heartbeat.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.heartbeat_testing.arn
}
