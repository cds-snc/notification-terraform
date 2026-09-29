data "github_repository_file" "manifests_env" {
  count      = local.use_manifest_image ? 1 : 0
  repository = "notification-manifests"
  branch     = "main"
  file       = "helmfile/overrides/${var.env}.env"
}

locals {
  use_manifest_image  = var.env != "sandbox" && !var.bootstrap
  image_tag           = local.use_manifest_image ? yamldecode(data.github_repository_file.manifests_env[0].content)["GOOGLE_CIDR_DOCKER_TAG"] : null
  ecr_repository_name = join("/", slice(split("/", var.google_cidr_ecr_repository_url), 1, length(split("/", var.google_cidr_ecr_repository_url))))
  ecr_image_available = local.use_manifest_image && var.google_cidr_ecr_repository_url != "" && !startswith(var.google_cidr_ecr_repository_url, "123456789012.")
}

data "aws_ecr_image" "google_cidr" {
  count           = local.ecr_image_available ? 1 : 0
  repository_name = local.ecr_repository_name
  image_tag       = local.image_tag
}

module "lambda-google-cidr" {
  source                 = "github.com/cds-snc/terraform-modules//lambda?ref=94729229cfcb754146c82a566227e55df6612228" # v11.3.5
  name                   = "google-cidr"
  billing_tag_value      = var.billing_tag_value
  ecr_arn                = var.google_cidr_ecr_arn
  enable_lambda_insights = true
  image_uri              = local.ecr_image_available ? data.aws_ecr_image.google_cidr[0].image_uri : "${var.google_cidr_ecr_repository_url}:${var.bootstrap ? "bootstrap" : "latest"}"
  timeout                = 60
  memory                 = 1024

  environment_variables = {
    PREFIX_LIST_ID          = var.google_cidr_prefix_list_id
    GOOGLE_CLOUD_CIDR_URL   = "https://www.gstatic.com/ipranges/cloud.json"
    GOOGLE_SERVICE_CIDR_URL = "https://www.gstatic.com/ipranges/goog.json"
  }

  policies = [
    data.aws_iam_policy_document.google_cidrs.json
  ]
}

resource "aws_lambda_function_event_invoke_config" "google_cidr_invoke_config" {
  function_name                = module.lambda-google-cidr.function_name
  maximum_event_age_in_seconds = 60
  maximum_retry_attempts       = 0
}

resource "aws_cloudwatch_event_target" "google_cidr" {
  arn  = module.lambda-google-cidr.function_arn
  rule = aws_cloudwatch_event_rule.google_cidr.id
}

resource "aws_cloudwatch_event_rule" "google_cidr" {
  name                = "google_cidr_testing"
  description         = "google_cidr_testing event rule"
  schedule_expression = var.google_cidr_schedule_expression
  depends_on          = [module.lambda-google-cidr]
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda-google-cidr.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.google_cidr.arn
}

data "aws_iam_policy_document" "google_cidrs" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeManagedPrefixLists"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:GetManagedPrefixListEntries",
      "ec2:ModifyManagedPrefixList"
    ]
    resources = [
      "arn:aws:ec2:${var.region}:${var.account_id}:prefix-list/${var.google_cidr_prefix_list_id}"
    ]
  }
}
