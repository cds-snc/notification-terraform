#
# Client VPN that will allow users in the specified IAM Identity Center group
# access to the private subnets.
#
module "vpn" {
  source = "github.com/cds-snc/terraform-modules//client_vpn?ref=v7.4.3"

  endpoint_name   = "private-subnets"
  access_group_id = var.client_vpn_access_group_id

  vpc_id              = aws_vpc.notification-canada-ca.id
  vpc_cidr_block      = aws_vpc.notification-canada-ca.cidr_block
  subnet_cidr_blocks  = aws_subnet.notification-canada-ca-private.*.cidr_block
  acm_certificate_arn = aws_acm_certificate.client_vpn.arn

  # Only create a self-service portal in prod  
  # The client config can still be downloaded from the AWS console
  self_service_portal                            = var.env == "production" ? "enabled" : "disabled"
  client_vpn_self_service_saml_metadata_document = var.env == "production" ? var.client_vpn_self_service_saml_metadata : null
  client_vpn_saml_metadata_document              = var.client_vpn_saml_metadata

  billing_tag_value = "notification-canada-ca-${var.env}"
}

#
# Certificate used for VPN communication
#
resource "aws_acm_certificate" "client_vpn" {
  private_key      = var.client_vpn_private_key
  certificate_body = var.client_vpn_certificate

  tags = {
    Name       = "notification-canada-ca"
    CostCenter = "notification-canada-ca-${var.env}"
  }

  lifecycle {
    create_before_destroy = true
  }
}
