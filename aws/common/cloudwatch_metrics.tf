resource "aws_cloudwatch_log_metric_filter" "500-errors" {
  name           = "500-errors"
  pattern        = "\"\\\" 500 \""
  log_group_name = var.eks_cluster_log_group_name

  metric_transformation {
    name      = "500-errors"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "celery-error" {
  name           = "celery-error"
  pattern        = "\"ERROR/Worker\""
  log_group_name = var.eks_cluster_log_group_name

  metric_transformation {
    name      = "celery-error"
    namespace = "LogMetrics"
    value     = "1"
  }
}
