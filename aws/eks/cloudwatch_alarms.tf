# Note to maintainers:
# Updating alarms? Update the Google Sheet also!
# https://docs.google.com/spreadsheets/d/1gkrL3Trxw0xEkX724C1bwpfeRsTlK2X60wtCjF6MFRA/edit
#
# There are also alarms defined in aws/common/cloudwatch_alarms.tf

resource "aws_cloudwatch_metric_alarm" "load-balancer-1-500-error-1-minute-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "load-balancer-1-500-error-1-minute-warning"
  alarm_description   = "One 500 error in 1 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "HTTPCode_ELB_500_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_actions       = [var.sns_alert_warning_arn]
  treat_missing_data  = "notBreaching"
  dimensions = {
    LoadBalancer = aws_alb.notification-canada-ca.arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "load-balancer-10-500-error-5-minutes-critical" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "load-balancer-10-500-error-5-minutes-critical"
  alarm_description   = "Ten 500 errors in 5 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "HTTPCode_ELB_500_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 300
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
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "load-balancer-1-502-error-1-minute-warning"
  alarm_description   = "One 502 error in 1 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "HTTPCode_ELB_502_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_actions       = [var.sns_alert_warning_arn]
  treat_missing_data  = "notBreaching"
  dimensions = {
    LoadBalancer = aws_alb.notification-canada-ca.arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "load-balancer-10-502-error-5-minutes-critical" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "load-balancer-10-502-error-5-minutes-critical"
  alarm_description   = "Ten 502 errors in 5 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "HTTPCode_ELB_502_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 300
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
  count               = var.cloudwatch_enabled ? 1 : 0
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
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "logs-1-celery-error-1-minute-warning"
  alarm_description   = "One Celery error in 1 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.celery-error[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.celery-error[0].metric_transformation[0].namespace
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "logs-10-celery-error-1-minute-critical" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "logs-10-celery-error-1-minute-critical"
  alarm_description   = "Ten Celery errors in 1 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.celery-error[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.celery-error[0].metric_transformation[0].namespace
  period              = 60
  statistic           = "Sum"
  threshold           = 10
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_critical_arn]
  ok_actions          = [var.sns_alert_critical_arn]
}

resource "aws_cloudwatch_metric_alarm" "logs-1-500-error-1-minute-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "logs-1-500-error-1-minute-warning"
  alarm_description   = "One 500 error in 1 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.web-500-errors[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.web-500-errors[0].metric_transformation[0].namespace
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "logs-10-500-error-5-minutes-critical" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "logs-10-500-error-5-minutes-critical"
  alarm_description   = "Ten 500 errors in 5 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.web-500-errors[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.web-500-errors[0].metric_transformation[0].namespace
  period              = 300
  statistic           = "Sum"
  threshold           = 10
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_critical_arn]
  ok_actions          = [var.sns_alert_critical_arn]
}

resource "aws_cloudwatch_metric_alarm" "admin-pods-high-cpu-warning" {
  count                     = var.cloudwatch_enabled ? 1 : 0
  alarm_name                = "admin-pods-high-cpu-warning"
  alarm_description         = "Average CPU of admin pods >=50% during 10 minutes"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "pod_cpu_utilization"
  namespace                 = "ContainerInsights"
  period                    = 300
  statistic                 = "Average"
  threshold                 = 50
  alarm_actions             = [var.sns_alert_warning_arn]
  insufficient_data_actions = [var.sns_alert_warning_arn]
  treat_missing_data        = "missing"
  dimensions = {
    Namespace   = "notification-canada-ca"
    Service     = "notify-admin"
    ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
  }
}

resource "aws_cloudwatch_metric_alarm" "api-pods-high-cpu-warning" {
  count                     = var.cloudwatch_enabled ? 1 : 0
  alarm_name                = "api-pods-high-cpu-warning"
  alarm_description         = "Average CPU of API pods >=50% during 10 minutes"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "pod_cpu_utilization"
  namespace                 = "ContainerInsights"
  period                    = 300
  statistic                 = "Average"
  threshold                 = 50
  alarm_actions             = [var.sns_alert_warning_arn]
  insufficient_data_actions = [var.sns_alert_warning_arn]
  treat_missing_data        = "missing"
  dimensions = {
    Namespace   = "notification-canada-ca"
    Service     = "notify-api"
    ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
  }
}

