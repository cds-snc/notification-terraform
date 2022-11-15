#
# Lambda function to update the Blazer security group with
# and egress rule to allow access to Google service CIDRs.
#
resource "aws_lambda_function" "google_cidrs" {
  function_name = "database-tools-update-google-cidrs"
  role          = aws_iam_role.google_cidrs.arn
  runtime       = "python3.8"
  handler       = "cidr.handler"
  memory_size   = 512

  filename         = data.archive_file.google_cidrs.output_path
  source_code_hash = filebase64sha256(data.archive_file.google_cidrs.output_path)

  environment {
    variables = {
      GOOGLE_CLOUD_CIDR_URL   = "https://www.gstatic.com/ipranges/cloud.json"
      GOOGLE_SERVICE_CIDR_URL = "https://www.gstatic.com/ipranges/goog.json"
      PREFIX_LIST_ID          = var.google_cidr_prefix_list_id
    }
  }

  tracing_config {
    mode = "PassThrough"
  }

  tags = {
    CostCentre = "notification-canada-ca-${var.env}"
  }
}

data "archive_file" "google_cidrs" {
  type        = "zip"
  source_file = "${path.module}/google_cidrs/cidr.py"
  output_path = "/tmp/cidr.py.zip"
}

resource "aws_cloudwatch_log_group" "google_cidrs" {
  name              = "/aws/lambda/${aws_lambda_function.google_cidrs.function_name}"
  retention_in_days = 7
  tags              = local.common_tags
}

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

#
# Trigger the Google CIDR update lambda every 24 hours
#
resource "aws_lambda_function_event_invoke_config" "google_cidrs" {
  function_name                = aws_lambda_function.google_cidrs.function_name
  maximum_event_age_in_seconds = 60
}

resource "aws_cloudwatch_event_target" "google_cidrs" {
  arn  = aws_lambda_function.google_cidrs.arn
  rule = aws_cloudwatch_event_rule.google_cidrs.id
}

resource "aws_cloudwatch_event_rule" "google_cidrs" {
  name                = "database-tools-update-google-cidrs"
  description         = "Update the Google CIDRs prefix list once a day"
  schedule_expression = "rate(1 day)"
  depends_on          = [aws_lambda_function.google_cidrs]
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.google_cidrs.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.google_cidrs.arn
}
