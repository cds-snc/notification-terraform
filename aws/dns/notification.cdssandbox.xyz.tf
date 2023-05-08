resource "aws_route53_zone" "notification-sandbox" {
  count = var.env == "staging" ? 1 : 0
  name  = "notification.cdssandbox.xyz"
}