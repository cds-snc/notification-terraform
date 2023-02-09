data "archive_file" "sns_to_sqs_sms_callbacks" {
  type        = "zip"
  source_file = "${path.module}/lambdas/sns_to_sqs_sms_callbacks.py"
  output_path = "${path.module}/lambdas/sns_to_sqs_sms_callbacks.zip"
}

resource "aws_lambda_function" "sns_to_sqs_sms_callbacks" {
  filename      = data.archive_file.sns_to_sqs_sms_callbacks.output_path
  function_name = "sns-to-sqs-sms-callbacks"
  role          = aws_iam_role.iam_lambda_to_sqs.arn
  handler       = "sns_to_sqs_sms_callbacks.lambda_handler"

  source_code_hash = data.archive_file.sns_to_sqs_sms_callbacks.output_base64sha256

  runtime = "python3.8"

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

##
# CloudWatch log groups for SNS deliveries in ca-central-1
##
resource "aws_lambda_permission" "allow_cloudwatch_logs_sns_successes" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sns_to_sqs_sms_callbacks.function_name
  principal     = "logs.${var.region}.amazonaws.com"
  source_arn    = "${aws_cloudwatch_log_group.sns_deliveries.arn}:*"
}

resource "aws_lambda_permission" "allow_cloudwatch_logs_sns_failures" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sns_to_sqs_sms_callbacks.function_name
  principal     = "logs.${var.region}.amazonaws.com"
  source_arn    = "${aws_cloudwatch_log_group.sns_deliveries_failures.arn}:*"
}

##
# CloudWatch log groups for SNS deliveries in us-west-2
##
resource "aws_lambda_permission" "allow_cloudwatch_logs_sns_successes_us_west_2" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sns_to_sqs_sms_callbacks.function_name
  principal     = "logs.us-west-2.amazonaws.com"
  source_arn    = "${aws_cloudwatch_log_group.sns_deliveries_us_west_2.arn}:*"
}

resource "aws_lambda_permission" "allow_cloudwatch_logs_sns_failures_us_west_2" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sns_to_sqs_sms_callbacks.function_name
  principal     = "logs.us-west-2.amazonaws.com"
  source_arn    = "${aws_cloudwatch_log_group.sns_deliveries_failures_us_west_2.arn}:*"
}

##
# SNS topics for CloudWatch alarms in us-west-2
##
resource "aws_lambda_permission" "sns_warning_us_west_2_to_slack_lambda" {
  action        = "lambda:InvokeFunction"
  function_name = module.notify_slack_warning.notify_slack_lambda_function_arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.notification-canada-ca-alert-warning-us-west-2.arn
}

resource "aws_lambda_permission" "sns_critical_us_west_2_to_slack_lambda" {
  action        = "lambda:InvokeFunction"
  function_name = module.notify_slack_critical.notify_slack_lambda_function_arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.notification-canada-ca-alert-critical-us-west-2.arn
}

##
# SNS topics for CloudWatch alarms in us-east-1
##
resource "aws_lambda_permission" "sns_warning_us_east_1_to_slack_lambda" {
  action        = "lambda:InvokeFunction"
  function_name = module.notify_slack_warning.notify_slack_lambda_function_arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.notification-canada-ca-alert-warning-us-east-1.arn
}

resource "aws_lambda_permission" "sns_critical_us_east_1_to_slack_lambda" {
  action        = "lambda:InvokeFunction"
  function_name = module.notify_slack_critical.notify_slack_lambda_function_arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.notification-canada-ca-alert-critical-us-east-1.arn
}

resource "aws_lambda_permission" "sns_ok_us_east_1_to_slack_lambda" {
  action        = "lambda:InvokeFunction"
  function_name = module.notify_slack_ok.notify_slack_lambda_function_arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.notification-canada-ca-alert-ok-us-east-1.arn
}
