###
# AWS EKS Cloudwatch groups
###

resource "aws_cloudwatch_log_group" "notification-canada-ca-eks-cluster-logs" {
  name              = "/aws/eks/${var.eks_cluster_name}/cluster"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "notification-canada-ca-eks-application-logs" {
  name              = "/aws/containerinsights/${var.eks_cluster_name}/application"
  retention_in_days = var.env == "production" ? 0 : 30
}

resource "aws_cloudwatch_log_group" "notification-canada-ca-eks-prometheus-logs" {
  name              = "/aws/containerinsights/${var.eks_cluster_name}/prometheus"
  retention_in_days = 0
}


###
# AWS EKS Cloudwatch log metric filters
###
resource "aws_cloudwatch_log_metric_filter" "web-500-errors" {
  name           = "web-500-errors"
  pattern        = "\"\\\" 500 \""
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-application-logs.name

  metric_transformation {
    name      = "500-errors"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "celery-error" {
  name           = "celery-error"
  pattern        = "?\"ERROR/Worker\" ?\"ERROR/ForkPoolWorker\" ?\"WorkerLostError\""
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-application-logs.name

  metric_transformation {
    name      = "celery-error"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "malware-detected" {
  name           = "malware-detected"
  pattern        = jsonencode("Malicious content detected! Download and attachment failed")
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-application-logs.name

  metric_transformation {
    name      = "malware-detected"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "scanfiles-timeout" {
  name           = "scanfiles-timeout"
  pattern        = "Malware scan timed out for notification.id"
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-application-logs.name

  metric_transformation {
    name      = "scanfiles-timeout"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "bounce-rate-critical" {
  name           = "bounce-rate-critical"
  pattern        = "critical bounce rate threshold of 10"
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-application-logs.name

  metric_transformation {
    name      = "bounce-rate-critical"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "bounce-rate-warning" {
  name           = "bounce-rate-warning"
  pattern        = "warning bounce rate threshold of 5"
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-application-logs.name

  metric_transformation {
    name      = "bounce-rate-warning"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "api-evicted-pods" {
  name           = "api-evicted-pods"
  pattern        = "{ ($.reason = \"Evicted\") && ($.kube_pod_status_reason = 1) && ($.pod = \"api-*\") }"
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-prometheus-logs.name

  metric_transformation {
    name      = "api-evicted-pods"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "celery-evicted-pods" {
  name           = "celery-evicted-pods"
  pattern        = "{ ($.reason = \"Evicted\") && ($.kube_pod_status_reason = 1) && ($.pod = \"celery-*\") }"
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-prometheus-logs.name

  metric_transformation {
    name      = "celery-evicted-pods"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "admin-evicted-pods" {
  name           = "admin-evicted-pods"
  pattern        = "{ ($.reason = \"Evicted\") && ($.kube_pod_status_reason = 1) && ($.pod = \"admin-*\") }"
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-prometheus-logs.name

  metric_transformation {
    name      = "admin-evicted-pods"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "document-download-evicted-pods" {
  name           = "document-download-evicted-pods"
  pattern        = "{ ($.reason = \"Evicted\") && ($.kube_pod_status_reason = 1) && ($.pod = \"document-download-*\") }"
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-prometheus-logs.name

  metric_transformation {
    name      = "document-download-evicted-pods"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "documentation-evicted-pods" {
  name           = "documentation-evicted-pods"
  pattern        = "{ ($.reason = \"Evicted\") && ($.kube_pod_status_reason = 1) && ($.pod = \"documentation-*\") }"
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-prometheus-logs.name

  metric_transformation {
    name      = "documentation-evicted-pods"
    namespace = "LogMetrics"
    value     = "1"
  }
}