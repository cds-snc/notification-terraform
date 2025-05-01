module "ses_receiving_emails" {

  providers = {
    aws = aws.us-east-1
  }

  source                     = "github.com/cds-snc/terraform-modules//lambda?ref=v7.4.3"
  name                       = "ses_receiving_emails"
  billing_tag_value          = var.billing_tag_value
  ecr_arn                    = var.ses_receiving_emails_ecr_arn
  enable_lambda_insights     = true
  image_uri                  = "${var.ses_receiving_emails_ecr_repository_url}:${var.ses_receiving_emails_docker_tag}"
  timeout                    = 60
  memory                     = 1024
  log_group_retention_period = var.sensitive_log_retention_period_days
  alias                      = "latest"

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
  provider      = aws.us-east-1
  action        = "lambda:InvokeFunction"
  function_name = module.ses_receiving_emails.function_name
  principal     = "ses.amazonaws.com"
  # tfsec:ignore:AWS058 Ensure that lambda function permission has a source arn specified
  # can ignore this because we specify `source_account` instead of `source_arn`
  source_account = var.account_id
}
