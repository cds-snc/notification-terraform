resource "github_actions_secret" "account_id" {
  repository      = data.github_repository.notification_terraform.name
  secret_name     = "${upper(var.env)}_AWS_ACCOUNT_ID"
  plaintext_value = var.account_id
}

resource "github_actions_secret" "notify_dev_slack_webhook" {
  count           = var.env == "production" ? 1 : 0
  repository      = data.github_repository.notification_terraform.name
  secret_name     = "NOTIFY_DEV_SLACK_WEBHOOK"
  plaintext_value = var.notify_dev_slack_webhook
}

resource "github_actions_secret" "op_service_account_token" {
  count           = var.env == "production" || var.env == "staging" ? 1 : 0
  repository      = data.github_repository.notification_terraform.name
  secret_name     = "OP_SERVICE_ACCOUNT_TOKEN_${upper(var.env)}"
  plaintext_value = var.op_service_account_token
}

resource "github_actions_secret" "openai_api_key" {
  count           = var.env == "production" ? 1 : 0
  repository      = data.github_repository.notification_terraform.name
  secret_name     = "OPENAI_API_KEY"
  plaintext_value = var.openai_api_key
}

resource "github_actions_secret" "aws_access_key_id" {
  count           = var.env == "production" || var.env == "staging" ? 1 : 0
  repository      = data.github_repository.notification_terraform.name
  secret_name     = "${upper(var.env)}_AWS_ACCESS_KEY_ID"
  plaintext_value = var.aws_access_key_id
}

resource "github_actions_secret" "aws_secret_access_key" {
  count           = var.env == "production" || var.env == "staging" ? 1 : 0
  repository      = data.github_repository.notification_terraform.name
  secret_name     = "${upper(var.env)}_AWS_SECRET_ACCESS_KEY"
  plaintext_value = var.aws_secret_access_key
}

variable "shared_staging_kms_key_id" {
  type        = string
}

resource "github_actions_secret" "aws_kms_key_id" {
  count           = var.env == "staging" ? 1 : 0
  repository      = data.github_repository.notification_terraform.name
  secret_name     = "${upper(var.env)}_AWS_KMS_KEY_ID"
  plaintext_value = var.shared_staging_kms_key_id
}

resource "github_actions_secret" "rds_snapshot_identifier" {
  repository      = data.github_repository.notification_terraform.name
  secret_name     = "${upper(var.env)}_RDS_SNAPSHOT_IDENTIFIER"
  plaintext_value = var.rds_snapshot_identifier
}