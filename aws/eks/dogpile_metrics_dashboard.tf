resource "aws_cloudwatch_dashboard" "dogpile_cache" {
  provider       = aws.core_services
  count          = var.cloudwatch_enabled ? 1 : 0
  dashboard_name = "Notify-Dogpile-${var.env}"
  dashboard_body = templatefile("${path.module}/dogpile_metrics_dashboard.json.tftpl", {
    metric_prefix = "${var.env}_notifications_api"
    region        = var.region
  })
}