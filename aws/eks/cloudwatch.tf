###
# AWS EKS Cloudwatch groups
###

resource "aws_cloudwatch_log_group" "notification-canada-ca-eks-cluster-logs" {
  name              = "/aws/eks/notification-canada-ca-${var.env}/cluster"
  retention_in_days = 7
}