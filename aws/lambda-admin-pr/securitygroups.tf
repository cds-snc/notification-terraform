#
# Security group allowing the lambda admin PR review environment to communicate
# with the Redis cluster, VPC private endpoints and recieve HTTPS requests.
#
resource "aws_security_group" "lambda_admin_pr_review" {
  count       = var.env == "staging" ? 1 : 0
  name        = "lambda-admin-pr-review"
  description = "Lambda admin PR review environment"
  vpc_id      = var.vpc_id

  tags = {
    CostCentre = "notification-canada-ca-${var.env}"
  }
}

resource "aws_security_group_rule" "cluster_ingress_from_lambda" {
  count                    = var.env == "staging" ? 1 : 0
  description              = "Allow inbound connections to cluster from the lambda admin PR review env"
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lambda_admin_pr_review[0].id
  security_group_id        = var.redis_cluster_security_group_id
}

resource "aws_security_group_rule" "lambda_egress_to_cluster" {
  count                    = var.env == "staging" ? 1 : 0
  description              = "Allow outbound connections from the lambda admin PR review env to the cluster"
  type                     = "egress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = var.redis_cluster_security_group_id
  security_group_id        = aws_security_group.lambda_admin_pr_review[0].id
}

resource "aws_security_group_rule" "lambda_egress_to_vpc_interface_endpoints" {
  count                    = var.env == "staging" ? 1 : 0
  description              = "Allow outbound connection from the lambda admin PR review env to the VPC private interface endpoints"
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = var.vpc_endpoint_security_group_id
  security_group_id        = aws_security_group.lambda_admin_pr_review[0].id
}

resource "aws_security_group_rule" "vpc_endpoints_ingress_from_lambda" {
  count                    = var.env == "staging" ? 1 : 0
  description              = "Allow inbound connections to VPC private endpoints from the lambda admin PR review env"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.lambda_admin_pr_review[0].id
  security_group_id        = var.vpc_endpoint_security_group_id
}

resource "aws_security_group_rule" "lambda_egress_to_vpc_gateway_endpoints" {
  count             = var.env == "staging" ? 1 : 0
  description       = "Allow outbound connection from the lambda admin PR review env to the VPC gateway endpoints"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.lambda_admin_pr_review[0].id
  prefix_list_ids   = var.vpc_endpoint_gateway_prefix_list_ids
}

resource "aws_security_group_rule" "internet_ingress_to_lambda" {
  count             = var.env == "staging" ? 1 : 0
  description       = "Allow inbound connections from the internet to the lambda admin PR review env"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.lambda_admin_pr_review[0].id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "lambda_egress_to_internet" {
  count             = var.env == "staging" ? 1 : 0
  description       = "Allow outbound connections from lambda admin PR review env to the internet"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.lambda_admin_pr_review[0].id
  cidr_blocks       = ["0.0.0.0/0"]
}
