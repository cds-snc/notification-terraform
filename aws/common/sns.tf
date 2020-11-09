resource "aws_sns_topic" "notification-canada-ca-ses-callback" {
  name              = "ses-callback"
  kms_master_key_id = aws_kms_key.notification-canada-ca.arn

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_sns_topic" "notification-canada-ca-alert-warning" {
  name              = "alert-warning"
  kms_master_key_id = aws_kms_key.notification-canada-ca.arn

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_sns_topic" "notification-canada-ca-alert-critical" {
  name              = "alert-critical"
  kms_master_key_id = aws_kms_key.notification-canada-ca.arn

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_sns_sms_preferences" "update-sms-prefs" {
  delivery_status_iam_role_arn          = aws_iam_role.sns-delivery-role.arn
  delivery_status_success_sampling_rate = 100
  monthly_spend_limit                   = 1000
}