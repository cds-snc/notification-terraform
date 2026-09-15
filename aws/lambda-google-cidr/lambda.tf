data "github_repository_file" "manifests_env" {
  repository = "notification-manifests"
  branch     = "main"
  file       = "helmfile/overrides/${var.env}.env"
}

locals {
  manifest_env_tag_matches = [
    for line in split("\n", data.github_repository_file.manifests_env.content) :
    regex("^([A-Z0-9_]+_DOCKER_TAG):[[:space:]]*\"([^\"]+)\"", line)
    if can(regex("^([A-Z0-9_]+_DOCKER_TAG):[[:space:]]*\"([^\"]+)\"", line))
  ]
  manifest_image_tags = { for match in local.manifest_env_tag_matches : match[0] => match[1] }
  image_tag           = local.manifest_image_tags["GOOGLE_CIDR_DOCKER_TAG"]
  ecr_repository_name = join("/", slice(split("/", var.google_cidr_ecr_repository_url), 1, length(split("/", var.google_cidr_ecr_repository_url))))
}

data "aws_ecr_image" "google_cidr" {
  repository_name = local.ecr_repository_name
  image_tag       = local.image_tag
}

module "lambda-google-cidr" {
  source                 = "github.com/cds-snc/terraform-modules//lambda?ref=94729229cfcb754146c82a566227e55df6612228" # v11.3.5
  name                   = "google-cidr"
  billing_tag_value      = var.billing_tag_value
  ecr_arn                = var.google_cidr_ecr_arn
  enable_lambda_insights = true
  image_uri              = data.aws_ecr_image.google_cidr.image_uri
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
