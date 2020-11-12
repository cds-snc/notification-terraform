###
# AWS ALB configuration
###

resource "aws_alb" "notification-canada-ca" {
  name               = "notification-${var.env}-alb"
  internal           = false #tfsec:ignore:AWS005
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.notification-canada-ca-alb.id,
    aws_eks_cluster.notification-canada-ca-eks-cluster.vpc_config[0].cluster_security_group_id
  ]
  subnets = var.vpc_public_subnets

  tags = {
    Name       = "notification-canada-ca"
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_alb_listener" "notification-canada-ca" {
  load_balancer_arn = aws_alb.notification-canada-ca.id
  port              = 80 #tfsec:ignore:AWS004
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not found"
      status_code  = "404"
    }
  }
}

###
# Document API Specific routing
###

resource "aws_alb_target_group" "notification-canada-ca-document-api" {
  name     = "notification-canada-ca-alb-document-api"
  port     = 7000
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path    = "/"
    matcher = "200"
  }
}

resource "aws_lb_listener_rule" "document-api-host-route" {
  listener_arn = aws_alb_listener.notification-canada-ca.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.notification-canada-ca-document-api.arn
  }

  condition {
    host_header {
      values = ["document.api.*"]
    }
  }
}

###
# Document Specific routing
###

resource "aws_alb_target_group" "notification-canada-ca-document" {
  name     = "notification-canada-ca-alb-document"
  port     = 7001
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path    = "/"
    matcher = "200"
  }
}

resource "aws_lb_listener_rule" "document-host-route" {
  listener_arn = aws_alb_listener.notification-canada-ca.arn
  priority     = 200

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.notification-canada-ca-document.arn
  }

  condition {
    host_header {
      values = ["document.*"]
    }
  }
}

###
# API Specific routing
###

resource "aws_alb_target_group" "notification-canada-ca-api" {
  name     = "notification-canada-ca-alb-api"
  port     = 6011
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path    = "/"
    matcher = "200"
  }
}

resource "aws_lb_listener_rule" "api-host-route" {
  listener_arn = aws_alb_listener.notification-canada-ca.arn
  priority     = 300

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.notification-canada-ca-api.arn
  }

  condition {
    host_header {
      values = ["api.*"]
    }
  }
}

###
# Admin Specific routing
###

resource "aws_alb_target_group" "notification-canada-ca-admin" {
  name     = "notification-canada-ca-alb-admin"
  port     = 6012
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path    = "/"
    matcher = "200"
  }
}

resource "aws_lb_listener_rule" "admin-host-route" {
  listener_arn = aws_alb_listener.notification-canada-ca.arn
  priority     = 400

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.notification-canada-ca-admin.arn
  }

  condition {
    host_header {
      values = ["*"]
    }
  }
}