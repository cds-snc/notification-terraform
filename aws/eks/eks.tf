###
# AWS EKS Cluster configuration
###

resource "aws_eks_cluster" "notification-canada-ca-eks-cluster" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks-cluster-role.arn
  version  = var.eks_cluster_version

  enabled_cluster_log_types = ["api", "audit", "controllerManager", "scheduler", "authenticator"]

  vpc_config {
    # tfsec:ignore:AWS068 EKS cluster should not have open CIDR range for public access
    # Will be tackled in the future https://github.com/cds-snc/notification-terraform/issues/203
    security_group_ids = [
      aws_security_group.notification-canada-ca-worker.id
    ]
    subnet_ids = var.vpc_private_subnets
    # tfsec:ignore:AWS069 EKS Clusters should have the public access disabled
    # Cannot connect with kubectl if we do this atm, will tackle later
    # https://github.com/cds-snc/notification-terraform/issues/205
  }

  # tfsec:ignore:AWS066 EKS should have the encryption of secrets enabled
  # Will be tackled in the future https://github.com/cds-snc/notification-terraform/issues/202

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_cloudwatch_log_group.notification-canada-ca-eks-cluster-logs,
    aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController,
  ]

  tags = {
    Name       = "notification-canada-ca"
    CostCentre = "notification-canada-ca-${var.env}"
    Terraform  = true
  }
}

###
# AWS EKS Nodegroup configuration
###

resource "aws_eks_node_group" "notification-canada-ca-eks-node-group" {
  cluster_name    = aws_eks_cluster.notification-canada-ca-eks-cluster.name
  node_group_name = "notification-canada-ca-${var.env}-eks-primary-node-group"
  node_role_arn   = aws_iam_role.eks-worker-role.arn
  subnet_ids      = var.vpc_private_subnets

  release_version = var.eks_node_ami_version
  instance_types  = var.primary_worker_instance_types

  scaling_config {
    desired_size = var.primary_worker_desired_size
    max_size     = var.primary_worker_max_size
    min_size     = var.primary_worker_min_size
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-worker-AWSLoadBalancerControllerIAMPolicy,
    aws_iam_role_policy_attachment.eks-worker-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.eks-worker-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-worker-AmazonEKS_CNI_Policy
  ]

  tags = {
    Name       = "notification-canada-ca"
    CostCentre = "notification-canada-ca-${var.env}"
    Terraform  = true
  }
}

###
# AWS EKS addons
###

resource "aws_eks_addon" "coredns" {
  cluster_name      = aws_eks_cluster.notification-canada-ca-eks-cluster.name
  addon_name        = "coredns"
  addon_version     = var.eks_addon_coredns_version
  resolve_conflicts = "OVERWRITE"
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name      = aws_eks_cluster.notification-canada-ca-eks-cluster.name
  addon_name        = "kube-proxy"
  addon_version     = var.eks_addon_kube_proxy_version
  resolve_conflicts = "OVERWRITE"
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name      = aws_eks_cluster.notification-canada-ca-eks-cluster.name
  addon_name        = "vpc-cni"
  addon_version     = var.eks_addon_vpc_cni_version
  resolve_conflicts = "OVERWRITE"
}
