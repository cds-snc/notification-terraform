resource "aws_iam_role" "heartbeat" {
  name = "heartbeat-iam-role"

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

resource "aws_lambda_function" "heartbeat" {
  function_name = "heartbeat"

  package_type = "Image"
  image_uri    = "${aws_ecr_repository.heartbeat.repository_url}:latest"

  role    = aws_iam_role.heartbeat.arn
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
      TF_VAR_heartbeat_api_key                    = var.heartbeat_api_key
      TF_VAR_heartbeat_base_url                   = var.heartbeat_base_url
      TF_VAR_heartbeat_template_id                = var.heartbeat_template_id
    }
  }
}

resource "aws_cloudwatch_event_target" "heartbeat" {
  arn  = aws_lambda_function.heartbeat-test.arn
  rule = aws_cloudwatch_event_rule.heartbeat-testing.id

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

resource "aws_cloudwatch_event_rule" "heartbeat-testing" {
  name                = "heartbeat-testing"
  description         = "heartbeat-testing event rule"
  schedule_expression = var.schedule_expression
  depends_on          = [aws_lambda_function.heartbeat-test]
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.heartbeat.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_lambda_function.heartbeat.arn
  qualifier     = aws_lambda_alias.heartbeat-lambda-alias.name
}

resource "aws_lambda_alias" "heartbeat-lambda-alias" {
  name             = "heartbeat-lambda-alias"
  description      = "Heartbeat testing lambda alias"
  function_name    = aws_lambda_function.heartbeat.function_name
  function_version = "$LATEST"
}

