# Pinpoint resources are set up in us-west-2
# because we don't want dedicated long codes
# to be used when don't specify a phone number
# while sending SMS
resource "aws_pinpoint_app" "notification-canada-ca" {
  provider = aws.us-west-2
  name     = "notification-canada-ca-${var.env}"

  tags = {
    CostCentre = "notification-canada-ca-${var.env}"
    Terraform  = true
  }
}

resource "aws_pinpoint_sms_channel" "sms" {
  provider       = aws.us-west-2
  application_id = aws_pinpoint_app.notification-canada-ca.application_id
}
