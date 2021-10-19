resource "aws_lambda_function" "api" {
  function_name = "api-lambda"

  package_type = "Image"
  image_uri    = "${aws_ecr_repository.api-lambda.repository_url}:${var.api_image_tag}"

  role    = aws_iam_role.api.arn
  timeout = 60

  memory_size = 1024
  publish     = true

  vpc_config {
    security_group_ids = [
      var.eks_cluster_securitygroup,
    ]
    subnet_ids = var.vpc_private_subnets
  }

  environment {
    variables = {
      ADMIN_CLIENT_SECRET            = var.admin_client_secret
      ADMIN_CLIENT_USER_NAME         = var.admin_client_user_name
      ASSET_DOMAIN                   = var.asset_domain
      ASSET_UPLOAD_BUCKET_NAME       = var.asset_upload_bucket_name
      AUTH_TOKENS                    = var.auth_tokens
      AWS_PINPOINT_REGION            = var.aws_pinpoint_region
      CSV_UPLOAD_BUCKET_NAME         = var.csv_upload_bucket_name
      DANGEROUS_SALT                 = var.dangerous_salt
      DOCUMENTS_BUCKET               = var.documents_bucket
      ENVIRONMENT                    = var.env
      MLWR_HOST                      = var.mlwr_host
      NOTIFICATION_QUEUE_PREFIX      = var.notification_queue_prefix
      NOTIFY_EMAIL_DOMAIN            = var.domain
      NOTIFY_ENVIRONMENT             = var.env
      REDIS_ENABLED                  = var.redis_enabled
      REDIS_URL                      = var.redis_url
      SECRET_KEY                     = var.secret_key
      SQLALCHEMY_DATABASE_READER_URI = var.sqlalchemy_database_reader_uri
      SQLALCHEMY_DATABASE_URI        = var.sqlalchemy_database_uri
      SQLALCHEMY_POOL_SIZE           = var.sqlalchemy_pool_size
      DOCUMENT_DOWNLOAD_API_HOST     = var.document_download_api_host
    }
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
  provisioned_concurrent_executions = var.scaling_min_capacity
  qualifier                         = aws_lambda_function.api.version
}

resource "aws_appautoscaling_target" "api" {
  min_capacity       = var.scaling_min_capacity
  max_capacity       = var.scaling_max_capacity
  resource_id        = "function:${aws_lambda_function.api.function_name}:${aws_lambda_function.api.version}"
  scalable_dimension = "lambda:function:ProvisionedConcurrency"
  service_namespace  = "lambda"
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
    min_capacity = 2
    max_capacity = 10
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
    min_capacity = 1
    max_capacity = 5
  }
}
