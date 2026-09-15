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
  image_tag           = local.manifest_image_tags["SES_TO_SQS_EMAIL_CALLBACKS_DOCKER_TAG"]
  ecr_repository_name = join("/", slice(split("/", var.ses_to_sqs_email_callbacks_ecr_repository_url), 1, length(split("/", var.ses_to_sqs_email_callbacks_ecr_repository_url))))
}

data "aws_ecr_image" "ses_to_sqs_email_callbacks" {
  repository_name = local.ecr_repository_name
  image_tag       = local.image_tag
}

module "ses_to_sqs_email_callbacks" {
  source                     = "github.com/cds-snc/terraform-modules//lambda?ref=94729229cfcb754146c82a566227e55df6612228" # v11.3.5
  name                       = "ses_to_sqs_email_callbacks"
  billing_tag_value          = var.billing_tag_value
  ecr_arn                    = var.ses_to_sqs_email_callbacks_ecr_arn
  enable_lambda_insights     = true
  image_uri                  = data.aws_ecr_image.ses_to_sqs_email_callbacks.image_uri
  timeout                    = 60
  memory                     = 1024
  log_group_retention_period = var.sensitive_log_retention_period_days
  alias_name                 = "latest"

  policies = [
    data.aws_iam_policy_document.ses_to_sqs_email_callbacks.json
  ]
}

data "aws_iam_policy_document" "ses_to_sqs_email_callbacks" {
  statement {
    actions = [
      "sqs:Get*",
      "sqs:SendMessage"
    ]
    effect    = "Allow"
    resources = [var.sqs_eks_notification_canada_cadelivery_receipts_arn]
  }

  # Gives the lambda function permission to receive messages from the receipt buffer SQS queue
  statement {
    actions = [
      "sqs:GetQueueAttributes",
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage"
    ]
    effect    = "Allow"
    resources = [var.ses_receipt_callback_buffer_arn]
  }
}

resource "aws_lambda_event_source_mapping" "sqs_batch_callbacks_trigger" {
  event_source_arn                   = var.ses_receipt_callback_buffer_arn
  function_name                      = module.ses_to_sqs_email_callbacks.function_name
  enabled                            = true
  batch_size                         = 10
  maximum_batching_window_in_seconds = 1
}
