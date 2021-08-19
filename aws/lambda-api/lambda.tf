resource "aws_lambda_function" "api" {
  function_name = "api"

  package_type = "Image"
  image_uri    = "${aws_ecr_repository.api.repository_url}:latest"

  role    = aws_iam_role.api.arn
  timeout = 60

  memory_size = 1024

  environment {
    variables = {
      ADMIN_CLIENT_SECRET = 
      ADMIN_CLIENT_USER_NAME = 
      API_HOST_NAME = 
      ASSET_DOMAIN = 
      ASSET_UPLOAD_BUCKET_NAME = 
      AUTH_TOKENS = 
      AWS_PINPOINT_REGION = 
      BASE_DOMAIN = 
      CSV_UPLOAD_BUCKET_NAME = 
      DANGEROUS_SALT = 
      DOCUMENTS_BUCKET = 
      ENVIRONMENT = var.env
      MLWR_HOST = 
      NOTIFICATION_QUEUE_PREFIX = 
      NOTIFY_EMAIL_DOMAIN = var.domain
      NOTIFY_ENVIRONMENT = var.environment
      REDIS_ENABLED = 
      REDIS_URL = 
      SECRET_KEY = 
      SQLALCHEMY_DATABASE_READER_URI = 
      SQLALCHEMY_DATABASE_URI = 
      SQLALCHEMY_POOL_SIZE = 
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
