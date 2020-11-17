resource "aws_sns_topic" "notification-canada-ca-ses-callback" {
  name              = "ses-callback"
  kms_master_key_id = aws_kms_key.notification-canada-ca.arn

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_sns_topic" "notification-canada-ca-alert-warning" {
  name              = "alert-warning"
  kms_master_key_id = aws_kms_key.notification-canada-ca.arn

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_sns_topic" "notification-canada-ca-alert-critical" {
  name              = "alert-critical"
  kms_master_key_id = aws_kms_key.notification-canada-ca.arn

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_sns_sms_preferences" "update-sms-prefs" {
  delivery_status_iam_role_arn          = aws_iam_role.sns-delivery-role.arn
  delivery_status_success_sampling_rate = 100
  monthly_spend_limit                   = var.sns_monthly_spend_limit
}

resource "aws_sns_topic_subscription" "ses_sns_to_lambda" {
  topic_arn = aws_sns_topic.notification-canada-ca-ses-callback.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.ses_to_sqs_email_callbacks.arn

  depends_on = [aws_lambda_permission.allow_sns]
}

resource "aws_sns_topic_subscription" "warning_slack_topic" {
  topic_arn = aws_sns_topic.notification-canada-ca-alert-warning.arn
  protocol  = "lambda"
  endpoint  = notify_slack.warning.notify_slack_lambda_function_arn
}

resource "aws_sns_topic_subscription" "critical_slack_topic" {
  topic_arn = aws_sns_topic.notification-canada-ca-alert-critical.arn
  protocol  = "lambda"
  endpoint  = notify_slack.critical.notify_slack_lambda_function_arn
}
