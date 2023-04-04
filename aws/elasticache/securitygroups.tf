#
# Security group used by resources that need to access the cluster
# in Staging only such as the lambda admin PR review environment.
#
resource "aws_security_group" "redis_cluster" {
  count       = var.env == "staging" ? 1 : 0
  name        = "redis-cluster"
  description = "Access to the Redis cluster"
  vpc_id      = var.vpc_id

  tags = {
    CostCentre = "notification-canada-ca-${var.env}"
    Terraform  = true
  }
}
