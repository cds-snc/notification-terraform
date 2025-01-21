###
# AWS S3 Buckets for Notification application
###

resource "aws_s3_bucket" "csv_bucket" {
  bucket        = "notification-canada-ca-${var.env}-csv-upload"
  acl           = "private"
  force_destroy = var.force_destroy_s3
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    id      = "expire"
    enabled = true

    expiration {
      days = 7
    }
  }

  #tfsec:ignore:AWS077 - Versioning is not enabled
  logging {
    target_prefix = var.env
    target_bucket = module.csv_bucket_logs.s3_bucket_id
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_s3_bucket_public_access_block" "csv_bucket" {
  bucket = aws_s3_bucket.csv_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

module "csv_bucket_logs" {
  source = "github.com/cds-snc/terraform-modules//S3_log_bucket?ref=v6.1.5"

  bucket_name       = "notification-canada-ca-${var.env}-csv-upload-logs"
  force_destroy     = var.force_destroy_s3
  billing_tag_value = "notification-canada-ca-${var.env}"
  versioning_status = "Enabled"

  lifecycle_rule = { "lifecycle_rule" : { "enabled" : "true", "expiration" : { "days" : "90" } } }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_s3_bucket" "asset_bucket" {
  bucket        = "notification-canada-ca-${var.env}-asset-upload"
  force_destroy = var.force_destroy_s3
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }

  #tfsec:ignore:AWS002 - No logging enabled
  #tfsec:ignore:AWS077 - Versioning is not enabled
}

resource "aws_s3_bucket_public_access_block" "asset_bucket" {
  bucket = aws_s3_bucket.asset_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "legacy_asset_bucket" {
  count         = var.env == "production" ? 1 : 0
  bucket        = "notification-alpha-canada-ca-asset-upload"
  acl           = "private"
  force_destroy = var.force_destroy_s3

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }

  #tfsec:ignore:AWS002 - No logging enabled
  #tfsec:ignore:AWS077 - Versioning is not enabled
}

