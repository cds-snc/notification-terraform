module "ses_to_sqs_email_callbacks" {
  source                 = "github.com/cds-snc/terraform-modules?ref=v4.0.3//lambda"
  name                   = "ses_to_sqs_email_callbacks"
  billing_tag_value      = var.billing_tag_value
  ecr_arn                = aws_ecr_repository.ses_to_sqs_email_callbacks.arn
  enable_lambda_insights = true
  image_uri              = "${aws_ecr_repository.ses_to_sqs_email_callbacks.repository_url}:latest"
  timeout                = 60
  memory                 = 1024

  environment_variables = {
    NOTIFY_SENDING_DOMAIN   = var.notify_sending_domain
    SQS_REGION              = var.sqs_region
    CELERY_QUEUE_PREFIX     = var.celery_queue_prefix
    GC_NOTIFY_SERVICE_EMAIL = var.gc_notify_service_email
  }
}

resource "aws_lambda_function_event_invoke_config" "ses_to_sqs_email_callbacks_invoke_config" {
  function_name                = module.ses_to_sqs_email_callbacks.function_name
  maximum_event_age_in_seconds = 60
  maximum_retry_attempts       = 0
}

resource "aws_cloudwatch_event_target" "ses_to_sqs_email_callbacks" {
  arn  = module.ses_to_sqs_email_callbacks.function_arn
  rule = aws_cloudwatch_event_rule.ses_to_sqs_email_callbacks_testing.id
}

resource "aws_cloudwatch_event_rule" "ses_to_sqs_email_callbacks_testing" {
  name                = "ses_to_sqs_email_callbacks_testing"
  description         = "ses_to_sqs_email_callbacks event rule"
  schedule_expression = var.schedule_expression
  depends_on          = [module.ses_to_sqs_email_callbacks]
}

resource "aws_lambda_permission" "ses_receiving_emails_allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.ses_receiving_emails.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ses_receiving_emails_testing.arn
}
