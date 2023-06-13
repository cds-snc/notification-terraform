resource "aws_cloudwatch_dashboard" "redis_batch_saving" {
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
                "region": "ca-central-1",
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
                "region": "ca-central-1",
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
                "region": "ca-central-1",
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
                "region": "ca-central-1",
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
                "region": "ca-central-1",
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
                "region": "ca-central-1",
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
                "region": "ca-central-1",
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
                "region": "ca-central-1",
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
  dashboard_name = "emails"
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
                "region": "ca-central-1",
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
                    "arn:aws:cloudwatch:ca-central-1:${var.account_id}:alarm:ses-bounce-rate-critical",
                    "arn:aws:cloudwatch:ca-central-1:${var.account_id}:alarm:ses-bounce-rate-warning",
                    "arn:aws:cloudwatch:ca-central-1:${var.account_id}:alarm:ses-complaint-rate-warning",
                    "arn:aws:cloudwatch:ca-central-1:${var.account_id}:alarm:ses-complaint-rate-critical",
                    "arn:aws:cloudwatch:ca-central-1:${var.account_id}:alarm:sqs-email-stuck-in-queue-critical",
                    "arn:aws:cloudwatch:ca-central-1:${var.account_id}:alarm:no-emails-sent-5-minutes-critical",
                    "arn:aws:cloudwatch:ca-central-1:${var.account_id}:alarm:no-emails-sent-1-minute-warning"
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
                "region": "ca-central-1",
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
                "region": "ca-central-1",
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
                "region": "ca-central-1",
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
                "markdown": "\n# Sending emails\n\nEmails are sent with [SES](https://ca-central-1.console.aws.amazon.com/ses/home?region=ca-central-1#dashboard:).\n\nOur limits are:\n- 1,000,000 emails per 24 hour period\n- 100 emails/second\n\nEmails are sent by Celery through the `deliver_email` task through the [send-email-tasks](https://ca-central-1.console.aws.amazon.com/sqs/v2/home?region=ca-central-1#/queues/https%3A%2F%2Fsqs.ca-central-1.amazonaws.com%2F${var.account_id}%2Feks-notification-canada-casend-email-tasks) queue.\n\n## Message flow\n\nAfter a notification has been created in the database, Celery sends the email to the provider using the deliver_email Celery task. This Celery task is assigned to the SQS queue eks-notification-canada-casend-email-tasks, unless a specific queue has been assigned to the queue (for example: eks-notification-canada-capriority-tasks for priority notifications or eks-notification-canada-cabulk-tasks through the API REST service). This task calls the AWS SES API to send a text message.\n\n## Delivery receipts\n\nReceipts from SES are dispatched to SNS -> [Lambda](https://ca-central-1.console.aws.amazon.com/lambda/home?region=ca-central-1#/functions/ses-to-sqs-email-callbacks) -> [SQS](https://ca-central-1.console.aws.amazon.com/sqs/v2/home?region=ca-central-1#/queues/https%3A%2F%2Fsqs.ca-central-1.amazonaws.com%2F${var.account_id}%2Feks-notification-canada-cadelivery-receipts) in the `delivery-receipts` queue.\n\nA delay in this queue means that we are slow to process delivery receipts (delivered, bounce, complaints).\n"
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
                "region": "ca-central-1",
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
                "region": "ca-central-1",
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
                "region": "ca-central-1",
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
                "region": "ca-central-1",
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
                "region": "ca-central-1",
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
                "region": "ca-central-1",
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
                "region": "ca-central-1",
                "stat": "Average",
                "period": 300,
                "title": "Number of messages visible in retry-tasks"
            }
        }
    ]
}
EOF
}








