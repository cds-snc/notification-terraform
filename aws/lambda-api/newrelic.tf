module "newrelic_log_ingestion" {
  source         = "git::https://github.com/newrelic/aws-log-ingestion.git?ref=v2.6.5"
  nr_license_key = var.new_relic_license_key
}
