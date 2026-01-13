#
# Create and Manage github workflow policies
#

# resource policies for GitHub OIDC roles
resource "aws_iam_policy" "notification_admin_test_admin_workflows" {
  count = var.env == "staging" ? 1 : 0

  name   = local.notification_admin_test_admin_workflows
  path   = "/"
  policy = data.aws_iam_policy_document.notification_admin_test_admin_workflows[0].json
}

data "aws_iam_role" "notify-admin-pr" {
  count = var.env == "staging" ? 1 : 0
  name  = "notify-admin-pr" # the name of your existing IAM role
}

data "aws_iam_policy_document" "notification_admin_test_admin_workflows" {
  count = var.env == "staging" ? 1 : 0

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
    resources = [data.aws_iam_role.notify-admin-pr[0].arn]
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

resource "aws_iam_policy" "notification_admin_cypress_e2e_tests" {
  count = var.env == "staging" ? 1 : 0

  name   = local.notification_admin_cypress_e2e_tests
  path   = "/"
  policy = data.aws_iam_policy_document.notification_admin_cypress_e2e_tests[0].json
}

data "aws_iam_policy_document" "notification_admin_cypress_e2e_tests" {
  count = var.env == "staging" ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "sqs:*",
    ]
    resources = [
      "arn:aws:sqs:${var.region}:${var.account_id}:*"
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

resource "aws_iam_policy" "notification_manifests_k8s_lambda_apply" {
  name   = local.notification_manifests_k8s_lambda_apply
  path   = "/"
  policy = data.aws_iam_policy_document.notification_manifests_k8s_lambda_apply.json
}

data "aws_iam_policy_document" "notification_manifests_k8s_lambda_apply" {
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
      "lambda:UpdateFunctionCode",
      "lambda:UpdateFunctionConfiguration",
      "lambda:GetFunction",
      "lambda:GetFunctionConfiguration",
      "lambda:CreateFunction",
      "lambda:DeleteFunction",
      "lambda:ListFunctions",
      "lambda:PublishVersion",
      "lambda:UpdateAlias"
    ]
    resources = [
      "arn:aws:lambda:${var.region}:${var.account_id}:function:*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:PutParameter",
      "ssm:DeleteParameter",
      "ssm:DescribeParameters"
    ]
    resources = [
      "arn:aws:ssm:${var.region}:${var.account_id}:parameter/*"
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

resource "aws_iam_policy" "notification_api_build_push" {
  name   = local.notification_api_build_push
  path   = "/"
  policy = data.aws_iam_policy_document.notification_api_build_push.json
}

data "aws_iam_policy_document" "notification_api_build_push" {
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
      "ecr:BatchDeleteImage",
      "ecr:DescribeImages",
      "ecr:ListImages",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage"
    ]
    resources = [
      "arn:aws:ecr:${var.region}:${var.account_id}:repository/notify/api",
      "arn:aws:ecr:${var.region}:${var.account_id}:repository/notify/api-lambda"
    ]
  }
}

resource "aws_iam_policy" "notification_admin_build_push" {
  name   = local.notification_admin_build_push
  path   = "/"
  policy = data.aws_iam_policy_document.notification_admin_build_push.json
}

data "aws_iam_policy_document" "notification_admin_build_push" {
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
}

resource "aws_iam_policy" "notification_document_download_build_push" {
  name   = local.notification_document_download_build_push
  path   = "/"
  policy = data.aws_iam_policy_document.notification_document_download_build_push.json
}

data "aws_iam_policy_document" "notification_document_download_build_push" {
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
      "ecr:BatchDeleteImage",
      "ecr:DescribeImages",
      "ecr:ListImages",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage"
    ]
    resources = [
      "arn:aws:ecr:${var.region}:${var.account_id}:repository/notify/document-download"
    ]
  }
}

#
# DKIM Audit read-only policy
#
resource "aws_iam_policy" "dkim_audit" {
  name   = local.dkim_audit
  path   = "/"
  policy = data.aws_iam_policy_document.dkim_audit.json
}

data "aws_iam_policy_document" "dkim_audit" {
  statement {
    effect = "Allow"
    actions = [
      "ses:Get*",
      "ses:List*",
      "ses:Describe*"
    ]
    resources = [
      "arn:aws:ses:${var.region}:${var.account_id}:identity/*"
    ]
  }
}

