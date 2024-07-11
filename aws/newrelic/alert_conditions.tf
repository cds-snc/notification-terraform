data "newrelic_entity" "notification-api-lambda" {
  name     = "api-lambda"
  provider = newrelic
  tag {
    key   = "env"
    value = var.env
  }
}

resource "newrelic_nrql_alert_condition" "external_services_callbacks_over_5_seconds_duration" {
  account_id = var.new_relic_account_id
  policy_id  = newrelic_alert_policy.terraform_notify_policy.id
  type       = "static"
  name       = "[External Services / Callbacks] Over 5 seconds duration"

  description = <<-EOT
  An API callback has a duration over 5 seconds. This has the potential to slow down the overall Celery processing of neighbors tasks such as database saving. Please investigate which service callback might be higher than the threshold and contact the service owner to look into the issue. If they cannot resolve in a timely manner, please remove their service's API URL callback. 

  You can identify the offending service(s) report by this alarm or via the ${var.env} errors dashboard: https://one.newrelic.com/dashboards/detail/${data.newrelic_entity.notification-api-lambda.guid}?account=${var.new_relic_account_id}
  EOT

  enabled                      = true
  violation_time_limit_seconds = 3600

  nrql {
    query = "SELECT max(duration) FROM Span WHERE service.name like 'notification-celery-${var.env}' AND http.url IS NOT NULL AND http.url not like '%amazonaws.com%' AND http.url not like '%notification.canada.ca%' AND name like 'External%' facet http.url"
  }

  critical {
    operator              = "above"
    threshold             = 10
    threshold_duration    = 60
    threshold_occurrences = "all"
  }
  fill_option        = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 120
}

resource "newrelic_nrql_alert_condition" "internal_services_awsnotify_over_5_seconds_duration" {
  account_id = var.new_relic_account_id
  policy_id  = newrelic_alert_policy.terraform_notify_policy.id
  type       = "static"
  name       = "[Internal Services / AWS+Notify] Over 5 seconds duration"

  description = <<-EOT
  An API callback has a duration over 5 seconds. This has the potential to slow down the overall Celery processing of neighbors tasks such as database saving. Please investigate which service callback might be higher than the threshold and contact the service owner to look into the issue. If they cannot resolve in a timely manner, please remove their service's API URL callback. 

  You can identify the offending service(s) report by this alarm or via the ${var.env} errors dashboard: https://one.newrelic.com/dashboards/detail/${data.newrelic_entity.notification-api-lambda.guid}?account=${var.new_relic_account_id}
  EOT

  enabled                      = true
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT max(duration) FROM Span WHERE service.name like 'notification-celery-${var.env}' AND http.url IS NOT NULL AND (http.url like '%amazonaws.com%' OR http.url like '%notification.canada.ca%') AND name like 'External%' facet http.url"
  }

  critical {
    operator              = "above"
    threshold             = 10
    threshold_duration    = 60
    threshold_occurrences = "all"
  }
  fill_option        = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 120
}

