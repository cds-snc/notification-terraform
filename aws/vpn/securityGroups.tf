# Client VPN access

resource "aws_security_group_rule" "client-vpn-ingress-database" {
  description              = "Client VPN ingress to the database"
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = module.vpn.client_vpn_security_group_id
  security_group_id        = var.eks_securitygroup_rds
}

resource "aws_security_group_rule" "client-vpn-ingress-redis" {
  description              = "Client VPN ingress to the redis cluster"
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = module.vpn.client_vpn_security_group_id
  security_group_id        = var.eks_securitygroup_rds
}

resource "aws_security_group_rule" "vpn_k8s_api_access" {
  description       = "Internal access to port 443 for private K8s API"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  type              = "ingress"
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = var.eks_cluster_securitygroup_id
}
