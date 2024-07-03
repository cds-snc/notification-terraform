resource "newrelic_nrql_alert_condition" "tf_lambda_api_errors_count_anomaly_unexpected_errors" {
  account_id = 2691974
  policy_id = 2801728
  type = "baseline"
  name = "Terraform - [Lambda API] Errors count anomaly (Unexpected Errors)"
  enabled = true
  violation_time_limit_seconds = 86400

  nrql {
    query = "SELECT count(*) FROM AwsLambdaInvocationError WHERE (`entityGuid`='MjY5MTk3NHxJTkZSQXxOQXwtNzgwNDUyNTc5NzAyODI1NTcyNw') and error.class NOT IN ('app.v2.errors:BadRequestError','jsonschema.exceptions:ValidationError', 'sqlalchemy.exc:NoResultFound', 'app.authentication.auth:AuthError', 'werkzeug.exceptions:MethodNotAllowed') and error.message NOT LIKE '{\\'result\\': \\'error\\', \\'message\\': {\\'password\\': [\\'Incorrect password\\']}}'"
  }

  critical {
    operator = "above"
    threshold = 6
    threshold_duration = 300
    threshold_occurrences = "all"
  }

  warning {
    operator = "above"
    threshold = 3
    threshold_duration = 300
    threshold_occurrences = "all"
  }
  fill_option = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay = 300
  baseline_direction = "upper_and_lower"
}
