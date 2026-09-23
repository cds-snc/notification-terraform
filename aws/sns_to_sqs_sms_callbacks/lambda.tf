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
  image_tag           = local.manifest_image_tags["SNS_TO_SQS_SMS_CALLBACKS_DOCKER_TAG"]
  ecr_repository_name = join("/", slice(split("/", var.sns_to_sqs_sms_callbacks_ecr_repository_url), 1, length(split("/", var.sns_to_sqs_sms_callbacks_ecr_repository_url))))
}

data "aws_ecr_image" "sns_to_sqs_sms_callbacks" {
  repository_name = local.ecr_repository_name
  image_tag       = local.image_tag
}

module "sns_to_sqs_sms_callbacks" {
  source                     = "github.com/cds-snc/terraform-modules//lambda?ref=94729229cfcb754146c82a566227e55df6612228" # v11.3.5
  name                       = "sns_to_sqs_sms_callbacks"
  billing_tag_value          = var.billing_tag_value
  ecr_arn                    = var.sns_to_sqs_sms_callbacks_ecr_arn
  enable_lambda_insights     = true
  image_uri                  = data.aws_ecr_image.sns_to_sqs_sms_callbacks.image_uri
  timeout                    = 60
  memory                     = 1024
  log_group_retention_period = var.sensitive_log_retention_period_days
  alias_name                 = "latest"

  policies = [
    data.aws_iam_policy_document.sns_to_sqs_sms_callbacks.json
  ]
}

data "aws_sqs_queue" "delivery-receipts" {
  name = "eks-notification-canada-cadelivery-receipts"
}

data "aws_iam_policy_document" "sns_to_sqs_sms_callbacks" {
  statement {
    actions = [
      "sqs:Get*",
      "sqs:SendMessage"
    ]
    effect    = "Allow"
    resources = [data.aws_sqs_queue.delivery-receipts.arn]
  }
}

##
# CloudWatch log groups for SNS deliveries in ca-central-1
##
resource "aws_lambda_permission" "allow_cloudwatch_logs_sns_successes" {
  count         = var.cloudwatch_enabled ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = module.sns_to_sqs_sms_callbacks.function_name
  principal     = "logs.${var.region}.amazonaws.com"
  source_arn    = "${var.sns_deliveries_ca_central_arn}:*"
}

resource "aws_cloudwatch_log_subscription_filter" "sns_deliveries_ca_central_to_lambda" {
  count           = var.cloudwatch_enabled ? 1 : 0
  name            = "sns_deliveries_ca_central"
  log_group_name  = var.sns_deliveries_ca_central_name
  filter_pattern  = ""
  destination_arn = module.sns_to_sqs_sms_callbacks.function_arn
}

resource "aws_lambda_permission" "allow_cloudwatch_logs_sns_failures" {
  count         = var.cloudwatch_enabled ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = module.sns_to_sqs_sms_callbacks.function_name
  principal     = "logs.${var.region}.amazonaws.com"
  source_arn    = "${var.sns_deliveries_failures_ca_central_arn}:*"
}

resource "aws_cloudwatch_log_subscription_filter" "sns_deliveries_failures_ca_central_to_lambda" {
  count           = var.cloudwatch_enabled ? 1 : 0
  name            = "sns_deliveries_failures_ca_central"
  log_group_name  = var.sns_deliveries_failures_ca_central_name
  filter_pattern  = ""
  destination_arn = module.sns_to_sqs_sms_callbacks.function_arn
}

##
# CloudWatch log groups for SNS deliveries in us-west-2
##
resource "aws_lambda_permission" "allow_cloudwatch_logs_sns_successes_us_west_2" {
  count         = var.cloudwatch_enabled ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = module.sns_to_sqs_sms_callbacks.function_name
  principal     = "logs.us-west-2.amazonaws.com"
  source_arn    = "${var.sns_deliveries_us_west_2_arn}:*"
}

resource "aws_cloudwatch_log_subscription_filter" "sns_deliveries_us_west_2_to_lambda" {
  count           = var.cloudwatch_enabled ? 1 : 0
  provider        = aws.core_services_us_west_2
  name            = "sns_deliveries_us_west_2_to_lambda"
  log_group_name  = var.sns_deliveries_us_west_2_name
  filter_pattern  = ""
  destination_arn = module.sns_to_sqs_sms_callbacks.function_arn
}

resource "aws_lambda_permission" "allow_cloudwatch_logs_sns_failures_us_west_2" {
  count         = var.cloudwatch_enabled ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = module.sns_to_sqs_sms_callbacks.function_name
  principal     = "logs.us-west-2.amazonaws.com"
  source_arn    = "${var.sns_deliveries_failures_us_west_2_arn}:*"
}

resource "aws_cloudwatch_log_subscription_filter" "sns_deliveries_failures_us_west_2_to_lambda" {
  count           = var.cloudwatch_enabled ? 1 : 0
  provider        = aws.core_services_us_west_2
  name            = "sns_deliveries_failures_us_west_2_to_lambda"
  log_group_name  = var.sns_deliveries_failures_us_west_2_name
  filter_pattern  = ""
  destination_arn = module.sns_to_sqs_sms_callbacks.function_arn
}
