# Note to maintainers:
# Updating alarms? Update the Google Sheet also!
# https://docs.google.com/spreadsheets/d/1gkrL3Trxw0xEkX724C1bwpfeRsTlK2X60wtCjF6MFRA/edit
#
# There are also alarms defined in aws/common/cloudwatch_alarms.tf

resource "aws_cloudwatch_metric_alarm" "load-balancer-1-500-error-1-minute-warning" {
  alarm_name          = "load-balancer-1-500-error-1-minute-warning"
  alarm_description   = "One 500 error in 1 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "HTTPCode_ELB_500_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Sum"
  threshold           = 1
  alarm_actions       = [var.sns_alert_warning_arn]
  treat_missing_data  = "notBreaching"
  dimensions = {
    LoadBalancer = aws_alb.notification-canada-ca.arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "load-balancer-10-500-error-5-minutes-critical" {
  alarm_name          = "load-balancer-10-500-error-5-minutes-critical"
  alarm_description   = "Ten 500 errors in 5 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "HTTPCode_ELB_500_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "300"
  statistic           = "Sum"
  threshold           = 10
  alarm_actions       = [var.sns_alert_critical_arn]
  ok_actions          = [var.sns_alert_critical_arn]
  treat_missing_data  = "notBreaching"

  dimensions = {
    LoadBalancer = aws_alb.notification-canada-ca.arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "load-balancer-1-502-error-1-minute-warning" {
  alarm_name          = "load-balancer-1-502-error-1-minute-warning"
  alarm_description   = "One 502 error in 1 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "HTTPCode_ELB_502_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Sum"
  threshold           = 1
  alarm_actions       = [var.sns_alert_warning_arn]
  treat_missing_data  = "notBreaching"
  dimensions = {
    LoadBalancer = aws_alb.notification-canada-ca.arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "load-balancer-10-502-error-5-minutes-critical" {
  alarm_name          = "load-balancer-10-502-error-5-minutes-critical"
  alarm_description   = "Ten 502 errors in 5 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "HTTPCode_ELB_502_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "300"
  statistic           = "Sum"
  threshold           = 10
  alarm_actions       = [var.sns_alert_critical_arn]
  ok_actions          = [var.sns_alert_critical_arn]
  treat_missing_data  = "notBreaching"
  dimensions = {
    LoadBalancer = aws_alb.notification-canada-ca.arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "document-download-api-high-request-count-warning" {
  alarm_name          = "document-download-api-high-request-count-warning"
  alarm_description   = "More than 300 4XX requests in 10 minutes on ${aws_alb_target_group.notification-canada-ca-document-api.name} target group"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "HTTPCode_Target_4XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60 * 10
  statistic           = "Sum"
  threshold           = 300
  alarm_actions       = [var.sns_alert_warning_arn]
  treat_missing_data  = "notBreaching"
  dimensions = {
    LoadBalancer = aws_alb.notification-canada-ca.arn_suffix
    TargetGroup  = aws_alb_target_group.notification-canada-ca-document-api.arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "logs-1-celery-error-1-minute-warning" {
  alarm_name          = "logs-1-celery-error-1-minute-warning"
  alarm_description   = "One Celery error in 1 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.celery-error.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.celery-error.metric_transformation[0].namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "logs-10-celery-error-1-minute-critical" {
  alarm_name          = "logs-10-celery-error-1-minute-critical"
  alarm_description   = "Ten Celery errors in 1 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.celery-error.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.celery-error.metric_transformation[0].namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = 10
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_critical_arn]
  ok_actions          = [var.sns_alert_critical_arn]
}

resource "aws_cloudwatch_metric_alarm" "logs-1-500-error-1-minute-warning" {
  alarm_name          = "logs-1-500-error-1-minute-warning"
  alarm_description   = "One 500 error in 1 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.web-500-errors.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.web-500-errors.metric_transformation[0].namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "logs-10-500-error-5-minutes-critical" {
  alarm_name          = "logs-10-500-error-5-minutes-critical"
  alarm_description   = "Ten 500 errors in 5 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.web-500-errors.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.web-500-errors.metric_transformation[0].namespace
  period              = "300"
  statistic           = "Sum"
  threshold           = 10
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_critical_arn]
  ok_actions          = [var.sns_alert_critical_arn]
}

resource "aws_cloudwatch_metric_alarm" "admin-pods-high-cpu-warning" {
  alarm_name          = "admin-pods-high-cpu-warning"
  alarm_description   = "Average CPU of admin pods >=50% during 10 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "pod_cpu_utilization"
  namespace           = "ContainerInsights"
  period              = "300"
  statistic           = "Average"
  threshold           = 50
  alarm_actions       = [var.sns_alert_warning_arn]
  dimensions = {
    Namespace   = "notification-canada-ca"
    Service     = "admin"
    ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
  }
}

resource "aws_cloudwatch_metric_alarm" "api-pods-high-cpu-warning" {
  alarm_name          = "api-pods-high-cpu-warning"
  alarm_description   = "Average CPU of API pods >=50% during 10 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "pod_cpu_utilization"
  namespace           = "ContainerInsights"
  period              = "300"
  statistic           = "Average"
  threshold           = 50
  alarm_actions       = [var.sns_alert_warning_arn]
  dimensions = {
    Namespace   = "notification-canada-ca"
    Service     = "api"
    ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
  }
}

resource "aws_cloudwatch_metric_alarm" "celery-pods-high-cpu-warning" {
  alarm_name          = "celery-pods-high-cpu-warning"
  alarm_description   = "Average CPU of Celery pods >=50% during 10 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "pod_cpu_utilization"
  namespace           = "ContainerInsights"
  period              = "300"
  statistic           = "Average"
  threshold           = 50
  alarm_actions       = [var.sns_alert_warning_arn]
  dimensions = {
    Namespace   = "notification-canada-ca"
    Service     = "celery"
    ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
  }
}

resource "aws_cloudwatch_metric_alarm" "celery-sms-pods-high-cpu-warning" {
  alarm_name          = "celery-sms-pods-high-cpu-warning"
  alarm_description   = "Average CPU of celery-sms pods >=50% during 10 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "pod_cpu_utilization"
  namespace           = "ContainerInsights"
  period              = "300"
  statistic           = "Average"
  threshold           = 50
  alarm_actions       = [var.sns_alert_warning_arn]
  dimensions = {
    Namespace   = "notification-canada-ca"
    Service     = "celery-sms"
    ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
  }
}


resource "aws_cloudwatch_metric_alarm" "admin-pods-high-memory-warning" {
  alarm_name          = "admin-pods-high-memory-warning"
  alarm_description   = "Average memory of admin pods >=50% during 10 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "pod_memory_utilization"
  namespace           = "ContainerInsights"
  period              = "300"
  statistic           = "Average"
  threshold           = 50
  alarm_actions       = [var.sns_alert_warning_arn]
  dimensions = {
    Namespace   = "notification-canada-ca"
    Service     = "admin"
    ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
  }
}

resource "aws_cloudwatch_metric_alarm" "api-pods-high-memory-warning" {
  alarm_name          = "api-pods-high-memory-warning"
  alarm_description   = "Average memory of API pods >=50% during 10 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "pod_memory_utilization"
  namespace           = "ContainerInsights"
  period              = "300"
  statistic           = "Average"
  threshold           = 50
  alarm_actions       = [var.sns_alert_warning_arn]
  dimensions = {
    Namespace   = "notification-canada-ca"
    Service     = "api"
    ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
  }
}

resource "aws_cloudwatch_metric_alarm" "celery-pods-high-memory-warning" {
  alarm_name          = "celery-pods-high-memory-warning"
  alarm_description   = "Average memory of Celery pods >=50% during 10 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "pod_memory_utilization"
  namespace           = "ContainerInsights"
  period              = "300"
  statistic           = "Average"
  threshold           = 50
  alarm_actions       = [var.sns_alert_warning_arn]
  dimensions = {
    Namespace   = "notification-canada-ca"
    Service     = "celery"
    ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
  }
}

resource "aws_cloudwatch_metric_alarm" "celery-sms-pods-high-memory-warning" {
  alarm_name          = "celery-sms-pods-high-memory-warning"
  alarm_description   = "Average memory of celery-sms >=50% during 10 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "pod_memory_utilization"
  namespace           = "ContainerInsights"
  period              = "300"
  statistic           = "Average"
  threshold           = 50
  alarm_actions       = [var.sns_alert_warning_arn]
  dimensions = {
    Namespace   = "notification-canada-ca"
    Service     = "celery-sms"
    ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
  }
}

resource "aws_cloudwatch_metric_alarm" "ddos-detected-load-balancer-critical" {
  alarm_name          = "ddos-detected-load-balancer-critical"
  alarm_description   = "DDoS has been detected on the load balancer"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "DDoSDetected"
  namespace           = "AWS/DDoSProtection"
  period              = "60"
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_critical_arn]
  ok_actions          = [var.sns_alert_critical_arn]
  dimensions = {
    ResourceArn = aws_shield_protection.notification-canada-ca.resource_arn
  }
}

resource "aws_cloudwatch_metric_alarm" "logs-1-malware-detected-1-minute-warning" {
  alarm_name          = "logs-1-malware-detected-1-minute-warning"
  alarm_description   = "One malware detected error in 1 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.malware-detected.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.malware-detected.metric_transformation[0].namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "logs-10-malware-detected-1-minute-critical" {
  alarm_name          = "logs-10-malware-detected-1-minute-critical"
  alarm_description   = "Ten malware detected errors in 1 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.malware-detected.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.malware-detected.metric_transformation[0].namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = 10
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_critical_arn]
  ok_actions          = [var.sns_alert_critical_arn]
}

resource "aws_cloudwatch_metric_alarm" "logs-3-scanfiles-timeout-5-minutes-warning" {
  alarm_name          = "logs-3-scanfiles-timeout-5-minutes-warning"
  alarm_description   = "Three scanfiles timeout detected error in 5 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.scanfiles-timeout.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.scanfiles-timeout.metric_transformation[0].namespace
  period              = "300"
  statistic           = "Sum"
  threshold           = 4
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "kubernetes-failed-nodes" {
  alarm_name          = "kubernetes-failed-nodes"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  alarm_description   = "Kubernetes failed node anomalies"
  #Setting to warn until we verify that it is working as expected
  alarm_actions      = [var.sns_alert_warning_arn]
  treat_missing_data = "notBreaching"
  threshold          = 1

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "cluster_failed_node_count"
      namespace   = "ContainerInsights"
      period      = 300
      stat        = "Maximum"
      unit        = "Count"
      dimensions = {
        Name = aws_eks_cluster.notification-canada-ca-eks-cluster.name
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "celery-replicas-unavailable" {
  alarm_name          = "celery-replicas-unavailable"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  alarm_description   = "Celery Replicas Unavailable"
  #Setting to warn until we verify that it is working as expected
  alarm_actions      = [var.sns_alert_warning_arn]
  treat_missing_data = "notBreaching"
  threshold          = 1

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "celery_deployment_replicas_unavailable"
      namespace   = "ContainerInsights/Prometheus"
      period      = 300
      stat        = "Maximum"
      unit        = "Count"
      dimensions = {
        ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
        namespace   = var.notify_k8s_namespace
        deployment  = "celery"
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "celery-sms-replicas-unavailable" {
  alarm_name          = "celery-sms-replicas-unavailable"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  alarm_description   = "Celery SMS Replicas Unavailable"
  #Setting to warn until we verify that it is working as expected
  alarm_actions      = [var.sns_alert_warning_arn]
  treat_missing_data = "notBreaching"
  threshold          = 1

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "kube_deployment_status_replicas_unavailable"
      namespace   = "ContainerInsights/Prometheus"
      period      = 300
      stat        = "Maximum"
      unit        = "Count"
      dimensions = {
        ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
        namespace   = var.notify_k8s_namespace
        deployment  = "celery-sms"
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "admin-replicas-unavailable" {
  alarm_name          = "admin-replicas-unavailable"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  alarm_description   = "Notify Admin Replicas Unavailable"
  #Setting to warn until we verify that it is working as expected
  alarm_actions      = [var.sns_alert_warning_arn]
  treat_missing_data = "notBreaching"
  threshold          = 1

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "kube_deployment_status_replicas_unavailable"
      namespace   = "ContainerInsights/Prometheus"
      period      = 300
      stat        = "Maximum"
      unit        = "Count"
      dimensions = {
        ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
        namespace   = var.notify_k8s_namespace
        deployment  = "admin"
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "api-replicas-unavailable" {
  alarm_name          = "api-replicas-unavailable"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  alarm_description   = "Notify K8S API Replicas Unavailable"
  #Setting to warn until we verify that it is working as expected
  alarm_actions      = [var.sns_alert_warning_arn]
  treat_missing_data = "notBreaching"
  threshold          = 1

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "kube_deployment_status_replicas_unavailable"
      namespace   = "ContainerInsights/Prometheus"
      period      = 300
      stat        = "Maximum"
      unit        = "Count"
      dimensions = {
        ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
        namespace   = var.notify_k8s_namespace
        deployment  = "api"
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "documentation-replicas-unavailable" {
  alarm_name          = "documentation-replicas-unavailable"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  alarm_description   = "Notify Documentation Replicas Unavailable"
  #Setting to warn until we verify that it is working as expected
  alarm_actions      = [var.sns_alert_warning_arn]
  treat_missing_data = "notBreaching"
  threshold          = 1

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "kube_deployment_status_replicas_unavailable"
      namespace   = "ContainerInsights/Prometheus"
      period      = 300
      stat        = "Maximum"
      unit        = "Count"
      dimensions = {
        ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
        namespace   = var.notify_k8s_namespace
        deployment  = "documentation"
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "document-download-api-replicas-unavailable" {
  alarm_name          = "document-download-api-replicas-unavailable"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  alarm_description   = "Notify Document Download API Replicas Unavailable"
  #Setting to warn until we verify that it is working as expected
  alarm_actions      = [var.sns_alert_warning_arn]
  treat_missing_data = "notBreaching"
  threshold          = 1

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "kube_deployment_status_replicas_unavailable"
      namespace   = "ContainerInsights/Prometheus"
      period      = 300
      stat        = "Maximum"
      unit        = "Count"
      dimensions = {
        ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
        namespace   = var.notify_k8s_namespace
        deployment  = "document-download-api"
      }
    }
  }
}
