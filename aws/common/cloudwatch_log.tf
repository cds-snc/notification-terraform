resource "aws_cloudwatch_log_group" "sns_deliveries" {
  name = "sns/${var.region}/${var.account_id}/DirectPublishToPhoneNumber"

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_cloudwatch_log_group" "sns_deliveries_failures" {
  name = "sns/${var.region}/${var.account_id}/DirectPublishToPhoneNumber/Failure"

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_cloudwatch_log_group" "ses_receiving_emails" {
  name = "/aws/lambda/${aws_lambda_function.ses_receiving_emails.function_name}"

  retention_in_days = 90

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_cloudwatch_log_group" "sns_deliveries_us_west_2" {
  provider = aws.us-west-2

  name = "sns/us-west-2/${var.account_id}/DirectPublishToPhoneNumber"

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_cloudwatch_log_group" "sns_deliveries_failures_us_west_2" {
  provider = aws.us-west-2

  name = "sns/us-west-2/${var.account_id}/DirectPublishToPhoneNumber/Failure"

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_cloudwatch_log_subscription_filter" "sns_to_lambda" {
  name            = "sns_to_lambda"
  log_group_name  = aws_cloudwatch_log_group.sns_deliveries.name
  filter_pattern  = ""
  destination_arn = aws_lambda_function.sns_to_sqs_sms_callbacks.arn
}

resource "aws_cloudwatch_log_subscription_filter" "sns_failures_to_lambda" {
  name            = "sns_failures_to_lambda"
  log_group_name  = aws_cloudwatch_log_group.sns_deliveries_failures.name
  filter_pattern  = ""
  destination_arn = aws_lambda_function.sns_to_sqs_sms_callbacks.arn
}

resource "aws_cloudwatch_log_subscription_filter" "sns_sms_us_west_2_to_lambda" {
  provider = aws.us-west-2

  name            = "sns_sms_us_west_2_to_lambda"
  log_group_name  = aws_cloudwatch_log_group.sns_deliveries_us_west_2.name
  filter_pattern  = ""
  destination_arn = aws_lambda_function.sns_to_sqs_sms_callbacks.arn
}

resource "aws_cloudwatch_log_subscription_filter" "sns_sms_failures_us_west_2_to_lambda" {
  provider = aws.us-west-2

  name            = "sns_sms_failures_us_west_2_to_lambda"
  log_group_name  = aws_cloudwatch_log_group.sns_deliveries_failures_us_west_2.name
  filter_pattern  = ""
  destination_arn = aws_lambda_function.sns_to_sqs_sms_callbacks.arn
}
