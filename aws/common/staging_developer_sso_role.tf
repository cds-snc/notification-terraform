# PROPOSAL: not yet adopted. Disabled by default (enable_staging_developer_sso_role = false).
#
# Replaces the static aws_iam_user/aws_iam_access_key in staging_developer_iam.tf with an
# IAM role that developers assume through their existing AWS SSO (IAM Identity Center)
# session, instead of a long-lived shared access key stored in Secrets Manager.
#
# This gives:
# - No static/long-lived credentials to store, rotate, or leak.
# - Per-developer CloudTrail attribution via distinct sts:AssumeRole session names.
# - Reuses the same least-privilege policy already defined in staging_developer_iam.tf.
#
# Open item: staging_developer_sso_principal_arn must be set to the IAM Identity Center
# permission-set (or group) role ARN allowed to assume this role. That permission set is
# provisioned outside this repo (management account / landing zone), likely owned by
# SRE/Platform - confirm with them before enabling this.

data "aws_iam_policy_document" "staging_developer_sso_assume_role" {
  count = var.env == "staging" && var.enable_staging_developer_sso_role ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.staging_developer_sso_principal_arn]
    }
  }
}

resource "aws_iam_role" "staging_developer_sso" {
  count = var.env == "staging" && var.enable_staging_developer_sso_role ? 1 : 0

  provider           = aws.core_services
  name               = "staging-developer-sso"
  path               = "/notify/"
  assume_role_policy = data.aws_iam_policy_document.staging_developer_sso_assume_role[0].json

  tags = {
    Environment = "staging"
    ManagedBy   = "terraform"
  }
}

resource "aws_iam_role_policy_attachment" "staging_developer_sso" {
  count = var.env == "staging" && var.enable_staging_developer_sso_role ? 1 : 0

  provider   = aws.core_services
  role       = aws_iam_role.staging_developer_sso[0].name
  policy_arn = aws_iam_policy.staging_developer[0].arn
}
