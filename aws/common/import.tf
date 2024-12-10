import {
  to = aws_cloudwatch_metric_stream.newrelic_metric_stream[0]
  id = "newrelic-metric-stream-${var.env}"
}

import {
  to = aws_config_configuration_recorder_status.newrelic_recorder_status[0]
  id = var.aws_config_recorder_name
}

import {
  to = aws_iam_policy.newrelic_aws_permissions[0]
  id = "arn:aws:iam::${var.account_id}:policy/NewRelicCloudStreamReadPermissions-${var.env}"
}

import {
  to = aws_iam_role.firehose_newrelic_role[0]
  id = "firehose_newrelic_role_${var.env}"
}

import {
  to = aws_iam_role.metric_stream_to_firehose[0]
  id = "newrelic_metric_stream_to_firehose_role_${var.env}"
}

import {
  to = aws_iam_role.newrelic_aws_role[0]
  id = "NewRelicInfrastructure-Integrations-${var.env}"
}

import {
  to = aws_iam_role.newrelic_configuration_recorder[0]
  id = "newrelic_configuration_recorder-${var.env}"
}

import {
  to = aws_iam_role_policy.metric_stream_to_firehose[0]
  id = "newrelic_metric_stream_to_firehose_role_${var.env}:default"
}

import {
  to = aws_iam_role_policy.newrelic_configuration_recorder_s3[0]
  id = "newrelic_configuration_recorder-${var.env}:newrelic-configuration-recorder-s3-${var.env}"
}

import {
  to = aws_iam_role_policy_attachment.newrelic_aws_policy_attach[0]
  id = "NewRelicInfrastructure-Integrations-${var.env}/arn:aws:iam::aws:policy/ReadOnlyAccess"
}

import {
  to = aws_iam_role_policy_attachment.newrelic_configuration_recorder[0]
  id = "newrelic_configuration_recorder-${var.env}/arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

import {
  to = aws_kinesis_firehose_delivery_stream.newrelic_firehose_stream[0]
  id = "arn:aws:firehose:ca-central-1:${var.account_id}:deliverystream/newrelic_firehose_stream_${var.env}"
}

import {
  to = aws_s3_bucket.newrelic_aws_bucket[0]
  id = "newrelic-aws-bucket-${random_string.s3-bucket-name[0].id}"
}

import {
  to = aws_s3_bucket.newrelic_configuration_recorder_s3[0]
  id = "newrelic-configuration-recorder-${random_string.s3-bucket-name[0].id}"
}

import {
  to = aws_s3_bucket_ownership_controls.newrelic_ownership_controls[0]
  id = "newrelic-aws-bucket-${random_string.s3-bucket-name[0].id}"
}

import {
  to = newrelic_api_access_key.newrelic_aws_access_key[0]
  id = "5EA911F90B135B0D61DB4012CB0DC376CCC5017C98EB1688932254CDDAFD3443:USER"
}

import {
  to = newrelic_cloud_aws_integrations.newrelic_cloud_integration_pull[0]
  id = var.env == "dev" ? "242485" : "225924"
}

import {
  to = newrelic_cloud_aws_link_account.newrelic_cloud_integration_pull[0]
  id = var.env == "dev" ? "242485" : "225924"
}

import {
  to = newrelic_cloud_aws_link_account.newrelic_cloud_integration_push[0]
  id = var.env == "dev" ? "242484" : "225918"
}

import {
  to = random_string.s3-bucket-name[0]
  id = var.env == "dev" ? "fiskyzxf" : "9p5x8bkb"
}
