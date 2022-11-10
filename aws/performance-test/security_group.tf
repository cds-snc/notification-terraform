resource "aws_security_group" "perf_test" {
  name        = "perf_test"
  description = "Performance Test Security Group"
  vpc_id      = var.vpc_id

  egress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    # We need to connect to the staging api server (not managed in terraform)
    # tfsec:ignore:AWS009
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Connect perf test to the vpc private endpoint security group

resource "aws_security_group_rule" "notification-worker-egress-private-endpoints" {
  description              = "Internal egress to VPC PrivateLink endpoints from perftest"
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = var.private-links-vpc-endpoints-securitygroup
  security_group_id        = aws_security_group.perf_test.id
}

resource "aws_security_group_rule" "private-endpoints-ingress-perf-test" {
  description              = "VPC PrivateLink endpoints ingress from perftest"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.perf_test.id
  security_group_id        = var.private-links-vpc-endpoints-securitygroup
}

resource "aws_security_group_rule" "perftest-egress-endpoints-gateway" {
  for_each = toset(var.private-links-gateway)

  description       = "Security group rule for perftest to S3 gateway"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.perf_test.id
  prefix_list_ids = [
    each.value.prefix_list_id
  ]
}
