#
# Client VPN that will allow users in the specified IAM Identity Center group
# access to the private subnets.
#
module "vpn" {
  source = "github.com/cds-snc/terraform-modules//client_vpn?ref=v9.5.3"

  endpoint_name         = "private-subnets"
  access_group_id       = var.client_vpn_access_group_id
  authentication_option = "federated-authentication"

  vpc_id              = var.vpc_id
  vpc_cidr_block      = var.vpc_cidr_block
  subnet_cidr_blocks  = var.subnet_cidr_blocks
  subnet_ids          = [tolist(var.subnet_ids)[0]]
  acm_certificate_arn = aws_acm_certificate.client_vpn.arn

  # Only create a self-service portal in prod  
  # The client config can still be downloaded from the AWS console
  self_service_portal                            = var.env == "production" ? "enabled" : "disabled"
  client_vpn_self_service_saml_metadata_document = var.env == "production" ? var.client_vpn_self_service_saml_metadata : null
  client_vpn_saml_metadata_document              = var.client_vpn_saml_metadata

  banner_text = "Welcome to the Notify ${upper(var.env)} Environment. This is a private network.  Only authorized users may connect and should take care not to cause service disruptions."


  billing_tag_value = "notification-canada-ca-${var.env}"
}

# GHA VPN
module "gha_vpn" {
  source = "github.com/cds-snc/terraform-modules//client_vpn?ref=v9.6.4"

  endpoint_name   = "gha-vpn"
  access_group_id = var.client_vpn_access_group_id

  authentication_option = "certificate-authentication"

  vpc_id              = var.vpc_id
  vpc_cidr_block      = var.vpc_cidr_block
  subnet_cidr_blocks  = var.subnet_cidr_blocks
  subnet_ids          = [tolist(var.subnet_ids)[0]]
  acm_certificate_arn = aws_acm_certificate.client_vpn.arn

  # Only create a self-service portal in prod  
  # The client config can still be downloaded from the AWS console
  self_service_portal = var.env == "production" ? "enabled" : "disabled"
  banner_text         = "Welcome to the Notify ${upper(var.env)} Environment. This is a private network.  Only authorized users may connect and should take care not to cause service disruptions."


  billing_tag_value = "notification-canada-ca-${var.env}"
}

resource "aws_acm_certificate" "client_vpn" {
  certificate_authority_arn = aws_acmpca_certificate_authority.client_vpn.arn
  domain_name               = "${var.env}.notification.canada.ca"

  tags = {
    Environment = var.env
  }

  lifecycle {
    create_before_destroy = true
  }
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


data "aws_partition" "current" {}
