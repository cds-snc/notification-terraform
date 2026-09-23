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
  image_tag           = local.manifest_image_tags["SES_RECEIVING_EMAILS_DOCKER_TAG"]
  ecr_repository_name = join("/", slice(split("/", var.ses_receiving_emails_ecr_repository_url), 1, length(split("/", var.ses_receiving_emails_ecr_repository_url))))
}

data "aws_ecr_image" "ses_receiving_emails" {
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
  image_uri                  = data.aws_ecr_image.ses_receiving_emails.image_uri
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
