locals {
  lambda_environment_variables = {
    DOCUMENT_DOWNLOAD_API_HOST            = var.document_download_api_host
    SQLALCHEMY_DATABASE_URI               = jsondecode(var.manifest_environment_variables)["POSTGRES_SQL"]
    NOTIFICATION_QUEUE_PREFIX             = var.notification_queue_prefix
    NOTIFY_EMAIL_DOMAIN                   = jsondecode(var.manifest_environment_variables)["BASE_DOMAIN"]
    NOTIFY_ENVIRONMENT                    = jsondecode(var.manifest_environment_variables)["ENVIRONMENT"]
    REDIS_ENABLED                         = var.redis_enabled
    NEW_RELIC_LAMBDA_HANDLER              = "application.handler"
    NEW_RELIC_ACCOUNT_ID                  = var.new_relic_account_id
    NEW_RELIC_APP_NAME                    = var.new_relic_app_name
    NEW_RELIC_DISTRIBUTED_TRACING_ENABLED = var.new_relic_distribution_tracing_enabled
    NEW_RELIC_LICENSE_KEY                 = var.new_relic_license_key
    NEW_RELIC_MONITOR_MODE                = var.new_relic_monitor_mode
    NEW_RELIC_EXTENSION_LOGS_ENABLED      = true
    NEW_RELIC_LAMBDA_EXTENSION_ENABLED    = true
    FF_CLOUDWATCH_METRICS_ENABLED         = var.ff_cloudwatch_metrics_enabled
  }
  # Merge the common environment variables with the lambda specific ones.
  # The second argument in the merge will override any values in the first argument that has the same key
  merged_environment_variables = sensitive(merge(jsondecode(var.manifest_environment_variables), local.lambda_environment_variables))
}

resource "aws_lambda_function" "api" {
  function_name = "api-lambda"
  role          = aws_iam_role.api.arn
  publish       = true

  package_type = "Image"
  image_uri    = "${aws_ecr_repository.api-lambda.repository_url}:${var.api_image_tag}"

  timeout                        = 60
  reserved_concurrent_executions = 850
  memory_size                    = 1024

  tracing_config {
    mode = "Active"
  }

  vpc_config {
    security_group_ids = [
      var.eks_cluster_securitygroup,
    ]
    subnet_ids = var.vpc_private_subnets
  }
  environment {
    variables = local.merged_environment_variables
  }

  lifecycle {
    ignore_changes = [
      image_uri,
    ]
  }
}

resource "aws_lambda_permission" "api_1" {
  statement_id  = "AllowAPIGatewayInvoke1"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_lambda_provisioned_concurrency_config" "api" {
  function_name                     = aws_lambda_function.api.function_name
  provisioned_concurrent_executions = var.low_demand_min_concurrency
  qualifier                         = aws_lambda_function.api.version
  lifecycle {
    ignore_changes = [provisioned_concurrent_executions]
  }
}

resource "aws_appautoscaling_target" "api" {
  min_capacity       = var.high_demand_min_concurrency
  max_capacity       = var.high_demand_max_concurrency
  resource_id        = "function:${aws_lambda_function.api.function_name}:${aws_lambda_function.api.version}"
  scalable_dimension = "lambda:function:ProvisionedConcurrency"
  service_namespace  = "lambda"
  lifecycle {
    ignore_changes = [min_capacity, max_capacity]
  }
}

# Scale up at noon EST, scale down at 5 pm EST
resource "aws_appautoscaling_scheduled_action" "api-noon" {
  name               = "api-noon"
  service_namespace  = aws_appautoscaling_target.api.service_namespace
  resource_id        = aws_appautoscaling_target.api.resource_id
  scalable_dimension = aws_appautoscaling_target.api.scalable_dimension
  schedule           = "cron(0 12 * * ? *)"
  timezone           = "America/Toronto"
  scalable_target_action {
    min_capacity = var.high_demand_min_concurrency
    max_capacity = var.high_demand_max_concurrency
  }
}

resource "aws_appautoscaling_scheduled_action" "api-5pm" {
  name               = "api-5pm"
  service_namespace  = aws_appautoscaling_target.api.service_namespace
  resource_id        = aws_appautoscaling_target.api.resource_id
  scalable_dimension = aws_appautoscaling_target.api.scalable_dimension
  schedule           = "cron(0 17 * * ? *)"
  timezone           = "America/Toronto"
  scalable_target_action {
    min_capacity = var.low_demand_min_concurrency
    max_capacity = var.low_demand_max_concurrency
  }
}
