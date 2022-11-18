module "lambda-google-cidr" {
  source                 = "github.com/cds-snc/terraform-modules?ref=v4.0.1//lambda"
  name                   = "google-cidr"
  billing_tag_value      = var.billing_tag_value
  ecr_arn                = aws_ecr_repository.google-cidr.arn
  enable_lambda_insights = true
  image_uri              = "${aws_ecr_repository.google-cidr.repository_url}:latest"
  timeout                = 60
  memory                 = 1024

  environment_variables = {
    PREFIX_LIST_ID          = var.google_cidr_prefix_list_id
    GOOGLE_CLOUD_CIDR_URL   = "https://www.gstatic.com/ipranges/cloud.json"
    GOOGLE_SERVICE_CIDR_URL = "https://www.gstatic.com/ipranges/goog.json"
  }
}

resource "aws_lambda_function_event_invoke_config" "google_cidr_invoke_config" {
  function_name                = module.lambda-google-cidr.function_name
  maximum_event_age_in_seconds = 60
  maximum_retry_attempts       = 0
}

resource "aws_cloudwatch_event_target" "google_cidr" {
  arn  = module.lambda-google-cidr.function_arn
  rule = aws_cloudwatch_event_rule.google_cidr.id
}

resource "aws_cloudwatch_event_rule" "google_cidr" {
  name                = "google_cidr_testing"
  description         = "google_cidr_testing event rule"
  schedule_expression = var.google_cidr_schedule_expression
  depends_on          = [module.lambda-google-cidr]
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda-google-cidr.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.google_cidr.arn
}

resource "aws_cloudwatch_log_group" "google_cidrs" {
  name              = module.lambda-google-cidr.function_name
  retention_in_days = 7
  tags = {
    CostCentre = "notification-canada-ca-${var.env}"
  }
}

# Iam Policy

resource "aws_iam_role" "google_cidrs" {
  name               = "DatabaseToolsUpdateGoogleCidrs"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_policy.json
}

resource "aws_iam_policy" "google_cidrs" {
  name   = "DatabaseToolsUpdateGoogleCidrs"
  path   = "/"
  policy = data.aws_iam_policy_document.google_cidrs.json
}

resource "aws_iam_role_policy_attachment" "google_cidrs" {
  role       = aws_iam_role.google_cidrs.name
  policy_arn = aws_iam_policy.google_cidrs.arn
}

data "aws_iam_policy_document" "lambda_assume_policy" {
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "google_cidrs" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      aws_cloudwatch_log_group.google_cidrs.arn,
      "${aws_cloudwatch_log_group.google_cidrs.arn}:log-stream:*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeManagedPrefixLists"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "ec2:GetManagedPrefixListEntries",
      "ec2:ModifyManagedPrefixList"
    ]
    resources = [
      "arn:aws:ec2:${var.region}:${var.account_id}:prefix-list/${var.google_cidr_prefix_list_id}"
    ]
  }
}
