output "redis_cluster_security_group_id" {
  description = "ID of the cluster's dedicated security group.  Currenly this is created in Staging only."
  value       = var.env == "staging" ? aws_security_group.redis_cluster[0].id : null
}
