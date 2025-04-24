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
  maximum_batching_window_in_seconds = 5
}
