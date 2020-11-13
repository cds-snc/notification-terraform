resource "aws_shield_protection" "notification-canada-ca" {
  name         = "notification-canada-ca"
  resource_arn = aws_alb.notification-canada-ca.arn
}
