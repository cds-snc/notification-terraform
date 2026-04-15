#
# Create and Manage github workflow policies
#

#
# notification-manifests helmfile apply policy (staging)
# Needs: EKS kubeconfig, EC2 VPN cert, Secrets Manager context, SSM lambda env vars
#
resource "aws_iam_policy" "notification_manifests_helmfile_apply" {
  count = var.env == "staging" ? 1 : 0

  name   = local.notification_manifests_helmfile_staging_apply
  path   = "/"
  policy = data.aws_iam_policy_document.notification_manifests_helmfile_apply[0].json
}

data "aws_iam_policy_document" "notification_manifests_helmfile_apply" {
  count = var.env == "staging" ? 1 : 0

  statement {
    effect    = "Allow"
    actions   = ["eks:DescribeCluster"]
    resources = ["arn:aws:eks:${var.region}:${var.account_id}:cluster/notification-canada-ca-staging-eks-cluster"]
  }

  statement {
    effect    = "Allow"
    actions   = ["ec2:ExportClientVpnClientConfiguration"]
    resources = ["arn:aws:ec2:${var.region}:${var.account_id}:client-vpn-endpoint/*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:*"]
  }

  statement {
    effect  = "Allow"
    actions = ["ssm:GetParameter", "ssm:GetParameters", "ssm:PutParameter", "ssm:DescribeParameters"]
    resources = [
      "arn:aws:ssm:${var.region}:${var.account_id}:parameter/ENVIRONMENT_VARIABLES",
      "arn:aws:ssm:${var.region}:${var.account_id}:parameter/ENVIRONMENT_VARIABLES_ADMIN"
    ]
  }

  statement {
    effect    = "Allow"
    actions   = ["kms:Decrypt", "kms:GenerateDataKey"]
    resources = ["arn:aws:kms:${var.region}:${var.account_id}:key/*"]
  }

  statement {
    effect  = "Allow"
    actions = ["s3:GetObject", "s3:ListBucket"]
    resources = [
      "arn:aws:s3:::notification-canada-ca-staging-tf",
      "arn:aws:s3:::notification-canada-ca-staging-tf/*"
    ]
  }
}

#
# notification-manifests helmfile apply policy (production)
#
resource "aws_iam_policy" "notification_manifests_helmfile_apply_production" {
  count = var.env == "production" ? 1 : 0

  name   = local.notification_manifests_helmfile_production_apply
  path   = "/"
  policy = data.aws_iam_policy_document.notification_manifests_helmfile_apply_production[0].json
}

data "aws_iam_policy_document" "notification_manifests_helmfile_apply_production" {
  count = var.env == "production" ? 1 : 0

  statement {
    effect    = "Allow"
    actions   = ["eks:DescribeCluster"]
    resources = ["arn:aws:eks:${var.region}:${var.account_id}:cluster/notification-canada-ca-production-eks-cluster"]
  }

  statement {
    effect    = "Allow"
    actions   = ["ec2:ExportClientVpnClientConfiguration"]
    resources = ["arn:aws:ec2:${var.region}:${var.account_id}:client-vpn-endpoint/*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:*"]
  }

  statement {
    effect  = "Allow"
    actions = ["ssm:GetParameter", "ssm:GetParameters", "ssm:PutParameter", "ssm:DescribeParameters"]
    resources = [
      "arn:aws:ssm:${var.region}:${var.account_id}:parameter/ENVIRONMENT_VARIABLES",
      "arn:aws:ssm:${var.region}:${var.account_id}:parameter/ENVIRONMENT_VARIABLES_ADMIN"
    ]
  }

  statement {
    effect    = "Allow"
    actions   = ["kms:Decrypt", "kms:GenerateDataKey"]
    resources = ["arn:aws:kms:${var.region}:${var.account_id}:key/*"]
  }

  statement {
    effect  = "Allow"
    actions = ["s3:GetObject", "s3:ListBucket"]
    resources = [
      "arn:aws:s3:::notification-canada-ca-production-tf",
      "arn:aws:s3:::notification-canada-ca-production-tf/*"
    ]
  }
}

#
# notification-manifests database migration policy (staging)
#
resource "aws_iam_policy" "notification_manifests_database_migration" {
  count = var.env == "staging" ? 1 : 0

  name   = local.notification_manifests_database_migration_staging
  path   = "/"
  policy = data.aws_iam_policy_document.notification_manifests_database_migration[0].json
}

