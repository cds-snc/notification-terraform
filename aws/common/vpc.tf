###
# AWS VPC
###

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "notification-canada-ca" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    Name       = "notification-canada-ca"
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

###
# AWS default security group
###

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.notification-canada-ca.id
}

###
# AWS Internet Gateway
###

resource "aws_internet_gateway" "notification-canada-ca" {
  vpc_id = aws_vpc.notification-canada-ca.id

  tags = {
    Name       = "notification-canada-ca"
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

###
# AWS NAT GW
###

resource "aws_eip" "notification-canada-ca-natgw" {
  count      = 3
  depends_on = [aws_internet_gateway.notification-canada-ca]

  vpc = true

  tags = {
    Name       = "notification-canada-ca"
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_eip" "notification-canada-ca-natgw-k8s" {
  count      = 3
  depends_on = [aws_internet_gateway.notification-canada-ca]

  vpc = true

  tags = {
    Name       = "notification-canada-ca"
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_nat_gateway" "notification-canada-ca" {
  count      = 3
  depends_on = [aws_internet_gateway.notification-canada-ca]

  allocation_id = aws_eip.notification-canada-ca-natgw.*.id[count.index]
  subnet_id     = aws_subnet.notification-canada-ca-public.*.id[count.index]

  tags = {
    Name       = "notification-canada-ca"
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_nat_gateway" "notification-canada-ca-k8s" {
  count      = 3
  depends_on = [aws_internet_gateway.notification-canada-ca]

  allocation_id = aws_eip.notification-canada-ca-natgw-k8s.*.id[count.index]
  subnet_id     = aws_subnet.notification-canada-ca-public.*.id[count.index]

  tags = {
    Name       = "notification-canada-ca"
    CostCenter = "notification-canada-ca-${var.env}"
  }
}



###
# AWS Subnets
###

resource "aws_subnet" "notification-canada-ca-private" {
  count = 3

  vpc_id            = aws_vpc.notification-canada-ca.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name                                                                  = "Private Subnet 0${count.index + 1}"
    CostCenter                                                            = "notification-canada-ca-${var.env}"
    Access                                                                = "private"
    "kubernetes.io/role/internal-elb"                                     = 1
    "kubernetes.io/cluster/notification-canada-ca-${var.env}-eks-cluster" = "shared"
    "karpenter.sh/discovery"                                              = var.eks_cluster_name
  }
}

resource "aws_subnet" "notification-canada-ca-public" {
  count = 3

  vpc_id            = aws_vpc.notification-canada-ca.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, count.index + 3)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name                     = "Public Subnet 0${count.index + 1}"
    CostCenter               = "notification-canada-ca-${var.env}"
    Access                   = "public"
    "kubernetes.io/role/elb" = 1
  }
}

resource "aws_subnet" "notification-canada-ca-private-k8s" {
  count = 3

  vpc_id            = aws_vpc.notification-canada-ca.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 3, count.index + 1)
  availability_zone = element(data.aws_availability_zones.available.names, count.index + 1)

  tags = {
    Name                                                                  = "Private Subnet 0${count.index + 4}"
    CostCenter                                                            = "notification-canada-ca-${var.env}"
    Access                                                                = "private"
    "kubernetes.io/role/internal-elb"                                     = 1
    "kubernetes.io/cluster/notification-canada-ca-${var.env}-eks-cluster" = "shared"
    "karpenter.sh/discovery"                                              = var.eks_cluster_name
  }
}

###
# AWS Routes
###

resource "aws_route_table" "notification-canada-ca-public_subnet" {
  vpc_id = aws_vpc.notification-canada-ca.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.notification-canada-ca.id
  }

  tags = {
    Name       = "Public Subnet Route Table"
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_route_table_association" "notification-canada-ca" {
  count = 3

  subnet_id      = aws_subnet.notification-canada-ca-public.*.id[count.index]
  route_table_id = aws_route_table.notification-canada-ca-public_subnet.id
}

resource "aws_route_table" "notification-canada-ca-private_subnet" {
  count = 3

  vpc_id = aws_vpc.notification-canada-ca.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.notification-canada-ca.*.id[count.index]
  }

  tags = {
    Name       = "Private Subnet Route Table ${count.index}"
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_route_table_association" "notification-canada-ca-private" {
  count = 3

  subnet_id      = aws_subnet.notification-canada-ca-private.*.id[count.index]
  route_table_id = aws_route_table.notification-canada-ca-private_subnet.*.id[count.index]
}

resource "aws_route_table" "notification-canada-ca-private_subnet_k8s" {
  count = 3

  vpc_id = aws_vpc.notification-canada-ca.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.notification-canada-ca-k8s.*.id[count.index]
  }

  tags = {
    Name       = "Private Subnet Route Table ${count.index + 3}"
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_route_table_association" "notification-canada-ca-private-k8s" {
  count = 3

  subnet_id      = aws_subnet.notification-canada-ca-private-k8s.*.id[count.index]
  route_table_id = aws_route_table.notification-canada-ca-private_subnet_k8s.*.id[count.index]
}

###
# AWS Network ACL
###

resource "aws_default_network_acl" "notification-canada-ca" {
  default_network_acl_id = aws_vpc.notification-canada-ca.default_network_acl_id

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 3389
    to_port    = 3389
  }

  ingress {
    protocol   = -1
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  // See https://www.terraform.io/docs/providers/aws/r/default_network_acl.html#managing-subnets-in-the-default-network-acl
  lifecycle {
    ignore_changes = [subnet_ids]
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_flow_log" "cloud-based-sensor" {
  depends_on = [
    module.cbs_logs_bucket
  ]
  log_destination      = "arn:aws:s3:::cbs-satellite-${var.account_id}/vpc_flow_logs/"
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.notification-canada-ca.id
  log_format           = "$${vpc-id} $${version} $${account-id} $${interface-id} $${srcaddr} $${dstaddr} $${srcport} $${dstport} $${protocol} $${packets} $${bytes} $${start} $${end} $${action} $${log-status} $${subnet-id} $${instance-id}"

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
    Terraform  = true
  }
}
