module "sns_to_sqs_sms_callbacks" {
  source                 = "github.com/cds-snc/terraform-modules?ref=v4.0.3//lambda"
  name                   = "sns_to_sqs_sms_callbacks"
  billing_tag_value      = var.billing_tag_value
  ecr_arn                = aws_ecr_repository.sns_to_sqs_sms_callbacks.arn
  enable_lambda_insights = true
  image_uri              = "${aws_ecr_repository.sns_to_sqs_sms_callbacks.repository_url}:latest"
  timeout                = 60
  memory                 = 1024

  policies = [
    data.aws_iam_policy_document.sns_to_sqs_sms_callbacks.json
  ]
}

data "aws_iam_policy_document" "sns_to_sqs_sms_callbacks" {
  statement {
    actions = [
      "sqs:Get*",
      "sqs:SendMessage"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

##
# CloudWatch log groups for SNS deliveries in ca-central-1
##
resource "aws_lambda_permission" "allow_cloudwatch_logs_sns_successes" {
  action        = "lambda:InvokeFunction"
  function_name = module.sns_to_sqs_sms_callbacks.function_name
  principal     = "logs.${var.region}.amazonaws.com"
  source_arn    = "${var.sns_deliveries_ca_central_arn}:*"
}

resource "aws_lambda_permission" "allow_cloudwatch_logs_sns_failures" {
  action        = "lambda:InvokeFunction"
  function_name = module.sns_to_sqs_sms_callbacks.function_name
  principal     = "logs.${var.region}.amazonaws.com"
  source_arn    = "${var.sns_deliveries_failures_ca_central_arn}:*"
}

##
# CloudWatch log groups for SNS deliveries in us-west-2
##
resource "aws_lambda_permission" "allow_cloudwatch_logs_sns_successes_us_west_2" {
  action        = "lambda:InvokeFunction"
  function_name = module.sns_to_sqs_sms_callbacks.function_name
  principal     = "logs.us-west-2.amazonaws.com"
  source_arn    = "${var.sns_deliveries_us_west_2_arn}:*"
}

resource "aws_lambda_permission" "allow_cloudwatch_logs_sns_failures_us_west_2" {
  action        = "lambda:InvokeFunction"
  function_name = module.sns_to_sqs_sms_callbacks.function_name
  principal     = "logs.us-west-2.amazonaws.com"
  source_arn    = "${var.sns_deliveries_failures_us_west_2_arn}:*"
}
