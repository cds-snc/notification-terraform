// Historically we do not have data where it spikes above 4%
// Since it is CPU related missing data could mean the service is missing
resource "aws_cloudwatch_metric_alarm" "redis-elasticache-medium-cpu-warning" {
  alarm_name          = "redis-elasticache-medium-cpu-warning"
  alarm_description   = "Average CPU of Redis Elasticache >= 5% during 1 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "30"
  statistic           = "Average"
  threshold           = 5
  alarm_actions       = [var.sns_alert_warning_arn]
  treat_missing_data  = "breaching"
  dimensions = {
    CacheClusterId = aws_elasticache_cluster.notification-cluster-cache.cluster_id
  }
}

// 50% is an arbitrary number as historical data has never shown CPU usage above 4% which is handled by
// the medium threshold; 10x is a reasonable number
// FIXME: Please consider upgrading this to a critical warning
resource "aws_cloudwatch_metric_alarm" "redis-elasticache-critical-cpu-warning" {
  alarm_name          = "redis-elasticache-critical-cpu-warning"
  alarm_description   = "Average CPU of Redis Elasticache >= 50% during 1 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "30"
  statistic           = "Average"
  threshold           = 50
  alarm_actions       = [var.sns_alert_warning_arn]
  treat_missing_data  = "breaching"
  dimensions = {
    CacheClusterId = aws_elasticache_cluster.notification-cluster-cache.cluster_id
  }
}

resource "aws_cloudwatch_metric_alarm" "redis-elasticache-high-engine-cpu-warning" {
  alarm_name          = "redis-elasticache-high-engine-cpu-warning"
  alarm_description   = "Average Engine CPU of Redis Elasticache >= 2% during 1 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "EngineCPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = "30"
  statistic           = "Average"
  threshold           = 2
  alarm_actions       = [var.sns_alert_warning_arn]
  treat_missing_data  = "breaching"
  dimensions = {
    CacheClusterId = aws_elasticache_cluster.notification-cluster-cache.cluster_id
  }
}

resource "aws_cloudwatch_metric_alarm" "redis-elasticache-high-db-memory-warning" {
  alarm_name          = "redis-elasticache-high-db-memory-warning"
  alarm_description   = "Average DB Memory on Redis Elasticache >= 2% during 1 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "DatabaseMemoryUsagePercentage"
  namespace           = "AWS/ElastiCache"
  period              = "30"
  statistic           = "Average"
  threshold           = 2
  alarm_actions       = [var.sns_alert_warning_arn]
  dimensions = {
    CacheClusterId = aws_elasticache_cluster.notification-cluster-cache.cluster_id
  }
}

resource "aws_cloudwatch_metric_alarm" "redis-elasticache-high-connection-warning" {
  alarm_name          = "redis-elasticache-high-connection-warning"
  alarm_description   = "Average Number of Connections on Redis Elasticache >= 30 connections during 1 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CurrConnections"
  namespace           = "AWS/ElastiCache"
  period              = "30"
  statistic           = "Average"
  threshold           = 30
  alarm_actions       = [var.sns_alert_warning_arn]
  dimensions = {
    CacheClusterId = aws_elasticache_cluster.notification-cluster-cache.cluster_id
  }
}
