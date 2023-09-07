resource "aws_cloudwatch_dashboard" "elb" {
  count          = var.cloudwatch_enabled ? 1 : 0
  dashboard_name = "Elastic-Load-Balancers"
  dashboard_body = <<EOF
{
    "widgets": [
        {
            "height": 5,
            "width": 8,
            "y": 0,
            "x": 0,
            "type": "metric",
            "properties": {
                "region": "${var.region}",
                "metrics": [
                    [ "AWS/ApplicationELB", "RequestCount", "LoadBalancer", "${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "Sum", "id": "m0r0" } ]
                ],
                "title": "Request Count Sum",
                "copilot": true,
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "height": 5,
            "width": 8,
            "y": 0,
            "x": 8,
            "type": "metric",
            "properties": {
                "region": "${var.region}",
                "metrics": [
                    [ "AWS/ApplicationELB", "HTTPCode_ELB_5XX_Count", "LoadBalancer", "${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "Sum", "id": "m0r0" } ]
                ],
                "title": "HTTP 5XX Count",
                "copilot": true,
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "height": 5,
            "width": 8,
            "y": 0,
            "x": 16,
            "type": "metric",
            "properties": {
                "region": "${var.region}",
                "metrics": [
                    [ "AWS/ApplicationELB", "ActiveConnectionCount", "LoadBalancer", "${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "Sum", "id": "m0r0" } ]
                ],
                "title": "Active Connection Count Sum",
                "copilot": true,
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "height": 5,
            "width": 8,
            "y": 5,
            "x": 0,
            "type": "metric",
            "properties": {
                "region": "${var.region}",
                "metrics": [
                    [ "AWS/ApplicationELB", "ClientTLSNegotiationErrorCount", "LoadBalancer", "${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "Sum", "id": "m0r0" } ]
                ],
                "title": "Client TLS Negotiation Error Count Sum",
                "copilot": true,
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "height": 5,
            "width": 8,
            "y": 5,
            "x": 8,
            "type": "metric",
            "properties": {
                "region": "${var.region}",
                "metrics": [
                    [ "AWS/ApplicationELB", "ConsumedLCUs", "LoadBalancer", "${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "Average", "id": "m0r0" } ]
                ],
                "title": "Consumed LC Us Average",
                "copilot": true,
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "height": 5,
            "width": 8,
            "y": 5,
            "x": 16,
            "type": "metric",
            "properties": {
                "region": "${var.region}",
                "metrics": [
                    [ "AWS/ApplicationELB", "HTTP_Fixed_Response_Count", "LoadBalancer", "${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "Sum", "id": "m0r0" } ]
                ],
                "title": "HTTP Fixed Response Count Sum",
                "copilot": true,
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "height": 5,
            "width": 8,
            "y": 10,
            "x": 0,
            "type": "metric",
            "properties": {
                "region": "${var.region}",
                "metrics": [
                    [ "AWS/ApplicationELB", "HTTP_Redirect_Count", "LoadBalancer", "${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "Sum", "id": "m0r0" } ]
                ],
                "title": "HTTP Redirect Count Sum",
                "copilot": true,
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "height": 5,
            "width": 8,
            "y": 10,
            "x": 8,
            "type": "metric",
            "properties": {
                "region": "${var.region}",
                "metrics": [
                    [ "AWS/ApplicationELB", "HTTP_Redirect_Url_Limit_Exceeded_Count", "LoadBalancer", "${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "Sum", "id": "m0r0" } ]
                ],
                "title": "HTTP Redirect Url Limit Exceeded Count Sum",
                "copilot": true,
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "height": 5,
            "width": 8,
            "y": 10,
            "x": 16,
            "type": "metric",
            "properties": {
                "region": "${var.region}",
                "metrics": [
                    [ "AWS/ApplicationELB", "HTTPCode_ELB_3XX_Count", "LoadBalancer", "${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "Sum", "id": "m0r0" } ]
                ],
                "title": "HTTP Code ELB 3 XX Count Sum",
                "copilot": true,
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "height": 5,
            "width": 8,
            "y": 15,
            "x": 0,
            "type": "metric",
            "properties": {
                "region": "${var.region}",
                "metrics": [
                    [ "AWS/ApplicationELB", "HTTPCode_ELB_4XX_Count", "LoadBalancer", "${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "Sum", "id": "m0r0" } ]
                ],
                "title": "HTTP 4XX Count",
                "copilot": true,
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "height": 5,
            "width": 8,
            "y": 15,
            "x": 8,
            "type": "metric",
            "properties": {
                "region": "${var.region}",
                "metrics": [
                    [ "AWS/ApplicationELB", "IPv6ProcessedBytes", "LoadBalancer", "${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "Sum", "id": "m0r0" } ]
                ],
                "title": "I Pv 6 Processed Bytes Sum",
                "copilot": true,
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "height": 5,
            "width": 8,
            "y": 15,
            "x": 16,
            "type": "metric",
            "properties": {
                "region": "${var.region}",
                "metrics": [
                    [ "AWS/ApplicationELB", "IPv6RequestCount", "LoadBalancer", "${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "Sum", "id": "m0r0" } ]
                ],
                "title": "I Pv 6 Request Count Sum",
                "copilot": true,
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "height": 5,
            "width": 8,
            "y": 20,
            "x": 0,
            "type": "metric",
            "properties": {
                "region": "${var.region}",
                "metrics": [
                    [ "AWS/ApplicationELB", "NewConnectionCount", "LoadBalancer", "${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "Sum", "id": "m0r0" } ]
                ],
                "title": "New Connection Count Sum",
                "copilot": true,
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "height": 5,
            "width": 8,
            "y": 20,
            "x": 8,
            "type": "metric",
            "properties": {
                "region": "${var.region}",
                "metrics": [
                    [ "AWS/ApplicationELB", "ProcessedBytes", "LoadBalancer", "${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "Sum", "id": "m0r0" } ]
                ],
                "title": "Processed Bytes Sum",
                "copilot": true,
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "height": 5,
            "width": 8,
            "y": 20,
            "x": 16,
            "type": "metric",
            "properties": {
                "region": "${var.region}",
                "metrics": [
                    [ "AWS/ApplicationELB", "RejectedConnectionCount", "LoadBalancer", "${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "Sum", "id": "m0r0" } ]
                ],
                "title": "Rejected Connection Count Sum",
                "copilot": true,
                "legend": {
                    "position": "bottom"
                }
            }
        },
        {
            "height": 5,
            "width": 24,
            "y": 25,
            "x": 0,
            "type": "metric",
            "properties": {
                "region": "${var.region}",
                "metrics": [
                    [ "AWS/ApplicationELB", "RuleEvaluations", "LoadBalancer", "${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "Sum", "id": "m0r0" } ]
                ],
                "title": "Rule Evaluations Sum",
                "copilot": true,
                "legend": {
                    "position": "bottom"
                }
            }
        }
    ]
}
EOF
}

resource "aws_cloudwatch_dashboard" "errors" {
  count          = var.cloudwatch_enabled ? 1 : 0
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
                "query": "SOURCE '/aws/containerinsights/${aws_eks_cluster.notification-canada-ca-eks-cluster.name}/application' | fields @timestamp, log, kubernetes.labels.app as app, kubernetes.pod_name as pod_name, @logStream\n| filter kubernetes.labels.app like /admin|api/\n| filter strcontains(@message, 'HTTP/1.1\\\" 500')\n| sort @timestamp desc\n| limit 20",
                "region": "${var.region}",
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
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:logs-1-500-error-1-minute-warning",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:logs-1-celery-error-1-minute-warning",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:logs-10-500-error-5-minutes-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:logs-10-celery-error-1-minute-critical",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:logs-1-error-1-minute-warning-lambda-api",
                    "arn:aws:cloudwatch:${var.region}:${var.account_id}:alarm:logs-10-error-5-minutes-critical-lambda-api"
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
                "query": "SOURCE '/aws/containerinsights/${aws_eks_cluster.notification-canada-ca-eks-cluster.name}/application' | fields @timestamp, log, kubernetes.labels.app as app, kubernetes.pod_name as pod_name, @logStream\n| filter kubernetes.labels.app like /^celery/\n| filter @message like /ERROR\\/.*Worker/\n| sort @timestamp desc\n| limit 20\n",
                "region": "${var.region}",
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
                "query": "SOURCE '/aws/containerinsights/${aws_eks_cluster.notification-canada-ca-eks-cluster.name}/application' | SOURCE '/aws/lambda/api-lambda' | filter (ispresent(application) or ispresent(kubernetes.host)) and @message like /has been rate limited/\n| parse @message /service (?<service>.*?) has been rate limited for (?<limit_type>..........).*/\n| stats count(*) by service, limit_type\n",
                "region": "${var.region}",
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
  count          = var.cloudwatch_enabled ? 1 : 0
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
                "region": "${var.region}"
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
                    [ "ContainerInsights", "pod_memory_utilization_over_pod_limit", "PodName", "admin", "ClusterName", "${aws_eks_cluster.notification-canada-ca-eks-cluster.name}", "Namespace", "notification-canada-ca" ],
                    [ "...", "api", ".", ".", ".", "." ],
                    [ "...", "celery", ".", ".", ".", "." ],
                    [ "...", "document-download-api", ".", ".", ".", "." ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
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
                    [ "ContainerInsights", "pod_cpu_utilization", "ClusterName", "${aws_eks_cluster.notification-canada-ca-eks-cluster.name}", "Service", "api", "Namespace", "notification-canada-ca", { "yAxis": "right", "stat": "Average" } ],
                    [ "...", "celery", ".", ".", { "yAxis": "right", "stat": "Average" } ],
                    [ "...", "admin", ".", ".", { "stat": "Average", "yAxis": "right" } ],
                    [ ".", "service_number_of_running_pods", ".", ".", ".", "celery", ".", ".", { "yAxis": "left" } ],
                    [ "...", "api", ".", ".", { "yAxis": "left" } ],
                    [ "...", "admin", ".", "." ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
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
  count          = var.cloudwatch_enabled ? 1 : 0
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
                    [ { "expression": "100 - FILL(admin_errors,0)/FILL(admin_requests, 1)*100", "label": "Success rate", "id": "e1", "period": 86400, "stat": "Sum", "color": "#1f77b4", "region": "${var.region}" } ],
                    [ "AWS/ApplicationELB", "HTTPCode_Target_5XX_Count", "TargetGroup", "targetgroup/notification-canada-ca-alb-admin/7b55c66402cf0ba9", "LoadBalancer", "${aws_alb.notification-canada-ca.arn_suffix}", { "id": "admin_errors", "visible": false } ],
                    [ ".", "RequestCount", ".", ".", ".", ".", { "id": "admin_requests", "visible": false } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
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
                    [ { "expression": "100 - 100 * m2 / m1", "label": "Success rate", "id": "e1", "region": "${var.region}", "color": "#1f77b4" } ],
                    [ "AWS/ApiGateway", "Count", "ApiName", "api-lambda", { "visible": false, "id": "m1" } ],
                    [ ".", "5XXError", ".", ".", { "id": "m2", "visible": false } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
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
                    [ "AWS/ApplicationELB", "RequestCount", "TargetGroup", "targetgroup/notification-canada-ca-alb-api/2d9017625dea5cd0", "LoadBalancer", "${aws_alb.notification-canada-ca.arn_suffix}", { "id": "m1", "visible": false } ],
                    [ ".", "HTTPCode_Target_5XX_Count", ".", ".", ".", ".", { "id": "m2", "visible": false } ],
                    [ { "expression": "100 - m2/m1*100", "label": "Success rate", "id": "e1", "period": 86400, "stat": "Sum", "color": "#1f77b4", "region": "${var.region}" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
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
                    [ "AWS/ApplicationELB", "TargetResponseTime", "TargetGroup", "targetgroup/notification-canada-ca-alb-admin/7b55c66402cf0ba9", "LoadBalancer", "${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "p90", "label": "Latency p90" } ],
                    [ "...", { "label": "Latency p99" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
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
                    [ "AWS/ApplicationELB", "TargetResponseTime", "TargetGroup", "targetgroup/notification-canada-ca-alb-admin/7b55c66402cf0ba9", "LoadBalancer", "${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "p90", "label": "Admin p90", "visible": false } ],
                    [ "...", { "label": "Admin p99", "visible": false } ],
                    [ "...", "targetgroup/notification-canada-ca-alb-api/2d9017625dea5cd0", ".", ".", { "stat": "p90", "label": "Latency p90", "color": "#1f77b4" } ],
                    [ "...", { "label": "Latency p99", "color": "#ff7f0e" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
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
                    [ "AWS/ApplicationELB", "TargetResponseTime", "TargetGroup", "targetgroup/notification-canada-ca-alb-admin/7b55c66402cf0ba9", "LoadBalancer", "${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "p90", "label": "Admin p90", "visible": false } ],
                    [ "...", { "label": "Admin p99", "visible": false } ],
                    [ "...", "targetgroup/notification-canada-ca-alb-api/2d9017625dea5cd0", ".", ".", { "stat": "p90", "label": "Api k8s p90", "visible": false } ],
                    [ "...", { "label": "Api k8s p99", "visible": false } ],
                    [ "AWS/ApiGateway", "Latency", "ApiName", "api-lambda", { "stat": "p90", "color": "#1f77b4" } ],
                    [ "...", { "color": "#ff7f0e" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
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
                "region": "${var.region}",
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

resource "aws_cloudwatch_dashboard" "slos" {
  count          = var.cloudwatch_enabled ? 1 : 0
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
                    [ { "expression": "FILL(admin_errors,0)/FILL(admin_requests, 1)*100", "label": "API error rate", "id": "e1", "period": 3600, "stat": "Sum", "color": "#d62728", "region": "${var.region}" } ],
                    [ "AWS/ApplicationELB", "HTTPCode_Target_5XX_Count", "TargetGroup", "targetgroup/notification-canada-ca-alb-admin/7b55c66402cf0ba9", "LoadBalancer", "${aws_alb.notification-canada-ca.arn_suffix}", { "id": "admin_errors", "visible": false } ],
                    [ ".", "RequestCount", ".", ".", ".", ".", { "id": "admin_requests", "visible": false } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
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
                    [ "AWS/ApplicationELB", "RequestCount", "TargetGroup", "targetgroup/notification-canada-ca-alb-api/2d9017625dea5cd0", "LoadBalancer", "${aws_alb.notification-canada-ca.arn_suffix}", { "id": "m1", "visible": false } ],
                    [ ".", "HTTPCode_Target_5XX_Count", ".", ".", ".", ".", { "id": "m2", "visible": false } ],
                    [ { "expression": "m2/m1*100", "label": "API error rate", "id": "e1", "period": 3600, "stat": "Sum", "color": "#d62728", "region": "${var.region}" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
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
                    [ { "expression": "(m2+m3)/m1*100", "label": "Load balancer error rate", "id": "e1", "color": "#d62728", "period": 3600, "region": "${var.region}" } ],
                    [ "AWS/ApplicationELB", "RequestCount", "LoadBalancer", "${aws_alb.notification-canada-ca.arn_suffix}", { "id": "m1", "visible": false } ],
                    [ ".", "HTTPCode_ELB_5XX_Count", ".", ".", { "id": "m2", "visible": false } ],
                    [ ".", "HTTPCode_Target_5XX_Count", ".", ".", { "id": "m3", "visible": false } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
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
                "region": "${var.region}",
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
                "region": "${var.region}",
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
                "region": "${var.region}",
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
                    [ "AWS/ApplicationELB", "TargetResponseTime", "TargetGroup", "targetgroup/notification-canada-ca-alb-api/2d9017625dea5cd0", "LoadBalancer", "${aws_alb.notification-canada-ca.arn_suffix}", { "stat": "p90" } ],
                    [ "..." ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
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
                    [ "AWS/ApplicationELB", "TargetResponseTime", "TargetGroup", "targetgroup/notification-canada-ca-alb-admin/7b55c66402cf0ba9", "LoadBalancer", "${aws_alb.notification-canada-ca.arn_suffix}" ],
                    [ "...", { "stat": "p99" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${var.region}",
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
                "region": "${var.region}",
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
                "region": "${var.region}",
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
                "region": "${var.region}",
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