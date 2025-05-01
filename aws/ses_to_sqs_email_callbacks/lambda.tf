module "ses_to_sqs_email_callbacks" {
  source                     = "github.com/cds-snc/terraform-modules//lambda?ref=v7.4.3"
  name                       = "ses_to_sqs_email_callbacks"
  billing_tag_value          = var.billing_tag_value
  ecr_arn                    = var.ses_to_sqs_email_callbacks_ecr_arn
  enable_lambda_insights     = true
  image_uri                  = "${var.ses_to_sqs_email_callbacks_ecr_repository_url}:${var.ses_to_sqs_callbacks_docker_tag}"
  timeout                    = 60
  memory                     = 1024
  log_group_retention_period = var.sensitive_log_retention_period_days
  alias                      = "latest"

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
}

resource "aws_lambda_permission" "allow_sns_ses_callbacks" {
  action        = "lambda:InvokeFunction"
  function_name = module.ses_to_sqs_email_callbacks.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = var.notification_canada_ca_ses_callback_arn
}

resource "aws_sns_topic_subscription" "ses_sns_to_lambda" {
  topic_arn = var.notification_canada_ca_ses_callback_arn
  protocol  = "lambda"
  endpoint  = module.ses_to_sqs_email_callbacks.function_arn
}
