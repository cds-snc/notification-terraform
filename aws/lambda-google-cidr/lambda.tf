module "google_cidr_image" {
  source           = "../modules/manifest_ecr_image"
  environment      = var.env
  account_id       = var.account_id
  region           = var.region
  repository_name  = "lambda/google-cidr"
  tag_key          = "GOOGLE_CIDR_DOCKER_TAG"
  manifest_ref     = var.manifest_ref
  verify_ecr_image = var.verify_manifest_image
}

module "lambda-google-cidr" {
  source                 = "github.com/cds-snc/terraform-modules//lambda?ref=94729229cfcb754146c82a566227e55df6612228" # v11.3.5
  name                   = "google-cidr"
  billing_tag_value      = var.billing_tag_value
  ecr_arn                = var.google_cidr_ecr_arn
  enable_lambda_insights = true
  image_uri              = module.google_cidr_image.image_uri
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
