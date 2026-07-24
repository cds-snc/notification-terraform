###
# AWS EKS Fargate Cluster configuration
# Note: This cluster is only created in the dev environment
###

resource "aws_cloudwatch_log_group" "notification-canada-ca-eks-fargate-cluster-logs" {
  provider          = aws.core_services
  count             = var.env == "dev" ? 1 : 0
  name              = "/aws/eks/${var.eks_cluster_name}-fargate/cluster"
  retention_in_days = var.log_retention_period_days
}

resource "aws_eks_cluster" "notification-canada-ca-eks-fargate-cluster" {
  provider = aws.core_services
  count    = var.env == "dev" ? 1 : 0
  name     = "${var.eks_cluster_name}-fargate"
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

  depends_on = [
    aws_cloudwatch_log_group.notification-canada-ca-eks-fargate-cluster-logs,
    aws_iam_role_policy_attachment.eks-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKSVPCResourceController,
    aws_iam_role_policy_attachment.eks-fargate-worker-AmazonEKSFargatePodExecutionRolePolicy,
    aws_iam_role_policy_attachment.notification-fargate-worker-policy,
  ]

  tags = {
    Name       = "notification-canada-ca-fargate"
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_security_group_rule" "vpn_k8s_api_access_fargate" {
  count             = var.env == "dev" ? 1 : 0
  description       = "Internal access to port 443 for private K8s API (Fargate cluster)"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  type              = "ingress"
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = aws_eks_cluster.notification-canada-ca-eks-fargate-cluster[0].vpc_config[0].cluster_security_group_id
}

resource "aws_security_group_rule" "eks-fargate-egress-private-endpoints" {
  provider                 = aws.core_services
  count                    = var.env == "dev" ? 1 : 0
  description              = "Internal egress to VPC PrivateLink endpoints from eks fargate securitygroup"
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = var.private-links-vpc-endpoints-securitygroup
  security_group_id        = aws_eks_cluster.notification-canada-ca-eks-fargate-cluster[0].vpc_config[0].cluster_security_group_id
}

resource "aws_security_group_rule" "private-endpoints-ingress-eks-fargate" {
  provider                 = aws.core_services
  count                    = var.env == "dev" ? 1 : 0
  description              = "VPC PrivateLink endpoints ingress from eks fargate securitygroup"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_eks_cluster.notification-canada-ca-eks-fargate-cluster[0].vpc_config[0].cluster_security_group_id
  security_group_id        = var.private-links-vpc-endpoints-securitygroup
}

resource "aws_security_group_rule" "eks-fargate-egress-endpoints-gateway" {
  provider          = aws.core_services
  count             = var.env == "dev" ? 1 : 0
  description       = "Security group rule for eks fargate securitygroup to S3 gateway"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_eks_cluster.notification-canada-ca-eks-fargate-cluster[0].vpc_config[0].cluster_security_group_id
  prefix_list_ids   = var.private-links-gateway-prefix-list-ids
}

###
# AWS EKS Fargate Profile configuration
###

resource "aws_eks_fargate_profile" "notification-canada-ca-fargate-profile" {
  provider               = aws.core_services
  count                  = var.env == "dev" ? 1 : 0
  cluster_name           = aws_eks_cluster.notification-canada-ca-eks-fargate-cluster[count.index].name
  fargate_profile_name   = "notification-canada-ca-${var.env}-fargate-profile"
  pod_execution_role_arn = aws_iam_role.eks-fargate-worker-role.arn
  subnet_ids             = var.vpc_private_subnets_k8s

  selector {
    namespace = "notification-canada-ca"
  }

  selector {
    namespace = "kube-system"
  }

  tags = {
    Name       = "notification-canada-ca-fargate"
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

###
# AWS EKS Fargate addons
###

resource "aws_eks_addon" "coredns_fargate" {
  provider                    = aws.core_services
  count                       = var.env == "dev" ? 1 : 0
  cluster_name                = aws_eks_cluster.notification-canada-ca-eks-fargate-cluster[0].name
  addon_name                  = "coredns"
  addon_version               = var.eks_addon_coredns_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  configuration_values = jsonencode({
    replicaCount = 2
    resources = {
      limits = {
        memory = "256Mi"
      }
      requests = {
        cpu    = "200m"
        memory = "128Mi"
      }
    }
    corefile = <<-EOF
      .:53 {
          errors
          log . notification {
              class denial
          }
          health {
              lameduck 5s
          }
          ready
          kubernetes cluster.local in-addr.arpa ip6.arpa {
              pods insecure
              fallthrough in-addr.arpa ip6.arpa
          }
          prometheus :9153
          forward . /etc/resolv.conf {
              except cluster.local
          }
          cache 60
          loop
          reload
          loadbalance
      }
      EOF
  })

  depends_on = [
    aws_eks_fargate_profile.notification-canada-ca-fargate-profile,
  ]
}