data "aws_iam_policy_document" "notification_manifests_database_migration" {
  count = var.env == "staging" ? 1 : 0

  statement {
    effect    = "Allow"
    actions   = ["eks:DescribeCluster"]
    resources = ["arn:aws:eks:${var.region}:${var.account_id}:cluster/notification-canada-ca-staging-eks-cluster"]
  }

  statement {
    effect    = "Allow"
    actions   = ["ec2:ExportClientVpnClientConfiguration"]
    resources = ["arn:aws:ec2:${var.region}:${var.account_id}:client-vpn-endpoint/*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["kms:Decrypt"]
    resources = ["arn:aws:kms:${var.region}:${var.account_id}:key/*"]
  }

  statement {
    effect  = "Allow"
    actions = ["s3:GetObject", "s3:ListBucket"]
    resources = [
      "arn:aws:s3:::notification-canada-ca-staging-tf",
      "arn:aws:s3:::notification-canada-ca-staging-tf/*"
    ]
  }
}

#
# notification-manifests database migration policy (production)
#
resource "aws_iam_policy" "notification_manifests_database_migration_production" {
  count = var.env == "production" ? 1 : 0

  name   = local.notification_manifests_database_migration_production
  path   = "/"
  policy = data.aws_iam_policy_document.notification_manifests_database_migration_production[0].json
}

data "aws_iam_policy_document" "notification_manifests_database_migration_production" {
  count = var.env == "production" ? 1 : 0

  statement {
    effect    = "Allow"
    actions   = ["eks:DescribeCluster"]
    resources = ["arn:aws:eks:${var.region}:${var.account_id}:cluster/notification-canada-ca-production-eks-cluster"]
  }

  statement {
    effect    = "Allow"
    actions   = ["ec2:ExportClientVpnClientConfiguration"]
    resources = ["arn:aws:ec2:${var.region}:${var.account_id}:client-vpn-endpoint/*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = ["arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["kms:Decrypt"]
    resources = ["arn:aws:kms:${var.region}:${var.account_id}:key/*"]
  }

  statement {
    effect  = "Allow"
    actions = ["s3:GetObject", "s3:ListBucket"]
    resources = [
      "arn:aws:s3:::notification-canada-ca-production-tf",
      "arn:aws:s3:::notification-canada-ca-production-tf/*"
    ]
  }
}

#
# notification-manifests smoke test production policy
#
resource "aws_iam_policy" "notification_manifests_smoke_test_production" {
  count = var.env == "production" ? 1 : 0

  name   = local.notification_manifests_smoke_test_production
  path   = "/"
  policy = data.aws_iam_policy_document.notification_manifests_smoke_test_production[0].json
}

data "aws_iam_policy_document" "notification_manifests_smoke_test_production" {
  count = var.env == "production" ? 1 : 0

  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::notification-canada-ca-production-csv-upload"]
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["arn:aws:s3:::notification-canada-ca-production-csv-upload/*"]
  }
}

#
# notification-admin test-delete-unused policy
#
resource "aws_iam_policy" "notification_admin_test_delete_unused" {
  count = var.env == "staging" ? 1 : 0

  name   = local.notification_admin_test_delete_unused
  path   = "/"
  policy = data.aws_iam_policy_document.notification_admin_test_delete_unused[0].json
}

data "aws_iam_policy_document" "notification_admin_test_delete_unused" {
  count = var.env == "staging" ? 1 : 0

  statement {
    effect    = "Allow"
    actions   = ["lambda:ListFunctions"]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "lambda:DeleteFunction",
      "lambda:DeleteFunctionUrlConfig",
      "lambda:GetFunctionUrlConfig"
    ]
    resources = ["arn:aws:lambda:${var.region}:${var.account_id}:function:notify-admin-pr-*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["logs:DeleteLogGroup"]
    resources = ["arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/lambda/notify-admin-pr-*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["ecr:BatchDeleteImage", "ecr:DescribeImages", "ecr:ListImages"]
    resources = ["arn:aws:ecr:${var.region}:${var.account_id}:repository/notify/admin"]
  }

  statement {
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }
}

#
# notification-api build-and-push performance test policy (staging)
#
resource "aws_iam_policy" "notification_api_build_push_performance_test" {
  count = var.env == "staging" ? 1 : 0

  name   = local.notification_api_build_push_performance_test
  path   = "/"
  policy = data.aws_iam_policy_document.notification_api_build_push_performance_test[0].json
}

data "aws_iam_policy_document" "notification_api_build_push_performance_test" {
  count = var.env == "staging" ? 1 : 0

  statement {
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
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
      "ecr:PutImage",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]
    resources = ["arn:aws:ecr:${var.region}:${var.account_id}:repository/notify/performance-test"]
  }
}

#
# notification-api lambda staging policy
# Needs: ECR push to notify/api-lambda + Lambda update/publish/alias
#
resource "aws_iam_policy" "notification_api_lambda_staging" {
  count = var.env == "staging" ? 1 : 0

  name   = local.notification_api_lambda_staging
  path   = "/"
  policy = data.aws_iam_policy_document.notification_api_lambda_staging[0].json
}

data "aws_iam_policy_document" "notification_api_lambda_staging" {
  count = var.env == "staging" ? 1 : 0

  statement {
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
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
      "ecr:PutImage",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]
    resources = ["arn:aws:ecr:${var.region}:${var.account_id}:repository/notify/api-lambda"]
  }

  statement {
    effect = "Allow"
    actions = [
      "lambda:UpdateFunctionCode",
      "lambda:PublishVersion",
      "lambda:UpdateAlias",
      "lambda:GetFunction",
      "lambda:GetFunctionConfiguration",
      "lambda:GetAlias",
      "lambda:ListAliases",
      "lambda:ListVersionsByFunction"
    ]
    resources = [
      "arn:aws:lambda:${var.region}:${var.account_id}:function:api-lambda",
      "arn:aws:lambda:${var.region}:${var.account_id}:function:api-lambda:*"
    ]
  }
}

