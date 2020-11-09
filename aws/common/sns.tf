resource "aws_sns_topic" "notification-canada-ca-ses-callback" {
  name = "ses-callback"
  kms_master_key_id = aws_kms_key.notification-canada-ca.arn

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_sns_topic" "notification-canada-ca-sms-callback" {
  name = "sms-callback"
  kms_master_key_id = aws_kms_key.notification-canada-ca.arn

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_sns_topic" "notification-canada-ca-alert-warning" {
  name = "alert-warning"
  kms_master_key_id = aws_kms_key.notification-canada-ca.arn

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_sns_topic" "notification-canada-ca-alert-critical" {
  name = "alert-critical"
  kms_master_key_id = aws_kms_key.notification-canada-ca.arn

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}