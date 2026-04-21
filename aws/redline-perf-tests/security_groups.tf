###
# Security Groups — Locust master and workers
###

###
# Master security group
# - Accepts worker connections on port 5557 (Locust master-worker protocol)
# - Outbound HTTPS to reach the target system, ECR, and CloudWatch
###
resource "aws_security_group" "locust_master" {
  name        = "locust-redline-master"
  description = "Locust master: accepts worker connections and coordinates the run"
  vpc_id      = aws_vpc.locust.id

  tags = {
    Name                  = "locust-redline-master-sg"
    (var.billing_tag_key) = var.billing_tag_value
  }
}

# Workers → master: Locust distributed protocol
resource "aws_security_group_rule" "master_ingress_workers" {
  description              = "Allow Locust workers to connect to master"
  type                     = "ingress"
  from_port                = 5557
  to_port                  = 5557
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.locust_worker.id
  security_group_id        = aws_security_group.locust_master.id
}

# Outbound HTTPS — target system, ECR, CloudWatch (all via NAT or public IP)
resource "aws_security_group_rule" "master_egress_https" {
  description       = "Outbound HTTPS from master"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.locust_master.id
}

# Outbound HTTP — some targets may redirect or respond on port 80
resource "aws_security_group_rule" "master_egress_http" {
  description       = "Outbound HTTP from master"
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.locust_master.id
}

###
# Worker security group
# - Connects out to master on port 5557
# - Outbound HTTPS/HTTP to reach the target system
###
resource "aws_security_group" "locust_worker" {
  name        = "locust-redline-worker"
  description = "Locust workers: connect to master and generate traffic to target"
  vpc_id      = aws_vpc.locust.id

  tags = {
    Name                  = "locust-redline-worker-sg"
    (var.billing_tag_key) = var.billing_tag_value
  }
}

# Workers → master: Locust distributed protocol
resource "aws_security_group_rule" "worker_egress_master" {
  description              = "Allow Locust workers to connect to master"
  type                     = "egress"
  from_port                = 5557
  to_port                  = 5557
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.locust_master.id
  security_group_id        = aws_security_group.locust_worker.id
}

# Outbound HTTPS — target system, ECR, CloudWatch
resource "aws_security_group_rule" "worker_egress_https" {
  description       = "Outbound HTTPS from workers"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.locust_worker.id
}

# Outbound HTTP
resource "aws_security_group_rule" "worker_egress_http" {
  description       = "Outbound HTTP from workers"
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.locust_worker.id
}
