resource "aws_shield_protection" "notification-canada-ca" {
  name         = "notification-canada-ca"
  resource_arn = aws_alb.notification-canada-ca.arn
}

resource "aws_shield_protection" "assets-notification-canada-ca" {
  name         = "notification-canada-ca"
  resource_arn = var.cloudfront_assets_arn
}
