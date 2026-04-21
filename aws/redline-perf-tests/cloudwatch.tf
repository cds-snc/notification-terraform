###
# CloudWatch Log Groups — Locust master and workers
###

resource "aws_cloudwatch_log_group" "locust_master" {
  name              = "/ecs/locust-redline/master"
  retention_in_days = 7

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
  }
}

resource "aws_cloudwatch_log_group" "locust_worker" {
  name              = "/ecs/locust-redline/worker"
  retention_in_days = 7

  tags = {
    (var.billing_tag_key) = var.billing_tag_value
  }
}
