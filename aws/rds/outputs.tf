output "database_read_only_proxy_endpoint" {
  value = "${module.rds_proxy.db_proxy_endpoints.read_only.endpoint}:${module.rds_proxy.proxy_target_port}"
}
output "database_read_write_proxy_endpoint" {
  value = "${module.rds_proxy.db_proxy_endpoints.read_write.endpoint}:${module.rds_proxy.proxy_target_port}"
}
output "database_name" {
  value = aws_rds_cluster.notification-canada-ca.database_name
}
