resource "aws_secretsmanager_secret" "gha_vpn_cert" {
  name                    = "GHA_VPN_CERT"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "gha_vpn_cert" {
  secret_id     = aws_secretsmanager_secret.gha_vpn_cert.id
  secret_string = module.gha_vpn.client_vpn_certificate_pem
}

resource "aws_secretsmanager_secret" "gha_vpn_key" {
  name                    = "GHA_VPN_KEY"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "gha_vpn_key" {
  secret_id     = aws_secretsmanager_secret.gha_vpn_key.id
  secret_string = module.gha_vpn.client_vpn_private_key_pem
}
