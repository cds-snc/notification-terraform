###
# AWS EKS Cloudwatch groups
###

resource "aws_cloudwatch_log_group" "notification-canada-ca-eks-cluster-logs" {
  count             = var.cloudwatch_enabled ? 1 : 0
  name              = "/aws/eks/${var.eks_cluster_name}/cluster"
  retention_in_days = var.log_retention_period_days
}

resource "aws_cloudwatch_log_group" "notification-canada-ca-eks-application-logs" {
  count             = var.cloudwatch_enabled ? 1 : 0
  name              = "/aws/containerinsights/${var.eks_cluster_name}/application"
  retention_in_days = var.log_retention_period_days
}

resource "aws_cloudwatch_log_group" "notification-canada-ca-eks-prometheus-logs" {
  count             = var.cloudwatch_enabled ? 1 : 0
  name              = "/aws/containerinsights/${var.eks_cluster_name}/prometheus"
  retention_in_days = var.log_retention_period_days
}


###
# AWS EKS Cloudwatch log metric filters
###
resource "aws_cloudwatch_log_metric_filter" "web-500-errors" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "web-500-errors"
  pattern        = "\"\\\" 500 \""
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-application-logs[0].name

  metric_transformation {
    name      = "500-errors"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "celery-error" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "celery-error"
  pattern        = "?\"ERROR/Worker\" ?\"ERROR/ForkPoolWorker\" ?\"WorkerLostError\""
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-application-logs[0].name

  metric_transformation {
    name      = "celery-error"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "malware-detected" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "malware-detected"
  pattern        = jsonencode("Malicious content detected! Download and attachment failed")
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-application-logs[0].name

  metric_transformation {
    name      = "malware-detected"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "scanfiles-timeout" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "scanfiles-timeout"
  pattern        = "Malware scan timed out for notification.id"
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-application-logs[0].name

  metric_transformation {
    name      = "scanfiles-timeout"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "bounce-rate-critical" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "bounce-rate-critical"
  pattern        = "critical bounce rate threshold of 10"
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-application-logs[0].name

  metric_transformation {
    name      = "bounce-rate-critical"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "api-evicted-pods" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "api-evicted-pods"
  pattern        = "{ ($.reason = \"Evicted\") && ($.kube_pod_status_reason = 1) && ($.pod = \"api-*\") }"
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-prometheus-logs[0].name

  metric_transformation {
    name      = "api-evicted-pods"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "celery-evicted-pods" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "celery-evicted-pods"
  pattern        = "{ ($.reason = \"Evicted\") && ($.kube_pod_status_reason = 1) && ($.pod = \"celery-*\") }"
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-prometheus-logs[0].name

  metric_transformation {
    name      = "celery-evicted-pods"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "admin-evicted-pods" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "admin-evicted-pods"
  pattern        = "{ ($.reason = \"Evicted\") && ($.kube_pod_status_reason = 1) && ($.pod = \"admin-*\") }"
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-prometheus-logs[0].name

  metric_transformation {
    name      = "admin-evicted-pods"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "document-download-evicted-pods" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "document-download-evicted-pods"
  pattern        = "{ ($.reason = \"Evicted\") && ($.kube_pod_status_reason = 1) && ($.pod = \"document-download-*\") }"
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-prometheus-logs[0].name

  metric_transformation {
    name      = "document-download-evicted-pods"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "documentation-evicted-pods" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "documentation-evicted-pods"
  pattern        = "{ ($.reason = \"Evicted\") && ($.kube_pod_status_reason = 1) && ($.pod = \"documentation-*\") }"
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-prometheus-logs[0].name

  metric_transformation {
    name      = "documentation-evicted-pods"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "aggregating-queues-are-active" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "aggregating-queues-are-active"
  pattern        = "Batch saving with"
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-application-logs[0].name

  metric_transformation {
    name      = "aggregating-queues-are-active"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "github-arc-write-alarm" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "GitHub ARC Runners Write Alarm"
  pattern        = "WRITE ERROR"
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-application-logs[0].name

  metric_transformation {
    name      = "aggregating-github-arc-write-alarm"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "callback-max-retry-failures" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "callback-max-retry-failures"
  pattern        = "send_delivery_status_to_service has retried the max num of times for callback url"
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-application-logs[0].name

  metric_transformation {
    name      = "callback-max-retry-failures"
    namespace = "LogMetrics"
    value     = "1"
  }
}
