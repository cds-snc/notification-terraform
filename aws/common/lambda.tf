data "archive_file" "ses_to_sqs_email_callbacks" {
  type        = "zip"
  source_file = "${path.module}/lambdas/ses_to_sqs_email_callbacks.py"
  output_path = "${path.module}/lambdas/ses_to_sqs_email_callbacks.zip"
}

resource "aws_lambda_function" "ses_to_sqs_email_callbacks" {
  filename      = data.archive_file.ses_to_sqs_email_callbacks.output_path
  function_name = "ses-to-sqs-email-callbacks"
  role          = aws_iam_role.iam_lambda_to_sqs.arn
  handler       = "ses_to_sqs_email_callbacks.lambda_handler"

  source_code_hash = data.archive_file.ses_to_sqs_email_callbacks.output_base64sha256

  runtime = "python3.8"

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

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

resource "aws_lambda_permission" "allow_cloudwatch_events" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sns_to_sqs_sms_callbacks.function_name
  principal     = "events.amazonaws.com"
}

resource "aws_lambda_permission" "allow_cloudwatch_logs" {
  statement_id  = "AllowExecutionFromCloudWatchLogs"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sns_to_sqs_sms_callbacks.function_name
  principal     = "logs.amazonaws.com"
}

resource "aws_lambda_permission" "allow_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ses_to_sqs_email_callbacks.function_name
  principal     = "sns.amazonaws.com"
}

resource "aws_lambda_permission" "sns_warning_us_west_2_to_slack_lambda" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = module.notify_slack_warning.notify_slack_lambda_function_arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.notification-canada-ca-alert-warning-us-west-2.arn
}

resource "aws_lambda_permission" "sns_critical_us_west_2_to_slack_lambda" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = module.notify_slack_critical.notify_slack_lambda_function_arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.notification-canada-ca-alert-critical-us-west-2.arn
}
