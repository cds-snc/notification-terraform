resource "aws_eks_cluster" "eks_auto" {
  count    = var.env == "dev" ? 1 : 0
  name     = "notify-${var.env}-eks"
  role_arn = aws_iam_role.cluster[0].arn
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
    node_role_arn = aws_iam_role.node[0].arn
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
  count = var.env == "dev" ? 1 : 0
  name  = "eks-test-cluster-role"

  assume_role_policy = data.aws_iam_policy_document.cluster_role_assume_role_policy.json
}

resource "aws_iam_role_policy_attachments_exclusive" "cluster" {
  count     = var.env == "dev" ? 1 : 0
  role_name = aws_iam_role.cluster[0].name
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
  count = var.env == "dev" ? 1 : 0
  name  = "eks-auto-node"
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
  count      = var.env == "dev" ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodeMinimalPolicy"
  role       = aws_iam_role.node[0].name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryPullOnly" {
  count      = var.env == "dev" ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
  role       = aws_iam_role.node[0].name
}

# Grant cluster admin access to the SSO admin role
resource "aws_eks_access_entry" "admin_sso" {
  count         = var.env == "dev" ? 1 : 0
  cluster_name  = aws_eks_cluster.eks_auto[0].name
  principal_arn = "arn:aws:iam::${var.account_id}:role/aws-reserved/sso.amazonaws.com/ca-central-1/AWSReservedSSO_AWSAdministratorAccess_e6e62a284c3c35fc"
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "admin_sso_policy" {
  count         = var.env == "dev" ? 1 : 0
  cluster_name  = aws_eks_cluster.eks_auto[0].name
  principal_arn = "arn:aws:iam::${var.account_id}:role/aws-reserved/sso.amazonaws.com/ca-central-1/AWSReservedSSO_AWSAdministratorAccess_e6e62a284c3c35fc"
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.admin_sso]
}


data "aws_security_group" "eks_auto" {
  count = var.env == "dev" ? 1 : 0
  id    = aws_eks_cluster.eks_auto[0].vpc_config[0].cluster_security_group_id
}

# eks-securitygroup

resource "aws_security_group_rule" "eks_auto_private_endpoint_egress" {
  count                    = var.env == "dev" ? 1 : 0
  description              = "Internal egress to VPC PrivateLink endpoints from eks securitygroup"
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = var.private-links-vpc-endpoints-securitygroup
  security_group_id        = data.aws_security_group.eks_auto[0].id
}

resource "aws_security_group_rule" "private_endpoints_ingress_eks_auto" {
  count                    = var.env == "dev" ? 1 : 0
  description              = "VPC PrivateLink endpoints ingress from eks securitygroup"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = data.aws_security_group.eks_auto[0].id
  security_group_id        = var.private-links-vpc-endpoints-securitygroup
}

resource "aws_security_group_rule" "eks_auto_egress_endpoints_gateway" {
  count             = var.env == "dev" ? 1 : 0
  description       = "Security group rule for eks securitygroup to S3 gateway"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = data.aws_security_group.eks_auto[0].id
  prefix_list_ids   = var.private-links-gateway-prefix-list-ids

}

resource "aws_eks_addon" "kube_proxy_auto" {
  count                       = var.env == "dev" ? 1 : 0
  cluster_name                = aws_eks_cluster.eks_auto[0].name
  addon_name                  = "kube-proxy"
  addon_version               = var.eks_addon_kube_proxy_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}

resource "aws_eks_addon" "vpc_cni_auto" {
  count                       = var.env == "dev" ? 1 : 0
  cluster_name                = aws_eks_cluster.eks_auto[0].name
  addon_name                  = "vpc-cni"
  addon_version               = var.eks_addon_vpc_cni_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}

resource "aws_eks_addon" "ebs_driver_auto" {
  count                       = var.env == "dev" ? 1 : 0
  cluster_name                = aws_eks_cluster.eks_auto[0].name
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = var.eks_addon_ebs_driver_version
  service_account_role_arn    = aws_iam_role.ebs_csi_driver_auto[0].arn
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}