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

  providers = {
    aws = aws.us-east-1
  }
}

resource "aws_lambda_function_event_invoke_config" "ses_receiving_emails_invoke_config" {
  function_name                = module.ses_receiving_emails.function_name
  maximum_event_age_in_seconds = 60
  maximum_retry_attempts       = 0
  provider                     = aws.us-east-1
}

resource "aws_cloudwatch_event_target" "ses_receiving_emails" {
  arn      = module.ses_receiving_emails.function_arn
  rule     = aws_cloudwatch_event_rule.ses_receiving_emails_testing.id
  provider = aws.us-east-1
}

resource "aws_cloudwatch_event_rule" "ses_receiving_emails_testing" {
  name                = "ses_receiving_emails_testing"
  description         = "ses_receiving_emails_testing event rule"
  schedule_expression = var.schedule_expression
  depends_on          = [module.ses_receiving_emails]
  provider            = aws.us-east-1
}

resource "aws_lambda_permission" "ses_receiving_emails_allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.ses_receiving_emails.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ses_receiving_emails_testing.arn
  provider      = aws.us-east-1
}
