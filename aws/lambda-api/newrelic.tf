locals {
  # New Relic environment variables
  newrelic_env_vars = {
    # New Relic account configuration
    NEW_RELIC_ACCOUNT_ID                   = var.new_relic_account_id
    NEW_RELIC_APP_NAME                     = var.lambda_new_relic_app_name
    NEW_RELIC_ENVIRONMENT                  = var.env
    NEW_RELIC_LICENSE_KEY_SECRET           = aws_secretsmanager_secret.lambda-new-relic-license-key.name
    NEW_RELIC_LAMBDA_HANDLER               = var.lambda_new_relic_handler
    NEW_RELIC_LAMBDA_EXTENSION_ENABLED     = var.api_enable_new_relic ? "true" : "false"
    NEW_RELIC_EXTENSION_LOGS_ENABLED       = var.api_enable_new_relic ? "true" : "false"
    NEW_RELIC_EXTENSION_SEND_FUNCTION_LOGS = var.api_enable_new_relic ? "true" : "false"
    NEW_RELIC_DISTRIBUTED_TRACING_ENABLED  = var.api_enable_new_relic ? "true" : "false"
  }
}
