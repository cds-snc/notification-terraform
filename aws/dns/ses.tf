locals {
  custom_sending_domain_dkim_records = distinct(flatten([
    for cd in aws_ses_domain_dkim.custom_sending_domains : [
      for token in cd.dkim_tokens : {
        domain = cd.domain
        token  = token
      }
    ]
  ]))

  ses_cic_trvapply_vrtdemande_dkim_records = distinct(flatten([
    for cd in aws_ses_domain_dkim.cic-trvapply-vrtdemande : [
      for token in cd.dkim_tokens : {
        domain = cd.domain
        token  = token
      }
    ]
  ]))

}

resource "aws_ses_domain_identity" "notification-canada-ca" {
  domain = var.domain
}

resource "aws_ses_domain_dkim" "notification-canada-ca" {
  domain = var.domain
}


# TODO: SES Domain Validation Records Programmatically

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
# trvapply-vrtdemande.apps.cic.gc.ca is alone for historic reasons
# and is not refactored to make sure the ressource is not destroyed/recreated.
# Read the section "Refactoring Can Be Tricky"
# https://blog.gruntwork.io/terraform-tips-tricks-loops-if-statements-and-gotchas-f739bbae55f9
#
# Afterwards there is a more automated way, using the set variable
# `ses_custom_sending_domains`.
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

resource "aws_ses_domain_identity" "custom_sending_domains" {
  for_each = var.ses_custom_sending_domains
  domain   = each.value
}

resource "aws_ses_domain_dkim" "custom_sending_domains" {
  for_each = var.ses_custom_sending_domains
  domain   = each.value
}

resource "aws_ses_identity_notification_topic" "custom_sending_domains_bounce_topic" {
  for_each                 = var.ses_custom_sending_domains
  topic_arn                = var.notification_canada_ca_ses_callback_arn
  notification_type        = "Bounce"
  identity                 = aws_ses_domain_identity.custom_sending_domains[each.value].domain
  include_original_headers = false
}

resource "aws_ses_identity_notification_topic" "custom_sending_domains_delivery_topic" {
  for_each                 = var.ses_custom_sending_domains
  topic_arn                = var.notification_canada_ca_ses_callback_arn
  notification_type        = "Delivery"
  identity                 = aws_ses_domain_identity.custom_sending_domains[each.value].domain
  include_original_headers = false
}

resource "aws_ses_identity_notification_topic" "custom_sending_domains_complaint_topic" {
  for_each                 = var.ses_custom_sending_domains
  topic_arn                = var.notification_canada_ca_ses_callback_arn
  notification_type        = "Complaint"
  identity                 = aws_ses_domain_identity.custom_sending_domains[each.value].domain
  include_original_headers = false
}

resource "aws_ses_domain_mail_from" "custom_sending_domains" {
  for_each         = var.ses_custom_sending_domains
  domain           = aws_ses_domain_identity.custom_sending_domains[each.value].domain
  mail_from_domain = "bounce.${aws_ses_domain_identity.custom_sending_domains[each.value].domain}"
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
