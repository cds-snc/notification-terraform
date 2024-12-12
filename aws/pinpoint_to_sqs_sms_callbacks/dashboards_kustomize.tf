resource "aws_cloudwatch_dashboard" "pinpoint" {
  count          = var.cloudwatch_enabled && var.env == "production" ? 1 : 0
  dashboard_name = "SMS-Pinpoint"
  dashboard_body = <<EOF
{
    "widgets": [
        {
            "height": 3,
            "width": 24,
            "y": 0,
            "x": 0,
            "type": "alarm",
            "properties": {
                "title": "Alarms",
                "alarms": [
                    "${aws_cloudwatch_metric_alarm.pinpoint-sms-success-rate-critical[0].arn}",
                    "${aws_cloudwatch_metric_alarm.pinpoint-sms-success-rate-warning[0].arn}",
                    "${var.sqs_send_sms_high_queue_delay_warning_arn}",
                    "${var.sqs_send_sms_high_queue_delay_critical_arn}",
                    "${var.sqs_send_sms_medium_queue_delay_warning_arn}",
                    "${var.sqs_send_sms_medium_queue_delay_critical_arn}",
                    "${var.sqs_send_sms_low_queue_delay_warning_arn}",
                    "${var.sqs_send_sms_low_queue_delay_critical_arn}",
                    "${aws_cloudwatch_metric_alarm.total-sms-spending-critical[0].arn}",
                    "${aws_cloudwatch_metric_alarm.total-sms-spending-warning[0].arn}"
                ]
            }
        },
        {
            "height": 6,
            "width": 9,
            "y": 5,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "LogMetrics", "pinpoint-sms-successes" ]
                ],
                "view": "timeSeries",
                "stacked": true,
                "region": "${var.region}",
                "stat": "Sum",
                "period": 300,
                "title": "SMS delivered per 5m"
            }
        },
        {
            "height": 6,
            "width": 9,
            "y": 11,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "LogMetrics", "pinpoint-sms-failures" ]
                ],
                "view": "timeSeries",
                "stacked": true,
                "region": "${var.region}",
                "stat": "Sum",
                "period": 300,
                "title": "SMS failures per 5m"
            }
        },
        {
            "height": 6,
            "width": 9,
            "y": 45,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/SQS", "ApproximateAgeOfOldestMessage", "QueueName", "${var.celery_queue_prefix}delivery-receipts" ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "title": "Approximate age of oldest message in delivery-receipts",
                "stat": "Average",
                "period": 60,
                "annotations": {
                    "horizontal": [
                        {
                            "color": "#ff7f0e",
                            "label": "Above 30s",
                            "value": 30,
                            "fill": "above"
                        },
                        {
                            "color": "#d62728",
                            "label": "Above 60s",
                            "value": 60,
                            "fill": "above"
                        }
                    ]
                }
            }
        },
        {
            "height": 6,
            "width": 9,
            "y": 45,
            "x": 9,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/SQS", "ApproximateNumberOfMessagesVisible", "QueueName", "${var.celery_queue_prefix}delivery-receipts" ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "stat": "Average",
                "period": 60,
                "title": "Number of messages visible in delivery-receipts"
            }
        },
        {
            "height": 6,
            "width": 9,
            "y": 11,
            "x": 9,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "NotificationCanadaCa", "${var.env}_notifications_celery_clients_pinpoint_request-time", "metric_type", "timing" ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "stat": "p90",
                "period": 60,
                "title": "p90 Pinpoint request time in ms",
                "annotations": {
                    "horizontal": [
                        {
                            "label": "Above 200ms",
                            "value": 0.2,
                            "fill": "above"
                        },
                        {
                            "label": "Above 100ms",
                            "value": 0.1,
                            "fill": "above"
                        }
                    ]
                }
            }
        },
        {
            "height": 6,
            "width": 9,
            "y": 39,
            "x": 9,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "NotificationCanadaCa", "${var.env}_notifications_celery_tasks_process_pinpoint_results", "metric_type", "counter" ]
                ],
                "view": "timeSeries",
                "stacked": true,
                "region": "${var.region}",
                "stat": "Sum",
                "period": 300,
                "title": "Celery: Number of Pinpoint delivery receipts processed"
            }
        },
        {
            "height": 2,
            "width": 24,
            "y": 3,
            "x": 0,
            "type": "text",
            "properties": {
                "markdown": "\n# Sending SMS with Pinpoint\n"
            }
        },
        {
            "height": 2,
            "width": 24,
            "y": 37,
            "x": 0,
            "type": "text",
            "properties": {
                "markdown": "\n# Delivery receipts\n"
            }
        },
        {
            "height": 6,
            "width": 9,
            "y": 39,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/Lambda", "Invocations", "FunctionName", "pinpoint-to-sqs-sms-callbacks" ],
                    [ ".", "Errors", ".", ".", { "color": "#d62728", "yAxis": "right" } ]
                ],
                "view": "timeSeries",
                "stacked": true,
                "region": "${var.region}",
                "stat": "Sum",
                "period": 300,
                "title": "Pinpoint Callback Lambda invocations per 5m"
            }
        },
        {
            "height": 18,
            "width": 6,
            "y": 5,
            "x": 18,
            "type": "text",
            "properties": {
                "markdown": "\n## Limits\n- [Spending limit](https://${var.region}.console.aws.amazon.com/sns/v3/home?region=${var.region}#/mobile/text-messaging) of 30,000 USD/month\n\n## Message flow\nAfter a notification has been created in the database, Celery sends the SMS to the provider using the `deliver_sms` Celery task. This Celery task is assigned to the SQS queue [${var.celery_queue_prefix}send-sms-low](#/queues/https%3A%2F%2Fsqs.${var.region}.amazonaws.com%2F${var.account_id}%2F${var.celery_queue_prefix}send-sms-low), [${var.celery_queue_prefix}send-sms-medium](#/queues/https%3A%2F%2Fsqs.${var.region}.amazonaws.com%2F${var.account_id}%2F${var.celery_queue_prefix}send-sms-medium), or [${var.celery_queue_prefix}send-sms-high](#/queues/https%3A%2F%2Fsqs.${var.region}.amazonaws.com%2F${var.account_id}%2F${var.celery_queue_prefix}send-sms-high) depending on the SMS priority. This task calls the SNS pr Pinpoint API to send a text message.\n\n## SMS IDs\nAWS keeps track of SMS with a `messageId`, the value of SNS' `messageId` is stored in the `Notification` object in the `reference` column.\n\n## Logging\nCelery tasks output multiple messages when processing tasks/calling the SNS/Pinpoint API, take a look at the relevant Celery code to know more.\n\nAfter an SMS has been sent by SNS, the delivery details are stored in CloudWatch Log groups:\n\n- [sns/${var.region}/${var.account_id}/DirectPublishToPhoneNumber](#logsV2:log-groups/log-group/sns$252F${var.region}$252F${var.account_id}$252FDirectPublishToPhoneNumber) for successful deliveries\n- [sns/${var.region}/${var.account_id}/DirectPublishToPhoneNumber/Failure](#logsV2:log-groups/log-group/sns$252F${var.region}$252F${var.account_id}$252FDirectPublishToPhoneNumber$252FFailure) for failures\n\n## Phone numbers\n\nSMS sent in `${var.region}` use phone numbers reserved for Notify's use\n\n### ⚠️  SNS in `us-west-2`\nIf a Notify service has an inbound number attached, SMS will be sent with SNS using a long code phone number ordered on Pinpoint in the `us-west-2` region. Statistics for this region and alarms are **not visible on this dashboard**.\n"
            }
        },
        {
            "height": 6,
            "width": 9,
            "y": 17,
            "x": 9,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "NotificationCanadaCa", "${var.env}_notifications_celery_tasks_deliver_sms", "metric_type", "counter" ]
                ],
                "view": "timeSeries",
                "stacked": true,
                "region": "${var.region}",
                "stat": "Sum",
                "period": 300,
                "title": "Number of deliver_sms Celery tasks per 5m"
            }
        },
        {
            "height": 9,
            "width": 6,
            "y": 39,
            "x": 18,
            "type": "text",
            "properties": {
                "markdown": "\n## Message flow\nAfter an SMS has been sent by Pinpoint, the delivery details are stored in CloudWatch Log groups:\n\n- [sns/${var.region}/${var.account_id}/PinpointDirectPublishToPhoneNumber](#logsV2:log-groups/log-group/sns$252F${var.region}$252F${var.account_id}$252FPinpointDirectPublishToPhoneNumber) for successful deliveries\n- [sns/${var.region}/${var.account_id}/PinpointDirectPublishToPhoneNumber/Failure](#logsV2:log-groups/log-group/sns$252F${var.region}$252F${var.account_id}$252FPinpointDirectPublishToPhoneNumber$252FFailure) for failures\n\nThe log groups are subscribed the Lambda function [pinpoint-to-sqs-sms-callbacks](#/functions/pinpoint-to-sqs-sms-callbacks?tab=configuration). This Lambda adds messages to the SQS queue `delivery-receipts` to trigger the Celery task in charge of updating notifications in the database, `process-pinpoint-result`.\n\nSee the relevant [AWS documentation](https://docs.aws.amazon.com/sns/latest/dg/sms_stats_cloudwatch.html#sns-viewing-cloudwatch-logs) for these messages.\n"
            }
        },
        {
            "height": 3,
            "width": 24,
            "y": 51,
            "x": 0,
            "type": "log",
            "properties": {
                "query": "SOURCE 'sns/${var.region}/${var.account_id}/PinpointDirectPublishToPhoneNumber/Failure' | fields @timestamp as Timestamp, messageId as MessageID, messageStatus as status, destinationPhoneNumber as Destination, messageStatusDescription as ProviderResponse\n| sort @timestamp desc\n| limit 20",
                "region": "${var.region}",
                "stacked": false,
                "view": "table",
                "title": "Pinpoint SMS Errors Log / ${var.region}"
            }
        },
        {
            "height": 6,
            "width": 9,
            "y": 5,
            "x": 9,
            "type": "metric",
            "properties": {
                "sparkline": true,
                "metrics": [
                    [ "NotificationCanadaCa", "${var.env}_notifications_celery_clients_sns_request-time", "metric_type", "timing", { "visible": false } ],
                    [ ".", "${var.env}_notifications_celery_sms_total-time", ".", "." ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "stat": "p90",
                "period": 60,
                "title": "SMS (SNS and Pinpoint) sending time in seconds",
                "annotations": {
                    "horizontal": [
                        {
                            "label": "Above 1 minute",
                            "value": 60,
                            "fill": "above"
                        },
                        {
                            "label": "Above 30 seconds",
                            "value": 30,
                            "fill": "above"
                        }
                    ]
                },
                "start": "-PT3H",
                "end": "P0D",
                "yAxis": {
                    "left": {
                        "min": 0,
                        "showUnits": false,
                        "label": "Sending time (sent_at - created_at)"
                    }
                },
                "setPeriodToTimeRange": true
            }
        },
        {
            "height": 6,
            "width": 24,
            "y": 63,
            "x": 0,
            "type": "log",
            "properties": {
                "query": "SOURCE 'sns/${var.region}/${var.account_id}/PinpointDirectPublishToPhoneNumber' | filter isFinal = 1 \n| stats avg((eventTimestamp - messageRequestTimestamp) / 1000 / 60) as Avg_carrier_time_minutes, count(*) as Number by carrierName as Carrier",
                "region": "${var.region}",
                "title": "Carrier Dwell Times",
                "view": "table"
            }
        },
        {
            "height": 6,
            "width": 24,
            "y": 57,
            "x": 0,
            "type": "log",
            "properties": {
                "query": "SOURCE 'sns/${var.region}/${var.account_id}/PinpointDirectPublishToPhoneNumber' | SOURCE 'sns/${var.region}/${var.account_id}/DirectPublishToPhoneNumber/Failure' | stats avg(delivery.dwellTimeMsUntilDeviceAck / 1000 / 60) as Avg_carrier_time_minutes by bin(30s)",
                "region": "${var.region}",
                "stacked": false,
                "view": "timeSeries",
                "title": "dwellTimeMsUntilDeviceAck"
            }
        },
        {
            "height": 6,
            "width": 8,
            "y": 25,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/SQS", "ApproximateAgeOfOldestMessage", "QueueName", "${var.celery_queue_prefix}${var.sqs_send_sms_high_queue_name}", { "region": "${var.region}" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "title": "Approximate age of oldest message in ${var.sqs_send_sms_high_queue_name}",
                "stat": "Average",
                "period": 60,
                "annotations": {
                    "horizontal": [
                        {
                            "color": "#ff7f0e",
                            "label": "Above 10 sec",
                            "value": 10,
                            "fill": "above"
                        },
                        {
                            "color": "#d62728",
                            "label": "Above 60 sec",
                            "value": 60,
                            "fill": "above"
                        }
                    ]
                },
                "yAxis": {
                    "left": {
                        "showUnits": true
                    }
                }
            }
        },
        {
            "height": 6,
            "width": 8,
            "y": 25,
            "x": 8,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/SQS", "ApproximateAgeOfOldestMessage", "QueueName", "${var.celery_queue_prefix}${var.sqs_send_sms_medium_queue_name}", { "region": "${var.region}" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "title": "Approximate age of oldest message in ${var.sqs_send_sms_medium_queue_name}",
                "stat": "Average",
                "period": 60,
                "annotations": {
                    "horizontal": [
                        {
                            "color": "#ff7f0e",
                            "label": "Above 10 min",
                            "value": 600,
                            "fill": "above"
                        },
                        {
                            "color": "#d62728",
                            "label": "Above 15 min",
                            "value": 900,
                            "fill": "above"
                        }
                    ]
                }
            }
        },
        {
            "height": 6,
            "width": 8,
            "y": 25,
            "x": 16,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/SQS", "ApproximateAgeOfOldestMessage", "QueueName", "${var.celery_queue_prefix}${var.sqs_send_sms_low_queue_name}", { "region": "${var.region}" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "title": "Approximate age of oldest message in ${var.sqs_send_sms_low_queue_name}",
                "stat": "Average",
                "period": 60,
                "annotations": {
                    "horizontal": [
                        {
                            "color": "#ff7f0e",
                            "label": "Above 10 min",
                            "value": 600,
                            "fill": "above"
                        },
                        {
                            "color": "#d62728",
                            "label": "Above 3 hours",
                            "value": 10800,
                            "fill": "above"
                        }
                    ]
                }
            }
        },
        {
            "height": 2,
            "width": 24,
            "y": 23,
            "x": 0,
            "type": "text",
            "properties": {
                "markdown": "\n# Delivery queues\n"
            }
        },
        {
            "height": 6,
            "width": 8,
            "y": 31,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/SQS", "ApproximateNumberOfMessagesVisible", "QueueName", "${var.celery_queue_prefix}${var.sqs_send_sms_high_queue_name}", { "region": "${var.region}" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "stat": "Average",
                "period": 60,
                "title": "Number of messages visible in ${var.sqs_send_sms_high_queue_name}"
            }
        },
        {
            "height": 6,
            "width": 8,
            "y": 31,
            "x": 16,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/SQS", "ApproximateNumberOfMessagesVisible", "QueueName", "${var.celery_queue_prefix}${var.sqs_send_sms_low_queue_name}", { "region": "${var.region}" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "stat": "Average",
                "period": 60,
                "title": "Number of messages visible in ${var.sqs_send_sms_low_queue_name}"
            }
        },
        {
            "height": 6,
            "width": 8,
            "y": 31,
            "x": 8,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/SQS", "ApproximateNumberOfMessagesVisible", "QueueName", "${var.celery_queue_prefix}${var.sqs_send_sms_medium_queue_name}", { "region": "${var.region}" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "stat": "Average",
                "period": 60,
                "title": "Number of messages visible in ${var.sqs_send_sms_medium_queue_name}"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 54,
            "width": 24,
            "height": 9,
            "properties": {
                "sparkline": true,
                "metrics": [
                    [ "LogMetrics", "pinpoint-sms-failures-carriers", "Carrier", "Bell Cellular Inc. / Aliant Telecom" ],
                    [ "LogMetrics", "pinpoint-sms-failures-carriers", "Carrier", "BRAGG Communications INC." ],
                    [ "LogMetrics", "pinpoint-sms-failures-carriers", "Carrier", "Chunghwa Telecom LDM" ],
                    [ "LogMetrics", "pinpoint-sms-failures-carriers", "Carrier", "Farmers Mutual Telephone Company Inc." ],
                    [ "LogMetrics", "pinpoint-sms-failures-carriers", "Carrier", "Freedom Mobile Inc." ],
                    [ "LogMetrics", "pinpoint-sms-failures-carriers", "Carrier", "Iristel Inc." ],
                    [ "LogMetrics", "pinpoint-sms-failures-carriers", "Carrier", "Maritime Telephone & Telegraph Ltd" ],
                    [ "LogMetrics", "pinpoint-sms-failures-carriers", "Carrier", "MTS Communications Inc." ],
                    [ "LogMetrics", "pinpoint-sms-failures-carriers", "Carrier", "Rogers Communications Canada Inc." ],
                    [ "LogMetrics", "pinpoint-sms-failures-carriers", "Carrier", "SK Telecom" ],
                    [ "LogMetrics", "pinpoint-sms-failures-carriers", "Carrier", "Taiwan Mobile Co Ltd." ],
                    [ "LogMetrics", "pinpoint-sms-failures-carriers", "Carrier", "Telus Communications" ],
                    [ "LogMetrics", "pinpoint-sms-failures-carriers", "Carrier", "TIM Celular S.A." ],
                    [ "LogMetrics", "pinpoint-sms-failures-carriers", "Carrier", "TURKCELL" ],
                    [ "LogMetrics", "pinpoint-sms-failures-carriers", "Carrier", "Videotron Ltd." ]
                ],
                "view": "singleValue",
                "stacked": false,
                "start": "-PT24H",
                "region": "ca-central-1",
                "yAxis": {
                    "left": {
                        "min": 0,
                        "max": 15
                    }
                },
                "stat": "Sum",
                "period": 86400,
                "title": "Carrier failures over the past day"
            }
        }
    ]
}
EOF
}

