module "heartbeat" {
  source                 = "github.com/cds-snc/terraform-modules?ref=v0.0.45//lambda"
  name                   = "heartbeat"
  billing_tag_value      = var.billing_tag_value
  ecr_arn                = aws_ecr_repository.heartbeat.arn
  enable_lambda_insights = true
  image_uri              = "${aws_ecr_repository.heartbeat.repository_url}:latest"
  timeout                = 60
  memory                 = 1024

  environment_variables = {
    heartbeat_api_key     = var.heartbeat_api_key
    heartbeat_base_url    = var.heartbeat_base_url
    heartbeat_template_id = var.heartbeat_template_id
  }
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
  source_arn    = module.heartbeat.function_arn
}
