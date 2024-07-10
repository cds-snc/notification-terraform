#TODO:  Check if we can extract the guids from the entities and use them in the queries, dynamically after we add the entities to code
locals {
  guid = var.env == "production" ? "MjY5MTk3NHxJTkZSQXxOQXwxMDg0NzM0MjU4MTkwNzk3NTQz" : "MjY5MTk3NHxJTkZSQXxOQXwtNzgwNDUyNTc5NzAyODI1NTcyNw"
}

resource "newrelic_nrql_alert_condition" "tf_lambda_api_errors_count_anomaly_unexpected_errors" {

  account_id                   = var.new_relic_account_id
  policy_id                    = newrelic_alert_policy.terraform_notify_policy.id
  type                         = "baseline"
  name                         = "${var.env} - Terraform - [Lambda API] Errors count anomaly (Unexpected Errors)"
  enabled                      = true
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT count(*) FROM AwsLambdaInvocationError WHERE (`entityGuid`='${local.guid}') and error.class NOT IN ('app.v2.errors:BadRequestError','jsonschema.exceptions:ValidationError', 'sqlalchemy.exc:NoResultFound', 'app.authentication.auth:AuthError', 'werkzeug.exceptions:MethodNotAllowed') and error.message NOT LIKE '{\\'result\\': \\'error\\', \\'message\\': {\\'password\\': [\\'Incorrect password\\']}}'"
  }

  critical {
    operator              = "above"
    threshold             = 6
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  warning {
    operator              = "above"
    threshold             = 3
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
  fill_option        = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 300
  baseline_direction = "upper_and_lower"
}
