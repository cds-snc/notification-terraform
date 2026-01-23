resource "aws_eks_cluster" "eks_auto" {
  name     = "notify-${var.env}-eks"
  role_arn = aws_iam_role.cluster.arn
  version  = var.eks_cluster_version

  vpc_config {
    subnet_ids = var.vpc_private_subnets
    security_group_ids = [
      aws_security_group.notification-canada-ca-worker.id
    ]
    endpoint_private_access = "true"
    endpoint_public_access  = "false"
  }

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = false
  }

  bootstrap_self_managed_addons = false

  zonal_shift_config {
    enabled = true
  }

  compute_config {
    enabled       = true
    node_pools    = ["general-purpose", "system"]
    node_role_arn = aws_iam_role.node.arn
  }

  kubernetes_network_config {
    elastic_load_balancing {
      enabled = true
    }
  }

  storage_config {
    block_storage {
      enabled = true
    }
  }
}

resource "aws_iam_role" "cluster" {
  name = "eks-test-cluster-role"

  assume_role_policy = data.aws_iam_policy_document.cluster_role_assume_role_policy.json
}

resource "aws_iam_role_policy_attachments_exclusive" "cluster" {
  role_name = aws_iam_role.cluster.name
  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSComputePolicy",
    "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy",
    "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
    "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  ]
}

data "aws_iam_policy_document" "cluster_role_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole", "sts:TagSession"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "node" {
  name = "eks-auto-node"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["sts:AssumeRole"]
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodeMinimalPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodeMinimalPolicy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryPullOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
  role       = aws_iam_role.node.name
}

# Grant cluster admin access to the SSO admin role
resource "aws_eks_access_entry" "admin_sso" {
  cluster_name  = aws_eks_cluster.eks_auto.name
  principal_arn = "arn:aws:iam::${var.account_id}:role/aws-reserved/sso.amazonaws.com/ca-central-1/AWSReservedSSO_AWSAdministratorAccess_e6e62a284c3c35fc"
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "admin_sso_policy" {
  cluster_name  = aws_eks_cluster.eks_auto.name
  principal_arn = "arn:aws:iam::${var.account_id}:role/aws-reserved/sso.amazonaws.com/ca-central-1/AWSReservedSSO_AWSAdministratorAccess_e6e62a284c3c35fc"
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.admin_sso]
}


data "aws_security_group" "eks_auto" {
  id = aws_eks_cluster.eks_auto.vpc_config[0].cluster_security_group_id
}

# eks-securitygroup

resource "aws_security_group_rule" "eks_auto_private_endpoint_egress" {
  description              = "Internal egress to VPC PrivateLink endpoints from eks securitygroup"
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = var.private-links-vpc-endpoints-securitygroup
  security_group_id        = data.aws_security_group.eks_auto.id
}

resource "aws_security_group_rule" "private_endpoints_ingress_eks_auto" {
  description              = "VPC PrivateLink endpoints ingress from eks securitygroup"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = data.aws_security_group.eks_auto.id
  security_group_id        = var.private-links-vpc-endpoints-securitygroup
}

resource "aws_security_group_rule" "eks_auto_egress_endpoints_gateway" {
  description       = "Security group rule for eks securitygroup to S3 gateway"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = data.aws_security_group.eks_auto.id
  prefix_list_ids   = var.private-links-gateway-prefix-list-ids

}