resource "aws_s3_bucket_public_access_block" "legacy_asset_bucket" {
  count = var.env == "production" ? 1 : 0

  bucket = aws_s3_bucket.legacy_asset_bucket[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "document_bucket" {
  bucket        = "notification-canada-ca-${var.env}-document-download"
  acl           = "private"
  force_destroy = var.force_destroy_s3

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  # expire linked files after 7 days
  lifecycle_rule {
    id      = "tf-s3-lifecycle-linked-files"
    enabled = true

    expiration {
      days = 7
    }
  }

  # Expire files attached directly to emails after a few days.
  # Those are stored in a `tmp/` folder.
  # See https://github.com/cds-snc/notification-document-download-api
  lifecycle_rule {
    id      = "tf-s3-lifecycle-attached-files"
    enabled = true
    prefix  = "tmp/"

    expiration {
      days = 3
    }
  }

  #tfsec:ignore:AWS077 - Versioning is not enabled
  logging {
    target_prefix = var.env
    target_bucket = module.document_download_logs.s3_bucket_id
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_s3_bucket" "scan_files_document_bucket" {
  bucket        = "notification-canada-ca-${var.env}-document-download-scan-files"
  acl           = "private"
  force_destroy = var.force_destroy_s3

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  # expire all files after 1 day
  lifecycle_rule {
    id      = "tf-s3-lifecycle-all-files"
    enabled = true

    expiration {
      days = 1
    }
  }

  #tfsec:ignore:AWS077 - Versioning is not enabled
  logging {
    target_prefix = var.env
    target_bucket = module.document_download_logs.s3_bucket_id
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_s3_bucket_public_access_block" "document_bucket" {
  bucket = aws_s3_bucket.document_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "scan_files_document_bucket" {
  bucket = aws_s3_bucket.scan_files_document_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

module "document_download_logs" {
  source = "github.com/cds-snc/terraform-modules//S3_log_bucket?ref=v6.1.5"

  bucket_name       = "notification-canada-ca-${var.env}-document-download-logs"
  force_destroy     = var.force_destroy_s3
  billing_tag_value = "notification-canada-ca-${var.env}"
  versioning_status = "Enabled"

  lifecycle_rule = { "lifecycle_rule" : { "enabled" : "true", "expiration" : { "days" : "90" } } }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_s3_bucket" "alb_log_bucket" {
  bucket        = "notification-canada-ca-${var.env}-alb-logs"
  acl           = "private"
  force_destroy = var.force_destroy_s3
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    enabled = true

    expiration {
      days = 90
    }
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }

  #tfsec:ignore:AWS002 - Ignore log of logs
  #tfsec:ignore:AWS077 - Versioning is not enabled
}

resource "aws_s3_bucket_public_access_block" "alb_log_bucket" {
  bucket = aws_s3_bucket.alb_log_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "alb_log_bucket_allow_elb_account" {
  bucket = aws_s3_bucket.alb_log_bucket.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.elb_account_ids[var.region]}:root"
      },
      "Action": "s3:PutObject",
      "Resource":"${aws_s3_bucket.alb_log_bucket.arn}/*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource":"${aws_s3_bucket.alb_log_bucket.arn}/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "${aws_s3_bucket.alb_log_bucket.arn}"
    }
  ]
}
POLICY
}

resource "aws_s3_bucket" "athena_bucket" {
  bucket        = "notification-canada-ca-${var.env}-athena"
  acl           = "private"
  force_destroy = var.force_destroy_s3
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    id      = "expire"
    enabled = true

    expiration {
      days = 7
    }
  }

  #tfsec:ignore:AWS077 - Versioning is not enabled
  logging {
    target_prefix = var.env
    target_bucket = module.athena_logs_bucket.s3_bucket_id
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_s3_bucket_public_access_block" "athena_bucket" {
  bucket = aws_s3_bucket.athena_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

module "athena_logs_bucket" {
  source = "github.com/cds-snc/terraform-modules//S3_log_bucket?ref=v6.1.5"

  bucket_name       = "notification-canada-ca-${var.env}-athena-logs"
  force_destroy     = var.force_destroy_s3
  billing_tag_value = "notification-canada-ca-${var.env}"
  versioning_status = "Enabled"

  lifecycle_rule = { "lifecycle_rule" : { "enabled" : "true", "expiration" : { "days" : "90" } } }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

module "cbs_logs_bucket" {
  source = "github.com/cds-snc/terraform-modules//S3_log_bucket?ref=v6.1.5"
  count  = var.create_cbs_bucket ? 1 : 0

  bucket_name                    = var.cbs_satellite_bucket_name
  force_destroy                  = var.force_destroy_s3
  billing_tag_value              = "notification-canada-ca-${var.env}"
  attach_lb_log_delivery_policy  = true
  attach_elb_log_delivery_policy = true
  versioning_status              = "Enabled"

  lifecycle_rule = { "lifecycle_rule" : { "enabled" : "true", "expiration" : { "days" : "90" } } }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

module "sns_sms_usage_report_bucket" {
  source = "github.com/cds-snc/terraform-modules//S3?ref=v9.6.4"

  bucket_name       = "notification-canada-ca-${var.env}-sms-usage-logs"
  force_destroy     = var.force_destroy_s3
  billing_tag_value = "notification-canada-ca-${var.env}"

  lifecycle_rule = { "lifecycle_rule" : { "enabled" : "true", "expiration" : { "days" : "7" } } }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_s3_bucket_policy" "sns_sms_usage_report_bucket_policy" {
  bucket = module.sns_sms_usage_report_bucket.s3_bucket_id

  policy = <<POLICY
{
	"Version": "2008-10-17",
	"Statement": [{
			"Sid": "AllowPutObject",
			"Effect": "Allow",
			"Principal": {
				"Service": "sns.amazonaws.com"
			},
			"Action": "s3:PutObject",
			"Resource": "arn:aws:s3:::${module.sns_sms_usage_report_bucket.s3_bucket_id}/*",
			"Condition": {
				"StringEquals": {
					"aws:SourceAccount": "${var.account_id}"
				},
				"ArnLike": {
					"aws:SourceArn": "arn:aws:sns:${var.region}:${var.account_id}:*"
				}
			}
		},
		{
			"Sid": "AllowGetBucketLocation",
			"Effect": "Allow",
			"Principal": {
				"Service": "sns.amazonaws.com"
			},
			"Action": "s3:GetBucketLocation",
			"Resource": "arn:aws:s3:::${module.sns_sms_usage_report_bucket.s3_bucket_id}",
			"Condition": {
				"StringEquals": {
					"aws:SourceAccount": "${var.account_id}"
				},
				"ArnLike": {
					"aws:SourceArn": "arn:aws:sns:${var.region}:${var.account_id}:*"
				}
			}
		},
		{
			"Sid": "AllowListBucket",
			"Effect": "Allow",
			"Principal": {
				"Service": "sns.amazonaws.com"
			},
			"Action": "s3:ListBucket",
			"Resource": "arn:aws:s3:::${module.sns_sms_usage_report_bucket.s3_bucket_id}",
			"Condition": {
				"StringEquals": {
					"aws:SourceAccount": "${var.account_id}"
				},
				"ArnLike": {
					"aws:SourceArn": "arn:aws:sns:${var.region}:${var.account_id}:*"
				}
			}
		}
	]
}
POLICY
}

module "sns_sms_usage_report_bucket_us_west_2" {
  providers = {
    aws = aws.us-west-2
  }

  source = "github.com/cds-snc/terraform-modules//S3?ref=v9.6.4"

  bucket_name       = "notification-canada-ca-${var.env}-sms-usage-west-2-logs"
  force_destroy     = var.force_destroy_s3
  billing_tag_value = "notification-canada-ca-${var.env}"

  lifecycle_rule = { "lifecycle_rule" : { "enabled" : "true", "expiration" : { "days" : "7" } } }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_s3_bucket_policy" "sns_sms_usage_report_bucket_us_west_2_policy" {
  provider = aws.us-west-2

  bucket = module.sns_sms_usage_report_bucket_us_west_2.s3_bucket_id

  policy = <<POLICY
{
	"Version": "2008-10-17",
	"Statement": [{
			"Sid": "AllowPutObject",
			"Effect": "Allow",
			"Principal": {
				"Service": "sns.amazonaws.com"
			},
			"Action": "s3:PutObject",
			"Resource": "arn:aws:s3:::${module.sns_sms_usage_report_bucket_us_west_2.s3_bucket_id}/*",
			"Condition": {
				"StringEquals": {
					"aws:SourceAccount": "${var.account_id}"
				},
				"ArnLike": {
					"aws:SourceArn": "arn:aws:sns:us-west-2:${var.account_id}:*"
				}
			}
		},
		{
			"Sid": "AllowGetBucketLocation",
			"Effect": "Allow",
			"Principal": {
				"Service": "sns.amazonaws.com"
			},
			"Action": "s3:GetBucketLocation",
			"Resource": "arn:aws:s3:::${module.sns_sms_usage_report_bucket_us_west_2.s3_bucket_id}",
			"Condition": {
				"StringEquals": {
					"aws:SourceAccount": "${var.account_id}"
				},
				"ArnLike": {
					"aws:SourceArn": "arn:aws:sns:us-west-2:${var.account_id}:*"
				}
			}
		},
		{
			"Sid": "AllowListBucket",
			"Effect": "Allow",
			"Principal": {
				"Service": "sns.amazonaws.com"
			},
			"Action": "s3:ListBucket",
			"Resource": "arn:aws:s3:::${module.sns_sms_usage_report_bucket_us_west_2.s3_bucket_id}",
			"Condition": {
				"StringEquals": {
					"aws:SourceAccount": "${var.account_id}"
				},
				"ArnLike": {
					"aws:SourceArn": "arn:aws:sns:us-west-2:${var.account_id}:*"
				}
			}
		}
	]
}
POLICY
}

module "sns_sms_usage_report_sanitized_bucket" {
  source = "github.com/cds-snc/terraform-modules//S3?ref=v9.6.4"

  bucket_name       = "notification-canada-ca-${var.env}-sms-usage-logs-san"
  force_destroy     = var.force_destroy_s3
  billing_tag_value = "notification-canada-ca-${var.env}"

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}


module "sns_sms_usage_report_sanitized_bucket_us_west_2" {
  providers = {
    aws = aws.us-west-2
  }

  source = "github.com/cds-snc/terraform-modules//S3?ref=v9.6.4"

  bucket_name       = "notification-canada-ca-${var.env}-sms-usage-west-2-logs-san"
  force_destroy     = var.force_destroy_s3
  billing_tag_value = "notification-canada-ca-${var.env}"

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_s3_bucket" "gc_organisations_bucket" {
  bucket        = "notification-canada-ca-${var.env}-gc-organisations"
  force_destroy = var.force_destroy_s3

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }

  #tfsec:ignore:AWS002 - No logging enabled
  #tfsec:ignore:AWS077 - Versioning is not enabled
}