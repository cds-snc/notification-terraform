data "archive_file" "ses_to_sqs_email_callbacks" {
  type        = "zip"
  source_file = "${path.module}/lambdas/ses_to_sqs_email_callbacks.py"
  output_path = "${path.module}/lambdas/ses_to_sqs_email_callbacks.zip"
}

resource "aws_lambda_function" "ses_to_sqs_email_callbacks" {
  filename      = data.archive_file.ses_to_sqs_email_callbacks.output_path
  function_name = "ses-to-sqs-email-callbacks"
  role          = aws_iam_role.iam_lambda_to_sqs.arn
  handler       = "ses_to_sqs_email_callbacks.lambda_handler"

  source_code_hash = data.archive_file.ses_to_sqs_email_callbacks.output_base64sha256

  runtime = "python3.8"

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

data "archive_file" "sns_to_sqs_sms_callbacks" {
  type        = "zip"
  source_file = "${path.module}/lambdas/sns_to_sqs_sms_callbacks.py"
  output_path = "${path.module}/lambdas/sns_to_sqs_sms_callbacks.zip"
}

resource "aws_lambda_function" "sns_to_sqs_sms_callbacks" {
  filename      = data.archive_file.sns_to_sqs_sms_callbacks.output_path
  function_name = "sns-to-sqs-sms-callbacks"
  role          = aws_iam_role.iam_lambda_to_sqs.arn
  handler       = "sns_to_sqs_sms_callbacks.lambda_handler"

  source_code_hash = data.archive_file.sns_to_sqs_sms_callbacks.output_base64sha256

  runtime = "python3.8"

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

data "archive_file" "ses_receiving_emails" {
  type        = "zip"
  source_file = "${path.module}/lambdas/ses_receiving_emails.py"
  output_path = "${path.module}/lambdas/ses_receiving_emails.zip"
}

resource "aws_lambda_function" "ses_receiving_emails" {
  # https://docs.aws.amazon.com/ses/latest/DeveloperGuide/regions.html#region-receive-email
  # With the exception of Amazon S3 buckets, all of the AWS resources that you use for
  # receiving email with Amazon SES have to be in the same AWS Region as the Amazon SES endpoint.
  provider = aws.us-east-1

  filename      = data.archive_file.ses_receiving_emails.output_path
  function_name = var.lambda_ses_receiving_emails_name
  role          = aws_iam_role.iam_lambda_to_sqs.arn
  handler       = "ses_receiving_emails.lambda_handler"

  source_code_hash = data.archive_file.ses_receiving_emails.output_base64sha256

  runtime = "python3.8"

  environment {
    variables = {
      CELERY_QUEUE_PREFIX     = var.celery_queue_prefix
      NOTIFY_SENDING_DOMAIN   = var.domain
      SQS_REGION              = var.region
      GC_NOTIFY_SERVICE_EMAIL = "gc.notify.gc.notification@${var.domain}"
    }
  }

  depends_on = [aws_cloudwatch_log_group.ses_receiving_emails]

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_lambda_function" "api" {
  function_name = "api"

  package_type = "Image"
  image_uri    = "${aws_ecr_repository.api.repository_url}:latest"

  role    = aws_iam_role.api.arn
  timeout = 60

  memory_size = 1024

  environment {
    variables = {
      ADMIN_CLIENT_SECRET = 
      ADMIN_CLIENT_USER_NAME = 
      API_HOST_NAME = 
      ASSET_DOMAIN = 
      ASSET_UPLOAD_BUCKET_NAME = 
      AUTH_TOKENS = 
      AWS_PINPOINT_REGION = 
      BASE_DOMAIN = 
      CSV_UPLOAD_BUCKET_NAME = 
      DANGEROUS_SALT = 
      DOCUMENTS_BUCKET = 
      ENVIRONMENT = var.env
      MLWR_HOST = 
      NOTIFICATION_QUEUE_PREFIX = 
      NOTIFY_EMAIL_DOMAIN = var.domain
      NOTIFY_ENVIRONMENT = var.environment
      REDIS_ENABLED = 
      REDIS_URL = 
      SECRET_KEY = 
      SQLALCHEMY_DATABASE_READER_URI = 
      SQLALCHEMY_DATABASE_URI = 
      SQLALCHEMY_POOL_SIZE = 
    }
  }

  vpc_config {
    security_group_ids = [module.rds.proxy_security_group_id]
    subnet_ids         = module.vpc.private_subnet_ids
  }

  lifecycle {
    ignore_changes = [
      image_uri,
    ]
  }
}

resource "aws_lambda_permission" "api" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}


##
# CloudWatch log groups for SNS deliveries in ca-central-1
##
resource "aws_lambda_permission" "allow_cloudwatch_logs_sns_successes" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sns_to_sqs_sms_callbacks.function_name
  principal     = "logs.${var.region}.amazonaws.com"
  source_arn    = "${aws_cloudwatch_log_group.sns_deliveries.arn}:*"
}

resource "aws_lambda_permission" "allow_cloudwatch_logs_sns_failures" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sns_to_sqs_sms_callbacks.function_name
  principal     = "logs.${var.region}.amazonaws.com"
  source_arn    = "${aws_cloudwatch_log_group.sns_deliveries_failures.arn}:*"
}

##
# CloudWatch log groups for SNS deliveries in us-west-2
##
resource "aws_lambda_permission" "allow_cloudwatch_logs_sns_successes_us_west_2" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sns_to_sqs_sms_callbacks.function_name
  principal     = "logs.us-west-2.amazonaws.com"
  source_arn    = "${aws_cloudwatch_log_group.sns_deliveries_us_west_2.arn}:*"
}

resource "aws_lambda_permission" "allow_cloudwatch_logs_sns_failures_us_west_2" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sns_to_sqs_sms_callbacks.function_name
  principal     = "logs.us-west-2.amazonaws.com"
  source_arn    = "${aws_cloudwatch_log_group.sns_deliveries_failures_us_west_2.arn}:*"
}

##
# SNS topic for SES deliveries
##
resource "aws_lambda_permission" "allow_sns_ses_callbacks" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ses_to_sqs_email_callbacks.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.notification-canada-ca-ses-callback.arn
}

##
# SNS topics for CloudWatch alarms in us-west-2
##
resource "aws_lambda_permission" "sns_warning_us_west_2_to_slack_lambda" {
  action        = "lambda:InvokeFunction"
  function_name = module.notify_slack_warning.notify_slack_lambda_function_arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.notification-canada-ca-alert-warning-us-west-2.arn
}

resource "aws_lambda_permission" "sns_critical_us_west_2_to_slack_lambda" {
  action        = "lambda:InvokeFunction"
  function_name = module.notify_slack_critical.notify_slack_lambda_function_arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.notification-canada-ca-alert-critical-us-west-2.arn
}

##
# SES in us-east-1 for handling incoming emails
##
resource "aws_lambda_permission" "ses_receiving_emails" {
  provider = aws.us-east-1

  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ses_receiving_emails.function_name
  principal     = "ses.amazonaws.com"
  # tfsec:ignore:AWS058 Ensure that lambda function permission has a source arn specified
  # can ignore this because we specify `source_account` instead of `source_arn`
  source_account = var.account_id
}
