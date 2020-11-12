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
