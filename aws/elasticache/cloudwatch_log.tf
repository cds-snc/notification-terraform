resource "aws_cloudwatch_log_group" "notification-canada-ca-elasticache-slow-logs" {
  name              = "/aws/elasticache/notify-${var.env}-cluster-cache-az/slow-logs"
  retention_in_days = var.env == "production" ? 0 : 365
}

resource "aws_cloudwatch_log_group" "notification-canada-ca-elasticache-engine-logs" {
  name              = "/aws/elasticache/notify-${var.env}-cluster-cache-az/engine-logs"
  retention_in_days = var.env == "production" ? 0 : 365
}

resource "aws_cloudwatch_log_group" "redis-batch-saving" {
  name              = "BatchSaving"
  retention_in_days = var.env == "production" ? 0 : 365
}