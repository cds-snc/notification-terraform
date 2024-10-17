resource "aws_secretsmanager_secret" "redis_url" {
  name                    = "REDIS_URL"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "redis_url" {
  secret_id     = aws_secretsmanager_secret.redis_url.id
  secret_string = "redis://${aws_elasticache_replication_group.notification-cluster-cache-multiaz-group.primary_endpoint_address}"
}