resource "aws_cloudwatch_dashboard" "errors" {
  dashboard_name = "Errors"
  dashboard_body = <<EOF
{
    "widgets": [
        {
            "height": 6,
            "width": 24,
            "y": 3,
            "x": 0,
            "type": "log",
            "properties": {
                "query": "SOURCE '/aws/containerinsights/notification-canada-ca-${var.env}-eks-cluster/application' | fields @timestamp, log, kubernetes.labels.app as app, kubernetes.pod_name as pod_name, @logStream\n| filter kubernetes.labels.app like /admin|api/\n| filter strcontains(@message, 'HTTP/1.1\\\" 500')\n| sort @timestamp desc\n| limit 20",
                "region": "ca-central-1",
                "title": "Admin and API 500 errors",
                "view": "table"
            }
        },
        {
            "height": 3,
            "width": 24,
            "y": 0,
            "x": 0,
            "type": "alarm",
            "properties": {
                "title": "Error alarms",
                "alarms": [
                    "arn:aws:cloudwatch:ca-central-1:${var.account_id}:alarm:logs-1-500-error-1-minute-warning",
                    "arn:aws:cloudwatch:ca-central-1:${var.account_id}:alarm:logs-1-celery-error-1-minute-warning",
                    "arn:aws:cloudwatch:ca-central-1:${var.account_id}:alarm:logs-10-500-error-5-minutes-critical",
                    "arn:aws:cloudwatch:ca-central-1:${var.account_id}:alarm:logs-10-celery-error-1-minute-critical",
                    "arn:aws:cloudwatch:ca-central-1:${var.account_id}:alarm:logs-1-error-1-minute-warning-lambda-api",
                    "arn:aws:cloudwatch:ca-central-1:${var.account_id}:alarm:logs-10-error-5-minutes-critical-lambda-api"
                ]
            }
        },
        {
            "height": 6,
            "width": 24,
            "y": 9,
            "x": 0,
            "type": "log",
            "properties": {
                "query": "SOURCE '/aws/containerinsights/notification-canada-ca-${var.env}-eks-cluster/application' | fields @timestamp, log, kubernetes.labels.app as app, kubernetes.pod_name as pod_name, @logStream\n| filter kubernetes.labels.app like /^celery/\n| filter @message like /ERROR\\/.*Worker/\n| sort @timestamp desc\n| limit 20\n",
                "region": "ca-central-1",
                "title": "Celery errors",
                "view": "table"
            }
        },
        {
            "height": 6,
            "width": 24,
            "y": 15,
            "x": 0,
            "type": "log",
            "properties": {
                "query": "SOURCE '/aws/containerinsights/notification-canada-ca-${var.env}-eks-cluster/application' | SOURCE '/aws/lambda/api-lambda' | filter (ispresent(application) or ispresent(kubernetes.host)) and @message like /has been rate limited/\n| parse @message /service (?<service>.*?) has been rate limited for (?<limit_type>..........).*/\n| stats count(*) by service, limit_type\n",
                "region": "ca-central-1",
                "stacked": false,
                "title": "Services going over the daily limit",
                "view": "table"
            }
        }
    ]
}
EOF
}

resource "aws_cloudwatch_dashboard" "kubernetes" {
  dashboard_name = "Kubernetes"
  dashboard_body = <<EOF
{
    "widgets": [
        {
            "height": 15,
            "width": 24,
            "y": 14,
            "x": 0,
            "type": "explorer",
            "properties": {
                "metrics": [
                    {
                        "metricName": "node_cpu_limit",
                        "resourceType": "AWS::EKS::Cluster",
                        "stat": "Maximum"
                    },
                    {
                        "metricName": "node_cpu_usage_total",
                        "resourceType": "AWS::EKS::Cluster",
                        "stat": "Maximum"
                    },
                    {
                        "metricName": "node_memory_limit",
                        "resourceType": "AWS::EKS::Cluster",
                        "stat": "Maximum"
                    },
                    {
                        "metricName": "node_memory_working_set",
                        "resourceType": "AWS::EKS::Cluster",
                        "stat": "Maximum"
                    },
                    {
                        "metricName": "cluster_failed_node_count",
                        "resourceType": "AWS::EKS::Cluster",
                        "stat": "Sum"
                    },
                    {
                        "metricName": "cluster_node_count",
                        "resourceType": "AWS::EKS::Cluster",
                        "stat": "Sum"
                    }
                ],
                "aggregateBy": {
                    "key": "Name",
                    "func": "MAX"
                },
                "labels": [
                    {
                        "key": "Name",
                        "value": "notification-canada-ca"
                    }
                ],
                "widgetOptions": {
                    "legend": {
                        "position": "bottom"
                    },
                    "view": "timeSeries",
                    "stacked": false,
                    "rowsPerPage": 50,
                    "widgetsPerRow": 2
                },
                "period": 300,
                "splitBy": "Name",
                "region": "ca-central-1"
            }
        },
        {
            "height": 7,
            "width": 24,
            "y": 0,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "ContainerInsights", "pod_memory_utilization_over_pod_limit", "PodName", "admin", "ClusterName", "notification-canada-ca-${var.env}-eks-cluster", "Namespace", "notification-canada-ca" ],
                    [ "...", "api", ".", ".", ".", "." ],
                    [ "...", "celery", ".", ".", ".", "." ],
                    [ "...", "document-download-api", ".", ".", ".", "." ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "yAxis": {
                    "left": {
                        "label": "pod_memory_utilization_over_pod_limit",
                        "min": 0,
                        "max": 100
                    },
                    "right": {
                        "label": "",
                        "min": 0
                    }
                },
                "title": "Pod mem utilization over limit",
                "period": 300,
                "stat": "Maximum"
            }
        },
        {
            "height": 7,
            "width": 24,
            "y": 7,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "ContainerInsights", "pod_cpu_utilization", "ClusterName", "notification-canada-ca-${var.env}-eks-cluster", "Service", "api", "Namespace", "notification-canada-ca", { "yAxis": "right", "stat": "Average" } ],
                    [ "...", "celery", ".", ".", { "yAxis": "right", "stat": "Average" } ],
                    [ "...", "admin", ".", ".", { "stat": "Average", "yAxis": "right" } ],
                    [ ".", "service_number_of_running_pods", ".", ".", ".", "celery", ".", ".", { "yAxis": "left" } ],
                    [ "...", "api", ".", ".", { "yAxis": "left" } ],
                    [ "...", "admin", ".", "." ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "Maximum",
                "period": 300,
                "yAxis": {
                    "left": {
                        "min": 0,
                        "label": "Running Pods: Max",
                        "showUnits": false
                    },
                    "right": {
                        "min": 0,
                        "label": "Pod Instances CPU: Average"
                    }
                },
                "title": "Pods Running VS Pod CPU"
            }
        }
    ]
}
EOF
}

