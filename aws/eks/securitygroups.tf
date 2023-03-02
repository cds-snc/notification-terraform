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
}

resource "aws_security_group_rule" "blazer-access-rds-eks" {
  description              = "Access to RDS DB through the EKS Security Group"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  type                     = "egress"
  security_group_id        = aws_security_group.blazer.id
  source_security_group_id = data.aws_security_group.eks-securitygroup-rds.id
}

resource "aws_security_group_rule" "blazer-access-dbtools-db" {
  description              = "Access to the Database tool DB"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  type                     = "egress"
  security_group_id        = aws_security_group.blazer.id
  source_security_group_id = aws_security_group.database-tools-db-securitygroup.id
}

resource "aws_security_group" "database-tools-db-securitygroup" {
  name        = "Database tools Database Security Group"
  description = "Security group for database in database-tools"
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

# Quicksight security groups
# following https://cloudcompiled.com/tutorials/amazon-quicksight-rds-vpc/

resource "aws_security_group" "quicksight" {
  name        = "quicksight"
  description = "Allow Quicksight to connect to RDS"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "quicksight-access-rds-eks" {
  description              = "Connect Quicksight to RDS"
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 5432
  to_port                  = 5432
  security_group_id        = aws_security_group.quicksight.id
  source_security_group_id = data.aws_security_group.eks-securitygroup-rds.id
}

resource "aws_security_group_rule" "notification-canada-ca-alb-quicksight-ingress" {
  description              = "Access to Quicksight access through its security group"
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.quicksight.id
  security_group_id        = data.aws_security_group.eks-securitygroup-rds.id
}

# Google CIDR security groups

resource "aws_ec2_managed_prefix_list" "google_cidrs" {
  name           = "Google Service CIDRs"
  address_family = "IPv4"
  max_entries    = 100

  tags = {
    CostCentre = "notification-canada-ca-${var.env}"
  }
}

resource "aws_security_group_rule" "blazer-egress-google-cidrs" {
  description       = "Access Google Services from Blazer"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.blazer.id
  prefix_list_ids = [
    aws_ec2_managed_prefix_list.google_cidrs.id
  ]
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


###
# Connect all security groups to go through the private link
###

# the load balancer
resource "aws_security_group_rule" "loadbalancer-egress-private-endpoints" {
  description              = "Internal egress to VPC PrivateLink endpoints from notification loadbalancer"
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = var.private-links-vpc-endpoints-securitygroup
  security_group_id        = aws_security_group.notification-canada-ca-alb.id
}

resource "aws_security_group_rule" "private-endpoints-ingress-loadbalancer" {
  description              = "VPC PrivateLink endpoints ingress from notification loadbalancer"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.notification-canada-ca-alb.id
  security_group_id        = var.private-links-vpc-endpoints-securitygroup
}

resource "aws_security_group_rule" "notify-lb-egress-endpoints-gateway" {
  description       = "Security group rule for notification loadbalancer to S3 gateway"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.notification-canada-ca-alb.id
  prefix_list_ids   = var.private-links-gateway-prefix-list-ids
}

# eks-securitygroup

resource "aws_security_group_rule" "eks-egress-private-endpoints" {
  description              = "Internal egress to VPC PrivateLink endpoints from eks securitygroup"
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = var.private-links-vpc-endpoints-securitygroup
  security_group_id        = data.aws_security_group.eks-securitygroup-rds.id
}

resource "aws_security_group_rule" "private-endpoints-ingress-eks" {
  description              = "VPC PrivateLink endpoints ingress from eks securitygroup"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = data.aws_security_group.eks-securitygroup-rds.id
  security_group_id        = var.private-links-vpc-endpoints-securitygroup
}

resource "aws_security_group_rule" "eks-egress-endpoints-gateway" {
  description       = "Security group rule for eks securitygroup to S3 gateway"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = data.aws_security_group.eks-securitygroup-rds.id
  prefix_list_ids   = var.private-links-gateway-prefix-list-ids
}

# blazer

resource "aws_security_group_rule" "blazer-egress-private-endpoints" {
  description              = "Internal egress to VPC PrivateLink endpoints from blazer"
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = var.private-links-vpc-endpoints-securitygroup
  security_group_id        = aws_security_group.blazer.id
}

resource "aws_security_group_rule" "private-endpoints-ingress-blazer" {
  description              = "VPC PrivateLink endpoints ingress from blazer"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.blazer.id
  security_group_id        = var.private-links-vpc-endpoints-securitygroup
}

resource "aws_security_group_rule" "blazer-egress-endpoints-gateway" {
  description       = "Security group rule for blazer to S3 gateway"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.blazer.id
  prefix_list_ids   = var.private-links-gateway-prefix-list-ids
}

# Database-tools

resource "aws_security_group_rule" "dbtools-db-egress-private-endpoints" {
  description              = "Internal egress to VPC PrivateLink endpoints from dbtools-db"
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = var.private-links-vpc-endpoints-securitygroup
  security_group_id        = aws_security_group.database-tools-db-securitygroup.id
}

resource "aws_security_group_rule" "private-endpoints-ingress-dbtools-db" {
  description              = "VPC PrivateLink endpoints ingress from dbtools-db"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.database-tools-db-securitygroup.id
  security_group_id        = var.private-links-vpc-endpoints-securitygroup
}

resource "aws_security_group_rule" "dbtools-egress-endpoints-gateway" {
  description       = "Security group rule for dbtools to S3 gateway"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.database-tools-db-securitygroup.id
  prefix_list_ids   = var.private-links-gateway-prefix-list-ids
}

# Notification worker

resource "aws_security_group_rule" "notification-worker-egress-private-endpoints" {
  description              = "Internal egress to VPC PrivateLink endpoints from notification worker"
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = var.private-links-vpc-endpoints-securitygroup
  security_group_id        = aws_security_group.notification-canada-ca-worker.id
}

resource "aws_security_group_rule" "private-endpoints-ingress-notification-worker" {
  description              = "VPC PrivateLink endpoints ingress from notification worker"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.notification-canada-ca-worker.id
  security_group_id        = var.private-links-vpc-endpoints-securitygroup
}

resource "aws_security_group_rule" "notification-worker-egress-endpoints-gateway" {
  description       = "Security group rule for notification worker to S3 gateway"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.notification-canada-ca-worker.id
  prefix_list_ids   = var.private-links-gateway-prefix-list-ids
}
