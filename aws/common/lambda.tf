data "archive_file" "ses_to_sqs_email_callbacks" {
  type        = "zip"
  source_file = "${path.module}/lambdas/ses_to_sqs_email_callbacks.py"
  output_path = "${path.module}/lambdas/ses_to_sqs_email_callbacks.zip"
}

resource "aws_lambda_function" "ses_to_sqs_email_callbacks" {
  filename      = data.archive_file.ses_to_sqs_email_callbacks.output_path
  function_name = "ses-to-sqs-email-callbacks"
  role          = aws_iam_role.iam_lambda_to_sqs.arn
  handler       = "ses_to_sqs_email_callbacks.lambda_handler"

  source_code_hash = data.archive_file.ses_to_sqs_email_callbacks.output_base64sha256

  runtime = "python3.8"

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

data "archive_file" "sns_to_sqs_sms_callbacks" {
  type        = "zip"
  source_file = "${path.module}/lambdas/sns_to_sqs_sms_callbacks.py"
  output_path = "${path.module}/lambdas/sns_to_sqs_sms_callbacks.zip"
}

resource "aws_lambda_function" "sns_to_sqs_sms_callbacks" {
  filename      = data.archive_file.sns_to_sqs_sms_callbacks.output_path
  function_name = "sns-to-sqs-sms-callbacks"
  role          = aws_iam_role.iam_lambda_to_sqs.arn
  handler       = "sns_to_sqs_sms_callbacks.lambda_handler"

  source_code_hash = data.archive_file.sns_to_sqs_sms_callbacks.output_base64sha256

  runtime = "python3.8"

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sns_to_sqs_sms_callbacks.function_name
  principal     = "events.amazonaws.com"
=======
resource "aws_iam_role" "iam_lambda_to_sqs" {
  name = "iam_lambda_to_sqs"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a Lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_lambda_to_sqs.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_iam_policy" "lambda_sqs_send" {
  name        = "lambda_sqs_send"
  path        = "/"
  description = "IAM policy for sending messages to SQS from Lambda"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "sqs:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_sqs" {
  role       = aws_iam_role.iam_lambda_to_sqs.name
  policy_arn = aws_iam_policy.lambda_sqs_send.arn
}

data "archive_file" "ses_to_sqs_email_callbacks" {
  type        = "zip"
  source_file = "${path.module}/lambdas/ses_to_sqs_email_callbacks.py"
  output_path = "${path.module}/lambdas/ses_to_sqs_email_callbacks.zip"
}

resource "aws_lambda_function" "ses_to_sqs_email_callbacks" {
  filename      = data.archive_file.ses_to_sqs_email_callbacks.output_path
  function_name = "ses-to-sqs-email-callbacks"
  role          = aws_iam_role.iam_lambda_to_sqs.arn
  handler       = "ses_to_sqs_email_callbacks.lambda_handler"

  source_code_hash = data.archive_file.ses_to_sqs_email_callbacks.output_base64sha256

  runtime = "python3.8"
}

data "archive_file" "sns_to_sqs_sms_callbacks" {
  type        = "zip"
  source_file = "${path.module}/lambdas/sns_to_sqs_sms_callbacks.py"
  output_path = "${path.module}/lambdas/sns_to_sqs_sms_callbacks.zip"
}

resource "aws_lambda_function" "sns_to_sqs_sms_callbacks" {
  filename      = data.archive_file.sns_to_sqs_sms_callbacks.output_path
  function_name = "sns-to-sqs-sms-callbacks"
  role          = aws_iam_role.iam_lambda_to_sqs.arn
  handler       = "sns_to_sqs_sms_callbacks.lambda_handler"

  source_code_hash = data.archive_file.sns_to_sqs_sms_callbacks.output_base64sha256

  runtime = "python3.8"
}