resource "aws_cloudwatch_metric_alarm" "celery-core-tasks-static-pods-high-cpu-warning" {
  count                     = var.cloudwatch_enabled ? 1 : 0
  alarm_name                = "celery-core-tasks-static-pods-high-cpu-warning"
  alarm_description         = "Average CPU of celery-core-tasks-static pods >=50% during 10 minutes"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "pod_cpu_utilization"
  namespace                 = "ContainerInsights"
  period                    = 300
  statistic                 = "Average"
  threshold                 = 50
  alarm_actions             = [var.sns_alert_warning_arn]
  insufficient_data_actions = [var.sns_alert_warning_arn]
  treat_missing_data        = "missing"
  dimensions = {
    Namespace   = "notification-canada-ca"
    Service     = "notify-celery-core-tasks-static"
    ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
  }
}

resource "aws_cloudwatch_metric_alarm" "celery-core-tasks-scalable-pods-high-cpu-warning" {
  count                     = var.cloudwatch_enabled ? 1 : 0
  alarm_name                = "celery-core-tasks-scalable-pods-high-cpu-warning"
  alarm_description         = "Average CPU of celery-core-tasks-scalable pods >=50% during 10 minutes"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "pod_cpu_utilization"
  namespace                 = "ContainerInsights"
  period                    = 300
  statistic                 = "Average"
  threshold                 = 50
  alarm_actions             = [var.sns_alert_warning_arn]
  insufficient_data_actions = [var.sns_alert_warning_arn]
  treat_missing_data        = "missing"
  dimensions = {
    Namespace   = "notification-canada-ca"
    Service     = "notify-celery-core-tasks-scalable"
    ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
  }
}

resource "aws_cloudwatch_metric_alarm" "celery-sms-dedicated-static-pods-high-cpu-warning" {
  count                     = var.cloudwatch_enabled ? 1 : 0
  alarm_name                = "celery-sms-dedicated-static-pods-high-cpu-warning"
  alarm_description         = "Average CPU of celery-sms-dedicated-static pods >=50% during 10 minutes"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "pod_cpu_utilization"
  namespace                 = "ContainerInsights"
  period                    = 300
  statistic                 = "Average"
  threshold                 = 50
  alarm_actions             = [var.sns_alert_warning_arn]
  insufficient_data_actions = [var.sns_alert_warning_arn]
  treat_missing_data        = "missing"
  dimensions = {
    Namespace   = "notification-canada-ca"
    Service     = "notify-celery-sms-dedicated-static"
    ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
  }
}


resource "aws_cloudwatch_metric_alarm" "admin-pods-high-memory-warning" {
  count                     = var.cloudwatch_enabled ? 1 : 0
  alarm_name                = "admin-pods-high-memory-warning"
  alarm_description         = "Average memory of admin pods >=50% during 10 minutes"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "pod_memory_utilization"
  namespace                 = "ContainerInsights"
  period                    = 300
  statistic                 = "Average"
  threshold                 = 50
  alarm_actions             = [var.sns_alert_warning_arn]
  insufficient_data_actions = [var.sns_alert_warning_arn]
  treat_missing_data        = "missing"
  dimensions = {
    Namespace   = "notification-canada-ca"
    Service     = "notify-admin"
    ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
  }
}

resource "aws_cloudwatch_metric_alarm" "api-pods-high-memory-warning" {
  count                     = var.cloudwatch_enabled ? 1 : 0
  alarm_name                = "api-pods-high-memory-warning"
  alarm_description         = "Average memory of API pods >=50% during 10 minutes"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "pod_memory_utilization"
  namespace                 = "ContainerInsights"
  period                    = 300
  statistic                 = "Average"
  threshold                 = 50
  alarm_actions             = [var.sns_alert_warning_arn]
  insufficient_data_actions = [var.sns_alert_warning_arn]
  treat_missing_data        = "missing"
  dimensions = {
    Namespace   = "notification-canada-ca"
    Service     = "notify-api"
    ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
  }
}

