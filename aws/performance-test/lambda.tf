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
