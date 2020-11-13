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