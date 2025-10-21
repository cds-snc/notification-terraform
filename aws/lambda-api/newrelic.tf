locals {
  # New Relic environment variables
  newrelic_env_vars = {
    # New Relic account configuration
    ENABLE_NEW_RELIC             = var.enable_new_relic
    NEW_RELIC_ACCOUNT_ID         = var.new_relic_account_id
    NEW_RELIC_APP_NAME           = var.lambda_new_relic_app_name
    NEW_RELIC_LICENSE_KEY_SECRET = aws_secretsmanager_secret.new-relic-license-key.name
    NEW_RELIC_CONFIG_FILE        = var.lambda_new_relic_config_file
  }
}
