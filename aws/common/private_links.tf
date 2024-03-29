
# TODO: add these later - "lambda", "elasticache", "elasticache-fips", "email-smtp", "sns", "sqs",
locals {
  endpoints_interface = toset([
    "ecr.dkr", "ecr.api", "logs", "ssm",
    "ssmmessages", "ec2messages", "monitoring", "rds"
  ])
  endpoints_gateway = toset(["s3"])
}

resource "aws_vpc_endpoint" "interface" {
  for_each = local.endpoints_interface

  vpc_id              = aws_vpc.notification-canada-ca.id
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.${var.region}.${each.value}"
  private_dns_enabled = true
  security_group_ids = [
    aws_security_group.vpc_endpoints.id,
  ]
  subnet_ids = aws_subnet.notification-canada-ca-private[*].id
}

resource "aws_vpc_endpoint" "gateway" {
  for_each = local.endpoints_gateway

  vpc_id            = aws_vpc.notification-canada-ca.id
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.${var.region}.${each.value}"
  route_table_ids   = aws_route_table.notification-canada-ca-private_subnet[*].id
}

resource "aws_security_group" "vpc_endpoints" {
  name        = "vpc_endpoints"
  description = "PrivateLink VPC endpoints"
  vpc_id      = aws_vpc.notification-canada-ca.id
}
