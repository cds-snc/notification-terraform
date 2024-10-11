resource "aws_secretsmanager_secret" "internal_dns_cert_base64" {
  name                    = "INTERNAL_DNS_CERT_BASE64"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "internal_dns_cert_base64" {
  secret_id     = aws_secretsmanager_secret.internal_dns_cert_base64.id
  secret_string = tls_self_signed_cert.internal_dns.cert_pem
}

resource "aws_secretsmanager_secret" "internal_dns_key_base64" {
  name                    = "INTERNAL_DNS_KEY_BASE64"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "internal_dns_key_base64" {
  secret_id     = aws_secretsmanager_secret.internal_dns_key_base64.id
  secret_string = tls_private_key.internal_dns.private_key_pem
}

resource "aws_secretsmanager_secret" "internal_dns_fqdn" {
  name                    = "INTERNAL_DNS_FQDN"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "internal_dns_fqdn" {
  secret_id     = aws_secretsmanager_secret.internal_dns_fqdn.id
  secret_string = aws_route53_zone.internal_dns.name
}

resource "aws_secretsmanager_secret" "aws_route53_zone" {
  name                    = "AWS_ROUTE53_ZONE"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "aws_route53_zone" {
  secret_id     = aws_secretsmanager_secret.aws_route53_zone.id
  secret_string = var.route53_zone_id
}
