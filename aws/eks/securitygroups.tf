###
# AWS ALB Security Group
###

resource "aws_security_group" "notification-canada-ca-alb" {
  name        = "notification-canada-ca-alb"
  description = "Ingress - Application load balancer"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:AWS008
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:AWS008
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

###
# Notification Worker Security Group
###

resource "aws_security_group" "notification-canada-ca-worker" {
  name        = "notification-canada-ca-worker"
  description = "ALB to Worker communication"
  vpc_id      = var.vpc_id

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}
