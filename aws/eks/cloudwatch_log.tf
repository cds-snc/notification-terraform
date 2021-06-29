###
# AWS EKS Cloudwatch groups
###

resource "aws_cloudwatch_log_group" "notification-canada-ca-eks-cluster-logs" {
  name              = "/aws/eks/${var.eks_cluster_name}/cluster"
  retention_in_days = 14
}

###
# AWS EKS Cloudwatch log metric filters
###
resource "aws_cloudwatch_log_metric_filter" "web-500-errors" {
  name           = "web-500-errors"
  pattern        = "\"\\\" 500 \""
  log_group_name = local.eks_application_log_group

  metric_transformation {
    name      = "500-errors"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "celery-error" {
  name           = "celery-error"
  pattern        = "?\"ERROR/Worker\" ?\"ERROR/ForkPoolWorker\" ?\"WorkerLostError\""
  log_group_name = local.eks_application_log_group

  metric_transformation {
    name      = "celery-error"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_metric_filter" "platform-admin-looking-at-sensitive-service" {

  name = "platform-admin-looking-at-sensitive-service"
  # The UUIDv4 is a Notify service ID we are interested in
  pattern        = "\"Admin API request\" \"432cb269-7c85-4e38-8e42-3828ec7e5799\""
  log_group_name = local.eks_application_log_group

  metric_transformation {
    name          = "platform-admin-looking-at-sensitive-service"
    namespace     = "LogMetrics"
    value         = "1"
    default_value = "0"
  }
}
