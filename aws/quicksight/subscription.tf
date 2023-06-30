resource "aws_quicksight_account_subscription" "subscription" {
  account_name          = "quicksight-test-${random_string.suffix.result}"
  authentication_method = "IAM_ONLY"
  edition               = "ENTERPRISE"
  notification_email    = "stephen.astels@cds-snc.ca"
}
