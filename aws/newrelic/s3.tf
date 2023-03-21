
resource "random_string" "s3-bucket-name" {
  length = 8
  special = false
  upper = false
}

resource "aws_s3_bucket" "newrelic_aws_bucket" {
  bucket = "newrelic-aws-bucket-${random_string.s3-bucket-name.id}"
}

resource "aws_s3_bucket_acl" "newrelic_aws_bucket_acl" {
  bucket = aws_s3_bucket.newrelic_aws_bucket.id
  acl    = "private"
}