#
# Create and Manage PR review environment resources
#
resource "aws_iam_policy" "notification_admin_test_admin_deploy" {
  name   = local.notification_admin_test_admin_deploy
  path   = "/"
  policy = data.aws_iam_policy_document.notification_admin_test_admin_deploy.json
}

data "aws_iam_policy_document" "notification_admin_test_admin_deploy" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:BatchDeleteImage",
      "ecr:DescribeImages",
      "ecr:ListImages"
    ]
    resources = [
      "arn:aws:ecr:${var.region}:${var.account_id}:repository/notify/admin"
    ]
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
      # "lambda:CreateFunctionUrlConfig",
      # "lambda:DeleteFunction",
      # "lambda:DeleteFunctionUrlConfig",
      # "lambda:DeleteFunctionConcurrency",
      "lambda:GetFunction",
      "lambda:GetFunctionConfiguration",
      # "lambda:GetFunctionUrlConfig",
      # "lambda:ListFunctionUrlConfigs",
      "lambda:PutFunctionConcurrency",
      "lambda:UpdateFunctionCode",
      "lambda:UpdateFunctionConfiguration",
      # "lambda:UpdateFunctionUrlConfig"
    ]
    resources = [
      "arn:aws:lambda:${var.region}:${var.account_id}:function:notify-admin-pr-*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      # "logs:CreateLogStream",
      # "logs:DeleteLogGroup",
      # "logs:DeleteLogStream",
      # "logs:DeleteRetentionPolicy",
      # "logs:DescribeLogStreams",
      "logs:PutRetentionPolicy"
    ]
    resources = [
      "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/lambda/notify-admin-pr-*"
    ]
  }
}

data "aws_organizations_organization" "org" {}

resource "aws_iam_policy" "notification_oidc_plan_policy" {
  name   = local.notification_oidc_plan_policy
  path   = "/"
  policy = data.aws_iam_policy_document.notification_oidc_plan_policy.json
}

data "aws_iam_policy_document" "notification_oidc_plan_policy" {
  statement {
    sid    = "AllowAllDynamoDBActionsOnAllTerragruntTables"
    effect = "Allow"
    actions = [
      "dynamodb:*"
    ]
    resources = [
      "arn:aws:dynamodb:${var.region}:${var.account_id}:table/tfstate-lock",
      "arn:aws:dynamodb:${var.region}:${var.account_id}:table/terraform-state-lock-dynamo"
    ]
  }

  statement {
    sid    = "AllowAllS3ActionsOnAllTerragruntBuckets"
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resources = [
      "arn:aws:s3:::*-tfstate/*",
      "arn:aws:s3:::*-tfstate",
      "arn:aws:s3:::*-tf/*",
      "arn:aws:s3:::*-tf"
    ]
  }

  statement {
    sid    = "AllowReadingSecrets"
    effect = "Allow"
    actions = [
      "secretsmanager:ListSecretVersionIds",
      "secretsmanager:GetSecretValue",
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:DescribeSecret"
    ]
    resources = [
      "arn:aws:secretsmanager:*:${var.account_id}:secret:*"
    ]
  }

  statement {
    sid    = "ListSecrets"
    effect = "Allow"
    actions = [
      "secretsmanager:ListSecrets"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid    = "ReadCWTagsForResources"
    effect = "Allow"
    actions = [
      "logs:ListTagsForResource"
    ]
    resources = [
      "arn:aws:logs:${var.region}:${var.account_id}:log-group:*"
    ]
  }

  # statement {
  #   sid    = "ReadAutoscalingTagsForResources"
  #   effect = "Allow"
  #   actions = [
  #     "application-autoscaling:ListTagsForResource"
  #   ]
  #   resources = [
  #     "*"
  #   ]
  # }

  # statement {
  #   sid    = "AllowReadingQuickSightResources"
  #   effect = "Allow"
  #   actions = [
  #     "quicksight:List*",
  #     "quicksight:Get*",
  #     "quicksight:Describe*"
  #   ]
  #   resources = [
  #     "*"
  #   ]
  # }

  # statement {
  #   sid    = "AllowReadingGlueResources"
  #   effect = "Allow"
  #   actions = [
  #     "glue:List*",
  #     "glue:Get*",
  #     "glue:Describe*"
  #   ]
  #   resources = [
  #     "*"
  #   ]
  # }

  statement {
    sid    = "AllowAssumeRole"
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    resources = [
      "*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [data.aws_organizations_organization.org.id]
    }
  }
}
