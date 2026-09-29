data "github_repository_file" "manifests_env" {
  count      = local.use_manifest_image ? 1 : 0
  repository = "notification-manifests"
  branch     = "main"
  file       = "helmfile/overrides/${var.env}.env"
}

locals {
  use_manifest_image  = var.env != "sandbox" && !var.bootstrap
  image_tag           = local.use_manifest_image ? yamldecode(data.github_repository_file.manifests_env[0].content)["SES_RECEIVING_EMAILS_DOCKER_TAG"] : null
  ecr_repository_name = join("/", slice(split("/", var.ses_receiving_emails_ecr_repository_url), 1, length(split("/", var.ses_receiving_emails_ecr_repository_url))))
  ecr_image_available = local.use_manifest_image && var.ses_receiving_emails_ecr_repository_url != "" && !startswith(var.ses_receiving_emails_ecr_repository_url, "123456789012.")
}

data "aws_ecr_image" "ses_receiving_emails" {
  count           = local.ecr_image_available ? 1 : 0
  provider        = aws.core_services_us_east_1
  repository_name = local.ecr_repository_name
  image_tag       = local.image_tag
}

module "ses_receiving_emails" {

  providers = {
    aws = aws.core_services_us_east_1
  }

  source                     = "github.com/cds-snc/terraform-modules//lambda?ref=94729229cfcb754146c82a566227e55df6612228" # v11.3.5
  name                       = "ses_receiving_emails"
  billing_tag_value          = var.billing_tag_value
  ecr_arn                    = var.ses_receiving_emails_ecr_arn
  enable_lambda_insights     = true
  image_uri                  = local.ecr_image_available ? data.aws_ecr_image.ses_receiving_emails[0].image_uri : "${var.ses_receiving_emails_ecr_repository_url}:${var.bootstrap ? "bootstrap" : "latest"}"
  timeout                    = 60
  memory                     = 1024
  log_group_retention_period = var.sensitive_log_retention_period_days
  alias_name                 = "latest"

  environment_variables = {
    NOTIFY_SENDING_DOMAIN   = var.notify_sending_domain
    SQS_REGION              = var.sqs_region
    CELERY_QUEUE_PREFIX     = var.celery_queue_prefix
    GC_NOTIFY_SERVICE_EMAIL = var.gc_notify_service_email
  }

  policies = [
    data.aws_iam_policy_document.ses_recieving_emails_sqs_send.json
  ]
}

data "aws_iam_policy_document" "ses_recieving_emails_sqs_send" {
  statement {
    actions = [
      "sqs:Get*",
      "sqs:SendMessage"
    ]
    effect    = "Allow"
    resources = [var.sqs_notify_internal_tasks_arn]
  }
}
resource "aws_lambda_permission" "ses_receiving_emails" {
  provider      = aws.core_services_us_east_1
  action        = "lambda:InvokeFunction"
  function_name = module.ses_receiving_emails.function_name
  principal     = "ses.amazonaws.com"
  # tfsec:ignore:AWS058 Ensure that lambda function permission has a source arn specified
  # can ignore this because we specify `source_account` instead of `source_arn`
  source_account = var.account_id
}
