resource "aws_secretsmanager_secret" "redis_url" {
  name = "REDIS_URL"
}

resource "aws_secretsmanager_secret_version" "redis_url" {
  secret_id     = aws_secretsmanager_secret.redis_url.id
  secret_string = aws_elasticache_replication_group.notification-cluster-cache-multiaz-group.primary_endpoint_address
}

resource "aws_secretsmanager_secret" "redis_publish_url" {
  name = "REDIS_PUBLISH_URL"
}

resource "aws_secretsmanager_secret_version" "redis_publish_url" {
  secret_id     = aws_secretsmanager_secret.redis_publish_url.id
  secret_string = aws_elasticache_replication_group.notification-cluster-cache-multiaz-group.primary_endpoint_address
}
