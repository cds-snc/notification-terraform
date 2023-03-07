output "redis_cluster_security_group_id" {
  description = "ID of the cluster's dedicated security group.  Currenly this is created in Staging only."
  value       = aws_security_group.redis_cluster.id
}
