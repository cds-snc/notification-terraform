resource "aws_cloudwatch_dashboard" "redis_batch_saving" {
  count          = var.cloudwatch_enabled ? 1 : 0
  dashboard_name = "Redis-batch-saving"
  dashboard_body = <<EOF
{
    "widgets": [
        {
            "height": 6,
            "width": 9,
            "y": 0,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "NotificationCanadaCa", "batch_saving_published", "list_name", "inbox:email:priority" ],
                    [ "...", "inbox:email:normal" ],
                    [ "...", "inbox:email:bulk" ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "stat": "Sum",
                "period": 300,
                "title": "Added to email inboxes"
            }
        },
        {
            "height": 6,
            "width": 9,
            "y": 0,
            "x": 9,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "NotificationCanadaCa", "batch_saving_published", "list_name", "inbox:sms:priority" ],
                    [ "...", "inbox:sms:normal" ],
                    [ "...", "inbox:sms:bulk" ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "stat": "Sum",
                "period": 300,
                "title": "Added to sms inboxes"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 6,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "NotificationCanadaCa", "batch_saving_inflight", "notification_type", "email", "created", "True", "priority", "priority", { "label": "created" } ],
                    [ "...", "acknowledged", ".", ".", ".", { "label": "acknowledged" } ],
                    [ "...", "expired", ".", ".", ".", { "label": "expired" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "stat": "Sum",
                "period": 300,
                "title": "Priority email inflights"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 6,
            "x": 6,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "NotificationCanadaCa", "batch_saving_inflight", "notification_type", "email", "created", "True", "priority", "normal", { "label": "created" } ],
                    [ "...", "acknowledged", ".", ".", ".", { "label": "acknowledged" } ],
                    [ "...", "expired", ".", ".", ".", { "label": "expired" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "stat": "Sum",
                "period": 300,
                "title": "Normal email inflights"
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
                    [ "NotificationCanadaCa", "batch_saving_inflight", "notification_type", "email", "created", "True", "priority", "bulk", { "label": "created" } ],
                    [ "...", "acknowledged", ".", ".", ".", { "label": "acknowledged" } ],
                    [ "...", "expired", ".", ".", ".", { "label": "expired" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "stat": "Sum",
                "period": 300,
                "title": "Bulk email inflights"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 12,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "NotificationCanadaCa", "batch_saving_inflight", "notification_type", "sms", "created", "True", "priority", "priority", { "label": "created" } ],
                    [ "...", "acknowledged", ".", ".", ".", { "label": "acknowledged" } ],
                    [ "...", "expired", ".", ".", ".", { "label": "expired" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "stat": "Sum",
                "period": 300,
                "title": "Priority sms inflights"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 12,
            "x": 6,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "NotificationCanadaCa", "batch_saving_inflight", "notification_type", "sms", "created", "True", "priority", "normal", { "label": "created" } ],
                    [ "...", "acknowledged", ".", ".", ".", { "label": "acknowledged" } ],
                    [ "...", "expired", ".", ".", ".", { "label": "expired" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "stat": "Sum",
                "period": 300,
                "title": "Normal sms inflights"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 12,
            "x": 12,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "NotificationCanadaCa", "batch_saving_inflight", "notification_type", "sms", "created", "True", "priority", "bulk", { "label": "created" } ],
                    [ "...", "acknowledged", ".", ".", ".", { "label": "acknowledged" } ],
                    [ "...", "expired", ".", ".", ".", { "label": "expired" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "stat": "Sum",
                "period": 300,
                "title": "Bulk sms inflights"
            }
        },
        {
            "height": 13,
            "width": 6,
            "y": 0,
            "x": 18,
            "type": "text",
            "properties": {
                "markdown": "# Description\n- Overview of notifications entering the system. This dashboard is meant to show the internal of the redis queues.\n- This dashboard shows us notifications which have not yet been saved to the database\n- NOTE: only notifications sent using the API are included here (`/sms` or `/email`).  \n- NOTE: Admin requests and posting to `/bulk` are not here.\n\n# Definitions\n- Inbox: a redis list that is the first entry of notifications into the system\n- Inflight: a subset of the inbox list that is about to be added to the database\n   - created: a group of messages taken out of the inbox and put together\n   - acknowledged: inflight notification has been added to our database and scheduled to be processed\n   - expired:  something went wrong and the inflight was never acknowledged (notification goes back to inbox)\n\n# Additional information\n- [Priority lanes adr](https://github.com/cds-snc/notification-adr/blob/main/records/2022-03-08.priority-lanes.md)\n\n# Todo\n- keeping track of oldest message in a particular queue (when it was added the first time vs. bouncing back and forth from inbox/inflights)"
            }
        }
    ]
}
EOF
}

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

resource "aws_cloudwatch_dashboard" "queues" {
  count          = var.cloudwatch_enabled ? 1 : 0
  dashboard_name = "Queues"
  dashboard_body = <<EOF
{
    "widgets": [
        {
            "height": 10,
            "width": 8,
            "y": 0,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/SQS", "NumberOfMessagesSent", "QueueName", "eks-notification-canada-cabulk-tasks" ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "setPeriodToTimeRange": true,
                "stat": "Sum",
                "period": 300,
                "title": "Bulk"
            }
        },
        {
            "height": 8,
            "width": 8,
            "y": 10,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/SQS", "NumberOfMessagesSent", "QueueName", "eks-notification-canada-cacelery" ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "stat": "Sum",
                "period": 3600,
                "title": "eks-notification-canada-cacelery: NumberOfMessagesSent"
            }
        },
        {
            "height": 10,
            "width": 8,
            "y": 0,
            "x": 16,
            "type": "text",
            "properties": {
                "markdown": "# Description\n- Queues dashboard - to see the flow of notifications through the queues compared to # of notifications we are sending\n- Identify bottlenecks in the system\n- This dashboard is intended to be high level, aggregates etc.\n\n# Queues\n- Redis queues: email/sms (bulk, normal, priority)\n- SQS: (bulk, normal, priority)\n\n# Todo\n- New chart -> traffic + total requests in queues, + age of oldest message in queues\n- Rename to \"Bottlenecks\" or \"Queues overview\"\n"
            }
        },
        {
            "height": 10,
            "width": 8,
            "y": 0,
            "x": 8,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/SQS", "NumberOfMessagesSent", "QueueName", "eks-notification-canada-ca-priority-database-tasks.fifo", { "region": "${var.region}" } ],
                    [ "...", "eks-notification-canada-ca-normal-database-tasks", { "region": "${var.region}" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "period": 300,
                "stat": "Sum",
                "title": "Normal / Priority"
            }
        }
    ]
}
EOF
}

resource "aws_cloudwatch_dashboard" "sms" {
  count          = var.cloudwatch_enabled ? 1 : 0
  dashboard_name = "SMS"
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
                    "${aws_cloudwatch_metric_alarm.sns-sms-success-rate-canadian-numbers-critical[0].arn}",
                    "${aws_cloudwatch_metric_alarm.sns-sms-success-rate-canadian-numbers-warning[0].arn}",
                    "${aws_cloudwatch_metric_alarm.sqs-send-sms-high-queue-delay-warning[0].arn}",
                    "${aws_cloudwatch_metric_alarm.sqs-send-sms-high-queue-delay-critical[0].arn}",
                    "${aws_cloudwatch_metric_alarm.sqs-send-sms-medium-queue-delay-warning[0].arn}",
                    "${aws_cloudwatch_metric_alarm.sqs-send-sms-medium-queue-delay-critical[0].arn}",
                    "${aws_cloudwatch_metric_alarm.sqs-send-sms-low-queue-delay-warning[0].arn}",
                    "${aws_cloudwatch_metric_alarm.sqs-send-sms-low-queue-delay-critical[0].arn}",
                    "${aws_cloudwatch_metric_alarm.sns-spending-critical[0].arn}",
                    "${aws_cloudwatch_metric_alarm.sns-spending-warning[0].arn}"
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
                    [ "AWS/SNS", "NumberOfNotificationsDelivered", "PhoneNumber", "PhoneNumberDirect" ]
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
                    [ "AWS/SNS", "NumberOfNotificationsFailed", "PhoneNumber", "PhoneNumberDirect", { "color": "#d62728" } ]
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
                "title": "p90 SNS request time in ms",
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
                    [ "AWS/Lambda", "Invocations", "FunctionName", "sns-to-sqs-sms-callbacks" ],
                    [ ".", "Errors", ".", ".", { "color": "#d62728", "yAxis": "right" } ]
                ],
                "view": "timeSeries",
                "stacked": true,
                "region": "${var.region}",
                "stat": "Sum",
                "period": 300,
                "title": "Lambda invocations per 5m"
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
            "y": 54,
            "x": 0,
            "type": "log",
            "properties": {
                "query": "SOURCE 'sns/us-west-2/${var.account_id}/DirectPublishToPhoneNumber/Failure' | fields @timestamp as Timestamp, notification.messageId as MessageID, status, delivery.destination as Destination, delivery.providerResponse as ProviderResponse\n| sort @timestamp desc\n| limit 20",
                "region": "us-west-2",
                "stacked": false,
                "title": "SMS Errors Log / us-west-2",
                "view": "table"
            }
        },
        {
            "height": 3,
            "width": 24,
            "y": 51,
            "x": 0,
            "type": "log",
            "properties": {
                "query": "SOURCE 'sns/${var.region}/${var.account_id}/DirectPublishToPhoneNumber/Failure' | fields @timestamp as Timestamp, notification.messageId as MessageID, status, delivery.destination as Destination, delivery.providerResponse as ProviderResponse\n| sort @timestamp desc\n| limit 20",
                "region": "${var.region}",
                "stacked": false,
                "view": "table",
                "title": "SMS Errors Log / ${var.region}"
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
                "title": "p90 SMS sending time in seconds",
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
                "query": "SOURCE 'sns/${var.region}/${var.account_id}/DirectPublishToPhoneNumber/Failure' | SOURCE 'sns/${var.region}/${var.account_id}/DirectPublishToPhoneNumber' | stats avg(delivery.dwellTimeMsUntilDeviceAck / 1000 / 60) as Avg_carrier_time_minutes, count(*) as Number by delivery.phoneCarrier as Carrier",
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
                "query": "SOURCE 'sns/${var.region}/${var.account_id}/DirectPublishToPhoneNumber' | SOURCE 'sns/${var.region}/${var.account_id}/DirectPublishToPhoneNumber/Failure' | stats avg(delivery.dwellTimeMsUntilDeviceAck / 1000 / 60) as Avg_carrier_time_minutes by bin(30s)",
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
        },
        {
            "height": 9,
            "width": 24,
            "y": 57,
            "x": 0,
            "type": "metric",
            "properties": {
                "sparkline": true,
                "metrics": [
                    [ "LogMetrics", "pinpoint-sms-failures-carriers", "Carrier", "Bell Cellular Inc. / Aliant Telecom" ],
                    [ "...", "BRAGG Communications INC." ],
                    [ "...", "Chunghwa Telecom LDM" ],
                    [ "...", "Farmers Mutual Telephone Company Inc." ],
                    [ "...", "Freedom Mobile Inc." ],
                    [ "...", "Iristel Inc." ],
                    [ "...", "Maritime Telephone & Telegraph Ltd" ],
                    [ "...", "MTS Communications Inc." ],
                    [ "...", "Rogers Communications Canada Inc." ],
                    [ "...", "SK Telecom" ],
                    [ "...", "Taiwan Mobile Co Ltd." ],
                    [ "...", "Telus Communications" ],
                    [ "...", "TIM Celular S.A." ],
                    [ "...", "TURKCELL" ],
                    [ "...", "Videotron Ltd." ]
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


resource "aws_cloudwatch_dashboard" "sensitive" {
  count          = var.cloudwatch_enabled ? 1 : 0
  dashboard_name = "Platform-admin-access-of-sensitive-services"
  dashboard_body = <<EOF
{
    "start": "-PT168H",
    "widgets": [
        {
            "height": 17,
            "width": 24,
            "y": 6,
            "x": 0,
            "type": "log",
            "properties": {
                "query": "SOURCE '/aws/containerinsights/notification-canada-ca-${var.env}-eks-cluster/application' | fields @timestamp, log\n| filter kubernetes.container_name like /admin/\n| filter log like /Sensitive/\n| filter log like /\\/service\\/[0-9a-f\\-]{36}\\//\n| parse log /(?<url>\\/service\\/.*) (?<admin>.*)\\|.*/\n| parse log \"Sensitive Admin API request * \" as request_type\n| display @timestamp, admin, url, request_type\n| sort request_type desc, @timestamp desc\n| limit 5000\n",
                "region": "${var.region}",
                "stacked": false,
                "title": "Details",
                "view": "table"
            }
        },
        {
            "height": 6,
            "width": 24,
            "y": 0,
            "x": 0,
            "type": "log",
            "properties": {
                "query": "SOURCE '/aws/containerinsights/notification-canada-ca-${var.env}-eks-cluster/application' | fields @timestamp, log \n| filter kubernetes.container_name like /admin/\n| filter log like /Sensitive/\n| filter log like /\\/service\\/[0-9a-f\\-]{36}\\//\n| parse log /service\\/(?<service>[0-9a-f\\-]*)\\/.* (?<admin>.*)\\|.*/\n| parse log \"Sensitive Admin API request * \" as request_type\n| stats count(*) as total by service, admin, request_type\n| sort request_type desc, total desc\n",
                "region": "${var.region}",
                "stacked": false,
                "title": "Summary ordered by total",
                "view": "table"
            }
        }
    ]
}
EOF
}
