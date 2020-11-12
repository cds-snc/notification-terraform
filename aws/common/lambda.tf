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
