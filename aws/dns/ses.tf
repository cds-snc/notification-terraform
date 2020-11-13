resource "aws_ses_domain_identity" "notification-canada-ca" {
  domain = var.domain
}

resource "aws_ses_domain_dkim" "notification-canada-ca" {
  domain = var.domain
}

resource "aws_ses_identity_notification_topic" "notification-canada-ca-bounce-topic" {
  topic_arn                = var.notification_canada_ca_ses_callback_arn
  notification_type        = "Bounce"
  identity                 = aws_ses_domain_identity.notification-canada-ca.domain
  include_original_headers = false
}

resource "aws_ses_identity_notification_topic" "notification-canada-ca-delivery-topic" {
  topic_arn                = var.notification_canada_ca_ses_callback_arn
  notification_type        = "Delivery"
  identity                 = aws_ses_domain_identity.notification-canada-ca.domain
  include_original_headers = false
}

resource "aws_ses_identity_notification_topic" "notification-canada-ca-complaint-topic" {
  topic_arn                = var.notification_canada_ca_ses_callback_arn
  notification_type        = "Complaint"
  identity                 = aws_ses_domain_identity.notification-canada-ca.domain
  include_original_headers = false
}