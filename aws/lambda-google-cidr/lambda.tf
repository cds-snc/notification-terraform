module "lambda-google-cidr" {
  source                 = "github.com/cds-snc/terraform-modules?ref=v4.0.1//lambda"
  name                   = "google-cidr"
  billing_tag_value      = var.billing_tag_value
  ecr_arn                = aws_ecr_repository.google-cidr.arn
  enable_lambda_insights = true
  image_uri              = "${aws_ecr_repository.google-cidr.repository_url}:latest"
  timeout                = 60
  memory                 = 1024

  environment_variables = {
    PREFIX_LIST_ID = var.google_cidr_prefix_list_id
  }
}

resource "aws_lambda_function_event_invoke_config" "google_cidr_invoke_config" {
  function_name                = module.lambda-google-cidr.function_name
  maximum_event_age_in_seconds = 60
  maximum_retry_attempts       = 0
}

resource "aws_cloudwatch_event_target" "google_cidr" {
  arn  = module.lambda-google-cidr.function_arn
  rule = aws_cloudwatch_event_rule.google_cidr.id
}

resource "aws_cloudwatch_event_rule" "google_cidr" {
  name                = "google_cidr_testing"
  description         = "google_cidr_testing event rule"
  schedule_expression = var.google_cidr_schedule_expression
  depends_on          = [module.lambda-google-cidr]
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda-google-cidr.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.google_cidr.arn
}
