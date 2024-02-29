resource "aws_quicksight_data_source" "rds" {
  depends_on     = [aws_iam_role_policy_attachment.rds-qs-attach, aws_quicksight_account_subscription.subscription]
  data_source_id = var.database_name
  name           = "Quicksight RDS data source"
  ssl_properties {
    disable_ssl = false
  }
  credentials {
    credential_pair {
      username = var.quicksight_db_user_name
      password = var.quicksight_db_user_password
    }
  }
  vpc_connection_properties {
    vpc_connection_arn = aws_quicksight_vpc_connection.rds.arn
  }
  parameters {
    rds {
      database    = var.database_name
      instance_id = var.rds_instance_id
    }
  }
  type = "POSTGRESQL"
  permission {
    actions = [
      "quicksight:PassDataSource",
      "quicksight:DescribeDataSourcePermissions",
      "quicksight:UpdateDataSource",
      "quicksight:UpdateDataSourcePermissions",
      "quicksight:DescribeDataSource",
      "quicksight:DeleteDataSource"
    ]
    principal = aws_quicksight_group.dataset_owner.arn
  }
}

resource "aws_s3_object" "object" {
  bucket = s3.sns_sms_usage_report_bucket.bucket_name
  key    = "quicksight/s3-manifest-sms-usage.json"                  # replace with desired object key
  source = "aws/quicksight/s3-manifests.s3-manifest-sms-usage.json" # replace with path to local file
  acl    = "private"
}

resource "aws_quicksight_data_source" "s3_sms_usage" {
  data_source_id = "s3-sms-usage"
  name           = "SMS Usage Data Source"

  parameters {
    s3 {
      manifest_file_location {
        bucket = var.s3_bucket_sms_usage_id
        key    = "quicksight/s3-manifest-sms-usage.json"
      }
    }
  }

  type = "S3"
}
