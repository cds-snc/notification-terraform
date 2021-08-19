resource "aws_lambda_function" "api" {
  function_name = "api"

  package_type = "Image"
  image_uri    = "${aws_ecr_repository.api.repository_url}:latest"

  role    = aws_iam_role.api.arn
  timeout = 60

  memory_size = 1024

  environment {
    variables = {
      ADMIN_CLIENT_SECRET = var.admin_client_secret
      ADMIN_CLIENT_USER_NAME = var.admin_client_user_name
      API_HOST_NAME = var.api_host_name
      ASSET_DOMAIN = var.asset_domain
      ASSET_UPLOAD_BUCKET_NAME = var.asset_upload_bucket_name
      AUTH_TOKENS = var.auth_tokens
      AWS_PINPOINT_REGION = var.aws_pinpoint_region
      BASE_DOMAIN = var.base_domain
      CSV_UPLOAD_BUCKET_NAME = var.csv_upload_bucket_name
      DANGEROUS_SALT = var.dangerous_salt
      DOCUMENTS_BUCKET = var.documents_bucket
      ENVIRONMENT = var.env
      MLWR_HOST = var.mlwr_host
      NOTIFICATION_QUEUE_PREFIX = var.notification_queue_prefix
      NOTIFY_EMAIL_DOMAIN = var.domain
      NOTIFY_ENVIRONMENT = var.environment
      REDIS_ENABLED = var.redis_enabled
      REDIS_URL = var.redis_url
      SECRET_KEY = var.secret_key
      SQLALCHEMY_DATABASE_READER_URI = var.sqlalchemy_database_reader_uri
      SQLALCHEMY_DATABASE_URI = var.sqlalchemy_database_uri
      SQLALCHEMY_POOL_SIZE = var.sqlalchemy_pool_size
    }
  }

  vpc_config {
    security_group_ids = [module.rds.proxy_security_group_id]
    subnet_ids         = module.vpc.private_subnet_ids
  }

  lifecycle {
    ignore_changes = [
      image_uri,
    ]
  }
}

resource "aws_lambda_permission" "api" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}
