data "aws_iam_policy_document" "system_status_s3_permissions" {
  statement {
    sid     = "AllowS3Access"
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::notification-canada-ca-${var.env}-system-status",
      "arn:aws:s3:::notification-canada-ca-${var.env}-system-status/*"
    ]
  }
}
