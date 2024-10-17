#
# Client VPN that will allow users in the specified IAM Identity Center group
# access to the private subnets.
#
module "vpn" {
  source = "github.com/cds-snc/terraform-modules//client_vpn?ref=v9.6.4"

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
