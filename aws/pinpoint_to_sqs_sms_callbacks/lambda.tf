module "pinpoint_to_sqs_sms_callbacks" {
  source                     = "github.com/cds-snc/terraform-modules//lambda?ref=v7.4.3"
  name                       = "pinpoint_to_sqs_sms_callbacks"
  billing_tag_value          = var.billing_tag_value
  ecr_arn                    = var.pinpoint_to_sqs_sms_callbacks_ecr_arn
  enable_lambda_insights     = true
  image_uri                  = "${var.pinpoint_to_sqs_sms_callbacks_ecr_repository_url}:${var.pinpoint_to_sqs_sms_callbacks_docker_tag}"
  timeout                    = 60
  memory                     = 1024
  log_group_retention_period = var.sensitive_log_retention_period_days

  policies = [
    data.aws_iam_policy_document.pinpoint_to_sqs_sms_callbacks.json
  ]
}

data "aws_iam_policy_document" "pinpoint_to_sqs_sms_callbacks" {
  statement {
    actions = [
      "sqs:Get*",
      "sqs:SendMessage"
    ]
    effect    = "Allow"
    resources = [var.sqs_deliver_receipts_queue_arn]
  }
}

resource "aws_lambda_permission" "allow_cloudwatch_logs_pinpoint_successes" {
  count         = var.cloudwatch_enabled ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = module.pinpoint_to_sqs_sms_callbacks.function_name
  principal     = "logs.${var.region}.amazonaws.com"
  source_arn    = "${aws_cloudwatch_log_group.pinpoint_deliveries[0].arn}:*"
}

resource "aws_cloudwatch_log_subscription_filter" "pinpoint_deliveries_ca_central_to_lambda" {
  count           = var.cloudwatch_enabled ? 1 : 0
  name            = "pinpoint_deliveries_ca_central"
  log_group_name  = aws_cloudwatch_log_group.pinpoint_deliveries[0].name
  filter_pattern  = ""
  destination_arn = module.pinpoint_to_sqs_sms_callbacks.function_arn
}

resource "aws_lambda_permission" "allow_cloudwatch_logs_pinpoint_failures" {
  count         = var.cloudwatch_enabled ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = module.pinpoint_to_sqs_sms_callbacks.function_name
  principal     = "logs.${var.region}.amazonaws.com"
  source_arn    = "${aws_cloudwatch_log_group.pinpoint_deliveries_failures[0].arn}:*"
}

resource "aws_cloudwatch_log_subscription_filter" "pinpoint_deliveries_failures_ca_central_to_lambda" {
  count           = var.cloudwatch_enabled ? 1 : 0
  name            = "pinpoint_deliveries_failures_ca_central"
  log_group_name  = aws_cloudwatch_log_group.pinpoint_deliveries_failures[0].name
  filter_pattern  = ""
  destination_arn = module.pinpoint_to_sqs_sms_callbacks.function_arn
}
