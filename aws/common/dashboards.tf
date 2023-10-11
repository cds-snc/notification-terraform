resource "aws_cloudwatch_dashboard" "notify_system" {
  count          = var.cloudwatch_enabled ? 1 : 0
  dashboard_name = "Notify-System-Overview"
  dashboard_body = <<EOF
{{
    "widgets": [
        {
            "height": 6,
            "width": 3,
            "y": 12,
            "x": 0,
            "type": "log",
            "properties": {
                "query": "SOURCE '/aws/containerinsights/notification-canada-ca-staging-eks-cluster/application' | fields kubernetes.namespace_name as Namespace\n| stats count(*) by Namespace\n| display Namespace\n",
                "region": "${var.region}",
                "stacked": false,
                "title": "Namespaces",
                "view": "table"
            }
        },
        {
            "height": 6,
            "width": 3,
            "y": 12,
            "x": 3,
            "type": "log",
            "properties": {
                "query": "SOURCE '/aws/containerinsights/notification-canada-ca-staging-eks-cluster/prometheus' | fields deployment as Deployment\n| filter ispresent(Deployment)\n| stats count(*) by Deployment\n| display Deployment",
                "region": "${var.region}",
                "stacked": false,
                "view": "table",
                "title": "Deployments"
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
                    [ "ContainerInsights/Prometheus", "kube_deployment_status_replicas_available", "namespace", "notification-canada-ca", "ClusterName", "notification-canada-ca-staging-eks-cluster", "deployment", "celery", { "region": "${var.region}" } ],
                    [ "...", "celery-sms-send", { "region": "${var.region}" } ]
                ],
                "sparkline": true,
                "view": "singleValue",
                "region": "${var.region}",
                "title": "Celery Replicas",
                "period": 60,
                "stat": "Maximum"
            }
        },
        {
            "height": 6,
            "width": 3,
            "y": 6,
            "x": 9,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/Lambda", "Invocations", "FunctionName", "api-lambda", { "region": "${var.region}", "color": "#b088f5" } ]
                ],
                "sparkline": true,
                "view": "singleValue",
                "region": "${var.region}",
                "title": "API Lambda Invocations",
                "period": 60,
                "stat": "Maximum"
            }
        },
        {
            "height": 6,
            "width": 13,
            "y": 12,
            "x": 6,
            "type": "log",
            "properties": {
                "query": "SOURCE '/aws/containerinsights/notification-canada-ca-staging-eks-cluster/application' | fields @timestamp as Time, kubernetes.pod_name as PodName, log\n| filter kubernetes.container_name like /^celery/\n| filter @message like /ERROR\\/.*Worker/\n| sort @timestamp desc\n| limit 20\n",
                "region": "${var.region}",
                "stacked": false,
                "title": "Celery Errors",
                "view": "table"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 0,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ { "expression": "FILL(METRICS(), 0)", "label": "Expression1", "id": "e1" } ],
                    [ "AWS/SES", "Send", { "region": "${var.region}", "id": "m1", "color": "#08aad2" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "period": 60,
                "stat": "Sum",
                "title": "Email Send Rate Per Minute",
                "legend": {
                    "position": "hidden"
                },
                "liveData": false
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 0,
            "x": 6,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ { "expression": "FILL(METRICS(), 0)", "label": "Expression1", "id": "e1" } ],
                    [ "AWS/SNS", "NumberOfNotificationsDelivered", "PhoneNumber", "PhoneNumberDirect", { "region": "${var.region}", "color": "#08aad2", "id": "m1" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "period": 60,
                "stat": "Sum",
                "title": "SMS Send Rate Per Minute",
                "legend": {
                    "position": "hidden"
                }
            }
        },
        {
            "height": 6,
            "width": 3,
            "y": 6,
            "x": 6,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "ContainerInsights/Prometheus", "kube_deployment_status_replicas_available", "namespace", "notification-canada-ca", "ClusterName", "notification-canada-ca-staging-eks-cluster", "deployment", "admin", { "label": "Admin Replicas Available", "region": "${var.region}", "color": "#69ae34" } ]
                ],
                "sparkline": true,
                "view": "singleValue",
                "region": "${var.region}",
                "title": "Admin Replicas",
                "period": 60,
                "stat": "Maximum"
            }
        },
        {
            "height": 18,
            "width": 3,
            "y": 0,
            "x": 19,
            "type": "alarm",
            "properties": {
                "title": "Critical Alarms",
                "alarms": [
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:sqs-priority-queue-delay-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:logs-10-celery-error-1-minute-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:sqs-send-sms-low-queue-delay-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:expired-inflight-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:sqs-priority-db-tasks-stuck-in-queue-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:sqs-send-sms-medium-queue-delay-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:logs-10-error-5-minutes-critical-lambda-api",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:sqs-send-sms-high-queue-delay-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:no-emails-sent-5-minutes-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:healtheck-page-slow-response-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:load-balancer-10-502-error-5-minutes-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:logs-10-500-error-5-minutes-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:logs-1-critical-bounce-rate-1-minute-warning",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:ses-bounce-rate-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:ses-complaint-rate-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:redis-elasticache-high-db-memory-critical-CacheCluster002",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:redis-elasticache-high-db-memory-critical-CacheCluster001",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:redis-elasticache-high-db-memory-critical-CacheCluster003",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:sqs-send-throttled-sms-tasks-receive-rate-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:sns-spending-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:logs-10-malware-detected-1-minute-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:lambda-image-sns-delivery-receipts-errors-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:logs-10-500-error-5-minutes-critical-sns_to_sqs_sms_callbacks-api",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:logs-10-500-error-5-minutes-critical-ses_to_sqs_email_callbacks-500-errors-api",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:lambda-ses-delivery-receipts-errors-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:sqs-sms-stuck-in-queue-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:sqs-email-queue-delay-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:sns-sms-success-rate-canadian-numbers-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:ddos-detected-load-balancer-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:inflights-not-being-processed-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:sqs-bulk-queue-delay-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:bulk-buffer-not-being-processed-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:normal-inflights-not-being-processed-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:bulk-inflights-not-being-processed-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:priority-inflights-not-being-processed-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:normal_bulk-buffer-not-being-processed-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:priority_bulk-buffer-not-being-processed-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:bulk_bulk-buffer-not-being-processed-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:sqs-bulk-db-tasks-stuck-in-queue-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:sqs-normal-db-tasks-stuck-in-queue-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:sqs-db-tasks-stuck-in-queue-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:logs-10-500-error-5-minutes-critical-heartbeat-api",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:sqs-throttled-sms-stuck-in-queue-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:sign-in-3-500-error-15-minutes-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:contact-3-500-error-15-minutes-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:load-balancer-10-500-error-5-minutes-critical"
                ]
            }
        },
        {
            "height": 6,
            "width": 3,
            "y": 0,
            "x": 12,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "ContainerInsights", "cluster_node_count", "ClusterName", "notification-canada-ca-staging-eks-cluster", { "color": "#dfb52c", "label": "Node Count", "region": "${var.region}" } ]
                ],
                "sparkline": true,
                "view": "singleValue",
                "region": "${var.region}",
                "stat": "Maximum",
                "period": 60,
                "title": "Cluster Node Count"
            }
        },
        {
            "height": 6,
            "width": 4,
            "y": 0,
            "x": 15,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ { "expression": "SELECT AVG(node_cpu_utilization) FROM SCHEMA(ContainerInsights, ClusterName) GROUP BY NodeName", "label": "Node CPU Usage", "id": "q1", "region": "${var.region}" } ]
                ],
                "view": "gauge",
                "region": "${var.region}",
                "yAxis": {
                    "left": {
                        "min": 0,
                        "max": 100
                    }
                },
                "stat": "Average",
                "period": 60,
                "legend": {
                    "position": "hidden"
                },
                "title": "Average Node CPU Usage",
                "annotations": {
                    "horizontal": [
                        {
                            "color": "#fe6e73",
                            "label": "High Usage",
                            "value": 80,
                            "fill": "above"
                        },
                        {
                            "color": "#dfb52c",
                            "label": "Low Usage",
                            "value": 25,
                            "fill": "below"
                        },
                        [
                            {
                                "color": "#69ae34",
                                "label": "Normal Usage",
                                "value": 80
                            },
                            {
                                "value": 25,
                                "label": "Normal Usage"
                            }
                        ]
                    ]
                }
            }
        },
        {
            "height": 6,
            "width": 4,
            "y": 6,
            "x": 15,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ { "expression": "SELECT AVG(node_memory_utilization) FROM SCHEMA(ContainerInsights, ClusterName) GROUP BY NodeName", "label": "Node CPU Usage", "id": "q1", "region": "${var.region}" } ]
                ],
                "view": "gauge",
                "region": "${var.region}",
                "yAxis": {
                    "left": {
                        "min": 0,
                        "max": 100
                    }
                },
                "stat": "Average",
                "period": 60,
                "legend": {
                    "position": "hidden"
                },
                "title": "Average Node Memory Usage",
                "annotations": {
                    "horizontal": [
                        {
                            "color": "#fe6e73",
                            "label": "High Usage",
                            "value": 80,
                            "fill": "above"
                        },
                        {
                            "color": "#dfb52c",
                            "label": "Low Usage",
                            "value": 25,
                            "fill": "below"
                        },
                        [
                            {
                                "color": "#69ae34",
                                "label": "Normal Usage",
                                "value": 80
                            },
                            {
                                "value": 25,
                                "label": "Normal Usage"
                            }
                        ]
                    ]
                }
            }
        }
    ]
}
EOF
}

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
            "y": 0,
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
            "height": 6,
            "width": 15,
            "y": 0,
            "x": 9,
            "type": "alarm",
            "properties": {
                "title": "Email alarms",
                "alarms": [
                    "${aws_cloudwatch_metric_alarm.ses-bounce-rate-critical[0].arn}",
                    "${aws_cloudwatch_metric_alarm.ses-bounce-rate-warning[0].arn}",
                    "${aws_cloudwatch_metric_alarm.ses-complaint-rate-warning[0].arn}",
                    "${aws_cloudwatch_metric_alarm.ses-complaint-rate-critical[0].arn}",
                    "${aws_cloudwatch_metric_alarm.sqs-email-queue-delay-critical[0].arn}",
                    "${aws_cloudwatch_metric_alarm.no-emails-sent-5-minutes-critical[0].arn}",
                    "${aws_cloudwatch_metric_alarm.no-emails-sent-5-minutes-warning[0].arn}"
                ]
            }
        },
        {
            "height": 6,
            "width": 9,
            "y": 6,
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
            "y": 6,
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
            "width": 9,
            "y": 24,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/SQS", "ApproximateAgeOfOldestMessage", "QueueName", "eks-notification-canada-casend-email-tasks", { "color": "#1f77b4" } ]
                ],
                "view": "timeSeries",
                "stacked": true,
                "region": "${var.region}",
                "stat": "Average",
                "period": 60,
                "title": "Average approximate age of oldest message in send-email-tasks"
            }
        },
        {
            "height": 15,
            "width": 6,
            "y": 6,
            "x": 18,
            "type": "text",
            "properties": {
                "markdown": "\n# Sending emails\n\nEmails are sent with [SES](https://${var.region}.console.aws.amazon.com/ses/home?region=${var.region}#dashboard:).\n\nOur limits are:\n- 1,000,000 emails per 24 hour period\n- 100 emails/second\n\nEmails are sent by Celery through the `deliver_email` task through the [send-email-tasks](https://${var.region}.console.aws.amazon.com/sqs/v2/home?region=${var.region}#/queues/https%3A%2F%2Fsqs.${var.region}.amazonaws.com%2F${var.account_id}%2Feks-notification-canada-casend-email-tasks) queue.\n\n## Message flow\n\nAfter a notification has been created in the database, Celery sends the email to the provider using the deliver_email Celery task. This Celery task is assigned to the SQS queue eks-notification-canada-casend-email-tasks, unless a specific queue has been assigned to the queue (for example: eks-notification-canada-capriority-tasks for priority notifications or eks-notification-canada-cabulk-tasks through the API REST service). This task calls the AWS SES API to send a text message.\n\n## Delivery receipts\n\nReceipts from SES are dispatched to SNS -> [Lambda](https://${var.region}.console.aws.amazon.com/lambda/home?region=${var.region}#/functions/ses-to-sqs-email-callbacks) -> [SQS](https://${var.region}.console.aws.amazon.com/sqs/v2/home?region=${var.region}#/queues/https%3A%2F%2Fsqs.${var.region}.amazonaws.com%2F${var.account_id}%2Feks-notification-canada-cadelivery-receipts) in the `delivery-receipts` queue.\n\nA delay in this queue means that we are slow to process delivery receipts (delivered, bounce, complaints).\n"
            }
        },
        {
            "height": 6,
            "width": 9,
            "y": 18,
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
            "width": 9,
            "y": 18,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/SQS", "ApproximateNumberOfMessagesVisible", "QueueName", "eks-notification-canada-casend-email-tasks" ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
                "title": "Approximate number of messages in send-email-tasks",
                "period": 60,
                "stat": "Average"
            }
        },
        {
            "height": 6,
            "width": 9,
            "y": 12,
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
            "y": 12,
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
            "width": 9,
            "y": 24,
            "x": 9,
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
            "width": 9,
            "y": 30,
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
            "width": 9,
            "y": 30,
            "x": 9,
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
                    "${aws_cloudwatch_metric_alarm.sqs-sms-stuck-in-queue-warning[0].arn}",
                    "${aws_cloudwatch_metric_alarm.sqs-sms-stuck-in-queue-critical[0].arn}",
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
                "markdown": "\n## Limits\n- SNS [maximum sending rate](https://docs.aws.amazon.com/general/latest/gr/sns.html#limits_sns): 20 SMS/second\n- [Spending limit](https://${var.region}.console.aws.amazon.com/sns/v3/home?region=${var.region}#/mobile/text-messaging) of 30,000 USD/month\n\n## Message flow\nAfter a notification has been created in the database, Celery sends the SMS to the provider using the `deliver_sms` Celery task. This Celery task is assigned to the SQS queue [eks-notification-canada-casend-sms-tasks](#/queues/https%3A%2F%2Fsqs.${var.region}.amazonaws.com%2F${var.account_id}%2Feks-notification-canada-casend-sms-tasks), unless a specific queue has been assigned to the queue (for example priority templates, SMS sent by the Notify service etc.). This task calls the SNS API to send a text message.\n\n## SNS IDs\nSNS keeps track of SMS with a `messageId`, the value of SNS' `messageId` is stored in the `Notification` object in the `reference` column.\n\n## Logging\nCelery tasks output multiple messages when processing tasks/calling the SNS API, take a look at the relevant Celery code to know more.\n\nAfter an SMS has been sent by SNS, the delivery details are stored in CloudWatch Log groups:\n\n- [sns/${var.region}/${var.account_id}/DirectPublishToPhoneNumber](#logsV2:log-groups/log-group/sns$252F${var.region}$252F${var.account_id}$252FDirectPublishToPhoneNumber) for successful deliveries\n- [sns/${var.region}/${var.account_id}/DirectPublishToPhoneNumber/Failure](#logsV2:log-groups/log-group/sns$252F${var.region}$252F${var.account_id}$252FDirectPublishToPhoneNumber$252FFailure) for failures\n\n## Phone numbers\n\nSMS sent in `${var.region}` use random phone numbers managed by AWS.\n\n### ⚠️  SNS in `us-west-2`\nIf a Notify service has an inbound number attached, SMS will be sent with SNS using a long code phone number ordered on Pinpoint in the `us-west-2` region. Statistics for this region and alarms are **not visible on this dashboard**.\n"
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
