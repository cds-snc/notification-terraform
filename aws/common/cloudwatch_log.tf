resource "aws_cloudwatch_log_group" "sns_deliveries" {
  name = "sns/${var.region}/${var.account_id}/DirectPublishToPhoneNumber"

  depends_on = [aws_lambda_permission.allow_cloudwatch]

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_cloudwatch_log_group" "sns_deliveries_failures" {
  name = "sns/${var.region}/${var.account_id}/DirectPublishToPhoneNumber/Failure"

  depends_on = [aws_lambda_permission.allow_cloudwatch]

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
