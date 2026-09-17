data "aws_iam_policy_document" "staging_developer" {
  count = var.env == "staging" ? 1 : 0

  # ListIdentities has no resource-level permissions support; must stay account-wide.
  statement {
    sid       = "SesList"
    actions   = ["ses:ListIdentities"]
    resources = ["*"]
  }

  statement {
    sid = "Ses"

    actions = [
      "ses:GetIdentityVerificationAttributes",
      "ses:SendEmail",
      "ses:SendRawEmail",
    ]

    resources = ["arn:aws:ses:*:${var.account_id}:identity/*"]
  }

  # VerifyEmailIdentity has no resource-level permissions support; must stay account-wide.
  statement {
    sid       = "SesVerifyEmail"
    actions   = ["ses:VerifyEmailIdentity"]
    resources = ["*"]
  }

  statement {
    sid     = "SnsPublish"
    actions = ["sns:Publish"]

    resources = [
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

    resources = [
      for bucket in [
        aws_s3_bucket.csv_bucket.arn,
        aws_s3_bucket.asset_bucket.arn,
        aws_s3_bucket.document_bucket.arn,
        aws_s3_bucket.scan_files_document_bucket.arn,
        aws_s3_bucket.gc_organisations_bucket.arn,
        aws_s3_bucket.reports_bucket.arn,
      ] : "${bucket}/*"
    ]
  }

  statement {
    sid = "S3Buckets"

    actions = [
      "s3:GetBucketLocation",
      "s3:GetBucketVersioning",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
    ]

    resources = [
      aws_s3_bucket.csv_bucket.arn,
      aws_s3_bucket.asset_bucket.arn,
      aws_s3_bucket.document_bucket.arn,
      aws_s3_bucket.scan_files_document_bucket.arn,
      aws_s3_bucket.gc_organisations_bucket.arn,
      aws_s3_bucket.reports_bucket.arn,
    ]
  }

  statement {
    sid = "Sqs"

    actions = [
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:SendMessage",
    ]

    resources = [
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

    resources = [
      aws_kms_key.notification-canada-ca.arn,
      aws_kms_key.notification-canada-ca-us-west-2.arn,
      aws_kms_key.notification-canada-ca-us-east-1.arn,
    ]
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
  count = var.env == "staging" ? 1 : 0

  provider = aws.core_services
  name     = "staging-developer"
  path     = "/notify/"

  tags = {
    Environment = "staging"
    ManagedBy   = "terraform"
  }
}

# Standalone managed policy: the inline-policy 2,048-character limit is too small
# for the explicit SES/SNS/S3/SQS/KMS ARNs this identity needs.
resource "aws_iam_policy" "staging_developer" {
  count = var.env == "staging" ? 1 : 0

  provider = aws.core_services
  name     = "staging-developer"
  policy   = data.aws_iam_policy_document.staging_developer[0].json
}

resource "aws_iam_user_policy_attachment" "staging_developer" {
  count = var.env == "staging" ? 1 : 0

  provider   = aws.core_services
  user       = aws_iam_user.staging_developer[0].name
  policy_arn = aws_iam_policy.staging_developer[0].arn
}

resource "aws_iam_access_key" "staging_developer" {
  count = var.env == "staging" ? 1 : 0

  provider = aws.core_services
  user     = aws_iam_user.staging_developer[0].name
}

resource "aws_secretsmanager_secret" "staging_developer_credentials" {
  count = var.env == "staging" ? 1 : 0

  provider = aws.core_services
  name     = "staging/developer/aws-credentials"
  # 1Password is the source of truth for secrets; skip the recovery window so this
  # code-managed secret can be deleted/recreated immediately if the user is rotated.
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "staging_developer_credentials" {
  count = var.env == "staging" ? 1 : 0

  provider  = aws.core_services
  secret_id = aws_secretsmanager_secret.staging_developer_credentials[0].id
  secret_string = jsonencode({
    aws_access_key_id     = aws_iam_access_key.staging_developer[0].id
    aws_secret_access_key = aws_iam_access_key.staging_developer[0].secret
  })
}