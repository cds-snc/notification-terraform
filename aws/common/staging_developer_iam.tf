locals {
  staging_developer_enabled = var.env == "staging"

  staging_developer_s3_buckets = [
    aws_s3_bucket.csv_bucket.arn,
    aws_s3_bucket.asset_bucket.arn,
    aws_s3_bucket.document_bucket.arn,
    aws_s3_bucket.scan_files_document_bucket.arn,
    aws_s3_bucket.gc_organisations_bucket.arn,
    aws_s3_bucket.reports_bucket.arn,
  ]

  staging_developer_sqs_queues = [
    aws_sqs_queue.priority_db_tasks_queue.arn,
    aws_sqs_queue.normal_db_tasks_queue.arn,
    aws_sqs_queue.bulk_db_tasks_queue.arn,
    aws_sqs_queue.notify_internal_tasks_queue.arn,
    aws_sqs_queue.eks_notification_canada_ca_sms_high_queue.arn,
    aws_sqs_queue.eks_notification_canada_ca_email_high_queue.arn,
    aws_sqs_queue.eks_notification_canada_cadelivery_receipts.arn,
    aws_sqs_queue.eks_notification_canada_usdelivery_receipts.arn,
    aws_sqs_queue.ses_receipt_callback_buffer.arn,
  ]

  staging_developer_sns_topics = [
    aws_sns_topic.notification-canada-ca-ses-callback.arn,
    aws_sns_topic.notification-canada-ca-alert-ok.arn,
    aws_sns_topic.notification-canada-ca-alert-warning.arn,
    aws_sns_topic.notification-canada-ca-alert-critical.arn,
    aws_sns_topic.notification-canada-ca-alert-general.arn,
    aws_sns_topic.notification-canada-ca-alert-warning-us-west-2.arn,
    aws_sns_topic.notification-canada-ca-alert-ok-us-west-2.arn,
    aws_sns_topic.notification-canada-ca-alert-critical-us-west-2.arn,
    aws_sns_topic.notification-canada-ca-alert-ok-us-east-1.arn,
    aws_sns_topic.notification-canada-ca-alert-warning-us-east-1.arn,
    aws_sns_topic.notification-canada-ca-alert-critical-us-east-1.arn,
  ]

  staging_developer_kms_keys = [
    aws_kms_key.notification-canada-ca.arn,
    aws_kms_key.notification-canada-ca-us-west-2.arn,
    aws_kms_key.notification-canada-ca-us-east-1.arn,
  ]
}

data "aws_iam_policy_document" "staging_developer" {
  count = local.staging_developer_enabled ? 1 : 0

  statement {
    sid = "Ses"

    actions = [
      "ses:GetIdentityVerificationAttributes",
      "ses:ListIdentities",
      "ses:SendEmail",
      "ses:SendRawEmail",
      "ses:VerifyEmailIdentity",
    ]

    resources = ["*"]
  }

  statement {
    sid       = "SnsPublish"
    actions   = ["sns:Publish"]
    resources = local.staging_developer_sns_topics
  }

  statement {
    sid = "PinpointSms"

    actions = [
      "mobiletargeting:SendMessages",
      "mobiletargeting:SendUsersMessages",
    ]

    resources = [
      "arn:aws:mobiletargeting:us-west-2:${var.account_id}:apps/${aws_pinpoint_app.notification-canada-ca.application_id}",
    ]
  }

  statement {
    sid       = "SmsVoice"
    actions   = ["sms-voice:SendTextMessage"]
    resources = ["*"]
  }

  statement {
    sid = "S3Objects"

    actions = [
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
    ]

    resources = [for bucket in local.staging_developer_s3_buckets : "${bucket}/*"]
  }

  statement {
    sid = "S3Buckets"

    actions = [
      "s3:GetBucketLocation",
      "s3:GetBucketVersioning",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
    ]

    resources = local.staging_developer_s3_buckets
  }

  statement {
    sid = "Sqs"

    actions = [
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:SendMessage",
    ]

    resources = local.staging_developer_sqs_queues
  }

  statement {
    sid = "Kms"

    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey",
      "kms:GenerateDataKeyWithoutPlaintext",
    ]

    resources = local.staging_developer_kms_keys
  }

  statement {
    sid       = "SecurityHub"
    actions   = ["securityhub:BatchImportFindings"]
    resources = ["*"]
  }

  statement {
    sid       = "CallerIdentity"
    actions   = ["sts:GetCallerIdentity"]
    resources = ["*"]
  }
}

resource "aws_iam_user" "staging_developer" {
  count = local.staging_developer_enabled ? 1 : 0

  provider = aws.core_services
  name     = "staging-developer"
  path     = "/notify/"

  tags = {
    Environment = "staging"
    ManagedBy   = "terraform"
  }
}

resource "aws_iam_user_policy" "staging_developer" {
  count = local.staging_developer_enabled ? 1 : 0

  provider = aws.core_services
  name     = "staging-developer"
  user     = aws_iam_user.staging_developer[0].name
  policy   = data.aws_iam_policy_document.staging_developer[0].json
}

resource "aws_iam_access_key" "staging_developer" {
  count = local.staging_developer_enabled ? 1 : 0

  provider = aws.core_services
  user     = aws_iam_user.staging_developer[0].name
}

resource "aws_secretsmanager_secret" "staging_developer_credentials" {
  count = local.staging_developer_enabled ? 1 : 0

  provider                = aws.core_services
  name                    = "staging/developer/aws-credentials"
  recovery_window_in_days = 7
}

resource "aws_secretsmanager_secret_version" "staging_developer_credentials" {
  count = local.staging_developer_enabled ? 1 : 0

  provider  = aws.core_services
  secret_id = aws_secretsmanager_secret.staging_developer_credentials[0].id
  secret_string = jsonencode({
    aws_access_key_id     = aws_iam_access_key.staging_developer[0].id
    aws_secret_access_key = aws_iam_access_key.staging_developer[0].secret
  })
}