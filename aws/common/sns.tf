resource "aws_sns_topic" "notification-canada-ca-ses-callback" {
  name              = "ses-callback"
  kms_master_key_id = aws_kms_key.notification-canada-ca.arn

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_sns_topic" "notification-canada-ca-alert-ok" {
  name              = "alert-ok"
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

resource "aws_sns_topic" "notification-canada-ca-alert-ok-us-west-2" {
  provider = aws.us-west-2

  name              = "alert-ok-us-west-2"
  kms_master_key_id = aws_kms_key.notification-canada-ca-us-west-2.arn

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
  name              = "alert-general"
  kms_master_key_id = aws_kms_key.notification-canada-ca.arn
  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSBudgetsSNSPublishingPermissions",
      "Effect": "Allow",
      "Principal": {
        "Service": "budgets.amazonaws.com"
      },
      "Action": "SNS:Publish",
      "Resource": "arn:aws:sns:ca-central-1:${var.account_id}:alert-general",
      "Condition": {
        "StringEquals": {
          "aws:SourceAccount": "${var.account_id}"
        },
        "ArnLike": {
          "aws:SourceArn": "arn:aws:budgets::${var.account_id}:*"
        }
      }
    },
    {
      "Sid": "__default_statement_ID",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "SNS:GetTopicAttributes",
        "SNS:SetTopicAttributes",
        "SNS:AddPermission",
        "SNS:RemovePermission",
        "SNS:DeleteTopic",
        "SNS:Subscribe",
        "SNS:ListSubscriptionsByTopic",
        "SNS:Publish"
      ],
      "Resource": "arn:aws:sns:ca-central-1:${var.account_id}:alert-general",
      "Condition": {
        "StringEquals": {
          "AWS:SourceOwner": "${var.account_id}"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_sns_sms_preferences" "update-sms-prefs" {
  delivery_status_iam_role_arn          = aws_iam_role.sns-delivery-role.arn
  delivery_status_success_sampling_rate = 100
  monthly_spend_limit                   = var.sns_monthly_spend_limit
  usage_report_s3_bucket                = module.sns_sms_usage_report_bucket.s3_bucket_id
  default_sender_id                     = "CANADA-CA"
  default_sms_type                      = "Transactional"
}

resource "aws_sns_sms_preferences" "update-sms-prefs-us-west-2" {
  provider = aws.us-west-2

  delivery_status_iam_role_arn          = aws_iam_role.sns-delivery-role.arn
  delivery_status_success_sampling_rate = 100
  monthly_spend_limit                   = var.sns_monthly_spend_limit_us_west_2
  usage_report_s3_bucket                = module.sns_sms_usage_report_bucket_us_west_2.s3_bucket_id
  default_sender_id                     = "CANADA-CA"
  default_sms_type                      = "Transactional"
}

resource "aws_sns_topic_subscription" "sqs_callback_subscription" {
  topic_arn            = aws_sns_topic.notification-canada-ca-ses-callback.arn
  protocol             = "sqs"
  endpoint             = aws_sqs_queue.ses_receipt_callback_buffer.arn
  raw_message_delivery = true
}

resource "aws_sns_topic_subscription" "sns_alert_ok_us_west_2_to_lambda" {
  count    = var.env == "production" ? 1 : 0
  provider = aws.us-west-2

  topic_arn = aws_sns_topic.notification-canada-ca-alert-ok-us-west-2.arn
  protocol  = "lambda"
  endpoint  = module.notify_slack_ok[0].notify_slack_lambda_function_arn
}

resource "aws_sns_topic_subscription" "sns_alert_ok_us_west_2_to_sre_bot" {
  count    = var.env == "production" ? 0 : 1
  provider = aws.us-west-2

  topic_arn            = aws_sns_topic.notification-canada-ca-alert-ok-us-west-2.arn
  protocol             = "https"
  endpoint             = var.cloudwatch_slack_webhook_general_topic
  raw_message_delivery = false
}

resource "aws_sns_topic_subscription" "sns_alert_warning_us_west_2_to_lambda" {
  count    = var.env == "production" ? 1 : 0
  provider = aws.us-west-2

  topic_arn = aws_sns_topic.notification-canada-ca-alert-warning-us-west-2.arn
  protocol  = "lambda"
  endpoint  = module.notify_slack_warning[0].notify_slack_lambda_function_arn
}

resource "aws_sns_topic_subscription" "sns_alert_warning_us_west_2_to_sre_bot" {
  count    = var.env == "production" ? 0 : 1
  provider = aws.us-west-2

  topic_arn            = aws_sns_topic.notification-canada-ca-alert-warning-us-west-2.arn
  protocol             = "https"
  endpoint             = var.cloudwatch_slack_webhook_warning_topic
  raw_message_delivery = false
}

resource "aws_sns_topic_subscription" "sns_alert_critical_us_west_2_to_lambda" {
  count    = var.env == "production" ? 1 : 0
  provider = aws.us-west-2

  topic_arn = aws_sns_topic.notification-canada-ca-alert-critical-us-west-2.arn
  protocol  = "lambda"
  endpoint  = module.notify_slack_critical[0].notify_slack_lambda_function_arn
}

resource "aws_sns_topic_subscription" "sns_alert_critical_us_west_2_to_sre_bot" {
  count    = var.env == "production" ? 0 : 1
  provider = aws.us-west-2

  topic_arn            = aws_sns_topic.notification-canada-ca-alert-critical-us-west-2.arn
  protocol             = "https"
  endpoint             = var.cloudwatch_slack_webhook_critical_topic
  raw_message_delivery = false
}

resource "aws_sns_topic_subscription" "alert_to_sns_to_opsgenie" {
  count = var.env == "production" ? 1 : 0

  topic_arn              = aws_sns_topic.notification-canada-ca-alert-critical.arn
  protocol               = "https"
  endpoint               = var.cloudwatch_opsgenie_alarm_webhook
  raw_message_delivery   = false
  endpoint_auto_confirms = true
}

resource "aws_sns_topic_subscription" "alert_to_sns_to_opsgenie_ok" {
  count = var.env == "production" ? 1 : 0

  topic_arn              = aws_sns_topic.notification-canada-ca-alert-ok.arn
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

resource "aws_sns_topic_subscription" "alert_critical_us_west_2_to_opsgenie_ok" {
  provider = aws.us-west-2

  count = var.env == "production" ? 1 : 0

  topic_arn              = aws_sns_topic.notification-canada-ca-alert-ok-us-west-2.arn
  protocol               = "https"
  endpoint               = var.cloudwatch_opsgenie_alarm_webhook
  raw_message_delivery   = false
  endpoint_auto_confirms = true
}

# SNS creation for us-east-1

resource "aws_sns_topic" "notification-canada-ca-alert-ok-us-east-1" {
  provider = aws.us-east-1

  name              = "alert-ok-us-east-1"
  kms_master_key_id = aws_kms_key.notification-canada-ca-us-east-1.arn

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_sns_topic" "notification-canada-ca-alert-warning-us-east-1" {
  provider = aws.us-east-1

  name              = "alert-warning-us-east-1"
  kms_master_key_id = aws_kms_key.notification-canada-ca-us-east-1.arn


  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_sns_topic" "notification-canada-ca-alert-critical-us-east-1" {
  provider = aws.us-east-1

  name              = "alert-critical-us-east-1"
  kms_master_key_id = aws_kms_key.notification-canada-ca-us-east-1.arn


  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_sns_topic_subscription" "sns_alert_ok_us_east_1_to_lambda" {
  count    = var.env == "production" ? 1 : 0
  provider = aws.us-east-1

  topic_arn = aws_sns_topic.notification-canada-ca-alert-ok-us-east-1.arn
  protocol  = "lambda"
  endpoint  = module.notify_slack_ok[0].notify_slack_lambda_function_arn
}

resource "aws_sns_topic_subscription" "sns_alert_ok_us_east_1_to_sre_bot" {
  count    = var.env == "production" ? 0 : 1
  provider = aws.us-east-1

  topic_arn            = aws_sns_topic.notification-canada-ca-alert-ok-us-east-1.arn
  protocol             = "https"
  endpoint             = var.cloudwatch_slack_webhook_general_topic
  raw_message_delivery = false
}

resource "aws_sns_topic_subscription" "sns_alert_warning_us_east_1_to_lambda" {
  count    = var.env == "production" ? 1 : 0
  provider = aws.us-east-1

  topic_arn = aws_sns_topic.notification-canada-ca-alert-warning-us-east-1.arn
  protocol  = "lambda"
  endpoint  = module.notify_slack_warning[0].notify_slack_lambda_function_arn
}

resource "aws_sns_topic_subscription" "sns_alert_warning_us_east_1_to_sre_bot" {
  count    = var.env == "production" ? 0 : 1
  provider = aws.us-east-1

  topic_arn            = aws_sns_topic.notification-canada-ca-alert-warning-us-east-1.arn
  protocol             = "https"
  endpoint             = var.cloudwatch_slack_webhook_warning_topic
  raw_message_delivery = false
}

resource "aws_sns_topic_subscription" "sns_alert_critical_us_east_1_to_lambda" {
  count    = var.env == "production" ? 1 : 0
  provider = aws.us-east-1

  topic_arn = aws_sns_topic.notification-canada-ca-alert-critical-us-east-1.arn
  protocol  = "lambda"
  endpoint  = module.notify_slack_critical[0].notify_slack_lambda_function_arn
}

resource "aws_sns_topic_subscription" "sns_alert_critical_us_east_1_to_sre_bot" {
  count    = var.env == "production" ? 0 : 1
  provider = aws.us-east-1

  topic_arn            = aws_sns_topic.notification-canada-ca-alert-critical-us-east-1.arn
  protocol             = "https"
  endpoint             = var.cloudwatch_slack_webhook_critical_topic
  raw_message_delivery = false
}

resource "aws_sns_topic_subscription" "alert_critical_us_east_1_to_opsgenie" {
  provider = aws.us-east-1

  count = var.env == "production" ? 1 : 0

  topic_arn              = aws_sns_topic.notification-canada-ca-alert-critical-us-east-1.arn
  protocol               = "https"
  endpoint               = var.cloudwatch_opsgenie_alarm_webhook
  raw_message_delivery   = false
  endpoint_auto_confirms = true
}

resource "aws_sns_topic_subscription" "alert_critical_us_east_1_to_opsgenie_ok" {
  provider = aws.us-east-1

  count = var.env == "production" ? 1 : 0

  topic_arn              = aws_sns_topic.notification-canada-ca-alert-ok-us-east-1.arn
  protocol               = "https"
  endpoint               = var.cloudwatch_opsgenie_alarm_webhook
  raw_message_delivery   = false
  endpoint_auto_confirms = true
}
