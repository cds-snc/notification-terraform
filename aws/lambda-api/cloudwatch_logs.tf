#
# API Gateway CloudWatch logging
#

resource "aws_cloudwatch_log_group" "api_gateway_log_group" {
  name              = "api_gateway_log_group"
  retention_in_days = 90
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

resource "aws_cloudwatch_log_metric_filter" "web-500-errors-lambda-api" {
  name           = "web-500-errors-lambda-api"
  pattern        = "\"\\\" 500 \""
  log_group_name = aws_cloudwatch_log_group.api_gateway_log_group.name

  metric_transformation {
    name      = "500-errors-lambda-api"
    namespace = "LogMetrics"
    value     = "1"
  }
}

