resource "aws_ses_domain_identity" "notification-canada-ca" {
  domain = var.domain
}

resource "aws_ses_domain_dkim" "notification-canada-ca" {
  domain = var.domain
}
