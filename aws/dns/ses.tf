resource "aws_ses_domain_identity" "notification-canada-ca" {
  domain = var.domain

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_ses_domain_dkim" "notification-canada-ca" {
  domain = var.domain

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}