resource "newrelic_nrql_alert_condition" "lambda_api_error_count_anomaly_fuzzy_attack" {
  account_id                   = var.new_relic_account_id
  policy_id                    = newrelic_alert_policy.terraform_notify_policy.id
  type                         = "baseline"
  name                         = "[Lambda API] Error count anomaly (Fuzzy attack)"
  enabled                      = false
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT count(*) FROM AwsLambdaInvocationError WHERE (`entityGuid`='${data.newrelic_entity.notification-api-lambda.guid}') AND `error.class` IN ('app.authentication.auth:AuthError', 'app.v2.errors:BadRequestError', 'werkzeug.exceptions:MethodNotAllowed')"
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
  name                         = "[Lambda API] Error percentage (API User Errors)"
  enabled                      = true
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT percentage(count(*), WHERE `error.class` IS NOT null)*100 / percentage(count(*), WHERE duration IS NOT null) as 'Error rate (%); filtered' FROM AwsLambdaInvocation, AwsLambdaInvocationError WHERE `entityGuid`='${data.newrelic_entity.notification-api-lambda.guid}' AND `error.class` IN ('jsonschema.exceptions:ValidationError', 'sqlalchemy.exc:NoResultFound')"
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

resource "newrelic_nrql_alert_condition" "lambda_api_error_percentage_fuzzy_attack" {
  account_id                   = var.new_relic_account_id
  policy_id                    = newrelic_alert_policy.terraform_notify_policy.id
  type                         = "static"
  name                         = "[Lambda API] Error percentage (Fuzzy attack)"
  enabled                      = false
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT percentage(count(*), WHERE `error.class` IS NOT null)*100 / percentage(count(*), WHERE duration IS NOT null) as 'Error rate (%); filtered' FROM AwsLambdaInvocation, AwsLambdaInvocationError WHERE `entityGuid`='${data.newrelic_entity.notification-api-lambda.guid}' AND `error.class` IN ('app.authentication.auth:AuthError', 'app.v2.errors:BadRequestError', 'werkzeug.exceptions:MethodNotAllowed')"
  }

  warning {
    operator              = "above"
    threshold             = 15
    threshold_duration    = 600
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

resource "newrelic_nrql_alert_condition" "lambda_api_error_percentage_fuzzy_attack_anomaly_detection" {
  account_id = var.new_relic_account_id
  policy_id  = newrelic_alert_policy.terraform_notify_policy.id
  type       = "baseline"
  name       = "[Lambda API] Error percentage (Fuzzy attack) (Anomaly Detection)"

  description = <<-EOT
  Unusual fuzzy attack is detected. 
  EOT

  enabled                      = true
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT percentage(count(*), WHERE `error.class` IS NOT null)*100 / percentage(count(*), WHERE duration IS NOT null) as 'Error rate (%); filtered' FROM AwsLambdaInvocation, AwsLambdaInvocationError WHERE `entityGuid`='${data.newrelic_entity.notification-api-lambda.guid}' AND `error.class` IN ('app.authentication.auth:AuthError', 'app.v2.errors:BadRequestError', 'werkzeug.exceptions:MethodNotAllowed')"
  }

  critical {
    operator              = "above"
    threshold             = 5
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
  fill_option                    = "none"
  aggregation_window             = 60
  aggregation_method             = "event_flow"
  aggregation_delay              = 300
  expiration_duration            = 600
  open_violation_on_expiration   = false
  close_violations_on_expiration = true
  baseline_direction             = "upper_only"
}

resource "newrelic_nrql_alert_condition" "lambda_api_error_percentage_unexpected_errors" {
  account_id                   = var.new_relic_account_id
  policy_id                    = newrelic_alert_policy.terraform_notify_policy.id
  type                         = "static"
  name                         = "[Lambda API] Error percentage (Unexpected Errors)"
  enabled                      = true
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT percentage(count(*), WHERE `error.class` IS NOT null)*100 / percentage(count(*), WHERE duration IS NOT null) as 'Error rate (%); filtered' FROM AwsLambdaInvocation, AwsLambdaInvocationError WHERE `entityGuid`='${data.newrelic_entity.notification-api-lambda.guid}' AND `error.class` NOT IN ('app.authentication.auth:AuthError', 'app.v2.errors:BadRequestError','jsonschema.exceptions:ValidationError', 'sqlalchemy.exc:NoResultFound', 'werkzeug.exceptions:MethodNotAllowed') and error.message NOT LIKE '{\\'result\\': \\'error\\', \\'message\\': {\\'password\\': [\\'Incorrect password\\']}}'"
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
  name                         = "[Lambda API] Errors count anomaly (API User Errors)"
  enabled                      = true
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT count(*) FROM AwsLambdaInvocationError WHERE (`entityGuid`='${data.newrelic_entity.notification-api-lambda.guid}') AND `error.class` IN ('jsonschema.exceptions:ValidationError', 'sqlalchemy.exc:NoResultFound')"
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

resource "newrelic_nrql_alert_condition" "lambda_api_errors_count_anomaly_unexpected_errors" {
  account_id                   = var.new_relic_account_id
  policy_id                    = newrelic_alert_policy.terraform_notify_policy.id
  type                         = "baseline"
  name                         = "[Lambda API] Errors count anomaly (Unexpected Errors)"
  enabled                      = true
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT count(*) FROM AwsLambdaInvocationError WHERE (`entityGuid`='${data.newrelic_entity.notification-api-lambda.guid}') and error.class NOT IN ('app.v2.errors:BadRequestError','jsonschema.exceptions:ValidationError', 'sqlalchemy.exc:NoResultFound', 'app.authentication.auth:AuthError', 'werkzeug.exceptions:MethodNotAllowed') and error.message NOT LIKE '{\\'result\\': \\'error\\', \\'message\\': {\\'password\\': [\\'Incorrect password\\']}}'"
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
