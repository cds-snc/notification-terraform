###
# AWS EKS IAM cluster roles
###



resource "aws_iam_role" "eks-cluster-role" {
  name = "eks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster-role.name
}

# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "eks-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks-cluster-role.name
}


###
# AWS EKS IAM worker role
###

resource "aws_iam_role" "eks-worker-role" {
  name = "eks-worker-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks-worker-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-worker-role.name
}

resource "aws_iam_role_policy_attachment" "eks-worker-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-worker-role.name
}

resource "aws_iam_role_policy_attachment" "eks-worker-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-worker-role.name
}

# Reference: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-prerequisites.html
resource "aws_iam_role_policy_attachment" "eks-worker-CloudWatchAgentServerPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.eks-worker-role.name
}

# Reference: https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html
resource "aws_iam_policy" "ALB-eks-controller-policy" {
  name   = "AWSLoadBalancerControllerIAMPolicy"
  policy = file("alb_iam_policy.json")
}

resource "aws_iam_role_policy_attachment" "eks-worker-AWSLoadBalancerControllerIAMPolicy" {
  policy_arn = aws_iam_policy.ALB-eks-controller-policy.arn
  role       = aws_iam_role.eks-worker-role.name
}

###
# Application level policies
###

resource "aws_iam_policy" "notification-worker-policy" {
  name        = "notification-worker-policy"
  description = "Permissions for a notification worker"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "mobiletargeting:*",
        "ses:SendEmail",
        "ses:SendRawEmail",
        "sqs:*",
        "sns:Publish",
        "sms-voice:SendTextMessage",
        "securityhub:BatchImportFindings",
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "notification-worker-policy" {
  policy_arn = aws_iam_policy.notification-worker-policy.arn
  role       = aws_iam_role.eks-worker-role.name
}

###
# AWS Fargate IAM worker role
###

resource "aws_iam_role" "eks-fargate-worker-role" {
  name = "eks-fargate-worker-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks-fargate-pods.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Reference: https://docs.aws.amazon.com/eks/latest/userguide/pod-execution-role.html
resource "aws_iam_role_policy_attachment" "eks-fargate-worker-AmazonEKSFargatePodExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.eks-worker-role.name
}

resource "aws_iam_role_policy_attachment" "notification-fargate-worker-policy" {
  policy_arn = aws_iam_policy.notification-worker-policy.arn
  role       = aws_iam_role.eks-fargate-worker-role.name
}



###
# AWS EKS Service account
###

data "tls_certificate" "notification-canada-ca" {
  url = aws_eks_cluster.notification-canada-ca-eks-cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "notification-canada-ca" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.notification-canada-ca.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.notification-canada-ca-eks-cluster.identity[0].oidc[0].issuer
}

data "aws_iam_policy_document" "eks-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.notification-canada-ca.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:notification-canada-ca:notification-service-account"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.notification-canada-ca.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "notification-service-account-role" {
  assume_role_policy = data.aws_iam_policy_document.eks-assume-role-policy.json
  name               = "notification-service-account-role"
}

resource "aws_iam_role_policy_attachment" "notification-service-worker-policy" {
  policy_arn = aws_iam_policy.notification-worker-policy.arn
  role       = aws_iam_role.notification-service-account-role.name
}

###
# Karpenter IAM
###

data "aws_eks_cluster" "notify_cluster" {
  # This is required for fetching the oidc provider
  name       = var.eks_cluster_name
  depends_on = [aws_eks_cluster.notification-canada-ca-eks-cluster]
}

data "aws_iam_policy" "ssm_managed_instance" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


module "iam_assumable_role_karpenter" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "5.28.0"
  create_role                   = true
  role_name                     = "karpenter-controller-eks"
  provider_url                  = data.aws_eks_cluster.notify_cluster.identity[0].oidc[0].issuer
  oidc_fully_qualified_subjects = ["system:serviceaccount:karpenter:karpenter"]
}

resource "aws_iam_instance_profile" "karpenter" {
  name = "KarpenterNodeInstanceProfile-karpenter-controller-eks"
  role = aws_iam_role.eks-worker-role.name
}

resource "aws_iam_role_policy_attachment" "karpenter_ssm_policy" {
  role       = aws_iam_role.eks-worker-role.name
  policy_arn = data.aws_iam_policy.ssm_managed_instance.arn
}

resource "aws_iam_role_policy_attachment" "ebs_csi_policy" {
  role       = aws_iam_role.eks-worker-role.name
  policy_arn = aws_iam_policy.ebs_driver.arn
}

