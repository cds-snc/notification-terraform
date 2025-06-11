#
# API Gateway CloudWatch logging
#

removed {
  from = aws_cloudwatch_log_group.api_gateway_execution_log_group

  lifecycle {
    destroy = false
  }
}

resource "aws_cloudwatch_log_group" "api_gateway_log_group" {
  name              = "api_gateway_log_group"
  retention_in_days = var.log_retention_period_days
  tags = {
    CostCenter  = "notification-canada-ca-${var.env}"
    Environment = var.env
    Application = "lambda"
  }
}

resource "aws_cloudwatch_log_group" "api_lambda_log_group" {
  count             = var.cloudwatch_enabled ? 1 : 0
  name              = "/aws/lambda/${aws_lambda_function.api.function_name}"
  retention_in_days = var.log_retention_period_days
  tags = {
    CostCenter  = "notification-canada-ca-${var.env}"
    Environment = var.env
    Application = "lambda"
  }
}



# This account will be used by all API Gateway resources in the account and region
resource "aws_api_gateway_account" "api_cloudwatch" {
  count               = var.cloudwatch_enabled ? 1 : 0
  cloudwatch_role_arn = aws_iam_role.api_cloudwatch[0].arn
}

resource "aws_iam_role" "api_cloudwatch" {
  count              = var.cloudwatch_enabled ? 1 : 0
  name               = "ApiGatewayCloudWatchRole"
  assume_role_policy = data.aws_iam_policy_document.api_assume.json
}

resource "aws_iam_role_policy_attachment" "api_cloudwatch" {
  count      = var.cloudwatch_enabled ? 1 : 0
  role       = aws_iam_role.api_cloudwatch[0].name
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
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "errors-lambda-api"
  pattern        = "\"\\\"levelname\\\": \\\"ERROR\\\"\" -\"SF_ERR\""
  log_group_name = aws_cloudwatch_log_group.api_lambda_log_group[0].name

  metric_transformation {
    name      = "errors-lambda-api"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "errors-salesforce-api" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "errors-salesforce-api"
  pattern        = "SF_ERR"
  log_group_name = aws_cloudwatch_log_group.api_lambda_log_group[0].name

  metric_transformation {
    name      = "errors-salesforce-api"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "failed-login-count-more-than-10" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "failed-login-count-more-than-10"
  pattern        = jsonencode("Failed login: Incorrect password for")
  log_group_name = aws_cloudwatch_log_group.api_lambda_log_group[0].name

  metric_transformation {
    name      = "failed-login-count"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "api-gateway-time-out" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "api-gateway-time-out"
  pattern        = "{ $.status = \"504\" }"
  log_group_name = aws_cloudwatch_log_group.api_gateway_log_group.name

  metric_transformation {
    name      = "api-gateway-time-out"
    namespace = "LogMetrics"
    value     = "1"
  }
}
