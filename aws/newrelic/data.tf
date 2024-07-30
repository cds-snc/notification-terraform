data "newrelic_entity" "notification-api-lambda" {
  name     = "api-lambda"
  provider = newrelic
  tag {
    key   = "aws.accountId"
    value = var.account_id
  }
}

data "newrelic_entity" "notification-admin" {
  name     = "notification-admin-${var.env}"
  provider = newrelic
}

data "newrelic_entity" "notification-api-k8s" {
  name     = "notification-api-${var.env}"
  provider = newrelic
}