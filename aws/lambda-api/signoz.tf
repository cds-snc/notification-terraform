module "signoz_api_lambda_logs" {
  count  = var.env == "dev" ? 1 : 0
  source = "github.com/cds-snc/terraform-modules//S3_log_bucket?ref=v6.1.5"

  bucket_name       = "notification-canada-ca-${var.env}-lambda-api-signoz-logs"
  force_destroy     = var.force_destroy_s3
  billing_tag_value = "notification-canada-ca-${var.env}"
  versioning_status = "Enabled"

  lifecycle_rule = { "lifecycle_rule" : { "enabled" : "true", "expiration" : { "days" : "90" } } }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

data "aws_iam_policy_document" "signoz_api_lambda_s3_permissions" {
  count = var.env == "dev" ? 1 : 0
  statement {
    sid     = "AllowS3Access"
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::notification-canada-ca-${var.env}-lambda-api-signoz-logs",
      "arn:aws:s3:::notification-canada-ca-${var.env}-lambda-api-signoz-logs/*"
    ]
  }
}

resource "aws_iam_policy" "signoz_s3_permissions" {
  count  = var.env == "dev" ? 1 : 0
  name   = "signoz_s3_permissions"
  path   = "/"
  policy = data.aws_iam_policy_document.signoz_api_lambda_s3_permissions[0].json
}

resource "aws_iam_role_policy_attachment" "signoz_s3_permissions" {
  count      = var.env == "dev" ? 1 : 0
  role       = aws_iam_role.api.name
  policy_arn = aws_iam_policy.signoz_s3_permissions[0].arn
}

# Lambda layer for dependencies
resource "aws_lambda_layer_version" "signoz_dependencies" {
  count               = var.env == "dev" ? 1 : 0
  filename            = "./signoz_lambda_layer/dependencies.zip"
  layer_name          = "signoz-dependencies"
  compatible_runtimes = ["python3.12"]
  description         = "Dependencies layer for SigNoz log forwarder"

  # Optional: Add a source code hash to trigger updates when the zip file changes
  source_code_hash = filebase64sha256("./signoz_lambda_layer/dependencies.zip")
}

# This is disabled everywhere for now. We need to make a more elegant way of getting the dependencies built and updated.
resource "aws_lambda_function" "signoz_log_forwarder" {
  count         = var.env == "dev" ? 0 : 0
  filename      = "signoz_log_forwarder.zip" # This should be your function code, not dependencies
  function_name = "signoz_log_forwarder"
  role          = aws_iam_role.api.name
  handler       = "index.handler"
  runtime       = "python3.12"

  # Attach the layer to the function
  layers = [aws_lambda_layer_version.signoz_dependencies[0].arn]

  # This needs to be added to work, but disabled for now.
  #source_code_hash = filebase64sha256("signoz_log_forwarder.zip")

  tracing_config {
    mode = "Active" # Enable X-Ray tracing
  }
}

# Lambda permission to allow S3 to invoke the function
resource "aws_lambda_permission" "signoz_s3_invoke" {
  count         = var.env == "dev" ? 0 : 0
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.signoz_log_forwarder[0].function_name
  principal     = "s3.amazonaws.com"
  source_arn    = module.signoz_api_lambda_logs[0].s3_bucket_arn
}

# S3 bucket notification to trigger the Lambda function
resource "aws_s3_bucket_notification" "signoz_logs_trigger" {
  count  = var.env == "dev" ? 0 : 0
  bucket = module.signoz_api_lambda_logs[0].s3_bucket_id

  lambda_function {
    lambda_function_arn = aws_lambda_function.signoz_log_forwarder[0].arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = ""     # Optional: filter by object key prefix
    filter_suffix       = ".log" # Optional: filter by object key suffix (e.g., only .log files)
  }

  depends_on = [aws_lambda_permission.signoz_s3_invoke]
}
