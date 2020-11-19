###
# AWS EKS Cloudwatch groups
###

resource "aws_cloudwatch_log_group" "notification-canada-ca-eks-cluster-logs" {
  name              = "/aws/eks/notification-canada-ca-${var.env}/cluster"
  retention_in_days = 7
}

###
# AWS EKS Cloudwatch log metric filters
###
resource "aws_cloudwatch_log_metric_filter" "web-500-errors" {
  name           = "web-500-errors"
  pattern        = "\"\\\" 500 \""
  log_group_name = "/aws/containerinsights/${aws_eks_cluster.notification-canada-ca-eks-cluster.name}/application"

  metric_transformation {
    name      = "500-errors"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "celery-error" {
  name           = "celery-error"
  pattern        = "\"ERROR/Worker\""
  log_group_name = "/aws/containerinsights/${aws_eks_cluster.notification-canada-ca-eks-cluster.name}/application"

  metric_transformation {
    name      = "celery-error"
    namespace = "LogMetrics"
    value     = "1"
  }
}
