###
# AWS S3 Buckets for Notification application
###

resource "aws_s3_bucket" "csv_bucket" {
  provider      = aws.core_services
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
  provider = aws.core_services
  bucket   = aws_s3_bucket.csv_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

module "csv_bucket_logs" {
  source = "github.com/cds-snc/terraform-modules//S3_log_bucket?ref=94729229cfcb754146c82a566227e55df6612228" # v11.3.5

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
  provider      = aws.core_services
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
  provider = aws.core_services
  bucket   = aws_s3_bucket.asset_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "legacy_asset_bucket" {
  provider      = aws.core_services
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
  provider = aws.core_services
  count    = var.env == "production" ? 1 : 0

  bucket = aws_s3_bucket.legacy_asset_bucket[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "document_bucket" {
  provider      = aws.core_services
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

  # Expire API link files after 7 days.
  lifecycle_rule {
    id      = "delete-api-link-7days"
    enabled = true
    prefix  = "api_link/"

    expiration {
      days = 7
    }
  }

  # Expire API attachments after 3 days.
  lifecycle_rule {
    id      = "delete-api-attachments-3days"
    enabled = true
    prefix  = "api_attachments/"

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
  provider      = aws.core_services
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

  # expire all files after 7 day
  lifecycle_rule {
    id      = "tf-s3-lifecycle-all-files"
    enabled = true

    expiration {
      days = 7
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
  provider = aws.core_services
  bucket   = aws_s3_bucket.document_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "scan_files_document_bucket" {
  provider = aws.core_services
  bucket   = aws_s3_bucket.scan_files_document_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

module "document_download_logs" {
  source = "github.com/cds-snc/terraform-modules//S3_log_bucket?ref=94729229cfcb754146c82a566227e55df6612228" # v11.3.5

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
  provider      = aws.core_services
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
  provider = aws.core_services
  bucket   = aws_s3_bucket.alb_log_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "alb_log_bucket_allow_elb_account" {
  provider = aws.core_services
  bucket   = aws_s3_bucket.alb_log_bucket.id

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
  provider      = aws.core_services
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
  provider = aws.core_services
  bucket   = aws_s3_bucket.athena_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

module "athena_logs_bucket" {
  source = "github.com/cds-snc/terraform-modules//S3_log_bucket?ref=94729229cfcb754146c82a566227e55df6612228" # v11.3.5

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
  source = "github.com/cds-snc/terraform-modules//S3_log_bucket?ref=94729229cfcb754146c82a566227e55df6612228" # v11.3.5
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
  source = "github.com/cds-snc/terraform-modules//S3?ref=94729229cfcb754146c82a566227e55df6612228" # v11.3.5

  bucket_name       = "notification-canada-ca-${var.env}-sms-usage-logs"
  force_destroy     = var.force_destroy_s3
  billing_tag_value = "notification-canada-ca-${var.env}"

  lifecycle_rule = { "lifecycle_rule" : { "enabled" : "true", "expiration" : { "days" : "7" } } }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_s3_bucket_policy" "sns_sms_usage_report_bucket_policy" {
  provider = aws.core_services
  bucket   = module.sns_sms_usage_report_bucket.s3_bucket_id

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
    aws = aws.core_services_us_west_2
  }

  source = "github.com/cds-snc/terraform-modules//S3?ref=94729229cfcb754146c82a566227e55df6612228" # v11.3.5

  bucket_name       = "notification-canada-ca-${var.env}-sms-usage-west-2-logs"
  force_destroy     = var.force_destroy_s3
  billing_tag_value = "notification-canada-ca-${var.env}"

  lifecycle_rule = { "lifecycle_rule" : { "enabled" : "true", "expiration" : { "days" : "7" } } }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_s3_bucket_policy" "sns_sms_usage_report_bucket_us_west_2_policy" {
  provider = aws.core_services_us_west_2

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
  source = "github.com/cds-snc/terraform-modules//S3?ref=94729229cfcb754146c82a566227e55df6612228" # v11.3.5

  bucket_name       = "notification-canada-ca-${var.env}-sms-usage-logs-san"
  force_destroy     = var.force_destroy_s3
  billing_tag_value = "notification-canada-ca-${var.env}"

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}


module "sns_sms_usage_report_sanitized_bucket_us_west_2" {
  providers = {
    aws = aws.core_services_us_west_2
  }

  source = "github.com/cds-snc/terraform-modules//S3?ref=94729229cfcb754146c82a566227e55df6612228" # v11.3.5

  bucket_name       = "notification-canada-ca-${var.env}-sms-usage-west-2-logs-san"
  force_destroy     = var.force_destroy_s3
  billing_tag_value = "notification-canada-ca-${var.env}"

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
}

resource "aws_s3_bucket" "gc_organisations_bucket" {
  provider      = aws.core_services
  bucket        = "notification-canada-ca-${var.env}-gc-organisations"
  force_destroy = var.force_destroy_s3

  logging {
    target_prefix = var.env
    target_bucket = module.csv_bucket_logs.s3_bucket_id
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }

  #tfsec:ignore:AWS002 - No logging enabled
  #tfsec:ignore:AWS077 - Versioning is not enabled
}

resource "aws_s3_bucket_public_access_block" "gc_organisations_bucket" {
  provider = aws.core_services
  bucket   = aws_s3_bucket.gc_organisations_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "reports_bucket" {
  provider      = aws.core_services
  bucket        = "notification-canada-ca-${var.env}-reports"
  force_destroy = var.force_destroy_s3

  lifecycle_rule {
    id      = "expire"
    enabled = true

    expiration {
      days = 3
    }
  }

  logging {
    target_prefix = var.env
    target_bucket = module.csv_bucket_logs.s3_bucket_id
  }

  tags = {
    CostCenter = "notification-canada-ca-${var.env}"
  }
  #checkov:skip=CKV_AWS_21:Versioning is not enabled for this bucket
  #checkov:skip=CKV2_AWS_62:Event notifications are not required for this bucket
}

resource "aws_s3_bucket_public_access_block" "reports_bucket" {
  provider = aws.core_services
  bucket   = aws_s3_bucket.reports_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
