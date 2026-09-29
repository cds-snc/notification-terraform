data "github_repository_file" "manifests_env" {
  count      = local.use_manifest_image ? 1 : 0
  repository = "notification-manifests"
  branch     = "main"
  file       = "helmfile/overrides/${var.env}.env"
}

locals {
  use_manifest_image        = var.env != "sandbox" && !var.bootstrap
  image_tag                 = local.use_manifest_image ? yamldecode(data.github_repository_file.manifests_env[0].content)["PINPOINT_TO_SQS_SMS_CALLBACKS_DOCKER_TAG"] : null
  ecr_repository_name       = join("/", slice(split("/", var.pinpoint_to_sqs_sms_callbacks_ecr_repository_url), 1, length(split("/", var.pinpoint_to_sqs_sms_callbacks_ecr_repository_url))))
  us_west_2_repository_name = join("/", slice(split("/", var.pinpoint_to_sqs_sms_callbacks_us_west_2_ecr_repository_url), 1, length(split("/", var.pinpoint_to_sqs_sms_callbacks_us_west_2_ecr_repository_url))))
  ecr_image_available       = local.use_manifest_image && var.pinpoint_to_sqs_sms_callbacks_ecr_repository_url != "" && !startswith(var.pinpoint_to_sqs_sms_callbacks_ecr_repository_url, "123456789012.")
  us_west_2_image_available = local.use_manifest_image && var.pinpoint_to_sqs_sms_callbacks_us_west_2_ecr_repository_url != "" && !startswith(var.pinpoint_to_sqs_sms_callbacks_us_west_2_ecr_repository_url, "123456789012.")
}

data "aws_ecr_image" "pinpoint_to_sqs_sms_callbacks" {
  count           = local.ecr_image_available ? 1 : 0
  repository_name = local.ecr_repository_name
  image_tag       = local.image_tag
}

data "aws_ecr_image" "pinpoint_to_sqs_sms_callbacks_us_west_2" {
  count           = local.us_west_2_image_available ? 1 : 0
  provider        = aws.core_services_us_west_2
  repository_name = local.us_west_2_repository_name
  image_tag       = local.image_tag
}

module "pinpoint_to_sqs_sms_callbacks" {
  source                     = "github.com/cds-snc/terraform-modules//lambda?ref=94729229cfcb754146c82a566227e55df6612228" # v11.3.5
  name                       = "pinpoint_to_sqs_sms_callbacks"
  billing_tag_value          = var.billing_tag_value
  ecr_arn                    = var.pinpoint_to_sqs_sms_callbacks_ecr_arn
  enable_lambda_insights     = true
  image_uri                  = local.ecr_image_available ? data.aws_ecr_image.pinpoint_to_sqs_sms_callbacks[0].image_uri : "${var.pinpoint_to_sqs_sms_callbacks_ecr_repository_url}:${var.bootstrap ? "bootstrap" : "latest"}"
  timeout                    = 60
  memory                     = 1024
  log_group_retention_period = var.sensitive_log_retention_period_days

  environment_variables = {
    SQS_QUEUE_URL = "https://sqs.ca-central-1.amazonaws.com/${var.account_id}/eks-notification-canada-cadelivery-receipts"
  }

  policies = [
    data.aws_iam_policy_document.pinpoint_to_sqs_sms_callbacks.json
  ]
}

data "aws_iam_policy_document" "pinpoint_to_sqs_sms_callbacks" {
  statement {
    actions = [
      "sqs:Get*",
      "sqs:SendMessage"
    ]
    effect = "Allow"
    resources = [
      var.sqs_deliver_receipts_queue_arn,
      var.sqs_deliver_receipts_queue_us_west_2_arn
    ]
  }
}

resource "aws_lambda_permission" "allow_cloudwatch_logs_pinpoint_successes" {
  count         = var.cloudwatch_enabled ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = module.pinpoint_to_sqs_sms_callbacks.function_name
  principal     = "logs.${var.region}.amazonaws.com"
  source_arn    = "${aws_cloudwatch_log_group.pinpoint_deliveries.arn}:*"
}

resource "aws_cloudwatch_log_subscription_filter" "pinpoint_deliveries_ca_central_to_lambda" {
  count           = var.cloudwatch_enabled ? 1 : 0
  name            = "pinpoint_deliveries_ca_central"
  log_group_name  = aws_cloudwatch_log_group.pinpoint_deliveries.name
  filter_pattern  = ""
  destination_arn = module.pinpoint_to_sqs_sms_callbacks.function_arn
}

