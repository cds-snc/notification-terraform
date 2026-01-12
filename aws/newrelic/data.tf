data "newrelic_entity" "notification-api-lambda" {
  count = var.enable_new_relic ? 1 : 0

  name     = "api-lambda"
  provider = newrelic
  tag {
    key   = "aws.accountId"
    value = var.account_id
  }
}

data "newrelic_entity" "notification-admin" {
  count = var.enable_new_relic ? 1 : 0

  name     = "notification-k8s-admin-${var.env}"
  provider = newrelic
}

data "newrelic_entity" "notification-api-k8s" {
  count = var.enable_new_relic ? 1 : 0

  name     = "notification-k8s-api-${var.env}"
  provider = newrelic
}