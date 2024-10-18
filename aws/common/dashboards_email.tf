resource "aws_cloudwatch_dashboard" "emails" {
  count          = var.cloudwatch_enabled ? 1 : 0
  dashboard_name = "Emails"
  dashboard_body = <<EOF
{
    "widgets": [
        {
            "height": 6,
            "width": 9,
            "y": 4,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/SES", "Send" ]
                ],
                "view": "timeSeries",
                "stacked": true,
                "region": "${var.region}",
                "stat": "Sum",
                "period": 300,
                "title": "Sent emails per 5mn",
                "liveData": true
            }
        },
        {
            "height": 4,
            "width": 24,
            "y": 0,
            "x": 0,
            "type": "alarm",
            "properties": {
                "title": "Email alarms",
                "alarms": [
                    "${aws_cloudwatch_metric_alarm.sqs-send-email-high-queue-delay-warning[0].arn}",
                    "${aws_cloudwatch_metric_alarm.sqs-send-email-high-queue-delay-critical[0].arn}",
                    "${aws_cloudwatch_metric_alarm.sqs-send-email-medium-queue-delay-warning[0].arn}",
                    "${aws_cloudwatch_metric_alarm.sqs-send-email-medium-queue-delay-critical[0].arn}",
                    "${aws_cloudwatch_metric_alarm.sqs-send-email-low-queue-delay-warning[0].arn}",
                    "${aws_cloudwatch_metric_alarm.sqs-send-email-low-queue-delay-critical[0].arn}",
                    "${aws_cloudwatch_metric_alarm.ses-bounce-rate-critical[0].arn}",
                    "${aws_cloudwatch_metric_alarm.ses-bounce-rate-warning[0].arn}",
                    "${aws_cloudwatch_metric_alarm.ses-complaint-rate-warning[0].arn}",
                    "${aws_cloudwatch_metric_alarm.ses-complaint-rate-critical[0].arn}",
                    "${aws_cloudwatch_metric_alarm.no-emails-sent-5-minutes-critical[0].arn}",
                    "${aws_cloudwatch_metric_alarm.no-emails-sent-5-minutes-warning[0].arn}"
                ]
            }
        },
        {
            "height": 6,
            "width": 9,
            "y": 4,
            "x": 9,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/SES", "Bounce", { "color": "#ff7f0e" } ]
                ],
                "view": "timeSeries",
                "stacked": true,
                "region": "${var.region}",
                "stat": "Sum",
                "period": 900,
                "title": "Bounces per 15mn"
            }
        },
        {
            "height": 6,
            "width": 9,
            "y": 10,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "NotificationCanadaCa", "${var.env}-time", "metric_type", "timing", { "id": "m1" } ]
                ],
                "view": "timeSeries",
                "stacked": true,
                "region": "${var.region}",
                "stat": "p90",
                "period": 300,
                "liveData": false,
                "title": "p90 SES requests time in ms",
                "yAxis": {
                    "left": {
                        "label": "s",
                        "showUnits": true
                    }
                }
            }
        },
        {
            "height": 6,
            "width": 8,
            "y": 24,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/SQS", "ApproximateAgeOfOldestMessage", "QueueName", "eks-notification-canada-casend-email-high", { "color": "#1f77b4", "region": "${var.region}", "label": "Age of oldest message" } ]
                ],
                "view": "timeSeries",
                "stacked": true,
                "region": "${var.region}",
                "stat": "Average",
                "period": 60,
                "title": "Average approximate age of oldest message in send-email-high",
                "annotations": {
                    "horizontal": [
                        {
                            "label": "60 sec",
                            "value": 60
                        },
                        {
                            "label": "20 sec",
                            "value": 20,
                            "fill": "above"
                        }
                    ]
                }
            }
        },
        {
            "height": 18,
            "width": 6,
            "y": 4,
            "x": 18,
            "type": "text",
            "properties": {
                "markdown": "\n# Sending emails\n\nEmails are sent with [SES](https://${var.region}.console.aws.amazon.com/ses/home?region=${var.region}#dashboard:).\n\nOur limits are:\n- 1,000,000 emails per 24 hour period\n- 100 emails/second\n\nEmails are sent by Celery through the `deliver_email` task through the [send-email-low](https://${var.region}.console.aws.amazon.com/sqs/v2/home?region=${var.region}#/queues/https%3A%2F%2Fsqs.${var.region}.amazonaws.com%2F${var.account_id}%2Feks-notification-canada-casend-email-low), [send-email-medium](https://${var.region}.console.aws.amazon.com/sqs/v2/home?region=${var.region}#/queues/https%3A%2F%2Fsqs.${var.region}.amazonaws.com%2F${var.account_id}%2Feks-notification-canada-casend-email-medium), or [send-email-high](https://${var.region}.console.aws.amazon.com/sqs/v2/home?region=${var.region}#/queues/https%3A%2F%2Fsqs.${var.region}.amazonaws.com%2F${var.account_id}%2Feks-notification-canada-casend-email-high) queues.\n\n## Message flow\n\nAfter a notification has been created in the database, Celery sends the email to the provider using the deliver_email Celery task. This Celery task is assigned to the send-email-low, send-email-medium, or send-email-high SQS queue depending on the email's priority. This task calls the AWS SES API to send a text message.\n\n## Delivery receipts\n\nReceipts from SES are dispatched to SNS -> [Lambda](https://${var.region}.console.aws.amazon.com/lambda/home?region=${var.region}#/functions/ses-to-sqs-email-callbacks) -> [SQS](https://${var.region}.console.aws.amazon.com/sqs/v2/home?region=${var.region}#/queues/https%3A%2F%2Fsqs.${var.region}.amazonaws.com%2F${var.account_id}%2Feks-notification-canada-cadelivery-receipts) in the `delivery-receipts` queue.\n\nA delay in this queue means that we are slow to process delivery receipts (delivered, bounce, complaints).\n"
            }
        },
        {
            "height": 6,
            "width": 9,
            "y": 16,
            "x": 9,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/SQS", "ApproximateAgeOfOldestMessage", "QueueName", "eks-notification-canada-cadelivery-receipts" ]
                ],
                "view": "timeSeries",
                "stacked": true,
                "region": "${var.region}",
                "stat": "Average",
                "period": 60,
                "title": "Approximate age of oldest message in delivery-receipts"
            }
        },
        {
            "height": 6,
            "width": 8,
            "y": 30,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/SQS", "ApproximateNumberOfMessagesVisible", "QueueName", "eks-notification-canada-casend-email-high", { "region": "${var.region}", "label": "Messages waiting in queue" } ],
                    [ ".", "ApproximateNumberOfMessagesNotVisible", ".", ".", { "region": "${var.region}", "label": "Messages in a celery worker" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "title": "Approximate number of messages in send-email-high",
                "period": 60,
                "stat": "Average"
            }
        },
        {
            "height": 6,
            "width": 9,
            "y": 16,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "NotificationCanadaCa", "${var.env}_notifications_celery_tasks_deliver_email", "metric_type", "counter" ]
                ],
                "view": "timeSeries",
                "stacked": true,
                "title": "Number of deliver_emails Celery tasks per 5m",
                "region": "${var.region}",
                "stat": "Sum",
                "period": 300
            }
        },
        {
            "height": 6,
            "width": 9,
            "y": 10,
            "x": 9,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "NotificationCanadaCa", "${var.env}_notifications_celery_tasks_process_ses_results", "metric_type", "counter" ]
                ],
                "view": "timeSeries",
                "stacked": true,
                "region": "${var.region}",
                "stat": "Sum",
                "period": 300,
                "title": "Celery: Number of SES delivery receipts processed"
            }
        },
        {
            "height": 6,
            "width": 8,
            "y": 36,
            "x": 8,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/SQS", "ApproximateNumberOfMessagesVisible", "QueueName", "eks-notification-canada-cabulk-tasks" ]
                ],
                "view": "timeSeries",
                "stacked": true,
                "region": "${var.region}",
                "stat": "Average",
                "period": 300,
                "title": "Number of messages visible in bulk-tasks"
            }
        },
        {
            "height": 6,
            "width": 8,
            "y": 36,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/SQS", "ApproximateNumberOfMessagesVisible", "QueueName", "eks-notification-canada-capriority-tasks" ]
                ],
                "view": "timeSeries",
                "stacked": true,
                "region": "${var.region}",
                "title": "Number of messages visible in priority-tasks",
                "stat": "Average",
                "period": 300
            }
        },
        {
            "height": 6,
            "width": 8,
            "y": 36,
            "x": 16,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/SQS", "ApproximateNumberOfMessagesVisible", "QueueName", "eks-notification-canada-caretry-tasks" ]
                ],
                "view": "timeSeries",
                "stacked": true,
                "region": "${var.region}",
                "stat": "Average",
                "period": 300,
                "title": "Number of messages visible in retry-tasks"
            }
        },
        {
            "height": 2,
            "width": 24,
            "y": 22,
            "x": 0,
            "type": "text",
            "properties": {
                "markdown": "# Delivery Queues\n"
            }
        },
        {
            "height": 6,
            "width": 8,
            "y": 24,
            "x": 8,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/SQS", "ApproximateAgeOfOldestMessage", "QueueName", "eks-notification-canada-casend-email-medium", { "color": "#1f77b4", "region": "${var.region}", "label": "Age of oldest message" } ]
                ],
                "view": "timeSeries",
                "stacked": true,
                "region": "${var.region}",
                "stat": "Average",
                "period": 60,
                "title": "Average approximate age of oldest message in send-email-medium",
                "annotations": {
                    "horizontal": [
                        {
                            "label": "45 min",
                            "value": 2700
                        },
                        {
                            "label": "30 min",
                            "value": 1800,
                            "fill": "above"
                        }
                    ]
                }
            }
        },
        {
            "height": 6,
            "width": 8,
            "y": 24,
            "x": 16,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/SQS", "ApproximateAgeOfOldestMessage", "QueueName", "eks-notification-canada-casend-email-low", { "color": "#1f77b4", "region": "${var.region}", "label": "Age of oldest message" } ]
                ],
                "view": "timeSeries",
                "stacked": true,
                "region": "${var.region}",
                "stat": "Average",
                "period": 60,
                "title": "Average approximate age of oldest message in send-email-low",
                "annotations": {
                    "horizontal": [
                        {
                            "label": "3 hours",
                            "value": 10800
                        },
                        {
                            "label": "1 hour",
                            "value": 3600,
                            "fill": "above"
                        }
                    ]
                }
            }
        },
        {
            "height": 6,
            "width": 8,
            "y": 30,
            "x": 8,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/SQS", "ApproximateNumberOfMessagesVisible", "QueueName", "eks-notification-canada-casend-email-medium", { "region": "${var.region}", "label": "Messages waiting in queue" } ],
                    [ ".", "ApproximateNumberOfMessagesNotVisible", ".", ".", { "region": "${var.region}", "label": "Messages in a celery worker" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "title": "Approximate number of messages in send-email-medium",
                "period": 60,
                "stat": "Average"
            }
        },
        {
            "height": 6,
            "width": 8,
            "y": 30,
            "x": 16,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/SQS", "ApproximateNumberOfMessagesVisible", "QueueName", "eks-notification-canada-casend-email-low", { "region": "${var.region}", "label": "Messages waiting in queue" } ],
                    [ ".", "ApproximateNumberOfMessagesNotVisible", ".", ".", { "region": "${var.region}", "label": "Messages in a celery worker" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "title": "Approximate number of messages in send-email-low",
                "period": 60,
                "stat": "Average"
            }
        }
    ]
}
EOF
}