#
# notification-api lambda production policy
# ECR push only — production Lambda deploy goes through manifests, not this workflow
#
resource "aws_iam_policy" "notification_api_lambda_production" {
  count = var.env == "production" ? 1 : 0

  name   = local.notification_api_lambda_production
  path   = "/"
  policy = data.aws_iam_policy_document.notification_api_lambda_production[0].json
}

data "aws_iam_policy_document" "notification_api_lambda_production" {
  count = var.env == "production" ? 1 : 0

  statement {
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
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
      "ecr:PutImage",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]
    resources = ["arn:aws:ecr:${var.region}:${var.account_id}:repository/notify/api-lambda"]
  }
}

#
# notification-system-status-frontend upload-to-s3 policy (staging)
#
resource "aws_iam_policy" "notification_system_status_frontend_upload_to_s3" {
  count = var.env == "staging" ? 1 : 0

  name   = local.notification_system_status_frontend_upload_to_s3
  path   = "/"
  policy = data.aws_iam_policy_document.notification_system_status_frontend_upload_to_s3[0].json
}

data "aws_iam_policy_document" "notification_system_status_frontend_upload_to_s3" {
  count = var.env == "staging" ? 1 : 0

  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::notification-canada-ca-staging-system-status"]
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["arn:aws:s3:::notification-canada-ca-staging-system-status/*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["cloudfront:CreateInvalidation"]
    resources = ["*"]
  }
}

#
# notification-system-status-frontend prod-upload-to-s3 policy (production)
#
resource "aws_iam_policy" "notification_system_status_frontend_prod_upload_to_s3" {
  count = var.env == "production" ? 1 : 0

  name   = local.notification_system_status_frontend_prod_upload_to_s3
  path   = "/"
  policy = data.aws_iam_policy_document.notification_system_status_frontend_prod_upload_to_s3[0].json
}

data "aws_iam_policy_document" "notification_system_status_frontend_prod_upload_to_s3" {
  count = var.env == "production" ? 1 : 0

  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::notification-canada-ca-production-system-status"]
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["arn:aws:s3:::notification-canada-ca-production-system-status/*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["cloudfront:CreateInvalidation"]
    resources = ["*"]
  }
}

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

resource "aws_iam_policy" "notification_lambdas_apply" {
  name   = local.notification_lambdas_apply
  path   = "/"
  policy = data.aws_iam_policy_document.notification_lambdas_apply.json
}

data "aws_iam_policy_document" "notification_lambdas_apply" {
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
      "arn:aws:ecr:${var.region}:${var.account_id}:repository/notify/pinpoint_to_sqs_sms_callbacks",
      "arn:aws:ecr:us-west-2:${var.account_id}:repository/notify/pinpoint_to_sqs_sms_callbacks"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "lambda:CreateAlias",
      "lambda:GetAlias",
      "lambda:GetFunction",
      "lambda:GetFunctionConfiguration",
      "lambda:ListAliases",
      "lambda:ListVersionsByFunction",
      "lambda:PublishVersion",
      "lambda:UpdateAlias",
      "lambda:UpdateFunctionCode"
    ]
    resources = [
      "arn:aws:lambda:${var.region}:${var.account_id}:function:pinpoint_to_sqs_sms_callbacks",
      "arn:aws:lambda:${var.region}:${var.account_id}:function:pinpoint_to_sqs_sms_callbacks:*",
      "arn:aws:lambda:us-west-2:${var.account_id}:function:pinpoint_to_sqs_sms_callbacks_us_west_2",
      "arn:aws:lambda:us-west-2:${var.account_id}:function:pinpoint_to_sqs_sms_callbacks_us_west_2:*"
    ]
  }
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
# notification-terraform workflow policies
#

