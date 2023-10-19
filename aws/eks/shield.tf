resource "aws_shield_protection" "notification-canada-ca" {
  depends_on   = [null_resource.aws_shield_subscription]
  name         = "notification-canada-ca"
  resource_arn = aws_alb.notification-canada-ca.arn
}

resource "aws_shield_protection" "assets-notification-canada-ca" {
  depends_on   = [null_resource.aws_shield_subscription]
  name         = "notification-canada-ca"
  resource_arn = var.cloudfront_assets_arn
}


resource "null_resource" "aws_shield_subscription" {
  provisioner "local-exec" {
    command = "aws shield create-subscription 2> /dev/null || true"
  }
}