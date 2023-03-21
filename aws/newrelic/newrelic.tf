

resource "newrelic_cloud_aws_link_account" "newrelic_cloud_integration_push" {
  arn = aws_iam_role.newrelic_aws_role.arn
  metric_collection_mode = "PUSH"
  name = "${var.NEW_RELIC_ACCOUNT_NAME} Push"
  depends_on = [aws_iam_role_policy_attachment.newrelic_aws_policy_attach]
}

resource "newrelic_api_access_key" "newrelic_aws_access_key" {
  account_id  = var.NEW_RELIC_ACCOUNT_ID
  key_type    = "INGEST"
  ingest_type = "LICENSE"
  name        = "Ingest License key"
  notes       = "AWS Cloud Integrations Firehost Key"
}

resource "aws_kinesis_firehose_delivery_stream" "newrelic_firehost_stream" {
  name        = "newrelic_firehost_stream"
  destination = "http_endpoint"

  s3_configuration {
    role_arn           = aws_iam_role.firehose_newrelic_role.arn
    bucket_arn         = aws_s3_bucket.newrelic_aws_bucket.arn
    buffer_size        = 10
    buffer_interval    = 400
    compression_format = "GZIP"
  }

  http_endpoint_configuration {
    url                = var.NEW_RELIC_CLOUDWATCH_ENDPOINT
    name               = "New Relic"
    access_key         = newrelic_api_access_key.newrelic_aws_access_key.key
    buffering_size     = 1
    buffering_interval = 60
    role_arn           = aws_iam_role.firehose_newrelic_role.arn
    s3_backup_mode     = "FailedDataOnly"

    request_configuration {
      content_encoding = "GZIP"
    }
  }
}

resource "aws_cloudwatch_metric_stream" "newrelic_metric_stream" {
  name          = "newrelic-metric-stream"
  role_arn      = aws_iam_role.metric_stream_to_firehose.arn
  firehose_arn  = aws_kinesis_firehose_delivery_stream.newrelic_firehost_stream.arn
  output_format = "opentelemetry0.7"
}

resource "newrelic_cloud_aws_link_account" "newrelic_cloud_integration_pull" {
  account_id = var.NEW_RELIC_ACCOUNT_ID
  arn = aws_iam_role.newrelic_aws_role.arn
  metric_collection_mode = "PULL"
  name = "${var.NEW_RELIC_ACCOUNT_NAME} Pull"
  depends_on = [aws_iam_role_policy_attachment.newrelic_aws_policy_attach]
}

resource "newrelic_cloud_aws_integrations" "foo" {
  account_id = var.NEW_RELIC_ACCOUNT_ID
  linked_account_id = newrelic_cloud_aws_link_account.newrelic_cloud_integration_pull.id
  billing {}
  cloudtrail {}
  health {}
  trusted_advisor {}
  vpc {}
  x_ray {}
}