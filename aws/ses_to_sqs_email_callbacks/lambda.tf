module "ses_to_sqs_email_callbacks" {
  source                 = "github.com/cds-snc/terraform-modules?ref=v4.0.3//lambda"
  name                   = "ses_to_sqs_email_callbacks"
  billing_tag_value      = var.billing_tag_value
  ecr_arn                = aws_ecr_repository.ses_to_sqs_email_callbacks.arn
  enable_lambda_insights = true
  image_uri              = "${aws_ecr_repository.ses_to_sqs_email_callbacks.repository_url}:latest"
  timeout                = 60
  memory                 = 1024

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
    resources = ["eks-notification-canada-cadelivery-receipts", ]
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
