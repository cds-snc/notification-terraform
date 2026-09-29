data "github_repository_file" "manifests_env" {
  count      = local.use_manifest_image ? 1 : 0
  repository = "notification-manifests"
  branch     = "main"
  file       = "helmfile/overrides/${var.env}.env"
}

locals {
  use_manifest_image  = var.env != "sandbox" && !var.bootstrap
  image_tag           = local.use_manifest_image ? yamldecode(data.github_repository_file.manifests_env[0].content)["SYSTEM_STATUS_DOCKER_TAG"] : null
  ecr_repository_name = join("/", slice(split("/", var.system_status_ecr_repository_url), 1, length(split("/", var.system_status_ecr_repository_url))))
  ecr_image_available = local.use_manifest_image && var.system_status_ecr_repository_url != "" && !startswith(var.system_status_ecr_repository_url, "123456789012.")
}

data "aws_ecr_image" "system_status" {
  count           = local.ecr_image_available ? 1 : 0
  repository_name = local.ecr_repository_name
  image_tag       = local.image_tag
}

module "system_status" {
  source                 = "github.com/cds-snc/terraform-modules//lambda?ref=94729229cfcb754146c82a566227e55df6612228" # v11.3.5
  name                   = "system_status"
  billing_tag_value      = var.billing_tag_value
  ecr_arn                = var.system_status_ecr_arn
  enable_lambda_insights = true
  image_uri              = local.ecr_image_available ? data.aws_ecr_image.system_status[0].image_uri : "${var.system_status_ecr_repository_url}:${var.bootstrap ? "bootstrap" : "latest"}"
  timeout                = 60
  memory                 = 1024
  policies               = [data.aws_iam_policy_document.system_status_s3_permissions.json]
  alias_name             = "latest"

  vpc = {
    security_group_ids = [
      var.eks_cluster_securitygroup,
    ]
    subnet_ids = var.vpc_private_subnets
  }

  environment_variables = {
    system_status_admin_url            = var.system_status_admin_url
    system_status_api_url              = var.system_status_api_url
    system_status_bucket_name          = "notification-canada-ca-${var.env}-system-status"
    sqlalchemy_database_reader_uri     = "postgresql://app_db_user:${var.app_db_user_password}@${var.database_read_only_proxy_endpoint}/${var.rds_database_name}"
    gc_articles_waf_rate_bypass_secret = var.gc_articles_waf_rate_bypass_secret
  }
}

resource "aws_lambda_function_event_invoke_config" "system_status_invoke_config" {
  function_name                = module.system_status.function_name
  maximum_event_age_in_seconds = 120
  maximum_retry_attempts       = 0
}

resource "aws_cloudwatch_event_target" "system_status" {
  count = var.cloudwatch_enabled ? 1 : 0
  arn   = module.system_status.function_arn
  rule  = aws_cloudwatch_event_rule.system_status_testing[0].id
}

resource "aws_cloudwatch_event_rule" "system_status_testing" {
  count               = var.cloudwatch_enabled ? 1 : 0
  name                = "system_status_testing"
  description         = "system_status_testing event rule"
  schedule_expression = var.system_status_schedule_expression
  depends_on          = [module.system_status]
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  count         = var.cloudwatch_enabled ? 1 : 0
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.system_status.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.system_status_testing[0].arn
}