resource "aws_iam_role_policy_attachment" "karpenter-cluster-worker-node" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = module.iam_assumable_role_karpenter.iam_role_name
}
resource "aws_iam_role_policy_attachment" "karpenter-cluster-cni" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = module.iam_assumable_role_karpenter.iam_role_name
}
resource "aws_iam_role_policy_attachment" "karpenter-cluster-ecr" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = module.iam_assumable_role_karpenter.iam_role_name
}
resource "aws_iam_role_policy_attachment" "karpenter-cluster-managed-instance-core" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = module.iam_assumable_role_karpenter.iam_role_name
}

resource "aws_iam_role_policy" "karpenter_controller" {
  #checkov:skip=CKV_AWS_290:The Karpenter IAM requires blanket access
  #checkov:skip=CKV_AWS_286:The Karpenter IAM requires privilege escalation
  #checkov:skip=CKV_AWS_289:The Karpenter IAM requires wide scale permissions management
  #checkov:skip=CKV_AWS_355:The Karpenter IAM requires blanket access
  #checkov:skip=CKV_AWS_288:The Karpenter IAM requires the ability to read pricing info
  name = "karpenter-policy-${var.eks_cluster_name}"
  role = module.iam_assumable_role_karpenter.iam_role_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:GetParameter",
          "iam:PassRole",
          "iam:GetInstanceProfile",
          "iam:CreateInstanceProfile",
          "iam:TagInstanceProfile",
          "iam:AddRoleToInstanceProfile",
          "ec2:DescribeImages",
          "ec2:RunInstances",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeLaunchTemplates",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInstanceTypeOfferings",
          "ec2:DescribeAvailabilityZones",
          "ec2:DeleteLaunchTemplate",
          "ec2:CreateTags",
          "ec2:CreateLaunchTemplate",
          "ec2:CreateFleet",
          "ec2:TerminateInstances",
          "ec2:DescribeSpotPriceHistory",
          "pricing:GetProducts"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

###
# EKS EBS IAM
###


#checkov:skip=CKV_AWS_290:The EKS worker IAM requires the ability to create EBS
#checkov:skip=CKV_AWS_355:The EKS worker IAM requires the ability to create EBS
resource "aws_iam_policy" "ebs_driver" {

  name   = "eks-ebs-csi-driver-${var.eks_cluster_name}"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateSnapshot",
        "ec2:AttachVolume",
        "ec2:DetachVolume",
        "ec2:ModifyVolume",
        "ec2:DescribeAvailabilityZones",
        "ec2:DescribeInstances",
        "ec2:DescribeSnapshots",
        "ec2:DescribeTags",
        "ec2:DescribeVolumes",
        "ec2:DescribeVolumesModifications"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateTags"
      ],
      "Resource": [
        "arn:aws:ec2:*:*:volume/*",
        "arn:aws:ec2:*:*:snapshot/*"
      ],
      "Condition": {
        "StringEquals": {
          "ec2:CreateAction": [
            "CreateVolume",
            "CreateSnapshot"
          ]
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DeleteTags"
      ],
      "Resource": [
        "arn:aws:ec2:*:*:volume/*",
        "arn:aws:ec2:*:*:snapshot/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateVolume"
      ],
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "aws:RequestTag/ebs.csi.aws.com/cluster": "true"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateVolume"
      ],
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "aws:RequestTag/CSIVolumeName": "*"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DeleteVolume"
      ],
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "ec2:ResourceTag/ebs.csi.aws.com/cluster": "true"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DeleteVolume"
      ],
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "ec2:ResourceTag/CSIVolumeName": "*"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DeleteVolume"
      ],
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "ec2:ResourceTag/kubernetes.io/created-for/pvc/name": "*"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DeleteSnapshot"
      ],
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "ec2:ResourceTag/CSIVolumeSnapshotName": "*"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DeleteSnapshot"
      ],
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "ec2:ResourceTag/ebs.csi.aws.com/cluster": "true"
        }
      }
    }
  ]
}
POLICY
}

#XRAY IAM
resource "aws_iam_role" "nodes_k8s_role" {
  name = "nodes.k8s.cluster.${var.env}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "nodes_k8s_instance_profile" {
  name = "nodes.k8s.cluster.${var.env}"
  role = aws_iam_role.nodes_k8s_role.name
}

resource "aws_iam_policy" "xray_policy" {
  name        = "XRayPolicy"
  description = "Policy to allow XRay tracing"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "xray:PutTraceSegments",
          "xray:PutTelemetryRecords"
        ]
        Resource = [
          "arn:aws:iam::${var.account_id}:instance-profile/nodes.k8s.cluster.${var.env}"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_xray_policy" {
  role       = aws_iam_role.eks-worker-role.name
  policy_arn = aws_iam_policy.xray_policy.arn
}