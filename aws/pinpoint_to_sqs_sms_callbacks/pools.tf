resource "null_resource" "create_pools" {
  depends_on = [aws_iam_role.pinpoint_logs, aws_cloudwatch_log_group.pinpoint_deliveries, aws_cloudwatch_log_group.pinpoint_deliveries_failures]

  provisioner "local-exec" {
    command = "scripts/create_pools.sh ${aws_iam_role.pinpoint_logs.arn} ${aws_cloudwatch_log_group.pinpoint_deliveries.arn} ${aws_cloudwatch_log_group.pinpoint_deliveries_failures.arn}"
  }
}
