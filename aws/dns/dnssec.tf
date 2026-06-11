# Route53 DNSSEC for notification.cdssandbox.xyz
#
# AWS requires the KMS key to be in us-east-1 regardless of the hosted zone region.
# After applying, retrieve the DS record from the output and provide it to the
# cdssandbox.xyz registrar to complete the chain of trust.

data "aws_caller_identity" "dns" {
  count    = var.env == "staging" ? 1 : 0
  provider = aws.dns-us-east-1
}

resource "aws_kms_key" "dnssec" {
  count                    = var.env == "staging" ? 1 : 0
  provider                 = aws.dns-us-east-1
  description              = "KMS key for Route53 DNSSEC signing - notification.cdssandbox.xyz"
  customer_master_key_spec = "ECC_NIST_P256"
  key_usage                = "SIGN_VERIFY"
  deletion_window_in_days  = 7
  enable_key_rotation      = false # rotation not supported for asymmetric keys

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM root permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.dns[0].account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow Route53 DNSSEC to use the key"
        Effect = "Allow"
        Principal = {
          Service = "dnssec-route53.amazonaws.com"
        }
        Action = [
          "kms:DescribeKey",
          "kms:GetPublicKey",
          "kms:Sign"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.dns[0].account_id
          }
        }
      },
      {
        Sid    = "Allow Route53 DNSSEC to create grants"
        Effect = "Allow"
        Principal = {
          Service = "dnssec-route53.amazonaws.com"
        }
        Action   = "kms:CreateGrant"
        Resource = "*"
        Condition = {
          Bool = {
            "kms:GrantIsForAWSResource" = "true"
          }
          StringEquals = {
            "aws:SourceAccount" = data.aws_caller_identity.dns[0].account_id
          }
        }
      }
    ]
  })

  tags = {
    "Project" = "dns"
  }
}

resource "aws_kms_alias" "dnssec" {
  count         = var.env == "staging" ? 1 : 0
  provider      = aws.dns-us-east-1
  name          = "alias/notification-cdssandbox-xyz-dnssec"
  target_key_id = aws_kms_key.dnssec[0].key_id
}

resource "aws_route53_key_signing_key" "notification-sandbox" {
  count                      = var.env == "staging" ? 1 : 0
  provider                   = aws.dns
  hosted_zone_id             = aws_route53_zone.notification-sandbox[0].zone_id
  key_management_service_arn = aws_kms_key.dnssec[0].arn
  name                       = "notification-cdssandbox-xyz-ksk"
}

resource "aws_route53_hosted_zone_dnssec" "notification-sandbox" {
  count          = var.env == "staging" ? 1 : 0
  provider       = aws.dns
  hosted_zone_id = aws_route53_key_signing_key.notification-sandbox[0].hosted_zone_id

  depends_on = [aws_route53_key_signing_key.notification-sandbox]
}
