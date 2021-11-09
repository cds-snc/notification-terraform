resource "aws_lambda_function" "performance-test" {
  function_name = "performance-test"

  package_type = "Image"
  image_uri    = "${aws_ecr_repository.performance-test.repository_url}:latest"

  role    = aws_iam_role.performance-test.arn
  timeout = 60

  memory_size = 1024
  publish     = true

  lifecycle {
    ignore_changes = [
      image_uri,
    ]
  }

  environment {
    variables = {
      LOAD_TEST_PHONE_NUMBER                      = var.load_test_phone_number 
      LOAD_TEST_EMAIL                             = var.load_test_email
      LOAD_TEST_AWS_S3_BUCKET                     = var.load_test_aws_s3_bucket
      LOAD_TEST_CSV_DIRECTORY_PATH                = var.load_test_csv_directory_path
      LOAD_TEST_DOMAIN                            = var.load_test_domain
      LOAD_TEST_SMS_TEMPLATE_ID                   = var.load_test_sms_template_id
      LOAD_TEST_BULK_EMAIL_TEMPLATE_ID            = var.load_test_bulk_email_template_id
      LOAD_TEST_EMAIL_TEMPLATE_ID                 = var.load_test_email_template_id
      LOAD_TEST_EMAIL_WITH_ATTACHMENT_TEMPLATE_ID = var.load_test_email_with_attachment_template_id
      LOAD_TEST_EMAIL_WITH_LINK_TEMPLATE_ID       = var.load_test_email_with_link_template_id
      TEST_AUTH_HEADER                            = var.test_auth_header
    }
  }
}

resource "aws_cloudwatch_event_target" "performance-test" {
  arn  = aws_lambda_function.performance-test.arn
  rule = aws_cloudwatch_event_rule.performance-testing.id

  input_transformer {
    input_paths = {
      instance = "$.detail.instance",
      status   = "$.detail.status",
    }
    input_template = <<-EOF
    {
      "instance_id": <instance>,
      "instance_status": <status>
    }
    EOF
  }
}

resource "aws_cloudwatch_event_rule" "performance-testing" {
  name                = "performance-testing"
  description         = "performance-testing event rule"
  schedule_expression = var.schedule_expression
  depends_on          = [aws_lambda_function.performance-test]
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.performance-test.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_lambda_function.performance-test.arn
  qualifier     = aws_lambda_alias.performance-lambda-alias.name
}
resource "aws_lambda_alias" "performance-lambda-alias" {
  name             = "performance-lambda-alias"
  description      = "Performance testing lambda alias"
  function_name    = aws_lambda_function.performance-test.function_name
  function_version = "$LATEST"
}

resource "aws_iam_role" "performance-test" {
  name = "performance-test-iam-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}
