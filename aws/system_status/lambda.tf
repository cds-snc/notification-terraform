locals {
  image_tag = var.env == "production" ? var.system_status_docker_tag : (var.bootstrap == true ? "bootstrap" : "latest")
}

module "system_status" {
  source                 = "github.com/cds-snc/terraform-modules//lambda?ref=v9.6.4"
  name                   = "system_status"
  billing_tag_value      = var.billing_tag_value
  ecr_arn                = var.system_status_ecr_arn
  enable_lambda_insights = true
  image_uri              = "${var.system_status_ecr_repository_url}:${local.image_tag}"
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
    system_status_admin_url        = var.system_status_admin_url
    system_status_api_url          = var.system_status_api_url
    system_status_bucket_name      = "notification-canada-ca-${var.env}-system-status"
    sqlalchemy_database_reader_uri = "postgresql://app_db_user:${var.app_db_user_password}@${var.database_read_only_proxy_endpoint}/NotificationCanadaCa${var.env}"
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
  schedule_expression = var.schedule_expression
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
