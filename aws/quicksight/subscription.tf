resource "aws_quicksight_account_subscription" "subscription" {
  account_name          = "quicksight-test-${var.env}"
  authentication_method = "IAM_ONLY"
  edition               = "ENTERPRISE"
  notification_email    = "helpdesk@cds-snc.ca"
}
