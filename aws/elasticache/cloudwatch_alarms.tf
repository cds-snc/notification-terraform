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
  dimensions = {
    CacheClusterId = aws_elasticache_cluster.notification-cluster-cache.cluster_id
  }
}
