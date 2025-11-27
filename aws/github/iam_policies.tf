#
# Create and Manage github workflow policies
#

# resource policies for GitHub OIDC roles
resource "aws_iam_policy" "notification_admin_test_admin_workflows" {
  count = var.env == "staging" ? 1 : 0

  name   = local.notification_admin_test_admin_workflows
  path   = "/"
  policy = data.aws_iam_policy_document.notification_admin_test_admin_workflows.json
}

data "aws_iam_role" "notify-admin-pr" {
  name = "notify-admin-pr" # the name of your existing IAM role
}

data "aws_iam_policy_document" "notification_admin_test_admin_workflows" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:BatchDeleteImage",
      "ecr:DescribeImages",
      "ecr:ListImages",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage"
    ]
    resources = [
      "arn:aws:ecr:${var.region}:${var.account_id}:repository/notify/admin"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = [data.aws_iam_role.notify-admin-pr.arn]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "lambda:AddPermission",
      "lambda:CreateFunction",
      "lambda:CreateFunctionUrlConfig",
      "lambda:DeleteFunction",
      "lambda:DeleteFunctionUrlConfig",
      "lambda:DeleteFunctionConcurrency",
      "lambda:GetFunction",
      "lambda:GetFunctionConfiguration",
      "lambda:GetFunctionUrlConfig",
      "lambda:ListFunctionUrlConfigs",
      "lambda:PutFunctionConcurrency",
      "lambda:UpdateFunctionCode",
      "lambda:UpdateFunctionConfiguration",
      "lambda:UpdateFunctionUrlConfig"
    ]
    resources = [
      "arn:aws:lambda:${var.region}:${var.account_id}:function:notify-admin-pr-*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DeleteLogGroup",
      "logs:DeleteLogStream",
      "logs:DeleteRetentionPolicy",
      "logs:DescribeLogStreams",
      "logs:PutRetentionPolicy"
    ]
    resources = [
      "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/lambda/notify-admin-pr-*"
    ]
  }
}

resource "aws_iam_policy" "notification_manifests_helmfile_diff" {
  name   = local.notification_manifests_helmfile_diff
  path   = "/"
  policy = data.aws_iam_policy_document.notification_manifests_helmfile_diff.json
}

data "aws_iam_policy_document" "notification_manifests_helmfile_diff" {
  statement {
    effect = "Allow"
    actions = [
      "eks:DescribeCluster"
    ]
    resources = [
      "arn:aws:eks:${var.region}:${var.account_id}:cluster/notification-canada-ca-*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:ExportClientVpnClientConfiguration"
    ]
    resources = [
      "arn:aws:ec2:${var.region}:${var.account_id}:client-vpn-endpoint/*"
    ]
  }
}

resource "aws_iam_policy" "notification_manifests_staging_smoke_test" {
  count = var.env == "staging" ? 1 : 0

  name   = local.notification_manifests_staging_smoke_test
  path   = "/"
  policy = data.aws_iam_policy_document.notification_manifests_staging_smoke_test.json
}

data "aws_iam_policy_document" "notification_manifests_staging_smoke_test" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    resources = [
      "arn:aws:s3:::notification-canada-ca-*"
    ]
  }
}
