module "notify_performance_test_results" {
  source            = "github.com/cds-snc/terraform-modules//S3?ref=v0.0.49"
  bucket_name       = "notify-performance-test-results-${var.env}"
  billing_tag_value = var.billing_tag_value
}
resource "aws_iam_policy" "notify_performance_test_s3" {
  name   = "NotifyPerformanceTestS3Access"
  path   = "/"
  policy = data.aws_iam_policy_document.notify_performance_test_s3.json
}
data "aws_iam_policy_document" "notify_performance_test_s3" {
  statement {
    effect = "Allow"

    actions = [
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket"
    ]

    resources = [
      module.notify_performance_test_results.s3_bucket_arn,
      "${module.notify_performance_test_results.s3_bucket_arn}/*"
    ]
  }
}
resource "aws_iam_role_policy_attachment" "s3_notify_performance_test" {
  role       = aws_iam_role.performance-test.name
  policy_arn = aws_iam_policy.notify_performance_test_s3.arn
}
resource "aws_iam_role" "performance-test" {
  name = "performance-test-iam-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}