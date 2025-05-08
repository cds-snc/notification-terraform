output "database_read_only_proxy_endpoint" {
  value = "${module.rds_proxy.db_proxy_endpoints.read_only.endpoint}:${module.rds_proxy.proxy_target_port}"
}
output "database_read_write_proxy_endpoint" {
  value = "${module.rds_proxy.db_proxy_endpoints.read_write.endpoint}:${module.rds_proxy.proxy_target_port}"
}
output "database_name" {
  value = aws_rds_cluster.notification-canada-ca.database_name
}
output "database_subnet_ids" {
  value = aws_db_subnet_group.notification-canada-ca.subnet_ids
}
output "rds_reader_instance_ids" {
  value       = [for instance in aws_rds_cluster_instance.notification-canada-ca-instances : instance.identifier if instance.count.index > 0]
  description = "List of reader instance IDs in the RDS cluster"
}
output "postgres_cluster_endpoint" {
  value     = aws_rds_cluster.notification-canada-ca.endpoint
  sensitive = true
}
output "shared_staging_kms_key_id" {
  value     = var.env == "staging" ? aws_kms_key.rds_snapshot[0].arn : ""
  sensitive = true
}
