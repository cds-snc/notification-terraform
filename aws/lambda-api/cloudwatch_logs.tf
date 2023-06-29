#
# API Gateway CloudWatch logging
#

resource "aws_cloudwatch_log_group" "api_gateway_log_group" {
  name              = "api_gateway_log_group"
  retention_in_days = 0
  tags = {
    CostCenter  = "notification-canada-ca-${var.env}"
    Environment = var.env
    Application = "lambda"
  }
}

resource "aws_cloudwatch_log_group" "api_lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.api.function_name}"
  retention_in_days = 0
  tags = {
    CostCenter  = "notification-canada-ca-${var.env}"
    Environment = var.env
    Application = "lambda"
  }
}



# This account will be used by all API Gateway resources in the account and region
resource "aws_api_gateway_account" "api_cloudwatch" {
  cloudwatch_role_arn = aws_iam_role.api_cloudwatch.arn
}

resource "aws_iam_role" "api_cloudwatch" {
  name               = "ApiGatewayCloudWatchRole"
  assume_role_policy = data.aws_iam_policy_document.api_assume.json
}

resource "aws_iam_role_policy_attachment" "api_cloudwatch" {
  role       = aws_iam_role.api_cloudwatch.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

data "aws_iam_policy_document" "api_assume" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

resource "aws_cloudwatch_log_metric_filter" "errors-lambda-api" {
  name           = "errors-lambda-api"
  pattern        = "\"\\\"levelname\\\": \\\"ERROR\\\"\" -\"SF_ERR\""
  log_group_name = aws_cloudwatch_log_group.api_lambda_log_group.name

  metric_transformation {
    name      = "errors-lambda-api"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "errors-salesforce-api" {
  name           = "errors-salesforce-api"
  pattern        = "SF_ERR"
  log_group_name = aws_cloudwatch_log_group.api_lambda_log_group.name

  metric_transformation {
    name      = "errors-salesforce-api"
    namespace = "LogMetrics"
    value     = "1"
  }
}