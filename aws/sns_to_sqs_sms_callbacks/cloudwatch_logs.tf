#
# SNS Receiving SMS CloudWatch logging
#

resource "aws_cloudwatch_log_group" "sns_to_sqs_sms_callbacks_log_group" {
  name              = "sns_to_sqs_sms_callbacks_log_group"
  retention_in_days = 90
  tags = {
    CostCentre  = "notification-canada-ca-${var.env}"
    Terraform   = true
    Environment = var.env
    Application = "lambda"
  }
}

resource "aws_cloudwatch_log_metric_filter" "sns_to_sqs_sms_callbacks-500-errors-api" {
  name           = "sns_to_sqs_sms_callbacks-500-errors-api"
  pattern        = "\"\\\"levelname\\\": \\\"ERROR\\\"\""
  log_group_name = "/aws/lambda/${module.sns_to_sqs_sms_callbacks.function_name}"

  metric_transformation {
    name      = "500-errors-sns_to_sqs_sms_callbacks-api"
    namespace = "LogMetrics"
    value     = "1"
  }
  tags = {
    CostCentre = "notification-canada-ca-${var.env}"
    Terraform  = true
  }
}