resource "aws_cloudwatch_dashboard" "new-slo" {
  dashboard_name = "New-SLO"
  dashboard_body = <<EOF
{
    "start": "-PT720H",
    "widgets": [
        {
            "height": 6,
            "width": 6,
            "y": 0,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ { "expression": "100 - FILL(admin_errors,0)/FILL(admin_requests, 1)*100", "label": "Success rate", "id": "e1", "period": 86400, "stat": "Sum", "color": "#1f77b4", "region": "ca-central-1" } ],
                    [ "AWS/ApplicationELB", "HTTPCode_Target_5XX_Count", "TargetGroup", "targetgroup/notification-canada-ca-alb-admin/7b55c66402cf0ba9", "LoadBalancer", "app/notification-${var.env}-alb/a88ef289ed9dd41e", { "id": "admin_errors", "visible": false } ],
                    [ ".", "RequestCount", ".", ".", ".", ".", { "id": "admin_requests", "visible": false } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "Sum",
                "period": 86400,
                "annotations": {
                    "horizontal": [
                        {
                            "label": "99%",
                            "value": 99,
                            "fill": "below"
                        }
                    ]
                },
                "liveData": false,
                "yAxis": {
                    "left": {
                        "showUnits": false
                    }
                },
                "title": "Admin success rate"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 0,
            "x": 12,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ { "expression": "100 - 100 * m2 / m1", "label": "Success rate", "id": "e1", "region": "ca-central-1", "color": "#1f77b4" } ],
                    [ "AWS/ApiGateway", "Count", "ApiName", "api-lambda", { "visible": false, "id": "m1" } ],
                    [ ".", "5XXError", ".", ".", { "id": "m2", "visible": false } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "Sum",
                "period": 86400,
                "annotations": {
                    "horizontal": [
                        {
                            "label": "99%",
                            "value": 99,
                            "fill": "below"
                        }
                    ]
                },
                "title": "Api lambda success rate",
                "yAxis": {
                    "left": {
                        "showUnits": false
                    }
                }
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
                    [ "AWS/ApplicationELB", "RequestCount", "TargetGroup", "targetgroup/notification-canada-ca-alb-api/2d9017625dea5cd0", "LoadBalancer", "app/notification-${var.env}-alb/a88ef289ed9dd41e", { "id": "m1", "visible": false } ],
                    [ ".", "HTTPCode_Target_5XX_Count", ".", ".", ".", ".", { "id": "m2", "visible": false } ],
                    [ { "expression": "100 - m2/m1*100", "label": "Success rate", "id": "e1", "period": 86400, "stat": "Sum", "color": "#1f77b4", "region": "ca-central-1" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "Sum",
                "period": 86400,
                "annotations": {
                    "horizontal": [
                        {
                            "label": "99%",
                            "value": 99,
                            "fill": "below"
                        }
                    ]
                },
                "liveData": false,
                "yAxis": {
                    "left": {
                        "showUnits": false
                    }
                },
                "title": "API k8s success rate",
                "timezone": "Local"
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
                    [ "AWS/ApplicationELB", "TargetResponseTime", "TargetGroup", "targetgroup/notification-canada-ca-alb-admin/7b55c66402cf0ba9", "LoadBalancer", "app/notification-${var.env}-alb/a88ef289ed9dd41e", { "stat": "p90", "label": "Latency p90" } ],
                    [ "...", { "label": "Latency p99" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "p99",
                "period": 86400,
                "title": "Admin latency",
                "annotations": {
                    "horizontal": [
                        {
                            "label": "200 ms",
                            "value": 0.2
                        },
                        {
                            "color": "#d62728",
                            "label": "400 ms",
                            "value": 0.4,
                            "fill": "above"
                        }
                    ]
                }
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
                    [ "AWS/ApplicationELB", "TargetResponseTime", "TargetGroup", "targetgroup/notification-canada-ca-alb-admin/7b55c66402cf0ba9", "LoadBalancer", "app/notification-${var.env}-alb/a88ef289ed9dd41e", { "stat": "p90", "label": "Admin p90", "visible": false } ],
                    [ "...", { "label": "Admin p99", "visible": false } ],
                    [ "...", "targetgroup/notification-canada-ca-alb-api/2d9017625dea5cd0", ".", ".", { "stat": "p90", "label": "Latency p90", "color": "#1f77b4" } ],
                    [ "...", { "label": "Latency p99", "color": "#ff7f0e" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "p99",
                "period": 86400,
                "title": "Api k8s latency",
                "annotations": {
                    "horizontal": [
                        {
                            "label": "200 ms",
                            "value": 0.2
                        },
                        {
                            "color": "#d62728",
                            "label": "400 ms",
                            "value": 0.4,
                            "fill": "above"
                        }
                    ]
                }
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
                    [ "AWS/ApplicationELB", "TargetResponseTime", "TargetGroup", "targetgroup/notification-canada-ca-alb-admin/7b55c66402cf0ba9", "LoadBalancer", "app/notification-${var.env}-alb/a88ef289ed9dd41e", { "stat": "p90", "label": "Admin p90", "visible": false } ],
                    [ "...", { "label": "Admin p99", "visible": false } ],
                    [ "...", "targetgroup/notification-canada-ca-alb-api/2d9017625dea5cd0", ".", ".", { "stat": "p90", "label": "Api k8s p90", "visible": false } ],
                    [ "...", { "label": "Api k8s p99", "visible": false } ],
                    [ "AWS/ApiGateway", "Latency", "ApiName", "api-lambda", { "stat": "p90", "color": "#1f77b4" } ],
                    [ "...", { "color": "#ff7f0e" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "p99",
                "period": 86400,
                "title": "Api lambda latency",
                "annotations": {
                    "horizontal": [
                        {
                            "label": "200 ms",
                            "value": 200
                        },
                        {
                            "color": "#d62728",
                            "label": "400 ms",
                            "value": 400,
                            "fill": "above"
                        }
                    ]
                }
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 0,
            "x": 18,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "NotificationCanadaCa", "${var.env}_notifications_celery_email_with-attachments_process_type-normal", "metric_type", "timing", { "stat": "p90", "label": "Send time p90" } ],
                    [ "...", { "label": "Send time p99" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "p99",
                "period": 86400,
                "annotations": {
                    "horizontal": [
                        {
                            "color": "#d62728",
                            "label": "More than 60s",
                            "value": 60
                        },
                        {
                            "color": "#d62728",
                            "label": "More than 300s",
                            "value": 300,
                            "fill": "above"
                        }
                    ]
                },
                "title": "Time to send emails with attachments (seconds)",
                "yAxis": {
                    "left": {
                        "showUnits": false
                    }
                }
            }
        }
    ]
}
EOF
}

resource "aws_cloudwatch_dashboard" "queues" {
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
                "region": "ca-central-1",
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
                "region": "ca-central-1",
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
                    [ "AWS/SQS", "NumberOfMessagesSent", "QueueName", "eks-notification-canada-ca-priority-database-tasks.fifo", { "region": "ca-central-1" } ],
                    [ "...", "eks-notification-canada-ca-normal-database-tasks", { "region": "ca-central-1" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "period": 300,
                "stat": "Sum",
                "title": "Normal / Priority"
            }
        }
    ]
}
EOF
}

resource "aws_cloudwatch_dashboard" "slos" {
  dashboard_name = "SLOs"
  dashboard_body = <<EOF
{
    "start": "-P3D",
    "widgets": [
        {
            "height": 6,
            "width": 12,
            "y": 37,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ { "expression": "FILL(admin_errors,0)/FILL(admin_requests, 1)*100", "label": "API error rate", "id": "e1", "period": 3600, "stat": "Sum", "color": "#d62728", "region": "ca-central-1" } ],
                    [ "AWS/ApplicationELB", "HTTPCode_Target_5XX_Count", "TargetGroup", "targetgroup/notification-canada-ca-alb-admin/7b55c66402cf0ba9", "LoadBalancer", "app/notification-${var.env}-alb/a88ef289ed9dd41e", { "id": "admin_errors", "visible": false } ],
                    [ ".", "RequestCount", ".", ".", ".", ".", { "id": "admin_requests", "visible": false } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "Sum",
                "period": 3600,
                "annotations": {
                    "horizontal": [
                        {
                            "label": "Above 1% error rate",
                            "value": 1,
                            "fill": "above"
                        }
                    ]
                },
                "liveData": false,
                "yAxis": {
                    "left": {
                        "showUnits": true
                    }
                },
                "title": "Admin error rate per hour"
            }
        },
        {
            "height": 6,
            "width": 12,
            "y": 4,
            "x": 12,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/ApplicationELB", "RequestCount", "TargetGroup", "targetgroup/notification-canada-ca-alb-api/2d9017625dea5cd0", "LoadBalancer", "app/notification-${var.env}-alb/a88ef289ed9dd41e", { "id": "m1", "visible": false } ],
                    [ ".", "HTTPCode_Target_5XX_Count", ".", ".", ".", ".", { "id": "m2", "visible": false } ],
                    [ { "expression": "m2/m1*100", "label": "API error rate", "id": "e1", "period": 3600, "stat": "Sum", "color": "#d62728", "region": "ca-central-1" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "Sum",
                "period": 3600,
                "annotations": {
                    "horizontal": [
                        {
                            "label": "Above 1% error rate",
                            "value": 1,
                            "fill": "above"
                        }
                    ]
                },
                "liveData": false,
                "yAxis": {
                    "left": {
                        "showUnits": true
                    }
                },
                "title": "API error rate per hour"
            }
        },
        {
            "height": 6,
            "width": 12,
            "y": 4,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ { "expression": "(m2+m3)/m1*100", "label": "Load balancer error rate", "id": "e1", "color": "#d62728", "period": 3600, "region": "ca-central-1" } ],
                    [ "AWS/ApplicationELB", "RequestCount", "LoadBalancer", "app/notification-${var.env}-alb/a88ef289ed9dd41e", { "id": "m1", "visible": false } ],
                    [ ".", "HTTPCode_ELB_5XX_Count", ".", ".", { "id": "m2", "visible": false } ],
                    [ ".", "HTTPCode_Target_5XX_Count", ".", ".", { "id": "m3", "visible": false } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "Sum",
                "period": 3600,
                "annotations": {
                    "horizontal": [
                        {
                            "label": "1% error rate",
                            "value": 1,
                            "fill": "above"
                        }
                    ]
                },
                "title": "Load balancer error rate per hour"
            }
        },
        {
            "height": 6,
            "width": 12,
            "y": 30,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "NotificationCanadaCa", "${var.env}_notifications_celery_sms_process_type-normal", "metric_type", "timing", { "label": "p90" } ],
                    [ "...", { "label": "p99", "stat": "p99" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "p90",
                "period": 900,
                "annotations": {
                    "horizontal": [
                        {
                            "color": "#ff7f0e",
                            "label": "More than 10s",
                            "value": 10,
                            "fill": "above"
                        },
                        {
                            "color": "#d62728",
                            "label": "More than 60s",
                            "value": 60,
                            "fill": "above"
                        }
                    ]
                },
                "title": "Delay to send SMS in seconds, per 15 minutes"
            }
        },
        {
            "height": 6,
            "width": 12,
            "y": 17,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "NotificationCanadaCa", "${var.env}_notifications_celery_email_no-attachments_process_type-normal", "metric_type", "timing", { "label": "p90" } ],
                    [ "...", { "stat": "p99", "label": "p99" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "p90",
                "period": 900,
                "annotations": {
                    "horizontal": [
                        {
                            "color": "#ff7f0e",
                            "label": "More than 10s",
                            "value": 10,
                            "fill": "above"
                        },
                        {
                            "color": "#d62728",
                            "label": "More than 60s",
                            "value": 60,
                            "fill": "above"
                        }
                    ]
                },
                "title": "Delay to send normal emails without attachments in seconds, per 15 minutes"
            }
        },
        {
            "height": 6,
            "width": 12,
            "y": 17,
            "x": 12,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "NotificationCanadaCa", "${var.env}_notifications_celery_email_no-attachments_process_type-bulk", "metric_type", "timing", { "stat": "p90", "label": "p90" } ],
                    [ "...", { "label": "p99" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "p99",
                "period": 900,
                "annotations": {
                    "horizontal": [
                        {
                            "color": "#ff7f0e",
                            "label": "More than 300s",
                            "value": 300,
                            "fill": "above"
                        },
                        {
                            "color": "#d62728",
                            "label": "More than 600s",
                            "value": 600,
                            "fill": "above"
                        }
                    ]
                },
                "title": "Delay to send bulk emails in seconds, per 15 minutes"
            }
        },
        {
            "height": 1,
            "width": 24,
            "y": 36,
            "x": 0,
            "type": "text",
            "properties": {
                "markdown": "\n# Admin\n"
            }
        },
        {
            "height": 1,
            "width": 24,
            "y": 3,
            "x": 0,
            "type": "text",
            "properties": {
                "markdown": "\n# API\n"
            }
        },
        {
            "height": 1,
            "width": 24,
            "y": 16,
            "x": 0,
            "type": "text",
            "properties": {
                "markdown": "\n# Emails\n"
            }
        },
        {
            "height": 1,
            "width": 24,
            "y": 29,
            "x": 0,
            "type": "text",
            "properties": {
                "markdown": "\n# SMS\n"
            }
        },
        {
            "height": 3,
            "width": 24,
            "y": 0,
            "x": 0,
            "type": "text",
            "properties": {
                "markdown": "\n# Service Level Objectives\n\nSee our SLOs on [Google Sheets](https://docs.google.com/spreadsheets/d/1fU-FJ7THfWEqNhbpQ4r22MQipFwC7SP851ZQnOf68cM/edit#gid=0).\n\nYou can use the [public URL](https://cloudwatch.amazonaws.com/dashboard.html?dashboard=SLOs&context=eyJSIjoidXMtZWFzdC0xIiwiRCI6ImN3LWRiLTI5NjI1NTQ5NDgyNSIsIlUiOiJ1cy1lYXN0LTFfRGY5R0xRU3RnIiwiQyI6IjYya2k0cDMxOGhoN2ZzcmxjMms0bDBsbzhzIiwiSSI6InVzLWVhc3QtMTo1N2U5ZmZjMC00ZTlkLTQzM2ItYmMyYy1iZWE4NTVkZTdmOWQiLCJPIjoiYXJuOmF3czppYW06OjI5NjI1NTQ5NDgyNTpyb2xlL3NlcnZpY2Utcm9sZS9DbG91ZFdhdGNoRGFzaGJvYXJkLVB1YmxpYy1SZWFkT25seUFjY2Vzcy1TTE9zLUNZTU5QVDg3IiwiTSI6IlB1YmxpYyJ9) to share this dashboard.\n"
            }
        },
        {
            "height": 6,
            "width": 12,
            "y": 10,
            "x": 12,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/ApplicationELB", "TargetResponseTime", "TargetGroup", "targetgroup/notification-canada-ca-alb-api/2d9017625dea5cd0", "LoadBalancer", "app/notification-${var.env}-alb/a88ef289ed9dd41e", { "stat": "p90" } ],
                    [ "..." ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "p99",
                "period": 900,
                "annotations": {
                    "horizontal": [
                        {
                            "label": "More than 400ms",
                            "value": 0.4,
                            "fill": "above"
                        },
                        {
                            "label": "More than 200ms",
                            "value": 0.2,
                            "fill": "above"
                        }
                    ]
                },
                "title": "API HTTP response time, per 15 minutes"
            }
        },
        {
            "height": 6,
            "width": 12,
            "y": 30,
            "x": 12,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/ApplicationELB", "TargetResponseTime", "TargetGroup", "targetgroup/notification-canada-ca-alb-admin/7b55c66402cf0ba9", "LoadBalancer", "app/notification-${var.env}-alb/a88ef289ed9dd41e" ],
                    [ "...", { "stat": "p99" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "p90",
                "period": 900,
                "annotations": {
                    "horizontal": [
                        {
                            "label": "More than 400ms",
                            "value": 0.4,
                            "fill": "above"
                        },
                        {
                            "label": "More than 200ms",
                            "value": 0.2,
                            "fill": "above"
                        }
                    ]
                },
                "title": "Admin HTTP response time, per 15 minutes"
            }
        },
        {
            "height": 6,
            "width": 12,
            "y": 43,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "NotificationCanadaCa", "${var.env}_notifications_celery_job_processing-start-delay", "metric_type", "timing", { "label": "p90" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "p90",
                "period": 3600,
                "annotations": {
                    "horizontal": [
                        {
                            "label": "More than 10min",
                            "value": 600,
                            "fill": "above"
                        }
                    ]
                },
                "title": "Delay to send notifications with a spreadsheet, per hour"
            }
        },
        {
            "height": 6,
            "width": 12,
            "y": 10,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "NotificationCanadaCa", "${var.env}_notifications_api_POST_v2_notifications_post_notification_201", "metric_type", "timing" ],
                    [ "...", { "stat": "p99" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "p90",
                "period": 900,
                "start": "-PT12H",
                "end": "P0D",
                "annotations": {
                    "horizontal": [
                        {
                            "label": "More than 400ms",
                            "value": 0.4,
                            "fill": "above"
                        },
                        {
                            "label": "More than 200ms",
                            "value": 0.2,
                            "fill": "above"
                        }
                    ]
                },
                "title": "Response time when posting a notification through the API, per 15 minutes"
            }
        },
        {
            "height": 6,
            "width": 12,
            "y": 23,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "NotificationCanadaCa", "${var.env}_notifications_celery_callback_ses_elapsed-time", "metric_type", "timing" ],
                    [ "...", { "stat": "p99" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "p90",
                "period": 900,
                "annotations": {
                    "horizontal": [
                        {
                            "label": "More than 180 seconds",
                            "value": 180,
                            "fill": "above"
                        },
                        {
                            "label": "More than 60 seconds",
                            "value": 60,
                            "fill": "above"
                        }
                    ]
                },
                "start": "-PT72H",
                "end": "P0D",
                "title": "Time to process email delivery receipts, per 15 minutes"
            }
        }
    ]
}
EOF
}

resource "aws_cloudwatch_dashboard" "sms" {
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
                    "arn:aws:cloudwatch:ca-central-1:${var.account_id}:alarm:sns-sms-success-rate-canadian-numbers-critical",
                    "arn:aws:cloudwatch:ca-central-1:${var.account_id}:alarm:sns-sms-success-rate-canadian-numbers-warning",
                    "arn:aws:cloudwatch:ca-central-1:${var.account_id}:alarm:sqs-sms-stuck-in-queue-warning",
                    "arn:aws:cloudwatch:ca-central-1:${var.account_id}:alarm:sqs-sms-stuck-in-queue-critical",
                    "arn:aws:cloudwatch:ca-central-1:${var.account_id}:alarm:sns-spending-critical",
                    "arn:aws:cloudwatch:ca-central-1:${var.account_id}:alarm:sns-spending-warning"
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
                "region": "ca-central-1",
                "stat": "Sum",
                "period": 300,
                "title": "SMS delivered per 5m"
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
                    [ "AWS/SNS", "NumberOfNotificationsFailed", "PhoneNumber", "PhoneNumberDirect", { "color": "#d62728" } ]
                ],
                "view": "timeSeries",
                "stacked": true,
                "region": "ca-central-1",
                "stat": "Sum",
                "period": 300,
                "title": "SMS failures per 5m"
            }
        },
        {
            "height": 6,
            "width": 9,
            "y": 37,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/SQS", "ApproximateAgeOfOldestMessage", "QueueName", "eks-notification-canada-cadelivery-receipts" ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
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
            "y": 37,
            "x": 9,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/SQS", "ApproximateNumberOfMessagesVisible", "QueueName", "eks-notification-canada-cadelivery-receipts" ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "Average",
                "period": 60,
                "title": "Number of messages visible in delivery-receipts"
            }
        },
        {
            "height": 6,
            "width": 9,
            "y": 17,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "NotificationCanadaCa", "${var.env}_notifications_celery_clients_sns_request-time", "metric_type", "timing" ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
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
            "y": 31,
            "x": 9,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "NotificationCanadaCa", "${var.env}_notifications_celery_tasks_process_sns_results", "metric_type", "counter" ]
                ],
                "view": "timeSeries",
                "stacked": true,
                "region": "ca-central-1",
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
            "y": 29,
            "x": 0,
            "type": "text",
            "properties": {
                "markdown": "\n# Delivery receipts\n"
            }
        },
        {
            "height": 6,
            "width": 9,
            "y": 31,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/Lambda", "Invocations", "FunctionName", "sns-to-sqs-sms-callbacks" ],
                    [ ".", "Errors", ".", ".", { "color": "#d62728", "yAxis": "right" } ]
                ],
                "view": "timeSeries",
                "stacked": true,
                "region": "ca-central-1",
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
                "markdown": "\n## Limits\n- SNS [maximum sending rate](https://docs.aws.amazon.com/general/latest/gr/sns.html#limits_sns): 20 SMS/second\n- [Spending limit](https://ca-central-1.console.aws.amazon.com/sns/v3/home?region=ca-central-1#/mobile/text-messaging) of 30,000 USD/month\n\n## Message flow\nAfter a notification has been created in the database, Celery sends the SMS to the provider using the `deliver_sms` Celery task. This Celery task is assigned to the SQS queue [eks-notification-canada-casend-sms-tasks](#/queues/https%3A%2F%2Fsqs.ca-central-1.amazonaws.com%2F${var.account_id}%2Feks-notification-canada-casend-sms-tasks), unless a specific queue has been assigned to the queue (for example priority templates, SMS sent by the Notify service etc.). This task calls the SNS API to send a text message.\n\n## SNS IDs\nSNS keeps track of SMS with a `messageId`, the value of SNS' `messageId` is stored in the `Notification` object in the `reference` column.\n\n## Logging\nCelery tasks output multiple messages when processing tasks/calling the SNS API, take a look at the relevant Celery code to know more.\n\nAfter an SMS has been sent by SNS, the delivery details are stored in CloudWatch Log groups:\n\n- [sns/ca-central-1/${var.account_id}/DirectPublishToPhoneNumber](#logsV2:log-groups/log-group/sns$252Fca-central-1$252F${var.account_id}$252FDirectPublishToPhoneNumber) for successful deliveries\n- [sns/ca-central-1/${var.account_id}/DirectPublishToPhoneNumber/Failure](#logsV2:log-groups/log-group/sns$252Fca-central-1$252F${var.account_id}$252FDirectPublishToPhoneNumber$252FFailure) for failures\n\n## Phone numbers\n\nSMS sent in `ca-central-1` use random phone numbers managed by AWS.\n\n### ⚠️  SNS in `us-west-2`\nIf a Notify service has an inbound number attached, SMS will be sent with SNS using a long code phone number ordered on Pinpoint in the `us-west-2` region. Statistics for this region and alarms are **not visible on this dashboard**.\n"
            }
        },
        {
            "height": 6,
            "width": 9,
            "y": 23,
            "x": 0,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "NotificationCanadaCa", "${var.env}_notifications_celery_tasks_deliver_sms", "metric_type", "counter" ]
                ],
                "view": "timeSeries",
                "stacked": true,
                "region": "ca-central-1",
                "stat": "Sum",
                "period": 300,
                "title": "Number of deliver_sms Celery tasks per 5m"
            }
        },
        {
            "height": 9,
            "width": 6,
            "y": 31,
            "x": 18,
            "type": "text",
            "properties": {
                "markdown": "\n## Message flow\nAfter an SMS has been sent by SNS, the delivery details are stored in CloudWatch Log groups:\n\n- [sns/ca-central-1/${var.account_id}/DirectPublishToPhoneNumber](#logsV2:log-groups/log-group/sns$252Fca-central-1$252F${var.account_id}$252FDirectPublishToPhoneNumber) for successful deliveries\n- [sns/ca-central-1/${var.account_id}/DirectPublishToPhoneNumber/Failure](#logsV2:log-groups/log-group/sns$252Fca-central-1$252F${var.account_id}$252FDirectPublishToPhoneNumber$252FFailure) for failures\n\nThe log groups are subscribed the Lambda function [sns-to-sqs-sms-callbacks](#/functions/sns-to-sqs-sms-callbacks?tab=configuration). This Lambda adds messages to the SQS queue `delivery-receipts` to trigger the Celery task in charge of updating notifications in the database, `process-sns-result`.\n\nSee the relevant [AWS documentation](https://docs.aws.amazon.com/sns/latest/dg/sms_stats_cloudwatch.html#sns-viewing-cloudwatch-logs) for these messages.\n"
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
                    [ "AWS/SQS", "ApproximateNumberOfMessagesVisible", "QueueName", "eks-notification-canada-casend-sms-tasks" ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "Average",
                "period": 60,
                "title": "Number of messages visible in send-sms-tasks"
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
                    [ "AWS/SQS", "ApproximateAgeOfOldestMessage", "QueueName", "eks-notification-canada-casend-sms-tasks" ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "title": "Approximate age of oldest message in send-sms-tasks",
                "stat": "Average",
                "period": 60,
                "annotations": {
                    "horizontal": [
                        {
                            "color": "#ff7f0e",
                            "label": "Above 3mn",
                            "value": 180,
                            "fill": "above"
                        },
                        {
                            "color": "#d62728",
                            "label": "Above 5mn",
                            "value": 300,
                            "fill": "above"
                        }
                    ]
                }
            }
        },
        {
            "height": 3,
            "width": 24,
            "y": 46,
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
            "y": 43,
            "x": 0,
            "type": "log",
            "properties": {
                "query": "SOURCE 'sns/ca-central-1/${var.account_id}/DirectPublishToPhoneNumber/Failure' | fields @timestamp as Timestamp, notification.messageId as MessageID, status, delivery.destination as Destination, delivery.providerResponse as ProviderResponse\n| sort @timestamp desc\n| limit 20",
                "region": "ca-central-1",
                "stacked": false,
                "view": "table",
                "title": "SMS Errors Log / ca-central-1"
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
                "region": "ca-central-1",
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
            "y": 55,
            "x": 0,
            "type": "log",
            "properties": {
                "query": "SOURCE 'sns/ca-central-1/${var.account_id}/DirectPublishToPhoneNumber/Failure' | SOURCE 'sns/ca-central-1/${var.account_id}/DirectPublishToPhoneNumber' | stats avg(delivery.dwellTimeMsUntilDeviceAck / 1000 / 60) as Avg_carrier_time_minutes, count(*) as Number by delivery.phoneCarrier as Carrier",
                "region": "ca-central-1",
                "title": "Carrier Dwell Times",
                "view": "table"
            }
        },
        {
            "height": 6,
            "width": 24,
            "y": 49,
            "x": 0,
            "type": "log",
            "properties": {
                "query": "SOURCE 'sns/ca-central-1/${var.account_id}/DirectPublishToPhoneNumber' | SOURCE 'sns/ca-central-1/${var.account_id}/DirectPublishToPhoneNumber/Failure' | stats avg(delivery.dwellTimeMsUntilDeviceAck / 1000 / 60) as Avg_carrier_time_minutes by bin(30s)",
                "region": "ca-central-1",
                "stacked": false,
                "view": "timeSeries",
                "title": "dwellTimeMsUntilDeviceAck"
            }
        }
    ]
}
EOF
}


