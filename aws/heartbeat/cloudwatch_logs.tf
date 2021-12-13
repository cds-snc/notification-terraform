#
# Heartbeat CloudWatch logging
#

resource "aws_cloudwatch_log_group" "heartbeat_log_group" {
  name              = "heartbeat_log_group"
  retention_in_days = 90
  tags = {
    CostCenter  = "notification-canada-ca-${var.env}"
    Environment = var.env
    Application = "lambda"
  }
}

# This account will be used by Heartbeat resources in the account and region
resource "aws_api_gateway_account" "heartbeat_cloudwatch" {
  cloudwatch_role_arn = aws_iam_role.heartbeat_cloudwatch.arn
}

resource "aws_iam_role" "heartbeat_cloudwatch" {
  name               = "HeartbeatCloudWatchRole"
  assume_role_policy = data.aws_iam_policy_document.heartbeat_assume.json
}

resource "aws_iam_role_policy_attachment" "heartbeat_cloudwatch" {
  role       = aws_iam_role.heartbeat_cloudwatch.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

data "aws_iam_policy_document" "heartbeat_assume" {
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

resource "aws_cloudwatch_log_metric_filter" "heartbeat-500-errors-api" {
  name           = "heartbeat-500-errors-api"
  pattern        = "\"\\\" 500 \""
  log_group_name = "/aws/lambda/${module.heartbeat.function_name}"

  metric_transformation {
    name      = "500-errors-heartbeat-api"
    namespace = "LogMetrics"
    value     = "1"
  }
}
