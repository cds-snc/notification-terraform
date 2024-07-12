resource "aws_lb" "internal_alb" {
  name                       = "notify-${var.env}-internal-alb"
  internal                   = true
  load_balancer_type         = "application"
  drop_invalid_header_fields = true
  security_groups = [
    aws_security_group.notification_internal.id
  ]
  subnets = var.vpc_private_subnets

  access_logs {
    bucket  = "cbs-satellite-${var.account_id}"
    prefix  = "inernal_lb_logs"
    enabled = true
  }

  enable_deletion_protection = var.enable_delete_protection

  tags = {
    Name       = "notification-canada-ca"
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_alb_listener" "internal_alb_tls" {

  load_balancer_arn = aws_lb.internal_alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = var.internal_dns_certificate_arn
  # See https://docs.aws.amazon.com/elasticloadbalancing/latest/network/create-tls-listener.html#describe-ssl-policies
  # And https://cyber.gc.ca/en/guidance/guidance-securely-configuring-network-protocols-itsp40062
  ssl_policy = "ELBSecurityPolicy-FS-1-2-Res-2019-08"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.internal_nginx_http.arn
  }
}

resource "aws_lb_listener" "internal_alb-80" {
  load_balancer_arn = aws_lb.internal_alb.id
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

resource "aws_alb_target_group" "internal_nginx_http" {
  name        = "notification-internal-nginx-http"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    protocol = "HTTP"
    path     = "/"
    matcher  = "404"
  }
}