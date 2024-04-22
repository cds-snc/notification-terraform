resource "null_resource" "create_pools" {
  count      = var.bootstrap ? 1 : 0
  depends_on = [aws_iam_role.pinpoint_logs.arn, aws_cloudwatch_log_group.pinpoint_deliveries, aws_cloudwatch_log_group.pinpoint_deliveries_failures]

  provisioner "local-exec" {
    command = "scripts/create_pools.sh ${aws_iam_role.pinpoint_logs.arn} ${aws_cloudwatch_log_group.pinpoint_deliveries.arn} ${aws_cloudwatch_log_group.pinpoint_deliveries_failures.arn}"
  }
}
