module "rds_activity_stream" {
  source = "github.com/cds-snc/terraform-modules//rds_activity_stream?ref=v9.3.0"

  rds_stream_name = "notification-canada-ca-${var.env}-cluster-activity-stream"
  rds_cluster_arn = aws_rds_cluster.notification-canada-ca.arn

  activity_log_retention_days = 7

  billing_tag_value = "notification-canada-ca-${var.env}"
}
