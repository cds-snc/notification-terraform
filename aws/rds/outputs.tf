output "database_proxy_endpoint" {
  description = "The endpoint that you can use to connect to the proxy"
  value       = module.rds_proxy.proxy_endpoint
}