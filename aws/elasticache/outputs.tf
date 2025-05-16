output "redis_cluster_security_group_id" {
  description = "ID of the cluster's dedicated security group.  Currenly this is created in Staging only."
  value       = var.env == "staging" ? aws_security_group.redis_cluster[0].id : ""
}

output "redis_primary_endpoint_address" {
  description = "The address of the primary node for the cluster"
  value       = var.elasticache_use_valkey == true ? aws_elasticache_replication_group.notification_valkey_cluster[0].primary_endpoint_address : aws_elasticache_replication_group.notification-cluster-cache-multiaz-group.primary_endpoint_address
  sensitive   = true
}
