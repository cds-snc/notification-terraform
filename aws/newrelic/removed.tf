removed {
  from = aws_cloudwatch_metric_stream.newrelic_metric_stream

  lifecycle {
    destroy = false
  }
}

removed {
  from = aws_config_configuration_recorder_status.newrelic_recorder_status

  lifecycle {
    destroy = false
  }
}

removed {
  from = aws_iam_policy.newrelic_aws_permissions

  lifecycle {
    destroy = false
  }
}

removed {
  from = aws_iam_role.firehose_newrelic_role

  lifecycle {
    destroy = false
  }
}

removed {
  from = aws_iam_role.metric_stream_to_firehose

  lifecycle {
    destroy = false
  }
}

removed {
  from = aws_iam_role.newrelic_aws_role

  lifecycle {
    destroy = false
  }
}

removed {
  from = aws_iam_role.newrelic_configuration_recorder

  lifecycle {
    destroy = false
  }
}

removed {
  from = aws_iam_role_policy.metric_stream_to_firehose

  lifecycle {
    destroy = false
  }
}

removed {
  from = aws_iam_role_policy.newrelic_configuration_recorder_s3

  lifecycle {
    destroy = false
  }
}

removed {
  from = aws_iam_role_policy_attachment.newrelic_aws_policy_attach

  lifecycle {
    destroy = false
  }
}

removed {
  from = aws_iam_role_policy_attachment.newrelic_configuration_recorder

  lifecycle {
    destroy = false
  }
}

removed {
  from = aws_kinesis_firehose_delivery_stream.newrelic_firehose_stream

  lifecycle {
    destroy = false
  }
}

removed {
  from = aws_s3_bucket.newrelic_aws_bucket

  lifecycle {
    destroy = false
  }
}

removed {
  from = aws_s3_bucket.newrelic_configuration_recorder_s3

  lifecycle {
    destroy = false
  }
}

removed {
  from = aws_s3_bucket_ownership_controls.newrelic_ownership_controls

  lifecycle {
    destroy = false
  }
}

removed {
  from = newrelic_api_access_key.newrelic_aws_access_key

  lifecycle {
    destroy = false
  }
}

removed {
  from = newrelic_cloud_aws_integrations.newrelic_cloud_integration_pull

  lifecycle {
    destroy = false
  }
}
removed {

  from = newrelic_cloud_aws_link_account.newrelic_cloud_integration_pull

  lifecycle {
    destroy = false
  }
}

removed {
  from = newrelic_cloud_aws_link_account.newrelic_cloud_integration_push

  lifecycle {
    destroy = false
  }
}