resource "aws_cloudwatch_metric_alarm" "celery-core-tasks-static-pods-high-memory-warning" {
  count                     = var.cloudwatch_enabled ? 1 : 0
  alarm_name                = "celery-core-tasks-static-pods-high-memory-warning"
  alarm_description         = "Average memory of celery-core-tasks-static pods >=50% during 10 minutes"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "pod_memory_utilization"
  namespace                 = "ContainerInsights"
  period                    = 300
  statistic                 = "Average"
  threshold                 = 50
  alarm_actions             = [var.sns_alert_warning_arn]
  insufficient_data_actions = [var.sns_alert_warning_arn]
  treat_missing_data        = "missing"
  dimensions = {
    Namespace   = "notification-canada-ca"
    Service     = "notify-celery-core-tasks-static"
    ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
  }
}

resource "aws_cloudwatch_metric_alarm" "celery-sms-dedicated-static-pods-high-memory-warning" {
  count                     = var.cloudwatch_enabled ? 1 : 0
  alarm_name                = "celery-sms-dedicated-static-pods-high-memory-warning"
  alarm_description         = "Average memory of celery-sms-dedicated-static >=50% during 10 minutes"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "pod_memory_utilization"
  namespace                 = "ContainerInsights"
  period                    = 300
  statistic                 = "Average"
  threshold                 = 50
  alarm_actions             = [var.sns_alert_warning_arn]
  insufficient_data_actions = [var.sns_alert_warning_arn]
  treat_missing_data        = "missing"
  dimensions = {
    Namespace   = "notification-canada-ca"
    Service     = "notify-celery-sms-dedicated-static"
    ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
  }
}

resource "aws_cloudwatch_metric_alarm" "ddos-detected-load-balancer-critical" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "ddos-detected-load-balancer-critical"
  alarm_description   = "DDoS has been detected on the load balancer"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "DDoSDetected"
  namespace           = "AWS/DDoSProtection"
  period              = 60
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
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "logs-1-malware-detected-1-minute-warning"
  alarm_description   = "One malware detected error in 1 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.malware-detected[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.malware-detected[0].metric_transformation[0].namespace
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "logs-10-malware-detected-1-minute-critical" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "logs-10-malware-detected-1-minute-critical"
  alarm_description   = "Ten malware detected errors in 1 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.malware-detected[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.malware-detected[0].metric_transformation[0].namespace
  period              = 60
  statistic           = "Sum"
  threshold           = 10
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_critical_arn]
  ok_actions          = [var.sns_alert_critical_arn]
}

resource "aws_cloudwatch_metric_alarm" "logs-1-scanfiles-timeout-1-minute-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "logs-1-scanfiles-timeout-5-minutes-warning"
  alarm_description   = "One scanfiles timeout detected error in 1 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.scanfiles-timeout[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.scanfiles-timeout[0].metric_transformation[0].namespace
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "logs-1-bounce-rate-critical" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "logs-1-bounce-rate-critical"
  alarm_description   = "Bounce rate exceeding 10% in a 12 hour period"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.bounce-rate-critical[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.bounce-rate-critical[0].metric_transformation[0].namespace
  period              = 60 * 60 * 12
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "kubernetes-failed-nodes" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "kubernetes-failed-nodes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
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
      stat        = "Average"
      dimensions = {
        Name = aws_eks_cluster.notification-canada-ca-eks-cluster.name
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "celery-core-tasks-static-replicas-unavailable" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "celery-core-tasks-static-replicas-unavailable"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  alarm_description   = "Celery Core Tasks Static Replicas Unavailable"
  #Setting to warn until we verify that it is working as expected
  alarm_actions      = [var.sns_alert_warning_arn]
  treat_missing_data = "breaching"
  threshold          = 1

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "kube_deployment_status_replicas_unavailable"
      namespace   = "ContainerInsights/Prometheus"
      period      = 300
      stat        = "Minimum"
      dimensions = {
        ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
        namespace   = var.notify_k8s_namespace
        deployment  = "notify-celery-core-tasks-static"
      }
    }
  }
}