resource "aws_cloudwatch_dashboard" "sms-send-rate" {
  count          = var.cloudwatch_enabled && var.env == "production" ? 1 : 0
  dashboard_name = "Specialized-sms-send-rate"
  dashboard_body = <<EOF
{
    "widgets": [
        {
            "height": 6,
            "width": 8,
            "y": 0,
            "x": 0,
            "type": "log",
            "properties": {
                "query": "SOURCE 'sns/${var.region}/${var.account_id}/PinpointDirectPublishToPhoneNumber' | filter isFinal = 1 \n| stats sum(totalMessageParts) as fragments, count(*) as sms by datefloor(messageRequestTimestamp, 1m)",
                "region": "${var.region}",
                "stacked": false,
                "title": "SMS Send Rate Per Minute",
                "view": "timeSeries"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 6,
            "x": 12,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/SQS", "ApproximateAgeOfOldestMessage", "QueueName", "${var.celery_queue_prefix}${var.sqs_send_sms_high_queue_name}", { "region": "${var.region}", "label": "High" } ],
                    [ "AWS/SQS", "ApproximateAgeOfOldestMessage", "QueueName", "${var.celery_queue_prefix}${var.sqs_send_sms_medium_queue_name}", { "region": "${var.region}", "label": "Medium" } ],
                    [ "AWS/SQS", "ApproximateAgeOfOldestMessage", "QueueName", "${var.celery_queue_prefix}${var.sqs_send_sms_low_queue_name}", { "region": "${var.region}", "label": "Low" } ]
                ],
                "view": "singleValue",
                "stacked": false,
                "region": "${var.region}",
                "title": "SMS SQS Queues Delays",
                "period": 60,
                "stat": "Maximum",
                "sparkline": true
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 6,
            "x": 18,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "ContainerInsights/Prometheus", "kube_deployment_status_replicas_available", "namespace", "notification-canada-ca", "ClusterName", "notification-canada-ca-${var.env}-eks-cluster", "deployment", "celery-sms-send-primary", { "region": "${var.region}", "label": "celery-sms-send-primary" } ],
                    [ "ContainerInsights/Prometheus", "kube_deployment_status_replicas_available", "namespace", "notification-canada-ca", "ClusterName", "notification-canada-ca-${var.env}-eks-cluster", "deployment", "celery-sms-send-scalable", { "region": "${var.region}", "label": "celery-sms-send-scalable" } ]
                ],
                "sparkline": true,
                "view": "singleValue",
                "region": "${var.region}",
                "title": "Pods",
                "period": 60,
                "stat": "Maximum"
            }
        },
        {
            "height": 6,
            "width": 8,
            "y": 0,
            "x": 8,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "NotificationCanadaCa", "${var.env}_notifications_celery_sms_total-time", "metric_type", "timing", { "region": "${var.region}", "label": "time" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "title": "Average Notify SMS Send Time",
                "period": 60,
                "stat": "Average",
                "yAxis": {
                    "left": {
                        "showUnits": false,
                        "label": "seconds"
                    }
                }
            }
        },
        {
            "height": 6,
            "width": 12,
            "y": 6,
            "x": 0,
            "type": "log",
            "properties": {
                "query": "SOURCE '/aws/containerinsights/notification-canada-ca-${var.env}-eks-cluster/application' | fields @timestamp as Time, kubernetes.container_name as Deployment, log\n| filter kubernetes.container_name like /^celery-sms-send/\n| filter @message like /ERROR\\/.*Worker/ or @message like /ERROR\\/MainProcess/ \n| sort @timestamp desc\n",
                "region": "${var.region}",
                "stacked": false,
                "title": "SMS Sending Celery Errors",
                "view": "table"
            }
        },
        {
            "height": 6,
            "width": 8,
            "y": 0,
            "x": 16,
            "type": "log",
            "properties": {
                "query": "SOURCE '/aws/containerinsights/notification-canada-ca-${var.env}-eks-cluster/application' | fields @timestamp, log, kubernetes.container_name as app, kubernetes.pod_name as pod_name, @logStream\n| filter kubernetes.container_name like /^celery-sms/\n| filter @message like /succeeded/\n| fields strcontains(@message, 'Task deliver_throttled_sms') as is_throttled_sms\n| fields strcontains(@message, 'Task deliver_sms') as is_normal_sms\n| stats sum(is_normal_sms) as normal_sms, sum(is_throttled_sms) as throttled_sms by bin(1m)",
                "queryLanguage": "LOGSQL",
                "region": "${var.region}",
                "title": "Normal vs Throttled SMS",
                "view": "timeSeries",
                "stacked": false
            }
        },
        {
            "height": 6,
            "width": 24,
            "y": 12,
            "x": 0,
            "type": "text",
            "properties": {
                "markdown": "# Notes\n\n- send time will go up substantially while sending throttled SMS\n"
            }
        }
    ]
}
EOF
}
