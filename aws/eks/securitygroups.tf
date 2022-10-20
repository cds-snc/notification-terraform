###
# AWS ALB Security Group
###

resource "aws_security_group" "notification-canada-ca-alb" {
  name        = "notification-canada-ca-alb"
  description = "Ingress - Application load balancer"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:AWS008
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:AWS008
  }

  ingress {
    protocol    = "tcp"
    from_port   = 4444
    to_port     = 4444
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:AWS008
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

###
# Find the automatically created security group for RDS
###

data "aws_security_group" "eks-securitygroup-rds" {
  id = aws_eks_cluster.notification-canada-ca-eks-cluster.vpc_config[0].cluster_security_group_id
}

###
# Blazer Security group. Due to a circular dependency, it cannot be added to the blazer folder
###

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
    security_groups = [data.aws_security_group.eks-securitygroup-rds.id, aws_security_group.database-tools-db-securitygroup.id]
  }
}

resource "aws_security_group" "database-tools-db-securitygroup" {
  name        = "Database tools Database Security Group"
  description = "Security group for database in database-tools. Needs access to notify's main DB and blazer task"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "database-tools-db-ingress" {
  description              = "Access Blazer task security group"
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.blazer.id
  security_group_id        = aws_security_group.database-tools-db-securitygroup.id
}

resource "aws_security_group_rule" "notification-canada-ca-alb-database-tools-ingress" {
  description              = "Access to database-tools (blazer) access through its security group"
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.blazer.id
  security_group_id        = data.aws_security_group.eks-securitygroup-rds.id
}

###
# Notification Worker Security Group
###

resource "aws_security_group" "notification-canada-ca-worker" {
  name        = "notification-canada-ca-worker"
  description = "ALB to Worker communication"
  vpc_id      = var.vpc_id

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}
