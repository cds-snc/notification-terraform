data "aws_iam_policy_document" "newrelic_assume_policy" {
  count = var.enable_new_relic ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      // This is the unique identifier for New Relic account on AWS, there is no need to change this
      identifiers = [754728514883]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [var.new_relic_account_id]
    }
  }
}

resource "aws_iam_role" "newrelic_aws_role" {
  count              = var.enable_new_relic && var.env == "staging" ? 1 : 0
  name               = "NewRelicInfrastructure-Integrations-${var.env}"
  description        = "New Relic Cloud integration role"
  assume_role_policy = data.aws_iam_policy_document.newrelic_assume_policy[0].json
}

resource "aws_iam_policy" "newrelic_aws_permissions" {
  count       = var.enable_new_relic && var.env == "staging" ? 1 : 0
  name        = "NewRelicCloudStreamReadPermissions-${var.env}"
  description = ""
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "budgets:ViewBudget",
        "cloudtrail:LookupEvents",
        "config:BatchGetResourceConfig",
        "config:ListDiscoveredResources",
        "ec2:DescribeInternetGateways",
        "ec2:DescribeVpcs",
        "ec2:DescribeNatGateways",
        "ec2:DescribeVpcEndpoints",
        "ec2:DescribeSubnets",
        "ec2:DescribeNetworkAcls",
        "ec2:DescribeVpcAttribute",
        "ec2:DescribeRouteTables",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcPeeringConnections",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DescribeVpnConnections",
        "health:DescribeAffectedEntities",
        "health:DescribeEventDetails",
        "health:DescribeEvents",
        "tag:GetResources",
        "xray:BatchGet*",
        "xray:Get*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "newrelic_aws_policy_attach" {
  count      = var.enable_new_relic && var.env == "staging" ? 1 : 0
  role       = aws_iam_role.newrelic_aws_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "newrelic_cloud_aws_link_account" "newrelic_cloud_integration_push" {
  count                  = var.enable_new_relic && var.env == "staging" ? 1 : 0
  account_id             = var.new_relic_account_id
  arn                    = aws_iam_role.newrelic_aws_role[0].arn
  metric_collection_mode = "PUSH"
  name                   = "${var.env} metric stream"
  depends_on             = [aws_iam_role_policy_attachment.newrelic_aws_policy_attach]
}

resource "newrelic_api_access_key" "newrelic_aws_access_key" {
  count       = var.enable_new_relic && var.env == "staging" ? 1 : 0
  account_id  = var.new_relic_account_id
  key_type    = "INGEST"
  ingest_type = "LICENSE"
  name        = "Metric Stream Key for ${var.env}"
  notes       = "AWS Cloud Integrations Metric Stream Key"
}

resource "aws_iam_role" "firehose_newrelic_role" {
  count = var.enable_new_relic && var.env == "staging" ? 1 : 0
  name  = "firehose_newrelic_role_${var.env}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "random_string" "s3-bucket-name" {
  count   = var.enable_new_relic && var.env == "staging" ? 1 : 0
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket" "newrelic_aws_bucket" {
  count         = var.enable_new_relic && var.env == "staging" ? 1 : 0
  bucket        = "newrelic-aws-bucket-${random_string.s3-bucket-name[0].id}"
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "newrelic_ownership_controls" {
  count  = var.enable_new_relic && var.env == "staging" ? 1 : 0
  bucket = aws_s3_bucket.newrelic_aws_bucket[0].id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_kinesis_firehose_delivery_stream" "newrelic_firehose_stream" {
  count       = var.enable_new_relic && var.env == "staging" ? 1 : 0
  name        = "newrelic_firehose_stream_${var.env}"
  destination = "http_endpoint"
  http_endpoint_configuration {
    url                = var.newrelic_account_region == "US" ? "https://aws-api.newrelic.com/cloudwatch-metrics/v1" : "https://aws-api.eu01.nr-data.net/cloudwatch-metrics/v1"
    name               = "New Relic ${var.env}"
    access_key         = newrelic_api_access_key.newrelic_aws_access_key[0].key
    buffering_size     = 1
    buffering_interval = 60
    role_arn           = aws_iam_role.firehose_newrelic_role[0].arn
    s3_backup_mode     = "FailedDataOnly"
    s3_configuration {
      role_arn           = aws_iam_role.firehose_newrelic_role[0].arn
      bucket_arn         = aws_s3_bucket.newrelic_aws_bucket[0].arn
      buffering_size     = 10
      buffering_interval = 400
      compression_format = "GZIP"
    }
    request_configuration {
      content_encoding = "GZIP"
    }
  }
}

resource "aws_iam_role" "metric_stream_to_firehose" {
  count = var.enable_new_relic && var.env == "staging" ? 1 : 0
  name  = "newrelic_metric_stream_to_firehose_role_${var.env}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "streams.metrics.cloudwatch.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "metric_stream_to_firehose" {
  count = var.enable_new_relic && var.env == "staging" ? 1 : 0
  name  = "default"
  role  = aws_iam_role.metric_stream_to_firehose[0].id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "firehose:PutRecord",
                "firehose:PutRecordBatch"
            ],
            "Resource": "${aws_kinesis_firehose_delivery_stream.newrelic_firehose_stream[0].arn}"
        }
    ]
}
EOF
}

