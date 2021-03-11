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

resource "aws_sns_topic" "notification-canada-ca-alert-warning-us-west-2" {
  provider = aws.us-west-2

  name              = "alert-warning-us-west-2"
  kms_master_key_id = aws_kms_key.notification-canada-ca-us-west-2.arn


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

resource "aws_sns_topic" "notification-canada-ca-alert-critical-us-west-2" {
  provider = aws.us-west-2

  name              = "alert-critical-us-west-2"
  kms_master_key_id = aws_kms_key.notification-canada-ca-us-west-2.arn


  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_sns_topic" "notification-canada-ca-alert-general" {
  name = "alert-general"

  # tfsec:ignore:AWS016
  # > Amazon RDS event notification is only available for unencrypted SNS topics.
  # > If you specify an encrypted SNS topic, event notifications aren't sent for the topic.
  #
  # https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_Events.html#USER_Events.Subscribing
  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_sns_sms_preferences" "update-sms-prefs" {
  delivery_status_iam_role_arn          = aws_iam_role.sns-delivery-role.arn
  delivery_status_success_sampling_rate = 100
  monthly_spend_limit                   = var.sns_monthly_spend_limit
}

resource "aws_sns_sms_preferences" "update-sms-prefs-us-west-2" {
  provider = aws.us-west-2

  delivery_status_iam_role_arn          = aws_iam_role.sns-delivery-role.arn
  delivery_status_success_sampling_rate = 100
  monthly_spend_limit                   = var.sns_monthly_spend_limit_us_west_2
}

resource "aws_sns_topic_subscription" "ses_sns_to_lambda" {
  topic_arn = aws_sns_topic.notification-canada-ca-ses-callback.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.ses_to_sqs_email_callbacks.arn
}

resource "aws_sns_topic_subscription" "sns_alert_warning_us_west_2_to_lambda" {
  provider = aws.us-west-2

  topic_arn = aws_sns_topic.notification-canada-ca-alert-warning-us-west-2.arn
  protocol  = "lambda"
  endpoint  = module.notify_slack_warning.notify_slack_lambda_function_arn
}

resource "aws_sns_topic_subscription" "sns_alert_critical_us_west_2_to_lambda" {
  provider = aws.us-west-2

  topic_arn = aws_sns_topic.notification-canada-ca-alert-critical-us-west-2.arn
  protocol  = "lambda"
  endpoint  = module.notify_slack_critical.notify_slack_lambda_function_arn
}

resource "aws_sns_topic_subscription" "alert_to_sns_to_opsgenie" {
  count = var.env == "production" ? 1 : 0

  topic_arn              = aws_sns_topic.notification-canada-ca-alert-critical.arn
  protocol               = "https"
  endpoint               = var.cloudwatch_opsgenie_alarm_webhook
  raw_message_delivery   = false
  endpoint_auto_confirms = true
}

resource "aws_sns_topic_subscription" "alert_critical_us_west_2_to_opsgenie" {
  provider = aws.us-west-2

  count = var.env == "production" ? 1 : 0

  topic_arn              = aws_sns_topic.notification-canada-ca-alert-critical-us-west-2.arn
  protocol               = "https"
  endpoint               = var.cloudwatch_opsgenie_alarm_webhook
  raw_message_delivery   = false
  endpoint_auto_confirms = true
}
