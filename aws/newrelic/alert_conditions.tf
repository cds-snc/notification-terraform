resource "newrelic_nrql_alert_condition" "admin_error_percentage" {
  count = var.enable_new_relic ? 1 : 0

  account_id                   = var.new_relic_account_id
  policy_id                    = newrelic_alert_policy.terraform_notify_policy[0].id
  type                         = "static"
  name                         = "[Admin] Error percentage"
  enabled                      = false
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT ((filter(count(newrelic.timeslice.value), where metricTimesliceName = 'Errors/all') / filter(count(newrelic.timeslice.value), WHERE metricTimesliceName IN ('HttpDispatcher', 'OtherTransaction/all'))) OR 0) * 100 FROM Metric WHERE appId IN (${data.newrelic_entity.notification-admin[0].application_id}) AND metricTimesliceName IN ('Errors/all', 'HttpDispatcher', 'OtherTransaction/all', 'Agent/MetricsReported/count') FACET appId"
  }

  critical {
    operator              = "above"
    threshold             = 1
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  warning {
    operator              = "above"
    threshold             = 0.5
    threshold_duration    = 600
    threshold_occurrences = "all"
  }
  fill_option        = "static"
  fill_value         = 0
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 120
}

resource "newrelic_nrql_alert_condition" "admin_response_time" {
  count = var.enable_new_relic ? 1 : 0

  account_id                   = var.new_relic_account_id
  policy_id                    = newrelic_alert_policy.terraform_notify_policy[0].id
  type                         = "static"
  name                         = "[Admin] Response time"
  enabled                      = var.env == "production"
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT filter(average(newrelic.timeslice.value), WHERE metricTimesliceName = 'HttpDispatcher') OR 0 FROM Metric WHERE appId IN (${data.newrelic_entity.notification-admin[0].application_id}) AND metricTimesliceName IN ('HttpDispatcher', 'Agent/MetricsReported/count') FACET appId"
  }

  critical {
    operator              = "above"
    threshold             = 0.5
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  warning {
    operator              = "above"
    threshold             = 0.2
    threshold_duration    = 600
    threshold_occurrences = "all"
  }
  fill_option        = "static"
  fill_value         = 0
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 120
}

