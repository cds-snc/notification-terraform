resource "aws_cloudwatch_metric_alarm" "redis-elasticache-medium-cpu-warning" {
  count               = var.elasticache_admin_cache_node_count
  alarm_name          = "redis-elasticache-medium-cpu-warning-CacheCluster00${count.index + 1}CPUUtilization"
  alarm_description   = "Average CPU of Redis ElastiCache >= 50% during 1 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"
  threshold           = 50
  alarm_actions       = [var.sns_alert_warning_arn]
  ok_actions          = [var.sns_alert_warning_arn]
  treat_missing_data  = "breaching"

  dimensions = {
    CacheClusterId = "${aws_elasticache_replication_group.notification-cluster-cache-multiaz-group.id}-00${count.index + 1}"
  }
}

resource "aws_cloudwatch_metric_alarm" "redis-elasticache-high-cpu-warning" {
  count               = var.elasticache_admin_cache_node_count
  alarm_name          = "redis-elasticache-high-cpu-warning-CacheCluster00${count.index + 1}CPUUtilization"
  alarm_description   = "Average CPU of Redis ElastiCache >= 70% during 1 minute "
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"
  threshold           = 70
  alarm_actions       = [var.sns_alert_warning_arn]
  ok_actions          = [var.sns_alert_warning_arn]
  treat_missing_data  = "breaching"
  dimensions = {
    CacheClusterId = "${aws_elasticache_replication_group.notification-cluster-cache-multiaz-group.id}-00${count.index + 1}"
  }
}

resource "aws_cloudwatch_metric_alarm" "redis-elasticache-high-db-memory-warning" {
  count               = var.elasticache_admin_cache_node_count
  alarm_name          = "redis-elasticache-high-db-memory-warning-CacheCluster00${count.index + 1}"
  alarm_description   = "Average DB Memory on Redis ElastiCache >= 60% during 1 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "DatabaseMemoryUsagePercentage"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"
  threshold           = 60
  alarm_actions       = [var.sns_alert_warning_arn]
  ok_actions          = [var.sns_alert_warning_arn]
  treat_missing_data  = "missing"
  dimensions = {
    CacheClusterId = "${aws_elasticache_replication_group.notification-cluster-cache-multiaz-group.id}-00${count.index + 1}"
  }
}

resource "aws_cloudwatch_metric_alarm" "redis-elasticache-high-db-memory-critical" {
  count               = var.elasticache_admin_cache_node_count
  alarm_name          = "redis-elasticache-high-db-memory-critical-CacheCluster00${count.index + 1}"
  alarm_description   = "Average DB Memory on Redis ElastiCache >= 85% during 1 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "DatabaseMemoryUsagePercentage"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"
  threshold           = 85
  alarm_actions       = [var.sns_alert_critical_arn]
  ok_actions          = [var.sns_alert_critical_arn]
  treat_missing_data  = "missing"
  dimensions = {
    CacheClusterId = "${aws_elasticache_replication_group.notification-cluster-cache-multiaz-group.id}-00${count.index + 1}"
  }
}

resource "aws_cloudwatch_metric_alarm" "redis-elasticache-high-connection-warning" {
  count               = var.elasticache_admin_cache_node_count
  alarm_name          = "redis-elasticache-high-connection-warning-CacheCluster00${count.index + 1}"
  alarm_description   = "Average Number of Connections on Redis ElastiCache >= 1000 connections during 1 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CurrConnections"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"
  threshold           = 1000
  alarm_actions       = [var.sns_alert_warning_arn]
  ok_actions          = [var.sns_alert_warning_arn]
  treat_missing_data  = "missing"
  dimensions = {
    CacheClusterId = "${aws_elasticache_replication_group.notification-cluster-cache-multiaz-group.id}-00${count.index + 1}"
  }
}


# Queue Cache Alarms

resource "aws_cloudwatch_metric_alarm" "elasticache_queue_medium_cpu_warning" {
  count               = var.env != "production" ? var.elasticache_cache_ops_node_count : 0
  alarm_name          = "elasticache-queue-medium-cpu-warning-CacheCluster00${count.index + 1}CPUUtilization"
  alarm_description   = "Average CPU of Redis ElastiCache >= 50% during 1 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"
  threshold           = 50
  alarm_actions       = [var.sns_alert_warning_arn]
  ok_actions          = [var.sns_alert_warning_arn]
  treat_missing_data  = "breaching"

  dimensions = {
    CacheClusterId = "${aws_elasticache_replication_group.notification-cluster-cache-multiaz-group.id}-00${count.index + 1}"
  }
}

resource "aws_cloudwatch_metric_alarm" "elasticache_queue_high_cpu_warning" {
  count               = var.env != "production" ? var.elasticache_cache_ops_node_count : 0
  alarm_name          = "elasticache-queue-high-cpu-warning-CacheCluster00${count.index + 1}CPUUtilization"
  alarm_description   = "Average CPU of Redis ElastiCache >= 70% during 1 minute "
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"
  threshold           = 70
  alarm_actions       = [var.sns_alert_warning_arn]
  ok_actions          = [var.sns_alert_warning_arn]
  treat_missing_data  = "breaching"
  dimensions = {
    CacheClusterId = "${aws_elasticache_replication_group.notification-cluster-cache-multiaz-group.id}-00${count.index + 1}"
  }
}

resource "aws_cloudwatch_metric_alarm" "elasticache_queue_high_db_memory_warning" {
  count               = var.env != "production" ? var.elasticache_cache_ops_node_count : 0
  alarm_name          = "elasticache-queue-high-db-memory-warning-CacheCluster00${count.index + 1}"
  alarm_description   = "Average DB Memory on Redis ElastiCache >= 60% during 1 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "DatabaseMemoryUsagePercentage"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"
  threshold           = 60
  alarm_actions       = [var.sns_alert_warning_arn]
  ok_actions          = [var.sns_alert_warning_arn]
  treat_missing_data  = "missing"
  dimensions = {
    CacheClusterId = "${aws_elasticache_replication_group.notification-cluster-cache-multiaz-group.id}-00${count.index + 1}"
  }
}

resource "aws_cloudwatch_metric_alarm" "elasticache_queue_high_db_memory_critical" {
  count               = var.env != "production" ? var.elasticache_cache_ops_node_count : 0
  alarm_name          = "elasticache-queue-high-db-memory-critical-CacheCluster00${count.index + 1}"
  alarm_description   = "Average DB Memory on Redis ElastiCache >= 85% during 1 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "DatabaseMemoryUsagePercentage"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"
  threshold           = 85
  alarm_actions       = [var.sns_alert_critical_arn]
  ok_actions          = [var.sns_alert_critical_arn]
  treat_missing_data  = "missing"
  dimensions = {
    CacheClusterId = "${aws_elasticache_replication_group.notification-cluster-cache-multiaz-group.id}-00${count.index + 1}"
  }
}

resource "aws_cloudwatch_metric_alarm" "elasticache_queue_high_db_connection_warning" {
  count               = var.env != "production" ? var.elasticache_cache_ops_node_count : 0
  alarm_name          = "elasticache-queue-high-connection-warning-CacheCluster00${count.index + 1}"
  alarm_description   = "Average Number of Connections on Redis ElastiCache >= 1000 connections during 1 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CurrConnections"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"
  threshold           = 1000
  alarm_actions       = [var.sns_alert_warning_arn]
  ok_actions          = [var.sns_alert_warning_arn]
  treat_missing_data  = "missing"
  dimensions = {
    CacheClusterId = "${aws_elasticache_replication_group.notification-cluster-cache-multiaz-group.id}-00${count.index + 1}"
  }
}
