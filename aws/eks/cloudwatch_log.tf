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

resource "aws_cloudwatch_log_group" "notification-canada-ca-eks-host-logs" {
  count             = var.cloudwatch_enabled ? 1 : 0
  name              = "/aws/containerinsights/${var.eks_cluster_name}/host"
  retention_in_days = var.log_retention_period_days
}

resource "aws_cloudwatch_log_group" "blazer" {
  count             = var.cloudwatch_enabled ? 1 : 0
  name              = "blazer"
  retention_in_days = 1827 # 5 years
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
  # This should be deprecated once we have the new category of Celery error
  # classifications fully implemented.
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "celery-error"
  pattern        = "%ERROR/.*Worker|ERROR/MainProcess%"
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-application-logs[0].name

  metric_transformation {
    name      = "celery-error"
    namespace = "LogMetrics"
    value     = "1"
  }
}

# We are adding this alarm in to staging since we are seeing some issues with cypress tests causing not found errors in staging
resource "aws_cloudwatch_log_metric_filter" "celery-not-found-error" {
  # This should be deprecated once we have the new category of Celery error
  # classifications fully implemented.
  count          = var.cloudwatch_enabled && var.env == "staging" ? 1 : 0
  name           = "celery-not-found-error"
  pattern        = "%notifications not found for SES references%"
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-application-logs[0].name

  metric_transformation {
    name      = "celery-not-found-error"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "celery-error-unknown" {
  # This is a catch all log metric filter for Celery when unexpected errors occur. We need
  # to keep an eye on closely and monitor.
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "celery-error-unknown"
  pattern        = "\"CELERY_UNKNOWN_ERROR\""
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-application-logs[0].name

  metric_transformation {
    name      = "celery-error-unknown"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "celery-error-duplicate-record" {
  # This monitors for database duplicate record errors in Celery.
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "celery-error-duplicate-record"
  pattern        = "\"CELERY_KNOWN_ERROR::DUPLICATE_RECORD\""
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-application-logs[0].name

  metric_transformation {
    name      = "celery-error-duplicate-record"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "celery-error-job-incomplete" {
  # This monitors for incomplete jobs that couldn't be completed within Celery.
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "celery-error-job-incomplete"
  pattern        = "\"CELERY_KNOWN_ERROR::JOB_INCOMPLETE\""
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-application-logs[0].name

  metric_transformation {
    name      = "celery-error-job-incomplete"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "celery-error-notification-not-found" {
  # This monitors for Celery errors when notifications were not found within the system.
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "celery-error-notification-not-found"
  pattern        = "\"CELERY_KNOWN_ERROR::NOTIFICATION_NOT_FOUND\""
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-application-logs[0].name

  metric_transformation {
    name      = "celery-error-notification-not-found"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "celery-error-shutdown" {
  # This monitors for Celery workers shutting down.
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "celery-error-shutdown"
  pattern        = "\"CELERY_KNOWN_ERROR::SHUTDOWN\""
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-application-logs[0].name

  metric_transformation {
    name      = "celery-error-shutdown"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "celery-error-throttling" {
  # This monitors for Celery errors related to throttling, which could indicate performance issues
  # or capacity limits being hit.
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "celery-error-throttling"
  pattern        = "\"CELERY_KNOWN_ERROR::THROTTLING\""
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-application-logs[0].name

  metric_transformation {
    name      = "celery-error-throttling"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "celery-error-timeout" {
  # This monitors for Celery errors related to network timeouts, which could indicate 
  # performance issues or external dependencies not responding in time.
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "celery-error-timeout"
  pattern        = "\"CELERY_KNOWN_ERROR::TIMEOUT\""
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-application-logs[0].name

  metric_transformation {
    name      = "celery-error-timeout"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "celery-error-xray" {
  # This monitors for Celery errors related to AWS X-Ray, which could indicate issues
  # with observability tracing.
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "celery-error-xray"
  pattern        = "\"CELERY_KNOWN_ERROR::XRAY\""
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-application-logs[0].name

  metric_transformation {
    name      = "celery-error-xray"
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

resource "aws_cloudwatch_log_metric_filter" "malware-scan-timeout" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "malware-scan-timeout"
  pattern        = "Malware scan timed out for notification.id"
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-application-logs[0].name

  metric_transformation {
    name      = "malware-scan-timeout"
    namespace = "LogMetrics"
    value     = "1"
  }
}

moved {
  from = aws_cloudwatch_log_metric_filter.scanfiles-timeout
  to   = aws_cloudwatch_log_metric_filter.malware-scan-timeout
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
  pattern        = "{ ($.reason = \"Evicted\") && ($.kube_pod_status_reason = 1) && ($.pod = \"notify-api-*\") }"
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
  pattern        = "{ ($.reason = \"Evicted\") && ($.kube_pod_status_reason = 1) && ($.pod = \"notify-celery-*\") }"
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
  pattern        = "{ ($.reason = \"Evicted\") && ($.kube_pod_status_reason = 1) && ($.pod = \"notify-admin-*\") }"
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
  pattern        = "{ ($.reason = \"Evicted\") && ($.kube_pod_status_reason = 1) && ($.pod = \"notify-document-download-*\") }"
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
  pattern        = "{ ($.reason = \"Evicted\") && ($.kube_pod_status_reason = 1) && ($.pod = \"notify-documentation-*\") }"
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

resource "aws_cloudwatch_log_metric_filter" "callback-request-failures" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "callback-request-failures"
  pattern        = "send_delivery_status_to_service request failed for notification_id"
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-application-logs[0].name

  metric_transformation {
    name      = "callback-max-retry-failures"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "throttling-exceptions" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "throttling-exceptions"
  pattern        = "ThrottlingException"
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-application-logs[0].name

  metric_transformation {
    name      = "throttling-exceptions"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "db-migration-failure" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "db-migration-failure"
  pattern        = "\"database migration failed\""
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-application-logs[0].name

  metric_transformation {
    name      = "db-migration-failure"
    namespace = "LogMetrics"
    value     = "1"
  }
}


# AWS EKS host log metric filters
resource "aws_cloudwatch_log_metric_filter" "oom-errors" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "oom-errors"
  pattern        = "%Memory cgroup out of memory%"
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-host-logs[0].name

  metric_transformation {
    name      = "oom-errors"
    namespace = "LogMetrics"
    value     = "1"
  }
}

###
# Velero backup errors
###

resource "aws_cloudwatch_log_metric_filter" "velero-error" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "velero-error"
  pattern        = "{ ($.kubernetes.pod_name = \"velero*\") && ($.log = *error*) && ($.log != *warning*) && ($.log != \"*file already closed*\")}"
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-application-logs[0].name

  metric_transformation {
    name      = "velero-error"
    namespace = "LogMetrics"
    value     = "1"
  }
}

###
# CORE DNS resources for Notification application
###

resource "aws_cloudwatch_log_metric_filter" "coredns-nxdomain-notification-filter" {
  count          = var.cloudwatch_enabled ? 1 : 0
  name           = "CoreDNSNXDOMAINNotificationFilter"
  log_group_name = aws_cloudwatch_log_group.notification-canada-ca-eks-application-logs[0].name
  pattern        = "{ $.log = \"*${var.base_domain}. *\" && $.log = \"*NXDOMAIN*\" }"

  metric_transformation {
    name      = "CoreDNSNXDOMAINNotificationCount"
    namespace = "NotificationCanadaCa/DNS"
    value     = "1"
  }
}

