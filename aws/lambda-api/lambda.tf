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
    variables = {
      ADMIN_BASE_URL                        = var.admin_base_url
      API_HOST_NAME                         = "https://${var.api_domain_name}"
      DOCUMENT_DOWNLOAD_API_HOST            = var.document_download_api_host
      SQLALCHEMY_DATABASE_URI               = var.sqlalchemy_database_uri
      SQLALCHEMY_DATABASE_READER_URI        = var.sqlalchemy_database_reader_uri
      NOTIFICATION_QUEUE_PREFIX             = var.notification_queue_prefix
      NOTIFY_EMAIL_DOMAIN                   = var.domain
      NOTIFY_ENVIRONMENT                    = var.env
      REDIS_ENABLED                         = var.redis_enabled
      NEW_RELIC_ENVIRONMENT                 = var.env
      NEW_RELIC_LAMBDA_HANDLER              = "application.handler"
      NEW_RELIC_ACCOUNT_ID                  = var.new_relic_account_id
      NEW_RELIC_APP_NAME                    = var.new_relic_app_name
      NEW_RELIC_DISTRIBUTED_TRACING_ENABLED = var.new_relic_distribution_tracing_enabled
      NEW_RELIC_EXTENSION_LOGS_ENABLED      = true
      NEW_RELIC_LAMBDA_EXTENSION_ENABLED    = true
      FF_CLOUDWATCH_METRICS_ENABLED         = var.ff_cloudwatch_metrics_enabled
    }
  }

  lifecycle {
    ignore_changes = [
      image_uri,
      description, # Will be updated outside TF to force cold start existing lambdas. Primarily when common envs are updated
    ]
  }
}

resource "aws_lambda_alias" "api_latest" {
  name             = "latest"
  description      = "The most recently deployed version of the API"
  function_name    = aws_lambda_function.api.arn
  function_version = aws_lambda_function.api.version
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
  qualifier                         = aws_lambda_alias.api_latest.name
  lifecycle {
    ignore_changes = [provisioned_concurrent_executions]
  }
}

resource "aws_appautoscaling_target" "api" {
  min_capacity       = var.high_demand_min_concurrency
  max_capacity       = var.high_demand_max_concurrency
  resource_id        = "function:${aws_lambda_function.api.function_name}:${aws_lambda_alias.api_latest.name}"
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
