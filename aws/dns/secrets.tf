resource "aws_secretsmanager_secret" "internal_dns_cert_base64" {
  name = "INTERNAL_DNS_CERT_BASE64"
}

resource "aws_secretsmanager_secret_version" "internal_dns_cert_base64" {
  secret_id     = aws_secretsmanager_secret.internal_dns_cert_base64.id
  secret_string = base64encode(tls_self_signed_cert.internal_dns.cert_pem)
}

resource "aws_secretsmanager_secret" "internal_dns_key_base64" {
  name = "INTERNAL_DNS_KEY_BASE64"
}

resource "aws_secretsmanager_secret_version" "internal_dns_key_base64" {
  secret_id     = aws_secretsmanager_secret.internal_dns_key_base64.id
  secret_string = base64encode(tls_private_key.internal_dns.private_key_pem)
}