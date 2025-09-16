resource "aws_cloudwatch_dashboard" "performance_bottlenecks" {
  count          = var.cloudwatch_enabled ? 1 : 0
  dashboard_name = "Performance-Bottlenecks"
  dashboard_body = <<EOF
{
    "widgets": [
        {
            "type": "metric",
            "x": 0,
            "y": 9,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/RDS", "CPUUtilization", "DBClusterIdentifier", "notification-canada-ca-${var.env}-cluster", { "period": 60 } ]
                ],
                "region": "ca-central-1",
                "title": "Database Cluster CPU"
            }
        },
        {
            "type": "text",
            "x": 0,
            "y": 7,
            "width": 24,
            "height": 1,
            "properties": {
                "markdown": "# Postgres Database",
                "background": "solid"
            }
        },
        {
            "type": "metric",
            "x": 6,
            "y": 22,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", "notification-canada-ca-${var.env}-instance-1", { "period": 60 } ],
                    [ "...", "notification-canada-ca-${var.env}-instance-2", { "period": 60 } ],
                    [ "...", "notification-canada-ca-${var.env}-instance-0", { "period": 60 } ]
                ],
                "region": "ca-central-1",
                "title": "CPU Usage Per Instance"
            }
        },
        {
            "type": "metric",
            "x": 6,
            "y": 9,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/RDS", "FreeableMemory", "DBClusterIdentifier", "notification-canada-ca-${var.env}-cluster", { "period": 60 } ]
                ],
                "region": "ca-central-1",
                "title": "Database Cluster Freeable Memory"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 22,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/RDS", "FreeableMemory", "DBInstanceIdentifier", "notification-canada-ca-${var.env}-instance-0", { "period": 60 } ],
                    [ "...", "notification-canada-ca-${var.env}-instance-1", { "period": 60 } ],
                    [ "...", "notification-canada-ca-${var.env}-instance-2", { "period": 60 } ]
                ],
                "region": "ca-central-1",
                "title": "Freeable Memory Per Instance"
            }
        },
        {
            "type": "metric",
            "x": 6,
            "y": 15,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/RDS", "WriteLatency", "DBClusterIdentifier", "notification-canada-ca-${var.env}-cluster", { "period": 60 } ]
                ],
                "region": "ca-central-1",
                "title": "Database Cluster Write Latency"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 15,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/RDS", "ReadLatency", "DBClusterIdentifier", "notification-canada-ca-${var.env}-cluster", { "period": 60 } ]
                ],
                "region": "ca-central-1",
                "title": "Database Cluster Read Latency"
            }
        },
        {
            "type": "text",
            "x": 0,
            "y": 8,
            "width": 24,
            "height": 1,
            "properties": {
                "markdown": "## Database Cluster"
            }
        },
        {
            "type": "text",
            "x": 0,
            "y": 21,
            "width": 24,
            "height": 1,
            "properties": {
                "markdown": "## Database Instances"
            }
        },
        {
            "type": "metric",
            "x": 6,
            "y": 28,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/RDS", "WriteLatency", "DBInstanceIdentifier", "notification-canada-ca-${var.env}-instance-0", { "period": 60 } ],
                    [ "...", "notification-canada-ca-${var.env}-instance-1", { "period": 60 } ],
                    [ "...", "notification-canada-ca-${var.env}-instance-2", { "period": 60 } ]
                ],
                "region": "ca-central-1",
                "title": "Write Latency Per Instance"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 28,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/RDS", "ReadLatency", "DBInstanceIdentifier", "notification-canada-ca-${var.env}-instance-0", { "period": 60 } ],
                    [ "...", "notification-canada-ca-${var.env}-instance-1", { "period": 60 } ],
                    [ "...", "notification-canada-ca-${var.env}-instance-2", { "period": 60 } ]
                ],
                "region": "ca-central-1",
                "title": "Read Latency Per Instance"
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 15,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/RDS", "CommitLatency", "DBClusterIdentifier", "notification-canada-ca-${var.env}-cluster", { "period": 60 } ]
                ],
                "region": "ca-central-1",
                "title": "Database Cluster Commit Latency"
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 9,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/RDS", "DatabaseConnections", "DBClusterIdentifier", "notification-canada-ca-${var.env}-cluster", { "period": 60 } ]
                ],
                "region": "ca-central-1",
                "title": "Database Cluster Connections"
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 9,
            "width": 6,
            "height": 6,
            "properties": {
                "metrics": [
                    [ "AWS/RDS", "Deadlocks", "DBClusterIdentifier", "notification-canada-ca-${var.env}-cluster", { "region": "ca-central-1", "color": "#fe6e73" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "title": "Database Cluster Deadlocks",
                "period": 60,
                "stat": "Average"
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 22,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/RDS", "Deadlocks", "DBInstanceIdentifier", "notification-canada-ca-${var.env}-instance-0", { "period": 60 } ],
                    [ "...", "notification-canada-ca-${var.env}-instance-1", { "period": 60 } ],
                    [ "...", "notification-canada-ca-${var.env}-instance-2", { "period": 60 } ]
                ],
                "region": "ca-central-1",
                "title": "Deadlocks Per Instance"
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 22,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", "notification-canada-ca-${var.env}-instance-0", { "period": 60 } ],
                    [ "...", "notification-canada-ca-${var.env}-instance-1", { "period": 60 } ],
                    [ "...", "notification-canada-ca-${var.env}-instance-2", { "period": 60 } ]
                ],
                "region": "ca-central-1",
                "title": "Connections Per Instance"
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 28,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/RDS", "CommitLatency", "DBInstanceIdentifier", "notification-canada-ca-${var.env}-instance-1", { "period": 60 } ],
                    [ "...", "notification-canada-ca-${var.env}-instance-0", { "period": 60 } ],
                    [ "...", "notification-canada-ca-${var.env}-instance-2", { "period": 60 } ]
                ],
                "region": "ca-central-1",
                "title": "Commit Latency Per Instance"
            }
        },
        {
            "type": "text",
            "x": 0,
            "y": 34,
            "width": 24,
            "height": 1,
            "properties": {
                "markdown": "# Queues"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 35,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/SQS", "ApproximateAgeOfOldestMessage", "QueueName", "eks-notification-canada-ca-normal-database-tasks" ],
                    [ "...", "eks-notification-canada-ca-bulk-database-tasks" ],
                    [ "...", "eks-notification-canada-ca-priority-database-tasks.fifo" ]
                ],
                "region": "ca-central-1",
                "title": "Approximate Age Of Oldest Message"
            }
        },
        {
            "type": "metric",
            "x": 6,
            "y": 35,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/SQS", "ApproximateNumberOfMessagesVisible", "QueueName", "eks-notification-canada-ca-bulk-database-tasks" ],
                    [ "...", "eks-notification-canada-ca-priority-database-tasks.fifo" ],
                    [ "...", "eks-notification-canada-ca-normal-database-tasks" ]
                ],
                "region": "ca-central-1",
                "title": "Approximate Number Of Messages Visible"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 55,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "ContainerInsights/Prometheus", "kube_deployment_status_replicas_ready", "namespace", "notification-canada-ca", "ClusterName", "notification-canada-ca-${var.env}-eks-cluster", "deployment", "notify-celery-sms-send-scalable" ],
                    [ "...", "notify-celery-core-tasks-static" ],
                    [ "...", "notify-celery-email-send-scalable" ],
                    [ "...", "notify-celery-email-send-static" ],
                    [ "...", "notify-celery-generate-reports-static" ],
                    [ "...", "notify-celery-beat" ],
                    [ "...", "notify-celery-delivery-receipts-scalable" ],
                    [ "...", "notify-celery-sms-send-static" ],
                    [ "...", "notify-celery-core-tasks-scalable" ],
                    [ "...", "notify-celery-sms-dedicated-static" ]
                ],
                "region": "ca-central-1",
                "title": "Celery Deployments"
            }
        },
        {
            "type": "text",
            "x": 0,
            "y": 41,
            "width": 24,
            "height": 1,
            "properties": {
                "markdown": "# Kubernetes"
            }
        },
        {
            "type": "text",
            "x": 0,
            "y": 54,
            "width": 24,
            "height": 1,
            "properties": {
                "markdown": "## Celery"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 42,
            "width": 12,
            "height": 6,
            "properties": {
                "metrics": [
                    [ { "id": "expr1m0", "label": "notification-canada-ca-${var.env}-eks-cluster", "period": 60, "expression": "(mm1m0 + mm1farm0) * 100 / (mm0m0 + mm0farm0)", "region": "ca-central-1" } ],
                    [ "ContainerInsights", "node_cpu_limit", "ClusterName", "notification-canada-ca-${var.env}-eks-cluster", { "period": 60, "stat": "Sum", "id": "mm0m0", "visible": false, "region": "ca-central-1" } ],
                    [ ".", "node_cpu_usage_total", ".", ".", { "period": 60, "stat": "Sum", "id": "mm1m0", "visible": false, "region": "ca-central-1" } ],
                    [ ".", "pod_cpu_limit", ".", ".", "LaunchType", "fargate", { "period": 60, "stat": "Sum", "id": "mm0farm0", "visible": false, "region": "ca-central-1" } ],
                    [ ".", "pod_cpu_usage_total", ".", ".", ".", ".", { "period": 60, "stat": "Sum", "id": "mm1farm0", "visible": false, "region": "ca-central-1" } ]
                ],
                "legend": {
                    "position": "hidden"
                },
                "title": "Kubernetes Cluster CPU Usage",
                "yAxis": {
                    "left": {
                        "min": 0,
                        "showUnits": false,
                        "label": "Percent"
                    }
                },
                "region": "ca-central-1",
                "liveData": false,
                "period": 60,
                "timezone": "UTC",
                "view": "timeSeries",
                "stacked": false
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 42,
            "width": 12,
            "height": 6,
            "properties": {
                "metrics": [
                    [ { "id": "expr1m0", "label": "notification-canada-ca-${var.env}-eks-cluster", "period": 60, "expression": "(mm1m0 + mm1farm0) * 100 / (mm0m0 + mm0farm0)", "region": "ca-central-1" } ],
                    [ "ContainerInsights", "node_memory_limit", "ClusterName", "notification-canada-ca-${var.env}-eks-cluster", { "period": 60, "stat": "Sum", "id": "mm0m0", "visible": false, "region": "ca-central-1" } ],
                    [ ".", "pod_memory_limit", ".", ".", "LaunchType", "fargate", { "period": 60, "stat": "Sum", "id": "mm0farm0", "visible": false, "region": "ca-central-1" } ],
                    [ ".", "node_memory_working_set", ".", ".", { "period": 60, "stat": "Sum", "id": "mm1m0", "visible": false, "region": "ca-central-1" } ],
                    [ ".", "pod_memory_working_set", ".", ".", "LaunchType", "fargate", { "period": 60, "stat": "Sum", "id": "mm1farm0", "visible": false, "region": "ca-central-1" } ]
                ],
                "legend": {
                    "position": "hidden"
                },
                "title": "EKS Cluster Memory Usage",
                "yAxis": {
                    "left": {
                        "min": 0,
                        "showUnits": false,
                        "label": "Percent"
                    }
                },
                "region": "ca-central-1",
                "liveData": false,
                "period": 60,
                "timezone": "UTC",
                "view": "timeSeries",
                "stacked": false
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 48,
            "width": 6,
            "height": 6,
            "properties": {
                "metrics": [
                    [ { "id": "expr1m0", "label": "notification-canada-ca-${var.env}-eks-cluster", "period": 60, "expression": "mm0m0 + mm0farm0" } ],
                    [ "ContainerInsights", "pod_network_rx_bytes", "ClusterName", "notification-canada-ca-${var.env}-eks-cluster", { "period": 60, "stat": "Average", "id": "mm0m0", "visible": false } ],
                    [ "ContainerInsights", "pod_network_rx_bytes", "ClusterName", "notification-canada-ca-${var.env}-eks-cluster", "LaunchType", "fargate", { "period": 60, "stat": "Average", "id": "mm0farm0", "visible": false } ]
                ],
                "legend": {
                    "position": "bottom"
                },
                "title": "EKS Cluster Network RX",
                "yAxis": {
                    "left": {
                        "showUnits": false,
                        "label": "Bytes/Second"
                    }
                },
                "region": "ca-central-1",
                "liveData": false,
                "period": 60,
                "timezone": "UTC",
                "view": "timeSeries",
                "stacked": false
            }
        },
        {
            "type": "metric",
            "x": 6,
            "y": 48,
            "width": 6,
            "height": 6,
            "properties": {
                "metrics": [
                    [ { "id": "expr1m0", "label": "notification-canada-ca-${var.env}-eks-cluster", "period": 60, "expression": "mm0m0 + mm0farm0" } ],
                    [ "ContainerInsights", "pod_network_tx_bytes", "ClusterName", "notification-canada-ca-${var.env}-eks-cluster", { "period": 60, "stat": "Average", "id": "mm0m0", "visible": false } ],
                    [ "ContainerInsights", "pod_network_tx_bytes", "ClusterName", "notification-canada-ca-${var.env}-eks-cluster", "LaunchType", "fargate", { "period": 60, "stat": "Average", "id": "mm0farm0", "visible": false } ]
                ],
                "legend": {
                    "position": "bottom"
                },
                "title": "EKS Cluster Network TX",
                "yAxis": {
                    "left": {
                        "showUnits": false,
                        "label": "Bytes/Second"
                    }
                },
                "region": "ca-central-1",
                "liveData": false,
                "period": 60,
                "timezone": "UTC",
                "view": "timeSeries",
                "stacked": false
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 48,
            "width": 6,
            "height": 6,
            "properties": {
                "metrics": [
                    [ { "id": "expr1m0", "label": "notification-canada-ca-${var.env}-eks-cluster", "period": 60, "expression": "mm0m0", "region": "ca-central-1" } ],
                    [ "ContainerInsights", "cluster_node_count", "ClusterName", "notification-canada-ca-${var.env}-eks-cluster", { "period": 60, "stat": "Average", "id": "mm0m0", "visible": false, "region": "ca-central-1" } ]
                ],
                "legend": {
                    "position": "bottom"
                },
                "title": "EKS Cluster Node Count",
                "yAxis": {
                    "left": {
                        "showUnits": false,
                        "label": "Count",
                        "min": 0
                    }
                },
                "region": "ca-central-1",
                "liveData": false,
                "period": 60,
                "timezone": "UTC",
                "view": "timeSeries",
                "stacked": false
            }
        },
        {
            "type": "metric",
            "x": 6,
            "y": 55,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "metrics": [
                    [ "ContainerInsights", "pod_cpu_utilization", "PodName", "notify-celery-sms-send-scalable", "ClusterName", "notification-canada-ca-${var.env}-eks-cluster", "Namespace", "notification-canada-ca" ],
                    [ "...", "notify-celery-core-tasks-static", ".", ".", ".", "." ],
                    [ "...", "notify-celery-email-send-static", ".", ".", ".", "." ],
                    [ "...", "notify-celery-sms-dedicated-static", ".", ".", ".", "." ],
                    [ "...", "notify-celery-delivery-receipts-scalable", ".", ".", ".", "." ],
                    [ "...", "notify-celery-email-send-scalable", ".", ".", ".", "." ],
                    [ "...", "notify-celery-beat", ".", ".", ".", "." ],
                    [ "...", "notify-celery-generate-reports-static", ".", ".", ".", "." ],
                    [ "...", "notify-celery-sms-send-static", ".", ".", ".", "." ],
                    [ "...", "notify-celery-core-tasks-scalable", ".", ".", ".", "." ]
                ],
                "title": "Celery CPU Utilization"
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 55,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "metrics": [
                    [ "ContainerInsights", "pod_memory_utilization", "PodName", "notify-celery-beat", "ClusterName", "notification-canada-ca-${var.env}-eks-cluster", "Namespace", "notification-canada-ca" ],
                    [ "...", "notify-celery-email-send-static", ".", ".", ".", "." ],
                    [ "...", "notify-celery-sms-dedicated-static", ".", ".", ".", "." ],
                    [ "...", "notify-celery-core-tasks-static", ".", ".", ".", "." ],
                    [ "...", "notify-celery-generate-reports-static", ".", ".", ".", "." ],
                    [ "...", "notify-celery-email-send-scalable", ".", ".", ".", "." ],
                    [ "...", "notify-celery-delivery-receipts-scalable", ".", ".", ".", "." ],
                    [ "...", "notify-celery-sms-send-scalable", ".", ".", ".", "." ],
                    [ "...", "notify-celery-core-tasks-scalable", ".", ".", ".", "." ],
                    [ "...", "notify-celery-sms-send-static", ".", ".", ".", "." ]
                ],
                "title": "Celery Memory Usage"
            }
        },
        {
            "type": "metric",
            "x": 6,
            "y": 61,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "metrics": [
                    [ "ContainerInsights", "pod_network_tx_bytes", "PodName", "notify-celery-delivery-receipts-scalable", "ClusterName", "notification-canada-ca-${var.env}-eks-cluster", "Namespace", "notification-canada-ca" ],
                    [ "...", "notify-celery-sms-send-static", ".", ".", ".", "." ],
                    [ "...", "notify-celery-core-tasks-static", ".", ".", ".", "." ],
                    [ "...", "notify-celery-beat", ".", ".", ".", "." ],
                    [ "...", "notify-celery-generate-reports-static", ".", ".", ".", "." ],
                    [ "...", "notify-celery-email-send-scalable", ".", ".", ".", "." ],
                    [ "...", "notify-celery-sms-dedicated-static", ".", ".", ".", "." ],
                    [ "...", "notify-celery-sms-send-scalable", ".", ".", ".", "." ],
                    [ "...", "notify-celery-core-tasks-scalable", ".", ".", ".", "." ],
                    [ "...", "notify-celery-email-send-static", ".", ".", ".", "." ]
                ],
                "title": "Celery Network TX Bytes"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 61,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "metrics": [
                    [ "ContainerInsights", "pod_network_rx_bytes", "PodName", "notify-celery-sms-send-scalable", "ClusterName", "notification-canada-ca-${var.env}-eks-cluster", "Namespace", "notification-canada-ca" ],
                    [ "...", "notify-celery-email-send-scalable", ".", ".", ".", "." ],
                    [ "...", "notify-celery-delivery-receipts-scalable", ".", ".", ".", "." ],
                    [ "...", "notify-celery-generate-reports-static", ".", ".", ".", "." ],
                    [ "...", "notify-celery-beat", ".", ".", ".", "." ],
                    [ "...", "notify-celery-core-tasks-static", ".", ".", ".", "." ],
                    [ "...", "notify-celery-sms-send-static", ".", ".", ".", "." ],
                    [ "...", "notify-celery-email-send-static", ".", ".", ".", "." ],
                    [ "...", "notify-celery-core-tasks-scalable", ".", ".", ".", "." ],
                    [ "...", "notify-celery-sms-dedicated-static", ".", ".", ".", "." ]
                ],
                "title": "Celery Network RX Bytes"
            }
        },
        {
            "type": "metric",
            "x": 6,
            "y": 68,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "metrics": [
                    [ "ContainerInsights", "pod_cpu_utilization", "PodName", "notify-admin", "ClusterName", "notification-canada-ca-${var.env}-eks-cluster", "Namespace", "notification-canada-ca", { "region": "ca-central-1" } ]
                ],
                "title": "Admin CPU Utilization",
                "period": 300,
                "legend": {
                    "position": "hidden"
                }
            }
        },
        {
            "type": "text",
            "x": 0,
            "y": 67,
            "width": 24,
            "height": 1,
            "properties": {
                "markdown": "## Admin"
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 68,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "metrics": [
                    [ "ContainerInsights", "pod_memory_utilization", "PodName", "notify-admin", "ClusterName", "notification-canada-ca-${var.env}-eks-cluster", "Namespace", "notification-canada-ca", { "region": "ca-central-1" } ]
                ],
                "title": "Admin Memory Utilization",
                "period": 300,
                "legend": {
                    "position": "hidden"
                }
            }
        },
        {
            "type": "metric",
            "x": 6,
            "y": 74,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "metrics": [
                    [ "ContainerInsights", "pod_network_tx_bytes", "PodName", "notify-admin", "ClusterName", "notification-canada-ca-${var.env}-eks-cluster", "Namespace", "notification-canada-ca", { "region": "ca-central-1" } ]
                ],
                "title": "Admin Network TX Bytes",
                "period": 300,
                "legend": {
                    "position": "hidden"
                }
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 74,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "metrics": [
                    [ "ContainerInsights", "pod_network_rx_bytes", "PodName", "notify-admin", "ClusterName", "notification-canada-ca-${var.env}-eks-cluster", "Namespace", "notification-canada-ca", { "region": "ca-central-1" } ]
                ],
                "title": "Admin Network RX Bytes",
                "period": 300,
                "legend": {
                    "position": "hidden"
                }
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 68,
            "width": 6,
            "height": 6,
            "properties": {
                "metrics": [
                    [ "ContainerInsights/Prometheus", "kube_deployment_status_replicas_available", "namespace", "notification-canada-ca", "ClusterName", "notification-canada-ca-${var.env}-eks-cluster", "deployment", "notify-admin", { "region": "ca-central-1" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "Maximum",
                "period": 300,
                "title": "Admin Deployments",
                "yAxis": {
                    "left": {
                        "min": 0
                    }
                },
                "legend": {
                    "position": "hidden"
                }
            }
        },
        {
            "type": "text",
            "x": 0,
            "y": 80,
            "width": 24,
            "height": 1,
            "properties": {
                "markdown": "## API (Kubernetes)"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 81,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "Maximum",
                "period": 300,
                "metrics": [
                    [ "ContainerInsights/Prometheus", "kube_deployment_status_replicas_available", "namespace", "notification-canada-ca", "ClusterName", "notification-canada-ca-${var.env}-eks-cluster", "deployment", "notify-api", { "region": "ca-central-1" } ]
                ],
                "title": "API Deployments",
                "legend": {
                    "position": "hidden"
                }
            }
        },
        {
            "type": "metric",
            "x": 6,
            "y": 81,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "Maximum",
                "period": 300,
                "metrics": [
                    [ "ContainerInsights", "pod_cpu_utilization", "PodName", "notify-api", "ClusterName", "notification-canada-ca-${var.env}-eks-cluster", "Namespace", "notification-canada-ca" ]
                ],
                "legend": {
                    "position": "hidden"
                },
                "title": "API CPU Utilization"
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 74,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "Maximum",
                "period": 300,
                "legend": {
                    "position": "hidden"
                },
                "metrics": [
                    [ "ContainerInsights", "pod_memory_utilization", "PodName", "notify-api", "ClusterName", "notification-canada-ca-${var.env}-eks-cluster", "Namespace", "notification-canada-ca" ]
                ],
                "title": "API Memory Utilization"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 87,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "Maximum",
                "period": 300,
                "legend": {
                    "position": "hidden"
                },
                "metrics": [
                    [ "ContainerInsights", "pod_network_rx_bytes", "PodName", "notify-api", "ClusterName", "notification-canada-ca-${var.env}-eks-cluster", "Namespace", "notification-canada-ca" ]
                ],
                "title": "API Network RX Bytes"
            }
        },
        {
            "type": "metric",
            "x": 6,
            "y": 87,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "Maximum",
                "period": 300,
                "legend": {
                    "position": "hidden"
                },
                "metrics": [
                    [ "ContainerInsights", "pod_network_tx_bytes", "PodName", "notify-api", "ClusterName", "notification-canada-ca-${var.env}-eks-cluster", "Namespace", "notification-canada-ca" ]
                ],
                "title": "API Network TX Bytes"
            }
        },
        {
            "type": "text",
            "x": 0,
            "y": 93,
            "width": 24,
            "height": 1,
            "properties": {
                "markdown": "# API Lambda"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 94,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "Maximum",
                "period": 300,
                "legend": {
                    "position": "hidden"
                },
                "metrics": [
                    [ "AWS/Lambda", "ConcurrentExecutions", "FunctionName", "api-lambda" ]
                ],
                "title": "API Lambda Concurrent Executions"
            }
        },
        {
            "type": "metric",
            "x": 6,
            "y": 94,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "Maximum",
                "period": 300,
                "legend": {
                    "position": "hidden"
                },
                "metrics": [
                    [ "AWS/Lambda", "Duration", "FunctionName", "api-lambda" ]
                ],
                "title": "API Lambda Request Duration"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 100,
            "width": 6,
            "height": 6,
            "properties": {
                "metrics": [
                    [ "AWS/Lambda", "Throttles", "FunctionName", "api-lambda", { "region": "ca-central-1", "color": "#fe6e73" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "Maximum",
                "period": 300,
                "legend": {
                    "position": "hidden"
                },
                "title": "API Lambda Throttles"
            }
        },
        {
            "type": "metric",
            "x": 6,
            "y": 100,
            "width": 6,
            "height": 6,
            "properties": {
                "metrics": [
                    [ "AWS/Lambda", "Errors", "FunctionName", "api-lambda", { "region": "ca-central-1", "color": "#fe6e73" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "Maximum",
                "period": 300,
                "legend": {
                    "position": "hidden"
                },
                "title": "API Lambda Errors"
            }
        },
        {
            "type": "text",
            "x": 0,
            "y": 106,
            "width": 24,
            "height": 1,
            "properties": {
                "markdown": "# Elasticache (Valkey)"
            }
        },
        {
            "type": "text",
            "x": 0,
            "y": 107,
            "width": 24,
            "height": 1,
            "properties": {
                "markdown": "## Admin Cache (Usage Stats)"
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 108,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/ElastiCache", "MemoryFragmentationRatio", "CacheClusterId", "notify-${var.env}-cluster-cache-az-001" ],
                    [ "...", "notify-${var.env}-cluster-cache-az-002" ],
                    [ "...", "notify-${var.env}-cluster-cache-az-003" ]
                ],
                "region": "ca-central-1",
                "title": "Memory Fragmentation"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 108,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/ElastiCache", "CPUUtilization", "CacheClusterId", "notify-${var.env}-cluster-cache-az-001", "CacheNodeId", "0001", { "region": "ca-central-1" } ],
                    [ ".", ".", ".", "notify-${var.env}-cluster-cache-az-002" ],
                    [ "...", "notify-${var.env}-cluster-cache-az-003" ]
                ],
                "region": "ca-central-1",
                "title": "CPU Utilization",
                "period": 300
            }
        },
        {
            "type": "metric",
            "x": 6,
            "y": 108,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/ElastiCache", "DatabaseMemoryUsagePercentage", "CacheClusterId", "notify-${var.env}-cluster-cache-az-003" ],
                    [ "...", "notify-${var.env}-cluster-cache-az-002" ],
                    [ "...", "notify-${var.env}-cluster-cache-az-001" ]
                ],
                "region": "ca-central-1",
                "title": "Database Memory Usage"
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 108,
            "width": 6,
            "height": 6,
            "properties": {
                "metrics": [
                    [ "AWS/ElastiCache", "CurrConnections", "CacheClusterId", "notify-${var.env}-cluster-cache-az-001" ],
                    [ "...", "notify-${var.env}-cluster-cache-az-003" ],
                    [ "...", "notify-${var.env}-cluster-cache-az-002" ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "title": "Connections",
                "period": 300,
                "stat": "Average"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 114,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/ElastiCache", "BytesUsedForCache", "CacheClusterId", "notify-${var.env}-cluster-cache-az-003" ],
                    [ "...", "notify-${var.env}-cluster-cache-az-002" ],
                    [ "...", "notify-${var.env}-cluster-cache-az-001" ]
                ],
                "region": "ca-central-1",
                "title": "Total Cache Usage Bytes"
            }
        },
        {
            "type": "text",
            "x": 0,
            "y": 120,
            "width": 24,
            "height": 1,
            "properties": {
                "markdown": "## Ops Cache (Messages)"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 121,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/ElastiCache", "CPUUtilization", "CacheClusterId", "notify-${var.env}-queue-cache-003" ],
                    [ "...", "notify-${var.env}-queue-cache-001" ],
                    [ "...", "notify-${var.env}-queue-cache-002" ]
                ],
                "region": "ca-central-1",
                "title": "CPU Utilization"
            }
        },
        {
            "type": "metric",
            "x": 6,
            "y": 121,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/ElastiCache", "DatabaseMemoryUsagePercentage", "CacheClusterId", "notify-${var.env}-queue-cache-001" ],
                    [ "...", "notify-${var.env}-queue-cache-003" ],
                    [ "...", "notify-${var.env}-queue-cache-002" ]
                ],
                "region": "ca-central-1",
                "title": "Database Memory Usage"
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 121,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/ElastiCache", "MemoryFragmentationRatio", "CacheClusterId", "notify-${var.env}-queue-cache-002" ],
                    [ "...", "notify-${var.env}-queue-cache-001" ],
                    [ "...", "notify-${var.env}-queue-cache-003" ]
                ],
                "region": "ca-central-1",
                "title": "Memory Fragmentation"
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 121,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/ElastiCache", "CurrConnections", "CacheClusterId", "notify-${var.env}-queue-cache-002" ],
                    [ "...", "notify-${var.env}-queue-cache-001" ],
                    [ "...", "notify-${var.env}-queue-cache-003" ]
                ],
                "region": "ca-central-1",
                "title": "Connections"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 127,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/ElastiCache", "BytesUsedForCache", "CacheClusterId", "notify-${var.env}-queue-cache-003" ],
                    [ "...", "notify-${var.env}-queue-cache-002" ],
                    [ "...", "notify-${var.env}-queue-cache-001" ]
                ],
                "region": "ca-central-1",
                "title": "Total Cache Usage Bytes"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 1,
            "width": 12,
            "height": 6,
            "properties": {
                "metrics": [
                    [ { "expression": "FILL(METRICS(), 0)", "label": "emails /", "id": "e1", "region": "ca-central-1" } ],
                    [ "AWS/SES", "Send", { "region": "ca-central-1", "id": "m1", "color": "#08aad2", "visible": false, "label": "min" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "period": 60,
                "stat": "Sum",
                "title": "Email Send Rate Per Minute",
                "legend": {
                    "position": "hidden"
                },
                "liveData": false,
                "sparkline": true
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 1,
            "width": 6,
            "height": 6,
            "properties": {
                "metrics": [
                    [ { "expression": "FILL(METRICS(), 0)", "label": "SMS /", "id": "e1", "region": "ca-central-1" } ],
                    [ "AWS/SNS", "NumberOfNotificationsDelivered", "PhoneNumber", "PhoneNumberDirect", { "region": "ca-central-1", "color": "#08aad2", "id": "m1", "visible": false, "label": "min" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "period": 60,
                "stat": "Sum",
                "title": "SNS/SMS Send Rate Per Minute",
                "legend": {
                    "position": "hidden"
                },
                "sparkline": true
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 1,
            "width": 6,
            "height": 6,
            "properties": {
                "metrics": [
                    [ { "expression": "FILL(METRICS(), 0)", "label": "Pinpoint /", "id": "e1", "region": "ca-central-1", "period": 60 } ],
                    [ "LogMetrics", "pinpoint-sms-successes", { "region": "ca-central-1", "label": "min", "id": "m1", "visible": false } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "Sum",
                "period": 60,
                "title": "Pinpoint Send Rate Per Minute",
                "sparkline": true
            }
        },
        {
            "type": "text",
            "x": 0,
            "y": 0,
            "width": 24,
            "height": 1,
            "properties": {
                "markdown": "# Send Rates"
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 81,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/ApiGateway", "Latency", "ApiName", "api-lambda" ]
                ],
                "region": "ca-central-1",
                "title": "API Gateway Latency"
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 68,
            "width": 6,
            "height": 6,
            "properties": {
                "metrics": [
                    [ { "expression": "AVG(METRICS())", "label": "Average Response Time", "id": "e1" } ],
                    [ "AWS/ApplicationELB", "TargetResponseTime", "TargetGroup", "targetgroup/notification-canada-ca-alb-admin/7b55c66402cf0ba9", "AvailabilityZone", "ca-central-1d", "LoadBalancer", "app/notification-${var.env}-alb/a88ef289ed9dd41e", { "id": "m1", "visible": false } ],
                    [ "...", "ca-central-1a", ".", ".", { "id": "m2", "visible": false } ],
                    [ "...", "ca-central-1b", ".", ".", { "id": "m3", "visible": false } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "Average",
                "period": 300,
                "yAxis": {
                    "left": {
                        "label": "Seconds",
                        "showUnits": false
                    }
                },
                "title": "Admin Average Response Time"
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 81,
            "width": 6,
            "height": 6,
            "properties": {
                "metrics": [
                    [ { "expression": "AVG(METRICS())", "label": "Average Response Time", "id": "e1" } ],
                    [ "AWS/ApplicationELB", "TargetResponseTime", "TargetGroup", "targetgroup/notification-canada-ca-alb-api/2d9017625dea5cd0", "AvailabilityZone", "ca-central-1d", "LoadBalancer", "app/notification-${var.env}-alb/a88ef289ed9dd41e", { "id": "m1", "visible": false } ],
                    [ "...", "ca-central-1b", ".", ".", { "id": "m2", "visible": false } ],
                    [ "...", "ca-central-1a", ".", ".", { "id": "m3", "visible": false } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "ca-central-1",
                "stat": "Average",
                "period": 300,
                "yAxis": {
                    "left": {
                        "label": "Seconds",
                        "showUnits": false
                    }
                },
                "title": "Average Response Time"
            }
        }
    ]
}
EOF
}
