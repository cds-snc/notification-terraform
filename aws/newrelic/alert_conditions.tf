#TODO:  Check if we can extract the guids from the entities and use them in the queries, dynamically after we add the entities to code
locals {
  guid = var.env == "production" ? "MjY5MTk3NHxJTkZSQXxOQXwxMDg0NzM0MjU4MTkwNzk3NTQz" : "MjY5MTk3NHxJTkZSQXxOQXwtNzgwNDUyNTc5NzAyODI1NTcyNw"
}

resource "newrelic_nrql_alert_condition" "lambda_api_errors_count_anomaly_unexpected_errors" {

  account_id                   = var.new_relic_account_id
  policy_id                    = newrelic_alert_policy.terraform_notify_policy.id
  type                         = "baseline"
  name                         = "${var.env} - [Lambda API] Errors count anomaly (Unexpected Errors)"
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

resource "newrelic_nrql_alert_condition" "admin_error_percentage" {
  account_id                   = var.new_relic_account_id
  policy_id                    = newrelic_alert_policy.terraform_notify_policy.id
  type                         = "static"
  name                         = "${var.env} - [Admin] Error percentage"
  enabled                      = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT ((filter(count(newrelic.timeslice.value), where metricTimesliceName = 'Errors/all') / filter(count(newrelic.timeslice.value), WHERE metricTimesliceName IN ('HttpDispatcher', 'OtherTransaction/all'))) OR 0) * 100 FROM Metric WHERE appId IN (511399580) AND metricTimesliceName IN ('Errors/all', 'HttpDispatcher', 'OtherTransaction/all', 'Agent/MetricsReported/count') FACET appId"
  }

  warning {
    operator              = "above"
    threshold             = 0.5
    threshold_duration    = 600
    threshold_occurrences = "all"
  }

  critical {
    operator              = "above"
    threshold             = 1
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
  fill_option        = "static"
  fill_value         = 0
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 120
}

resource "newrelic_nrql_alert_condition" "admin_response_time" {
  account_id                   = var.new_relic_account_id
  policy_id                    = newrelic_alert_policy.terraform_notify_policy.id
  type                         = "static"
  name                         = "${var.env} - [Admin] Response time"
  enabled                      = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT filter(average(newrelic.timeslice.value), WHERE metricTimesliceName = 'HttpDispatcher') OR 0 FROM Metric WHERE appId IN (265796415) AND metricTimesliceName IN ('HttpDispatcher', 'Agent/MetricsReported/count') FACET appId"
  }

  warning {
    operator              = "above"
    threshold             = 0.2
    threshold_duration    = 600
    threshold_occurrences = "all"
  }

  critical {
    operator              = "above"
    threshold             = 0.5
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
  fill_option        = "static"
  fill_value         = 0
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 120
}

resource "newrelic_nrql_alert_condition" "k8s_api_error_percentage" {
  account_id                   = var.new_relic_account_id
  policy_id                    = newrelic_alert_policy.terraform_notify_policy.id
  type                         = "static"
  name                         = "${var.env} - [k8s API] Error percentage"
  enabled                      = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT ((filter(count(newrelic.timeslice.value), where metricTimesliceName = 'Errors/all') / filter(count(newrelic.timeslice.value), WHERE metricTimesliceName IN ('HttpDispatcher', 'OtherTransaction/all'))) OR 0) * 100 FROM Metric WHERE appId IN (265671177) AND metricTimesliceName IN ('Errors/all', 'HttpDispatcher', 'OtherTransaction/all', 'Agent/MetricsReported/count') FACET appId"
  }

  critical {
    operator              = "above"
    threshold             = 2
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  warning {
    operator              = "above"
    threshold             = 1
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
  fill_option        = "static"
  fill_value         = 0
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 120
}

resource "newrelic_nrql_alert_condition" "k8s_api_response_time" {
  account_id                   = var.new_relic_account_id
  policy_id                    = newrelic_alert_policy.terraform_notify_policy.id
  type                         = "static"
  name                         = "${var.env} - [k8s API] Response time"
  enabled                      = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT filter(average(newrelic.timeslice.value), WHERE metricTimesliceName = 'HttpDispatcher') OR 0 FROM Metric WHERE appId IN (265671177) AND metricTimesliceName IN ('HttpDispatcher', 'Agent/MetricsReported/count') FACET appId"
  }

  critical {
    operator              = "above"
    threshold             = 0.1
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  warning {
    operator              = "above"
    threshold             = 0.05
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
  fill_option        = "static"
  fill_value         = 0
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 120
}

resource "newrelic_nrql_alert_condition" "k8s_api_transaction_database_time" {
  account_id                   = var.new_relic_account_id
  policy_id                    = newrelic_alert_policy.terraform_notify_policy.id
  type                         = "baseline"
  name                         = "${var.env} - [k8s API] Transaction database time"
  enabled                      = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT filter(average(newrelic.timeslice.value), WHERE metricTimesliceName = 'Datastore/all') OR 0 FROM Metric WHERE appId IN (265671177) AND metricTimesliceName IN ('Datastore/all', 'Agent/MetricsReported/count') FACET appId"
  }

  critical {
    operator              = "above"
    threshold             = 6.91831
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  warning {
    operator              = "above"
    threshold             = 6.91831
    threshold_duration    = 120
    threshold_occurrences = "all"
  }
  fill_option        = "static"
  fill_value         = 0
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 120
  baseline_direction = "upper_only"
}

resource "newrelic_nrql_alert_condition" "lambda_api_error_count_anomaly_fuzzy_attack" {
  account_id                   = var.new_relic_account_id
  policy_id                    = newrelic_alert_policy.terraform_notify_policy.id
  type                         = "baseline"
  name                         = "${var.env} - [Lambda API] Error count anomaly (Fuzzy attack)"
  enabled                      = true
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT count(*) FROM AwsLambdaInvocationError WHERE (`entityGuid`='MjY5MTk3NHxJTkZSQXxOQXwtNzgwNDUyNTc5NzAyODI1NTcyNw') AND `error.class` IN ('app.authentication.auth:AuthError', 'app.v2.errors:BadRequestError', 'werkzeug.exceptions:MethodNotAllowed')"
  }

  critical {
    operator              = "above"
    threshold             = 8
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  warning {
    operator              = "above"
    threshold             = 5
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
  fill_option        = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 300
  baseline_direction = "upper_and_lower"
}

resource "newrelic_nrql_alert_condition" "lambda_api_error_percentage_api_user_errors" {
  account_id                   = var.new_relic_account_id
  policy_id                    = newrelic_alert_policy.terraform_notify_policy.id
  type                         = "static"
  name                         = "${var.env} - [Lambda API] Error percentage (API User Errors)"
  enabled                      = true
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT percentage(count(*), WHERE `error.class` IS NOT null)*100 / percentage(count(*), WHERE duration IS NOT null) as 'Error rate (%); filtered' FROM AwsLambdaInvocation, AwsLambdaInvocationError WHERE `entityGuid`='MjY5MTk3NHxJTkZSQXxOQXwtNzgwNDUyNTc5NzAyODI1NTcyNw' AND `error.class` IN ('jsonschema.exceptions:ValidationError', 'sqlalchemy.exc:NoResultFound')"
  }

  critical {
    operator              = "above"
    threshold             = 2
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  warning {
    operator              = "above"
    threshold             = 1
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
  fill_option        = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 300
}

resource "newrelic_nrql_alert_condition" "lambda_api_error_percentage_fuzzy_attack" {
  account_id                   = var.new_relic_account_id
  policy_id                    = newrelic_alert_policy.terraform_notify_policy.id
  type                         = "static"
  name                         = "${var.env} - [Lambda API] Error percentage (Fuzzy attack)"
  enabled                      = false
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT percentage(count(*), WHERE `error.class` IS NOT null)*100 / percentage(count(*), WHERE duration IS NOT null) as 'Error rate (%); filtered' FROM AwsLambdaInvocation, AwsLambdaInvocationError WHERE `entityGuid`='MjY5MTk3NHxJTkZSQXxOQXwtNzgwNDUyNTc5NzAyODI1NTcyNw' AND `error.class` IN ('app.authentication.auth:AuthError', 'app.v2.errors:BadRequestError', 'werkzeug.exceptions:MethodNotAllowed')"
  }

  critical {
    operator              = "above"
    threshold             = 15
    threshold_duration    = 600
    threshold_occurrences = "all"
  }

  warning {
    operator              = "above"
    threshold             = 15
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
  fill_option                    = "none"
  aggregation_window             = 60
  aggregation_method             = "event_flow"
  aggregation_delay              = 300
  expiration_duration            = 300
  open_violation_on_expiration   = false
  close_violations_on_expiration = true
}

resource "newrelic_nrql_alert_condition" "lambda_api_error_percentage_unexpected_errors" {
  account_id                   = var.new_relic_account_id
  policy_id                    = newrelic_alert_policy.terraform_notify_policy.id
  type                         = "static"
  name                         = "${var.env} - [Lambda API] Error percentage (Unexpected Errors)"
  enabled                      = true
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT percentage(count(*), WHERE `error.class` IS NOT null)*100 / percentage(count(*), WHERE duration IS NOT null) as 'Error rate (%); filtered' FROM AwsLambdaInvocation, AwsLambdaInvocationError WHERE `entityGuid`='MjY5MTk3NHxJTkZSQXxOQXwtNzgwNDUyNTc5NzAyODI1NTcyNw' AND `error.class` NOT IN ('app.authentication.auth:AuthError', 'app.v2.errors:BadRequestError','jsonschema.exceptions:ValidationError', 'sqlalchemy.exc:NoResultFound', 'werkzeug.exceptions:MethodNotAllowed') and error.message NOT LIKE '{\\'result\\': \\'error\\', \\'message\\': {\\'password\\': [\\'Incorrect password\\']}}'"
  }

  critical {
    operator              = "above"
    threshold             = 2
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  warning {
    operator              = "above"
    threshold             = 1
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
  fill_option                    = "none"
  aggregation_window             = 60
  aggregation_method             = "event_flow"
  aggregation_delay              = 300
  expiration_duration            = 300
  open_violation_on_expiration   = false
  close_violations_on_expiration = true
}

resource "newrelic_nrql_alert_condition" "lambda_api_errors_count_anomaly_api_user_errors" {
  account_id                   = var.new_relic_account_id
  policy_id                    = newrelic_alert_policy.terraform_notify_policy.id
  type                         = "baseline"
  name                         = "${var.env} - [Lambda API] Errors count anomaly (API User Errors)"
  enabled                      = true
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT count(*) FROM AwsLambdaInvocationError WHERE (`entityGuid`='MjY5MTk3NHxJTkZSQXxOQXwtNzgwNDUyNTc5NzAyODI1NTcyNw') AND `error.class` IN ('jsonschema.exceptions:ValidationError', 'sqlalchemy.exc:NoResultFound')"
  }

  critical {
    operator              = "above"
    threshold             = 12
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  warning {
    operator              = "above"
    threshold             = 6
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
  fill_option        = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 300
  baseline_direction = "upper_and_lower"
}
