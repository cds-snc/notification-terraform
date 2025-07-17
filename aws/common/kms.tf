data "aws_caller_identity" "current" {}

locals {
  # Common KMS configuration for SQS queues
  sqs_kms_config = {
    kms_master_key_id                 = aws_kms_key.notification-canada-ca.arn
    kms_data_key_reuse_period_seconds = 300
  }

  # Common KMS configuration for SNS topics
  sns_kms_config = {
    kms_master_key_id = aws_kms_key.notification-canada-ca.arn
  }

  # Common KMS configuration for SNS topics in us-west-2
  sns_kms_config_us_west_2 = {
    kms_master_key_id = aws_kms_key.notification-canada-ca-us-west-2.arn
  }

  # Common tags for SQS queues
  sqs_common_tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }

  # Common tags for SQS queues with Environment tag
  sqs_common_tags_with_env = {
    Environment = var.env
    CostCenter  = "notification-canada-ca-${var.env}"
  }

  # Common tags for SNS topics
  sns_common_tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }

  # Common tags for all resources
  common_tags = {
    Name       = "notification-canada-ca"
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_kms_key" "notification-canada-ca" {
  description         = "notification-canada-ca ${var.env} encryption key"
  enable_key_rotation = true

  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["logs.${var.region}.amazonaws.com"]
    }
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Allow_CloudWatch_for_CMK"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudwatch.amazonaws.com"]
    }
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ses.amazonaws.com"]
    }
    actions = [
      "kms:GenerateDataKey*",
      "kms:Decrypt"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Allow_SQS_for_CMK"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["sqs.amazonaws.com"]
    }
    actions = [
      "kms:GenerateDataKey*",
      "kms:Decrypt"
    ]
    resources = ["*"]
  }

  tags = {
    Name       = "notification-canada-ca"
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_kms_key" "notification-canada-ca-us-west-2" {
  provider = aws.us-west-2

  description         = "notification-canada-ca ${var.env} encryption key in us-west-2"
  enable_key_rotation = true

  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid    = "Allow_CloudWatch_for_CMK"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudwatch.amazonaws.com"]
    }
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Allow_SQS_for_CMK"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["sqs.amazonaws.com"]
    }
    actions = [
      "kms:GenerateDataKey*",
      "kms:Decrypt"
    ]
    resources = ["*"]
  }

  tags = {
    Name       = "notification-canada-ca"
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_kms_key" "notification-canada-ca-us-east-1" {
  provider = aws.us-east-1

  description         = "notification-canada-ca ${var.env} encryption key in us-east-1"
  enable_key_rotation = true

  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid    = "Allow_CloudWatch_for_CMK"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudwatch.amazonaws.com"]
    }
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Allow_SQS_for_CMK"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["sqs.amazonaws.com"]
    }
    actions = [
      "kms:GenerateDataKey*",
      "kms:Decrypt"
    ]
    resources = ["*"]
  }

  tags = {
    Name       = "notification-canada-ca"
    CostCenter = "notification-canada-ca-${var.env}"
  }
}
