###
# Locust Redline Load Test — VPC
# A standalone VPC so load-test traffic is fully isolated from the notify VPC.
###

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "locust" {
  cidr_block           = var.locust_vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name                  = "locust-redline-vpc"
    (var.billing_tag_key) = var.billing_tag_value
  }
}

###
# Lock down the default security group — no implicit rules
###
resource "aws_default_security_group" "locust" {
  vpc_id = aws_vpc.locust.id
}

###
# Internet Gateway
###
resource "aws_internet_gateway" "locust" {
  vpc_id = aws_vpc.locust.id

  tags = {
    Name                  = "locust-redline-igw"
    (var.billing_tag_key) = var.billing_tag_value
  }
}

###
# Public subnets — used for the master and NAT GW
###
resource "aws_subnet" "locust_public" {
  count = 2

  vpc_id            = aws_vpc.locust.id
  cidr_block        = cidrsubnet(var.locust_vpc_cidr_block, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name                  = "locust-redline-public-${count.index + 1}"
    (var.billing_tag_key) = var.billing_tag_value
  }
}

###
# Private subnets — used for worker tasks
###
resource "aws_subnet" "locust_private" {
  count = 2

  vpc_id            = aws_vpc.locust.id
  cidr_block        = cidrsubnet(var.locust_vpc_cidr_block, 8, count.index + 2)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name                  = "locust-redline-private-${count.index + 1}"
    (var.billing_tag_key) = var.billing_tag_value
  }
}

###
# NAT Gateway (single, in the first public subnet — cost-efficient for testing)
###
resource "aws_eip" "locust_nat" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.locust]

  tags = {
    Name                  = "locust-redline-nat-eip"
    (var.billing_tag_key) = var.billing_tag_value
  }
}

resource "aws_nat_gateway" "locust" {
  allocation_id = aws_eip.locust_nat.id
  subnet_id     = aws_subnet.locust_public[0].id
  depends_on    = [aws_internet_gateway.locust]

  tags = {
    Name                  = "locust-redline-nat"
    (var.billing_tag_key) = var.billing_tag_value
  }
}

###
# Route tables
###
resource "aws_route_table" "locust_public" {
  vpc_id = aws_vpc.locust.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.locust.id
  }

  tags = {
    Name                  = "locust-redline-public-rt"
    (var.billing_tag_key) = var.billing_tag_value
  }
}

resource "aws_route_table_association" "locust_public" {
  count          = 2
  subnet_id      = aws_subnet.locust_public[count.index].id
  route_table_id = aws_route_table.locust_public.id
}

resource "aws_route_table" "locust_private" {
  vpc_id = aws_vpc.locust.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.locust.id
  }

  tags = {
    Name                  = "locust-redline-private-rt"
    (var.billing_tag_key) = var.billing_tag_value
  }
}

resource "aws_route_table_association" "locust_private" {
  count          = 2
  subnet_id      = aws_subnet.locust_private[count.index].id
  route_table_id = aws_route_table.locust_private.id
}