resource "aws_cloudwatch_metric_stream" "newrelic_metric_stream" {
  # Disabled for now
  count         = var.enable_new_relic && var.env == "staging" ? 1 : 0
  name          = "newrelic-metric-stream-${var.env}"
  role_arn      = aws_iam_role.metric_stream_to_firehose[0].arn
  firehose_arn  = aws_kinesis_firehose_delivery_stream.newrelic_firehose_stream[0].arn
  output_format = "opentelemetry0.7"
}

resource "newrelic_cloud_aws_link_account" "newrelic_cloud_integration_pull" {
  count                  = var.enable_new_relic && var.env == "staging" ? 1 : 0
  account_id             = var.new_relic_account_id
  arn                    = aws_iam_role.newrelic_aws_role[0].arn
  metric_collection_mode = "PULL"
  name                   = "${var.env} pull"
  depends_on             = [aws_iam_role_policy_attachment.newrelic_aws_policy_attach]
}

resource "newrelic_cloud_aws_integrations" "newrelic_cloud_integration_pull" {
  count             = var.env == "staging" ? 1 : 0
  account_id        = var.new_relic_account_id
  linked_account_id = newrelic_cloud_aws_link_account.newrelic_cloud_integration_pull[0].id

  lambda {}

}

resource "aws_s3_bucket" "newrelic_configuration_recorder_s3" {
  count         = var.enable_new_relic && var.env == "staging" ? 1 : 0
  bucket        = "newrelic-configuration-recorder-${random_string.s3-bucket-name[0].id}"
  force_destroy = true
}

resource "aws_iam_role" "newrelic_configuration_recorder" {
  count              = var.enable_new_relic && var.env == "staging" ? 1 : 0
  name               = "newrelic_configuration_recorder-${var.env}"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "config.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
      ]
    }
EOF
}

resource "aws_iam_role_policy" "newrelic_configuration_recorder_s3" {
  count = var.enable_new_relic && var.env == "staging" ? 1 : 0
  name  = "newrelic-configuration-recorder-s3-${var.env}"
  role  = aws_iam_role.newrelic_configuration_recorder[0].id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.newrelic_configuration_recorder_s3[0].arn}",
        "${aws_s3_bucket.newrelic_configuration_recorder_s3[0].arn}/*"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "newrelic_configuration_recorder" {
  count      = var.enable_new_relic && var.env == "staging" ? 1 : 0
  role       = aws_iam_role.newrelic_configuration_recorder[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}


resource "aws_config_configuration_recorder_status" "newrelic_recorder_status" {
  count      = var.enable_new_relic && var.env == "staging" ? 1 : 0
  name       = var.aws_config_recorder_name
  is_enabled = true
}
