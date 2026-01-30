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

  access_logs {
    bucket  = var.cbs_satellite_bucket_name
    prefix  = "lb_logs"
    enabled = true
  }

  enable_deletion_protection = var.enable_delete_protection
  idle_timeout               = var.env == "production" ? 60 : 120

  tags = {
    Name       = "notification-canada-ca"
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_alb_listener" "notification-canada-ca" {

  depends_on = [aws_acm_certificate_validation.notification-canada-ca, aws_acm_certificate_validation.notification-canada-ca-alt]

  load_balancer_arn = aws_alb.notification-canada-ca.id
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.notification-canada-ca.arn
  # See https://docs.aws.amazon.com/elasticloadbalancing/latest/network/create-tls-listener.html#describe-ssl-policies
  # And https://cyber.gc.ca/en/guidance/guidance-securely-configuring-network-protocols-itsp40062
  ssl_policy = "ELBSecurityPolicy-FS-1-2-Res-2019-08"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.notification-canada-ca-admin.arn
  }
}

resource "aws_lb_listener_certificate" "alt_domain_certificate" {
  depends_on      = [aws_acm_certificate.notification-canada-ca-alt]
  listener_arn    = aws_alb_listener.notification-canada-ca.arn
  certificate_arn = aws_acm_certificate.notification-canada-ca-alt[0].arn
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
    target_group_arn = aws_alb_target_group.notification-canada-ca-document-api.arn
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
  name                 = "notification-canada-ca-alb-api"
  port                 = 6011
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  target_type          = "ip"
  deregistration_delay = 30

  health_check {
    path    = "/_status?simple=true"
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
      values = ["api.*", "api-k8s.*"]
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
    path    = "/_status?simple=true"
    matcher = "200"
  }
}

###
# WWW to non-WWW
###

resource "aws_lb_listener_rule" "www-domain-host-route" {
  listener_arn = aws_alb_listener.notification-canada-ca.arn
  priority     = 50

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
      values = ["www.${var.domain}"]
    }
  }
}

###
# Documentation Specific Routing
###

resource "aws_alb_target_group" "notification-canada-ca-documentation" {
  name     = "notification-documentation"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path    = "/"
    matcher = "200"
  }
}

resource "aws_lb_listener_rule" "documentation-host-route" {
  listener_arn = aws_alb_listener.notification-canada-ca.arn
  priority     = 60

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.notification-canada-ca-documentation.arn
  }

  condition {
    host_header {
      values = ["documentation.*"]
    }
  }
}

resource "aws_lb_listener_rule" "documentation-host-redirect" {
  listener_arn = aws_alb_listener.notification-canada-ca.arn
  priority     = 70

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
      host        = "documentation.${var.domain}"
      path        = "/#{path}"
      query       = "#{query}"
    }
  }

  condition {
    host_header {
      values = ["doc.*"]
    }
  }
}

###
# WAF
###

resource "aws_wafv2_web_acl_association" "notification-canada-ca" {
  resource_arn = aws_alb.notification-canada-ca.arn
  web_acl_arn  = aws_wafv2_web_acl.notification-canada-ca.arn
}

