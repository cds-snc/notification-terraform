locals {
  # Conditional New Relic environment variables
  # Only include these if api_enable_new_relic is true
  newrelic_env_vars = var.enable_new_relic ? {
    # New Relic account configuration
    NEW_RELIC_ACCOUNT_ID  = var.new_relic_account_id
    NEW_RELIC_APP_NAME    = var.lambda_new_relic_app_name
    NEW_RELIC_ENVIRONMENT = var.env

    # License key from Secrets Manager
    # The extension will automatically fetch this secret if the Lambda has the right IAM permissions
    NEW_RELIC_LICENSE_KEY_SECRET = aws_secretsmanager_secret.new-relic-license-key.name

    # Handler configuration - tells New Relic wrapper what your real handler is
    # For containerized Lambdas, this should match your actual handler function
    NEW_RELIC_LAMBDA_HANDLER = var.lambda_new_relic_handler

    # New Relic extension configuration
    NEW_RELIC_LAMBDA_EXTENSION_ENABLED     = var.lambda_new_relic_extension_enabled
    NEW_RELIC_EXTENSION_LOGS_ENABLED       = var.lambda_new_relic_extension_logs_enabled
    NEW_RELIC_EXTENSION_SEND_FUNCTION_LOGS = var.lambda_new_relic_extension_send_function_logs

    # Distributed tracing configuration
    NEW_RELIC_DISTRIBUTED_TRACING_ENABLED = var.lambda_new_relic_distribution_tracing_enabled
  } : {}
}
