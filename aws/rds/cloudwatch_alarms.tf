# Note to maintainers:
# Updating alarms? Update the Google Sheet also!
# https://docs.google.com/spreadsheets/d/1gkrL3Trxw0xEkX724C1bwpfeRsTlK2X60wtCjF6MFRA/edit
#
# There are also alarms defined in aws/common/cloudwatch_alarms.tf

resource "aws_cloudwatch_metric_alarm" "high-dbload-warning" {
  count               = var.rds_instance_count
  alarm_name          = "high-dbload-warning-instance-${count.index}"
  alarm_description   = "DBLoad > 10. Check if there's a query that is causing this."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "DBLoad"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  threshold           = 10
  alarm_actions       = [var.sns_alert_warning_arn]
  treat_missing_data  = "notBreaching"
  dimensions = {
    DBInstanceIdentifier = aws_rds_cluster_instance.notification-canada-ca-instances[count.index].identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "high-dbload-critical" {
  count               = var.rds_instance_count
  alarm_name          = "high-dbload-critical-instance-${count.index}"
  alarm_description   = "DBLoad > 100. Check if there's a query that is causing this."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "DBLoad"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  threshold           = 100
  alarm_actions       = [var.sns_alert_critical_arn]
  treat_missing_data  = "notBreaching"
  dimensions = {
    DBInstanceIdentifier = aws_rds_cluster_instance.notification-canada-ca-instances[count.index].identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "high-db-cpu-warning" {
  count               = var.rds_instance_count
  alarm_name          = "high-db-cpu-warning-instance-${count.index}"
  alarm_description   = "CPU usage of the RDS instance > 80%"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_actions       = [var.sns_alert_warning_arn]
  treat_missing_data  = "notBreaching"
  dimensions = {
    DBInstanceIdentifier = aws_rds_cluster_instance.notification-canada-ca-instances[count.index].identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "very-high-db-cpu-warning" {
  count               = var.rds_instance_count
  alarm_name          = "very-high-db-cpu-warning-instance-${count.index}"
  alarm_description   = "CPU usage of the RDS instance > 95%"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  threshold           = 95
  alarm_actions       = [var.sns_alert_warning_arn]
  treat_missing_data  = "notBreaching"
  dimensions = {
    DBInstanceIdentifier = aws_rds_cluster_instance.notification-canada-ca-instances[count.index].identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "low-db-memory-warning" {
  count               = var.rds_instance_count
  alarm_name          = "low-db-memory-warning-instance-${count.index}"
  alarm_description   = "Freeable memory of the RDS instance < 4G"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  threshold           = 4 * 1024 * 1024 * 1024
  alarm_actions       = [var.sns_alert_warning_arn]
  treat_missing_data  = "notBreaching"
  dimensions = {
    DBInstanceIdentifier = aws_rds_cluster_instance.notification-canada-ca-instances[count.index].identifier
  }
}


resource "aws_cloudwatch_metric_alarm" "low-db-memory-critical" {
  count               = var.rds_instance_count
  alarm_name          = "low-db-memory-critical-instance-${count.index}"
  alarm_description   = "Freeable memory of the RDS instance < 2G"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  threshold           = 2 * 1024 * 1024 * 1024
  alarm_actions       = [var.sns_alert_critical_arn]
  treat_missing_data  = "notBreaching"
  dimensions = {
    DBInstanceIdentifier = aws_rds_cluster_instance.notification-canada-ca-instances[count.index].identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "db-free-local-storage-warning" {
  count               = var.rds_instance_count
  alarm_name          = "db-free-local-storage-warning-instance-${count.index}"
  alarm_description   = "Free local storage of instance is less than 10GB"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeLocalStorage"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  threshold           = 10 * 1024 * 1024 * 1024
  alarm_actions       = [var.sns_alert_warning_arn]
  treat_missing_data  = "notBreaching"
  dimensions = {
    DBInstanceIdentifier = aws_rds_cluster_instance.notification-canada-ca-instances[count.index].identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "db-free-local-storage-critical" {
  count               = var.rds_instance_count
  alarm_name          = "db-free-local-storage-critical-instance-${count.index}"
  alarm_description   = "Free local storage of instance is less than 5GB"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeLocalStorage"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  threshold           = 5 * 1024 * 1024 * 1024
  alarm_actions       = [var.sns_alert_critical_arn]
  treat_missing_data  = "notBreaching"
  dimensions = {
    DBInstanceIdentifier = aws_rds_cluster_instance.notification-canada-ca-instances[count.index].identifier
  }
}
