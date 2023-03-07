#
# Security group used by the lambda admin PR review environment communication
# with the Redis cluster.  It is only created in Staging.
#
resource "aws_security_group" "lambda_admin_pr_review" {
  count       = var.env == "staging" ? 1 : 0
  name        = "lambda-admin-pr-review"
  description = "Lambda admin PR review environment and Redis communication"
  vpc_id      = var.vpc_id

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_security_group_rule" "cluster_ingress_from_lambda" {
  count             = var.env == "staging" ? 1 : 0
  description       = "Allow inbound connections to cluster from the lambda admin PR review environment"
  type              = "ingress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.lambda_admin_pr_review[0].id
}

resource "aws_security_group_rule" "lambda_egress_to_cluster" {
  count             = var.env == "staging" ? 1 : 0
  description       = "Allow outbound connections from the lambda admin PR review environment to the cluster"
  type              = "egress"
  from_port         = 6379
  to_port           = 6379
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.lambda_admin_pr_review[0].id
}
