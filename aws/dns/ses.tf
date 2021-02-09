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

resource "aws_ses_domain_mail_from" "notification-canada-ca" {
  domain           = aws_ses_domain_identity.notification-canada-ca.domain
  mail_from_domain = "bounce.${aws_ses_domain_identity.notification-canada-ca.domain}"
}

###
# Receiving emails
###

resource "aws_ses_domain_identity" "notification-canada-ca-receiving" {
  # Email receiving with SES is available in only 3 regions
  # so we use us-east-1
  # https://docs.aws.amazon.com/general/latest/gr/ses.html
  provider = aws.us-east-1

  domain = var.domain
}

resource "aws_ses_receipt_rule_set" "main" {
  provider = aws.us-east-1

  rule_set_name = "main"
}

resource "aws_ses_receipt_rule" "inbound-to-lambda" {
  provider = aws.us-east-1

  name          = "inbound-to-lambda"
  rule_set_name = aws_ses_receipt_rule_set.main.rule_set_name
  recipients    = [var.domain]
  enabled       = true
  scan_enabled  = true

  lambda_action {
    function_arn    = var.lambda_ses_receiving_emails_arn
    invocation_type = "Event"
    position        = 1
  }
}

###
# Additional sending domains
###

resource "aws_ses_domain_identity" "cic-trvapply-vrtdemande" {
  count  = var.env == "production" ? 1 : 0
  domain = "trvapply-vrtdemande.apps.cic.gc.ca"
}

resource "aws_ses_domain_dkim" "cic-trvapply-vrtdemande" {
  count  = var.env == "production" ? 1 : 0
  domain = "trvapply-vrtdemande.apps.cic.gc.ca"
}

resource "aws_ses_identity_notification_topic" "cic-trvapply-vrtdemande-bounce-topic" {
  count                    = var.env == "production" ? 1 : 0
  topic_arn                = var.notification_canada_ca_ses_callback_arn
  notification_type        = "Bounce"
  identity                 = aws_ses_domain_identity.cic-trvapply-vrtdemande[0].domain
  include_original_headers = false
}

resource "aws_ses_identity_notification_topic" "cic-trvapply-vrtdemande-delivery-topic" {
  count                    = var.env == "production" ? 1 : 0
  topic_arn                = var.notification_canada_ca_ses_callback_arn
  notification_type        = "Delivery"
  identity                 = aws_ses_domain_identity.cic-trvapply-vrtdemande[0].domain
  include_original_headers = false
}

resource "aws_ses_identity_notification_topic" "cic-trvapply-vrtdemande-complaint-topic" {
  count                    = var.env == "production" ? 1 : 0
  topic_arn                = var.notification_canada_ca_ses_callback_arn
  notification_type        = "Complaint"
  identity                 = aws_ses_domain_identity.cic-trvapply-vrtdemande[0].domain
  include_original_headers = false
}