resource "aws_cloudwatch_metric_alarm" "celery-core-tasks-scalable-replicas-unavailable" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "celery-core-tasks-scalable-replicas-unavailable"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 3
  alarm_description   = "Celery Core Tasks Scalable Replicas Unavailable"
  #Setting to warn until we verify that it is working as expected
  alarm_actions      = [var.sns_alert_warning_arn]
  treat_missing_data = "breaching"
  threshold          = 1

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "kube_deployment_status_replicas_unavailable"
      namespace   = "ContainerInsights/Prometheus"
      period      = 300
      stat        = "Minimum"
      dimensions = {
        ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
        namespace   = var.notify_k8s_namespace
        deployment  = "notify-celery-core-tasks-scalable"
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "celery-beat-replicas-unavailable" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "celery-beat-replicas-unavailable"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  alarm_description   = "Celery Beat Replicas Unavailable"
  #Setting to warn until we verify that it is working as expected
  alarm_actions      = [var.sns_alert_warning_arn]
  treat_missing_data = "breaching"
  threshold          = 1

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "kube_deployment_status_replicas_unavailable"
      namespace   = "ContainerInsights/Prometheus"
      period      = 300
      stat        = "Average"
      dimensions = {
        ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
        namespace   = var.notify_k8s_namespace
        deployment  = "notify-celery-beat"
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "celery-sms-dedicated-static-replicas-unavailable" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "celery-sms-dedicated-static-replicas-unavailable"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  alarm_description   = "Celery SMS Dedicated Static Replicas Unavailable"
  #Setting to warn until we verify that it is working as expected
  alarm_actions      = [var.sns_alert_warning_arn]
  treat_missing_data = "breaching"
  threshold          = 1

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "kube_deployment_status_replicas_unavailable"
      namespace   = "ContainerInsights/Prometheus"
      period      = 300
      stat        = "Average"
      dimensions = {
        ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
        namespace   = var.notify_k8s_namespace
        deployment  = "notify-celery-sms-dedicated-static"
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "celery-email-send-static-replicas-unavailable" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "celery-email-send-static-replicas-unavailable"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  alarm_description   = "Celery Email Send Static Replicas Unavailable"
  #Setting to warn until we verify that it is working as expected
  alarm_actions      = [var.sns_alert_warning_arn]
  treat_missing_data = "breaching"
  threshold          = 1

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "kube_deployment_status_replicas_unavailable"
      namespace   = "ContainerInsights/Prometheus"
      period      = 300
      stat        = "Minimum"
      dimensions = {
        ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
        namespace   = var.notify_k8s_namespace
        deployment  = "notify-celery-email-send-static"
      }
    }
  }
}


resource "aws_cloudwatch_metric_alarm" "celery-email-send-scalable-replicas-unavailable" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "celery-email-send-scalable-replicas-unavailable"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 3
  alarm_description   = "Celery Email Send Scalable Replicas Unavailable"
  #Setting to warn until we verify that it is working as expected
  alarm_actions      = [var.sns_alert_warning_arn]
  treat_missing_data = "breaching"
  threshold          = 1

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "kube_deployment_status_replicas_unavailable"
      namespace   = "ContainerInsights/Prometheus"
      period      = 300
      stat        = "Minimum"
      dimensions = {
        ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
        namespace   = var.notify_k8s_namespace
        deployment  = "notify-celery-email-send-scalable"
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "celery-sms-send-static-replicas-unavailable" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "celery-sms-send-static-replicas-unavailable"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  alarm_description   = "Celery SMS Send Static Replicas Unavailable"
  #Setting to warn until we verify that it is working as expected
  alarm_actions      = [var.sns_alert_warning_arn]
  treat_missing_data = "breaching"
  threshold          = 1

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "kube_deployment_status_replicas_unavailable"
      namespace   = "ContainerInsights/Prometheus"
      period      = 300
      stat        = "Minimum"
      dimensions = {
        ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
        namespace   = var.notify_k8s_namespace
        deployment  = "notify-celery-sms-send-static"
      }
    }
  }
}


