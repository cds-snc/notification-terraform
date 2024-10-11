# Note to maintainers:
# Updating alarms? Update the Google Sheet also!
# https://docs.google.com/spreadsheets/d/1gkrL3Trxw0xEkX724C1bwpfeRsTlK2X60wtCjF6MFRA/edit
#

resource "aws_cloudwatch_metric_alarm" "logs-1-500-error-1-minute-warning-pinpoint_to_sqs_sms_callbacks-api" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "logs-1-500-error-1-minute-warning-pinpoint_to_sqs_sms_callbacks-api"
  alarm_description   = "One 500 error in 1 minute for pinpoint_to_sqs_sms_callbacks api"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.pinpoint_to_sqs_sms_callbacks-500-errors-api[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.pinpoint_to_sqs_sms_callbacks-500-errors-api[0].metric_transformation[0].namespace
  period              = "60"
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_warning_arn]
  ok_actions          = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "logs-10-500-error-5-minutes-critical-pinpoint_to_sqs_sms_callbacks-api" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "logs-10-500-error-5-minutes-critical-pinpoint_to_sqs_sms_callbacks-api"
  alarm_description   = "Ten 500 errors in 5 minutes for pinpoint_to_sqs_sms_callbacks api"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.pinpoint_to_sqs_sms_callbacks-500-errors-api[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.pinpoint_to_sqs_sms_callbacks-500-errors-api[0].metric_transformation[0].namespace
  period              = "300"
  statistic           = "Sum"
  threshold           = 10
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_critical_arn]
  ok_actions          = [var.sns_alert_ok_arn]
}

resource "aws_cloudwatch_metric_alarm" "lambda-image-pinpoint-delivery-receipts-errors-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "lambda-image-pinpoint-delivery-receipts-errors-warning"
  alarm_description   = "5 errors on Lambda pinpoint-to-sqs-sms-callbacks in 10 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60 * 10
  statistic           = "Sum"
  threshold           = 5
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_warning_arn]
  ok_actions          = [var.sns_alert_ok_arn]
  dimensions = {
    FunctionName = module.pinpoint_to_sqs_sms_callbacks.function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "lambda-image-pinpoint-delivery-receipts-errors-critical" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "lambda-image-pinpoint-delivery-receipts-errors-critical"
  alarm_description   = "20 errors on Lambda pinpoint-to-sqs-sms-callbacks in 10 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60 * 10
  statistic           = "Sum"
  threshold           = 20
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_critical_arn]
  ok_actions          = [var.sns_alert_ok_arn]
  dimensions = {
    FunctionName = module.pinpoint_to_sqs_sms_callbacks.function_name
  }
}