resource "aws_cloudwatch_dashboard" "email-bounce_rate" {
  count          = var.cloudwatch_enabled ? 1 : 0
  dashboard_name = "Email_Bounce_Rate"
  dashboard_body = <<EOF
{
    "widgets": [
        {
            "height": 6,
            "width": 8,
            "y": 2,
            "x": 0,
            "type": "log",
            "properties": {
                "query": "SOURCE '/aws/containerinsights/notification-canada-ca-${var.env}-eks-cluster/application' | filter @message like \"bounce rate\"\n| parse log \"Service: * has met or exceeded a * bounce rate threshold of *. Bounce rate: *\" as service_id, bounce_type, threshold, bounce_rate\n| stats max(@timestamp) as latest_time, latest(bounce_rate) * 100 as latest_bounce_rate by service_id",
                "region": "${var.region}",
                "stacked": false,
                "title": "Recent high bounce rate services",
                "view": "table"
            }
        },
        {
            "height": 6,
            "width": 8,
            "y": 8,
            "x": 8,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/SES", "Reputation.BounceRate", { "stat": "Average", "region": "${var.region}" } ]
                ],
                "legend": {
                    "position": "hidden"
                },
                "region": "${var.region}",
                "liveData": false,
                "title": "SES reputation bounce rate",
                "view": "timeSeries",
                "stacked": false,
                "period": 900
            }
        },
        {
            "height": 6,
            "width": 8,
            "y": 2,
            "x": 8,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ { "expression": "100 * m1 / m2", "label": "Notify bounce rate", "id": "e1", "region": "${var.region}", "period": 900 } ],
                    [ "AWS/SES", "Bounce", { "color": "#1f77b4", "region": "${var.region}", "id": "m1", "visible": false } ],
                    [ ".", "Send", { "id": "m2", "region": "${var.region}", "yAxis": "right", "label": "Total sent", "visible": false } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "stat": "Sum",
                "period": 900,
                "title": "Notify bounce rate",
                "yAxis": {
                    "left": {
                        "label": "%",
                        "min": 0,
                        "showUnits": false
                    }
                },
                "legend": {
                    "position": "hidden"
                }
            }
        },
        {
            "height": 6,
            "width": 8,
            "y": 8,
            "x": 0,
            "type": "text",
            "properties": {
                "markdown": "# Notes\nThe Notify bounce rate is the percentage of emails from Notify that failed (for any reason).\n\nThe SES reputation bounce rate is a rolling score based on hard bounces (ie not including emails to addresses on our supression list).\n"
            }
        },
        {
            "height": 2,
            "width": 16,
            "y": 0,
            "x": 0,
            "type": "alarm",
            "properties": {
                "title": "Alarms",
                "alarms": [
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:logs-1-bounce-rate-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:ses-bounce-rate-warning",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:ses-bounce-rate-critical"
                ]
            }
        }
    ]
}
EOF
}
