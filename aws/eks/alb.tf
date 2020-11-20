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
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.aws_acm_notification_canada_ca_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.notification-canada-ca-admin.arn
  }
}

resource "aws_lb_listener_certificate" "alt_domain_certificate" {
  count           = var.aws_acm_alt_notification_canada_ca_arn != "" ? 1 : 0
  listener_arn    = aws_alb_listener.notification-canada-ca.arn
  certificate_arn = var.aws_acm_alt_notification_canada_ca_arn
}

resource "aws_lb_listener" "notification-canada-ca-80" {
  load_balancer_arn = aws_alb.notification-canada-ca.id
  port              = 80 #tfsec:ignore:AWS004
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

###
# Document API Specific routing
###

resource "aws_alb_target_group" "notification-canada-ca-document-api" {
  name     = "notification-document-api"
  port     = 7000
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path    = "/_status"
    matcher = "200"
  }
}

resource "aws_lb_listener_rule" "alt-domain-document-api-host-route" {
  count        = var.alt_domain != "" ? 1 : 0
  listener_arn = aws_alb_listener.notification-canada-ca.arn
  priority     = 10

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
      host        = "api.document.${var.domain}"
      path        = "/#{path}"
      query       = "#{query}"
    }
  }

  condition {
    host_header {
      values = ["api.document.${var.alt_domain}"]
    }
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
      values = ["api.document.*"]
    }
  }
}

###
# Document Specific routing
###

resource "aws_alb_target_group" "notification-canada-ca-document" {
  name     = "notification-alb-document"
  port     = 7001
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path    = "/_status"
    matcher = "200"
  }
}

resource "aws_lb_listener_rule" "alt-domain-document-host-route" {
  count        = var.alt_domain != "" ? 1 : 0
  listener_arn = aws_alb_listener.notification-canada-ca.arn
  priority     = 20

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
      host        = "document.${var.domain}"
      path        = "/#{path}"
      query       = "#{query}"
    }
  }

  condition {
    host_header {
      values = ["document.${var.alt_domain}"]
    }
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
    path    = "/_status"
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

resource "aws_lb_listener_rule" "alt-domain-host-route" {
  count        = var.alt_domain != "" ? 1 : 0
  listener_arn = aws_alb_listener.notification-canada-ca.arn
  priority     = 40

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
      host        = var.domain
      path        = "/#{path}"
      query       = "#{query}"
    }
  }

  condition {
    host_header {
      values = [var.alt_domain]
    }
  }
}

resource "aws_alb_target_group" "notification-canada-ca-admin" {
  name     = "notification-canada-ca-alb-admin"
  port     = 6012
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path    = "/_status"
    matcher = "200"
  }
}


###
# WAF
###

resource "aws_wafv2_web_acl_association" "notification-canada-ca" {
  resource_arn = aws_alb.notification-canada-ca.arn
  web_acl_arn  = aws_wafv2_web_acl.notification-canada-ca.arn
}