resource "aws_lambda_permission" "allow_cloudwatch_logs_pinpoint_failures" {
  count         = var.cloudwatch_enabled ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = module.pinpoint_to_sqs_sms_callbacks.function_name
  principal     = "logs.${var.region}.amazonaws.com"
  source_arn    = "${aws_cloudwatch_log_group.pinpoint_deliveries_failures.arn}:*"
}

resource "aws_cloudwatch_log_subscription_filter" "pinpoint_deliveries_failures_ca_central_to_lambda" {
  count           = var.cloudwatch_enabled ? 1 : 0
  name            = "pinpoint_deliveries_failures_ca_central"
  log_group_name  = aws_cloudwatch_log_group.pinpoint_deliveries_failures.name
  filter_pattern  = ""
  destination_arn = module.pinpoint_to_sqs_sms_callbacks.function_arn
}

module "pinpoint_to_sqs_sms_callbacks_us_west_2" {
  count                      = 1
  source                     = "github.com/cds-snc/terraform-modules//lambda?ref=94729229cfcb754146c82a566227e55df6612228" # v11.3.5
  name                       = "pinpoint_to_sqs_sms_callbacks_us_west_2"
  billing_tag_value          = var.billing_tag_value
  ecr_arn                    = var.pinpoint_to_sqs_sms_callbacks_us_west_2_ecr_arn
  enable_lambda_insights     = true
  image_uri                  = local.us_west_2_image_available ? data.aws_ecr_image.pinpoint_to_sqs_sms_callbacks_us_west_2[0].image_uri : "${var.pinpoint_to_sqs_sms_callbacks_us_west_2_ecr_repository_url}:${var.bootstrap ? "bootstrap" : "latest"}"
  timeout                    = 60
  memory                     = 1024
  log_group_retention_period = var.sensitive_log_retention_period_days

  providers = {
    aws = aws.core_services_us_west_2
  }

  environment_variables = {
    SQS_QUEUE_URL = "https://sqs.ca-central-1.amazonaws.com/${var.account_id}/eks-notification-canada-cadelivery-receipts"
  }

  policies = [
    data.aws_iam_policy_document.pinpoint_to_sqs_sms_callbacks.json
  ]
}

resource "aws_lambda_permission" "allow_cloudwatch_logs_pinpoint_us_successes" {
  provider      = aws.core_services_us_west_2
  count         = var.cloudwatch_enabled ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = module.pinpoint_to_sqs_sms_callbacks_us_west_2[0].function_name
  principal     = "logs.${var.region_pinpoint_us}.amazonaws.com"
  source_arn    = "${aws_cloudwatch_log_group.pinpoint_us_deliveries.arn}:*"
}

resource "aws_cloudwatch_log_subscription_filter" "pinpoint_deliveries_us_west_2_to_lambda" {
  provider        = aws.core_services_us_west_2
  count           = var.cloudwatch_enabled ? 1 : 0
  name            = "pinpoint_deliveries_us_west_2"
  log_group_name  = aws_cloudwatch_log_group.pinpoint_us_deliveries.name
  filter_pattern  = ""
  destination_arn = module.pinpoint_to_sqs_sms_callbacks_us_west_2[0].function_arn
  depends_on      = [aws_lambda_permission.allow_cloudwatch_logs_pinpoint_us_successes]
}

resource "aws_lambda_permission" "allow_cloudwatch_logs_pinpoint_us_failures" {
  provider      = aws.core_services_us_west_2
  count         = var.cloudwatch_enabled ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = module.pinpoint_to_sqs_sms_callbacks_us_west_2[0].function_name
  principal     = "logs.${var.region_pinpoint_us}.amazonaws.com"
  source_arn    = "${aws_cloudwatch_log_group.pinpoint_us_deliveries_failures.arn}:*"
}

resource "aws_cloudwatch_log_subscription_filter" "pinpoint_deliveries_failures_us_west_2_to_lambda" {
  provider        = aws.core_services_us_west_2
  count           = var.cloudwatch_enabled ? 1 : 0
  name            = "pinpoint_deliveries_failures_us_west_2"
  log_group_name  = aws_cloudwatch_log_group.pinpoint_us_deliveries_failures.name
  filter_pattern  = ""
  destination_arn = module.pinpoint_to_sqs_sms_callbacks_us_west_2[0].function_arn
  depends_on      = [aws_lambda_permission.allow_cloudwatch_logs_pinpoint_us_failures]
}
