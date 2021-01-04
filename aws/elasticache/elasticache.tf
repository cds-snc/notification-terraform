###
# AWS Elasticache Redis for Notification application
###

resource "aws_elasticache_subnet_group" "notification-canada-ca-cache-subnet" {
  name       = "notification-canada-ca-${var.env}-cache-subnet"
  subnet_ids = var.vpc_private_subnets
}

resource "aws_elasticache_cluster" "notification-cluster-cache" {
  # Default is false with this param, it looks counter-intuitive because
  # applied changes would only happen during maintenance window if false.
  apply_immediately = true
  cluster_id        = "notification-cluster-cache"
  engine            = "redis"
  # AWS automatically supports the Redis minor version management since version 6.
  # https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/supported-engine-versions.html#redis-version-6.x
  engine_version       = "6.x"
  maintenance_window   = "thu:04:00-thu:05:00"
  node_type            = var.elasticache_node_type
  num_cache_nodes      = var.elasticache_node_count
  parameter_group_name = "default.redis4.0"
  port                 = 6379
  security_group_ids = [
    var.eks_cluster_securitygroup
  ]
  subnet_group_name = aws_elasticache_subnet_group.notification-canada-ca-cache-subnet.name

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}
