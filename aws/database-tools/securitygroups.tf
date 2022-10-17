data "aws_subnet" "private_subnet" {
  for_each = toset(var.vpc_private_subnets)
  id       = each.value
}

resource "aws_security_group" "blazer" {
  name        = "blazer"
  description = "Allow inbound traffic to internal service"
  vpc_id      = var.vpc_id

  egress {
    description = "Access to internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Access to internal service"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    self        = true
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description     = "Access to RDS DB through the EKS Security Group"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.eks-cluster-securitygroup]
  }
}
