
# TODO: add these later - "lambda", "elasticache", "elasticache-fips", "email-smtp", "sns", "sqs",
locals {
  endpoints_interface = toset([
    "autoscaling", "ec2", "ec2messages", "ecr.api",
    "ecr.dkr", "ecs", "elasticloadbalancing", "logs",
    "monitoring", "rds", "ssm", "ssmmessages", "sts"
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
  route_table_ids = concat(
    aws_route_table.notification-canada-ca-private_subnet[*].id,
    aws_route_table.notification-canada-ca-private_subnet_k8s[*].id
  )
}

resource "aws_security_group" "vpc_endpoints" {
  name        = "vpc_endpoints"
  description = "PrivateLink VPC endpoints"
  vpc_id      = aws_vpc.notification-canada-ca.id
}
