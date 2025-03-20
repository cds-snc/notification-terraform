resource "aws_iam_role" "platform_data_lake_export" {
  count              = var.env == "staging" ? 1 : 0
  name               = "NotifyExportToPlatformDataLake"
  description        = "Export RDS snapshots to the Platform Data Lake"
  assume_role_policy = data.aws_iam_policy_document.platform_data_lake_assume[0].json
}

resource "aws_iam_policy" "platform_data_lake_export" {
  count  = var.env == "staging" ? 1 : 0
  name   = "NotifyExportToPlatformDataLake"
  policy = data.aws_iam_policy_document.platform_data_lake_export[0].json
}

resource "aws_iam_role_policy_attachment" "platform_data_lake_export" {
  count      = var.env == "staging" ? 1 : 0
  role       = aws_iam_role.platform_data_lake_export[0].name
  policy_arn = aws_iam_policy.platform_data_lake_export[0].arn
}

data "aws_iam_policy_document" "platform_data_lake_export_assume" {
  count = var.env == "staging" ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "export.rds.amazonaws.com"
      ]
    }
    principals {
      type = "AWS"
      identifiers = [
        var.platform_data_lake_rds_export_role_arn
      ]
    }
  }
}

data "aws_iam_policy_document" "platform_data_lake_export" {
  count = var.env == "staging" ? 1 : 0

  statement {
    sid    = "RDSExportSnapshots"
    effect = "Allow"
    actions = [
      "rds:CopyDBSnapshot",
      "rds:DescribeDBSnapshots",
      "rds:DescribeDBSnapshotAttributes",
      "rds:ListTagsForResource",
    ]
    resources = [
      "arn:aws:rds:${var.region}:${var.account_id}:snapshot:rds:notification-canada-ca-${var.env}-cluster-*"
    ]
  }

  statement {
    sid    = "S3WriteObjects"
    effect = "Allow"
    actions = [
      "s3:PutObject*",
      "s3:ListBucket",
      "s3:GetObject*",
      "s3:DeleteObject*",
      "s3:GetBucketLocation"
    ]
    resources = [
      var.platform_data_lake_raw_s3_bucket_arn,
      "${var.platform_data_lake_raw_s3_bucket_arn}/*"
    ]
  }

  statement {
    sid    = "KMSReadWrite"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:GenerateDataKey",
      "kms:GenerateDataKeyWithoutPlaintext",
      "kms:ReEncryptFrom",
      "kms:ReEncryptTo",
      "kms:CreateGrant",
      "kms:DescribeKey",
      "kms:RetireGrant"
    ]
    resources = [
      var.platform_data_lake_kms_key_arn
    ]
  }
}
