resource "tls_private_key" "internal_dns" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "internal_dns" {
  private_key_pem       = tls_private_key.internal_dns.private_key_pem
  validity_period_hours = 43800 # 5 years
  early_renewal_hours   = 672   # Generate new cert if Terraform is run within 4 weeks of expiry

  subject {
    common_name = aws_route53_zone.internal_dns.name
  }

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "internal_dns" {
  private_key      = tls_private_key.internal_dns.private_key_pem
  certificate_body = tls_self_signed_cert.internal_dns.cert_pem

  tags = {
    Name       = "notification-canada-ca"
    CostCenter = "notification-canada-ca-${var.env}"
  }

  lifecycle {
    create_before_destroy = true
  }
}