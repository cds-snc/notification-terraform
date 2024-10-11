resource "null_resource" "create_pools" {
  depends_on = [aws_iam_role.pinpoint_logs, aws_cloudwatch_log_group.pinpoint_deliveries, aws_cloudwatch_log_group.pinpoint_deliveries_failures]

  provisioner "local-exec" {
    command = "./create_pinpoint_pools.sh ${aws_iam_role.pinpoint_logs.arn} ${aws_cloudwatch_log_group.pinpoint_deliveries[0].arn} ${aws_cloudwatch_log_group.pinpoint_deliveries_failures[0].arn}"
  }
}