resource "aws_cloudwatch_metric_alarm" "celery-sms-send-scalable-replicas-unavailable" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "celery-sms-send-scalable-replicas-unavailable"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 3
  alarm_description   = "Celery SMS Send Scalable Replicas Unavailable"
  #Setting to warn until we verify that it is working as expected
  alarm_actions      = [var.sns_alert_warning_arn]
  treat_missing_data = "breaching"
  threshold          = 1

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "kube_deployment_status_replicas_unavailable"
      namespace   = "ContainerInsights/Prometheus"
      period      = 300
      stat        = "Minimum"
      dimensions = {
        ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
        namespace   = var.notify_k8s_namespace
        deployment  = "notify-celery-sms-send-scalable"
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "admin-replicas-unavailable" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "admin-replicas-unavailable"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  alarm_description   = "Notify Admin Replicas Unavailable"
  #Setting to warn until we verify that it is working as expected
  alarm_actions      = [var.sns_alert_warning_arn]
  treat_missing_data = "breaching"
  threshold          = 1

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "kube_deployment_status_replicas_unavailable"
      namespace   = "ContainerInsights/Prometheus"
      period      = 300
      stat        = "Average"
      dimensions = {
        ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
        namespace   = var.notify_k8s_namespace
        deployment  = "notify-admin"
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "api-replicas-unavailable" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "api-replicas-unavailable"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  alarm_description   = "Notify K8S API Replicas Unavailable"
  #Setting to warn until we verify that it is working as expected
  alarm_actions      = [var.sns_alert_warning_arn]
  treat_missing_data = "breaching"
  threshold          = 1

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "kube_deployment_status_replicas_unavailable"
      namespace   = "ContainerInsights/Prometheus"
      period      = 300
      stat        = "Average"
      dimensions = {
        ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
        namespace   = var.notify_k8s_namespace
        deployment  = "notify-api"
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "documentation-replicas-unavailable" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "documentation-replicas-unavailable"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  alarm_description   = "Notify Documentation Replicas Unavailable"
  #Setting to warn until we verify that it is working as expected
  alarm_actions      = [var.sns_alert_warning_arn]
  treat_missing_data = "breaching"
  threshold          = 1

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "kube_deployment_status_replicas_unavailable"
      namespace   = "ContainerInsights/Prometheus"
      period      = 300
      stat        = "Average"
      dimensions = {
        ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
        namespace   = var.notify_k8s_namespace
        deployment  = "notify-documentation"
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "document-download-api-replicas-unavailable" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "document-download-api-replicas-unavailable"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  alarm_description   = "Notify Document Download API Replicas Unavailable"
  #Setting to warn until we verify that it is working as expected
  alarm_actions      = [var.sns_alert_warning_arn]
  treat_missing_data = "breaching"
  threshold          = 1

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "kube_deployment_status_replicas_unavailable"
      namespace   = "ContainerInsights/Prometheus"
      period      = 300
      stat        = "Average"
      dimensions = {
        ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
        namespace   = var.notify_k8s_namespace
        deployment  = "notify-document-download"
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "api-evicted-pods" {
  count                     = var.cloudwatch_enabled ? 1 : 0
  alarm_name                = "evicted-api-pods-detected"
  alarm_description         = "One or more Kubernetes API Pods is reporting as Evicted"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "3"
  metric_name               = aws_cloudwatch_log_metric_filter.api-evicted-pods[0].name
  namespace                 = aws_cloudwatch_log_metric_filter.api-evicted-pods[0].metric_transformation[0].namespace
  period                    = "60"
  statistic                 = "Sum"
  threshold                 = 1
  treat_missing_data        = "notBreaching"
  alarm_actions             = [var.sns_alert_warning_arn]
  ok_actions                = [var.sns_alert_warning_arn]
  insufficient_data_actions = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "celery-evicted-pods" {
  count                     = var.cloudwatch_enabled ? 1 : 0
  alarm_name                = "evicted-celery-pods-detected"
  alarm_description         = "One or more Kubernetes Celery Pods is reporting as Evicted"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "3"
  metric_name               = aws_cloudwatch_log_metric_filter.celery-evicted-pods[0].name
  namespace                 = aws_cloudwatch_log_metric_filter.celery-evicted-pods[0].metric_transformation[0].namespace
  period                    = "60"
  statistic                 = "Sum"
  threshold                 = 1
  treat_missing_data        = "notBreaching"
  alarm_actions             = [var.sns_alert_warning_arn]
  ok_actions                = [var.sns_alert_warning_arn]
  insufficient_data_actions = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "admin-evicted-pods" {
  count                     = var.cloudwatch_enabled ? 1 : 0
  alarm_name                = "evicted-admin-pods-detected"
  alarm_description         = "One or more Kubernetes Admin Pods is reporting as Evicted"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "3"
  metric_name               = aws_cloudwatch_log_metric_filter.admin-evicted-pods[0].name
  namespace                 = aws_cloudwatch_log_metric_filter.admin-evicted-pods[0].metric_transformation[0].namespace
  period                    = "60"
  statistic                 = "Sum"
  threshold                 = 1
  treat_missing_data        = "notBreaching"
  alarm_actions             = [var.sns_alert_warning_arn]
  ok_actions                = [var.sns_alert_warning_arn]
  insufficient_data_actions = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "document-download-evicted-pods" {
  count                     = var.cloudwatch_enabled ? 1 : 0
  alarm_name                = "evicted-document-download-pods-detected"
  alarm_description         = "One or more Kubernetes Document Download Pods is reporting as Evicted"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "3"
  metric_name               = aws_cloudwatch_log_metric_filter.document-download-evicted-pods[0].name
  namespace                 = aws_cloudwatch_log_metric_filter.document-download-evicted-pods[0].metric_transformation[0].namespace
  period                    = "60"
  statistic                 = "Sum"
  threshold                 = 1
  treat_missing_data        = "notBreaching"
  alarm_actions             = [var.sns_alert_warning_arn]
  ok_actions                = [var.sns_alert_warning_arn]
  insufficient_data_actions = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "documentation-evicted-pods" {
  count                     = var.cloudwatch_enabled ? 1 : 0
  alarm_name                = "evicted-documentation-pods-detected"
  alarm_description         = "One or more Kubernetes Documentation Pods is reporting as Evicted"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "3"
  metric_name               = aws_cloudwatch_log_metric_filter.documentation-evicted-pods[0].name
  namespace                 = aws_cloudwatch_log_metric_filter.documentation-evicted-pods[0].metric_transformation[0].namespace
  period                    = "60"
  statistic                 = "Sum"
  threshold                 = 1
  treat_missing_data        = "notBreaching"
  alarm_actions             = [var.sns_alert_warning_arn]
  ok_actions                = [var.sns_alert_warning_arn]
  insufficient_data_actions = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "karpenter-replicas-unavailable" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "karpenter-replicas-unavailable"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  alarm_description   = "Karpenter Replicas Unavailable"
  #Setting to warn until we verify that it is working as expected
  alarm_actions      = [var.sns_alert_warning_arn]
  treat_missing_data = "breaching"
  threshold          = 1

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "kube_deployment_status_replicas_unavailable"
      namespace   = "ContainerInsights/Prometheus"
      period      = 300
      stat        = "Minimum"
      dimensions = {
        ClusterName = aws_eks_cluster.notification-canada-ca-eks-cluster.name
        namespace   = "karpenter"
        deployment  = "karpenter"
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "aggregating-queues-not-active-1-minute-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "aggregating-queues-not-active-1-minute-warning"
  alarm_description   = "Beat inbox tasks have not been active for one minute"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.aggregating-queues-are-active[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.aggregating-queues-are-active[0].metric_transformation[0].namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "breaching"
  alarm_actions       = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "aggregating-queues-not-active-5-minutes-critical" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "aggregating-queues-not-active-5-minutes-critical"
  alarm_description   = "Beat inbox tasks have not been active for 5 minutes"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.aggregating-queues-are-active[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.aggregating-queues-are-active[0].metric_transformation[0].namespace
  period              = "300"
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "breaching"
  alarm_actions       = [var.sns_alert_critical_arn]
  ok_actions          = [var.sns_alert_critical_arn]
}

resource "aws_cloudwatch_metric_alarm" "service-callback-too-many-failures-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "service-callback-too-many-failures-warning"
  alarm_description   = "Service reached the max number of callback retries 25 times in 5 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.callback-request-failures[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.callback-request-failures[0].metric_transformation[0].namespace
  period              = 60 * 5
  statistic           = "Sum"
  threshold           = 25
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "service-callback-too-many-failures-critical" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "service-callback-too-many-failures-critical"
  alarm_description   = "Service reached the max number of callback retries 100 times in 10 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.callback-request-failures[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.callback-request-failures[0].metric_transformation[0].namespace
  period              = 60 * 10
  statistic           = "Sum"
  threshold           = 100
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_critical_arn]
}

resource "aws_cloudwatch_metric_alarm" "throttling-exception-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "throttling-exception-warning"
  alarm_description   = "Have received a throttling exception in the last minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.throttling-exceptions[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.throttling-exceptions[0].metric_transformation[0].namespace
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "many-throttling-exceptions-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "many-throttling-exceptions-warning"
  alarm_description   = "Have received 100 throttling exception in the last minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.throttling-exceptions[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.throttling-exceptions[0].metric_transformation[0].namespace
  period              = 60
  statistic           = "Sum"
  threshold           = 100
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "db-migration-failure-critical" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "db-migration-failure-critical"
  alarm_description   = "The database migration running in the api k8s pods has failed"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.db-migration-failure[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.db-migration-failure[0].metric_transformation[0].namespace
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_critical_arn]
}


resource "aws_cloudwatch_metric_alarm" "logs-1-oom-error-1-minute-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "logs-1-oom-error-1-minute-warning"
  alarm_description   = "One oom error in 1 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.oom-errors[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.oom-errors[0].metric_transformation[0].namespace
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_warning_arn]
}

# both of these are set to warning atm
resource "aws_cloudwatch_metric_alarm" "logs-10-oom-error-5-minute-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "logs-10-oom-error-5-minute-warning"
  alarm_description   = "Ten oom errors in 5 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.oom-errors[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.oom-errors[0].metric_transformation[0].namespace
  period              = 300
  statistic           = "Sum"
  threshold           = 10
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "api-email-slow-execution-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "api-email-slow-execution-warning"
  alarm_description   = "API send for email notifications taking longer than 1s"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.notification-canada-ca-alert-warning.arn]
  ok_actions          = [aws_sns_topic.notification-canada-ca-alert-ok.arn]

  metric_query {
    id          = "batch_saving_email_slow_execution"
    expression  = "INSIGHT_RULE_METRIC('batch_saving_email_slow_execution_rule')"
    label       = "Email batch saving operations taking >1000ms"
    return_data = "true"
  }
}

resource "aws_cloudwatch_metric_insight_rule" "api_send_slow_execution_rule" {
  name  = "api_send_slow_execution_rule"
  state = "ENABLED"
  rule_body = jsonencode({
    Source        = "aws/containerinsights/${var.cluster_name}/application"
    LogGroupNames = [local.eks_application_log_group]
    QueryString   = aws_cloudwatch_query_definition.api-send-greater-than-1s[0].query_string
  })
}
