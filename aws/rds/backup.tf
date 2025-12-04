#
# AWS Backup Configuration for RDS
#
# This provides immutable backups with vault lock protection
# to prevent deletion of backups (ransomware protection).
#

# KMS key policy for backup vault
data "aws_iam_policy_document" "backup_vault_kms" {
  count = var.env == "dev" ? 1 : 0

  # Allow account root full access
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_id}:root"]
    }

    actions   = ["kms:*"]
    resources = ["*"]
  }

  # Allow AWS Backup service to use the key
  statement {
    sid    = "Allow AWS Backup to use the key"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }

    actions = [
      "kms:CreateGrant",
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey",
      "kms:GenerateDataKeyWithoutPlaintext",
      "kms:ReEncrypt*"
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = ["backup.${var.region}.amazonaws.com"]
    }
  }
}

# KMS key for encrypting backups
resource "aws_kms_key" "backup_vault" {
  count = var.env == "dev" ? 1 : 0

  description             = "KMS key for RDS backup vault encryption - ${var.env}"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.backup_vault_kms[0].json

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
    Terraform  = "true"
  }
}

resource "aws_kms_alias" "backup_vault" {
  count = var.env == "dev" ? 1 : 0

  name          = "alias/backup-vault-${var.env}"
  target_key_id = aws_kms_key.backup_vault[0].key_id
}

# Backup vault with encryption
resource "aws_backup_vault" "rds" {
  count = var.env == "dev" ? 1 : 0

  name        = "notification-canada-ca-${var.env}-rds-vault"
  kms_key_arn = aws_kms_key.backup_vault[0].arn

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
    Terraform  = "true"
  }
}

# Vault lock configuration for immutability
# This prevents deletion of backups for the specified retention period
resource "aws_backup_vault_lock_configuration" "rds" {
  count = var.env == "dev" ? 1 : 0

  backup_vault_name   = aws_backup_vault.rds[0].name
  min_retention_days  = 7
  max_retention_days  = 8
  changeable_for_days = 365
}

# IAM role for AWS Backup
resource "aws_iam_role" "backup" {
  count = var.env == "dev" ? 1 : 0

  name               = "AWSBackupRole-${var.env}"
  assume_role_policy = data.aws_iam_policy_document.backup_assume_role.json

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
    Terraform  = "true"
  }
}

data "aws_iam_policy_document" "backup_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "backup" {
  count = var.env == "dev" ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.backup[0].name
}

resource "aws_iam_role_policy_attachment" "backup_restore" {
  count = var.env == "dev" ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
  role       = aws_iam_role.backup[0].name
}

# Backup plan
resource "aws_backup_plan" "rds" {
  count = var.env == "dev" ? 1 : 0

  name = "notification-canada-ca-${var.env}-rds-plan"

  rule {
    rule_name         = "daily-backup"
    target_vault_name = aws_backup_vault.rds[0].name
    schedule          = "cron(0 7 * * ? *)" # Daily at 7 AM UTC
    start_window      = 120                 # 2 hours
    completion_window = 240                 # 4 hours

    lifecycle {
      delete_after = 8 # Match existing backup_retention_period
    }

    recovery_point_tags = {
      CostCenter = "notification-canada-ca-${var.env}"
      Terraform  = "true"
    }
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
    Terraform  = "true"
  }
}

# Backup selection - target the RDS cluster
resource "aws_backup_selection" "rds" {
  count = var.env == "dev" ? 1 : 0

  name         = "notification-canada-ca-${var.env}-rds-selection"
  plan_id      = aws_backup_plan.rds[0].id
  iam_role_arn = aws_iam_role.backup[0].arn

  resources = [
    aws_rds_cluster.notification-canada-ca.arn
  ]
}

# SNS topic for backup notifications
resource "aws_sns_topic" "backup_notifications" {
  count = var.env == "dev" ? 1 : 0

  name              = "notification-canada-ca-${var.env}-backup-notifications"
  kms_master_key_id = aws_kms_key.backup_vault[0].id

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
    Terraform  = "true"
  }
}

resource "aws_backup_vault_notifications" "rds" {
  count = var.env == "dev" ? 1 : 0

  backup_vault_name   = aws_backup_vault.rds[0].name
  sns_topic_arn       = aws_sns_topic.backup_notifications[0].arn
  backup_vault_events = ["BACKUP_JOB_COMPLETED", "BACKUP_JOB_FAILED", "RESTORE_JOB_COMPLETED", "RESTORE_JOB_FAILED"]
}

# IAM policy for SNS notifications
resource "aws_sns_topic_policy" "backup_notifications" {
  count = var.env == "dev" ? 1 : 0

  arn    = aws_sns_topic.backup_notifications[0].arn
  policy = data.aws_iam_policy_document.backup_notifications[0].json
}

data "aws_iam_policy_document" "backup_notifications" {
  count = var.env == "dev" ? 1 : 0

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }

    actions = [
      "SNS:Publish"
    ]

    resources = [
      aws_sns_topic.backup_notifications[0].arn
    ]
  }
}
