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

  # notification-api's aws_sns.py publishes SMS directly to a phone number (no TopicArn),
  # which has no resource-level permissions support; must stay account-wide.
  statement {
    sid       = "SnsPublish"
    actions   = ["sns:Publish"]
    resources = ["*"]
  }

  # notification-api's aws_pinpoint.py uses the pinpoint-sms-voice-v2 API (sms-voice:*),
  # not the classic mobiletargeting API, and OriginationIdentity/pool targets have no
  # resource-level permissions support; must stay account-wide.
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

  # notification-api's NOTIFICATION_QUEUE_PREFIX lets developers create their own ad hoc
  # queue names (e.g. <prefix>-tasks), so per-queue actions are scoped to the
  # account/region rather than a fixed ARN list, which would miss those dev queues.
  statement {
    sid = "Sqs"

    actions = [
      "sqs:ChangeMessageVisibility",
      "sqs:CreateQueue",
      "sqs:DeleteMessage",
      "sqs:DeleteQueue",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:PurgeQueue",
      "sqs:ReceiveMessage",
      "sqs:SendMessage",
    ]

    resources = ["arn:aws:sqs:ca-central-1:${var.account_id}:*"]
  }

  # ListQueues has no resource-level permissions support; must stay account-wide.
  statement {
    sid       = "SqsListQueues"
    actions   = ["sqs:ListQueues"]
    resources = ["*"]
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
# for the explicit SES/S3/SQS ARNs this identity needs.
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