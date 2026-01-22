##
# SNS topics for CloudWatch alarms in us-west-2
# Only needed for production (Lambda-based integration)
##
resource "aws_lambda_permission" "sns_warning_us_west_2_to_slack_lambda" {
  count         = var.env == "production" ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = module.notify_slack_warning[0].notify_slack_lambda_function_arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.notification-canada-ca-alert-warning-us-west-2.arn
}

resource "aws_lambda_permission" "sns_critical_us_west_2_to_slack_lambda" {
  count         = var.env == "production" ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = module.notify_slack_critical[0].notify_slack_lambda_function_arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.notification-canada-ca-alert-critical-us-west-2.arn
}

##
# SNS topics for CloudWatch alarms in us-east-1
# Only needed for production (Lambda-based integration)
##
resource "aws_lambda_permission" "sns_warning_us_east_1_to_slack_lambda" {
  count         = var.env == "production" ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = module.notify_slack_warning[0].notify_slack_lambda_function_arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.notification-canada-ca-alert-warning-us-east-1.arn
}

resource "aws_lambda_permission" "sns_critical_us_east_1_to_slack_lambda" {
  count         = var.env == "production" ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = module.notify_slack_critical[0].notify_slack_lambda_function_arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.notification-canada-ca-alert-critical-us-east-1.arn
}

resource "aws_lambda_permission" "sns_ok_us_east_1_to_slack_lambda" {
  count         = var.env == "production" ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = module.notify_slack_ok[0].notify_slack_lambda_function_arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.notification-canada-ca-alert-ok-us-east-1.arn
}
