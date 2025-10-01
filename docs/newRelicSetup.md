# New Relic Lambda Instrumentation Setup

This directory contains the Terraform configuration for instrumenting the Notify API Lambda function with New Relic monitoring.

## Overview

The API Lambda is a **containerized function** (using `package_type = "Image"`), which requires a different instrumentation approach than ZIP-based Lambdas.

## Current Setup

### Terraform Configuration (Managed Here)

The Terraform in this directory manages:

1. **Environment Variables** (`newrelic.tf`):
   - `NEW_RELIC_ACCOUNT_ID` - Your New Relic account identifier
   - `NEW_RELIC_APP_NAME` - Application name in New Relic UI
   - `NEW_RELIC_ENVIRONMENT` - Environment tag (dev/staging/production)
   - `NEW_RELIC_LICENSE_KEY_SECRET` - Name of Secrets Manager secret containing license key
   - `NEW_RELIC_LAMBDA_HANDLER` - Your actual handler function (`application.handler`)
   - `NEW_RELIC_LAMBDA_EXTENSION_ENABLED` - Enable the extension for telemetry shipping
   - `NEW_RELIC_EXTENSION_LOGS_ENABLED` - Send function logs to New Relic
   - `NEW_RELIC_DISTRIBUTED_TRACING_ENABLED` - Enable distributed tracing
   - `NEW_RELIC_CONFIG_FILE` - Path to newrelic.ini config file

2. **IAM Permissions** (`iam.tf`):
   - Already has `secretsmanager:GetSecretValue` permission for the license key secret

3. **Secrets** (`secrets_manager.tf`):
   - `NEW_RELIC_LICENSE_KEY` secret already exists in AWS Secrets Manager

### Docker Image Configuration (NOT Managed Here)

**⚠️ IMPORTANT**: You must also update your Lambda's Dockerfile to include the New Relic agent and extension.

The recommended approach for containerized Lambdas is to use New Relic's pre-built layer images:

```dockerfile
# Stage 1: Get New Relic extension and agent
FROM public.ecr.aws/newrelic-lambda-layers-for-docker/newrelic-lambda-layers-python:312 AS layer

# Stage 2: Your application image
FROM public.ecr.aws/lambda/python:3.12

# Copy New Relic extension and agent files
COPY --from=layer /opt/ /opt/

# Your application code and dependencies
COPY app.py requirements.txt ./
RUN python3.12 -m pip install -r requirements.txt -t .

# IMPORTANT: Handler should be the New Relic wrapper
# The wrapper will call your actual handler based on NEW_RELIC_LAMBDA_HANDLER env var
CMD [ "newrelic_lambda_wrapper.handler" ]
```

## How It Works

### For Containerized Lambdas

1. **Multi-stage Docker build**: The New Relic layer image provides both the extension and the Python agent
2. **Wrapper Handler**: The `CMD` points to New Relic's wrapper (`newrelic_lambda_wrapper.handler`)
3. **Environment Variables**: Terraform sets `NEW_RELIC_LAMBDA_HANDLER=application.handler` to tell the wrapper where your real handler is
4. **Extension**: The New Relic Lambda extension ships telemetry directly to New Relic (bypasses CloudWatch)
5. **License Key**: The extension automatically fetches the license key from Secrets Manager using the IAM permission

### Enabling/Disabling

The instrumentation is controlled by the `api_enable_new_relic` variable (defined in `env/variables.tf`):

- **`true`**: All New Relic environment variables are set, monitoring is active
- **`false`**: New Relic environment variables are omitted, no monitoring overhead

## Available Python Layers

New Relic provides pre-built container layer images for different Python versions:

- `newrelic-lambda-layers-python:38` - Python 3.8
- `newrelic-lambda-layers-python:39` - Python 3.9  
- `newrelic-lambda-layers-python:310` - Python 3.10
- `newrelic-lambda-layers-python:311` - Python 3.11
- `newrelic-lambda-layers-python:312` - Python 3.12

All layers are available from: `public.ecr.aws/newrelic-lambda-layers-for-docker/`

## Testing the Setup

After deploying with Terraform and updating your Docker image:

1. **Deploy the Lambda** with the updated Dockerfile
2. **Invoke the function** (any invocation will generate telemetry)
3. **Check New Relic** - Navigate to your New Relic account → Lambda monitoring
4. **Check CloudWatch Logs** - Look for New Relic initialization messages:
   ```
   [NR_EXT] New Relic Lambda Extension starting up
   [NR_EXT] Telemetry client initialized
   ```

## Troubleshooting

### No telemetry in New Relic

1. Check CloudWatch logs for extension startup messages
2. Verify `api_enable_new_relic = true` in your environment config
3. Confirm the license key secret exists and Lambda has permission to read it
4. Verify the Dockerfile includes the New Relic layer files

### Errors about missing handler

- Ensure `NEW_RELIC_LAMBDA_HANDLER` matches your actual handler function
- Verify the Dockerfile `CMD` points to `newrelic_lambda_wrapper.handler`

### High latency / cold start issues

- This is normal for containerized Lambdas with instrumentation
- Consider provisioned concurrency (already configured) to reduce cold starts

## References

- [New Relic Containerized Lambda Docs](https://docs.newrelic.com/docs/serverless-function-monitoring/aws-lambda-monitoring/instrument-lambda-function/containerized-images/)
- [New Relic Lambda Extension GitHub](https://github.com/newrelic/newrelic-lambda-extension)
- [Containerized Lambda Examples](https://github.com/newrelic/newrelic-lambda-extension/tree/main/examples/sam/containerized-lambda)
- [Terraform Examples](https://github.com/newrelic/newrelic-lambda-extension/tree/main/examples/terraform/python)
- [Environment Variables Reference](https://docs.newrelic.com/docs/serverless-function-monitoring/aws-lambda-monitoring/instrument-lambda-function/env-variables-lambda/)