resource "newrelic_nrql_alert_condition" "k8s_api_error_percentage" {
  count = var.enable_new_relic ? 1 : 0

  account_id                   = var.new_relic_account_id
  policy_id                    = newrelic_alert_policy.terraform_notify_policy[0].id
  type                         = "static"
  name                         = "[k8s API] Error percentage"
  enabled                      = false
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT ((filter(count(newrelic.timeslice.value), where metricTimesliceName = 'Errors/all') / filter(count(newrelic.timeslice.value), WHERE metricTimesliceName IN ('HttpDispatcher', 'OtherTransaction/all'))) OR 0) * 100 FROM Metric WHERE appId IN (${data.newrelic_entity.notification-api-k8s[0].application_id}) AND metricTimesliceName IN ('Errors/all', 'HttpDispatcher', 'OtherTransaction/all', 'Agent/MetricsReported/count') FACET appId"
  }

  warning {
    operator              = "above"
    threshold             = 1
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  critical {
    operator              = "above"
    threshold             = 2
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
  count = var.enable_new_relic ? 1 : 0

  account_id                   = var.new_relic_account_id
  policy_id                    = newrelic_alert_policy.terraform_notify_policy[0].id
  type                         = "static"
  name                         = "[k8s API] Response time"
  enabled                      = false
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT filter(average(newrelic.timeslice.value), WHERE metricTimesliceName = 'HttpDispatcher') OR 0 FROM Metric WHERE appId IN (${data.newrelic_entity.notification-api-k8s[0].application_id}) AND metricTimesliceName IN ('HttpDispatcher', 'Agent/MetricsReported/count') FACET appId"
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
  count = var.enable_new_relic ? 1 : 0

  account_id                   = var.new_relic_account_id
  policy_id                    = newrelic_alert_policy.terraform_notify_policy[0].id
  type                         = "baseline"
  name                         = "[k8s API] Transaction database time"
  enabled                      = false
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT filter(average(newrelic.timeslice.value), WHERE metricTimesliceName = 'Datastore/all') OR 0 FROM Metric WHERE appId IN (${data.newrelic_entity.notification-api-k8s[0].application_id}) AND metricTimesliceName IN ('Datastore/all', 'Agent/MetricsReported/count') FACET appId"
  }

  critical {
    operator              = "above"
    threshold             = 2.81838
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  warning {
    operator              = "above"
    threshold             = 2.81838
    threshold_duration    = 180
    threshold_occurrences = "all"
  }
  fill_option        = "static"
  fill_value         = 0
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 120
  baseline_direction = "lower_only"
}


resource "newrelic_nrql_alert_condition" "external_services_callbacks_over_5_seconds_duration" {
  count = var.enable_new_relic ? 1 : 0

  account_id = var.new_relic_account_id
  policy_id  = newrelic_alert_policy.terraform_notify_policy[0].id
  type       = "static"
  name       = "[External Services / Callbacks] Over 5 seconds duration"

  description = <<-EOT
  An API callback has a duration over 5 seconds. This has the potential to slow down the overall Celery processing of neighbors tasks such as database saving. Please investigate which service callback might be higher than the threshold and contact the service owner to look into the issue. If they cannot resolve in a timely manner, please remove their service's API URL callback. 

  You can identify the offending service(s) report by this alarm or via the ${var.env} errors dashboard: https://one.newrelic.com/dashboards/detail/${data.newrelic_entity.notification-api-lambda[0].guid}?account=${var.new_relic_account_id}
  EOT

  enabled                      = var.env == "production"
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
  count = var.enable_new_relic ? 1 : 0

  account_id = var.new_relic_account_id
  policy_id  = newrelic_alert_policy.terraform_notify_policy[0].id
  type       = "static"
  name       = "[Internal Services / AWS+Notify] Over 5 seconds duration"

  description = <<-EOT
  An API callback has a duration over 5 seconds. This has the potential to slow down the overall Celery processing of neighbors tasks such as database saving. Please investigate which service callback might be higher than the threshold and contact the service owner to look into the issue. If they cannot resolve in a timely manner, please remove their service's API URL callback. 

  You can identify the offending service(s) report by this alarm or via the ${var.env} errors dashboard: https://one.newrelic.com/dashboards/detail/${data.newrelic_entity.notification-api-lambda[0].guid}?account=${var.new_relic_account_id}
  EOT

  enabled                      = var.env == "production"
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
  count = var.enable_new_relic ? 1 : 0

  account_id                   = var.new_relic_account_id
  policy_id                    = newrelic_alert_policy.terraform_notify_policy[0].id
  type                         = "baseline"
  name                         = "[Lambda API] Error count anomaly (Fuzzy attack)"
  enabled                      = false
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT count(*) FROM AwsLambdaInvocationError WHERE (`entityGuid`='${data.newrelic_entity.notification-api-lambda[0].guid}') AND `error.class` IN ('app.authentication.auth:AuthError', 'app.v2.errors:BadRequestError', 'werkzeug.exceptions:MethodNotAllowed')"
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
  count = var.enable_new_relic ? 1 : 0

  account_id                   = var.new_relic_account_id
  policy_id                    = newrelic_alert_policy.terraform_notify_policy[0].id
  type                         = "static"
  name                         = "[Lambda API] Error percentage (API User Errors)"
  enabled                      = false
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT percentage(count(*), WHERE `error.class` IS NOT null)*100 / percentage(count(*), WHERE duration IS NOT null) as 'Error rate (%); filtered' FROM AwsLambdaInvocation, AwsLambdaInvocationError WHERE `entityGuid`='${data.newrelic_entity.notification-api-lambda[0].guid}' AND `error.class` IN ('jsonschema.exceptions:ValidationError', 'sqlalchemy.exc:NoResultFound')"
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
  count = var.enable_new_relic ? 1 : 0

  account_id                   = var.new_relic_account_id
  policy_id                    = newrelic_alert_policy.terraform_notify_policy[0].id
  type                         = "static"
  name                         = "[Lambda API] Error percentage (Fuzzy attack)"
  enabled                      = false
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT percentage(count(*), WHERE `error.class` IS NOT null)*100 / percentage(count(*), WHERE duration IS NOT null) as 'Error rate (%); filtered' FROM AwsLambdaInvocation, AwsLambdaInvocationError WHERE `entityGuid`='${data.newrelic_entity.notification-api-lambda[0].guid}' AND `error.class` IN ('app.authentication.auth:AuthError', 'app.v2.errors:BadRequestError', 'werkzeug.exceptions:MethodNotAllowed')"
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
  count = var.enable_new_relic ? 1 : 0

  account_id = var.new_relic_account_id
  policy_id  = newrelic_alert_policy.terraform_notify_policy[0].id
  type       = "baseline"
  name       = "[Lambda API] Error percentage (Fuzzy attack) (Anomaly Detection)"

  description = <<-EOT
  Unusual fuzzy attack is detected. 
  EOT

  enabled                      = var.env == "production"
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT percentage(count(*), WHERE `error.class` IS NOT null)*100 / percentage(count(*), WHERE duration IS NOT null) as 'Error rate (%); filtered' FROM AwsLambdaInvocation, AwsLambdaInvocationError WHERE `entityGuid`='${data.newrelic_entity.notification-api-lambda[0].guid}' AND `error.class` IN ('app.authentication.auth:AuthError', 'app.v2.errors:BadRequestError', 'werkzeug.exceptions:MethodNotAllowed')"
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
  count = var.enable_new_relic ? 1 : 0

  account_id                   = var.new_relic_account_id
  policy_id                    = newrelic_alert_policy.terraform_notify_policy[0].id
  type                         = "static"
  name                         = "[Lambda API] Error percentage (Unexpected Errors)"
  enabled                      = false
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT percentage(count(*), WHERE `error.class` IS NOT null)*100 / percentage(count(*), WHERE duration IS NOT null) as 'Error rate (%); filtered' FROM AwsLambdaInvocation, AwsLambdaInvocationError WHERE `entityGuid`='${data.newrelic_entity.notification-api-lambda[0].guid}' AND `error.class` NOT IN ('app.authentication.auth:AuthError', 'app.v2.errors:BadRequestError','jsonschema.exceptions:ValidationError', 'sqlalchemy.exc:NoResultFound', 'werkzeug.exceptions:MethodNotAllowed') and error.message NOT LIKE '{\\'result\\': \\'error\\', \\'message\\': {\\'password\\': [\\'Incorrect password\\']}}'"
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
  count = var.enable_new_relic ? 1 : 0

  account_id                   = var.new_relic_account_id
  policy_id                    = newrelic_alert_policy.terraform_notify_policy[0].id
  type                         = "baseline"
  name                         = "[Lambda API] Errors count anomaly (API User Errors)"
  enabled                      = false
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT count(*) FROM AwsLambdaInvocationError WHERE (`entityGuid`='${data.newrelic_entity.notification-api-lambda[0].guid}') AND `error.class` IN ('jsonschema.exceptions:ValidationError', 'sqlalchemy.exc:NoResultFound')"
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
  count = var.enable_new_relic ? 1 : 0

  account_id                   = var.new_relic_account_id
  policy_id                    = newrelic_alert_policy.terraform_notify_policy[0].id
  type                         = "baseline"
  name                         = "[Lambda API] Errors count anomaly (Unexpected Errors)"
  enabled                      = false
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT count(*) FROM AwsLambdaInvocationError WHERE (`entityGuid`='${data.newrelic_entity.notification-api-lambda[0].guid}') and error.class NOT IN ('app.v2.errors:BadRequestError','jsonschema.exceptions:ValidationError', 'sqlalchemy.exc:NoResultFound', 'app.authentication.auth:AuthError', 'werkzeug.exceptions:MethodNotAllowed') and error.message NOT LIKE '{\\'result\\': \\'error\\', \\'message\\': {\\'password\\': [\\'Incorrect password\\']}}'"
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

resource "newrelic_nrql_alert_condition" "admin_monthly_ccu" {
  count = var.enable_new_relic && var.env == "production" ? 1 : 0

  account_id                   = var.new_relic_account_id
  policy_id                    = newrelic_alert_policy.terraform_notify_policy_by_condition[0].id
  type                         = "static"
  name                         = "[Admin] Monthly CCU"
  enabled                      = var.env == "production"
  violation_time_limit_seconds = 259200

  nrql {
    query = "FROM NrMTDConsumption select latest(consumption)  where metric = 'CoreCCU'"
  }

  critical {
    operator              = "above_or_equals"
    threshold             = 90 # 100 is the hard limit, set critical a bit lower at 90% capacity to allow for time to react
    threshold_duration    = 60
    threshold_occurrences = "at_least_once"
  }

  warning {
    operator              = "above_or_equals"
    threshold             = 70
    threshold_duration    = 60
    threshold_occurrences = "at_least_once"
  }
  fill_option        = "none"
  aggregation_window = 60
  aggregation_method = "event_timer"
  aggregation_timer  = 60
}

resource "newrelic_nrql_alert_condition" "admin_monthy_data_usage" {
  count = var.enable_new_relic && var.env == "production" ? 1 : 0

  account_id                   = var.new_relic_account_id
  policy_id                    = newrelic_alert_policy.terraform_notify_policy_by_condition[0].id
  type                         = "static"
  name                         = "[Admin] Monthy Data Usage"
  enabled                      = var.env == "production"
  violation_time_limit_seconds = 259200

  nrql {
    query = "FROM NrMTDConsumption SELECT latest(GigabytesIngested) WHERE productLine = 'DataPlatform'"
  }

  critical {
    operator              = "above_or_equals"
    threshold             = 3600 # 4000 is the hard limit, set critical a bit lower at 90% capacity to allow for time to react
    threshold_duration    = 60
    threshold_occurrences = "at_least_once"
  }

  warning {
    operator              = "above_or_equals"
    threshold             = 2800
    threshold_duration    = 60
    threshold_occurrences = "at_least_once"
  }
  fill_option        = "none"
  aggregation_window = 60
  aggregation_method = "event_timer"
  aggregation_timer  = 60
}