resource "aws_cloudwatch_metric_alarm" "total-sms-spending-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "total-sms-spending-warning"
  alarm_description   = "SMS spending reached 80% of limit this month"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  threshold           = 0.8 * var.sms_monthly_spend_limit
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_warning_arn]

  metric_query {
    id          = "total_spend"
    expression  = "sns_spend + pinpoint_spend"
    label       = "Total SMS Monthly Spend"
    return_data = "true"
  }

  metric_query {
    id = "sns_spend"
    metric {
      metric_name = "SMSMonthToDateSpentUSD"
      namespace   = "AWS/SNS"
      period      = 300
      stat        = "Maximum"
    }
  }

  metric_query {
    id = "pinpoint_spend"
    metric {
      metric_name = "TextMessageMonthlySpend"
      namespace   = "AWS/SMSVoice"
      period      = 300
      stat        = "Maximum"
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "total-sms-spending-critical" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "total-sms-spending-critical"
  alarm_description   = "SMS spending reached 90% of limit this month"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  threshold           = 0.9 * var.sms_monthly_spend_limit
  treat_missing_data  = "notBreaching"
  alarm_actions       = [var.sns_alert_warning_arn]

  metric_query {
    id          = "total_spend"
    expression  = "sns_spend + pinpoint_spend"
    label       = "Total SMS Monthly Spend"
    return_data = "true"
  }

  metric_query {
    id = "sns_spend"
    metric {
      metric_name = "SMSMonthToDateSpentUSD"
      namespace   = "AWS/SNS"
      period      = 300
      stat        = "Maximum"
    }
  }

  metric_query {
    id = "pinpoint_spend"
    metric {
      metric_name = "TextMessageMonthlySpend"
      namespace   = "AWS/SMSVoice"
      period      = 300
      stat        = "Maximum"
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "pinpoint-sms-failures-bell-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "pinpoint-sms-failures-bell-warning"
  alarm_description   = "Pinpoint SMS failures are more than 50 for Bell Cellular Inc. / Aliant Telecom."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.pinpoint-sms-failures-carriers[0].metric_transformation[0].name
  namespace           = "LogMetrics"
  period              = "300"
  statistic           = "Sum"
  threshold           = "50" # 50 over a period of 5 minutes
  treat_missing_data  = "notBreaching"

  dimensions = {
    Carrier = "Bell Cellular Inc. / Aliant Telecom"
  }

  alarm_actions = [var.sns_alert_warning_arn]
  ok_actions    = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "pinpoint-sms-failures-bragg-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "pinpoint-sms-failures-bragg-warning"
  alarm_description   = "Pinpoint SMS failures are more than 50 for BRAGG Communications INC."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.pinpoint-sms-failures-carriers[0].metric_transformation[0].name
  namespace           = "LogMetrics"
  period              = "300"
  statistic           = "Sum"
  threshold           = "50" # 50 over a period of 5 minutes
  treat_missing_data  = "notBreaching"

  dimensions = {
    Carrier = "BRAGG Communications INC."
  }

  alarm_actions = [var.sns_alert_warning_arn]
  ok_actions    = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "pinpoint-sms-failures-freedom-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "pinpoint-sms-failures-freedom-warning"
  alarm_description   = "Pinpoint SMS failures are more than 50 for Freedom Mobile Inc."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.pinpoint-sms-failures-carriers[0].metric_transformation[0].name
  namespace           = "LogMetrics"
  period              = "300"
  statistic           = "Sum"
  threshold           = "50" # 50 over a period of 5 minutes
  treat_missing_data  = "notBreaching"

  dimensions = {
    Carrier = "Freedom Mobile Inc."
  }

  alarm_actions = [var.sns_alert_warning_arn]
  ok_actions    = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "pinpoint-sms-failures-iristel-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "pinpoint-sms-failures-iristel-warning"
  alarm_description   = "Pinpoint SMS failures are more than 50 for Iristel Inc."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.pinpoint-sms-failures-carriers[0].metric_transformation[0].name
  namespace           = "LogMetrics"
  period              = "300"
  statistic           = "Sum"
  threshold           = "50" # 50 over a period of 5 minutes
  treat_missing_data  = "notBreaching"

  dimensions = {
    Carrier = "Iristel Inc."
  }

  alarm_actions = [var.sns_alert_warning_arn]
  ok_actions    = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "pinpoint-sms-failures-maritime-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "pinpoint-sms-failures-maritime-warning"
  alarm_description   = "Pinpoint SMS failures are more than 50 for Maritime Telephone & Telegraph Ltd."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.pinpoint-sms-failures-carriers[0].metric_transformation[0].name
  namespace           = "LogMetrics"
  period              = "300"
  statistic           = "Sum"
  threshold           = "50" # 50 over a period of 5 minutes
  treat_missing_data  = "notBreaching"

  dimensions = {
    Carrier = "Maritime Telephone & Telegraph Ltd"
  }

  alarm_actions = [var.sns_alert_warning_arn]
  ok_actions    = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "pinpoint-sms-failures-mts-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "pinpoint-sms-failures-mts-warning"
  alarm_description   = "Pinpoint SMS failures are more than 50 for MTS Communications Inc."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.pinpoint-sms-failures-carriers[0].metric_transformation[0].name
  namespace           = "LogMetrics"
  period              = "300"
  statistic           = "Sum"
  threshold           = "50" # 50 over a period of 5 minutes
  treat_missing_data  = "notBreaching"

  dimensions = {
    Carrier = "MTS Communications Inc."
  }

  alarm_actions = [var.sns_alert_warning_arn]
  ok_actions    = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "pinpoint-sms-failures-rogers-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "pinpoint-sms-failures-rogers-warning"
  alarm_description   = "Pinpoint SMS failures are more than 50 for Rogers Communications Canada Inc."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.pinpoint-sms-failures-carriers[0].metric_transformation[0].name
  namespace           = "LogMetrics"
  period              = "300"
  statistic           = "Sum"
  threshold           = "50" # 50 over a period of 5 minutes
  treat_missing_data  = "notBreaching"

  dimensions = {
    Carrier = "Rogers Communications Canada Inc."
  }

  alarm_actions = [var.sns_alert_warning_arn]
  ok_actions    = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "pinpoint-sms-failures-telus-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "pinpoint-sms-failures-telus-warning"
  alarm_description   = "Pinpoint SMS failures are more than 50 for Telus Communications"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.pinpoint-sms-failures-carriers[0].metric_transformation[0].name
  namespace           = "LogMetrics"
  period              = "300"
  statistic           = "Sum"
  threshold           = "50" # 50 over a period of 5 minutes
  treat_missing_data  = "notBreaching"

  dimensions = {
    Carrier = "Telus Communications"
  }

  alarm_actions = [var.sns_alert_warning_arn]
  ok_actions    = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "pinpoint-sms-failures-videotron-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "pinpoint-sms-failures-videotron-warning"
  alarm_description   = "Pinpoint SMS failures are more than 50 for Videotron Ltd."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.pinpoint-sms-failures-carriers[0].metric_transformation[0].name
  namespace           = "LogMetrics"
  period              = "300"
  statistic           = "Sum"
  threshold           = "50" # 50 over a period of 5 minutes
  treat_missing_data  = "notBreaching"

  dimensions = {
    Carrier = "Videotron Ltd."
  }

  alarm_actions = [var.sns_alert_warning_arn]
  ok_actions    = [var.sns_alert_warning_arn]
}

resource "aws_cloudwatch_metric_alarm" "pinpoint-sms-success-rate-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "pinpoint-sms-success-rate-warning"
  alarm_description   = "Pinpoint SMS success rate is below 60% over 2 consecutive periods of 12 hours"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  datapoints_to_alarm = "2"
  threshold           = 60 / 100
  alarm_actions       = [var.sns_alert_warning_arn]
  treat_missing_data  = "notBreaching"

  metric_query {
    id          = "success_rate"
    expression  = "successes / (successes + failures)"
    label       = "Success Rate"
    return_data = "true"
  }

  metric_query {
    id = "successes"
    metric {
      metric_name = aws_cloudwatch_log_metric_filter.pinpoint-sms-successes[0].metric_transformation[0].name
      namespace   = aws_cloudwatch_log_metric_filter.pinpoint-sms-successes[0].metric_transformation[0].namespace
      period      = 60 * 60 * 12
      stat        = "Sum"
    }
  }

  metric_query {
    id = "failures"
    metric {
      metric_name = aws_cloudwatch_log_metric_filter.pinpoint-sms-failures[0].metric_transformation[0].name
      namespace   = aws_cloudwatch_log_metric_filter.pinpoint-sms-failures[0].metric_transformation[0].namespace
      period      = 60 * 60 * 12
      stat        = "Sum"
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "pinpoint-sms-success-rate-critical" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "pinpoint-sms-success-rate-critical"
  alarm_description   = "Pinpoint SMS success rate is below 25% over 2 consecutive periods of 12 hours"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  datapoints_to_alarm = "2"
  threshold           = 25 / 100
  alarm_actions       = [var.sns_alert_critical_arn]
  ok_actions          = [var.sns_alert_ok_arn]
  treat_missing_data  = "notBreaching"

  metric_query {
    id          = "success_rate"
    expression  = "successes / (successes + failures)"
    label       = "Success Rate"
    return_data = "true"
  }

  metric_query {
    id = "successes"
    metric {
      metric_name = aws_cloudwatch_log_metric_filter.pinpoint-sms-successes[0].metric_transformation[0].name
      namespace   = aws_cloudwatch_log_metric_filter.pinpoint-sms-successes[0].metric_transformation[0].namespace
      period      = 60 * 60 * 12
      stat        = "Sum"
    }
  }

  metric_query {
    id = "failures"
    metric {
      metric_name = aws_cloudwatch_log_metric_filter.pinpoint-sms-failures[0].metric_transformation[0].name
      namespace   = aws_cloudwatch_log_metric_filter.pinpoint-sms-failures[0].metric_transformation[0].namespace
      period      = 60 * 60 * 12
      stat        = "Sum"
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "pinpoint-sms-blocked-as-spam-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "pinpoint-sms-blocked-as-spam-warning"
  alarm_description   = "More than 10 Pinpoint SMS have been blocked as spam over 12 hours"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.pinpoint-sms-blocked-as-spam[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.pinpoint-sms-blocked-as-spam[0].metric_transformation[0].namespace
  period              = 60 * 60 * 12
  statistic           = "Sum"
  threshold           = 10
  alarm_actions       = [var.sns_alert_warning_arn]
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "pinpoint-sms-phone-carrier-unavailable-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "pinpoint-sms-phone-carrier-unavailable-warning"
  alarm_description   = "More than 100 Pinpoint SMS failed because a phone carrier is unavailable over 3 hours"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.pinpoint-sms-phone-carrier-unavailable[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.pinpoint-sms-phone-carrier-unavailable[0].metric_transformation[0].namespace
  period              = 60 * 60 * 3
  statistic           = "Sum"
  threshold           = 100
  alarm_actions       = [var.sns_alert_warning_arn]
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "pinpoint-sms-rate-exceeded-warning" {
  count               = var.cloudwatch_enabled ? 1 : 0
  alarm_name          = "pinpoint-sms-rate-exceeded-warning"
  alarm_description   = "At least 1 Pinpoint SMS rate exceeded error in 5 minutes"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.pinpoint-sms-rate-exceeded[0].metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.pinpoint-sms-rate-exceeded[0].metric_transformation[0].namespace
  period              = 60 * 5
  statistic           = "Sum"
  threshold           = 1
  alarm_actions       = [var.sns_alert_warning_arn]
  treat_missing_data  = "notBreaching"
}
