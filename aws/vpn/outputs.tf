# GHA VPN
output "gha_vpn_id" {
  value = module.gha_vpn.client_vpn_endpoint_id
}

output "gha_vpn_certificate" {
  sensitive = true
  value     = module.gha_vpn.client_vpn_certificate_pem
}

output "gha_vpn_key" {
  sensitive = true
  value     = module.gha_vpn.client_vpn_private_key_pem
}

# Sentinel
output "sentinel_forwarder_cloudwatch_lambda_arn" {
  value = module.sentinel_forwarder.lambda_arn
}

output "sentinel_forwarder_cloudwatch_lambda_name" {
  value = module.sentinel_forwarder.lambda_name
}

