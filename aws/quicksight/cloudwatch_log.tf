###
# AWS Quicksight Cloudwatch groups
###

resource "aws_cloudwatch_log_group" "step_functions_logs" {
  provider          = aws.core_services
  count             = var.cloudwatch_enabled ? 1 : 0
  name              = "/aws/stepfunctions/AthenaUpdateTableLocation"
  retention_in_days = var.log_retention_period_days
  tags = {
    CostCenter  = "notification-canada-ca-${var.env}"
    Environment = var.env
  }
}
