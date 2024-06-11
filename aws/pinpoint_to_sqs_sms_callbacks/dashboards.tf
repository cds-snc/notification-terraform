resource "aws_cloudwatch_dashboard" "pinpoint" {
  count          = var.cloudwatch_enabled ? 1 : 0
  dashboard_name = "Pinpoint"
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
                    [ "AWS/SQS", "ApproximateAgeOfOldestMessage", "QueueName", "eks-notification-canada-cadelivery-receipts" ]
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
                    [ "AWS/SQS", "ApproximateNumberOfMessagesVisible", "QueueName", "eks-notification-canada-cadelivery-receipts" ]
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
                    [ "NotificationCanadaCa", "${var.env}_notifications_celery_clients_sns_request-time", "metric_type", "timing" ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "stat": "p90",
                "period": 60,
                "title": "TODO CONVERT TO PINPOINT p90 SNS request time in ms",
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
                    [ "NotificationCanadaCa", "${var.env}_notifications_celery_tasks_process_sns_results", "metric_type", "counter" ]
                ],
                "view": "timeSeries",
                "stacked": true,
                "region": "${var.region}",
                "stat": "Sum",
                "period": 300,
                "title": "Celery: Number of SNS delivery receipts processed"
            }
        },
        {
            "height": 2,
            "width": 24,
            "y": 3,
            "x": 0,
            "type": "text",
            "properties": {
                "markdown": "\n# Sending SMS with SNS\n"
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
                "markdown": "\n## Limits\n- SNS [maximum sending rate](https://docs.aws.amazon.com/general/latest/gr/sns.html#limits_sns): 20 SMS/second\n- [Spending limit](https://${var.region}.console.aws.amazon.com/sns/v3/home?region=${var.region}#/mobile/text-messaging) of 30,000 USD/month\n\n## Message flow\nAfter a notification has been created in the database, Celery sends the SMS to the provider using the `deliver_sms` Celery task. This Celery task is assigned to the SQS queue [${var.celery_queue_prefix}send-sms-low](#/queues/https%3A%2F%2Fsqs.${var.region}.amazonaws.com%2F${var.account_id}%2F${var.celery_queue_prefix}send-sms-low), [${var.celery_queue_prefix}send-sms-medium](#/queues/https%3A%2F%2Fsqs.${var.region}.amazonaws.com%2F${var.account_id}%2F${var.celery_queue_prefix}send-sms-medium), or [${var.celery_queue_prefix}send-sms-high](#/queues/https%3A%2F%2Fsqs.${var.region}.amazonaws.com%2F${var.account_id}%2F${var.celery_queue_prefix}send-sms-high) depending on the SMS priority. This task calls the SNS API to send a text message.\n\n## SNS IDs\nSNS keeps track of SMS with a `messageId`, the value of SNS' `messageId` is stored in the `Notification` object in the `reference` column.\n\n## Logging\nCelery tasks output multiple messages when processing tasks/calling the SNS API, take a look at the relevant Celery code to know more.\n\nAfter an SMS has been sent by SNS, the delivery details are stored in CloudWatch Log groups:\n\n- [sns/${var.region}/${var.account_id}/DirectPublishToPhoneNumber](#logsV2:log-groups/log-group/sns$252F${var.region}$252F${var.account_id}$252FDirectPublishToPhoneNumber) for successful deliveries\n- [sns/${var.region}/${var.account_id}/DirectPublishToPhoneNumber/Failure](#logsV2:log-groups/log-group/sns$252F${var.region}$252F${var.account_id}$252FDirectPublishToPhoneNumber$252FFailure) for failures\n\n## Phone numbers\n\nSMS sent in `${var.region}` use random phone numbers managed by AWS.\n\n### ⚠️  SNS in `us-west-2`\nIf a Notify service has an inbound number attached, SMS will be sent with SNS using a long code phone number ordered on Pinpoint in the `us-west-2` region. Statistics for this region and alarms are **not visible on this dashboard**.\n"
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
                "markdown": "\n## Message flow\nAfter an SMS has been sent by SNS, the delivery details are stored in CloudWatch Log groups:\n\n- [sns/${var.region}/${var.account_id}/DirectPublishToPhoneNumber](#logsV2:log-groups/log-group/sns$252F${var.region}$252F${var.account_id}$252FDirectPublishToPhoneNumber) for successful deliveries\n- [sns/${var.region}/${var.account_id}/DirectPublishToPhoneNumber/Failure](#logsV2:log-groups/log-group/sns$252F${var.region}$252F${var.account_id}$252FDirectPublishToPhoneNumber$252FFailure) for failures\n\nThe log groups are subscribed the Lambda function [sns-to-sqs-sms-callbacks](#/functions/sns-to-sqs-sms-callbacks?tab=configuration). This Lambda adds messages to the SQS queue `delivery-receipts` to trigger the Celery task in charge of updating notifications in the database, `process-sns-result`.\n\nSee the relevant [AWS documentation](https://docs.aws.amazon.com/sns/latest/dg/sms_stats_cloudwatch.html#sns-viewing-cloudwatch-logs) for these messages.\n"
            }
        },
        {
            "height": 3,
            "width": 24,
            "y": 51,
            "x": 0,
            "type": "log",
            "properties": {
                "query": "SOURCE 'sns/${var.region}/${var.account_id}/PinpointDirectPublishToPhoneNumber/Failure' | fields @timestamp as Timestamp, notification.messageId as MessageID, status, delivery.destination as Destination, delivery.providerResponse as ProviderResponse\n| sort @timestamp desc\n| limit 20",
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
                "title": "TODO: Convert to Pinpoint p90 SMS sending time in seconds",
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
                "query": "SOURCE 'sns/${var.region}/${var.account_id}/DirectPublishToPhoneNumber/Failure' | SOURCE 'sns/${var.region}/${var.account_id}/PinpointDirectPublishToPhoneNumber' | stats avg(delivery.dwellTimeMsUntilDeviceAck / 1000 / 60) as Avg_carrier_time_minutes, count(*) as Number by delivery.phoneCarrier as Carrier",
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
                    [ "AWS/SQS", "ApproximateAgeOfOldestMessage", "QueueName", "eks-notification-canada-casend-sms-high", { "region": "${var.region}" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "title": "Approximate age of oldest message in send-sms-high",
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
                    [ "AWS/SQS", "ApproximateAgeOfOldestMessage", "QueueName", "eks-notification-canada-casend-sms-medium", { "region": "${var.region}" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "title": "Approximate age of oldest message in send-sms-medium",
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
                    [ "AWS/SQS", "ApproximateAgeOfOldestMessage", "QueueName", "eks-notification-canada-casend-sms-low", { "region": "${var.region}" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "title": "Approximate age of oldest message in send-sms-low",
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
                    [ "AWS/SQS", "ApproximateNumberOfMessagesVisible", "QueueName", "eks-notification-canada-casend-sms-high", { "region": "${var.region}" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "stat": "Average",
                "period": 60,
                "title": "Number of messages visible in send-sms-high"
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
                    [ "AWS/SQS", "ApproximateNumberOfMessagesVisible", "QueueName", "eks-notification-canada-casend-sms-low", { "region": "${var.region}" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "stat": "Average",
                "period": 60,
                "title": "Number of messages visible in send-sms-low"
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
                    [ "AWS/SQS", "ApproximateNumberOfMessagesVisible", "QueueName", "eks-notification-canada-casend-sms-medium", { "region": "${var.region}" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "stat": "Average",
                "period": 60,
                "title": "Number of messages visible in send-sms-medium"
            }
        }
    ]
}
EOF
}

