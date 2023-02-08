module "sns_to_sqs_sms_callbacks" {
  source                 = "github.com/cds-snc/terraform-modules?ref=v4.0.3//lambda"
  name                   = "sns_to_sqs_sms_callbacks"
  billing_tag_value      = var.billing_tag_value
  ecr_arn                = aws_ecr_repository.sns_to_sqs_sms_callbacks.arn
  enable_lambda_insights = true
  image_uri              = "${aws_ecr_repository.sns_to_sqs_sms_callbacks.repository_url}:latest"
  timeout                = 60
  memory                 = 1024

  policies = [
    data.aws_iam_policy_document.sns_to_sqs_sms_callbacks.json
  ]
}

data "aws_iam_policy_document" "sns_to_sqs_sms_callbacks" {
  statement {
    actions = [
      "sqs:Get*",
      "sqs:SendMessage"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_lambda_permission" "sns_to_sqs_sms_callbacks" {
  action        = "lambda:InvokeFunction"
  function_name = module.ses_to_sqs_email_callbacks.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = var.notification_canada_ca_ses_callback_arn
}

resource "aws_sns_topic_subscription" "sns_to_sqs_sms_callbacks_to_lambda" {
  topic_arn = var.notification_canada_ca_ses_callback_arn
  protocol  = "lambda"
  endpoint  = module.ses_to_sqs_email_callbacks.function_arn
}
