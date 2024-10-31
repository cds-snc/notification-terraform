locals {
  custom_sending_domain_dkim_records = distinct(flatten([
    for cd in aws_ses_domain_dkim.custom_sending_domains : [
      for token in cd.dkim_tokens : {
        domain = cd.domain
        token  = token
      }
    ]
  ]))
}



resource "aws_sesv2_email_identity" "notification-canada-ca" {
  email_identity = var.domain
}

resource "aws_ses_domain_dkim" "notification-canada-ca" {
  domain = var.domain
}


# TODO: SES Domain Validation Records Programmatically

resource "aws_ses_identity_notification_topic" "notification-canada-ca-bounce-topic" {
  topic_arn                = var.notification_canada_ca_ses_callback_arn
  notification_type        = "Bounce"
  identity                 = aws_sesv2_email_identity.notification-canada-ca.email_identity
  include_original_headers = false
}

resource "aws_ses_identity_notification_topic" "notification-canada-ca-delivery-topic" {
  topic_arn                = var.notification_canada_ca_ses_callback_arn
  notification_type        = "Delivery"
  identity                 = aws_sesv2_email_identity.notification-canada-ca.email_identity
  include_original_headers = false
}

resource "aws_ses_identity_notification_topic" "notification-canada-ca-complaint-topic" {
  topic_arn                = var.notification_canada_ca_ses_callback_arn
  notification_type        = "Complaint"
  identity                 = aws_sesv2_email_identity.notification-canada-ca.email_identity
  include_original_headers = false
}

resource "aws_ses_domain_mail_from" "notification-canada-ca" {
  domain           = aws_sesv2_email_identity.notification-canada-ca.email_identity
  mail_from_domain = "bounce.${aws_sesv2_email_identity.notification-canada-ca.email_identity}"
}

###
# Receiving emails
###

resource "aws_sesv2_email_identity" "notification-canada-ca-receiving" {
  # Email receiving with SES is available in only 3 regions
  # so we use us-east-1
  # https://docs.aws.amazon.com/general/latest/gr/ses.html
  provider = aws.us-east-1

  email_identity = var.domain
}

resource "aws_ses_domain_dkim" "notification-canada-ca-receiving" {
  provider = aws.us-east-1
  domain   = var.domain
}


resource "aws_ses_receipt_rule_set" "main" {
  provider = aws.us-east-1

  rule_set_name = "main"
}

resource "aws_ses_active_receipt_rule_set" "main" {
  provider = aws.us-east-1

  rule_set_name = aws_ses_receipt_rule_set.main.rule_set_name
}

###
# Additional custom sending domains for emails
###


resource "aws_sesv2_email_identity" "custom_sending_domains" {
  for_each       = var.ses_custom_sending_domains
  email_identity = each.value
}

resource "aws_ses_domain_dkim" "custom_sending_domains" {
  for_each = var.ses_custom_sending_domains
  domain   = each.value
}

resource "aws_ses_identity_notification_topic" "custom_sending_domains_bounce_topic" {
  for_each                 = var.ses_custom_sending_domains
  topic_arn                = var.notification_canada_ca_ses_callback_arn
  notification_type        = "Bounce"
  identity                 = aws_sesv2_email_identity.custom_sending_domains[each.value].email_identity
  include_original_headers = false
}

resource "aws_ses_identity_notification_topic" "custom_sending_domains_delivery_topic" {
  for_each                 = var.ses_custom_sending_domains
  topic_arn                = var.notification_canada_ca_ses_callback_arn
  notification_type        = "Delivery"
  identity                 = aws_sesv2_email_identity.custom_sending_domains[each.value].email_identity
  include_original_headers = false
}

resource "aws_ses_identity_notification_topic" "custom_sending_domains_complaint_topic" {
  for_each                 = var.ses_custom_sending_domains
  topic_arn                = var.notification_canada_ca_ses_callback_arn
  notification_type        = "Complaint"
  identity                 = aws_sesv2_email_identity.custom_sending_domains[each.value].email_identity
  include_original_headers = false
}

resource "aws_ses_domain_mail_from" "custom_sending_domains" {
  for_each         = var.ses_custom_sending_domains
  domain           = aws_sesv2_email_identity.custom_sending_domains[each.value].email_identity
  mail_from_domain = "bounce.${aws_sesv2_email_identity.custom_sending_domains[each.value].email_identity}"
}


### SES receiving emails lambda image
resource "aws_ses_receipt_rule" "ses_receiving_emails_inbound-to-lambda-arn" {
  provider = aws.us-east-1

  name          = "ses_receiving_emails_inbound-to-lambda"
  rule_set_name = aws_ses_receipt_rule_set.main.rule_set_name
  recipients    = [var.domain]
  enabled       = true
  scan_enabled  = true

  lambda_action {
    function_arn    = var.lambda_ses_receiving_emails_image_arn
    invocation_type = "Event"
    position        = 1
  }
}