resource "aws_cloudwatch_dashboard" "sms" {
  dashboard_name = "SMS"
  dashboard_body = <<EOF
{
    "widgets": [
        {
            "height": 17,
            "width": 24,
            "y": 6,
            "x": 0,
            "type": "log",
            "properties": {
                "query": "SOURCE '/aws/containerinsights/notification-canada-ca-${var.env}-eks-cluster/application' | fields @timestamp, log\n| filter kubernetes.container_name like /admin/\n| filter log like /Sensitive/\n| filter log like /\\/service\\/[0-9a-f\\-]{36}\\//\n| parse log /(?<url>\\/service\\/.*) (?<admin>.*)\\|.*/\n| display @timestamp, admin, url\n| sort @timestamp desc\n| limit 5000\n",
                "region": "ca-central-1",
                "stacked": false,
                "view": "table",
                "title": "Details"
            }
        },
        {
            "height": 6,
            "width": 24,
            "y": 0,
            "x": 0,
            "type": "log",
            "properties": {
                "query": "SOURCE '/aws/containerinsights/notification-canada-ca-${var.env}-eks-cluster/application' | fields @timestamp, log\n| filter kubernetes.container_name like /admin/\n| filter log like /Sensitive/\n| filter log like /\\/service\\/[0-9a-f\\-]{36}\\//\n| parse log /service\\/(?<service>[0-9a-f\\-]*)\\/.* (?<admin>.*)\\|.*/\n| stats count(*) as total by service, admin\n| sort total desc\n",
                "region": "ca-central-1",
                "title": "Summary ordered by total",
                "view": "table"
            }
        }
    ]
}
EOF
}