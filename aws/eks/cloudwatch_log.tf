###
# AWS EKS Cloudwatch groups
###

resource "aws_cloudwatch_log_group" "notification-canada-ca-eks-cluster-logs" {
  name              = "/aws/eks/${var.eks_cluster_name}/cluster"
  retention_in_days = 14
}

###
# AWS EKS Cloudwatch log metric filters
###
resource "aws_cloudwatch_log_metric_filter" "web-500-errors" {
  name           = "web-500-errors"
  pattern        = "\"\\\" 500 \""
  log_group_name = local.eks_application_log_group

  metric_transformation {
    name      = "500-errors"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "celery-error" {
  name           = "celery-error"
  pattern        = "?\"ERROR/Worker\" ?\"ERROR/ForkPoolWorker\" ?\"WorkerLostError\""
  log_group_name = local.eks_application_log_group

  metric_transformation {
    name      = "celery-error"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "malware-detected" {
  name           = "malware-detected"
  pattern        = jsonencode("Malicious content detected! Download and attachment failed")
  log_group_name = local.eks_application_log_group

  metric_transformation {
    name      = "malware-detected"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "scanfiles-timeout" {
  name           = "scanfiles-timeout"
  pattern        = "Malware scan timed out for notification.id"
  log_group_name = local.eks_application_log_group

  metric_transformation {
    name      = "scanfiles-timeout"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "bounce-rate-critical" {
  name            = "bounce-rate-critical"
  pattern         = "critical bounce rate threshold of 10%"
  log_group_name  = local.eks_application_log_group

  metric_transformation {
    name      = "bounce-rate-critical"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "bounce-rate-warning" {
  name            = "bounce-rate-warning"
  pattern         = "warning bounce rate threshold of 5%"
  log_group_name  = local.eks_application_log_group

    metric_transformation {
    name      = "bounce-rate-warning"
    namespace = "LogMetrics"
    value     = "1"
  }
}
