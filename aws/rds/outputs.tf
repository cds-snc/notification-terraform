output "database_name" {
  value = aws_rds_cluster.notification-canada-ca.database_name
}
output "database_subnet_ids" {
  value = aws_db_subnet_group.notification-canada-ca.subnet_ids
}
output "rds_instance_id" {
  value = aws_rds_cluster_instance.notification-canada-ca-instances[0].identifier
}
output "postgres_cluster_endpoint" {
  value     = aws_rds_cluster.notification-canada-ca.endpoint
  sensitive = true
}
output "shared_staging_kms_key_id" {
  value     = var.env == "staging" ? aws_kms_key.rds_snapshot[0].arn : ""
  sensitive = true
}