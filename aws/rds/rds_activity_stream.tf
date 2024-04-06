#
# Creates an RDS activity stream for the cluster and stores its events
# in an S3 bucket for 7 days.
#
module "rds_activity_stream" {
  count = var.env != "production" ? 1 : 0 # Disable in prod until fully tested

  source = "github.com/cds-snc/terraform-modules//rds_activity_stream?ref=v9.3.1"

  rds_stream_name = "notification-canada-ca-${var.env}-cluster"
  rds_cluster_arn = aws_rds_cluster.notification-canada-ca.arn

  activity_log_retention_days = 7

  billing_tag_value = "notification-canada-ca-${var.env}"
}
