resource "aws_cloudwatch_log_subscription_filter" "sns_to_lambda" {
  name            = "sns_to_lambda"
  log_group_name  = "sns/${var.region}/${var.account_id}/DirectPublishToPhoneNumber"
  filter_pattern  = ""
  destination_arn = aws_lambda_function.sns_to_sqs_sms_callbacks.arn
}

resource "aws_cloudwatch_log_subscription_filter" "sns_failures_to_lambda" {
  name            = "sns_failures_to_lambda"
  log_group_name  = "sns/${var.region}/${var.account_id}/DirectPublishToPhoneNumber/Failure"
  filter_pattern  = ""
  destination_arn = aws_lambda_function.sns_to_sqs_sms_callbacks.arn
}
