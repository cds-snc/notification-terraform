###
# AWS Elasticache Redis/Valkey for Notification application
###

resource "aws_elasticache_subnet_group" "notification-canada-ca-cache-subnet" {
  name       = "notification-canada-ca-${var.env}-cache-subnet"
  subnet_ids = var.vpc_private_subnets
}

###
# AWS Elasticache Redis/Valkey Cluster - 1 node, 2 replicas, cluster node enabled:false, multi AZ
###

resource "aws_elasticache_replication_group" "notification-cluster-cache-multiaz-group" {
  # Default is false with this param, it looks counter-intuitive because
  # applied changes would only happen during maintenance window if false.
  apply_immediately           = true
  automatic_failover_enabled  = true
  preferred_cache_cluster_azs = ["ca-central-1b", "ca-central-1d", "ca-central-1a"]
  replication_group_id        = "notify-${var.env}-cluster-cache-az"
  description                 = "Redis/Valkey multiaz cluster with replication group"
  node_type                   = var.elasticache_admin_cache_node_type
  num_cache_clusters          = var.elasticache_admin_cache_node_count
  engine                      = var.elasticache_use_valkey ? "valkey" : "redis"
  engine_version              = var.elasticache_use_valkey ? "8.0" : "6.x"
  parameter_group_name        = var.elasticache_use_valkey ? "default.valkey8" : "default.redis6.x"
  port                        = 6379
  maintenance_window          = "thu:04:00-thu:05:00"
  multi_az_enabled            = true

  security_group_ids = local.cluster_security_group_ids
  subnet_group_name  = aws_elasticache_subnet_group.notification-canada-ca-cache-subnet.name

  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.notification-canada-ca-elasticache-slow-logs.name
    destination_type = "cloudwatch-logs"
    log_format       = "json"
    log_type         = "slow-log"
  }

  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.notification-canada-ca-elasticache-engine-logs.name
    destination_type = "cloudwatch-logs"
    log_format       = "json"
    log_type         = "engine-log"
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }

  lifecycle {
    ignore_changes = [num_cache_clusters]
  }
}

###
# AWS Elasticache Redis/Valkey Cluster - 1 node, 2 replicas, cluster node enabled:false, multi AZ
###

resource "aws_elasticache_replication_group" "elasticache_queue_cache" {

  apply_immediately           = true
  automatic_failover_enabled  = true
  preferred_cache_cluster_azs = ["ca-central-1b", "ca-central-1d", "ca-central-1a"]
  replication_group_id        = "notify-${var.env}-queue-cache"
  description                 = "Redis/Valkey multiaz cluster with replication group for Celery queues"
  node_type                   = var.elasticache_cache_ops_node_type
  num_cache_clusters          = var.elasticache_cache_ops_node_count
  engine                      = "valkey"
  engine_version              = "8.0"
  parameter_group_name        = "default.valkey8"
  port                        = 6379
  maintenance_window          = "thu:04:00-thu:05:00"
  multi_az_enabled            = true

  security_group_ids = local.cluster_security_group_ids
  subnet_group_name  = aws_elasticache_subnet_group.notification-canada-ca-cache-subnet.name

  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.elasticache_queue_cache_slow_logs.name
    destination_type = "cloudwatch-logs"
    log_format       = "json"
    log_type         = "slow-log"
  }

  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.elasticache_queue_cache_engine_logs.name
    destination_type = "cloudwatch-logs"
    log_format       = "json"
    log_type         = "engine-log"
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }

  lifecycle {
    ignore_changes = [num_cache_clusters]
  }
}

