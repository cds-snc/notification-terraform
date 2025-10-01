# New Relic Lambda instrumentation configuration
# This configures the New Relic Lambda extension for monitoring the API Lambda function
# 
# For containerized Lambdas, the extension and agent must be included in the Docker image.
# See: https://docs.newrelic.com/docs/serverless-function-monitoring/aws-lambda-monitoring/instrument-lambda-function/containerized-images/
#
# IMPORTANT: This Terraform configuration only manages environment variables and IAM permissions.
# You must also update your Lambda's Dockerfile to include the New Relic agent and extension.
#
# Example Dockerfile changes needed:
# 
#   # Add New Relic layer as a build stage
#   FROM public.ecr.aws/newrelic-lambda-layers-for-docker/newrelic-lambda-layers-python:312 AS layer
#   
#   FROM public.ecr.aws/lambda/python:3.12
#   
#   # Copy New Relic extension and agent from layer
#   COPY --from=layer /opt/ /opt/
#   
#   # Your existing application code
#   COPY app.py requirements.txt ./
#   RUN python3.12 -m pip install -r requirements.txt -t .
#   
#   # Update CMD to use New Relic wrapper
#   CMD [ "newrelic_lambda_wrapper.handler" ]
#
# Available New Relic container layer tags:
#   - newrelic-lambda-layers-python:38 (Python 3.8)
#   - newrelic-lambda-layers-python:39 (Python 3.9)
#   - newrelic-lambda-layers-python:310 (Python 3.10)
#   - newrelic-lambda-layers-python:311 (Python 3.11)
#   - newrelic-lambda-layers-python:312 (Python 3.12)
#
# More info: https://github.com/newrelic/newrelic-lambda-extension/tree/main/examples/sam/containerized-lambda

locals {
  # Conditional New Relic environment variables
  # Only include these if api_enable_new_relic is true
  newrelic_env_vars = var.api_enable_new_relic ? {
    # New Relic account configuration
    NEW_RELIC_ACCOUNT_ID  = var.new_relic_account_id
    NEW_RELIC_APP_NAME    = var.new_relic_app_name
    NEW_RELIC_ENVIRONMENT = var.env

    # License key from Secrets Manager
    # The extension will automatically fetch this secret if the Lambda has the right IAM permissions
    NEW_RELIC_LICENSE_KEY_SECRET = aws_secretsmanager_secret.new-relic-license-key.name

    # Handler configuration - tells New Relic wrapper what your real handler is
    # For containerized Lambdas, this should match your actual handler function
    NEW_RELIC_LAMBDA_HANDLER = var.new_relic_lambda_handler

    # New Relic extension configuration
    NEW_RELIC_LAMBDA_EXTENSION_ENABLED     = var.new_relic_lambda_extension_enabled
    NEW_RELIC_EXTENSION_LOGS_ENABLED       = var.new_relic_extension_logs_enabled
    NEW_RELIC_EXTENSION_SEND_FUNCTION_LOGS = var.new_relic_extension_send_function_logs

    # Distributed tracing configuration
    NEW_RELIC_DISTRIBUTED_TRACING_ENABLED = var.new_relic_distribution_tracing_enabled

    # Optional: Config file path if you have one in your container
    NEW_RELIC_CONFIG_FILE = var.new_relic_config_file
  } : {}
}
