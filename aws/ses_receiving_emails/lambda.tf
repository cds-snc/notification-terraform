module "ses_receiving_emails" {
  source                 = "github.com/cds-snc/terraform-modules?ref=v4.0.3//lambda"
  name                   = "ses_receiving_emails"
  billing_tag_value      = var.billing_tag_value
  ecr_arn                = aws_ecr_repository.ses_receiving_emails.arn
  enable_lambda_insights = true
  image_uri              = "${aws_ecr_repository.ses_receiving_emails.repository_url}:latest"
  timeout                = 60
  memory                 = 1024

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

resource "aws_cloudwatch_event_target" "ses_receiving_emails" {
  arn  = module.ses_receiving_emails.function_arn
  rule = aws_cloudwatch_event_rule.ses_receiving_emails_testing.id
}

resource "aws_cloudwatch_event_rule" "ses_receiving_emails_testing" {
  name                = "ses_receiving_emails_testing"
  description         = "ses_receiving_emails_testing event rule"
  schedule_expression = var.schedule_expression
  depends_on          = [module.ses_receiving_emails]
}

resource "aws_lambda_permission" "ses_receiving_emails_allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.ses_receiving_emails.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ses_receiving_emails_testing.arn
}

data "aws_iam_policy_document" "ses_recieving_emails_sqs_send" {
  statement {
    actions = [
      "sqs:Get*",
      "sqs:SendMessage"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_lambda_permission" "ses_receiving_emails" {
  action        = "lambda:InvokeFunction"
  function_name = module.ses_receiving_emails.function_name
  principal     = "ses.amazonaws.com"
  # tfsec:ignore:AWS058 Ensure that lambda function permission has a source arn specified
  # can ignore this because we specify `source_account` instead of `source_arn`
  source_account = var.account_id
}
