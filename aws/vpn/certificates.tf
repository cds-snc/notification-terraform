data "aws_partition" "current" {}

resource "aws_acm_certificate" "client_vpn" {
  depends_on = [time_sleep.wait_for_cert_authority]

  certificate_authority_arn = aws_acmpca_certificate_authority.client_vpn.arn
  domain_name               = "${var.env}.notification.canada.ca"

  tags = {
    Environment = var.env
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "time_sleep" "wait_for_cert_authority" {
  depends_on = [aws_acmpca_certificate_authority.client_vpn]

  create_duration = "30s"
}

resource "aws_acmpca_certificate_authority_certificate" "client_vpn" {
  certificate_authority_arn = aws_acmpca_certificate_authority.client_vpn.arn

  certificate       = aws_acmpca_certificate.client_vpn.certificate
  certificate_chain = aws_acmpca_certificate.client_vpn.certificate_chain
}

resource "aws_acmpca_certificate" "client_vpn" {
  certificate_authority_arn   = aws_acmpca_certificate_authority.client_vpn.arn
  certificate_signing_request = aws_acmpca_certificate_authority.client_vpn.certificate_signing_request
  signing_algorithm           = "SHA512WITHRSA"

  template_arn = "arn:${data.aws_partition.current.partition}:acm-pca:::template/RootCACertificate/V1"

  validity {
    type  = "YEARS"
    value = 5
  }
}

resource "aws_acmpca_certificate_authority" "client_vpn" {
  type = "ROOT"

  certificate_authority_configuration {
    key_algorithm     = "RSA_4096"
    signing_algorithm = "SHA512WITHRSA"

    subject {
      common_name = "notification.canada.ca"
    }
  }

  permanent_deletion_time_in_days = 7
}


