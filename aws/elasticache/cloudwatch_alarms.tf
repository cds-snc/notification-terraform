resource "aws_cloudwatch_metric_alarm" "redis-elasticache-medium-cpu-warning" {
  alarm_name          = "redis-elasticache-medium-cpu-warning"
  alarm_description   = "Average CPU of Redis ElastiCache >= 50% during 1 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"
  threshold           = 50
  alarm_actions       = [var.sns_alert_warning_arn]
  treat_missing_data  = "breaching"
  dimensions = {
    ReplicationGroupId = aws_elasticache_replication_group.notification-cluster-cache-multiaz-group.id
  }
}

resource "aws_cloudwatch_metric_alarm" "redis-elasticache-high-cpu-warning" {
  alarm_name          = "redis-elasticache-high-cpu-warning"
  alarm_description   = "Average CPU of Redis ElastiCache >= 70% during 1 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"
  threshold           = 70
  alarm_actions       = [var.sns_alert_warning_arn]
  treat_missing_data  = "breaching"
  dimensions = {
    ReplicationGroupId = aws_elasticache_replication_group.notification-cluster-cache-multiaz-group.id
  }
}

resource "aws_cloudwatch_metric_alarm" "redis-elasticache-high-db-memory-warning" {
  alarm_name          = "redis-elasticache-high-db-memory-warning"
  alarm_description   = "Average DB Memory on Redis ElastiCache >= 60% during 1 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "DatabaseMemoryUsagePercentage"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"
  threshold           = 60
  alarm_actions       = [var.sns_alert_warning_arn]
  dimensions = {
    ReplicationGroupId = aws_elasticache_replication_group.notification-cluster-cache-multiaz-group.id
  }
}

resource "aws_cloudwatch_metric_alarm" "redis-elasticache-high-connection-warning" {
  alarm_name          = "redis-elasticache-high-connection-warning"
  alarm_description   = "Average Number of Connections on Redis ElastiCache >= 1000 connections during 1 minute"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CurrConnections"
  namespace           = "AWS/ElastiCache"
  period              = "60"
  statistic           = "Average"
  threshold           = 1000
  alarm_actions       = [var.sns_alert_warning_arn]
  dimensions = {
    ReplicationGroupId = aws_elasticache_replication_group.notification-cluster-cache-multiaz-group.id
  }
}
