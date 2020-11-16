###
# AWS EKS Cloudwatch groups
###

resource "aws_cloudwatch_log_group" "notification-canada-ca-eks-cluster-logs" {
  name              = "/aws/eks/notification-canada-ca-${var.env}/cluster"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_metric_filter" "500-errors" {
  name           = "500-errors"
  pattern        = "\"\\\" 500 \""
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-cluster-logs.name

  metric_transformation {
    name      = "500-errors"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "celery-error" {
  name           = "celery-error"
  pattern        = "\"ERROR/Worker\""
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-cluster-logs.name

  metric_transformation {
    name      = "celery-error"
    namespace = "LogMetrics"
    value     = "1"
  }
}
