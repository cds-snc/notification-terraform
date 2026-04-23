# Configuration sets — native Terraform resources
resource "aws_pinpointsmsvoicev2_configuration_set" "ca" {
  name = "pinpoint-configuration"
}

resource "aws_pinpointsmsvoicev2_configuration_set" "us_west_2" {
  provider = aws.us-west-2
  name     = "pinpoint-configuration"
}

# Pools and event destinations have no native Terraform resource — managed via script
resource "null_resource" "pinpoint_setup" {
  depends_on = [
    aws_pinpointsmsvoicev2_configuration_set.ca,
    aws_pinpointsmsvoicev2_configuration_set.us_west_2,
    aws_iam_role.pinpoint_logs,
  ]

  triggers = {
    script_sha = filesha256("${path.module}/create_pinpoint_pools.sh")
  }

  provisioner "local-exec" {
    command = "${path.module}/create_pinpoint_pools.sh ${aws_iam_role.pinpoint_logs.arn} ${aws_cloudwatch_log_group.pinpoint_deliveries.arn} ${aws_cloudwatch_log_group.pinpoint_deliveries_failures.arn} ${aws_cloudwatch_log_group.pinpoint_us_deliveries.arn} ${aws_cloudwatch_log_group.pinpoint_us_deliveries_failures.arn}"
  }
}

# Pool IDs — retrieved after creation, stored in Secrets Manager
data "external" "default_pool_id" {
  depends_on = [null_resource.pinpoint_setup]
  program    = ["${path.module}/helper_scripts/getDefaultPoolId.sh"]
}

data "external" "shortcode_pool_id" {
  depends_on = [null_resource.pinpoint_setup]
  program    = ["${path.module}/helper_scripts/getShortCodePoolId.sh"]
}

resource "aws_secretsmanager_secret" "pinpoint_default_pool_id" {
  name                    = "PINPOINT_DEFAULT_POOL_ID"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "pinpoint_default_pool_id" {
  secret_id     = aws_secretsmanager_secret.pinpoint_default_pool_id.id
  secret_string = data.external.default_pool_id.result.poolId
}

resource "aws_secretsmanager_secret" "pinpoint_shortcode_pool_id" {
  name                    = "PINPOINT_SHORT_CODE_POOL_ID"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "pinpoint_shortcode_pool_id" {
  secret_id     = aws_secretsmanager_secret.pinpoint_shortcode_pool_id.id
  secret_string = coalesce(data.external.shortcode_pool_id.result.poolId, data.external.default_pool_id.result.poolId)
}
