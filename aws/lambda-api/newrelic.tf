locals {
  # New Relic environment variables
  newrelic_env_vars = {
    # New Relic account configuration
    #Important: We set these for the lambda to be in APM mode, not serverless mode
    NEW_RELIC_ACCOUNT_ID                  = var.new_relic_account_id
    NEW_RELIC_APP_NAME                    = var.lambda_new_relic_app_name
    NEW_RELIC_ENVIRONMENT                 = var.env
    NEW_RELIC_LICENSE_KEY_SECRET          = aws_secretsmanager_secret.new-relic-license-key.name
    NEW_RELIC_DISTRIBUTED_TRACING_ENABLED = var.api_enable_new_relic ? "true" : "false"
    NEW_RELIC_SERVERLESS_MODE_ENABLED     = "false"
  }
}
