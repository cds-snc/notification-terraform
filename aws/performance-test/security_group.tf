resource "aws_security_group_rule" "perftest-egress-internet" {
  description       = "Egress to the internet from perftest"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = var.perf_test_security_group_id
}

# Connect perf test to the vpc private endpoint security group

resource "aws_security_group_rule" "notification-worker-egress-private-endpoints" {
  description              = "Internal egress to VPC PrivateLink endpoints from perftest"
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = var.private-links-vpc-endpoints-securitygroup
  security_group_id        = var.perf_test_security_group_id
}

resource "aws_security_group_rule" "private-endpoints-ingress-perf-test" {
  description              = "VPC PrivateLink endpoints ingress from perftest"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = var.perf_test_security_group_id
  security_group_id        = var.private-links-vpc-endpoints-securitygroup
}

resource "aws_security_group_rule" "perftest-egress-endpoints-gateway" {
  description       = "Security group rule for perftest to S3 gateway"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = var.perf_test_security_group_id
  prefix_list_ids   = var.private-links-gateway-prefix-list-ids
}
