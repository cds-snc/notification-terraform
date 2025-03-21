resource "null_resource" "create_pools" {
  depends_on = [aws_iam_role.pinpoint_logs, aws_cloudwatch_log_group.pinpoint_deliveries, aws_cloudwatch_log_group.pinpoint_deliveries_failures]

  provisioner "local-exec" {
    command = "./create_pinpoint_pools.sh ${aws_iam_role.pinpoint_logs.arn} ${aws_cloudwatch_log_group.pinpoint_deliveries.arn} ${aws_cloudwatch_log_group.pinpoint_deliveries_failures.arn}"
  }
}

data "external" "get_default_pool_id" {
  # Get the Default Pool Id
  program = ["helper_scripts/getDefaultPoolId.sh"]

}

resource "aws_secretsmanager_secret" "pinpoint_default_pool_id" {
  name                    = "PINPOINT_DEFAULT_POOL_ID"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "pinpoint_default_pool_id" {
  secret_id     = aws_secretsmanager_secret.pinpoint_default_pool_id.id
  secret_string = data.external.get_default_pool_id.result.poolId
}

data "external" "get_short_code_pool_id" {
  # Get the short code pool id
  program = ["helper_scripts/getShortCodePoolId.sh"]

}

resource "aws_secretsmanager_secret" "pinpoint_shortcode_pool_id" {
  name                    = "PINPOINT_SHORT_CODE_POOL_ID"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "pinpoint_shortcode_pool_id" {
  secret_id     = aws_secretsmanager_secret.pinpoint_shortcode_pool_id.id
  secret_string = data.external.get_short_code_pool_id.result.poolId != "" ? data.external.get_short_code_pool_id.result.poolId : data.external.get_default_pool_id.result.poolId
}
