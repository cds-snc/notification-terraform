module "notify_performance_test_results" {
  source            = "github.com/cds-snc/terraform-modules?ref=v0.0.38//S3"
  bucket_name       = "notify-performance-test-results-staging"
  billing_tag_value = "notification-canada-ca-staging"
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
