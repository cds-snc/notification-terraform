module "sns_to_sqs_sms_callbacks" {
  source                     = "github.com/cds-snc/terraform-modules//lambda?ref=v7.4.3"
  name                       = "sns_to_sqs_sms_callbacks"
  billing_tag_value          = var.billing_tag_value
  ecr_arn                    = var.sns_to_sqs_sms_callbacks_ecr_arn
  enable_lambda_insights     = true
  image_uri                  = "${var.sns_to_sqs_sms_callbacks_ecr_repository_url}:${var.sns_to_sqs_sms_callbacks_docker_tag}"
  timeout                    = 60
  memory                     = 1024
  log_group_retention_period = var.sensitive_log_retention_period_days

  policies = [
    data.aws_iam_policy_document.sns_to_sqs_sms_callbacks.json
  ]
}

data "aws_sqs_queue" "delivery-receipts" {
  name = "eks-notification-canada-cadelivery-receipts"
}

data "aws_iam_policy_document" "sns_to_sqs_sms_callbacks" {
  statement {
    actions = [
      "sqs:Get*",
      "sqs:SendMessage"
    ]
    effect    = "Allow"
    resources = [data.aws_sqs_queue.delivery-receipts.arn]
  }
}

##
# CloudWatch log groups for SNS deliveries in ca-central-1
##
resource "aws_lambda_permission" "allow_cloudwatch_logs_sns_successes" {
  count         = var.cloudwatch_enabled ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = module.sns_to_sqs_sms_callbacks.function_name
  principal     = "logs.${var.region}.amazonaws.com"
  source_arn    = "${var.sns_deliveries_ca_central_arn}:*"
}

resource "aws_cloudwatch_log_subscription_filter" "sns_deliveries_ca_central_to_lambda" {
  count           = var.cloudwatch_enabled ? 1 : 0
  name            = "sns_deliveries_ca_central"
  log_group_name  = var.sns_deliveries_ca_central_name
  filter_pattern  = ""
  destination_arn = module.sns_to_sqs_sms_callbacks.function_arn
}

resource "aws_lambda_permission" "allow_cloudwatch_logs_sns_failures" {
  count         = var.cloudwatch_enabled ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = module.sns_to_sqs_sms_callbacks.function_name
  principal     = "logs.${var.region}.amazonaws.com"
  source_arn    = "${var.sns_deliveries_failures_ca_central_arn}:*"
}

resource "aws_cloudwatch_log_subscription_filter" "sns_deliveries_failures_ca_central_to_lambda" {
  count           = var.cloudwatch_enabled ? 1 : 0
  name            = "sns_deliveries_failures_ca_central"
  log_group_name  = var.sns_deliveries_failures_ca_central_name
  filter_pattern  = ""
  destination_arn = module.sns_to_sqs_sms_callbacks.function_arn
}

##
# CloudWatch log groups for SNS deliveries in us-west-2
##
resource "aws_lambda_permission" "allow_cloudwatch_logs_sns_successes_us_west_2" {
  count         = var.cloudwatch_enabled ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = module.sns_to_sqs_sms_callbacks.function_name
  principal     = "logs.us-west-2.amazonaws.com"
  source_arn    = "${var.sns_deliveries_us_west_2_arn}:*"
}

resource "aws_cloudwatch_log_subscription_filter" "sns_deliveries_us_west_2_to_lambda" {
  count           = var.cloudwatch_enabled ? 1 : 0
  provider        = aws.us-west-2
  name            = "sns_deliveries_us_west_2_to_lambda"
  log_group_name  = var.sns_deliveries_us_west_2_name
  filter_pattern  = ""
  destination_arn = module.sns_to_sqs_sms_callbacks.function_arn
}

resource "aws_lambda_permission" "allow_cloudwatch_logs_sns_failures_us_west_2" {
  count         = var.cloudwatch_enabled ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = module.sns_to_sqs_sms_callbacks.function_name
  principal     = "logs.us-west-2.amazonaws.com"
  source_arn    = "${var.sns_deliveries_failures_us_west_2_arn}:*"
}

resource "aws_cloudwatch_log_subscription_filter" "sns_deliveries_failures_us_west_2_to_lambda" {
  count           = var.cloudwatch_enabled ? 1 : 0
  provider        = aws.us-west-2
  name            = "sns_deliveries_failures_us_west_2_to_lambda"
  log_group_name  = var.sns_deliveries_failures_us_west_2_name
  filter_pattern  = ""
  destination_arn = module.sns_to_sqs_sms_callbacks.function_arn
}
