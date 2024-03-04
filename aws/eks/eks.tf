###
# AWS EKS Cluster configuration
###

resource "aws_eks_cluster" "notification-canada-ca-eks-cluster" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks-cluster-role.arn
  version  = var.eks_cluster_version

  enabled_cluster_log_types = ["api", "audit", "controllerManager", "scheduler", "authenticator"]

  vpc_config {

    endpoint_private_access = true
    endpoint_public_access  = false

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
    aws_iam_role_policy_attachment.eks-worker-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-worker-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-worker-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.eks-worker-CloudWatchAgentServerPolicy,
    aws_iam_role_policy_attachment.eks-worker-AWSLoadBalancerControllerIAMPolicy,
    aws_iam_role_policy_attachment.notification-worker-policy,
    aws_iam_role_policy_attachment.eks-fargate-worker-AmazonEKSFargatePodExecutionRolePolicy,
    aws_iam_role_policy_attachment.notification-fargate-worker-policy
  ]

  tags = {
    Name       = "notification-canada-ca"
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

###
# AWS EKS Nodegroup configuration
###

resource "aws_eks_node_group" "notification-canada-ca-eks-node-group" {
  cluster_name         = aws_eks_cluster.notification-canada-ca-eks-cluster.name
  node_group_name      = "notification-canada-ca-${var.env}-eks-primary-node-group"
  node_role_arn        = aws_iam_role.eks-worker-role.arn
  subnet_ids           = var.vpc_private_subnets
  force_update_version = var.force_upgrade

  disk_size = 80

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
    Name                     = "notification-canada-ca"
    CostCenter               = "notification-canada-ca-${var.env}"
    "karpenter.sh/discovery" = aws_eks_cluster.notification-canada-ca-eks-cluster.name
  }
}

resource "aws_eks_node_group" "notification-canada-ca-eks-secondary-node-group" {
  count                = var.node_upgrade ? 1 : 0
  cluster_name         = aws_eks_cluster.notification-canada-ca-eks-cluster.name
  node_group_name      = "notification-canada-ca-${var.env}-eks-secondary-node-group"
  node_role_arn        = aws_iam_role.eks-worker-role.arn
  subnet_ids           = var.vpc_private_subnets
  force_update_version = var.force_upgrade

  disk_size = 80

  release_version = var.eks_node_ami_version
  instance_types  = var.secondary_worker_instance_types

  scaling_config {
    # Since we are just using this node group as an interim group while we upgrade primary, 
    # we will leverage primary settings here.
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
    Name                     = "notification-canada-ca"
    CostCenter               = "notification-canada-ca-${var.env}"
    "karpenter.sh/discovery" = aws_eks_cluster.notification-canada-ca-eks-cluster.name
  }
}

###
# AWS EKS addons
###

resource "aws_eks_addon" "coredns" {
  cluster_name                = aws_eks_cluster.notification-canada-ca-eks-cluster.name
  addon_name                  = "coredns"
  addon_version               = var.eks_addon_coredns_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  configuration_values = jsonencode({
    corefile = <<-EOF
      .:53 {
          errors
          health {
              lameduck 5s
            }
          ready
          kubernetes cluster.local in-addr.arpa ip6.arpa {
            pods insecure
            fallthrough in-addr.arpa ip6.arpa
          }
          prometheus :9153
          forward . /etc/resolv.conf
          cache 60
          loop
          reload
          loadbalance
      }
      EOF
    "nodeSelector" : {
      "eks.amazonaws.com/capacityType" : "ON_DEMAND"
    }
  })
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name                = aws_eks_cluster.notification-canada-ca-eks-cluster.name
  addon_name                  = "kube-proxy"
  addon_version               = var.eks_addon_kube_proxy_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name                = aws_eks_cluster.notification-canada-ca-eks-cluster.name
  addon_name                  = "vpc-cni"
  addon_version               = var.eks_addon_vpc_cni_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}

resource "aws_eks_addon" "ebs_driver" {
  cluster_name                = aws_eks_cluster.notification-canada-ca-eks-cluster.name
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = var.eks_addon_ebs_driver_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
}