resource "aws_iam_policy" "notification_terraform_check_eks_ami_update" {
  count = var.env == "staging" ? 1 : 0

  name   = local.notification_terraform_check_eks_ami_update
  path   = "/"
  policy = data.aws_iam_policy_document.notification_terraform_check_eks_ami_update[0].json
}

data "aws_iam_policy_document" "notification_terraform_check_eks_ami_update" {
  count = var.env == "staging" ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "eks:DescribeCluster",
      "eks:DescribeNodegroup"
    ]
    resources = [
      "arn:aws:eks:${var.region}:${var.account_id}:cluster/notification-canada-ca-*",
      "arn:aws:eks:${var.region}:${var.account_id}:nodegroup/notification-canada-ca-*/*/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameter"
    ]
    resources = [
      "arn:aws:ssm:${var.region}::parameter/aws/service/eks/optimized-ami/*"
    ]
  }
}

resource "aws_iam_policy" "notification_terraform_check_eks_cluster_update" {
  count = var.env == "staging" ? 1 : 0

  name   = local.notification_terraform_check_eks_cluster_update
  path   = "/"
  policy = data.aws_iam_policy_document.notification_terraform_check_eks_cluster_update[0].json
}

data "aws_iam_policy_document" "notification_terraform_check_eks_cluster_update" {
  count = var.env == "staging" ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "eks:DescribeAddonVersions"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "eks:DescribeCluster"
    ]
    resources = [
      "arn:aws:eks:${var.region}:${var.account_id}:cluster/notification-canada-ca-*"
    ]
  }
}

resource "aws_iam_policy" "notification_terraform_sanitize_staging_sms" {
  count = var.env == "staging" ? 1 : 0

  name   = local.notification_terraform_sanitize_staging_sms
  path   = "/"
  policy = data.aws_iam_policy_document.notification_terraform_sanitize_staging_sms[0].json
}

data "aws_iam_policy_document" "notification_terraform_sanitize_staging_sms" {
  count = var.env == "staging" ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::notification-canada-ca-staging-sms-usage-logs",
      "arn:aws:s3:::notification-canada-ca-staging-sms-usage-west-2-logs"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::notification-canada-ca-staging-sms-usage-logs/*",
      "arn:aws:s3:::notification-canada-ca-staging-sms-usage-west-2-logs/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::notification-canada-ca-staging-sms-usage-logs-san/*",
      "arn:aws:s3:::notification-canada-ca-staging-sms-usage-west-2-logs-san/*"
    ]
  }
}

resource "aws_iam_policy" "notification_terraform_sanitize_production_sms" {
  count = var.env == "production" ? 1 : 0

  name   = local.notification_terraform_sanitize_production_sms
  path   = "/"
  policy = data.aws_iam_policy_document.notification_terraform_sanitize_production_sms[0].json
}

data "aws_iam_policy_document" "notification_terraform_sanitize_production_sms" {
  count = var.env == "production" ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::notification-canada-ca-production-sms-usage-logs",
      "arn:aws:s3:::notification-canada-ca-production-sms-usage-west-2-logs"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::notification-canada-ca-production-sms-usage-logs/*",
      "arn:aws:s3:::notification-canada-ca-production-sms-usage-west-2-logs/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::notification-canada-ca-production-sms-usage-logs-san/*",
      "arn:aws:s3:::notification-canada-ca-production-sms-usage-west-2-logs-san/*"
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
      "ses:Describe*",
      "sesv2:Get*",
      "sesv2:List*"
    ]
    resources = ["*"]
  }
}

#
# Performance Test Results Sync policy
#
resource "aws_iam_policy" "notification_performance_test_results" {
  count = var.env == "staging" ? 1 : 0

  name   = local.notification_performance_test_results
  path   = "/"
  policy = data.aws_iam_policy_document.notification_performance_test_results[0].json
}

data "aws_iam_policy_document" "notification_performance_test_results" {
  count = var.env == "staging" ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::notify-performance-test-results-${var.env}"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    resources = [
      "arn:aws:s3:::notify-performance-test-results-${var.env}/*"
    ]
  }
}

